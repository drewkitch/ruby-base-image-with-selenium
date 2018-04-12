FROM ruby:2.2.5

# install prerequisite tools
RUN apt-get update && apt-get -y upgrade && apt-get install -y --no-install-recommends \
  build-essential \
  wget \
  xvfb \
  unzip \
  zip \
  && apt-get clean

# Set up the Chrome PPA
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list
RUN apt-get update && apt-get install -y --no-install-recommends google-chrome-stable && apt-get clean

# Set up ChromeDriver
ENV CHROMEDRIVER_VERSION 2.30
ENV CHROMEDRIVER_DIR /chromedriver
RUN mkdir $CHROMEDRIVER_DIR
RUN wget -q --continue -P $CHROMEDRIVER_DIR "http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip" \
  && unzip $CHROMEDRIVER_DIR/chromedriver* -d $CHROMEDRIVER_DIR && rm $CHROMEDRIVER_DIR/chromedriver*.zip
ENV PATH $CHROMEDRIVER_DIR:$PATH

# Set up Java
# http://www.webupd8.org/2014/03/how-to-install-oracle-java-8-in-debian.html
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | tee /etc/apt/sources.list.d/webupd8team-java.list
RUN echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get update && apt-get install -y --no-install-recommends oracle-java8-installer && apt-get clean

# Set up Selenium Server
RUN wget -q --continue --output-document /selenium-server.jar "http://selenium-release.storage.googleapis.com/3.4/selenium-server-standalone-3.4.0.jar"
ENV SELENIUM_PORT 4444

COPY ./start-selenium-server.sh ./start-selenium-server.sh
ENTRYPOINT [ "./start-selenium-server.sh" ]

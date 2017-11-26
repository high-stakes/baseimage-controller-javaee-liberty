FROM "controller-java"

ARG LIBERTY_VERSION=17.0.0.3
ARG LIBERTY_SHA=528e393e0b240ebbedb91d25402e22297c6d56ec
ARG DB_DRIVER_URL=http://repo2.maven.org/maven2/com/h2database/h2/1.4.196/h2-1.4.196.jar

# Install Open Liberty
RUN apt-get update \
    && apt-get install -y --no-install-recommends unzip \
    && rm -rf /var/lib/apt/lists/*

ENV WLP_HOME /opt/ol/wlp

RUN wget https://repo1.maven.org/maven2/io/openliberty/openliberty-runtime/$LIBERTY_VERSION/openliberty-runtime-$LIBERTY_VERSION.zip -q -O /tmp/wlp.zip \
   && echo "$LIBERTY_SHA  /tmp/wlp.zip" > /tmp/wlp.zip.sha1 \
   && sha1sum -c /tmp/wlp.zip.sha1 \
   && unzip -q /tmp/wlp.zip -d /opt/ol \
   && rm /tmp/wlp.zip \
   && rm /tmp/wlp.zip.sha1 \
   && $WLP_HOME/bin/server create \
   && mkdir $WLP_HOME/etc \
   && mkdir -p $WLP_HOME/usr/shared/resources \
   && rm -rf $WLP_HOME/output/.classCache /output/workarea \
   && wget $DB_DRIVER_URL -O $WLP_HOME/usr/shared/resources/db_driver.jar -q

COPY ./jvm.options $WLP_HOME/etc/
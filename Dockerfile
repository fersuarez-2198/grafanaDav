
# Usa la imagen oficial de Grafana
FROM grafana/grafana:10.4.1


## Set Grafana options
ENV GF_ENABLE_GZIP=true
ENV GF_USERS_DEFAULT_THEME=light
# Updates Check
ENV GF_ANALYTICS_CHECK_FOR_UPDATES=false
# Establece el directorio de trabajo

WORKDIR /usr/share/grafana

# Copia el archivo JSON del dashboard
COPY my-dashboard.json /etc/grafana/provisioning/dashboards/my-dashboard.json

# Copia la configuración de provisión de dashboards
COPY dashboards.yaml /etc/grafana/provisioning/dashboards/dashboards.yaml

COPY img/fav32.png /usr/share/grafana/public/img
COPY img/fav32.png /usr/share/grafana/public/img/apple-touch-icon.png
COPY img/logo.svg /usr/share/grafana/public/img/grafana_icon.svg 
COPY img/background.svg /usr/share/grafana/public/img/g8_login_dark.svg
COPY img/background.svg /usr/share/grafana/public/img/g8_login_light.svg

# Cambia a usuario root para modificar el archivo index.html
USER root
# Modifica el archivo index.html para incluir el CSS personalizado
# Update Title
RUN rm /usr/share/grafana/public/img/g8_login_light.svg 
COPY img/background.svg /usr/share/grafana/public/img/g8_login_light.svg
COPY img/background.svg /usr/share/grafana/public/img/g8_login_dark.svg
RUN sed -i 's|<title>\[\[.AppTitle\]\]</title>|<title>Volkov Labs</title>|g' /usr/share/grafana/public/views/index.html
RUN sed -i '/<\/head>/i <link rel="stylesheet" type="text/css" href="public/css/custom.css">' /usr/share/grafana/public/views/index.html
RUN find /usr/share/grafana/public/build/ -name *.js -exec sed -i 's|"LoginTitle","Welcome to Grafana")|"LoginTitle","Insights Davivienda")|g' {} \;
RUN find /usr/share/grafana/public/build/ -name *.js -exec sed -i 's|"LoginTitle","Welcome to Grafana")|"LoginTitle","Insights Davivienda")|g' {} \;
RUN find /usr/share/grafana/public/build/ -name *.js -exec sed -i 's|LoginTitle="Welcome to Grafana"|LoginTitle="Insights Davivienda"|g' {} \;
RUN find /usr/share/grafana/public/build/ -name *.js -exec sed -i 's|AppTitle="Grafana"|AppTitle="Davivienda Insights"|g' {} \;

USER grafana
# Configura las variables de entorno
ENV GF_PANELS_DISABLE_SANITIZE_HTML=true

# Exponer el puerto que utiliza Grafana
EXPOSE 3000

# Comando para iniciar Grafana
CMD ["grafana-server", "--homepath", "/usr/share/grafana"]


load("@ytt:base64", "base64")
def init(self):
  self.team = "c21s"
  self.clusterName = "postgresql"
  self.deploymentName = "{}-{}".format(self.team, self.clusterName)
  self.user = "ccdbuser"
  self.database = "ccdb"
  self.secretName = "{user}.{team}-{clusterName}.credentials.postgresql.acid.zalan.do".format(user=self.user, team=self.team, clusterName = self.clusterName)
  self.service = "{}.{}.svc.cluster.local".format(self.deploymentName, self.namespace )
  self.port = 5432

def apply(self,k8s):
  self.__apply(k8s)
  k8s.wait(kind="Job",name="postgresql-extension-job",condition="condition=Complete", timeout=180, namespace=self.namespace, namespaced=True)

def get_db_type(self):
  return "postgres"

def get_port(self):
  return self.port

def get_service(self):
  return self.service

def get_user(self):
  return self.user

def get_password(self, k8s):
  secret = k8s.get(kind="Secret", name=self.secretName,namespaced=True, namespace=self.namespace)
  password = base64.decode(secret.data.password)
  return password

def get_database(self):
  return self.database
package "cowsay" do
  action :install
end

service "ufw" do
  action :start
end

file "/tmp/some-file" do
  content <<~EOF
    some content
  EOF
  mode "0644"
end
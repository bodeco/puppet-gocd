go_env=ENV.select{|k| k.to_s.match(/^GO/)}
go_env.each do |k, v|
  Facter.add(k){ setcode{v} }
end

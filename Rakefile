def spec_paths
  Dir.glob("StopsTests/**/*Spec.m")
end

def replace_in_specs(pattern, replacement)
  spec_paths.each do |path|
    text = File.read(path).gsub(pattern, replacement)
    File.open(path, 'w') do |file| file << text end
  end
end

task :pend do
  replace_in_specs(/ it\(@"/, ' pending_(@"')
end

task :unpend do
  replace_in_specs(/ pending_\(@"/, ' it(@"')
end

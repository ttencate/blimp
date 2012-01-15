sample_root = Blimp.gem_root.join("sample")
sample_source = Blimp::Sources::DiskSource.new(sample_root)
sample_site = Site.new("sample", sample_source, domains: ["localhost", "127.0.0.1", "127.0.0.1:9292", "127.0.0.1:9393"])
Sites.add(sample_site)

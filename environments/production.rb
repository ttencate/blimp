blimp_root = Blimp.gem_root.join("sample")
blimp_source = Blimp::Sources::DiskSource.new(blimp_root)
blimp_site = Site.new("blimp", blimp_source, domains: ["blimp.martenveldthuis.com"])
Sites.add(blimp_site)

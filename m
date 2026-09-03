Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED4F34887E
	for <kvmarm@lists.linux.dev>; Thu,  3 Sep 2026 02:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788402902; cv=none; b=mr4SPDVruYZNAf0Lcnubk8hGsklt9ssf/mD8mtClQXiLmBxXlF1Izh+K6zLAcQNvkIVQPe1JnBBcUFVkGpLL84BWBHEQLUFmurPTwZ2IPbI303g5jGZMeljHCqOGdHPNZEZ7VycJ7T+uuEQUy2gd4WwxEfGLVUx24qNuxwAOzj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788402902; c=relaxed/simple;
	bh=KttI8yN3SEE9knj1xRs/FNrG5jE/gzLZlVVCanD/Yjg=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=MlUzXIi/oXLgbbG9pxtpLNb1KNmNnma9ywBDoLu94q1pZTVYHBN+/uZqj4XYdJm1XfKwZMuOHs6jwGVaUBPshlTUHNA9Ug1xW5euylBt+bFTVf9CHw4w58jO1zTlUYJIC/5k7ZrrpRRo2L4mewVaez8GZxZySjuUCDL//wO2uxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--loganodell.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=t9lxLB8B; arc=none smtp.client-ip=209.85.216.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--loganodell.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t9lxLB8B"
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38e1118e4abso3451774a91.0
        for <kvmarm@lists.linux.dev>; Wed, 02 Sep 2026 19:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788402896; x=1789007696; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Z/CUOTjDyaAxtZC1lTIYdZbcKOF2SIWxflbwVxpxItE=;
        b=t9lxLB8BOhqyGYJtj7Mlxn82IqyEKvzP8Rf354ECHj/4gTs6C3GGF0ztPlxzTi7v5Z
         qvTNvY0dTB7BFYhSaHJ9EtsQgtC6SjEBkJKAdglDU+NOm2MFN4JexOjPJFYlIojXNqUh
         viwPKqme8+XPEQkzT2m5YiLTaCI24RBnv59X/+pLsNZtS9LVzYnB89wgP8L4EZta+k/L
         Fd3vtFHQbT7xaXxXDx03CaJui9BivGkcoDv28COX5q8V0AI+8mbBWQNK/tdxCfO/0wOF
         9BgM9F9UdtbWizeSxKdvQ5NiYgV+fk7VNzP6LSKhuhWLwwzuSZNEwGl5RlfyuQIWbA36
         +erw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788402896; x=1789007696;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Z/CUOTjDyaAxtZC1lTIYdZbcKOF2SIWxflbwVxpxItE=;
        b=FNwPI5AZQ7XaHSQIwyXV/17+0+yD5n3w6U2m2J6jSK5Znm8dOC09ykETH3fH7maEZ6
         cts/9lurcfzfhFjq3Irs7fgwOu3xCNz2NKIb9eBLY5fp2E2BaGj1rIFegB2cDRQot1fD
         PfYMOSbDycVZfHFYYJNGBH6A644EV8oGy5exlqwCAei72ANmhbZKiIGJ/HE25tyQBkNw
         DBEL9KbiM6CaKfvMzjMTbgHFOI6oJu+YFOWTuo9BVF8oK1/zAo4ss0kNPW0WJv3N0X4f
         XblDt5mD3iQYp/7jDxFOs17nXiD+6ClOqIkgZx+g6gcuF+jzwEYexFtV8sT4Q8aWM1GH
         q3SA==
X-Forwarded-Encrypted: i=1; AKwUvBwkf1xBX2j6oU0QdND+SCAIiZe2aUla7a5oCzNTEkpQd5CU+qUEQiZsNRAlqqN4EtiYRTQLgtE=@lists.linux.dev
X-Gm-Message-State: AFuF++nr2xo/gv7QhFZAlOS2yGQUcIPvwkStxZpjTgI32vhVmoiwfQzP
	ni9l3ixOrv693OaaVGoyjI5FUPCPLqbCNpwlzs5NsrMJaLrkgxDWFBau8+oaQWEhkvqTZd/IwMQ
	SX1tezv1Sa2SWk1UT7Ol2Mw==
X-Received: from dysc26.prod.google.com ([2002:a05:7300:3b1a:b0:332:2edd:e13a])
 (user=loganodell job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2d85:b0:398:9c00:29f0 with SMTP id 98e67ed59e1d1-39aee249bd7mr14082963a91.24.1788402895806;
 Wed, 02 Sep 2026 19:34:55 -0700 (PDT)
Date: Wed,  2 Sep 2026 19:34:49 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.979.g7e5102b832-goog
Message-ID: <20260903023452.721732-1-loganodell@google.com>
Subject: [RFC PATCH 0/3] liveupdate: Move to feature flags for LUO and memfd
 ABI compatibility
From: Logan Odell <loganodell@google.com>
To: arnd@arndb.de, pasha.tatashin@soleen.com, rppt@kernel.org, 
	pratyush@kernel.org, graf@amazon.com, akpm@linux-foundation.org, 
	pbonzini@redhat.com, maz@kernel.org, oupton@kernel.org, seanjc@google.com, 
	bhelgaas@google.com, alex@shazbot.org, jgg@nvidia.com, kevin.tian@intel.com, 
	dwmw2@infradead.org, baolu.lu@linux.intel.com, joro@8bytes.org, 
	will@kernel.org, robin.murphy@arm.com
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, linux-mm@kvack.org, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-pci@vger.kernel.org, iommu@lists.linux.dev, 
	Logan Odell <loganodell@google.com>
Content-Type: text/plain; charset="UTF-8"

We're including maintainers from all subsystems that currently is or
will be expected to participate in live update to ensure alignment on
the path forward for compatibility.

Currently, Live Update Orchestrator (LUO) and its file handlers rely on
monolithic compatibility strings (such as "luo-v5" and "memfd-v1") to
validate ABI compatibility across kexec live updates. Any modification
to serialized structures requires bumping the version string, which
strictly breaks compatibility between adjacent kernels even when changes
are additive, backwards-compatible, or optional.

This RFC series transitions LUO and subsystem file handlers to use
granular feature bitmasks instead of compatibility strings. We replace
the compatibility string with a header structure that includes some
reserved space to define the features that are included after the
feature.

We include 3 bits of data for each feature: supported, active, and
required. When the supported bit is set in the next kernel, the previous
kernel can serialize the feature and pass it to the next kernel. When
the active bit is set, it means the previous occurred and the data for
that feature is valid. When the required bit is set, it means that the
next kernel must have the associated supported bit in order to be
compatible.

If a feature is required in that it cannot live update to a kernel that
does not support the feature, it is expected that the feature not be
active or required initially. This allows for an intermediate upgrade
path.

Overview of Changes:
1. Define feature header and migrate luo_ser (Patch 1):
  - Introudce the feature header with the supported, active, and
    required bits.
  - Replace the luo compatibility string with this new header.
  - Validate the preserved size is at least the size of the header. This
    breaks compatibility with the old way.

2. Export feature header information to vmlinux (Patch 2):
  - Adds a .liveupdate_features section in vmlinux containing
  - Adds helper macros to export feature information for a given
    subsystem
  - Export luo's feature information

3. Memfd Handler Migration (Patch 3):
  - Migrate memfd to use the feature header instead of compatibility
    strings

Logan Odell (3):
  luo: Move to feature flags instead of compatibility strings
  luo: Export feature support to vmlinux section
  luo: memfd: Move to feature flags instead of compatibility strings

 include/asm-generic/vmlinux.lds.h |  12 ++++
 include/linux/kho/abi/luo.h       | 114 +++++++++++++++++++++++++-----
 include/linux/kho/abi/memfd.h     |  41 +++++++----
 include/linux/liveupdate.h        |  22 ++++--
 kernel/liveupdate/luo_core.c      |  60 ++++++++++++----
 kernel/liveupdate/luo_file.c      |  28 ++++----
 kernel/liveupdate/luo_flb.c       |   2 +-
 lib/tests/liveupdate.c            |   2 +-
 mm/memfd_luo.c                    |  40 ++++++++---
 9 files changed, 246 insertions(+), 75 deletions(-)

-- 
2.55.0.979.g7e5102b832-goog


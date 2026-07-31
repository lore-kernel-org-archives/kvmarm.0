Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF213E63B2
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 14:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785508558; cv=none; b=Cnz+MuQZL6c24m0ISsLQ+9xe2BGd9JiU0eOCMO8kOHsXCwNpK7gaZL1Qw0xPKWyDiIvXkySpN8efD1JBgxZ5ifr/aHLsRobH1oFVzaRtUOy9RZk0QNwP+LOHlAVKnjbwNu1nAiz83nLVzFrpwWfPWq1MD15i5Iv2GDuoboimj/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785508558; c=relaxed/simple;
	bh=di6xiYvGMEw5+c/32DuaGeN66UsZAV4+K6EFro0lUNg=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=qZ65VIo56jbCqfL5SwjHzqreZOmb2jhjPVktZ7P8Oa0a/GStaw6T7XLsHofbbv8qt8YeGFE8wey7zT4fKcgcC2TELG7NWFj8a3x0ViFZbKyOLF16LBL5iHYnf0znHW+ifj3pEPpLXW+NUYAfNr98u9E5YgaCq8QS7ezZrNB1UwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CMBzHjvx; arc=none smtp.client-ip=209.85.218.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CMBzHjvx"
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c15ceb17a28so84707366b.3
        for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 07:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785508555; x=1786113355; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=sK5d2FXANLt47SMUgxpLbGKpKt0pgzFr6mPV9F5aVAQ=;
        b=CMBzHjvxJ7fxeSeEkgPQKd+UUAf63/Dy1uhWtjl/iJyEzuM/C4va8a/EVlfh03+o1i
         +ERLhkZuCz9WEzxFshvPZM+PW/B04UIbYiVE/lvI/uVJlL8x5MY2tUhQ65foGU5aeGj6
         5koChwqJ3zI4XMjtsWl1G7ZCVDweMEl5ot5OysDS49cAvWqRpU3A/AP6z3UAVgoyCR+2
         YmJqz+p7/pJy34tLPAa2UIywIUzaR/yPfa3vxMzQQhdKPQ7sXIR03PxN5Mxd6DfDvRM9
         nIxJ4YD5x5ZDo/jo4EfCDeSgMRCpefcGesORfbXnfNUDN59ENY4x0ySfJwNCIxyrNsup
         L6qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785508555; x=1786113355;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sK5d2FXANLt47SMUgxpLbGKpKt0pgzFr6mPV9F5aVAQ=;
        b=N0hsBdekmXSwHEWkXCveT49u0QQH52mqgDSQsjO5d1xA0SiDJ3Khv0Ft6R/dDUqPt6
         lZcHsYhBO9UcjmBZ9dC39L514nlUHuimK0Hxnd6InSfsuyUxJNFRnqDbTl4Dx53JuJjq
         QhTWlMgYencAvNqwYKWZUojab2g+Fz//H2ErRyiumudTY43wQWQD2bdDAOLSmrPwGT2p
         m/z5aQlcO4mmCHuNIydLPVhPt3s2YiNO/3ZeOmDQ5UrALxPKCl5W8jnxehGPMMmVNWUV
         emLnslCraWmhFFllJPHssYIZHN5V1pcu+A5eBBDj4mgxzyo6oIdfvW+SF7nFim6Zp+5e
         O2sw==
X-Forwarded-Encrypted: i=1; AHgh+Rorjc/I7KJgrdX07VN7WOBjlV7Oucw0mz6EtjvrU1fQNFdY15abGfRnU+rnlAQ5n5PCpRcDTMc=@lists.linux.dev
X-Gm-Message-State: AOJu0YxOXvx0he9ZENUH6+6WskICEuZu5strvYp6vYv+MOHA7ONePD/v
	nwNohZilVG0EUI26EaIlbpqQpHnEYd2kkrsuJKExXJuccsLRjDboUncpG3rJ+ojX4W+9Lw6pOyZ
	1RkUY7Tfx8gG3fSqHgZNI8g==
X-Received: from wmte19.prod.google.com ([2002:a05:600c:8b33:b0:495:59dd:24f])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:9f92:b0:c15:e07a:eb4b with SMTP id a640c23a62f3a-c1fd200f131mr138962066b.3.1785508554441;
 Fri, 31 Jul 2026 07:35:54 -0700 (PDT)
Date: Fri, 31 Jul 2026 15:35:24 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260731143541.956291-1-vdonnefort@google.com>
Subject: [PATCH v4 00/17] KVM: arm64: Introduce pKVM hypervisor heap allocator
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

pKVM historically lacked a dynamic memory allocator: all hypervisor-side
VM and VCPU structures had to be sized on the host, allocated as
contiguous pages and donated to the hypervisor.

This design tightly coupled the hypervisor's memory footprint to
host-side constraints, complicated memory reclaim, and severely
restricted VM scalability.

This patch series introduces a dynamically-mapped custom heap allocator
(hyp_allocator) to the pKVM hypervisor. The initial users are the
pkvm_hyp_vm and pkvm_hyp_vcpu structs, and the hypervisor tracing
metadata.

In the near future, this heap allocator is expected to be leveraged to
support SVE in protected VMs and in the distant future, it will also
support dynamic device assignment.

By moving to a hypervisor-managed dynamic allocator, we also allow
deduplicating the donation/reclaim path of EL2-private structures.

The main building blocks for this series are:

1. pkvm_hyp_req:
----------------
When the hypervisor heap allocator goes out of memory (-ENOMEM), it
suspends the hypercall, embeds a PKVM_HYP_REQ_HYP_ALLOC top-up request
into the SMCCC HVC return registers, and exits back to the host.

This building block will also be useful for the future huge-mapping
support in protected guests, allowing EL2 to raise requests such as
block splitting back to the host.

2. hyp_allocator:
----------------
This heap allocator manages a reserved VA space range, dynamically
mapping and unmapping physical pages on-demand to minimise the pKVM
hypervisor footprint. As memory is reclaimed and relinquished to the
host, unmapped holes are introduced within the VA space. To prevent
orphan mapped regions, neighboring unused chunks cannot be merged if
they are separated by an unmapped region.

The allocator chunk metadata is stored directly into the VA space range.
To minimize metadata overhead, chunks only link to each other via a
relative 32-bit offset.

A simple hardening of the metadata is added via a simple 32-bit hash.

3. shrinker:
------------
As the heap allocator isn't reclaimed actively on VM or tracing
teardown, a shrinker is added to allow the host to reclaim unused memory
from the hypervisor when the host is under heavy memory pressure.

Changelog
---------

v4:

  - Add kerneldoc to pkvm_remove_mappings
  - Allow pkvm_private_va_range_pa() to work with block-level mappings (Sashiko)
  - Add rollback and harden pkvm_map_private_va_range input (Sashiko)
  - Add missing mc count into reclaimable memory
  - Differentiate -ENOMEM from hyp_alloc in errno_to_smccc() (Sashiko)
  - Collect Fuad's Tested-by

v3: https://lore.kernel.org/all/20260720171513.1415357-1-vdonnefort@google.com/

  - Remove unsafe WARN_ON(hyp_spin_is_locked(&pkvm_pgd_lock)) check in hyp_allocator_alloc() (Sashiko)
  - Modify MIN_ALLOC_SIZE to 16-bytes to comply with FPSIMD alignment requirements (Sashiko)
  - Allow hyp topup/reclaim HVCs pre-deprivilege
  - Add enum symbols to pkvm_hyp_req_handle event (Fuad)
  - Various clarification in commit descriptions (Fuad)
  - Restore unmap_donated_memory() for PGD on error path (Fuad)
  - Renamed __hyp_allocator_map -> pkvm_map_private_va_range (Fuad)
  - Collected Fuad's Reviewed-by tags
  - Rebased on 7.2-rc4

v2: https://lore.kernel.org/all/20260706175415.2604046-1-vdonnefort@google.com/

  - Rebased series on 7.2-rc2.
  - Use scope-based hyp_spinlock.
  - Fix best_missing/best_data_size priority in hyp_allocator_find_efficient_chunk() (Sashiko)
  - Fix missing free_hyp_memcache() in pkvm_hyp_topup() (Sashiko)
  - Fix unused selftest_init() warning when !CONFIG_NVHE_EL2_DEBUG (Sashiko)
  - Fix missing shrinker_free() in teardown_hyp_mode() (Sashiko)

v1: https://lore.kernel.org/r/20260520152650.4107895-1-vdonnefort@google.com

Vincent Donnefort (17):
  KVM: arm64: Add pkvm_private_va_range_pa
  KVM: arm64: Add pkvm_remove_mappings
  KVM: arm64: Add pkvm_map_private_va_range
  KVM: arm64: Add a heap allocator for the pKVM hyp
  KVM: arm64: Allow kvm_hyp_memcache usage outside of stage-2
  KVM: arm64: Add pkvm_hyp_req infrastructure
  KVM: arm64: Add PKVM_HYP_REQ_HYP_ALLOC request
  KVM: arm64: Add reclaim interface for the pKVM heap alloc
  KVM: arm64: Add selftests for the pKVM heap allocator
  KVM: arm64: Add a shrinker for pKVM
  KVM: arm64: Filter out non-kernel addresses in kern_hyp_va
  KVM: arm64: Move hyp_vm refcount into the structure
  KVM: arm64: Alloc pkvm_hyp_vm using pKVM heap allocator
  KVM: arm64: Alloc pkvm_hyp_vcpu using pKVM heap allocator
  KVM: arm64: Reject hyp trace descriptors with fewer CPUs than
    hyp_nr_cpus
  KVM: arm64: Reject hyp trace descriptors with fewer than 3 pages
  KVM: arm64: Alloc simple_buffer_page using pKVM hyp allocator

 arch/arm64/include/asm/kvm_asm.h           |    4 +
 arch/arm64/include/asm/kvm_host.h          |   14 +-
 arch/arm64/include/asm/kvm_mmu.h           |    3 +
 arch/arm64/include/asm/kvm_pkvm.h          |  102 ++
 arch/arm64/kvm/arm.c                       |    2 +
 arch/arm64/kvm/hyp/hyp-constants.c         |    2 -
 arch/arm64/kvm/hyp/include/nvhe/alloc.h    |   24 +
 arch/arm64/kvm/hyp/include/nvhe/mm.h       |    3 +
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h     |   19 +-
 arch/arm64/kvm/hyp/include/nvhe/spinlock.h |    4 +
 arch/arm64/kvm/hyp/nvhe/Makefile           |    2 +-
 arch/arm64/kvm/hyp/nvhe/alloc.c            | 1225 ++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c         |  129 ++-
 arch/arm64/kvm/hyp/nvhe/mm.c               |   79 ++
 arch/arm64/kvm/hyp/nvhe/pkvm.c             |  100 +-
 arch/arm64/kvm/hyp/nvhe/setup.c            |    6 +
 arch/arm64/kvm/hyp/nvhe/trace.c            |   70 +-
 arch/arm64/kvm/hyp_trace.c                 |   15 +-
 arch/arm64/kvm/mmu.c                       |    4 +-
 arch/arm64/kvm/pkvm.c                      |  159 ++-
 arch/arm64/kvm/trace_pkvm.h                |   45 +
 21 files changed, 1866 insertions(+), 145 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/alloc.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/alloc.c
 create mode 100644 arch/arm64/kvm/trace_pkvm.h


base-commit: 1590cf0329716306e948a8fc29f1d3ee87d3989f
-- 
2.55.0.508.g3f0d502094-goog


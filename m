Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B60259D
	for <kvmarm@lists.linux.dev>; Wed,  1 Feb 2023 12:59:19 +0000 (UTC)
Received: by mail-wr1-f41.google.com with SMTP id q5so17271156wrv.0
        for <kvmarm@lists.linux.dev>; Wed, 01 Feb 2023 04:59:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VLwwDnyRxUIk04LctYlJIiJXPDb99zDQ0mkniPbimTE=;
        b=U9RLp3as5sbiG9ImsyZYSkygJF2rsCmvkgMOTFbfS57BJjrA2J23dp5xfYe4goWGRB
         klpnEfv0qB3H6gdPd8jWI+GjAUpu3O5dzLIWod0Ye148672tK8t4MrJZWmZ6hdNPwzpv
         C6+qUk5BWgkqkCWMvueVFC6odlvcK2vuQM/4EeLuf9txuzKomdsuP8ki2zMzLVzrB8Rt
         YrF0oQAAtNk3rfOGFOi+c3crBGWFiWZ0iYSqCbwln35SbgcpQJWkgD17EySDcc2yYV2j
         BLGF0NZJMasSkbiXnfjQnQRKwmr5usVJF7wS10W9bRxg2Nnp340vufW10kDmM+A2T369
         KlwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VLwwDnyRxUIk04LctYlJIiJXPDb99zDQ0mkniPbimTE=;
        b=hZa2jjHpkePg6+tKxHmA1NJe8cSUhE5GnEwZ2aHxgAw3jgWW4gzmS9tYG0Ngrjm2KJ
         osrBJPVZGT4MTw+K+Mx/BfLgzi7PlIrvJowCRNktdXBSW0IAtQq2jxAmBGPglEMEnEIu
         NF3p9FP3BbLr1OcOUSiZjvFlUGLQSE9E2DJNymgMzI39HoSbxuZIw8KHBfw22yIr7TOp
         3VLpHA6aKHBB8yJ1FklDZv89HuEkVS2tMUq+gBhxbkxQkbWWT59FEClOcsFGxO96d9Fh
         pW59wGUEYyMFrd/bwe1ufuEcAPJnD/sqGZ2IMTXymede/Uo66q/xHHdr2Ao/o4I/koWx
         oONg==
X-Gm-Message-State: AO0yUKVib7IYcRIlZ2PjhZY/yzfcjS+mHUU9PNfx3yjvsw4oGK36AcB2
	qY4TrtZM7Vg8M3ak4VezDQ4Oag==
X-Google-Smtp-Source: AK7set+0MVYoW/tl+4fxD0uxWT3sNMcCa/0flt96XdghvR/Hw02VWtwdBqXKUzbsDZD9oTmFAwALnQ==
X-Received: by 2002:adf:c754:0:b0:2bf:e533:3158 with SMTP id b20-20020adfc754000000b002bfe5333158mr2556951wrh.20.1675256358203;
        Wed, 01 Feb 2023 04:59:18 -0800 (PST)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id m15-20020a056000024f00b002bfae16ee2fsm17972811wrz.111.2023.02.01.04.59.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 04:59:17 -0800 (PST)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: maz@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	joro@8bytes.org
Cc: robin.murphy@arm.com,
	james.morse@arm.com,
	suzuki.poulose@arm.com,
	oliver.upton@linux.dev,
	yuzenghui@huawei.com,
	smostafa@google.com,
	dbrazdil@google.com,
	ryan.roberts@arm.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	iommu@lists.linux.dev,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [RFC PATCH 00/45] KVM: Arm SMMUv3 driver for pKVM
Date: Wed,  1 Feb 2023 12:52:44 +0000
Message-Id: <20230201125328.2186498-1-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.39.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The pKVM hypervisor, recently introduced on arm64, provides a separation
of privileges between the host and hypervisor parts of KVM, where the
hypervisor is trusted by guests but the host is not [1]. The host is
initially trusted during boot, but its privileges are reduced after KVM
is initialized so that, if an adversary later gains access to the large
attack surface of the host, it cannot access guest data.

Currently with pKVM, the host can still instruct DMA-capable devices
like the GPU to access guest and hypervisor memory, which undermines
this isolation. Preventing DMA attacks requires an IOMMU, owned by the
hypervisor.

This series adds a hypervisor driver for the Arm SMMUv3 IOMMU. Since the
hypervisor part of pKVM (called nVHE here) is minimal, moving the whole
host SMMU driver into nVHE isn't really an option. It is too large and
complex and requires infrastructure from all over the kernel. We add a
reduced nVHE driver that deals with populating the SMMU tables and the
command queue, and the host driver still deals with probing and some
initialization.


Patch overview
==============

A significant portion of this series just moves and factors code to
avoid duplications. Things get interesting only around patch 15, which
adds two helpers that track pages mapped in the IOMMU, and ensure those
pages are not donated to guests. Then patches 16-27 add the hypervisor
IOMMU driver, split into a generic part that can be reused by other
drivers, and code specific to SMMUv3.

Patches 34-40 introduce the host component of the pKVM SMMUv3 driver,
which initializes the configuration and forwards mapping requests to the
hypervisor. Ideally there would be a single host driver with two sets of
IOMMU ops, and while I believe more code can still be shared, the
initialization is very different and having separate driver entry points
seems clearer.

Patches 41-45 provide a rough example of power management through SCMI.
Although the host decides on power management policies, the hypervisor
must at least be aware of power changes, so that it doesn't access powered
down interfaces. We expect that the platform controller enforces
dependencies so that DMA doesn't bypass a powered down IOMMU. But these
things are unfortunately platform dependent and the SCMI patches are
only illustrative.

These patches in particular are best reviewed with git's --color-moved:
1,2	iommu/io-pgtable-arm: Split*
7,29-32	iommu/arm-smmu-v3: Move*

A development branch is available at
https://jpbrucker.net/git/linux pkvm/smmu


Design
======

We've explored three solutions so far. This posting implements the third
one, slightly more invasive in the hypervisor but the most flexible.

1. Sharing stage-2 page tables

This is the simplest solution, sharing the stage-2 page tables (which
translates host physical address -> system physical address) between CPU
and SMMU. Whatever the host can access on the CPU, it can also access with
DMA. Memory that is not accessible to the host because donated to the
hypervisor or guests, DMA cannot access either.

pKVM normally populates the host stage-2 page tables lazily, when the host
first accesses them. However this relies on CPU page faults, and DMA
generally cannot fault. The whole stage-2 must therefore be populated at
boot. That's easy to do because the HPA->PA mapping for the host is an
identity.

It gets more complicated when donating some pages to guests, which
involves removing those pages from the host stage-2. To save memory and be
TLB efficient, the stage-2 is mapped with block mappings (1G or 2MB
contiguous range, rather than individual 4k units). When donating a page
from that range, the hypervisor must remove the block mapping, and replace
it with a table that excludes the donated page. Since a device may be
simultaneously performing DMA on other pages in the range, this
replacement operation must be atomic. Otherwise DMA may reach the SMMU
during a small period of time where the mapping is invalid, and fatally
abort.

The Arm architecture supports atomic replacement of block mappings only
since version 8.4 (FEAT_BBM), and it is optional. So this solution, while
tempting, is not sufficient.

2. Pinning DMA mappings in the shared stage-2

Building on the first solution, we can let the host notify the hypervisor
about pages used for DMA. This way block mappings are broken into tables
when the host sets up DMA, and donating neighbouring pages to guests won't
cause block replacement.

This solution adds runtime overhead because calls the DMA API are now
forwarded to the hypervisor, which needs to update the stage-2 mappings.

All in all, I believe this is a good solution if the hardware is up to the
task. But sharing page tables requires matching capabilities between the
stage-2 MMU and SMMU, and we don't expect all platforms to support the
required features, especially on mobile platforms where chip area is
costly.

3. Private I/O page tables

A flexible alternative uses private page tables in the SMMU, entirely
disconnected from the CPU page tables. With this the SMMU can implement a
reduced set of features, even shed a stage of translation. This also
provides a virtual I/O address space to the host, which allows more
efficient memory allocation for large buffers, and for devices with
limited addressing abilities.

This is the solution implemented in this series. The host creates
IOVA->HPA mappings with two hypercalls map_pages() and unmap_pages(), and
the hypervisor populates the page tables. Page tables are abstracted into
IOMMU domains, which allow multiple devices to share the same address
space. Another four hypercalls, alloc_domain(), attach_dev(), detach_dev()
and free_domain(), manage the domains.

Although the hypervisor already has pgtable.c to populate CPU page tables,
we import the io-pgtable library because it is more suited to IOMMU page
tables. It supports arbitrary page and address sizes, non-coherent page
walks, quirks and errata workarounds specific to IOMMU implementations,
and atomically switching between tables and blocks without lazy remapping.


Performance
===========

Both solutions 2 and 3 add overhead to DMA mappings, and since the
hypervisor relies on global locks at the moment, they scale poorly.
Interestingly solution 3 can be optimized to scale really well on the
map() path. We can remove the hypervisor IOMMU lock in map()/unmap() by
holding domain references, and then use the hyp vmemmap to track DMA state
of pages atomically, without updating the CPU stage-2 tables. Donation and
sharing would then need to inspect the vmemmap. On the unmap() path, the
single command queue for TLB invalidations still requires locking.

To give a rough idea, these are dma_map_benchmark results on a 96-core
server (4 NUMA nodes, SMMU on node 0). I'm adding these because I found
the magnitudes interesting but do take them with a grain of salt, my
methodology wasn't particularly thorough (although the numbers seem
repeatable). Numbers represent the average time needed for one
dma_map/dma_unmap call in μs, lower is better.

			1 thread	16 threads (node 0)	96 threads
host only		0.2/0.7		0.4/3.5			1.7/81
pkvm (this series)	0.5/2.2		28/51			291/542
pkvm (+optimizations)	0.3/1.9		0.4/38			0.8/304


[1] https://lore.kernel.org/kvmarm/20220519134204.5379-1-will@kernel.org/


David Brazdil (1):
  KVM: arm64: Introduce IOMMU driver infrastructure

Jean-Philippe Brucker (44):
  iommu/io-pgtable-arm: Split the page table driver
  iommu/io-pgtable-arm: Split initialization
  iommu/io-pgtable: Move fmt into io_pgtable_cfg
  iommu/io-pgtable: Add configure() operation
  iommu/io-pgtable: Split io_pgtable structure
  iommu/io-pgtable-arm: Extend __arm_lpae_free_pgtable() to only free
    child tables
  iommu/arm-smmu-v3: Move some definitions to arm64 include/
  KVM: arm64: pkvm: Add pkvm_udelay()
  KVM: arm64: pkvm: Add pkvm_create_hyp_device_mapping()
  KVM: arm64: pkvm: Expose pkvm_map/unmap_donated_memory()
  KVM: arm64: pkvm: Expose pkvm_admit_host_page()
  KVM: arm64: pkvm: Unify pkvm_pkvm_teardown_donated_memory()
  KVM: arm64: pkvm: Add hyp_page_ref_inc_return()
  KVM: arm64: pkvm: Prevent host donation of device memory
  KVM: arm64: pkvm: Add __pkvm_host_share/unshare_dma()
  KVM: arm64: pkvm: Add IOMMU hypercalls
  KVM: arm64: iommu: Add per-cpu page queue
  KVM: arm64: iommu: Add domains
  KVM: arm64: iommu: Add map() and unmap() operations
  KVM: arm64: iommu: Add SMMUv3 driver
  KVM: arm64: smmu-v3: Initialize registers
  KVM: arm64: smmu-v3: Setup command queue
  KVM: arm64: smmu-v3: Setup stream table
  KVM: arm64: smmu-v3: Reset the device
  KVM: arm64: smmu-v3: Support io-pgtable
  KVM: arm64: smmu-v3: Setup domains and page table configuration
  iommu/arm-smmu-v3: Extract driver-specific bits from probe function
  iommu/arm-smmu-v3: Move some functions to arm-smmu-v3-common.c
  iommu/arm-smmu-v3: Move queue and table allocation to
    arm-smmu-v3-common.c
  iommu/arm-smmu-v3: Move firmware probe to arm-smmu-v3-common
  iommu/arm-smmu-v3: Move IOMMU registration to arm-smmu-v3-common.c
  iommu/arm-smmu-v3: Use single pages for level-2 stream tables
  iommu/arm-smmu-v3: Add host driver for pKVM
  iommu/arm-smmu-v3-kvm: Pass a list of SMMU devices to the hypervisor
  iommu/arm-smmu-v3-kvm: Validate device features
  iommu/arm-smmu-v3-kvm: Allocate structures and reset device
  iommu/arm-smmu-v3-kvm: Add per-cpu page queue
  iommu/arm-smmu-v3-kvm: Initialize page table configuration
  iommu/arm-smmu-v3-kvm: Add IOMMU ops
  KVM: arm64: pkvm: Add __pkvm_host_add_remove_page()
  KVM: arm64: pkvm: Support SCMI power domain
  KVM: arm64: smmu-v3: Support power management
  iommu/arm-smmu-v3-kvm: Support power management with SCMI SMC
  iommu/arm-smmu-v3-kvm: Enable runtime PM

 drivers/iommu/Kconfig                         |   10 +
 virt/kvm/Kconfig                              |    3 +
 arch/arm64/kvm/hyp/nvhe/Makefile              |    6 +
 drivers/iommu/Makefile                        |    2 +-
 drivers/iommu/arm/arm-smmu-v3/Makefile        |    6 +
 arch/arm64/include/asm/arm-smmu-v3-regs.h     |  478 ++++++++
 arch/arm64/include/asm/kvm_asm.h              |    7 +
 arch/arm64/include/asm/kvm_host.h             |    5 +
 arch/arm64/include/asm/kvm_hyp.h              |    4 +-
 arch/arm64/kvm/hyp/include/nvhe/iommu.h       |  115 ++
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   11 +-
 arch/arm64/kvm/hyp/include/nvhe/memory.h      |   15 +-
 arch/arm64/kvm/hyp/include/nvhe/mm.h          |    2 +
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |   29 +
 .../arm64/kvm/hyp/include/nvhe/trap_handler.h |    2 +
 drivers/gpu/drm/panfrost/panfrost_device.h    |    2 +-
 drivers/iommu/amd/amd_iommu_types.h           |   17 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  510 +-------
 drivers/iommu/arm/arm-smmu/arm-smmu.h         |    2 +-
 drivers/iommu/io-pgtable-arm.h                |   30 -
 include/kvm/arm_smmu_v3.h                     |   61 +
 include/kvm/iommu.h                           |   74 ++
 include/kvm/power_domain.h                    |   22 +
 include/linux/io-pgtable-arm.h                |  190 +++
 include/linux/io-pgtable.h                    |  114 +-
 arch/arm64/kvm/arm.c                          |   41 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  101 +-
 arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c   |  625 ++++++++++
 .../arm64/kvm/hyp/nvhe/iommu/io-pgtable-arm.c |   97 ++
 arch/arm64/kvm/hyp/nvhe/iommu/iommu.c         |  393 ++++++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         |  209 +++-
 arch/arm64/kvm/hyp/nvhe/mm.c                  |   27 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                |   66 +-
 arch/arm64/kvm/hyp/nvhe/power/scmi.c          |  233 ++++
 arch/arm64/kvm/hyp/nvhe/setup.c               |   47 +-
 arch/arm64/kvm/hyp/nvhe/timer-sr.c            |   43 +
 drivers/gpu/drm/msm/msm_iommu.c               |   22 +-
 drivers/gpu/drm/panfrost/panfrost_mmu.c       |   22 +-
 drivers/iommu/amd/io_pgtable.c                |   26 +-
 drivers/iommu/amd/io_pgtable_v2.c             |   43 +-
 drivers/iommu/amd/iommu.c                     |   29 +-
 drivers/iommu/apple-dart.c                    |   38 +-
 .../arm/arm-smmu-v3/arm-smmu-v3-common.c      |  632 ++++++++++
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c   |  864 +++++++++++++
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |    2 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  679 +----------
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c    |    7 +-
 drivers/iommu/arm/arm-smmu/arm-smmu.c         |   41 +-
 drivers/iommu/arm/arm-smmu/qcom_iommu.c       |   41 +-
 drivers/iommu/io-pgtable-arm-common.c         |  766 ++++++++++++
 drivers/iommu/io-pgtable-arm-v7s.c            |  190 +--
 drivers/iommu/io-pgtable-arm.c                | 1082 ++---------------
 drivers/iommu/io-pgtable-dart.c               |  105 +-
 drivers/iommu/io-pgtable.c                    |   57 +-
 drivers/iommu/ipmmu-vmsa.c                    |   20 +-
 drivers/iommu/msm_iommu.c                     |   18 +-
 drivers/iommu/mtk_iommu.c                     |   14 +-
 57 files changed, 5743 insertions(+), 2554 deletions(-)
 create mode 100644 arch/arm64/include/asm/arm-smmu-v3-regs.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/iommu.h
 delete mode 100644 drivers/iommu/io-pgtable-arm.h
 create mode 100644 include/kvm/arm_smmu_v3.h
 create mode 100644 include/kvm/iommu.h
 create mode 100644 include/kvm/power_domain.h
 create mode 100644 include/linux/io-pgtable-arm.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
 create mode 100644 arch/arm64/kvm/hyp/nvhe/iommu/io-pgtable-arm.c
 create mode 100644 arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
 create mode 100644 arch/arm64/kvm/hyp/nvhe/power/scmi.c
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common.c
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
 create mode 100644 drivers/iommu/io-pgtable-arm-common.c

-- 
2.39.0


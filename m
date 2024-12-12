Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9925223C55
	for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 18:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734026688; cv=none; b=GAYzJFDT13s4xdusc2D+23z3Mu8Ov/0+01dgq82KbuZa3xulpQaTvH4f9pxAwVmyoZJuAPG/oZ1ebDncEHUWqVFhPmjHgWi7wjPJ64lejyH7Y7m9IRf4JiEOdnxVBojgLQNrDD75/VIlSoL01dqa/qYw8/m/JGdQxC+9BjGN++4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734026688; c=relaxed/simple;
	bh=JJQYlqRniRo6Liyifw+wEXn5BAuzS8qZYBOaVeIIJRY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=f0HHr76h3/w4N78MS9XILjc0X8400aEDJdACTDeo+pHtzCdMqstLLSekX8MQ7mT5As14njVpbaKCoR9wOJnMjA8lJSzE7HyV/rquypvZnWpnrejZ9gsKqlFMesETL7EadJIQyOV7Bv+2B5sp7sggYKD0+uR7uBKZQawfmqR5L+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QkoCFIqn; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QkoCFIqn"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4361c040ba8so5527205e9.1
        for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 10:04:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734026684; x=1734631484; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=X3QNbQk9Af3tLnSha9OvWeoZKYxnPI0205NsJD/WvOI=;
        b=QkoCFIqnesYqIRwiB5ChEs2OoJWQeGUbfBHTSkTHR7gzycqRve3Br6qBjcatc6iTrG
         7XRMEax6exwFVGRAeEodWzRkkdEChyta9gAp21fR0AEhc5Q4trUNqy6EDZB1b8JLW7Dz
         K/ZM8lFeo3dx5SMZtR80AE61HjYQRVkwbScQAyNzjdc4dudTwKqhfmuXMo2qylw4EUUX
         eXea+u+FS7PnqLAHTM4pKGKwZU6XQe39lKr4eHo5HgBFtnIiVICt6XWovC+OGnXxKDD6
         pONKrrhcaBN1hLdvdkIfxUmwfdO9XEQQ0mTfvwofBCblJqYgyLfTyACw8F+oR65TU7O2
         dbOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734026684; x=1734631484;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X3QNbQk9Af3tLnSha9OvWeoZKYxnPI0205NsJD/WvOI=;
        b=aEXF2YGmdeonQjLCLUdI2mRny718vKTn3wbNBF+2xGRaSmYMgxJfZz5s5q2UsS7hAl
         WVPYH9Bp/C3tdXdZzHpyWkS/bM7EYKPGIuQBmqXj4tRXfkk36GEf/yr4jauzDLed/WHI
         LLaKql7MzqgRFD1vEhIoutYydU+WpdnzUALT+ajp3DoX/Gon7QVJq70v5FAlTRPq7ljT
         LKc9IX1tNmq101puXkFbBDAFsrebw+zf9SVZPy304nM+ywUBGolFHgytjg+a5iNdEqRM
         KzQh+LxCg57OQtC+8QtNmIaApLotFcBN9u7VC2xg7CKRiCS3Lum4EF9lkdZnqoCetEgg
         W/VQ==
X-Forwarded-Encrypted: i=1; AJvYcCX+4aF9MX0OYlxgj0ao09qHdLmGOL6AZWDfJFk5fb8pDbQAjm4uvl4bg3hIunuAerW6OtHqOiI=@lists.linux.dev
X-Gm-Message-State: AOJu0YyRhukg+syjasiSyffa79IivU7SlVHB55DL48QjEolABzVY5pD2
	4KJjMXmfqgN96aufhhL4afEoopvW+6Cfu5yHBPOvRn4+GN1puAMhRoTSfKKNb1v3vqQiSUqjAjL
	GPXGR5tXMBQ==
X-Google-Smtp-Source: AGHT+IHKBinJVQcT479Uep9PSmgKSNGnRHCqrxbrAdrm9kvadA4RmY5+rFb8SPYgtemfy+24DWsTv7iNnYRDDQ==
X-Received: from wmfq8.prod.google.com ([2002:a05:600c:2e48:b0:434:a922:b240])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:5029:b0:431:44fe:fd9a with SMTP id 5b1f17b1804b1-4361c3e010amr64381255e9.19.1734026684302;
 Thu, 12 Dec 2024 10:04:44 -0800 (PST)
Date: Thu, 12 Dec 2024 18:03:24 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241212180423.1578358-1-smostafa@google.com>
Subject: [RFC PATCH v2 00/58] KVM: Arm SMMUv3 driver for pKVM
From: Mostafa Saleh <smostafa@google.com>
To: iommu@lists.linux.dev, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, robdclark@gmail.com, joro@8bytes.org, 
	robin.murphy@arm.com, jean-philippe@linaro.org, jgg@ziepe.ca, 
	nicolinc@nvidia.com, vdonnefort@google.com, qperret@google.com, 
	tabba@google.com, danielmentz@google.com, tzukui@google.com, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This is v2 of the series sent last year:
https://lore.kernel.org/kvmarm/20230201125328.2186498-1-jean-philippe@linar=
o.org/

pKVM overview:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
The pKVM hypervisor, recently introduced on arm64, provides a separation
of privileges between the host and hypervisor parts of KVM, where the
hypervisor is trusted by guests but the host is not [1][2]. The host is
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

Some of the pKVM infrastructure is not upstream yet, which are dependencies
for this series, so it should be considered a forward looking RFC for
what we think about how DMA isolation can be supported in pKVM or in
other similar confidential computing solutions and not a ready to merge
solution.
This is discussed further in the dependencies section below.

Patches overview
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
The patches are split as follows:
Patches 1-10: Mostly about splitting the current SMMUv3 driver and
io-pgtable-arm library, so the code can be re-used in the KVM driver
either inside the kernel or the hypervisor.
Most of these patches are best reviewed with git's --color-moved.

Patches 11-24: Introduce the hypervisor core code for IOMMUs which is
not specific to SMMUv3, these are the hypercall handlers and common
logic in the hypervisor.
It also introduces the key functions __pkvm_host_{un}use_dma_page which
are used to track DMA mapped pages, more on this in the design section.

Patches 25-41: Add the hypervisor part of the KVM SMMUv3 driver which
is called by hypervisor core IOMMU code, these are para-virtualized
operations such as attach/detach, map/unmap...

Patches 42-54: Add the kernel part of the KVM SMMUv3 driver, this
probes the IOMMUs and initialises them and populates the list of SMMUs
to the hypervisor, it also implements the kernel iommu_ops and registers
the IOMMUs with the kernel.

Patches 55-58: Two extra optimizations introduced at the end to avoid
complicating the start of the series, one to optimise iommu_map_sg and
the other is to batch TLB invalidation which I noticed to be a problem
while testing as my HW doesn=E2=80=99t support range invalidation.

A development branch is available at:
https://android-kvm.googlesource.com/linux/+log/refs/heads/for-upstream/pkv=
m-smmu

Design
=3D=3D=3D=3D=3D=3D
We've explored 4 solutions so far, we only mention two of them here
which I believe are the most promising as they offer private IO spaces,
while the others were discussed in the v1 of the series cover letter.

1. Paravirtual I/O page tables
This is the solution implemented in this series. The host creates
IOVA->HPA mappings with two hypercalls map_pages() and unmap_pages(), and
the hypervisor populates the page tables. Page tables are abstracted into
IOMMU domains, which allow multiple devices to share the same address
space. Another four hypercalls, alloc_domain(), attach_dev(), detach_dev()
and free_domain(), manage the domains, the semantics of those hypercalls
are almost identical to the IOMMU ops which make the kernel driver part
simpler.

Some key points in the hypervisor design:
a- Tracking mapped pages: the hypervisor must prevent pages mapped in the
   IOMMU to be donated to a protected guest or the hypervisor, or allow
   a protected guest/hypervisor page be mapped in an IOMMU domain.

   For that we rely on the vmemmap refcount, where each time a page is
   mapped it=E2=80=99s refcount is incremented and ownership is checked, an=
d
   each time it's successfully unmapped it=E2=80=99s decremented. And any m=
emory
   donation would be denied for refcounted pages.

b- Locking: The io-pgtable-arm is lockless under some guarantees of how
   the IOMMU code behaves. However with pKVM, the kernel is not trusted
   and a malicious kernel can issue concurrent requests causing memory
   corruption or UAF, so that it has to be locked in the hypervisor.

c- Memory management: The hypervisor needs a way to allocate pages for
   the pv page tables, for that an IOMMU pool is created which can be
   topped up from a hypercall, and the IOMMU hypercalls returns encoded
   memory requests which can be fulfilled by the kernel driver.

2. Nested SMMUv3 translation (with emulation)
Another approach is to rely on nested translation support which is
optional in SMMUv3, that requires an architecturally accurate emulation
of SMMUv3 which can be complicated including cmdq emulation.

With this approach, we can use the same page tables as the CPU stage-2,
which adds more constraints on HW (SMMUv3 features must match the CPU)
and the ability of the devices to handle faults as the CPU part relies
on lazy mapping and has no guarantees about pages being mapped.
Or we can use a shadow IOMMU page table instead.

I have a prototype that is not ready yet to be posted for nested:
https://android-kvm.googlesource.com/linux/+log/refs/heads/smostafa/android=
15-6.6-smmu-nesting-wip


The trade off between the 2 approaches can be roughly summarised as:
Paravirtualization:
- Compatible with more HW (and IOMMUs).
- Better DMA performance due to shorter table walks/less TLB pressure
- Needs extra complexity to squeeze the last bit of optimization (around
  unmap, and map_sg).

Nested Emulation
- Faster map_pages (not sure about unmap because it requires cmdq
  emulation for TLB invalidation if DVM not used).
- Needs extra complexity for architecturally emulating SMMUv3.

I believe that the first approach looks more promising with this trade
off. However, I plan to complete the nested emulation and post it with
a comparison with this approach in terms of performance, and maybe this
topic can be discussed in an upcoming conference.

Dependencies
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
This series depends on some parts of pKVM that are not upstreamed yet,
some of them are currently posted[3][4]. However, not to spam the list
with many of these changes which are not relevant to IOMMU/SMMUv3 the
patches are developed on top of them.

This series also depends on another series reworking the io-pgtable walker[=
5]

Performance
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
With CONFIG_DMA_MAP_BENCHMARK on a 4-core Morello board.
Numbers represent the average time needed for one dma_map/dma_unmap call
in =CE=BCs, lower is better.
It is compared with the kernel driver, which is not quite a fair comparison
as it doesn't fulfil pKVM DMA isolation requirements. However, these
numbers are provided just to give a rough idea about how the overhead
looks like.
			Kernel driver	      pKVM driver
4K - 1 thread		0.1/0.7               0.3/1.3
4K - 4 threads		0.1/1.1               0.5/3.3
1M - 1 thread		0.8/21.5              2.6/27.3
1M - 4 threads		1.1/45.7              3.6/46.2

And tested as follows:
echo dma_map_benchmark > /sys/bus/pci/devices/0000\:06\:00.0/driver_overrid=
e
echo 0000:06:00.0 >  /sys/bus/pci/devices/0000\:06\:00.0/driver/unbind
echo 0000:06:00.0 > /sys/bus/pci/drivers/dma_map_benchmark/bind
./dma_map_bechmark -t $threads -g $nr_pages


Future work
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
- Add IDENTITY_DOMAIN support, I already have some patches for that, but
  didn=E2=80=99t want to complicate this series, I can send them separately=
.
- Complete the comparison with the nesting support and find the most
  suitable solution for upstream.


Main changes since v1
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
- Patches are reordered to split the introduction of the KVM IOMMU
  code and the SMMUv3 driver.
- KVM EL2 code is closer the EL1 where domains are decoupled from
  IOMMUs.
- SMMUv3 new features (stage-1 support, IRQ and EVTQ in the kernel).
- Adaptions to the new SMMUv3 cleanups.
- Rework tracking of mapped pages to improve performance.
- Rework locking to improve performance.
- Rework unmap to improve performance.
- Adding iotlb_gather to optimize unmap.
- Add new operations to optimize map_sg operation.
- Registering driver is dynamically done instead of statically checked.
- Memory allocation for page table pages are changed to be separate
  pool and HVCs instead of share mc that required atomic allocation.
- Support for higher order page allocation.
- Support for non-coherent SMMUs.
- Support for DABT and MMIO emulation.


[1] https://lore.kernel.org/kvmarm/20220519134204.5379-1-will@kernel.org/
[2] https://www.youtube.com/watch?v=3D9npebeVFbFw
[3] https://lore.kernel.org/kvmarm/20241203103735.2267589-1-qperret@google.=
com/
[4] https://lore.kernel.org/all/20241202154742.3611749-1-tabba@google.com/
[5] https://lore.kernel.org/linux-iommu/20241028213146.238941-1-robdclark@g=
mail.com/T/#t


Jean-Philippe Brucker (23):
  iommu/io-pgtable-arm: Split the page table driver
  iommu/io-pgtable-arm: Split initialization
  iommu/io-pgtable: Add configure() operation
  iommu/arm-smmu-v3: Move some definitions to arm64 include/
  iommu/arm-smmu-v3: Extract driver-specific bits from probe function
  iommu/arm-smmu-v3: Move some functions to arm-smmu-v3-common.c
  iommu/arm-smmu-v3: Move queue and table allocation to
    arm-smmu-v3-common.c
  iommu/arm-smmu-v3: Move firmware probe to arm-smmu-v3-common
  iommu/arm-smmu-v3: Move IOMMU registration to arm-smmu-v3-common.c
  KVM: arm64: pkvm: Add pkvm_udelay()
  KVM: arm64: pkvm: Add __pkvm_host_add_remove_page()
  KVM: arm64: pkvm: Support SCMI power domain
  KVM: arm64: iommu: Support power management
  KVM: arm64: iommu: Add SMMUv3 driver
  KVM: arm64: smmu-v3: Initialize registers
  KVM: arm64: smmu-v3: Setup command queue
  KVM: arm64: smmu-v3: Reset the device
  KVM: arm64: smmu-v3: Support io-pgtable
  iommu/arm-smmu-v3-kvm: Add host driver for pKVM
  iommu/arm-smmu-v3-kvm: Pass a list of SMMU devices to the hypervisor
  iommu/arm-smmu-v3-kvm: Validate device features
  iommu/arm-smmu-v3-kvm: Allocate structures and reset device
  iommu/arm-smmu-v3-kvm: Probe power domains

Mostafa Saleh (35):
  iommu/arm-smmu-v3: Move common irq code to common file
  KVM: arm64: Add __pkvm_{use, unuse}_dma()
  KVM: arm64: Introduce IOMMU driver infrastructure
  KVM: arm64: pkvm: Add IOMMU hypercalls
  KVM: arm64: iommu: Add a memory pool for the IOMMU
  KVM: arm64: iommu: Add domains
  KVM: arm64: iommu: Add {attach, detach}_dev
  KVM: arm64: iommu: Add map/unmap() operations
  KVM: arm64: iommu: support iommu_iotlb_gather
  KVM: arm64: Support power domains
  KVM: arm64: iommu: Support DABT for IOMMU
  KVM: arm64: smmu-v3: Setup stream table
  KVM: arm64: smmu-v3: Setup event queue
  KVM: arm64: smmu-v3: Add {alloc/free}_domain
  KVM: arm64: smmu-v3: Add TLB ops
  KVM: arm64: smmu-v3: Add context descriptor functions
  KVM: arm64: smmu-v3: Add attach_dev
  KVM: arm64: smmu-v3: Add detach_dev
  iommu/io-pgtable: Generalize walker interface
  iommu/io-pgtable-arm: Add post table walker callback
  drivers/iommu: io-pgtable: Add IO_PGTABLE_QUIRK_UNMAP_INVAL
  KVM: arm64: smmu-v3: Add map/unmap pages and iova_to_phys
  KVM: arm64: smmu-v3: Add DABT handler
  KVM: arm64: Add function to topup generic allocator
  KVM: arm64: Add macro for SMCCC call with all returns
  iommu/arm-smmu-v3-kvm: Add function to topup IOMMU allocator
  iommu/arm-smmu-v3-kvm: Add IOMMU ops
  iommu/arm-smmu-v3-kvm: Add map, unmap and iova_to_phys operations
  iommu/arm-smmu-v3-kvm: Support PASID operations
  iommu/arm-smmu-v3-kvm: Add IRQs for the driver
  iommu/arm-smmu-v3-kvm: Enable runtime PM
  drivers/iommu: Add deferred map_sg operations
  KVM: arm64: iommu: Add hypercall for map_sg
  iommu/arm-smmu-v3-kvm: Implement sg operations
  iommu/arm-smmu-v3-kvm: Support command queue batching

 arch/arm64/include/asm/arm-smmu-v3-common.h   |  592 +++++++
 arch/arm64/include/asm/kvm_asm.h              |    9 +
 arch/arm64/include/asm/kvm_host.h             |   48 +-
 arch/arm64/include/asm/kvm_hyp.h              |    2 +
 arch/arm64/kvm/Makefile                       |    2 +-
 arch/arm64/kvm/arm.c                          |    8 +-
 arch/arm64/kvm/hyp/hyp-constants.c            |    1 +
 arch/arm64/kvm/hyp/include/nvhe/iommu.h       |   91 ++
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |    3 +
 arch/arm64/kvm/hyp/include/nvhe/mm.h          |    1 +
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |   37 +
 .../arm64/kvm/hyp/include/nvhe/trap_handler.h |    2 +
 arch/arm64/kvm/hyp/nvhe/Makefile              |    6 +-
 arch/arm64/kvm/hyp/nvhe/alloc_mgt.c           |    2 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  114 ++
 arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c   | 1390 +++++++++++++++++
 .../arm64/kvm/hyp/nvhe/iommu/io-pgtable-arm.c |  153 ++
 arch/arm64/kvm/hyp/nvhe/iommu/iommu.c         |  490 ++++++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         |  133 +-
 arch/arm64/kvm/hyp/nvhe/mm.c                  |   17 +
 arch/arm64/kvm/hyp/nvhe/power/hvc.c           |   47 +
 arch/arm64/kvm/hyp/nvhe/power/scmi.c          |  231 +++
 arch/arm64/kvm/hyp/nvhe/setup.c               |    9 +
 arch/arm64/kvm/hyp/nvhe/timer-sr.c            |   42 +
 arch/arm64/kvm/iommu.c                        |   89 ++
 arch/arm64/kvm/mmu.c                          |   20 +
 arch/arm64/kvm/pkvm.c                         |   20 +
 drivers/gpu/drm/msm/msm_iommu.c               |    5 +-
 drivers/iommu/Kconfig                         |    9 +
 drivers/iommu/Makefile                        |    2 +-
 drivers/iommu/arm/arm-smmu-v3/Makefile        |    7 +
 .../arm/arm-smmu-v3/arm-smmu-v3-common.c      |  824 ++++++++++
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c   | 1093 +++++++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  989 +-----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  758 +++------
 drivers/iommu/io-pgtable-arm-common.c         |  929 +++++++++++
 drivers/iommu/io-pgtable-arm.c                | 1061 +------------
 drivers/iommu/io-pgtable-arm.h                |   30 -
 drivers/iommu/io-pgtable.c                    |   15 +
 drivers/iommu/iommu.c                         |   53 +-
 include/kvm/arm_smmu_v3.h                     |   46 +
 include/kvm/iommu.h                           |   59 +
 include/kvm/power_domain.h                    |   24 +
 include/linux/io-pgtable-arm.h                |  233 +++
 include/linux/io-pgtable.h                    |   38 +-
 include/linux/iommu.h                         |   43 +-
 46 files changed, 7169 insertions(+), 2608 deletions(-)
 create mode 100644 arch/arm64/include/asm/arm-smmu-v3-common.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/iommu.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
 create mode 100644 arch/arm64/kvm/hyp/nvhe/iommu/io-pgtable-arm.c
 create mode 100644 arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
 create mode 100644 arch/arm64/kvm/hyp/nvhe/power/hvc.c
 create mode 100644 arch/arm64/kvm/hyp/nvhe/power/scmi.c
 create mode 100644 arch/arm64/kvm/iommu.c
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common.c
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
 create mode 100644 drivers/iommu/io-pgtable-arm-common.c
 delete mode 100644 drivers/iommu/io-pgtable-arm.h
 create mode 100644 include/kvm/arm_smmu_v3.h
 create mode 100644 include/kvm/iommu.h
 create mode 100644 include/kvm/power_domain.h
 create mode 100644 include/linux/io-pgtable-arm.h

--=20
2.47.0.338.g60cca15819-goog


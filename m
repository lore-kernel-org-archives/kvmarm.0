Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B23939DBF9
	for <kvmarm@lists.linux.dev>; Fri,  1 May 2026 11:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777634387; cv=none; b=QEIfmzvUSSO7dunPdocSSHlY1dt2kfy1zGLIN1B+uHe0Q12E1dt+Hd/U8NmWyqrnZRhsbeO9BTD9cPy8c8uFacXoQAte6eiebElSRKFAyTeIHj1twafCNhRAMQvMhAVWqTuNRNT+uH4Gk85esae/o84nLhKKY01CoMoFwa97vHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777634387; c=relaxed/simple;
	bh=a7l0tjjKDWFABSCDQFyGvRK9SXNivegcz+Anu6dErts=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=ktOQPtg3Nzk6FPv+3etNe7jvxlqQYic7WpnH4f5jQqcKOkvw5OyLArSDHiCCBjuvDN+AbNTgIrlJfqb2L8hWBNPHGy/t4WRaxCOTCzoqKnZMPLpzZxBGj4o1nfoopYgD3vjDSBtcvk+cZCi2tpvONV+blBZ5ZYt47EL2KYI2s6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aiWICx/X; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aiWICx/X"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b8ff07df5e4so156339766b.3
        for <kvmarm@lists.linux.dev>; Fri, 01 May 2026 04:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777634384; x=1778239184; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=39s63gE+FaRnrwSJ1nF07Frvg2b04cpO6BVgy2OjLZw=;
        b=aiWICx/XY+6Gf9uskqKMFJVfpCsPW/eNI7tkNl5cIgCSapOI8/TJhkkmnyWu8VucGt
         m9ggYMbRlVyBkgPgGj5jNR7OR9JAbUgPJlczvC0oR5bA8bvUl6UaWnK4XS1xe6M/IIzq
         lcN8e3ottibV7l/dvjXJW5BYPoVY1JdCBe4h5BkpIviFz+DYjs65ThUkqWCnfJLsYsEA
         1iLao/KSdiTAZe/qRm4V+Ec7Ubyg2HJkXGwdc0XBTKLK+dlmijgPSrV5u99Zgsw+ycnM
         q8Csxebub4SHWWZ7tdUedlFyiCCtB4aFAs+kq2Jze68ysXdiw1ATn+2HZGYiljTtV4L/
         1l9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777634384; x=1778239184;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=39s63gE+FaRnrwSJ1nF07Frvg2b04cpO6BVgy2OjLZw=;
        b=VfSeuoggSps/R96H9j8jhXtlpJOLTjsVZvdaN3fRX1DsS7fSo4hwSYPvP+rFDVC3qe
         9YyZgZYDEu0S4ip3KhltE1XGJ/1K9oevRpFHgxSPrZ7kH5RHJwiTU6ngbCqwFI1RCKEB
         q0LfOQ+A/wtQBqB7KWUCCV/OG9VobXnGOEJRwaJnXeK3HQJRb7k8aJ7v8vDH/JPSsn6r
         eSMQw494i53ECR/agAKfkIn6/zGZElk6iL1nOy87aIn+WMjOz3sLGHz657CSKEE8apA6
         UhuL9I8Jz/0Z3HoTrA7rD89BxCR4LQRYwNWExQabmcFzn+CNL7llqdR4ID/EWMfp2JeA
         5+yQ==
X-Forwarded-Encrypted: i=1; AFNElJ8IdKJedbTr4WD3dULsIDgENyLW5YxDcQoKnQXe+Q2hoIukccQ6EFrkUxTu8HhgbOut6n2RtVg=@lists.linux.dev
X-Gm-Message-State: AOJu0YxVpVt0WP+4wukF15zuJVpXcdjY2VCeAz+Os3ivWWl+tKLl75Is
	+VB8/GKQe4Qu8eHzH0pq0dRhxRJFlS+o8iPXObDqxYk9iGLGocRnD7D6HDBu2KW4QnmAchlyhE0
	5zjWSnsMWyGpFiA==
X-Received: from ejcqw28.prod.google.com ([2002:a17:906:6a1c:b0:ba5:6ff2:e915])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:980d:b0:bab:ba5a:fcb8 with SMTP id a640c23a62f3a-bbac7e8405emr444971866b.32.1777634384133;
 Fri, 01 May 2026 04:19:44 -0700 (PDT)
Date: Fri,  1 May 2026 11:19:02 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260501111928.259252-1-smostafa@google.com>
Subject: [PATCH v6 00/25] KVM: arm64: SMMUv3 driver for pKVM (trap and emulate)
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org, jgg@ziepe.ca, 
	mark.rutland@arm.com, qperret@google.com, tabba@google.com, 
	vdonnefort@google.com, sebastianene@google.com, keirf@google.com, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This is v6 of pKVM SMMUv3 support with trap and emulate

v1: Implements full fledged pv interface
https://lore.kernel.org/kvmarm/20230201125328.2186498-1-jean-philippe@linar=
o.org/

v2:  Implements full fledged pv interface (+ more features as evtq and s1)
https://lore.kernel.org/kvmarm/20241212180423.1578358-1-smostafa@google.com=
/

v3: Only DMA isolation (using pv)
https://lore.kernel.org/kvmarm/20250728175316.3706196-1-smostafa@google.com=
/

v4: Trap and emulate
https://lore.kernel.org/all/20250819215156.2494305-1-smostafa@google.com/

v5: Trap and emulate
https://lore.kernel.org/all/20251117184815.1027271-1-smostafa@google.com/


This series is based on the review feedback on v5 + improvements,
most notably:
- Rebase on ToT which includes the newly merged protected VM support!
- Drop non-coherent support to make the patches smaller, this can be
  added in a later series.
- Re-work the io-pgtable-arm split to rely on iommu-pages [Jason]
- Use the newly added clock for tracing instead of adding new
  functions in the hypervisor.
- Align nesting support with the upstream driver in terms of
  supported IPs [Jason]
- Keep STE hiltless updating when possible [Jason]
- Move some of the refactored code to the c file [Jason]
- Add support for evtq and priq tracking
- Add extra hardening checks, handle failures and massively reduce the
  amount of WARN_ONs and other cleanups.
- Don=E2=80=99t enforce DMA isolation to not regress pKVM booting.

Notes about Sashiko
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
I ran Sashiko locally and it was helpful in discovering problems in
the series. However, it still shows large number of critical and high
severity issues, I went through them and I believe they are false
positive, mainly because (in the order of frequently reported):
- It doesn=E2=80=99t understand de-privilege and which data is trusted that
  the driver populated at boot (keeps complaining about missing checks
  for zero mmio size..)
- It doesn=E2=80=99t understand WARNs are fatal in the hypervisor.
- It doesn=E2=80=99t understand that a malicious host can DoS the system an=
d
  pKVM doesn=E2=80=99t guarantee availability
- It doesn=E2=80=99t understand the SMMUv3 spec and makes stuff up (eg.  ab=
out
  CMD_SYC CS field it makes up an non-existent encoding or wrong
  semantics for the gbpa register)
- It seems to look at one patch at a time and not the whole series, and
  as the series is written in a way to be bisectable that confuses it.
- Sometimes it complains about code which is not related to the change.

Fuad is currently working on updating review prompts to make it work better
with protected KVM [1]

Design:
=3D=3D=3D=3D=3D=3D=3D
Assumptions:
------------
One of the important points, is that this doesn=E2=80=99t emulate the full
SMMUv3 architecture, but only the parts used by Linux kernel,
that=E2=80=99s why enablement of this (ARM_SMMU_V3_PKVM) depends on
(ARM_SMMU_V3=3Dy) so we are sure of the driver behaviour.

Any new change in the driver will likely trigger a WARN_ON ending up
in panic, that will require to support also in the hypervisor.

Most notable assumptions:
- Changing of stream table format/size or l2 pointers is not allowed
  after initialization.
- leaf=3D0 CFGI is not allowed.
- CFGI_ALL with any value but 31 is not allowed.
- Some commands which are not used are not allowed.
- Values set in ARM_SMMU_CR1 are hardcoded and don't change.

Emulation logic mainly targets:

1) Command Queue
----------------
At boot time, the hypervisor will allocate a shadow command queue
(doesn=E2=80=99t need to match the host size) which then sets up in HW, the=
n
it will trap access to

i) ARM_SMMU_CMDQ_BASE
That can only be written when the cmdq is disabled. Then on enable,
the hypervisor will put the host command queue in a shared state to
avoid transition into the hypervisor or VMs. It will be unshared with
the cmdq is disabled

ii) ARM_SMMU_CMDQ_PROD
Trigger emulation code, where the hypervisor will copy the commands
between cons and prod, of the host queue and sanitise them (mostly
WARNs if the host is malicious and issuing commands it shouldn=E2=80=99t)
then eagerly consume them, updating the host cons.

iii) ARM_SMMU_CMDQ_CONS
No much logic, just return the emulated cons + error bits.

2) Stream table
---------------
Similar to the command queue, the first level is allocated at boot
with max possible size, then the hypervisor  will trap access to:
i) ARM_SMMU_STRTAB_BASE/ARM_SMMU_STRTAB_BASE_CFG: Keep track of
   the stream table to put it in a shared state.

On CFGI_STE, the hypervisor will read the STE in scope from the host
copy, shadow L2 pointers if needed and attach stage-2.

3) GBPA
-------
The hypervisor will set GBPA to abort at boot, then any read from the
host will return ABORT and writes are ignored.
If the host tries to clear GBPA, it will look like GBPA is refusing
to update and time out.

4) EVTQ and PRIDQ
No shadowing needed for those queues, but the hypervisor needs to keep
track of them to put them in a shared state so they can=E2=80=99t be used b=
y
the host or the hypervisor.

Bisectibility:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
I wrote the patches where most of them are bisectable at run time (so
we can run with a prefix of the series till MMIO emulation, cmdq
emulation, STE or full nested) that was very helpful in debugging,
and I kept it like this to make debugging easier.

Constraints:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
1) Discovery:
-------------
Only device trees are supported at the moment.
I don=E2=80=99t usually use ACPI, but I can look into adding that later.
(not make this series bigger)

1) Shadow page table
--------------------
Uses page granularity (leaf) for memory, that=E2=80=99s because of the lack
of split_block_unmap() logic. I am currently looking into the
possibility of sharing page tables, if that turned complicated (as
expected) it might be worth to re-add this logic

Boot and Probe ordering:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
The main SMMUv3 MUST be only bound/probed after KVM fully initialises
so it can set up the MMIO emulation.

The KVM SMMUv3 driver is loaded early before KVM init so it can
register itself, during that point it will probe all the SMMUs from the
platform bus and bind them to the driver.

Then at a later init call it will create an auxiliary device per SMMU,
that the main driver will probe. The main driver still relies on this
device(parent) for all driver activity. (Check comment in patch 14.

Future work
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
1) Sharing page tables will be an interesting optimization, but
   requires dealing with stage-2 page faults (which are handled
   by the kernel), BBM and possibly more complexity.

2) There is currently ongoing work to enable RPM, that will possibly
   enable/disable the SMMU frequently, we might need some optimizations
   to avoid re-shadowing the CMDQ/STE unnecessarily.

3) Add support for non-coherent SMMUs

4) Optimizations (as using block mappings for memory)

Patches overview
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
The patches are split as follows:

Patches 01-02: Core hypervisor: Dealing with MMIO and timers.
Patches 04-06: Refactoring of io-pgtable-arm and SMMUv3 driver.
Patches 07-10: Hypervisor IOMMU core: pagetable management, dabts.
Patches 11-25: KVM SMMUv3 code.

Tested on Lenovo IdeaCentre mini X and Qemu.

A development branch can be found at [2]

[1] https://github.com/ftabba/review-prompts/commits/local-arm64-kvm/
[2] https://android-kvm.googlesource.com/linux/+/refs/heads/pkvm-smmu-v6


Jean-Philippe Brucker (1):
  iommu/arm-smmu-v3-kvm: Add SMMUv3 driver

Mostafa Saleh (24):
  KVM: arm64: Generalize trace clock
  KVM: arm64: Donate MMIO to the hypervisor
  iommu/arm-smmu-v3: Split code with hyp
  iommu/arm-smmu-v3: Move TLB range invalidation into common code
  iommu/arm-smmu-v3: Move IDR parsing to common functions
  iommu/io-pgtable-arm: Rework to use the iommu-pages API
  KVM: arm64: iommu: Introduce IOMMU driver infrastructure
  KVM: arm64: iommu: Shadow host stage-2 page table
  KVM: arm64: iommu: Add memory pool
  KVM: arm64: iommu: Support DABT for IOMMU
  iommu/arm-smmu-v3-kvm: Add the kernel driver
  iommu/arm-smmu-v3-kvm: Probe SMMU HW
  iommu/arm-smmu-v3-kvm: Add MMIO emulation
  iommu/arm-smmu-v3-kvm: Shadow the command queue
  iommu/arm-smmu-v3-kvm: Add CMDQ functions
  iommu/arm-smmu-v3-kvm: Emulate CMDQ for host
  iommu/arm-smmu-v3-kvm: Shadow stream table
  iommu/arm-smmu-v3-kvm: Shadow STEs
  iommu/arm-smmu-v3-kvm: Share other queues
  iommu/arm-smmu-v3-kvm: Emulate GBPA
  iommu/io-pgtable-arm: Support io-pgtable-arm in the hypervisor
  iommu/arm-smmu-v3-kvm: Shadow the CPU stage-2 page table
  iommu/arm-smmu-v3-kvm: Enable nesting
  KVM: arm64: Add documentation for pKVM DMA isolation

 .../admin-guide/kernel-parameters.txt         |    4 +
 Documentation/virt/kvm/arm/pkvm.rst           |   19 +-
 arch/arm64/include/asm/kvm_host.h             |    6 +
 arch/arm64/kvm/Makefile                       |    2 +-
 arch/arm64/kvm/hyp/include/nvhe/clock.h       |   11 +-
 arch/arm64/kvm/hyp/include/nvhe/iommu.h       |   23 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |    4 +
 arch/arm64/kvm/hyp/nvhe/Makefile              |   13 +-
 arch/arm64/kvm/hyp/nvhe/clock.c               |   44 +-
 arch/arm64/kvm/hyp/nvhe/iommu/iommu.c         |  156 ++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         |  169 ++-
 arch/arm64/kvm/hyp/nvhe/setup.c               |   20 +
 arch/arm64/kvm/hyp/nvhe/trace.c               |    4 +-
 arch/arm64/kvm/hyp/pgtable.c                  |    9 +-
 arch/arm64/kvm/iommu.c                        |   57 +
 arch/arm64/kvm/pkvm.c                         |    1 +
 drivers/iommu/arm/Kconfig                     |    9 +
 drivers/iommu/arm/arm-smmu-v3/Makefile        |    3 +-
 .../arm/arm-smmu-v3/arm-smmu-v3-common-lib.c  |  224 +++
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c   |  232 +++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  387 +----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  150 ++
 .../iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c  | 1250 +++++++++++++++++
 .../iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h  |   67 +
 drivers/iommu/io-pgtable-arm.c                |   68 +-
 drivers/iommu/io-pgtable-arm.h                |    6 +
 drivers/iommu/iommu-pages.h                   |   99 ++
 27 files changed, 2668 insertions(+), 369 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/iommu.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
 create mode 100644 arch/arm64/kvm/iommu.c
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common-lib.c
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h

--=20
2.54.0.545.g6539524ca2-goog


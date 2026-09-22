Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34C7430CEC
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 13:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790082787; cv=none; b=cIiXun+sz5JTtS22JPxkQEG7uGwDEnfS5rAXu/C9DXO7JUHhcrR05mrRxl589JbWTDVsdPMdTyqwb1Z1bSry9tfqr0oiFj3uk1C+m1ETYhm+6YofeZHFmylhWzNLWmZjw49NfEvMlCn3TmxSOCDKrpfMPmmZtAmHaZbzO10Xfpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790082787; c=relaxed/simple;
	bh=pVjyIu0kXnDhjx3DniHHtuHEwZ3F8cMzRKvHX5tGWdY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=UvT5ToNYRLCgo2D0LFRjkKVrIPMmjC2lq+KZPNGKToE5ESUErrOquYjwMMNEeVpjrq72gmZWQLtZQdOig0nYIbU4UEkzmADSMTMylKANdiqduBBMXOrHhnNkXbWq9+8WkAcmB5v4lMayOHECXCpef03fJTMivtNi64adE1AMk7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Waker2by; arc=none smtp.client-ip=209.85.208.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Waker2by"
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-6a9b4e3987aso5053730a12.3
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 06:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790082783; x=1790687583; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=eWCrskNiAleudFFxBYgMjk1A9BS0wLHQijBLHdv5uys=;
        b=Waker2by1rw84zBwFe+9BUj85rF6n9DXRjMDy08375xZXj5dK+KxpvDI1IMY9XsH1j
         FpEAHJ9r8C5tMP5pqceXvLHYSwa7AxwkwwjgxK1+1trnxqI3Mpl0UXlbIGtf48lSx0Vq
         9UoDmMAAseu6ao7OsSooTTmwOpiWOjVn0KPNchbSz97dGrsxBJerWPvz57fbW4p7iill
         xCwClMZtCZUUhUAtZgLyVTfVXctHxclpiCm1rxjHSjbx/FQgCZo36NdvKsVkboaOcJ+m
         q4YuSkKdt/bV3I2stgg719SM8ZiUA3HVlWlaEIqUrAIfIdVsMSet+TGetKNdZgWDYB/O
         IkMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790082783; x=1790687583;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eWCrskNiAleudFFxBYgMjk1A9BS0wLHQijBLHdv5uys=;
        b=mBpeHzBo1lrnb0WzZMjyHwgsYrpo/+2pms3pOdO/JAj+md2cRNu6IzuihhCpuMa2pi
         gnytG1yUqhPaB7XcrGzhbAZQiAjjWNb3NXOtRXpaZ9EESBPX8KvSuix92b7TZU5zDrR5
         Zk3t3KYwEJh8J2XuB88woWRI59E3tFRAg6wXGxXcrWcVDS1pJh6krI+nJ30JtzLeyv7O
         f7cRghPIHil7nT+sZZCX6ZyGvFfZ4rtJtToyHTnfdCt7xiViwFbVtG8esdAGigi2xTtu
         Y1w/J7ruExf3/m0pDTBz/XqDxJIvsnDa79OZGAXoxtireaI6fYwuXkK2cFdb7QIadM4o
         jhnw==
X-Forwarded-Encrypted: i=1; AKwUvBysADWfXBS+oB7zklf0rKGLW/WRLT9vk1jsV+1ofhpbCr+LOeEwSQO/gOy9X8vTQYOxrkAFN6w=@lists.linux.dev
X-Gm-Message-State: AFuF++lNgxzxcbmWnZGKQlY7w6adrgJROq4GCkYCK3zPpMb093CDVqJb
	C8wfeB7IUZ/u+5osRDgt5qobr0cCgKNfp8T9kSlgg3kG9lIkbX9dxDnDjAMk+Uc/xwRiUnmYSmK
	446pfhffP9eVD3Q==
X-Received: from edvt20.prod.google.com ([2002:a05:6402:214:b0:6a3:64db:ff2])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:5003:b0:6a9:dfd4:811f with SMTP id 4fb4d7f45d1cf-6aa579997a6mr11277387a12.42.1790082782443;
 Tue, 22 Sep 2026 06:13:02 -0700 (PDT)
Date: Tue, 22 Sep 2026 13:12:33 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260922131259.2975334-1-smostafa@google.com>
Subject: [PATCH v8 00/25] KVM: arm64: SMMUv3 driver for pKVM (trap and emulate)
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca, mark.rutland@arm.com, 
	qperret@google.com, tabba@google.com, vdonnefort@google.com, 
	sebastianene@google.com, keirf@google.com, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Changes from v7:
v7: https://lore.kernel.org/all/20260715115906.2664882-1-smostafa@google.co=
m/
- Use pfn, nr_pages instead of addr, size in MMIO functions [Vincent]
- Inline system timer handling in the driver [Vincent]
- Update comments [Fuad]
- Remove TLB invalidation re-use and introduce helpers instead [Jason]
- Implement  a different TLB algorithm for the hypervisor based on 2
  overlapping commands as currently on the list.
- Rely on macro tricks to reuse more functions between drivers [Jason]
- Use the hitless machinery for the hypervisor STE updates [Jason]
- Fixed an issue with small command queue sizes.
- Update and rename patches message to be more clear.

Notes about Sashiko
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
I ran Sashiko locally and it was helpful in discovering problems in
the series. However, it still shows large number of critical and high
severity issues, I went through them and I believe they are false
positives, mainly because (in the order of frequently reported):
- It doesn't understand WARNs are fatal in the hypervisor.
- It doesn't understand that a malicious host can DoS the system and
  pKVM doesn't guarantee availability
- It doesn't understand the SMMUv3 spec and makes stuff up (eg. about
  CMD_SYC CS field it makes up an non-existent encoding or wrong
  semantics for the gbpa register)
- It seems to look at one patch at a time and not the whole series, and
  as the series is written in a way to be bisectable that confuses it.

Design:
=3D=3D=3D=3D=3D=3D=3D
Assumptions:
------------
One of the important points, is that this doesn=E2=80=99t emulate the full
SMMUv3 architecture, but only the parts used by Linux kernel.
That=E2=80=99s why enablement of this (ARM_SMMU_V3_PKVM) depends on
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
(doesn't need to match the host size) which then sets up in HW, then
it will trap access to

i) ARM_SMMU_CMDQ_BASE
That can only be written when the cmdq is disabled. Then on enable,
the hypervisor will put the host command queue in a shared state to
avoid transition into the hypervisor or VMs. It will be unshared with
the cmdq is disabled

ii) ARM_SMMU_CMDQ_PROD
Trigger emulation code, where the hypervisor will copy the commands
between cons and prod, of the host queue and sanitise them (mostly
WARNs if the host is malicious and issuing commands it shouldn't)
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

2) Shadow page table
--------------------
Uses page granularity (leaf) for memory, that's because of the lack
of split_block_unmap() logic.

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
   has many challenges, I have a prototype for that I plan to send
   it will be group related series, starting with BBML3 which is
   already posted [1]. I also have a talk in the KVM MC in LPC 2026
   about this.

2) There is currently ongoing work to enable RPM, that will possibly
   enable/disable the SMMU frequently, we might need some optimizations
   to avoid re-shadowing the CMDQ/STE unnecessarily.

3) Add support for non-coherent SMMUs.

4) Optimizations (as using block mappings for memory).

Patches overview
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
The patches are split as follows:

Patches 01: Core hypervisor: Dealing with MMIO and timers.
Patches 02-05: Refactoring of io-pgtable-arm and SMMUv3 driver.
Patches 06-09: Hypervisor IOMMU core: pagetable management, dabts.
Patches 10-25: KVM SMMUv3 code.

Tested on Lenovo IdeaCentre mini X and Qemu.

A development branch can be found at [2]

[1] https://lore.kernel.org/all/20260904132855.638117-1-smostafa@google.com=
/
[2] https://android-kvm.googlesource.com/linux/+/refs/heads/kvm-smmu-v8

Jean-Philippe Brucker (1):
  iommu/arm-smmu-v3-kvm: Add SMMUv3 driver

Mostafa Saleh (24):
  KVM: arm64: Donate MMIO to the hypervisor
  iommu/arm-smmu-v3: Move Queue and STE functions to header
  iommu/arm-smmu-v3: Introduce RangeInval encoding helpers
  iommu/arm-smmu-v3: Move IDR parsing to common functions
  iommu/arm-smmu-v3: Move hitless machinery to common code
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
  iommu/arm-smmu-v3-kvm: Invalidate the SMMU TLBs
  iommu/arm-smmu-v3-kvm: Enable nesting
  KVM: arm64: Add documentation for pKVM DMA isolation

 .../admin-guide/kernel-parameters.txt         |    5 +
 Documentation/virt/kvm/arm/pkvm.rst           |   23 +-
 arch/arm64/include/asm/kvm_host.h             |    6 +
 arch/arm64/include/asm/kvm_pgtable.h          |    1 +
 arch/arm64/kvm/Makefile                       |    2 +-
 arch/arm64/kvm/hyp/include/nvhe/iommu.h       |   24 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |    7 +
 arch/arm64/kvm/hyp/nvhe/Makefile              |    9 +-
 arch/arm64/kvm/hyp/nvhe/iommu.c               |  174 ++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         |  135 +-
 arch/arm64/kvm/hyp/nvhe/setup.c               |   19 +
 arch/arm64/kvm/hyp/pgtable.c                  |   11 +-
 arch/arm64/kvm/iommu.c                        |   64 +
 arch/arm64/kvm/pkvm.c                         |    1 +
 drivers/iommu/arm/Kconfig                     |   12 +
 drivers/iommu/arm/arm-smmu-v3/Makefile        |    3 +-
 .../arm/arm-smmu-v3/arm-smmu-v3-common-lib.c  |  416 +++++
 .../arm/arm-smmu-v3/arm-smmu-v3-common-lib.h  |   41 +
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c   |  231 +++
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  |    1 +
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  561 +------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  107 +-
 .../arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.h    |   79 +
 .../iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c  | 1430 +++++++++++++++++
 .../arm/arm-smmu-v3/pkvm/io-pgtable-arm-hyp.h |   86 +
 drivers/iommu/io-pgtable-arm.c                |   14 +-
 drivers/iommu/io-pgtable-arm.h                |    9 +
 27 files changed, 2960 insertions(+), 511 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/iommu.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/iommu.c
 create mode 100644 arch/arm64/kvm/iommu.c
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common-lib.c
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common-lib.h
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.h
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/pkvm/io-pgtable-arm-hyp.h


base-commit: f0100363d8c374bd8e9ea7c9ba02744f0b802ca4
--=20
2.55.0.1082.g2b9226bbc0-goog


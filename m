Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC2132EB85C
	for <kvmarm@lists.linux.dev>; Tue, 19 Aug 2025 21:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755640346; cv=none; b=uO+Fp3eDn0QNzgbhfPqg2C5U20hLJCigDlvLcqDRJZnZ9IMl54Mk4Gf5ai00dfUEAeo5CkeEvVCQ41gcXQzgCqpO5BE4V+rffkm9fUDgw5NY7gJgaoV8Yg223fBf/iX+ILe6aDCnDoNaJiyPzLB1TeKeIXx/2MkBxVJTyByhi/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755640346; c=relaxed/simple;
	bh=CbR3S6cznnisg77rj4gvJVHl8SFaVWWDohwNuQc1CT0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=A6PaGsF7sXyDbz7KT3bwF0uV4zMfg3CLTXVNqn8nA8wahCtEIWSE74Ur/tE39xUlFoplWjn+4NQeM/z8rXejbOTXiprK2hL4m55tCAlye/M06onN7ikg0FTxsaIF8RXib9SrotBycgyleXKynN/RwRPp3B2SuMaSsZ6dJXJnvGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qN1Nrdkl; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qN1Nrdkl"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-afcb7a5d28eso406315766b.2
        for <kvmarm@lists.linux.dev>; Tue, 19 Aug 2025 14:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755640343; x=1756245143; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZrHJk9887AX1HHtKZNq/61idp0TzV0k4BhIgbcGBx4w=;
        b=qN1NrdklAYCGWpSKalfAQ6as0jsorggV8x3oNOCD1Ian+Q/l0VauckqlFMdECkmbpK
         e7bB+9oJhJ2gc5vnieXjtjDFc0pn4NZpyKdzApKxraP+fpHIOLdpaz1YYBvW931GqfIx
         v4qUffPvt9ylz1WJaWh4dwkUoGTJnLsywuwvBCl9P/grAxsvUDCCgqNqdEeH3eYvdlpZ
         fmFKnohqoc6D/GP4uFFvLYttDDG0nZg8676ntZbueMGUSxgUmgnjKke1qZEyNT5a2HWx
         pG5W+37qe4Ij4f3H+8puO9b4ersJpiFA8Rp8pVNXsPFqaVxB6+/nyVMj8DeIErUooVsk
         IcVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755640343; x=1756245143;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZrHJk9887AX1HHtKZNq/61idp0TzV0k4BhIgbcGBx4w=;
        b=HjZ2SSwVADnPnq2WUTreG4MtmmYSoij4mFW69jf8Cv9A8gFFE3tAA9fSVSf6K9seo8
         xzjA0TQl6TREF5S1KNrPC2bFXRwCvblAg3Dm7pL86/n8doNWWRPdZjOJC3R4pyyrHn0O
         m+AncPSkZ4OSOoOmxc+rc9fGtpsfFXj1CPZsFMAQDn+DNtX+npmjoXOqT3xuy3t7sx8P
         5S6T3IioeoMg2t/QnIn+n8eu0tlZ8UWUo3EGnE73MyGma1TpOmGk5PJOhH1VOCz2HOFs
         wZJe1r8CRG/gb5D80k6a9mzLsLoJPBtExPxnF2VEtDqYsQJwOqaPczLJde6DCNlRUJIK
         u4bw==
X-Forwarded-Encrypted: i=1; AJvYcCVHMk2S1fiOGomDF+JxAuS+EVNchOLnQ2dKxf1NEEz5tU2frnzOg2p2CcG02IraQDjDiLc6/cY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw3PN91YOlz1gK23yyES9Ty6cSDYEoac8tuZjW76woeD8DWPvBx
	56sIyF4zmd1Z+2D8IpXo9sVLCySjHk2sS2MR0oE9ivL279TkwM/C4X3ubpEfyG85ElOiIIxHfuO
	bj+RfqrCAOYfC+g==
X-Google-Smtp-Source: AGHT+IGoEEbJ2keRX3c8rzT1Ww2isK1cL8gYsZ5NqJ5GccWyDWzyWtYPdlql7UJ8EQPEpyvX4jzA2yJKWHjrhg==
X-Received: from ejvs17.prod.google.com ([2002:a17:906:bc51:b0:afd:efcc:6f5c])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:72c8:b0:af9:5ca0:e4fe with SMTP id a640c23a62f3a-afdf02dc4f9mr40079066b.56.1755640343180;
 Tue, 19 Aug 2025 14:52:23 -0700 (PDT)
Date: Tue, 19 Aug 2025 21:51:28 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.rc1.167.g924127e9c0-goog
Message-ID: <20250819215156.2494305-1-smostafa@google.com>
Subject: [PATCH v4 00/28] KVM: arm64: SMMUv3 driver for pKVM (trap and emulate)
From: Mostafa Saleh <smostafa@google.com>
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, robin.murphy@arm.com, jean-philippe@linaro.org, 
	qperret@google.com, tabba@google.com, jgg@ziepe.ca, mark.rutland@arm.com, 
	praan@google.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This is v4 of pKVM SMMUv3 support, this version is quite different from
the previous ones as it implements nested SMMUv3 using trap and emulate:
v1: Implements full fledged pv interface
https://lore.kernel.org/kvmarm/20230201125328.2186498-1-jean-philippe@linar=
o.org/

v2:  Implements full fledged pv interface (+ more features as evtq and s1)
https://lore.kernel.org/kvmarm/20241212180423.1578358-1-smostafa@google.com=
/

v3: Only DMA isolation (using pv)
https://lore.kernel.org/kvmarm/20250728175316.3706196-1-smostafa@google.com=
/

Based on the feedback on v3, having a separate driver was too complicated
to maintain. So, the alternatives were either to integrate the KVM
implementation in the current driver and rely on impl ops, I have PoC for i=
t:
https://android-kvm.googlesource.com/linux/+log/refs/heads/pkvm-smmu-implop=
s-poc

Or just go for the final goal which is nested translation using trap and
emulate which is implemented in this series.

Other major changes, is that io-pgtable-arm is not split to a common file,
however kernel specific code was factored out (mostly memory allocation
and selftests) based on Robin feedback.

Design:
=3D=3D=3D=3D=3D=3D=3D

Assumptions:
------------

As mentioned, this is a completely different approach which uses trapping
of the SMMUv3 MMIO space and emulating some of these accesses.

One of the important points, is that this doesn=E2=80=99t emulate the full =
SMMUv3
architecture, but only the parts used by Linux kernel, that=E2=80=99s why e=
nablement
of this (ARM_SMMU_V3_PKVM) depends on (ARM_SMMU_V3=3Dy) so we are sure of t=
he
driver behaviour.

Any new change in the driver will likely trigger a WARN_ON ending up in pan=
ic.

Most notable assumptions:
- Changing of stream table format/size or l2 pointers is not allowed after
initialization.
- leaf=3D0 CFGI is not allowed
- CFGI_ALL with any value but 31 is not allowed
- Some commands which are not used are not allowed (ex CMD_TLBI_NH_ALL)
- Values set in ARM_SMMU_CR1 are hardcoded and don't change.


Emulation logic mainly targets:

1) Command Queue
----------------
At boot time, the hypervisor will allocate a shadow command queue (doesn=E2=
=80=99t need
to match the host size) which then sets up in HW, then it will trap access =
to

i) ARM_SMMU_CMDQ_BASE
That can only be written when the cmdq is disabled. Then on enable, the hyp=
ervisor
will put the host command queue in a shared state to avoid transition into =
the
hypervisor or VMs. It will be unshared with the cmdq is disabled

ii) ARM_SMMU_CMDQ_PROD
Trigger emulation code, where the hypervisor will copy the commands between=
 cons and
prod, of the host queue and sanitise them (mostly WARNs if the host is mali=
cious and
issuing commands it shouldn=E2=80=99t) then eagerly consume them, updating =
the host cons.

iii) ARM_SMMU_CMDQ_CONS
No much logic, just return the emulated cons + error bits.

2) Stream table
---------------
Similar to the command queue, the first level is allocated at boot with max=
 possible
size, then the hypervisor  will trap access to:
i) ARM_SMMU_STRTAB_BASE/ARM_SMMU_STRTAB_BASE_CFG: Keep track of the stream =
table to
put it in a shared state.

On CFGI_STE, the hypervisor will read the STE in scope from the host copy, =
shadow
L2 pointers if needed and attach stage-2.

3) GBPA
-------
The hypervisor will set GBPA to abort at boot, then any access to GBPA from=
 the host
will return the value set by the host. The host only sets ABORT so that is =
fine.
Otherwise we can always return ABORT is set even if not which makes it look=
 like HW
is not responding to updates.


Bisectibility:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
I wrote the patches where most of them are bisectable at run time (so we ca=
n run
with a prefix of the series till MMIO emulation, cmdq emulation, STE or ful=
l nested)
that was very helpful in debugging, and I kept like this to make debugging =
easier.

Constraints:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
1) Discovery:
-------------
Only device tree is supported at the moment.
I don=E2=80=99t usually use ACPI, but I can look into adding that later. (n=
ot make this
series bigger)

2) Errata:
----------
Some HW with both stage-1 and stage-2 but can=E2=80=99t run nested translat=
ion due to some errata,
which makes the driver remove nesting for MMU_700, I believe this is too re=
strictive.
At the moment KVM will use nesting if advertised. (Or we need other mechani=
sm to exclude
only the affected HW)

3) Shadow page table
--------------------
Uses page granularity (leaf) for memory, that=E2=80=99s because of the lack=
 of split_block_unmap()
logic. I am currently looking into the possibility of sharing page tables,
if that turned complicated (as expected) it might be worth to re-add this l=
ogic

Boot flow:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
The hypervisor initialises at =E2=80=9Cmodule_init=E2=80=9D.
Before that, at =E2=80=9Ccore_initcall=E2=80=9D the SMMUv3 KVM code will
- Register the hypervisor ops with the hypervisor
- Parse the device tree and populate an array with the SMMUs to the hypervi=
sor.

At =E2=80=9Cmodule_init=E2=80=9D, the hypervisor init will run, where the S=
MMU driver will:
- Take over the SMMus description
- Probe the SMMUs (from IDRs) I tried to make most of this code common usin=
g macros.
- Take over the SMMUs MMIO space so it will be trapped.
- Take over and set up the shadow command queue and stream table.

With =E2=80=9CARM_SMMU_V3_PKVM=E2=80=9D enabled, the current SMMU driver wi=
ll register at
=E2=80=9Cdevice_initcall_sync=E2=80=9D so it can run after the kernel de-pr=
ivileges and the
hypervisor is set up.

Future work
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
1) Sharing page tables will be an interesting optimization, but requires de=
aling with
stage-2 page faults (which are handled by the kernel), BBM and possibly mor=
e complexity.

2) There is currently ongoing work to enable RPM, that will possibly enable=
/disable
the SMMU frequently, we might need some optimizations to avoid re-shadowing=
 the
CMDQ/STE unnecessarily.

3) Look into ACPI support.

Patches overview
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
The patches are split as follows:

Patches 01-03: Core hypervisor: Add donation for NC, dealing with MMIO,
               and arch timer abstraction.
Patches 04-08: Refactoring of io-pgtable-arm and SMMUv3 driver
Patches 09-12: Hypervisor IOMMU core: IOMMU pagetable management, dabts=E2=
=80=A6
Patches 13-28: KVM SMMUv3 code


Tested on Qemu(S1 only, S2 only and nested)  and Morello board.
Also tested with PAGE_SIZE 4k,16k, and 64k.

A development branch can be found in:
https://android-kvm.googlesource.com/linux/+log/refs/heads/pkvm-smmu-v4


Jean-Philippe Brucker (1):
  iommu/arm-smmu-v3-kvm: Add SMMUv3 driver

Mostafa Saleh (27):
  KVM: arm64: Add a new function to donate memory with prot
  KVM: arm64: Donate MMIO to the hypervisor
  KVM: arm64: pkvm: Add pkvm_time_get()
  iommu/io-pgtable-arm: Move selftests to a separate file
  iommu/io-pgtable-arm: Factor kernel specific code out
  iommu/arm-smmu-v3: Split code with hyp
  iommu/arm-smmu-v3: Move TLB range invalidation into a macro
  iommu/arm-smmu-v3: Move IDR parsing to common functions
  KVM: arm64: iommu: Introduce IOMMU driver infrastructure
  KVM: arm64: iommu: Shadow host stage-2 page table
  KVM: arm64: iommu: Add memory pool
  KVM: arm64: iommu: Support DABT for IOMMU
  iommu/arm-smmu-v3: Add KVM mode in the driver
  iommu/arm-smmu-v3: Load the driver later in KVM mode
  iommu/arm-smmu-v3-kvm: Create array for hyp SMMUv3
  iommu/arm-smmu-v3-kvm: Take over SMMUs
  iommu/arm-smmu-v3-kvm: Probe SMMU HW
  iommu/arm-smmu-v3-kvm: Add MMIO emulation
  iommu/arm-smmu-v3-kvm: Shadow the command queue
  iommu/arm-smmu-v3-kvm: Add CMDQ functions
  iommu/arm-smmu-v3-kvm: Emulate CMDQ for host
  iommu/arm-smmu-v3-kvm: Shadow stream table
  iommu/arm-smmu-v3-kvm: Shadow STEs
  iommu/arm-smmu-v3-kvm: Emulate GBPA
  iommu/arm-smmu-v3-kvm: Support io-pgtable
  iommu/arm-smmu-v3-kvm: Shadow the CPU stage-2 page table
  iommu/arm-smmu-v3-kvm: Enable nesting

 arch/arm64/include/asm/kvm_arm.h              |    2 +
 arch/arm64/include/asm/kvm_host.h             |    7 +
 arch/arm64/kvm/Makefile                       |    3 +-
 arch/arm64/kvm/hyp/include/nvhe/iommu.h       |   21 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |    3 +
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |    2 +
 arch/arm64/kvm/hyp/nvhe/Makefile              |   10 +-
 arch/arm64/kvm/hyp/nvhe/iommu/iommu.c         |  130 +++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         |   90 +-
 arch/arm64/kvm/hyp/nvhe/setup.c               |   17 +
 arch/arm64/kvm/hyp/nvhe/timer-sr.c            |   33 +
 arch/arm64/kvm/hyp/pgtable.c                  |    9 +-
 arch/arm64/kvm/iommu.c                        |   32 +
 arch/arm64/kvm/pkvm.c                         |    1 +
 drivers/iommu/Makefile                        |    2 +-
 drivers/iommu/arm/Kconfig                     |    9 +
 drivers/iommu/arm/arm-smmu-v3/Makefile        |    3 +-
 .../arm/arm-smmu-v3/arm-smmu-v3-common-hyp.c  |  114 ++
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c   |  158 +++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  342 +-----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  220 ++++
 .../iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c  | 1036 +++++++++++++++++
 .../iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h  |   67 ++
 .../arm/arm-smmu-v3/pkvm/io-pgtable-arm-hyp.c |   64 +
 drivers/iommu/io-pgtable-arm-kernel.c         |  305 +++++
 drivers/iommu/io-pgtable-arm.c                |  346 +-----
 drivers/iommu/io-pgtable-arm.h                |   66 ++
 27 files changed, 2439 insertions(+), 653 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/iommu.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
 create mode 100644 arch/arm64/kvm/iommu.c
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common-hyp.c
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/pkvm/io-pgtable-arm-hyp.c
 create mode 100644 drivers/iommu/io-pgtable-arm-kernel.c

--=20
2.51.0.rc1.167.g924127e9c0-goog


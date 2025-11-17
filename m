Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A957301483
	for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 18:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763405309; cv=none; b=aBPKSEPnDSuYcc96Rh0RIHGz44VH4fBJI0Ko8r2T750LIQxPD4xsHBA+13GTnOEUhxIQQfTFmfZcy+Jq2XoazutIwTJOaOToxyyceNiyxkZwK8Y6QqS0Max/Sy5qKiIe0NYoS/bcAAoX/vD/g4pP0hXUduB8x7n8VxeI1tPOwVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763405309; c=relaxed/simple;
	bh=RUJIGMKmFkkqnphzr4kemMR5y3/FyUV6BCm2ZQa4An0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Zp0bxEQpRu8xTlDMswFgfEtANtdRZCmaZu59YY0dRcDk52VuNhGuWxCeQd3YFk4dFemsC8FZmO7JrYJhfM0dKekiTncUXe1BIJ28tjZ4KGGVMZKQo+R5dTcpMLgce3jecu8ZiNUutswdzCyV+4A5c3TMqx8hrrvlQ7WWAMj5/HE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IsqOmh+L; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IsqOmh+L"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-42b2fb13b79so2204325f8f.3
        for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 10:48:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763405306; x=1764010106; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mQPdbRFOlFRQV2M3CnpwjihoUC+ROTyADJUsM+cRT4o=;
        b=IsqOmh+L4hDoh5GpwUICBuQKwaDS2ZNrbQdMsxrp73je33mZeC4W2TW8ZMYGNJlIIX
         GOVH5fFvuSvijurRPbSvdyq9f81DJlxF40CjIffCrbSd3wr0dDitkQLVRhCbkUWiok7M
         FzGoILnPTt0zo5dYBI5n0WZOge3MwAvxEPq7O1Fj/dfVGTBvqopdu1cICKG9DZ0GjmQC
         /Eu9H+tbhwvMXehqNSkk4m5PeaVInVmSTkvnouJtYM0NeLE7GYM1XQvOlkoKUqLyWewJ
         IrNoGNroZDA+vLC8Nx4VmiYBtgbyi4GrNxPCJy1juzS7VBV6rtgmSCapX/60bvlGsnJ8
         2arg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763405306; x=1764010106;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mQPdbRFOlFRQV2M3CnpwjihoUC+ROTyADJUsM+cRT4o=;
        b=OICmvhob2sBMLKKPq/KOi38qeSAs/TPOs1oTVSWlIq1E6qhyhaAKv/D+Z196L7m9zX
         /I4pDwTNV06ZaS7HjZtQ5BK1RbCF+gZdJxZ3PVeJk64BZoSTUncx2zolqB+iQoLewEyn
         0JSYZZV2MygU1lBywPfjARXaE38rfHjq0fjNLkHGfIshzLAYNa6GfEc0aYVWEjns2rYk
         /NJPv7b0b7TK0/jHIm8/A+kiR4lvb4SY+u6tIco+Ez9JCrXrh9mISs9HO/6kjXMNNPUk
         AXOd/hP9a5nZGXbBR5VQk3KjMwI14G9yqYwc+vrU6ow4ktLj9/3nYDWfLQfWAIMDEIY2
         kirQ==
X-Forwarded-Encrypted: i=1; AJvYcCVCd7rTczIo3bmpXPESq65NBt7q6CVfB9/2RzXF7b0w3KtX1buD5RlD/DcEIkjvMDEznXa01as=@lists.linux.dev
X-Gm-Message-State: AOJu0YzbSuM7OaFsFKTbQLZ8F0uVvUlqdf9c64nCziFpo/2YsRqjhNFl
	hTfGSiAMmiBlVbceaIOmnL00E+16EAvIdb3Ey5vs7faLr7Oru/gN+PlH7K5AJpmZ8RfwoZhhhgv
	FGq+i45RwIJxr6w==
X-Google-Smtp-Source: AGHT+IH6k0Kpp/PjB+jSzNj/xVrwaT5fMRtpFc9z29ENKIOcBKsGRq+08bxuJJ/JrJdhKeQ4q392SvELM4Y4YA==
X-Received: from wrbee10.prod.google.com ([2002:a05:6000:210a:b0:429:de3f:827d])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2f83:b0:42b:3c3e:5d2e with SMTP id ffacd0b85a97d-42b5932345dmr12287897f8f.1.1763405305694;
 Mon, 17 Nov 2025 10:48:25 -0800 (PST)
Date: Mon, 17 Nov 2025 18:47:47 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251117184815.1027271-1-smostafa@google.com>
Subject: [PATCH v5 00/27] KVM: arm64: SMMUv3 driver for pKVM (trap and emulate)
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org, jgg@ziepe.ca, 
	praan@google.com, danielmentz@google.com, mark.rutland@arm.com, 
	qperret@google.com, tabba@google.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This is v5 of pKVM SMMUv3 support with trap and emulate

v1: Implements full fledged pv interface
https://lore.kernel.org/kvmarm/20230201125328.2186498-1-jean-philippe@linar=
o.org/

v2:  Implements full fledged pv interface (+ more features as evtq and s1)
https://lore.kernel.org/kvmarm/20241212180423.1578358-1-smostafa@google.com=
/

v3: Only DMA isolation (using pv)
https://lore.kernel.org/kvmarm/20250728175316.3706196-1-smostafa@google.com=
/

v4: trap and emulate
https://lore.kernel.org/all/20250819215156.2494305-1-smostafa@google.com/

This series is based on the review feedback on v4 + some other
improvements, most notably:
- Add hardening checks in MMIO donation [Will]
- Add missing CMOs for non-coherent SMMU emulation [Will]
- Rely on aux bus to probe the emulated SMMUs, and make the KVM
  driver a platform driver [Jason]
- Replace TLB invalidation macro with inline function [Will]
- Set carevout size from KConfig and cmdline instead of hooks [Will]
- Fix S2 TLB invalidation if SMMUs where disabled
- Re-work command queue emulation to avoid unnecessary MMIO writes to
  make it more efficient.
- Update GBPA emulation to reflect HW state
- Minor cleanups, file renames and rewording of commits

This series applies on iommu-next (includes recent kunit rework)

Design:
=3D=3D=3D=3D=3D=3D=3D

Assumptions:
------------
One of the important points, is that this doesn=E2=80=99t emulate the full
SMMUv3 architecture, but only the parts used by Linux kernel,
that=E2=80=99s why enablement of this (ARM_SMMU_V3_PKVM) depends on
(ARM_SMMU_V3=3Dy) so we are sure of the driver behaviour.

Any new change in the driver will likely trigger a WARN_ON ending up
in panic.

Most notable assumptions:
- Changing of stream table format/size or l2 pointers is not allowed
  after initialization.
- leaf=3D0 CFGI is not allowed
- CFGI_ALL with any value but 31 is not allowed
- Some commands which are not used are not allowed (ex CMD_TLBI_NH_ALL)
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

Dealing with timers
-------------------
In another series Vincent adds some timer abstractions for tracing in
the hypervisor, after checking and having a discussion with him, it
seems there isn=E2=80=99t enough common base to justify having a dependency
between the 2 series, but it=E2=80=99s possible which ever series lands fir=
st,
the other one might need to adapt to it.
https://lore.kernel.org/all/20250821081412.1008261-17-vdonnefort@google.com=
/

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

2) Errata:
----------
Some HW with both stage-1 and stage-2 but can=E2=80=99t run nested
translation due to some errata, which makes the driver remove
nesting for MMU_700, I believe this is too restrictive.
At the moment KVM will use nesting if advertised. (Or we need
other mechanism to exclude only the affected HW)

3) Shadow page table
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

3) Look into ACPI support.

4) Some optimizations (as using block mappings for memory)

Patches overview
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
The patches are split as follows:

Patches 01-03: Core hypervisor: Add donation for NC, dealing with
               MMIO and arch timer abstraction.
Patches 04-07: Refactoring of io-pgtable-arm and SMMUv3 driver
Patches 09-11: Hypervisor IOMMU core: pagetable management, dabts..
Patches 12-27: KVM SMMUv3 code

Tested on Qemu(S1 only, S2 only and nested)  and Morello board.
Also tested with PAGE_SIZE 4k,16k, and 64k.

A development branch can be found in:
https://android-kvm.googlesource.com/linux/+/refs/heads/pkvm-smmu-v5

Jean-Philippe Brucker (1):
  iommu/arm-smmu-v3-kvm: Add SMMUv3 driver

Mostafa Saleh (26):
  KVM: arm64: Add a new function to donate memory with prot
  KVM: arm64: Donate MMIO to the hypervisor
  KVM: arm64: pkvm: Add pkvm_time_get()
  iommu/io-pgtable-arm: Factor kernel specific code out
  iommu/arm-smmu-v3: Split code with hyp
  iommu/arm-smmu-v3: Move TLB range invalidation into common code
  iommu/arm-smmu-v3: Move IDR parsing to common functions
  KVM: arm64: iommu: Introduce IOMMU driver infrastructure
  KVM: arm64: iommu: Shadow host stage-2 page table
  KVM: arm64: iommu: Add memory pool
  KVM: arm64: iommu: Support DABT for IOMMU
  iommu/arm-smmu-v3-kvm: Add the kernel driver
  iommu/arm-smmu-v3: Support probing KVM emulated devices
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

 .../admin-guide/kernel-parameters.txt         |    4 +
 arch/arm64/include/asm/kvm_arm.h              |    2 +
 arch/arm64/include/asm/kvm_host.h             |    6 +
 arch/arm64/kvm/Kconfig                        |    7 +
 arch/arm64/kvm/Makefile                       |    2 +-
 arch/arm64/kvm/hyp/include/nvhe/iommu.h       |   21 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |    3 +
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |    2 +
 arch/arm64/kvm/hyp/nvhe/Makefile              |   10 +-
 arch/arm64/kvm/hyp/nvhe/iommu/iommu.c         |  130 ++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         |  116 +-
 arch/arm64/kvm/hyp/nvhe/setup.c               |   23 +
 arch/arm64/kvm/hyp/nvhe/timer-sr.c            |   32 +
 arch/arm64/kvm/hyp/pgtable.c                  |    9 +-
 arch/arm64/kvm/iommu.c                        |   44 +
 arch/arm64/kvm/pkvm.c                         |    1 +
 drivers/iommu/Makefile                        |    2 +-
 drivers/iommu/arm/Kconfig                     |    9 +
 drivers/iommu/arm/arm-smmu-v3/Makefile        |    3 +-
 .../arm/arm-smmu-v3/arm-smmu-v3-common-lib.c  |  114 ++
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c   |  190 +++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  400 ++----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  254 ++++
 .../iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c  | 1068 +++++++++++++++++
 .../iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h  |   65 +
 .../arm/arm-smmu-v3/pkvm/io-pgtable-arm-hyp.c |   68 ++
 drivers/iommu/io-pgtable-arm-kernel.c         |  103 ++
 drivers/iommu/io-pgtable-arm.c                |  103 +-
 drivers/iommu/io-pgtable-arm.h                |   30 +
 29 files changed, 2402 insertions(+), 419 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/iommu.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
 create mode 100644 arch/arm64/kvm/iommu.c
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common-lib.c
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/pkvm/io-pgtable-arm-hyp.c
 create mode 100644 drivers/iommu/io-pgtable-arm-kernel.c


base-commit: 3ee8acab4e5038a261a72ea2e6035cff89168010
--=20
2.52.0.rc1.455.g30608eb744-goog


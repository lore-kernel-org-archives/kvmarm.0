Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A47B413D8B2;
	Wed, 21 Aug 2024 15:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724254751; cv=none; b=b1GKa9f459HZS6wQblE2tQ7a3/v5p+IKQ2M6+NBBr10mz3CvzaEGvFEMZWiieS2XHjp4OhTndkiO6I8S5BgK1rbPpzNyZbCK//ur6yDAWGmnCS2lEVlQ7ke4ts1dGdTCrXOtCnj5MNkGXA+P2UVwyhw/3iuvjk1OPkx2M8RiJRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724254751; c=relaxed/simple;
	bh=Cmq06yc88KUbQjvW3sBJZKQWcYJ0khTjJ+3FZLoN4gI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=VJxOqB0p/33JeLeKWWEkF8Z+UIOPj2DbDirehyP0E0/9uV0v/vgE2n7bZRLh9hxOeWO5nUb47LFDbGPTC4KCxfQI6rvC4F/IGSN8z4LhWEfk3xG5bSHbiLTIQ4J+wsvcGrEq6VE8saI1PxARNTnoxm7TxGiBgiD8Eejap5Pnu3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 27084DA7;
	Wed, 21 Aug 2024 08:39:34 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.37.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 178503F73B;
	Wed, 21 Aug 2024 08:39:03 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>
Subject: [PATCH v4 00/43] arm64: Support for Arm CCA in KVM
Date: Wed, 21 Aug 2024 16:38:01 +0100
Message-Id: <20240821153844.60084-1-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This series adds support for running protected VMs using KVM under the
Arm Confidential Compute Architecture (CCA).

The related guest support was posted[1] earlier this week. As mentioned
there this version switches to a newer version of the RMM spec
(v1.0-rel0-rc1) which involves some (small) binary breaks to the
interface so you'll need to upgrade both host and guest kernel (and the
RMM) at the same time.

The focus has been on the guest side, so there's not much in the way of
big changes this time. The changes since v3[3] fit in three categories:

 1. Updates caused by the new RMM spec. In particular the 'num_bps' and
    'num_wps' fields now match the architectural ID_AA64DFR0_EL1
    register which avoids a number +1 and -1s in the code.

 2. A bunch of tidy ups handling the cases where kvm is NULL in various
    places.

 3. Misc changes due to rebasing (mostly caused by nested virt support).

Major limitations:

 * Only supports 4k host PAGE_SIZE (if PAGE_SIZE != 4k then the realm
   extensions are disabled).

 * No support for huge pages when mapping the guest's pages. There is
   some 'dead' code left over from before guest_mem was supported. This
   is partly a current limitation of guest_memfd.

The ABI to the RMM (the RMI) is based on RMM v1.0-rel0-rc1
specification[2].

This series is based on v6.11-rc1. It is also available as a git
repository:

https://gitlab.arm.com/linux-arm/linux-cca cca-host/v4

Work in progress changes for kvmtool are available from the git
repository below, these changes are based on Fuad Tabba's repository for
pKVM to provide some alignment with the ongoing pKVM work:

https://gitlab.arm.com/linux-arm/kvmtool-cca cca/v2

[1] https://lore.kernel.org/r/20240819131924.372366-1-steven.price%40arm.com
[2] https://developer.arm.com/-/cdn-downloads/permalink/PDF/Architectures/DEN0137_1.0-rel0-rc1_rmm-arch_external.pdf
[3] https://lore.kernel.org/r/20240610134202.54893-1-steven.price%40arm.com

Jean-Philippe Brucker (7):
  arm64: RME: Propagate number of breakpoints and watchpoints to
    userspace
  arm64: RME: Set breakpoint parameters through SET_ONE_REG
  arm64: RME: Initialize PMCR.N with number counter supported by RMM
  arm64: RME: Propagate max SVE vector length from RMM
  arm64: RME: Configure max SVE vector length for a Realm
  arm64: RME: Provide register list for unfinalized RME RECs
  arm64: RME: Provide accurate register list

Joey Gouly (2):
  arm64: rme: allow userspace to inject aborts
  arm64: rme: support RSI_HOST_CALL

Sean Christopherson (1):
  KVM: Prepare for handling only shared mappings in mmu_notifier events

Steven Price (29):
  arm64: RME: Handle Granule Protection Faults (GPFs)
  arm64: RME: Add SMC definitions for calling the RMM
  arm64: RME: Add wrappers for RMI calls
  arm64: RME: Check for RME support at KVM init
  arm64: RME: Define the user ABI
  arm64: RME: ioctls to create and configure realms
  arm64: kvm: Allow passing machine type in KVM creation
  arm64: RME: Keep a spare page delegated to the RMM
  arm64: RME: RTT tear down
  arm64: RME: Allocate/free RECs to match vCPUs
  arm64: RME: Support for the VGIC in realms
  KVM: arm64: Support timers in realm RECs
  arm64: RME: Allow VMM to set RIPAS
  arm64: RME: Handle realm enter/exit
  KVM: arm64: Handle realm MMIO emulation
  arm64: RME: Allow populating initial contents
  arm64: RME: Runtime faulting of memory
  KVM: arm64: Handle realm VCPU load
  KVM: arm64: Validate register access for a Realm VM
  KVM: arm64: Handle Realm PSCI requests
  KVM: arm64: WARN on injected undef exceptions
  arm64: Don't expose stolen time for realm guests
  arm64: RME: Always use 4k pages for realms
  arm64: rme: Prevent Device mappings for Realms
  arm_pmu: Provide a mechanism for disabling the physical IRQ
  arm64: rme: Enable PMU support with a realm guest
  kvm: rme: Hide KVM_CAP_READONLY_MEM for realm guests
  arm64: kvm: Expose support for private memory
  KVM: arm64: Allow activating realms

Suzuki K Poulose (4):
  kvm: arm64: pgtable: Track the number of pages in the entry level
  kvm: arm64: Include kvm_emulate.h in kvm/arm_psci.h
  kvm: arm64: Expose debug HW register numbers for Realm
  arm64: rme: Allow checking SVE on VM instance

 Documentation/virt/kvm/api.rst       |    3 +
 arch/arm64/include/asm/kvm_emulate.h |   34 +
 arch/arm64/include/asm/kvm_host.h    |   16 +-
 arch/arm64/include/asm/kvm_pgtable.h |    2 +
 arch/arm64/include/asm/kvm_rme.h     |  155 +++
 arch/arm64/include/asm/rmi_cmds.h    |  508 ++++++++
 arch/arm64/include/asm/rmi_smc.h     |  253 ++++
 arch/arm64/include/asm/virt.h        |    1 +
 arch/arm64/include/uapi/asm/kvm.h    |   49 +
 arch/arm64/kvm/Kconfig               |    1 +
 arch/arm64/kvm/Makefile              |    3 +-
 arch/arm64/kvm/arch_timer.c          |   45 +-
 arch/arm64/kvm/arm.c                 |  166 ++-
 arch/arm64/kvm/guest.c               |   99 +-
 arch/arm64/kvm/hyp/pgtable.c         |    5 +-
 arch/arm64/kvm/hypercalls.c          |    4 +-
 arch/arm64/kvm/inject_fault.c        |    2 +
 arch/arm64/kvm/mmio.c                |   10 +-
 arch/arm64/kvm/mmu.c                 |  181 ++-
 arch/arm64/kvm/pmu-emul.c            |    7 +-
 arch/arm64/kvm/psci.c                |   29 +
 arch/arm64/kvm/reset.c               |   23 +-
 arch/arm64/kvm/rme-exit.c            |  212 ++++
 arch/arm64/kvm/rme.c                 | 1620 ++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c            |   83 +-
 arch/arm64/kvm/vgic/vgic-v3.c        |    8 +-
 arch/arm64/kvm/vgic/vgic.c           |   37 +-
 arch/arm64/mm/fault.c                |   31 +-
 drivers/perf/arm_pmu.c               |   15 +
 include/kvm/arm_arch_timer.h         |    2 +
 include/kvm/arm_pmu.h                |    4 +
 include/kvm/arm_psci.h               |    2 +
 include/linux/kvm_host.h             |    2 +
 include/linux/perf/arm_pmu.h         |    5 +
 include/uapi/linux/kvm.h             |   31 +-
 virt/kvm/kvm_main.c                  |    7 +
 36 files changed, 3555 insertions(+), 100 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_rme.h
 create mode 100644 arch/arm64/include/asm/rmi_cmds.h
 create mode 100644 arch/arm64/include/asm/rmi_smc.h
 create mode 100644 arch/arm64/kvm/rme-exit.c
 create mode 100644 arch/arm64/kvm/rme.c

-- 
2.34.1


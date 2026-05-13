Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8456331E830;
	Wed, 13 May 2026 13:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778678303; cv=none; b=CrL15z5fHoLliLDSgyJtMN3lQvb3YLQsLBhoJuzUtFAD9TpvXt2GtRD+f4kmiSsOgL0BSdppWVB2NEAMwYJFl+IaDVWdHOXkX6QntwjAKKYFn25PThzK9HFr0ysMG6c7bxc/pzHaeOAAuFnj7UGgTEzz12JNAHKmDSRZC3Rs78A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778678303; c=relaxed/simple;
	bh=mPzCcDED60bjX6A2Gwx//sNfCouiSOsEZUW1a9b8vxY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=SNuPF6kmppUN+aww3qkBzb/YZ8tSPiW4URqZyIpGW5aZsKC/F+yaHsBE5EfhZMM829eQa/nfI112D7FCu/9QLeEvSx0S60iEPKe/qQpObUwFpHmaaHzM7HNVwshPuiJvwHT77eHCmJ2ZuGb7xZSGqtpitomSmKGNSNuuIvrL8ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=L0vxWiwp; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="L0vxWiwp"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8BDAD1C14;
	Wed, 13 May 2026 06:18:14 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.68.187])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C4CE13F836;
	Wed, 13 May 2026 06:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778678299; bh=mPzCcDED60bjX6A2Gwx//sNfCouiSOsEZUW1a9b8vxY=;
	h=From:To:Cc:Subject:Date:From;
	b=L0vxWiwpUToB4RBVYmCN7+mrMNQwwq+zoXksV9iqAHHWX8lJyscPEbEXuzsc3Fq1p
	 wCFm4oUALrTsFIAy77GTSfeK6Tk+Uj84gmjq+NDKj88TfEocgwoItQc9CA0pS/fxJ4
	 rJx5jml5cyHNk9YhVUC/CBkY8CmH5lTjkfDiW6Bo=
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
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>,
	WeiLin.Chang@arm.com,
	Lorenzo.Pieralisi2@arm.com
Subject: [PATCH v14 00/44] arm64: Support for Arm CCA in KVM
Date: Wed, 13 May 2026 14:17:08 +0100
Message-ID: <20260513131757.116630-1-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
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

This is rebased on v7.1-rc1, but still targets RMM v2.0-bet1[1].

The major updates from v13 remain but have been more fully implemented:
the RMM uses the host's page size, range based RMI APIs mean we don't
have to break everything down to base page sizes, the GIC state is
passed via system registers, and the uAPI has been simplified.

The main changes since v13 are:

 * The RMI definitions and wrappers have been fully updated for RMM
   v2.0-bet1. In particular the temporary RMM v1.0 SMC compatibility
   patch has been dropped.

 * The PSCI completion ioctl has been removed. RMM v2.0-bet1 still
   requires the host to provide the target REC for PSCI calls which
   name another vCPU, but KVM now performs the RMI PSCI completion
   automatically before entering the REC again. Userspace no longer
   needs to issue KVM_ARM_VCPU_RMI_PSCI_COMPLETE. A future spec should
   remove the need for the host to provide the MPIDR mapping.

 * The generic RMI init, RMM configuration, GPT setup,
   delegate/undelegate helpers and SRO infrastructure have moved out of
   KVM into arch/arm64/kernel/rmi.c. RMI is expected to be used by
   features outside KVM, so this code should be available even when KVM
   is not built.

 * RMI_GRANULE_TRACKING_GET has been updated to work on a range, this
   allows it to work when the region is not aligned to the tracking
   size. Solves the problem reported by Mathieu[2].

 * SRO support has been moved earlier in the series and improved. It
   provides a cleaner way for the host to provide the RMM with the extra
   memory it requires. However support is still incomplete where the
   TF-RMM code does not yet implement it. This is noted by FIXMEs in the
   code.

 * The ARM VM type encoding has been reworked to coexist with the
   upstream pKVM KVM_VM_TYPE_ARM_PROTECTED bit.

 * The private-memory documentation now notes that arm64 uses
   KVM_CAP_MEMORY_ATTRIBUTES.

 * PMU support is dropped for now. It will be added later in a separate
   series. Similarly for selecting the hash algorithm and RPV.

There are also the usual rebase updates and smaller fixes, including
changes to the RMM v2.0-bet1 range APIs, removal of REC auxiliary
granule handling, fixes to the address range descriptor encoding, and
cleanups around realm stage-2 teardown.

Stateful RMI Operations
-----------------------

The RMM v2.0 spec introduces Stateful RMI Operations (SROs), which allow
the RMM to complete an operation over several SMC calls while requesting
or returning memory to the host. This allows interrupts to be handled in
the middle of an operation and lets the RMM dynamically allocate memory
for internal tracking purposes. For example, RMI_REC_CREATE no longer
needs auxiliary granules to be provided up front, and can instead
request memory during the operation.

This series includes the generic SRO infrastructure in
arch/arm64/kernel/rmi.c and uses it for REC create/destroy. The other
cases are not yet used by TF-RMM and a future revision will be needed to
finish those paths in Linux.

This series is based on v7.1-rc1. It is also available as a git
repository:

https://gitlab.arm.com/linux-arm/linux-cca cca-host/v14

Work in progress changes for kvmtool are available from the git
repository below:

https://gitlab.arm.com/linux-arm/kvmtool-cca cca/v12

The TF-RMM has not yet merged the RMM v2.0 support, so you will need to
use a branch with RMM v2.0-bet1 support. At the time of writing the
following branch is being used:

https://git.trustedfirmware.org/TF-RMM/tf-rmm.git topics/rmm-v2.0-poc_2
(tested on commit 3340667a291a)

There is a kvm-unit-test branch which has been updated to support the
attestation used in RMMv2.0 available here:

https://gitlab.arm.com/linux-arm/kvm-unit-tests-cca cca/v4

[1] https://developer.arm.com/documentation/den0137/2-0bet1/
[2] https://lore.kernel.org/all/acrj-cKphy4hJsEG@p14s/

Jean-Philippe Brucker (6):
  arm64: RMI: Propagate number of breakpoints and watchpoints to
    userspace
  arm64: RMI: Set breakpoint parameters through SET_ONE_REG
  arm64: RMI: Propagate max SVE vector length from RMM
  arm64: RMI: Configure max SVE vector length for a Realm
  arm64: RMI: Provide register list for unfinalized RMI RECs
  arm64: RMI: Provide accurate register list

Joey Gouly (2):
  arm64: RMI: allow userspace to inject aborts
  arm64: RMI: support RSI_HOST_CALL

Steven Price (33):
  kvm: arm64: Avoid including linux/kvm_host.h in kvm_pgtable.h
  arm64: RME: Handle Granule Protection Faults (GPFs)
  arm64: RMI: Add SMC definitions for calling the RMM
  arm64: RMI: Add wrappers for RMI calls
  arm64: RMI: Check for RMI support at init
  arm64: RMI: Configure the RMM with the host's page size
  arm64: RMI: Ensure that the RMM has GPT entries for memory
  arm64: RMI: Provide functions to delegate/undelegate ranges of memory
  arm64: RMI: Add support for SRO
  arm64: RMI: Check for RMI support at KVM init
  arm64: RMI: Check for LPA2 support
  arm64: RMI: Define the user ABI
  arm64: RMI: Basic infrastructure for creating a realm.
  KVM: arm64: Allow passing machine type in KVM creation
  arm64: RMI: RTT tear down
  arm64: RMI: Activate realm on first VCPU run
  arm64: RMI: Allocate/free RECs to match vCPUs
  arm64: RMI: Support for the VGIC in realms
  KVM: arm64: Support timers in realm RECs
  arm64: RMI: Handle realm enter/exit
  arm64: RMI: Handle RMI_EXIT_RIPAS_CHANGE
  KVM: arm64: Handle realm MMIO emulation
  KVM: arm64: Expose support for private memory
  arm64: RMI: Allow populating initial contents
  arm64: RMI: Set RIPAS of initial memslots
  arm64: RMI: Create the realm descriptor
  arm64: RMI: Runtime faulting of memory
  KVM: arm64: Handle realm VCPU load
  KVM: arm64: Validate register access for a Realm VM
  KVM: arm64: Handle Realm PSCI requests
  KVM: arm64: WARN on injected undef exceptions
  arm64: RMI: Prevent Device mappings for Realms
  arm64: RMI: Enable realms to be created

Suzuki K Poulose (3):
  kvm: arm64: Include kvm_emulate.h in kvm/arm_psci.h
  kvm: arm64: Don't expose unsupported capabilities for realm guests
  arm64: RMI: Allow checking SVE on VM instance

 Documentation/virt/kvm/api.rst       |   62 +-
 arch/arm64/include/asm/kvm_emulate.h |   37 +
 arch/arm64/include/asm/kvm_host.h    |   13 +-
 arch/arm64/include/asm/kvm_pgtable.h |    5 +-
 arch/arm64/include/asm/kvm_pkvm.h    |    2 +-
 arch/arm64/include/asm/kvm_rmi.h     |  127 +++
 arch/arm64/include/asm/rmi_cmds.h    |  680 +++++++++++++
 arch/arm64/include/asm/rmi_smc.h     |  448 ++++++++
 arch/arm64/include/asm/virt.h        |    1 +
 arch/arm64/kernel/Makefile           |    2 +-
 arch/arm64/kernel/cpufeature.c       |    1 +
 arch/arm64/kernel/rmi.c              |  605 +++++++++++
 arch/arm64/kvm/Kconfig               |    2 +
 arch/arm64/kvm/Makefile              |    2 +-
 arch/arm64/kvm/arch_timer.c          |   28 +-
 arch/arm64/kvm/arm.c                 |  140 ++-
 arch/arm64/kvm/guest.c               |   93 +-
 arch/arm64/kvm/hyp/pgtable.c         |    1 +
 arch/arm64/kvm/hypercalls.c          |    4 +-
 arch/arm64/kvm/inject_fault.c        |    5 +-
 arch/arm64/kvm/mmio.c                |   16 +-
 arch/arm64/kvm/mmu.c                 |  197 +++-
 arch/arm64/kvm/psci.c                |   15 +-
 arch/arm64/kvm/reset.c               |   13 +-
 arch/arm64/kvm/rmi-exit.c            |  215 ++++
 arch/arm64/kvm/rmi.c                 | 1401 ++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c            |   47 +-
 arch/arm64/kvm/vgic/vgic-init.c      |    2 +-
 arch/arm64/mm/fault.c                |   28 +-
 include/kvm/arm_arch_timer.h         |    2 +
 include/kvm/arm_psci.h               |    2 +
 include/uapi/linux/kvm.h             |   20 +-
 32 files changed, 4122 insertions(+), 94 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_rmi.h
 create mode 100644 arch/arm64/include/asm/rmi_cmds.h
 create mode 100644 arch/arm64/include/asm/rmi_smc.h
 create mode 100644 arch/arm64/kernel/rmi.c
 create mode 100644 arch/arm64/kvm/rmi-exit.c
 create mode 100644 arch/arm64/kvm/rmi.c

-- 
2.43.0


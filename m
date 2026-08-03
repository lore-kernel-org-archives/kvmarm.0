Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F19DF40F753;
	Mon,  3 Aug 2026 13:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785764661; cv=none; b=iji9SbflUPbYnJaCLe5bmSL4y05lWFMh4pD2qUrS8DP9Ufwq+Z8MtXN2Qi+eTqCkD/AJjRqBCPGqGGpuhFvwVPLNhpm0E0r0qzchjl145UM1lLnFFwcgbZWgkKlw5fOQFV16npJawulwFm0cYIeBvtuvH3Jbg2bTbDu90S1Mso8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785764661; c=relaxed/simple;
	bh=7gDW+1efL7RasAqDrD/fMjJ3ytid+vo61xlhqQvvQxY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=MNVHZw+vuuMWu+1aBnEzcKroVEy3NEjFSjch/stU1gNLIFU2fPB5AZ4Y/VjfusKXqSjAJ5oaAcW/1OiCn17emYBMMIRh7fRMjyBMHbJO25i3SjlWeCtYLXDuk6YVCzj3oQ7VUhnwrijpcZ9hNnGamZ4066zGIbCTNrPSmJO++so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=JzYmqgjX; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="JzYmqgjX"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1BC95143D;
	Mon,  3 Aug 2026 06:44:14 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.25.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0FC3E3F66F;
	Mon,  3 Aug 2026 06:44:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785764658; bh=7gDW+1efL7RasAqDrD/fMjJ3ytid+vo61xlhqQvvQxY=;
	h=From:To:Cc:Subject:Date:From;
	b=JzYmqgjX4z3WBvr551f3ponsOq2UHT+MJAzIJbxuW9HArmH9jX63DI9MDTXt8+TSn
	 B4UAqam71tvGl3zyKAkzuGjrWNxGBXgGxn0H9Bc6pP2ZJ7lsmUxPt0uzXsXciYaeUJ
	 /IiKlSXoxqNGznnI6sZddBn7leHog3gPYcWDPESM=
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
	Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: [PATCH v16 00/45] arm64: Support for Arm CCA in KVM
Date: Mon,  3 Aug 2026 14:43:16 +0100
Message-ID: <20260803134403.80630-1-steven.price@arm.com>
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
Arm Confidential Compute Architecture (CCA), including the firmware
support needed to communicate with the Realm Management Monitor (RMM).

For v15 the series was split into a 6-patch generic firmware/RMM series
and a 37-patch KVM series. The two parts are combined again for v16, as
requested to allow the complete stack to be tested by Sashiko as a
single series.

The first six patches add the generic firmware layer for talking to the
RMM, as specified by version 2.0-bet2 of the RMM specification[0]. They
provide the RMI definitions and wrappers, discover and configure the
RMM, implement Stateful RMI Operations (SROs), and ensure that the RMM
has GPT entries for host memory. The remaining patches add the KVM
support needed to create, populate and run Realm VMs.

Note that RMM v2.0 Beta 3 specification should be published soon. The
changes introduced in that are minor and I expect this series to be
largely compatible with the new spec.

The RMM v2.0 specification introduces SROs, which allow the RMM to
complete an operation over several SMC calls while requesting or
returning memory to the host. This allows interrupts to be handled in
the middle of an operation and lets the RMM dynamically allocate memory
for internal tracking purposes. For example, RMI_REC_CREATE no longer
needs auxiliary granules to be provided up front, and can instead
request memory during the operation.

The main changes since v15 are:

 * Recombine the firmware/RMM and KVM portions into one series. The
   Realm-specific RMI wrappers remain separate from the generic
   firmware wrappers, in a new KVM patch.

 * Rewrite Realm entry and exit handling to fit into the generic KVM
   run loop. Work which cannot be performed in the entry path is now
   completed through KVM requests, and MMIO, PSCI, RIPAS changes and
   host calls are adapted to the new flow.

 * Rewrite Realm timer support to use KVM's IRQ-ops infrastructure and
   software resampling.

 * Improve SRO cancellation and error handling. Ensure a cancelled
   operation isn't treated as successful, wrapper return values can carry
   negative Linux errors as well as RMI return values, and those errors
   are propagated through the KVM users.

 * Check that the RMM supports the host page size before configuring it,
   and exclude firmware-reserved NOMAP memory when creating GPT entries.

 * Expand the KVM_ARM_RMI_POPULATE documentation to make clear that Arm
   CCA cannot preserve memory contents during an in-place
   shared-to-private conversion.

 * Allocate Realm parameters only while creating the Realm descriptor.

 * Document the encoding of the arm64 VM types and require
   ICH_HCR_EL2.TDIR before advertising or creating Realm VMs.

This series is based on the guest_memfd in-place conversion v9 tree[1],
which is itself based on kvm-x86/next. It is also available as a git
repository:

https://gitlab.arm.com/linux-arm/linux-cca cca-host/v16

Work in progress changes for kvmtool are available from the git
repository below:

https://gitlab.arm.com/linux-arm/kvmtool-cca cca/v13

The TF-RMM branch used for testing this series is available here:

https://git.trustedfirmware.org/TF-RMM/tf-rmm.git topics/rmm-v2.0-poc_3

There is a kvm-unit-test branch updated to support the attestation used
in RMM v2.0 available here:

https://gitlab.arm.com/linux-arm/kvm-unit-tests-cca cca/v4

[0] https://developer.arm.com/documentation/den0137/2-0bet2/
One bet2 change, which moves metadata out of the individual address
range descriptors, has intentionally not been implemented because that
part of the specification is expected to be reverted.

[1] https://github.com/googleprodkernel/linux-cc/commits/guest_memfd-inplace-conversion-v9

Jean-Philippe Brucker (6):
  KVM: arm64: CCA: Propagate breakpoint and watchpoint counts to
    userspace
  KVM: arm64: CCA: Set breakpoint parameters through SET_ONE_REG
  KVM: arm64: CCA: Propagate max SVE vector length from the RMM
  KVM: arm64: CCA: Configure max SVE vector length for a Realm
  KVM: arm64: CCA: Provide register list for unfinalized RECs
  KVM: arm64: CCA: Provide an accurate register list

Joey Gouly (2):
  KVM: arm64: CCA: Allow userspace to inject aborts
  KVM: arm64: CCA: Support RSI_HOST_CALL

Steven Price (34):
  firmware: arm_rmm: Add SMC definitions for calling the RMM
  firmware: arm_rmm: Add wrappers for direct RMI calls
  firmware: arm_rmm: Check for RMI support at init
  firmware: arm_rmm: Configure the RMM with the host's page size
  firmware: arm_rmm: Add support for SRO
  firmware: arm_rmm: Ensure the RMM has GPT entries for memory
  arm64: mm: Handle Granule Protection Faults (GPFs)
  KVM: arm64: Avoid including linux/kvm_host.h in kvm_pgtable.h
  KVM: arm64: CCA: Add wrappers for realm related RMIs
  KVM: arm64: CCA: Check for RMI support at KVM init
  KVM: arm64: CCA: Check for LPA2 support
  KVM: arm64: CCA: Define the user ABI
  KVM: arm64: CCA: Add basic infrastructure for creating a realm
  KVM: arm64: CCA: Allow passing the machine type in KVM creation
  KVM: arm64: CCA: Tear down RTTs
  KVM: arm64: CCA: Allocate and free RECs to match vCPUs
  KVM: arm64: CCA: Support the VGIC in realms
  KVM: arm64: CCA: Support timers in realm RECs
  KVM: arm64: CCA: Handle realm enter/exit
  KVM: arm64: CCA: Handle RMI_EXIT_RIPAS_CHANGE
  KVM: arm64: CCA: Handle realm MMIO emulation
  KVM: arm64: Expose support for private memory
  KVM: arm64: CCA: Create the realm descriptor
  KVM: arm64: CCA: Activate realms on first vCPU run
  KVM: arm64: CCA: Allow populating initial contents
  KVM: arm64: CCA: Set RIPAS of initial memslots
  KVM: arm64: CCA: Support runtime faulting of memory
  KVM: arm64: CCA: Handle realm vCPU load
  KVM: arm64: CCA: Validate register access for Realm VMs
  KVM: arm64: CCA: Handle Realm PSCI requests
  KVM: arm64: WARN on injected undef exceptions
  KVM: arm64: CCA: Prevent Device mappings for realms
  KVM: arm64: CCA: Require ICH_HCR_EL2.TDIR for realms
  KVM: arm64: CCA: Enable realms to be created

Suzuki K Poulose (3):
  KVM: arm64: Include kvm_emulate.h in kvm/arm_psci.h
  KVM: arm64: CCA: Don't expose unsupported capabilities for realm
    guests
  KVM: arm64: CCA: Allow checking SVE on VM instance

 Documentation/virt/kvm/api.rst       |   70 +-
 arch/arm64/Kconfig                   |    1 +
 arch/arm64/include/asm/kvm_asm.h     |    2 +
 arch/arm64/include/asm/kvm_emulate.h |   37 +
 arch/arm64/include/asm/kvm_host.h    |   12 +-
 arch/arm64/include/asm/kvm_pgtable.h |    6 +-
 arch/arm64/include/asm/kvm_pkvm.h    |    2 +-
 arch/arm64/include/asm/kvm_rmi.h     |  139 +++
 arch/arm64/include/asm/rmi_cmds.h    |  465 ++++++++
 arch/arm64/include/asm/virt.h        |    1 +
 arch/arm64/kernel/cpufeature.c       |    1 +
 arch/arm64/kvm/Kconfig               |    2 +
 arch/arm64/kvm/Makefile              |    2 +-
 arch/arm64/kvm/arch_timer.c          |   34 +-
 arch/arm64/kvm/arm.c                 |  139 ++-
 arch/arm64/kvm/guest.c               |   93 +-
 arch/arm64/kvm/handle_exit.c         |   14 +
 arch/arm64/kvm/hyp/pgtable.c         |    1 +
 arch/arm64/kvm/hypercalls.c          |    4 +-
 arch/arm64/kvm/inject_fault.c        |    5 +-
 arch/arm64/kvm/mmio.c                |   16 +-
 arch/arm64/kvm/mmu.c                 |  144 ++-
 arch/arm64/kvm/reset.c               |   13 +-
 arch/arm64/kvm/rmi-exit.c            |  178 +++
 arch/arm64/kvm/rmi.c                 | 1561 ++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c            |   47 +-
 arch/arm64/kvm/vgic/vgic-init.c      |    2 +-
 arch/arm64/mm/fault.c                |   28 +-
 drivers/firmware/Kconfig             |    1 +
 drivers/firmware/Makefile            |    1 +
 drivers/firmware/arm_rmm/Kconfig     |   26 +
 drivers/firmware/arm_rmm/Makefile    |    2 +
 drivers/firmware/arm_rmm/rmi.c       |  776 +++++++++++++
 include/kvm/arm_psci.h               |    2 +
 include/linux/arm-rmi-cmds.h         |  201 ++++
 include/linux/arm-smccc-rmi.h        |  493 ++++++++
 include/uapi/linux/kvm.h             |   20 +-
 37 files changed, 4446 insertions(+), 95 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_rmi.h
 create mode 100644 arch/arm64/include/asm/rmi_cmds.h
 create mode 100644 arch/arm64/kvm/rmi-exit.c
 create mode 100644 arch/arm64/kvm/rmi.c
 create mode 100644 drivers/firmware/arm_rmm/Kconfig
 create mode 100644 drivers/firmware/arm_rmm/Makefile
 create mode 100644 drivers/firmware/arm_rmm/rmi.c
 create mode 100644 include/linux/arm-rmi-cmds.h
 create mode 100644 include/linux/arm-smccc-rmi.h

-- 
2.43.0


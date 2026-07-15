Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6C06380FE7;
	Wed, 15 Jul 2026 14:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784125733; cv=none; b=ZmSAz74DmAdJncbzf/o1eSyXqqQFH2ldfAhYVGg1BacWXp3W82kwzBm/7RgHbzCT9KvPZ7Epdp/VGm4qx9JBEa/sZkU6G61miPXitbdkq+UnIxyg2tCwNOV1YF3cloba0ofGA/VqlTm2xga1LZy+2tDesF5Pme16vOdGR0LWwdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784125733; c=relaxed/simple;
	bh=RPBcdk7+OWFlYMx6oWxTVQsRuoPWXh2yHJ6dCW6HmvM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=quupn6jlZ5ztLlrCiZIC2761hM3PRZ+WR5YHtwBRFlXx4N1dxXA1/uqJ0zVmFTxrvFkH1NKZQi0PbeoR87cXARYqae/lk0BYvhhMFepfBUS2sABTymYa8BCTBMSyjP7vLuK1vbu+AQ26G+g6xwEEM2U2ci/v6X6zuItcZMaoQcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hY+3GrTo; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hY+3GrTo"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D62A31477;
	Wed, 15 Jul 2026 07:28:46 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.25.27])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 067293F7B4;
	Wed, 15 Jul 2026 07:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784125731; bh=RPBcdk7+OWFlYMx6oWxTVQsRuoPWXh2yHJ6dCW6HmvM=;
	h=From:To:Cc:Subject:Date:From;
	b=hY+3GrToMRKUOLAqu5ldF2nT83VrjtYAGsIsVmpYxd0xEXjUhS7xyrbHhTUM/nc/V
	 z7jmdrmgMkjd9k6PoEQABpH9WJZc//hUXFwt1PNZymVNYMjJ8C6LhP74kIkPj2F8Da
	 7yHozn+WxgEZVckoiCl2JdJPwzevO0fRctXPands=
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
Subject: [PATCH v15 00/37] arm64: Support for Arm CCA in KVM
Date: Wed, 15 Jul 2026 15:28:02 +0100
Message-ID: <20260715142841.80544-1-steven.price@arm.com>
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

It is the second part of the Arm CCA host support that was previously
posted as a single 44-patch series. The generic firmware/RMM support has
now been split into a separate 6-patch base series[0] so that it can also be
used by other work (and hopefully make reviewing a little easier). This
series applies on top of that base.

This is rebased on v7.2-rc1 and targets RMM v2.0-bet2[1].

The main changes since v14 are:

 * The RMI definitions and wrappers have been updated for RMM
   v2.0-bet2. One bet2 change, which moves metadata out of the
   individual address range descriptors, has intentionally not been
   implemented because that part of the spec is expected to be reverted.

 * The generic RMI code has been split out into the preceding
   firmware/RMM series. Common definitions and helpers are in
   include/linux/arm-smccc-rmi.h and include/linux/arm-rmi-cmds.h, with
   the KVM-specific wrappers left under arch/arm64.

 * SRO handling has been reworked to match the new layout. Wrappers for
   SRO-based RMI commands live with the SRO infrastructure, range
   delegate/undelegate use the stateful command infrastructure, BUSY and
   BLOCKED polling now calls cpu_relax(), and realm creation uses the
   SRO flow.

 * PSCI completion has been updated for the RMM v2.0-bet2 flow, which no
   longer requires the host to pass the target REC to RMI_PSCI_COMPLETE.

 * Realm creation has been adapted to the v2.0-bet2 realm parameter
   layout, including explicit SHA-256 selection and SRO-based realm
   creation.

 * RTT teardown is now serialized under config_lock and is idempotent.

 * KVM_ARM_RMI_POPULATE now takes slots_lock and config_lock higher in
   the call path, adds lockdep assertions in the lower helpers, and
   checks for overflow in the userspace-provided range.

 * RMI_EXIT_RIPAS_CHANGE handling now uses addition rather than bitwise OR
   when adding the shared bit, so ranges ending at the last address are
   handled correctly.

 * The RMI feature checks now support selecting the feature register to
   query and validate that the default SHA-256 hash algorithm is
   available.

 * Patch subjects have been renamed to use firmware: arm_rmm for the
   generic RMI layer and KVM: arm64: CCA for the KVM realm support.

There are also the usual rebase updates and smaller fixes.

The RMM v2.0 spec introduces Stateful RMI Operations (SROs), which allow
the RMM to complete an operation over several SMC calls while requesting
or returning memory to the host. This allows interrupts to be handled in
the middle of an operation and lets the RMM dynamically allocate memory
for internal tracking purposes. For example, RMI_REC_CREATE no longer
needs auxiliary granules to be provided up front, and can instead
request memory during the operation.

The SRO infrastructure itself is provided by the prerequisite
firmware/RMM series. This KVM series uses that infrastructure for the RMI
operations which can complete statefully, including realm creation, RMM
activation, GPT creation and range delegate/undelegate.

This series is based on v7.2-rc1 and Ackerley's guest_memfd in-place
series. It is also available as a git repository:

https://gitlab.arm.com/linux-arm/linux-cca cca-host/v15

Work in progress changes for kvmtool are available from the git
repository below:

https://gitlab.arm.com/linux-arm/kvmtool-cca cca/v13

The TF-RMM has now merged most of the RMM v2.0 support needed by this
series. The remaining PSCI changes have not yet merged; for testing those
changes are available in the following TF-RMM branch:

https://git.trustedfirmware.org/TF-RMM/tf-rmm.git topics/rmm-v2.0-poc_3

There is a kvm-unit-test branch which has been updated to support the
attestation used in RMM v2.0 available here:

https://gitlab.arm.com/linux-arm/kvm-unit-tests-cca cca/v4

[0] https://lore.kernel.org/r/20260715142739.80398-1-steven.price@arm.com

[1] https://developer.arm.com/documentation/den0137/2-0bet2/
Note that one bet2 change, which moves metadata out of the individual
address range descriptors, has intentionally not been implemented
because that part of the spec is expected to be reverted.

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

Steven Price (26):
  KVM: arm64: Avoid including linux/kvm_host.h in kvm_pgtable.h
  arm64: mm: Handle Granule Protection Faults (GPFs)
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
  KVM: arm64: CCA: Enable realms to be created

Suzuki K Poulose (3):
  KVM: arm64: Include kvm_emulate.h in kvm/arm_psci.h
  KVM: arm64: CCA: Don't expose unsupported capabilities for realm
    guests
  KVM: arm64: CCA: Allow checking SVE on VM instance

 Documentation/virt/kvm/api.rst       |   61 +-
 arch/arm64/include/asm/kvm_emulate.h |   37 +
 arch/arm64/include/asm/kvm_host.h    |   11 +-
 arch/arm64/include/asm/kvm_pgtable.h |    6 +-
 arch/arm64/include/asm/kvm_pkvm.h    |    2 +-
 arch/arm64/include/asm/kvm_rmi.h     |  136 +++
 arch/arm64/include/asm/virt.h        |    1 +
 arch/arm64/kvm/Kconfig               |    2 +
 arch/arm64/kvm/Makefile              |    2 +-
 arch/arm64/kvm/arch_timer.c          |   38 +-
 arch/arm64/kvm/arm.c                 |  140 ++-
 arch/arm64/kvm/guest.c               |   93 +-
 arch/arm64/kvm/hyp/pgtable.c         |    1 +
 arch/arm64/kvm/hypercalls.c          |    4 +-
 arch/arm64/kvm/inject_fault.c        |    5 +-
 arch/arm64/kvm/mmio.c                |   16 +-
 arch/arm64/kvm/mmu.c                 |  144 ++-
 arch/arm64/kvm/psci.c                |   14 +
 arch/arm64/kvm/reset.c               |   13 +-
 arch/arm64/kvm/rmi-exit.c            |  212 ++++
 arch/arm64/kvm/rmi.c                 | 1523 ++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c            |   47 +-
 arch/arm64/kvm/vgic/vgic-init.c      |    2 +-
 arch/arm64/mm/fault.c                |   28 +-
 include/kvm/arm_arch_timer.h         |    2 +
 include/kvm/arm_psci.h               |    2 +
 include/uapi/linux/kvm.h             |   20 +-
 27 files changed, 2466 insertions(+), 96 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_rmi.h
 create mode 100644 arch/arm64/kvm/rmi-exit.c
 create mode 100644 arch/arm64/kvm/rmi.c

-- 
2.43.0


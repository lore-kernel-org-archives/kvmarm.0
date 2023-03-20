Received: from out-57.mta1.migadu.com (out-57.mta1.migadu.com [95.215.58.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A818477
	for <kvmarm@lists.linux.dev>; Mon, 20 Mar 2023 22:10:27 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1679350225;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=IdkcR+2C9TkNpkDTs4O6CTM2PZmQv4+noGiw54PYvos=;
	b=o+6w+KUiqTo8XAhM98QKzVuZTNLZrK40BcC8TFDPPLYdOAEE3Rjzt/qPV+MzGJGimUNvY7
	uZ3XUhDnjHsJsb+4+Ow4bhdobNBYWgYW6Bk+fCpjZyUrWTZPk0KrNzLKDSEzvjY7duWmTV
	mftHdY+wNbx/v8WJG1SYtXrvisLQOIk=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sean Christopherson <seanjc@google.com>,
	Salil Mehta <salil.mehta@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 00/11] KVM: arm64: Userspace SMCCC call filtering
Date: Mon, 20 Mar 2023 22:09:51 +0000
Message-Id: <20230320221002.4191007-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The Arm SMCCC is rather prescriptive in regards to the allocation of
SMCCC function ID ranges. Many of the hypercall ranges have an
associated specification from Arm (FF-A, PSCI, SDEI, etc.) with some
room for vendor-specific implementations.

The ever-expanding SMCCC surface leaves a lot of work within KVM for
providing new features. Furthermore, KVM implements its own
vendor-specific ABI, with little room for other implementations (like
Hyper-V, for example). Rather than cramming it all into the kernel we
should provide a way for userspace to handle hypercalls.

It would appear that vCPU hotplug [*] has a legitimate use case for
something like this, sending PSCI calls to userspace (where they
should have gone in the first place).

[*] https://lore.kernel.org/kvmarm/20230203135043.409192-1-james.morse@arm.com/

=> We have these new hypercall bitmap registers, why not use that?

The hypercall bitmap registers aren't necessarily aimed at the same
problem. The bitmap registers allow a VMM to preserve the ABI the guest
gets from KVM by default when migrating between hosts. By default KVM
exposes the entire feature set to the guest, whereas user SMCCC calls
need explicit opt-in from userspace.

Applies to 6.3-rc3.

RFCv2: https://lore.kernel.org/kvmarm/20230211013759.3556016-1-oliver.upton@linux.dev/

RFCv2 -> v1:
 - Redefine kvm_run::hypercall::longmode as a flags field (Sean)
 - Handle SMCs from EL1
 - Pre-increment PC before exiting to userspace for an SMC
 - A test!

Oliver Upton (11):
  KVM: x86: Redefine 'longmode' as a flag for KVM_EXIT_HYPERCALL
  KVM: arm64: Add a helper to check if a VM has ran once
  KVM: arm64: Add vm fd device attribute accessors
  KVM: arm64: Rename SMC/HVC call handler to reflect reality
  KVM: arm64: Start handling SMCs from EL1
  KVM: arm64: Refactor hvc filtering to support different actions
  KVM: arm64: Use a maple tree to represent the SMCCC filter
  KVM: arm64: Add support for KVM_EXIT_HYPERCALL
  KVM: arm64: Indroduce support for userspace SMCCC filtering
  KVM: selftests: Add a helper for SMCCC calls with SMC instruction
  KVM: selftests: Add test for SMCCC filter

 Documentation/virt/kvm/api.rst                |  24 ++-
 Documentation/virt/kvm/devices/vm.rst         |  74 +++++++
 arch/arm64/include/asm/kvm_host.h             |   8 +-
 arch/arm64/include/uapi/asm/kvm.h             |  24 +++
 arch/arm64/kvm/arm.c                          |  35 ++++
 arch/arm64/kvm/handle_exit.c                  |  22 +-
 arch/arm64/kvm/hypercalls.c                   | 155 +++++++++++++-
 arch/arm64/kvm/pmu-emul.c                     |   4 +-
 arch/x86/include/uapi/asm/kvm.h               |   9 +
 arch/x86/kvm/x86.c                            |   5 +-
 include/kvm/arm_hypercalls.h                  |   6 +-
 include/uapi/linux/kvm.h                      |   9 +-
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/smccc_filter.c      | 196 ++++++++++++++++++
 .../selftests/kvm/include/aarch64/processor.h |  13 ++
 .../selftests/kvm/lib/aarch64/processor.c     |  52 +++--
 16 files changed, 593 insertions(+), 44 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/smccc_filter.c


base-commit: e8d018dd0257f744ca50a729e3d042cf2ec9da65
-- 
2.40.0.rc1.284.g88254d51c5-goog


Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 610B84437C
	for <kvmarm@lists.linux.dev>; Thu,  7 Dec 2023 15:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 554ED139F;
	Thu,  7 Dec 2023 07:09:01 -0800 (PST)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.197.60])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 680573F762;
	Thu,  7 Dec 2023 07:08:14 -0800 (PST)
From: James Morse <james.morse@arm.com>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Morse <james.morse@arm.com>
Subject: [PATCH v2 0/4] KVM: arm64: Hide unsupported MPAM from the guest
Date: Thu,  7 Dec 2023 15:08:00 +0000
Message-Id: <20231207150804.3425468-1-james.morse@arm.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

'lo

This series fixes up a long standing bug where MPAM was accidentally exposed
to a guest, but the feature was not otherwise trapped or context switched.
This could result in KVM warning about unexpected traps, and injecting an
undef into the guest contradicting the ID registers.
This would prevent an MPAM aware kernel from booting - fortunately, there
aren't any of those.

Ideally, we'd take the MPAM feature away from the ID registers, but that
would leave existing guests unable to migrate to a newer kernel. Instead,
use the writable ID registers to allow MPAM to be re-enabled - but emulate
it as RAZ/WI for the system registers that are trapped.
This means KVM emulates a machine with 0 PARTID and 0 PMG, so the MPAMx_ELy
registers don't need to be preserved by KVM. This has the added advantage
that MPAMx_ELy's 'MPAMEN' bit will be read as zero, telling guests that
this feature is disabled.

Guests have never been able to make use of MPAM as these system registers
are only for configuring the CPU, to see any change in behaviour you need
to configure the Memory System Components (MSC) which are MMIO gadgets that
belong to the host.

This series includes the head.S and KVM changes to enable/disable traps. If
MPAM is neither enabled nor emulated by EL3 firmware, these system register
accesses will trap to EL3.
If your kernel doesn't boot, and the problem bisects here - please update
your firmware. MPAM has been supported by trusted firmware since v1.6 in
2018. (also noted on patch 2).

This series is based on v6.7-rc4 and can be retrieved from:
https://git.kernel.org/pub/scm/linux/kernel/git/morse/linux.git/log/?h=mpam/kvm_mpam_fix/v2


Thanks,

James Morse (4):
  arm64: head.S: Initialise MPAM EL2 registers and disable traps
  arm64: cpufeature: discover CPU support for MPAM
  KVM: arm64: Fix missing traps of guest accesses to the MPAM registers
  KVM: arm64: Disable MPAM visibility by default, and handle traps

 .../arch/arm64/cpu-feature-registers.rst      |  2 +
 arch/arm64/Kconfig                            | 19 ++++-
 arch/arm64/include/asm/cpu.h                  |  1 +
 arch/arm64/include/asm/cpufeature.h           | 13 ++++
 arch/arm64/include/asm/el2_setup.h            | 16 ++++
 arch/arm64/include/asm/kvm_arm.h              |  1 +
 arch/arm64/include/asm/mpam.h                 | 75 +++++++++++++++++++
 arch/arm64/include/asm/sysreg.h               |  8 ++
 arch/arm64/kernel/Makefile                    |  1 +
 arch/arm64/kernel/cpufeature.c                | 67 +++++++++++++++++
 arch/arm64/kernel/cpuinfo.c                   |  4 +
 arch/arm64/kernel/image-vars.h                |  5 ++
 arch/arm64/kernel/mpam.c                      |  8 ++
 arch/arm64/kvm/hyp/include/hyp/switch.h       | 32 ++++++++
 arch/arm64/kvm/sys_regs.c                     | 71 +++++++++++++++++-
 arch/arm64/tools/cpucaps                      |  1 +
 arch/arm64/tools/sysreg                       | 32 ++++++++
 17 files changed, 352 insertions(+), 4 deletions(-)
 create mode 100644 arch/arm64/include/asm/mpam.h
 create mode 100644 arch/arm64/kernel/mpam.c

-- 
2.39.2


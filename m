Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BB6A28691
	for <kvmarm@lists.linux.dev>; Tue, 15 Oct 2024 13:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728999574; cv=none; b=InQ5+c/bFKmTTThQFHPaLtk6+3n9KnatXGkQw55RmDle/+CgUv0NZ7oSYD4wSRbowWMR0FClYN/5DtR10WYlHrmRIkU3qK++0EmtwFOeI3jFNhL0yBTqcDbGhMV7pKxIXLmdjcWMzKzXHaLUUpOUb0cuVM00fbEuk372+AT5NuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728999574; c=relaxed/simple;
	bh=LMXtO0n1tPoebIUIl3KEllcVFHRWF6FapiRxBw1p7H8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=llipO1xC9CNIU50UKickiwKgE1TSQcaQPNp+Y0bMAIfOGFpkR0PmZOsgqAoGl1slJMb5T6Rwszq4VbgmVhjo0fgJwOzqGt7j7WSArFB9pu7m706M8K1S8IeP+bd7fSxZXSxsK4Y6EOlBtAl9hyv7NG501hoEq3K45CNn0oyXVnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C0323FEC;
	Tue, 15 Oct 2024 06:40:00 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 428EA3F51B;
	Tue, 15 Oct 2024 06:39:29 -0700 (PDT)
From: Joey Gouly <joey.gouly@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: anshuman.khandual@arm.com,
	james.morse@arm.com,
	joey.gouly@arm.com,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jing Zhang <jingzhangos@google.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v5 0/7] KVM: arm64: Hide unsupported MPAM from the guest
Date: Tue, 15 Oct 2024 14:39:16 +0100
Message-Id: <20241015133923.3910916-1-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Thanks Gavin and Marc for the feedback, hopefully incorporated it all here.

changes since v4 [1]:
	- Swap order of patches, to be able to use MPAMIDR_EL1_HAS_HCR_SHIFT from
	  el2_setup.h
	- Remove trap_mpam() and use undef_acccess() directly
	- Stopped using ID_FILTERED() for the 32-bit ID register
	- Fix ID_AA64PFR1_EL1 sanitisation
	- Fix MPAM_EL1 encoding
	- Fix bug that set everything apart from MPAM_frac as writable in
	  ID_AA64PFR1_EL1. Match the current behaviour, so nothing is writable.

James wrote:
	This series fixes up a long standing bug where MPAM was accidentally exposed
	to a guest, but the feature was not otherwise trapped or context switched.
	This could result in KVM warning about unexpected traps, and injecting an
	undef into the guest contradicting the ID registers.
	This would prevent an MPAM aware kernel from booting - fortunately, there
	aren't any of those.

	Ideally, we'd take the MPAM feature away from the ID registers, but that
	would leave existing guests unable to migrate to a newer kernel. Instead,
	just ignore that field when it matches the hardware. KVM wasn't going to
	expose MPAM anyway. The guest will not see MPAM in the id registers.

	This series includes the head.S and KVM changes to enable/disable traps. If
	MPAM is neither enabled nor emulated by EL3 firmware, these system register
	accesses will trap to EL3.
	If your kernel doesn't boot, and the problem bisects here - please update
	your firmware. MPAM has been supported by trusted firmware since v1.6 in
	2018. (also noted on patch 3).

Thanks,
Joey

[1] https://lore.kernel.org/linux-arm-kernel/20241004110714.2051604-1-joey.gouly@arm.com/

James Morse (7):
  arm64/sysreg: Convert existing MPAM sysregs and add the remaining
    entries
  arm64: head.S: Initialise MPAM EL2 registers and disable traps
  arm64: cpufeature: discover CPU support for MPAM
  KVM: arm64: Fix missing traps of guest accesses to the MPAM registers
  KVM: arm64: Add a macro for creating filtered sys_reg_descs entries
  KVM: arm64: Disable MPAM visibility by default and ignore VMM writes
  KVM: arm64: selftests: Test ID_AA64PFR0.MPAM isn't completely ignored

 .../arch/arm64/cpu-feature-registers.rst      |   2 +
 arch/arm64/Kconfig                            |  20 +++
 arch/arm64/include/asm/cpu.h                  |   1 +
 arch/arm64/include/asm/cpucaps.h              |   2 +
 arch/arm64/include/asm/cpufeature.h           |  12 ++
 arch/arm64/include/asm/el2_setup.h            |  16 ++
 arch/arm64/include/asm/kvm_arm.h              |   1 +
 arch/arm64/include/asm/mpam.h                 |  32 ++++
 arch/arm64/include/asm/sysreg.h               |  12 --
 arch/arm64/kernel/Makefile                    |   2 +
 arch/arm64/kernel/cpufeature.c                |  97 +++++++++++
 arch/arm64/kernel/cpuinfo.c                   |   4 +
 arch/arm64/kernel/image-vars.h                |   5 +
 arch/arm64/kernel/mpam.c                      |   6 +
 arch/arm64/kvm/hyp/include/hyp/switch.h       |  32 ++++
 arch/arm64/kvm/sys_regs.c                     | 105 +++++++++---
 arch/arm64/tools/cpucaps                      |   1 +
 arch/arm64/tools/sysreg                       | 161 ++++++++++++++++++
 .../selftests/kvm/aarch64/set_id_regs.c       | 100 ++++++++++-
 19 files changed, 571 insertions(+), 40 deletions(-)
 create mode 100644 arch/arm64/include/asm/mpam.h
 create mode 100644 arch/arm64/kernel/mpam.c

-- 
2.25.1


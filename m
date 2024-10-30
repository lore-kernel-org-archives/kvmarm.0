Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D28C36126
	for <kvmarm@lists.linux.dev>; Wed, 30 Oct 2024 16:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730304209; cv=none; b=f8jQkGojBu6McU0y3rEaRrIu2Wx7tBi2avieeS097PDUnGhXbFI8x1VZQ30UGR/hQfYavS+mGC06aldevpPP5heINXsHR5TjuuQAR1w5lXvayXAKV/0RTlQmpbeFOQsrbOJ0TVH7O8MxHVi7OgfbQ1ECvcPCwwwJXaQeviGAsPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730304209; c=relaxed/simple;
	bh=yGdrxDbPcyddfHcvr4uDquPG3uJ8P3ZF+2e4cJz1hZ4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZufyZ6Gem/kejzt8kNTqgk2H9H47inn9El9C0DhT6HQtg+W/LlKyVa1AgktkXGus1RBToE79ochSCqgH8SBthX3ssLUfEuRnaRk3Kpn8cT5m/OyKZVVrbtrRycdqWvAiXvAh8svXCtq274LZbbTK0dlzgkI3OBtZIUkqbhSw7sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 10792113E;
	Wed, 30 Oct 2024 09:03:55 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 478523F528;
	Wed, 30 Oct 2024 09:03:23 -0700 (PDT)
From: Joey Gouly <joey.gouly@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: anshuman.khandual@arm.com,
	gshan@redhat.com,
	james.morse@arm.com,
	joey.gouly@arm.com,
	shameerali.kolothum.thodi@huawei.com,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jing Zhang <jingzhangos@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v6 0/7] KVM: arm64: Hide unsupported MPAM from the guest
Date: Wed, 30 Oct 2024 16:03:10 +0000
Message-Id: <20241030160317.2528209-1-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

changes since v5 [1]:
	- Removed Kconfig option, the KVM traps shouldn't rely on host kernel support
	- Renamed cpus_support_* to system_supports_* since that matches other functions
	- Replace static branch arm64_mpam_has_hcr with a normal cpufeature capability
	- Add MPAM*_EL2 regs to KVM (undef_access)
	- Use constants in the test, instead of hardcoded values
	- Added R-b and T-b tags
	- Rebased on v6.12-rc5

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

[1] https://lore.kernel.org/kvmarm/20241015133923.3910916-1-joey.gouly@arm.com/

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
 arch/arm64/include/asm/cpu.h                  |   1 +
 arch/arm64/include/asm/cpucaps.h              |   5 +
 arch/arm64/include/asm/cpufeature.h           |  17 ++
 arch/arm64/include/asm/el2_setup.h            |  14 ++
 arch/arm64/include/asm/kvm_arm.h              |   1 +
 arch/arm64/include/asm/sysreg.h               |  12 --
 arch/arm64/kernel/cpufeature.c                |  96 +++++++++++
 arch/arm64/kernel/cpuinfo.c                   |   3 +
 arch/arm64/kvm/hyp/include/hyp/switch.h       |  31 ++++
 arch/arm64/kvm/sys_regs.c                     | 121 +++++++++----
 arch/arm64/tools/cpucaps                      |   2 +
 arch/arm64/tools/sysreg                       | 161 ++++++++++++++++++
 .../selftests/kvm/aarch64/set_id_regs.c       |  99 ++++++++++-
 14 files changed, 523 insertions(+), 42 deletions(-)

-- 
2.25.1


Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A33FB673
	for <kvmarm@lists.linux.dev>; Thu, 21 Mar 2024 16:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711040263; cv=none; b=gtt4ubL/bIBXCgpeULsQOyrXUmXgC74RwN2t+bhdWQxqv+O7YIwXg+qs6M/3p5W9LF52l1NLJRCrpxOgNmK73MjumjqIiS4GN9QJ+aE73k4s04Pm2fGOIHSprjwwCs2SafYlOmyiyJNnmC9MsybM5LSbBf5zw/kgzCKSJg4YZHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711040263; c=relaxed/simple;
	bh=YwyKJWx57Y4dTphp+OTDlJ7dGtsmklm7pKtvdGu0lqs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fZfhLYWjg+shfq3VYd98o/t05UQpqxSb2TJE9HnTx4Qq+FqnKzDWhVzPOC2SfYHpN7txFRO+GC2oqa5Z9bgpxKuo0neAprAimp2gRdP27peqmdfyTb415JvWpBmrucF7i2P6Rvs604bzbK5jXHCuQ3+lUAeWXEOaPMNDSn2BzbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DAA371007;
	Thu, 21 Mar 2024 09:58:15 -0700 (PDT)
Received: from merodach.members.linode.com (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 480613F67D;
	Thu, 21 Mar 2024 09:57:40 -0700 (PDT)
From: James Morse <james.morse@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Jing Zhang <jingzhangos@google.com>,
	James Morse <james.morse@arm.com>
Subject: [PATCH v3 0/6] KVM: arm64: Hide unsupported MPAM from the guest
Date: Thu, 21 Mar 2024 16:57:22 +0000
Message-Id: <20240321165728.31907-1-james.morse@arm.com>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

'lo

Sorry skipped a cycle, I got busy with the resctrl end of this, and it took
me a while to convince myself doing this can still work if we need to
prevent migration to incompatible hardware.

The change since v2 is to (mostly) ignore the value provided by user-space
as the simplest thing to do. The value is ignored when it matches the
sanitised hardware value - as that is the value exposed by the bug. But
otherwise is checked normally. This allows the value to be used to prevent
migration on some hypothetical MPAM==2 hardware if that is incompatible. If
it is compatible, the writeable-id-registers can be used. Sufficiently hairy
that I added a test.

~

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
2018. (also noted on patch 2).

This series is based on Linus' commit 23956900041d and can be retrieved from:
https://git.kernel.org/pub/scm/linux/kernel/git/morse/linux.git
mpam/kvm_mpam_fix/v3

Sorry for the mid-merge window base, I'm away for a few weeks - this should
rebase trivially onto rc1.

Thanks

James

[v1] https://lore.kernel.org/linux-arm-kernel/20200925160102.118858-1-james.morse@arm.com/
[v2] https://lore.kernel.org/linux-arm-kernel/20231207150804.3425468-1-james.morse@arm.com/

James Morse (6):
  arm64: head.S: Initialise MPAM EL2 registers and disable traps
  arm64: cpufeature: discover CPU support for MPAM
  KVM: arm64: Fix missing traps of guest accesses to the MPAM registers
  KVM: arm64: Disable MPAM visibility by default and ignore VMM writes
  KVM: arm64: selftests: Move the bulky macro invocation to a helper
  KVM: arm64: selftests: Test ID_AA64PFR0.MPAM isn't completely ignored

 .../arch/arm64/cpu-feature-registers.rst      |   2 +
 arch/arm64/Kconfig                            |  19 +++-
 arch/arm64/include/asm/cpu.h                  |   1 +
 arch/arm64/include/asm/cpufeature.h           |  13 +++
 arch/arm64/include/asm/el2_setup.h            |  16 +++
 arch/arm64/include/asm/kvm_arm.h              |   1 +
 arch/arm64/include/asm/mpam.h                 |  75 +++++++++++++
 arch/arm64/include/asm/sysreg.h               |   8 ++
 arch/arm64/kernel/Makefile                    |   2 +
 arch/arm64/kernel/cpufeature.c                | 104 ++++++++++++++++++
 arch/arm64/kernel/cpuinfo.c                   |   4 +
 arch/arm64/kernel/image-vars.h                |   5 +
 arch/arm64/kernel/mpam.c                      |   8 ++
 arch/arm64/kvm/hyp/include/hyp/switch.h       |  32 ++++++
 arch/arm64/kvm/sys_regs.c                     |  43 +++++++-
 arch/arm64/tools/cpucaps                      |   1 +
 arch/arm64/tools/sysreg                       |  32 ++++++
 .../selftests/kvm/aarch64/set_id_regs.c       |  64 ++++++++++-
 18 files changed, 424 insertions(+), 6 deletions(-)
 create mode 100644 arch/arm64/include/asm/mpam.h
 create mode 100644 arch/arm64/kernel/mpam.c

-- 
2.39.2


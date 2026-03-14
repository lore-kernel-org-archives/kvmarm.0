Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0C1D314B9A
	for <kvmarm@lists.linux.dev>; Sat, 14 Mar 2026 17:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773510705; cv=none; b=jIatOSmzzHCA+qdezkwpWbLcozrz9vEZmkqcHq6qbVYyyP9szIy88GZXEEH2Ytn2nVImp+3pduMRdf3J2pgxMfGjz1cwff+axtO07vVmnFI3XiQn6aFjxRZyej1yAI6e/LLeD82wPKpBLM3I/K32O5xi5k/dY2s0iTg1CrHEwm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773510705; c=relaxed/simple;
	bh=ky0TodqFmtCk9igM06yYCVcwJU5iu8azLX4ItOahUsU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=OQqleuJNSwDqialccZDL9VPAQH2Y6ZmwaOahjtoPMRnqnVY0ls4raRmaWtbe0ofOL6aEltFX61tLPAzk3YF6A4riCVl2rR7btvu3hZ5KIreV7xIkyJoPrulPTrR9g9aPwfT85teU413H9/IGftPj3sruayWSLDGfNovd11h3EbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 79262152B;
	Sat, 14 Mar 2026 10:51:31 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 21C013F73B;
	Sat, 14 Mar 2026 10:51:35 -0700 (PDT)
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	maz@kernel.org,
	oupton@kernel.org,
	miko.lenczewski@arm.com,
	kevin.brodsky@arm.com,
	broonie@kernel.org,
	ardb@kernel.org,
	suzuki.poulose@arm.com,
	lpieralisi@kernel.org,
	joey.gouly@arm.com,
	yuzenghui@huawei.com,
	yeoreum.yun@arm.com
Subject: [PATCH v17 0/8] support FEAT_LSUI
Date: Sat, 14 Mar 2026 17:51:25 +0000
Message-Id: <20260314175133.1084528-1-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since Armv9.6, FEAT_LSUI supplies the load/store instructions for
previleged level to access to access user memory without clearing
PSTATE.PAN bit.

This patchset support FEAT_LSUI and applies it mainly in
futex atomic operation and others.

This patch based on v7.0-rc3


Patch History
==============
from v16 to v17
  - remove loops in __lsui_cmpxchg32().
  - modify some comments and move them to commit message.
  - https://lore.kernel.org/all/20260312175243.1593864-1-yeoreum.yun@arm.com/

from v15 to v16:
  - remove positional operand in futex asm.
  - rebased to v7.0-rc3
  - https://lore.kernel.org/all/20260227151705.1275328-1-yeoreum.yun@arm.com/

from v14 to v15:
  - replace caslt to cast
  - cleanup the patch
  - https://lore.kernel.org/all/20260225182708.3225211-1-yeoreum.yun@arm.com/

from v13 to v14:
  - add LSUI config check in cpucap_is_possible()
  - fix build failure with clang-19
  - https://lore.kernel.org/all/20260223174802.458411-1-yeoreum.yun@arm.com/

from v12 to v13:
  - rebase to v7.0-rc1
  - apply CASLT for swapping guest descriptor
  - remove has_lsui() for checking cpu feature.
  - simplify __lsui_cmpxchg32() according to @Catalin's suggestion.
  - use uaccess_ttbr0_enable()/disable() for LSUI instructions.
  - https://lore.kernel.org/all/aYWuqTqM5MvudI5V@e129823.arm.com/

from v11 to v12:
  - rebase to v6.19-rc6
  - add CONFIG_ARM64_LSUI
  - enable LSUI when !CPU_BIG_ENDIAN and PAN presents.
  - drop the swp emulation with LSUI insns instead, disable it
    when LSUI presents.
  - some of small fixes (useless prefix and suffix and etc).
  - https://lore.kernel.org/all/20251214112248.901769-1-yeoreum.yun@arm.com/

from v10 to v11:
  - rebase to v6.19-rc1
  - use cast instruction to emulate deprecated swpb instruction
  - https://lore.kernel.org/all/20251103163224.818353-1-yeoreum.yun@arm.com/

from v9 to v10:
  - apply FEAT_LSUI to user_swpX emulation.
  - add test coverage for LSUI bit in ID_AA64ISAR3_EL1
  - rebase to v6.18-rc4
  - https://lore.kernel.org/all/20250922102244.2068414-1-yeoreum.yun@arm.com/

from v8 to v9:
  - refotoring __lsui_cmpxchg64()
  - rebase to v6.17-rc7
  - https://lore.kernel.org/all/20250917110838.917281-1-yeoreum.yun@arm.com/

from v7 to v8:
  - implements futex_atomic_eor() and futex_atomic_cmpxchg() with casalt
    with C helper.
  - Drop the small optimisation on ll/sc futex_atomic_set operation.
  - modify some commit message.
  - https://lore.kernel.org/all/20250816151929.197589-1-yeoreum.yun@arm.com/

from v6 to v7:
  - wrap FEAT_LSUI with CONFIG_AS_HAS_LSUI in cpufeature
  - remove unnecessary addition of indentation.
  - remove unnecessary mte_tco_enable()/disable() on LSUI operation.
  - https://lore.kernel.org/all/20250811163635.1562145-1-yeoreum.yun@arm.com/

from v5 to v6:
  - rebase to v6.17-rc1
  - https://lore.kernel.org/all/20250722121956.1509403-1-yeoreum.yun@arm.com/

from v4 to v5:
  - remove futex_ll_sc.h futext_lsui and lsui.h and move them to futex.h
  - reorganize the patches.
  - https://lore.kernel.org/all/20250721083618.2743569-1-yeoreum.yun@arm.com/

from v3 to v4:
  - rebase to v6.16-rc7
  - modify some patch's title.
  - https://lore.kernel.org/all/20250617183635.1266015-1-yeoreum.yun@arm.com/

from v2 to v3:
  - expose FEAT_LSUI to guest
  - add help section for LSUI Kconfig
  - https://lore.kernel.org/all/20250611151154.46362-1-yeoreum.yun@arm.com/

from v1 to v2:
  - remove empty v9.6 menu entry
  - locate HAS_LSUI in cpucaps in order
  - https://lore.kernel.org/all/20250611104916.10636-1-yeoreum.yun@arm.com/


Yeoreum Yun (8):
  arm64: cpufeature: add FEAT_LSUI
  KVM: arm64: expose FEAT_LSUI to guest
  KVM: arm64: kselftest: set_id_regs: add test for FEAT_LSUI
  arm64: futex: refactor futex atomic operation
  arm64: futex: support futex with FEAT_LSUI
  arm64: armv8_deprecated: disable swp emulation when FEAT_LSUI present
  KVM: arm64: use CAST instruction for swapping guest descriptor
  arm64: Kconfig: add support for LSUI

 arch/arm64/Kconfig                            |  20 ++
 arch/arm64/include/asm/cpucaps.h              |   2 +
 arch/arm64/include/asm/futex.h                | 307 ++++++++++++++----
 arch/arm64/include/asm/lsui.h                 |  27 ++
 arch/arm64/kernel/armv8_deprecated.c          |  16 +
 arch/arm64/kernel/cpufeature.c                |  10 +
 arch/arm64/kvm/at.c                           |  34 +-
 arch/arm64/kvm/sys_regs.c                     |   3 +-
 arch/arm64/tools/cpucaps                      |   1 +
 .../testing/selftests/kvm/arm64/set_id_regs.c |   1 +
 10 files changed, 361 insertions(+), 60 deletions(-)
 create mode 100644 arch/arm64/include/asm/lsui.h

--
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


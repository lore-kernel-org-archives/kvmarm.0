Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A95093FE341
	for <kvmarm@lists.linux.dev>; Thu, 12 Mar 2026 17:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773337970; cv=none; b=lQpqKT9y1EURhPRSIZSjt52EL1LV72POBQgIsJNRe9ocKok6rFaxKrTMzOpktih/l4Y/W+0LCeS5hLF8UHVu6f2xEXoBys9uLGf+pEfY9pj3DgnjCrdNyhCd03F5ZuHvjZBCYTTGxJLrBKA+mokkazp21f5fGbjmLjTu0byPKmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773337970; c=relaxed/simple;
	bh=aGZMRJkXF11EHpW5zxb25GXR22S9mh3MN8XDpM1BjHI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Ac7Jg9MGD7jnBVQoKSCpJVKVAKai7DSLGJ26q+BcoOLHT5h1Eg66Uwp5cHR+OFnXDwv4xW7Wi2LMsPKG+QvV3pMEUo2NXMd3i+hreW9Z8okFtNmdF5DJPwoMr5DVkOSXqmOwsCDWAh3FPe+GIpJCjgAXOiCpH383q0pfWtgU5/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C2F1A165C;
	Thu, 12 Mar 2026 10:52:41 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 6F2483F73B;
	Thu, 12 Mar 2026 10:52:45 -0700 (PDT)
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
Subject: [PATCH v16 0/8] support FEAT_LSUI
Date: Thu, 12 Mar 2026 17:52:35 +0000
Message-Id: <20260312175243.1593864-1-yeoreum.yun@arm.com>
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
 arch/arm64/include/asm/futex.h                | 318 ++++++++++++++----
 arch/arm64/include/asm/lsui.h                 |  27 ++
 arch/arm64/kernel/armv8_deprecated.c          |  16 +
 arch/arm64/kernel/cpufeature.c                |  10 +
 arch/arm64/kvm/at.c                           |  42 ++-
 arch/arm64/kvm/sys_regs.c                     |   3 +-
 arch/arm64/tools/cpucaps                      |   1 +
 .../testing/selftests/kvm/arm64/set_id_regs.c |   1 +
 10 files changed, 380 insertions(+), 60 deletions(-)
 create mode 100644 arch/arm64/include/asm/lsui.h

--
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


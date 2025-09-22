Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACFF32F5306
	for <kvmarm@lists.linux.dev>; Mon, 22 Sep 2025 10:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758536572; cv=none; b=I7/oogkTAsMKokaJ4BXU8kyE9ijScoZVmvuWca9JMdtihbcyJXhYSP73eMT1uoj+yUUfdmeZHm1aJBpKMJiMSqnB0imrfX8orkYYexpLGmOOJVWbvpDedbZVd0L56A4jtFSZGrSG+SzQAD3jqRIvK7b0VMzkZpHNzwYxZvmYCQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758536572; c=relaxed/simple;
	bh=TKoIACpDvCRORBma6dGuMqTYSr124BdjoyT0MEjQVu4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=rByynARflcyZxyFjvUyKwGsz9aQakAYGtbKQggNJVzYY4IiyczLquiRT/XZn/R2ZmXFMgK3TrkScCF0f/WIhhTWDPP4slnYRhX1AZHmwHx7cxV7KWln5/iT6rSFCMIUvh6VAStJIgg4PmVXdhRTmRDM9E2MXr0jlcDgVz44nWFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DCC3B14BF;
	Mon, 22 Sep 2025 03:22:41 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id CADB23F66E;
	Mon, 22 Sep 2025 03:22:47 -0700 (PDT)
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	broonie@kernel.org,
	maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	james.morse@arm.com,
	ardb@kernel.org,
	scott@os.amperecomputing.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	mark.rutland@arm.com
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH v9 0/6] support FEAT_LSUI and apply it on futex atomic ops
Date: Mon, 22 Sep 2025 11:22:39 +0100
Message-Id: <20250922102244.2068414-1-yeoreum.yun@arm.com>
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

This patchset support FEAT_LSUI and applies in futex atomic operation
where can replace from ldxr/stlxr pair implmentation with clearing
PSTATE.PAN bit to correspondant load/store unprevileged atomic operation
without clearing PSTATE.PAN bit.

Patch Sequences
================

Patch #1 adds cpufeature for FEAT_LSUI

Patch #2 expose FEAT_LSUI to guest

Patch #3 adds Kconfig for FEAT_LSUI

Patch #4 refactor former futex atomic-op implmentation with ll/sc &
         clearing PSTATE.PAN

Patch #5 support futex atomic-op with FEAT_LSUI

Patch History
==============
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
  - expose FEAT_LUSI to guest
  - add help section for LUSI Kconfig
  - https://lore.kernel.org/all/20250611151154.46362-1-yeoreum.yun@arm.com/

from v1 to v2:
  - remove empty v9.6 menu entry
  - locate HAS_LUSI in cpucaps in order
  - https://lore.kernel.org/all/20250611104916.10636-1-yeoreum.yun@arm.com/

Yeoreum Yun (5):
  arm64: cpufeature: add FEAT_LSUI
  KVM: arm64: expose FEAT_LSUI to guest
  arm64: Kconfig: Detect toolchain support for LSUI
  arm64: futex: refactor futex atomic operation
  arm64: futex: support futex with FEAT_LSUI

 arch/arm64/Kconfig             |   5 +
 arch/arm64/include/asm/futex.h | 304 ++++++++++++++++++++++++++++-----
 arch/arm64/kernel/cpufeature.c |  10 ++
 arch/arm64/kvm/sys_regs.c      |   5 +-
 arch/arm64/tools/cpucaps       |   1 +
 5 files changed, 277 insertions(+), 48 deletions(-)

--
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


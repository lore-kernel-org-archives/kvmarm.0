Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A25E1DFDAB
	for <kvmarm@lists.linux.dev>; Mon, 11 Aug 2025 16:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754930029; cv=none; b=qRZojOswN9KGZxfA5abRZgDdL+35m9XPBDQWpno10ewdCsd4o3esBLQ+qlxiV7XZab89wjK2yX3hOOJ31GQ36arPUeeLfoeHaIL/8BSYIQo5vJSEeqJAntkQ7+2UMPY4+9uUvKVf3s+d/NqF46Q91+zLlhIewKICb+dbsVJgHDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754930029; c=relaxed/simple;
	bh=pU2UzEZKy3+2XSauLiBQ5ZkFLpIIsyJ0rjtuhV/PuCA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=hS+VeWipx+z+VUk1RG/DHsZpJfm1JlbCKjMNy4krdM7TBxnIUOP6hmQD0aGKtnNWEaSjhxm7SuwPzosMOJ52W8Al/gpMB3oQTJ2GjLjeYKFsEVoLPbraL5OtWLtICtaDyzpmgwjdfZ6efZf0n1Dznw7lf3wWchg7CM5n9SHOorA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BCF56113E;
	Mon, 11 Aug 2025 09:33:37 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 3BFBD3F738;
	Mon, 11 Aug 2025 09:33:42 -0700 (PDT)
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	maz@kernel.org,
	broonie@kernel.org,
	oliver.upton@linux.dev,
	anshuman.khandual@arm.com,
	robh@kernel.org,
	james.morse@arm.com,
	mark.rutland@arm.com,
	joey.gouly@arm.com,
	ry111@xry111.site,
	Dave.Martin@arm.com,
	ahmed.genidi@arm.com,
	kevin.brodsky@arm.com,
	scott@os.amperecomputing.com,
	mbenes@suse.cz,
	james.clark@linaro.org,
	frederic@kernel.org,
	rafael@kernel.org,
	pavel@kernel.org,
	ryan.roberts@arm.com,
	suzuki.poulose@arm.com
Cc: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH v2 0/6] initialize SCTRL2_ELx
Date: Mon, 11 Aug 2025 17:33:34 +0100
Message-Id: <20250811163340.1561893-1-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This series introduces initial support for the SCTLR2_ELx registers in Linux.
The feature is optional starting from ARMv8.8/ARMv9.3,
and becomes mandatory from ARMv8.9/ARMv9.4.

Currently, Linux has no strict need to modify SCTLR2_ELx—
at least assuming that firmware initializes
these registers to reasonable defaults.

However, several upcoming architectural features will require configuring
control bits in these registers.
Notable examples include FEAT_PAuth_LR and FEAT_CPA2.

Patch History
==============
from v1 to v2:
  - rebase to v6.17-rc1
  - https://lore.kernel.org/all/20250804121724.3681531-1-yeoreum.yun@arm.com/

Yeoreum Yun (6):
  arm64: make SCTLR2_EL1 accessible
  arm64: initialise SCTLR2_ELx register at boot time
  arm64: save/restore SCTLR2_EL1 when cpu_suspend()/resume()
  arm64: init SCTLR2_EL1 at cpu_soft_restart()
  arm64: make the per-task SCTLR2_EL1
  KVM: arm64: initialise SCTLR2_EL1 at __kvm_host_psci_cpu_entry()

 arch/arm64/include/asm/el2_setup.h   | 14 +++++++++++++-
 arch/arm64/include/asm/processor.h   |  5 +++++
 arch/arm64/include/asm/suspend.h     |  2 +-
 arch/arm64/include/asm/sysreg.h      | 22 ++++++++++++++++++++++
 arch/arm64/kernel/cpu-reset.S        |  6 ++++++
 arch/arm64/kernel/head.S             |  5 ++++-
 arch/arm64/kernel/process.c          |  9 +++++++++
 arch/arm64/kvm/hyp/nvhe/psci-relay.c |  3 +++
 arch/arm64/mm/proc.S                 | 26 ++++++++++++++++++--------
 9 files changed, 81 insertions(+), 11 deletions(-)


base-commit: 8f5ae30d69d7543eee0d70083daf4de8fe15d585
--
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


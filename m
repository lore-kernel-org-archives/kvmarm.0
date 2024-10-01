Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07D3E1B81D1
	for <kvmarm@lists.linux.dev>; Tue,  1 Oct 2024 04:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727757376; cv=none; b=TByhzq2eKXD2+tA0g49ugjxUtkAeeQJsrZNMJ8KOmJ0vCa0pHROOX7Fi/4oCaWOIGTXWL+dYGOPc+Pe2ogYT1ZfTV90dXydIPzaoWf8HTc/yjZ8/IouI1jWAGMdqGbFbTEyXrlv1gwkzC8rN4eL5MaPYeuebKxMLnOAoNe5Onws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727757376; c=relaxed/simple;
	bh=noXrtJKhSn1L6vtY7ar3QesMm/JTjM/ohQdc+mzdupk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=EMNG0YXx05iTaF7aPHsMYzGUFKfgDM4p2LHLgDBgQlO0kuLYmJcy5YGUxgnUL6p8y5AM44vCGlFa/FuDjKdmX2qHhHLF/6fbLehcgHKuyeX/AeF34U/PYZjwhBI+LupN0cTxy+8rdUEkaMOjv7OKcqcjggVeOUV0JB52h7/vRCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9D7EA339;
	Mon, 30 Sep 2024 21:36:42 -0700 (PDT)
Received: from a077893.blr.arm.com (a077893.blr.arm.com [10.162.16.61])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 327773F58B;
	Mon, 30 Sep 2024 21:36:08 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	kvmarm@lists.linux.dev
Subject: [PATCH 0/3] arm64/hw_breakpoint: Enable FEAT_Debugv8p9
Date: Tue,  1 Oct 2024 10:05:59 +0530
Message-Id: <20241001043602.1116991-1-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series enables FEAT_Debugv8p9 thus extending breakpoint and watchpoint
support upto 64. This series is based on v6.12-rc1 after applying the KVM
FEAT_FGT2 FGU series.

https://lore.kernel.org/all/20241001024356.1096072-1-anshuman.khandual@arm.com/

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: James Morse <james.morse@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org

Changes in V1:

- Changed FTR_STRICT to FTR_NONSTRICT for the following ID_AA64DFR1_EL1
  register fields - ABL_CMPs, DPFZS, PMICNTR, CTX_CMPs, WRPs and BRPs

Changes in RFC V2:

https://lore.kernel.org/linux-arm-kernel/20240620092607.267132-1-anshuman.khandual@arm.com/

- This series has been split from RFC V1 dealing only with arm64 breakpoints
- Restored back DBG_MDSCR_MASK definition (unrelated change)
- Added preempt_disable()/enable() blocks between selecting banks and registers

Changes in RFC:

https://lore.kernel.org/all/20240405080008.1225223-1-anshuman.khandual@arm.com/

Anshuman Khandual (3):
  arm64/cpufeature: Add field details for ID_AA64DFR1_EL1 register
  arm64/boot: Enable EL2 requirements for FEAT_Debugv8p9
  arm64/hw_breakpoint: Enable FEAT_Debugv8p9

 Documentation/arch/arm64/booting.rst    | 19 ++++++++++
 arch/arm64/include/asm/debug-monitors.h |  1 +
 arch/arm64/include/asm/el2_setup.h      | 27 +++++++++++++
 arch/arm64/include/asm/hw_breakpoint.h  | 50 ++++++++++++++++++++-----
 arch/arm64/include/asm/kvm_arm.h        |  1 +
 arch/arm64/kernel/cpufeature.c          | 21 ++++++++---
 arch/arm64/kernel/debug-monitors.c      | 16 ++++++--
 arch/arm64/kernel/hw_breakpoint.c       | 33 ++++++++++++++++
 8 files changed, 149 insertions(+), 19 deletions(-)

-- 
2.25.1


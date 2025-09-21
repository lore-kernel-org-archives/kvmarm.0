Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 573904C6E
	for <kvmarm@lists.linux.dev>; Sun, 21 Sep 2025 00:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758415999; cv=none; b=a9Y9zbtJMHg1VdTFkitL9TUCC63MwugMCHw/0RBi98wc3wk2NGWBjJDlYcL7nhcu92+cggnDf3kELPndhwuTHUAH7zgWCwg8FV7Z14g6yYUGMh8ZqEIs1QhS8/TmSE1fEJLLdXsAlMCNKBMB17K8q4B+rVEwGlg1tgN61bcgKh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758415999; c=relaxed/simple;
	bh=FgtXAyhF+sk8xLaI+Sc2uMnz5ebHxJ+hsxJ/40fyF/Y=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=KgqNpM6udQkgdLZu9Nx3yKbRh6946O52vyuMcGM4bzedbC/hxe2vt6lZ4G+1IUSVFtQbOfFKFeDemC8C6lKrFogyCK8bzUYiGh66/VkvVIB/S7O28i3v+a7sW67TPBMl/vQJnOqKLecITpiMhfGOLCTzH19uYLCU/QQjLSo93mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CD9691655;
	Sat, 20 Sep 2025 17:53:01 -0700 (PDT)
Received: from a076716.blr.arm.com (a076716.blr.arm.com [10.164.21.47])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A3A8D3F66E;
	Sat, 20 Sep 2025 17:53:06 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	will@kernel.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH V5 0/4] arm64/sysreg: Clean up TCR_EL1 field macros
Date: Sun, 21 Sep 2025 06:22:56 +0530
Message-Id: <20250921005300.2535994-1-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently TCR_EL1 field macros are sprinkled across the arm64 platform code
including KVM implementation. Clean these up via updating required register
filed definitions in tools sysreg format and then subsequently doing all
necessary replacements. All required TCR_XXX macros have been moved from
(asm/pgtable-hwdef.h) into KVM header (asm/kvm_arm.h) for their continued
usage in KVM.

The cleanup does not cause any functional change.

This applies on v6.17-rc6

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Mark Brown <broonie@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: kvmarm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org

Changes in V5:

- Split tools header and KVM changes into separate patches per Will

Changes in V4:

https://lore.kernel.org/all/20250907123000.414181-1-anshuman.khandual@arm.com/

- Dropped all unused TCR_XXX macros while moving into KVM header

Changes in V3:

https://lore.kernel.org/all/20250901072037.743380-1-anshuman.khandual@arm.com/

- KVM TCR_XXX flags are expressed via TCR_EL1_XXX flags per Marc

Changes in V2:

https://lore.kernel.org/all/20250829060215.1086792-1-anshuman.khandual@arm.com/

- Fixed ARM ARM version from 7.B to L.B
- Changed UnsignedEnum into Enum per Mark
- Dropped all TCR_EL1 replacements from KVM code
- Moved existing TCR_XXX macros from (asm/pgtable-hwdef.h) into KVM header
  (asm/kvm_arm.h) for their continued usage
- Dropped patches 3 and 4 which could be done subsequently

Changes in V1:

https://lore.kernel.org/linux-arm-kernel/20250818045759.672408-1-anshuman.khandual@arm.com/

Anshuman Khandual (4):
  tools: header : arm64: Replace TCR_NFD[0|1] with TCR_EL1_NFD[0|1]
  arm64/sysreg: Update TCR_EL1 register
  arm64/sysreg: Replace TCR_EL1 field macros
  KVM: arm64: Move inside all required TCR_XXX macros

 arch/arm64/include/asm/assembler.h     |  6 +-
 arch/arm64/include/asm/cputype.h       |  2 +-
 arch/arm64/include/asm/kvm_arm.h       | 43 +++++++++++
 arch/arm64/include/asm/mmu_context.h   |  4 +-
 arch/arm64/include/asm/pgtable-hwdef.h | 98 +-------------------------
 arch/arm64/include/asm/pgtable-prot.h  |  2 +-
 arch/arm64/include/asm/sysreg.h        |  2 -
 arch/arm64/kernel/cpufeature.c         |  4 +-
 arch/arm64/kernel/pi/map_kernel.c      |  8 +--
 arch/arm64/kernel/vmcore_info.c        |  2 +-
 arch/arm64/mm/proc.S                   | 36 ++++++----
 arch/arm64/tools/sysreg                | 52 +++++++++++---
 tools/arch/arm64/include/asm/cputype.h |  2 +-
 13 files changed, 127 insertions(+), 134 deletions(-)

-- 
2.25.1


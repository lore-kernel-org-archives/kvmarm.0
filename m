Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3809121CFFA
	for <kvmarm@lists.linux.dev>; Fri, 29 Aug 2025 06:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756447350; cv=none; b=HcsqQQSoVUpwmPFEfmF0Zo0XFOhJ3KaoLicdE1o5I7bGi0y3eQKs2wE92znF4jwo3iNnWWd5ifbmYRaibToXuK8Da56NdvYDzvN03P28ot3ECNQNEpqt2kQBRO8J9323LkAX+zqDGthUAvgOaKGvlV7G9DJKpu8d5ONT2WiIRoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756447350; c=relaxed/simple;
	bh=fkxELPNjdvOxdImKn5EW2lD4Dj7mmwIUhBj3BasDsIU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=GL+UQnzBhHUdZAxDwZmc3UZmk1/inD7EQz3FHgbaLO4WBNKJP+6yvi8Vav9SKRqOSFkqf2xD6wo3nS7ByC0jyhffef1hCxTerebXG8c65jAOxWYzCSVfG7mIs3PGzrd+juqXekcbbmT6nfnFKSNm7l3ZvVBsjUykmJK6mf4HLKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2880B1758;
	Thu, 28 Aug 2025 23:02:18 -0700 (PDT)
Received: from a076716.blr.arm.com (a076716.blr.arm.com [10.164.21.47])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 5494B3F63F;
	Thu, 28 Aug 2025 23:02:23 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH V2 0/2] arm64/sysreg: Clean up TCR_EL1 field macros
Date: Fri, 29 Aug 2025 11:32:13 +0530
Message-Id: <20250829060215.1086792-1-anshuman.khandual@arm.com>
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
necessary replacements. TCR_XXX macros are moved from (asm/pgtable-hwdef.h)
into KVM header (asm/kvm_arm.h) for their continued usage in KVM.

The cleanup does not cause any functional change.

This applies on v6.17-rc3

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Mark Brown <broonie@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: kvmarm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org

Changes in V2:

- Fixed ARM ARM version from 7.B to L.B
- Changed UnsignedEnum into Enum per Mark
- Dropped all TCR_EL1 replacements from KVM code
- Moved existing TCR_XXX macros from (asm/pgtable-hwdef.h) into KVM header
  (asm/kvm_arm.h) for their continued usage
- Dropped patches 3 and 4 which could be done subsequently

Changes in V1:

https://lore.kernel.org/linux-arm-kernel/20250818045759.672408-1-anshuman.khandual@arm.com/

Anshuman Khandual (2):
  arm64/sysreg: Update TCR_EL1 register
  arm64/sysreg: Replace TCR_EL1 field macros

 arch/arm64/include/asm/assembler.h     |   6 +-
 arch/arm64/include/asm/cputype.h       |   2 +-
 arch/arm64/include/asm/kvm_arm.h       |  92 +++++++++++++++++++++++
 arch/arm64/include/asm/mmu_context.h   |   4 +-
 arch/arm64/include/asm/pgtable-hwdef.h | 100 +------------------------
 arch/arm64/include/asm/pgtable-prot.h  |   2 +-
 arch/arm64/include/asm/sysreg.h        |   2 -
 arch/arm64/kernel/cpufeature.c         |   4 +-
 arch/arm64/kernel/pi/map_kernel.c      |   8 +-
 arch/arm64/kernel/vmcore_info.c        |   2 +-
 arch/arm64/mm/proc.S                   |  36 +++++----
 arch/arm64/tools/sysreg                |  52 +++++++++++--
 tools/arch/arm64/include/asm/cputype.h |   2 +-
 13 files changed, 178 insertions(+), 134 deletions(-)

-- 
2.25.1


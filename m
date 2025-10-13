Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 866FE2D4B7F
	for <kvmarm@lists.linux.dev>; Mon, 13 Oct 2025 05:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760333398; cv=none; b=Ba4YpS6zVctr91128BrOMKTt6iaJTC2G5tuDIoheEv1ZWhVXSbxsX7aJ04SV/p/JZeuUT5Z9IVJVpBeBFSlsHaCX5wr2qAU4mdHKqqwrUlRK4r6TVx0sRALELTHol0oHQmeYIOnASaqy3m2wCUAu4AgEAcJM/noJ+om+YMAVomA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760333398; c=relaxed/simple;
	bh=lRWnG0og5nQp7A0ZDN8ycgUjmNyIrIG/ToERsMwzvrw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=oJk/80xAAR4Oz/WFd1uU/XcoSGm/BnWEfNUdY9rwHbZgQLSm3rQDB0zevDeeRv5RyIKVjCl94OS4rIxCnfNgVDQmFo5Xtk5S5xREGzPtOcS0sY0Brh0T9oSM4o+bRHxt/QKH9W4HxS2YbU5KwwwpiHDYUp+xZizSMmjRxDNwy8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0435D12FC;
	Sun, 12 Oct 2025 22:29:47 -0700 (PDT)
Received: from a076716.blr.arm.com (a076716.blr.arm.com [10.164.21.47])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 9986E3F6A8;
	Sun, 12 Oct 2025 22:29:51 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-kernel@vger.kernel.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH V6 0/3] arm64/sysreg: Clean up TCR_EL1 field macros
Date: Mon, 13 Oct 2025 10:59:42 +0530
Message-Id: <20251013052945.2197190-1-anshuman.khandual@arm.com>
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

This applies on v6.18-rc1

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Mark Brown <broonie@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: kvmarm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org

Changes in V6:

- Added back definition for TCR_SH1_MASK as KVM on arm64 uses it now

Changes in V5:

https://lore.kernel.org/all/20250921005300.2535994-1-anshuman.khandual@arm.com/

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

Anshuman Khandual (3):
  tools: header: arm64: Replace TCR_NFD[0|1] with TCR_EL1_NFD[0|1]
  arm64/sysreg: Replace TCR_EL1 field macros
  KVM: arm64: Move inside all required TCR_XXX macros

 arch/arm64/include/asm/assembler.h     |  6 +-
 arch/arm64/include/asm/cputype.h       |  2 +-
 arch/arm64/include/asm/kvm_arm.h       | 45 ++++++++++++
 arch/arm64/include/asm/mmu_context.h   |  4 +-
 arch/arm64/include/asm/pgtable-hwdef.h | 98 +-------------------------
 arch/arm64/include/asm/pgtable-prot.h  |  2 +-
 arch/arm64/kernel/cpufeature.c         |  4 +-
 arch/arm64/kernel/pi/map_kernel.c      |  8 +--
 arch/arm64/kernel/vmcore_info.c        |  2 +-
 arch/arm64/mm/proc.S                   | 36 ++++++----
 tools/arch/arm64/include/asm/cputype.h |  2 +-
 11 files changed, 85 insertions(+), 124 deletions(-)

-- 
2.25.1


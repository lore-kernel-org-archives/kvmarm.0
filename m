Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 265411CD1E1
	for <kvmarm@lists.linux.dev>; Fri, 21 Feb 2025 04:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740112963; cv=none; b=P5KIvCixjVV/32TbIzNsrMxmkcdw0pnbSzNRamth9VNrQzvIIcugugi2h1q1EstWsw9e4fa59F2+os5t2NOih6CHaMAtIl4Gnlr/ENVKxZjI5qMPuGWMWimhewvzW2ZJVHy1AP7eopS8hNPam16VPzF5Otw8KbUe27aeZsYV6jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740112963; c=relaxed/simple;
	bh=GGb906K2VWG+4OalnI6S/0sqpalmaz8Ltc5IL4C3t5o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=OUWuc14AOlUeFGjVTMRCamJ28bC+/j7r1GkeK9LwsCbhT7lmUsFraSIz+/I6kk2O60cLzL3mhANTNNxnP/YKmtNVgWDKLHcRFkZJpPhmrXm4Skprbbrgm2ceCGbyeevdUHSgq0XeqJ5v9qR04ixv0opE3y3WDgbbz2JqMW9+Sg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 174BE1C01;
	Thu, 20 Feb 2025 20:42:58 -0800 (PST)
Received: from a077893.blr.arm.com (a077893.blr.arm.com [10.162.40.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8167F3F6A8;
	Thu, 20 Feb 2025 20:42:35 -0800 (PST)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: arm-kernel@lists.infradead.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH V2 0/8] arm64/mm: Drop PXD_TABLE_BIT
Date: Fri, 21 Feb 2025 10:12:19 +0530
Message-Id: <20250221044227.1145393-1-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove the PXX_TABLE_BIT definitions and instead rely on PXX_TYPE_MASK,
PXX_TYPE_SECT and PXX_TYPE_TABLE. The latter versions are more abstract
and also include the PTE_VALID bit.

This abstraction is valuable for the impending D128 page table support,
which doesn't have a single page table bit to determine table vs block.
Instead it has the skip level (SKL) field, where it will consider 0 to
mean table and any other value to mean a block entry. So PXX_TABLE_BIT
therefore doesn't fit into the D128 model well, but the type fields do.

This series applies on v6.14-rc3.

Changes in V2:

- Changed pmd_mkhuge() and pud_mkhuge() implementation
- Changed pud_bad() implementation with an additional patch

Changes in V1:

https://lore.kernel.org/all/20241005123824.1366397-1-anshuman.khandual@arm.com/

Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: James Morse <james.morse@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org

Anshuman Khandual (6):
  KVM: arm64: ptdump: Test PMD_TYPE_MASK for block mapping
  arm64/ptdump: Test PMD_TYPE_MASK for block mapping
  arm64/mm: Clear PXX_TYPE_MASK in mk_[pmd|pud]_sect_prot()
  arm64/mm: Clear PXX_TYPE_MASK and set PXD_TYPE_SECT in [pmd|pud]_mkhuge()
  arm64/mm: Check PXD_TYPE_TABLE in [p4d|pgd]_bad()
  arm64/mm: Drop PXD_TABLE_BIT

Ryan Roberts (2):
  arm64/mm: Check PUD_TYPE_TABLE in pud_bad()
  arm64/mm: Check pmd_table() in pmd_trans_huge()

 arch/arm64/include/asm/pgtable-hwdef.h |  5 --
 arch/arm64/include/asm/pgtable.h       | 65 ++++++++++++++++++--------
 arch/arm64/kvm/ptdump.c                |  4 +-
 arch/arm64/mm/ptdump.c                 |  4 +-
 4 files changed, 50 insertions(+), 28 deletions(-)

-- 
2.25.1


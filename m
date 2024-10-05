Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A22B7231C81
	for <kvmarm@lists.linux.dev>; Sat,  5 Oct 2024 12:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728131919; cv=none; b=HL3yt6SmOOY01d/4Yr5bLkkxYOFavuAJ2BAuYlIBVvfX77ykD64aAYliC5HuzTcO2RmEOSw0/3ggOpyU0kN47fUJGNqcezMUtEm4ORe+NKwcBKU3FtPgp73XgTzpVCaD43tLmII74d9EtzuLtblbWqdQzwMPiQW2E4Y8URCfD3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728131919; c=relaxed/simple;
	bh=5bfDVZsX8OSO8Dych981R9gu5INRDbKr3puS3EVh6SQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Rdk2aS7RNDgdaXzJJjKOFkXRT7QfmOYEqwCtW8EJ5cVFKyj6fHbprhhScD4DUcFlnXqXQpSITo9cuc4FJhzO0IK7bFOhGrxWqQEO076T32swSH/vNVdbEVrwcdUNq1rq+wNNpLX4Eqdr5BCs9e0yp4exnVqcn41Dqou8H4liATU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 90BAB1007;
	Sat,  5 Oct 2024 05:38:59 -0700 (PDT)
Received: from a077893.arm.com (unknown [10.163.39.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 397BC3F64C;
	Sat,  5 Oct 2024 05:38:25 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
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
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] arm64/mm: Drop PXD_TABLE_BIT
Date: Sat,  5 Oct 2024 18:08:19 +0530
Message-Id: <20241005123824.1366397-1-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Clearing PXD_TABLE_BIT i.e bit[1] on a page table entry always operates on
the assumption that subsequent PXD_VALID i.e bit[0] is set. That's because
bits[1:0]="01" makes a block mapping. So it is prudent to treat bits[1:0]
as a single register field, which should be updated as block or table etc.
Although mk_[pmd|pud]_sect_prot() helpers go to some extent in using these
PXD_TYPE_SECT macros, their usage is not really consistent else where.

This series removes these table bit clearing for block mapping creation and
eventually completely drops off those table macros.

This series applies on v6.12-rc1.

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

Anshuman Khandual (5):
  arm64/mm: Drop pte_mkhuge()
  arm64/mm: Replace PXD_TABLE_BIT with PXD_TYPE_[MASK|SECT]
  arm64/ptdump: Test PMD_TYPE_MASK for block mapping
  KVM: arm64: ptdump: Test PMD_TYPE_MASK for block mapping
  arm64/mm: Drop PXD_TABLE_BIT

 arch/arm64/include/asm/pgtable-hwdef.h |  6 +-----
 arch/arm64/include/asm/pgtable.h       | 20 ++++++++------------
 arch/arm64/kvm/ptdump.c                |  4 ++--
 arch/arm64/mm/hugetlbpage.c            |  2 +-
 arch/arm64/mm/ptdump.c                 |  8 ++++----
 5 files changed, 16 insertions(+), 24 deletions(-)

-- 
2.25.1


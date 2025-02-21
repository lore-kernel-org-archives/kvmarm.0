Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68E561E5739
	for <kvmarm@lists.linux.dev>; Fri, 21 Feb 2025 04:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740112972; cv=none; b=gO5egBPPd7DeYRwxILB8soVx8j4BCrOJ/Em99/c9eTDEp8JBuy125nocHFCD+JwCwvtoHeB8z32uiGipb8OXy9PhKonsf4K54Z+K5jQIwDZO9W3qzyC/jHPAFaOUilzVzEhCHRKSd/3gFmvs3YO6ll+5o16hHUs5wQIAv/QHbwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740112972; c=relaxed/simple;
	bh=unapYRLzN4vF8MFbKRnudeDyNWTZmUnDpCl2Q5uv/zQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jEwoopIn262+6Nzxs7voUHeMhSgb88PB3e+foGcghiqWPS2AagzCYjVkP6jiBQRVT90wwH0bkbGC1hT3Dyuus24DXHvbPLpEi4FISSbS3LEDzPbpzATUwScVsYHh02Obr7qzhecDKadKvXpEHqWxG3eaKz+jo2GqEQWNOivsnN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A191B1C01;
	Thu, 20 Feb 2025 20:43:08 -0800 (PST)
Received: from a077893.blr.arm.com (a077893.blr.arm.com [10.162.40.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 145E03F6A8;
	Thu, 20 Feb 2025 20:42:45 -0800 (PST)
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
Subject: [PATCH V2 2/8] arm64/ptdump: Test PMD_TYPE_MASK for block mapping
Date: Fri, 21 Feb 2025 10:12:21 +0530
Message-Id: <20250221044227.1145393-3-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250221044227.1145393-1-anshuman.khandual@arm.com>
References: <20250221044227.1145393-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Test given page table entries against PMD_TYPE_SECT on PMD_TYPE_MASK mask
bits for identifying block mappings in stage 1 page tables.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/mm/ptdump.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/mm/ptdump.c b/arch/arm64/mm/ptdump.c
index 688fbe0271ca..8cec0da4cff2 100644
--- a/arch/arm64/mm/ptdump.c
+++ b/arch/arm64/mm/ptdump.c
@@ -80,8 +80,8 @@ static const struct ptdump_prot_bits pte_bits[] = {
 		.set	= "CON",
 		.clear	= "   ",
 	}, {
-		.mask	= PTE_TABLE_BIT | PTE_VALID,
-		.val	= PTE_VALID,
+		.mask	= PMD_TYPE_MASK,
+		.val	= PMD_TYPE_SECT,
 		.set	= "BLK",
 		.clear	= "   ",
 	}, {
-- 
2.25.1


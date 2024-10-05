Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C527E231C81
	for <kvmarm@lists.linux.dev>; Sat,  5 Oct 2024 12:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728131929; cv=none; b=N5XELB9e/boXg9ke4tB+apPGfwol5l1VEACBM8ptAIwZaXeptY4wbF3R+uswEP87mJOxUl8pvLWpTE2wDaoeTRy5d/UL7MD4DPKn27L9zAaSMC91AEM+lUIRf7OFDdjg6FtVuEDQJ4Y5xy7AzHIlkWRIkssk/mmXc8eurmz1kLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728131929; c=relaxed/simple;
	bh=Z7kazaIF5WNMGOyAEoMizSXGQAqW9WcgsTT4OhzJgjA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=q4u5g35TQBbIx21P3gPdZqmMryUjvk5Rdndh0bSqFhM4GdHv/8ptPq30o0EfvbaapJnLFvli0XSPR/za8FAaDw5AjE4sexFZRUv6NSBG4CEq6N5sC8JIpO+XnjVB1BmkrylGOipq6dO3p3UKLEsKj4KxERrww40+DooMeLa3gt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 074A11063;
	Sat,  5 Oct 2024 05:39:17 -0700 (PDT)
Received: from a077893.arm.com (unknown [10.163.39.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A24133F64C;
	Sat,  5 Oct 2024 05:38:43 -0700 (PDT)
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
Subject: [PATCH 4/5] KVM: arm64: ptdump: Test PMD_TYPE_MASK for block mapping
Date: Sat,  5 Oct 2024 18:08:23 +0530
Message-Id: <20241005123824.1366397-5-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241005123824.1366397-1-anshuman.khandual@arm.com>
References: <20241005123824.1366397-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This changes stage-2 ptdump making it test given page table entries against
PMD_TYPE_SECT on PMD_TYPE_MASK bits for a block mapping, as is the case for
stage-1 ptdump.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: James Morse <james.morse@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/kvm/ptdump.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
index e4a342e903e2..098416d7e5c2 100644
--- a/arch/arm64/kvm/ptdump.c
+++ b/arch/arm64/kvm/ptdump.c
@@ -52,8 +52,8 @@ static const struct ptdump_prot_bits stage2_pte_bits[] = {
 		.set	= "AF",
 		.clear	= "  ",
 	}, {
-		.mask	= PTE_TABLE_BIT | PTE_VALID,
-		.val	= PTE_VALID,
+		.mask	= PMD_TYPE_MASK,
+		.val	= PMD_TYPE_SECT,
 		.set	= "BLK",
 		.clear	= "   ",
 	},
-- 
2.25.1


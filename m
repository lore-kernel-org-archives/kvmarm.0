Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C51F71AA7B3;
	Fri,  4 Oct 2024 15:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728055709; cv=none; b=eCnKDzqGC/sOU5y1a46ywcH0fjpLcY98+WXp4TUWM8u/lYlnwQKa2luCN+SFDquu/BGU9DxThtDxH86uZrlghsMi5EKk9hBK4aINhxlXkaMkad7I9Fqu/5O6G8oRZwCM4o2n/MetCGx4yw3mEbu3cy4R1gS9SR4v2EyvZLMZpI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728055709; c=relaxed/simple;
	bh=3EwLA5Bo1+Udhn5axwJZ+IQN2yjc30v3PSzrjwGhrZ8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DpDoERaPqisWx/9X+fMSosGzRfvK7kUQZ44kQe5MXOATmHoeUIUqJnVzzVXSLsXqKg0SqqfbHAOGzk7ZbaTxXfijd6OPab35QT2n5GGmgIxpQqU5ukGLtP2UV/6qnEWR88VMtPXpJP48rqeYxH32Wd4ClqYzrG4RoI8qbxa8bTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C34C5339;
	Fri,  4 Oct 2024 08:28:56 -0700 (PDT)
Received: from e122027.cambridge.arm.com (unknown [10.1.25.25])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 144023F640;
	Fri,  4 Oct 2024 08:28:22 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH v5 02/43] kvm: arm64: pgtable: Track the number of pages in the entry level
Date: Fri,  4 Oct 2024 16:27:23 +0100
Message-Id: <20241004152804.72508-3-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241004152804.72508-1-steven.price@arm.com>
References: <20241004152804.72508-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Suzuki K Poulose <suzuki.poulose@arm.com>

Keep track of the number of pages allocated for the top level PGD,
rather than computing it every time (though we need it only twice now).
This will be used later by Arm CCA KVM changes.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 2 ++
 arch/arm64/kvm/hyp/pgtable.c         | 5 +++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 03f4c3d7839c..25b512756200 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -404,6 +404,7 @@ static inline bool kvm_pgtable_walk_lock_held(void)
  * struct kvm_pgtable - KVM page-table.
  * @ia_bits:		Maximum input address size, in bits.
  * @start_level:	Level at which the page-table walk starts.
+ * @pgd_pages:		Number of pages in the entry level of the page-table.
  * @pgd:		Pointer to the first top-level entry of the page-table.
  * @mm_ops:		Memory management callbacks.
  * @mmu:		Stage-2 KVM MMU struct. Unused for stage-1 page-tables.
@@ -414,6 +415,7 @@ static inline bool kvm_pgtable_walk_lock_held(void)
 struct kvm_pgtable {
 	u32					ia_bits;
 	s8					start_level;
+	u8					pgd_pages;
 	kvm_pteref_t				pgd;
 	struct kvm_pgtable_mm_ops		*mm_ops;
 
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index b11bcebac908..9e1be28c3dc9 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1534,7 +1534,8 @@ int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
 	u32 sl0 = FIELD_GET(VTCR_EL2_SL0_MASK, vtcr);
 	s8 start_level = VTCR_EL2_TGRAN_SL0_BASE - sl0;
 
-	pgd_sz = kvm_pgd_pages(ia_bits, start_level) * PAGE_SIZE;
+	pgt->pgd_pages = kvm_pgd_pages(ia_bits, start_level);
+	pgd_sz = pgt->pgd_pages * PAGE_SIZE;
 	pgt->pgd = (kvm_pteref_t)mm_ops->zalloc_pages_exact(pgd_sz);
 	if (!pgt->pgd)
 		return -ENOMEM;
@@ -1586,7 +1587,7 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
 	};
 
 	WARN_ON(kvm_pgtable_walk(pgt, 0, BIT(pgt->ia_bits), &walker));
-	pgd_sz = kvm_pgd_pages(pgt->ia_bits, pgt->start_level) * PAGE_SIZE;
+	pgd_sz = pgt->pgd_pages * PAGE_SIZE;
 	pgt->mm_ops->free_pages_exact(kvm_dereference_pteref(&walker, pgt->pgd), pgd_sz);
 	pgt->pgd = NULL;
 }
-- 
2.34.1


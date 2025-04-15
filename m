Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 638F8274665
	for <kvmarm@lists.linux.dev>; Tue, 15 Apr 2025 05:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744695917; cv=none; b=LCmpQ7TclG8kF+mwpGdNBBcWArq4aISmebCy2yq4io4VFxnRRUWwNaCJGHbdEnKyyIggHIR1uiTXy9+XNIsaWpTACyBeUZlC3STb49ysR0kIxXIW7/9k84egZbf2r0eTBVMWIkDA2ZmWcwl1T7RhaVdfuEq5RWK4P+AoztvjnPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744695917; c=relaxed/simple;
	bh=FDnB9voEkiJNDZy8LRUnYY/6P86aa7l3pmQpvvQiwoI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hOxPhz8uQFtCm8bbFH9Vl0n36wJFtp0j9Bbh9YSs780UfOiZcWevccrZcKMnPCZfF5J9otrWmM0gfKtq++/Ei/Hk9sNVXrUWvsTtWxN5gEWwWj5tmI9/5o/BzCZh1UcqzB4Uw/Mgg0k4puW7lUWWbHEnvYprlvRiKN9uTy2qncA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EE23315A1;
	Mon, 14 Apr 2025 22:45:12 -0700 (PDT)
Received: from a077893.arm.com (unknown [10.163.49.104])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B630F3F66E;
	Mon, 14 Apr 2025 22:45:11 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Anshuman Khandual <anshuman.khandual@arm.com>
Subject: [PATCH V2] arm64/mm: Implement pte_po_index() for permission overlay index
Date: Tue, 15 Apr 2025 11:14:42 +0530
Message-Id: <20250415054442.2287891-1-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ryan Roberts <ryan.roberts@arm.com>

Previously pte_access_permitted() used FIELD_GET() directly to retrieve
the permission overlay index from the pte. However, FIELD_GET() doesn't
work for 128 bit quanitites. Since we are about to add support for D128
pgtables, let's create a specific helper, pte_po_index() which can do
the required mask and shift regardless of the data type width.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
This patch applies on v6.15-rc2

Changes in V2:

- Replaced FIELD_GET() in compute_s1_overlay_permissions() per Ryan

Changes in V1:

https://lore.kernel.org/linux-arm-kernel/20250410052021.1533180-1-anshuman.khandual@arm.com/

 arch/arm64/include/asm/pgtable-hwdef.h | 1 +
 arch/arm64/include/asm/pgtable-prot.h  | 2 ++
 arch/arm64/include/asm/pgtable.h       | 2 +-
 arch/arm64/kvm/at.c                    | 2 +-
 4 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
index f3b77deedfa2..028a164924df 100644
--- a/arch/arm64/include/asm/pgtable-hwdef.h
+++ b/arch/arm64/include/asm/pgtable-hwdef.h
@@ -211,6 +211,7 @@
 #define PTE_PO_IDX_2	(_AT(pteval_t, 1) << 62)
 
 #define PTE_PO_IDX_MASK		GENMASK_ULL(62, 60)
+#define PTE_PO_IDX_SHIFT	60
 
 
 /*
diff --git a/arch/arm64/include/asm/pgtable-prot.h b/arch/arm64/include/asm/pgtable-prot.h
index 7830d031742e..b53bc241e4e7 100644
--- a/arch/arm64/include/asm/pgtable-prot.h
+++ b/arch/arm64/include/asm/pgtable-prot.h
@@ -136,6 +136,8 @@ static inline bool __pure lpa2_is_enabled(void)
 	((pte & BIT(PTE_PI_IDX_1)) >> (PTE_PI_IDX_1 - 1)) | \
 	((pte & BIT(PTE_PI_IDX_0)) >> (PTE_PI_IDX_0 - 0)))
 
+#define pte_po_index(pte)	((pte_val(pte) & PTE_PO_IDX_MASK) >> PTE_PO_IDX_SHIFT)
+
 /*
  * Page types used via Permission Indirection Extension (PIE). PIE uses
  * the USER, DBM, PXN and UXN bits to to generate an index which is used
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index d3b538be1500..41979c0e6c21 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -182,7 +182,7 @@ static inline bool por_el0_allows_pkey(u8 pkey, bool write, bool execute)
 	(((pte_val(pte) & (PTE_VALID | PTE_USER)) == (PTE_VALID | PTE_USER)) && (!(write) || pte_write(pte)))
 #define pte_access_permitted(pte, write) \
 	(pte_access_permitted_no_overlay(pte, write) && \
-	por_el0_allows_pkey(FIELD_GET(PTE_PO_IDX_MASK, pte_val(pte)), write, false))
+	por_el0_allows_pkey(pte_po_index(pte), write, false))
 #define pmd_access_permitted(pmd, write) \
 	(pte_access_permitted(pmd_pte(pmd), (write)))
 #define pud_access_permitted(pud, write) \
diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index f74a66ce3064..66bee3f2d7c2 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -1073,7 +1073,7 @@ static void compute_s1_overlay_permissions(struct kvm_vcpu *vcpu,
 {
 	u8 idx, pov_perms, uov_perms;
 
-	idx = FIELD_GET(PTE_PO_IDX_MASK, wr->desc);
+	idx = pte_po_index(__pte(wr->desc));
 
 	switch (wi->regime) {
 	case TR_EL10:
-- 
2.25.1


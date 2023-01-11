Received: from out-73.mta0.migadu.com (out-73.mta0.migadu.com [91.218.175.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D91180
	for <kvmarm@lists.linux.dev>; Wed, 11 Jan 2023 00:23:18 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1673395415;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dAXX/LNlPU0/7x/WB4sHfAEpk6aprKisr31vwb0y/J8=;
	b=rVdEIqr8nA4DZ0XZnB6dpg6NqL8ss9zcS6ljQu0ScAqDn7Ex0/tR+GZUXTBrnHfQDj3JkE
	ZftP2b2B3vJtXev9rt83En5kutZG7+iIa7S9lyOAGHvua4rNBcnxXq1THmnR63aVDn2wnE
	Cx5chH2cJisrpGtaLO37mctfcSrepu4=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Quentin Perret <qperret@google.com>,
	Will Deacon <will@kernel.org>,
	Reiji Watanabe <reijiw@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 2/5] KVM: arm64: Add a mask for all leaf PTE attributes
Date: Wed, 11 Jan 2023 00:02:57 +0000
Message-Id: <20230111000300.2034799-3-oliver.upton@linux.dev>
In-Reply-To: <20230111000300.2034799-1-oliver.upton@linux.dev>
References: <20230111000300.2034799-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

No functional change intended.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_pgtable.h | 3 +++
 arch/arm64/kvm/hyp/pgtable.c         | 7 +++----
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 8071698cc680..f8f6b4d2735a 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -73,6 +73,9 @@ typedef u64 kvm_pte_t;
 					 KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | \
 					 KVM_PTE_LEAF_ATTR_HI_S2_XN)
 
+#define KVM_PTE_LEAF_ATTRS		(KVM_PTE_LEAF_ATTR_LO | \
+					 KVM_PTE_LEAF_ATTR_HI)
+
 #define KVM_PTE_ADDR_MASK		GENMASK(47, PAGE_SHIFT)
 #define KVM_PTE_ADDR_51_48		GENMASK(15, 12)
 
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 3efe3aca3cb9..26f61462527d 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -111,7 +111,7 @@ static kvm_pte_t kvm_init_valid_leaf_pte(u64 pa, kvm_pte_t attr, u32 level)
 	u64 type = (level == KVM_PGTABLE_MAX_LEVELS - 1) ? KVM_PTE_TYPE_PAGE :
 							   KVM_PTE_TYPE_BLOCK;
 
-	pte |= attr & (KVM_PTE_LEAF_ATTR_LO | KVM_PTE_LEAF_ATTR_HI);
+	pte |= attr & KVM_PTE_LEAF_ATTRS;
 	pte |= FIELD_PREP(KVM_PTE_TYPE, type);
 	pte |= KVM_PTE_VALID;
 
@@ -1027,10 +1027,9 @@ static int stage2_update_leaf_attrs(struct kvm_pgtable *pgt, u64 addr,
 				    u32 *level, enum kvm_pgtable_walk_flags flags)
 {
 	int ret;
-	kvm_pte_t attr_mask = KVM_PTE_LEAF_ATTR_LO | KVM_PTE_LEAF_ATTR_HI;
 	struct stage2_attr_data data = {
-		.attr_set	= attr_set & attr_mask,
-		.attr_clr	= attr_clr & attr_mask,
+		.attr_set	= attr_set & KVM_PTE_LEAF_ATTRS,
+		.attr_clr	= attr_clr & KVM_PTE_LEAF_ATTRS,
 	};
 	struct kvm_pgtable_walker walker = {
 		.cb		= stage2_attr_walker,
-- 
2.39.0.314.g84b9a713c41-goog


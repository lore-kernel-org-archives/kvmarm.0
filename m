Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849B8221264
	for <kvmarm@lists.linux.dev>; Fri, 27 Mar 2026 14:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774620123; cv=none; b=K0WP1ubAUlxbpKEOzqrPjTPtCpeOVL3DW/XoVXaKaX/0biKBksmBoPXQww17cD3MwOiUZgC4GmGZRpWulHKLmoJn7r8E++9D3LXFMXqIFB83/RdRZzFeQMwhTO+DPfNQjUL7uFUn0Sxv5CxxyHC7UXnNkfeLBVC5UCDUGaXEYWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774620123; c=relaxed/simple;
	bh=PEkITeoFsx5XhDmWodOqKWQXVGklwJbFcm8YS4Kt7I4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tdY9VaZMRKsTIU/Ew8Flb5nlIarQRpbDmA9m10TaxfHUOT0+pKfQRz9x/qJsJpL8wuv0ox7WxlIvfHINz4Sq7MUj7R9T0CPD8hc6srU5Qs1YsL+0XrjBUp4O3+2ve7tr+pQjKDXswHh7ZMCFwH/oiXW60ymuLBz0Lv3oL7gKRE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CIhMAJfq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CIhMAJfq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B21FDC2BC87;
	Fri, 27 Mar 2026 14:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774620123;
	bh=PEkITeoFsx5XhDmWodOqKWQXVGklwJbFcm8YS4Kt7I4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CIhMAJfqzlwKAtzEMU1M7bm5lvG3rND211y/dGugrV43IEGXWYVEwvK6N0K8ttryf
	 oXFay1zt/a59/HPhqo2UNYz5Z3j2p+KkHF/ApuXHVb5+eDe5yrFspwrgCUMvXZoz3b
	 jaTLH3eWjKFdoLxpQwXVfnwRnjhSlAATa9k0svsxZuCuJt6lWi8w35yShUnKpKV1sv
	 12f97/w9QQAK7qhDppfIj1GYIJqfx4ApVKitzgh7xrHT3i+FYRORwc25JRDaKcaYrH
	 woHb7npX87w26+58DdMcGoYJ1IBts1A5pZhROnR3m7tL7p4RPYPVD3JA4IWKU1LVYQ
	 TO5/bAnhkIHdA==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH v4 22/38] KVM: arm64: Introduce host_stage2_set_owner_metadata_locked()
Date: Fri, 27 Mar 2026 14:00:21 +0000
Message-ID: <20260327140039.21228-23-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260327140039.21228-1-will@kernel.org>
References: <20260327140039.21228-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rework host_stage2_set_owner_locked() to add a new helper function,
host_stage2_set_owner_metadata_locked(), which will allow us to store
additional metadata alongside a 3-bit owner ID for invalid host stage-2
entries.

Tested-by: Fuad Tabba <tabba@google.com>
Tested-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_pgtable.h  |  2 --
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 47 ++++++++++++++++++---------
 2 files changed, 32 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index e36c2908bdb2..2df22640833c 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -99,8 +99,6 @@ typedef u64 kvm_pte_t;
 					 KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | \
 					 KVM_PTE_LEAF_ATTR_HI_S2_XN)
 
-#define KVM_INVALID_PTE_OWNER_MASK	GENMASK(9, 2)
-
 /* pKVM invalid pte encodings */
 #define KVM_INVALID_PTE_TYPE_MASK	GENMASK(63, 60)
 #define KVM_INVALID_PTE_ANNOT_MASK	~(KVM_PTE_VALID | \
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index aea6ec981801..90003cbf5603 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -549,37 +549,54 @@ static void __host_update_page_state(phys_addr_t addr, u64 size, enum pkvm_page_
 		set_host_state(page, state);
 }
 
-static kvm_pte_t kvm_init_invalid_leaf_owner(u8 owner_id)
-{
-	return FIELD_PREP(KVM_INVALID_PTE_OWNER_MASK, owner_id);
-}
-
-int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id)
+#define KVM_HOST_DONATION_PTE_OWNER_MASK	GENMASK(3, 1)
+#define KVM_HOST_DONATION_PTE_EXTRA_MASK	GENMASK(59, 4)
+static int host_stage2_set_owner_metadata_locked(phys_addr_t addr, u64 size,
+						 u8 owner_id, u64 meta)
 {
 	kvm_pte_t annotation;
-	int ret = -EINVAL;
+	int ret;
 
-	if (!FIELD_FIT(KVM_INVALID_PTE_OWNER_MASK, owner_id))
+	if (owner_id == PKVM_ID_HOST)
 		return -EINVAL;
 
 	if (!range_is_memory(addr, addr + size))
 		return -EPERM;
 
+	if (!FIELD_FIT(KVM_HOST_DONATION_PTE_OWNER_MASK, owner_id))
+		return -EINVAL;
+
+	if (!FIELD_FIT(KVM_HOST_DONATION_PTE_EXTRA_MASK, meta))
+		return -EINVAL;
+
+	annotation = FIELD_PREP(KVM_HOST_DONATION_PTE_OWNER_MASK, owner_id) |
+		     FIELD_PREP(KVM_HOST_DONATION_PTE_EXTRA_MASK, meta);
+	ret = host_stage2_try(kvm_pgtable_stage2_annotate, &host_mmu.pgt,
+			      addr, size, &host_s2_pool,
+			      KVM_HOST_INVALID_PTE_TYPE_DONATION, annotation);
+	if (!ret)
+		__host_update_page_state(addr, size, PKVM_NOPAGE);
+
+	return ret;
+}
+
+int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id)
+{
+	int ret = -EINVAL;
+
 	switch (owner_id) {
 	case PKVM_ID_HOST:
+		if (!range_is_memory(addr, addr + size))
+			return -EPERM;
+
 		ret = host_stage2_idmap_locked(addr, size, PKVM_HOST_MEM_PROT);
 		if (!ret)
 			__host_update_page_state(addr, size, PKVM_PAGE_OWNED);
 		break;
 	case PKVM_ID_GUEST:
 	case PKVM_ID_HYP:
-		annotation = kvm_init_invalid_leaf_owner(owner_id);
-		ret = host_stage2_try(kvm_pgtable_stage2_annotate, &host_mmu.pgt,
-				      addr, size, &host_s2_pool,
-				      KVM_HOST_INVALID_PTE_TYPE_DONATION,
-				      annotation);
-		if (!ret)
-			__host_update_page_state(addr, size, PKVM_NOPAGE);
+		ret = host_stage2_set_owner_metadata_locked(addr, size,
+							    owner_id, 0);
 		break;
 	}
 
-- 
2.53.0.1018.g2bb0e51243-goog


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13900324B33
	for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 14:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774882204; cv=none; b=decQCPbA8q9dbur5K6mhUmQW5WZJGuPcsC1rVEpb2fFe/DKAnaSXMdGoAXGY4/+oGBmXTphYfe9+/clB7rG5dehIi+5g2ElLmHpsbhynSgYxc3KsfGwQwjcmSm/+A+ER3H+voRcTW2ew4aoSh1xQHEc5G9AVJXBxe2T90vn35oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774882204; c=relaxed/simple;
	bh=PEkITeoFsx5XhDmWodOqKWQXVGklwJbFcm8YS4Kt7I4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oRHJJ7vfCxKcu5Q1SBwllnQ7C/KEfevCSz7jribJtn3dLMV8Fy9azZj2BlvBusG4Khb3XP8QCCXycPhk1au0gFPIwKe8kr6UoC8gf9ImqtlAx62dRRuTro1N3NY+LTJ2CKRGkCLpwv+SZFU+bdISPI525yVsnKXZaL+0Z1kfYjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=igVVGoyV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="igVVGoyV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 391D4C4CEF7;
	Mon, 30 Mar 2026 14:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774882204;
	bh=PEkITeoFsx5XhDmWodOqKWQXVGklwJbFcm8YS4Kt7I4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=igVVGoyVDZEDizKXMDr55ZxyL1JdTfkxRKvNg3yLELbK5jynmLs9rNN3j8Yn1cTyA
	 saJAoegbh7ewXIhNevt+HHspLZOt9MEt8hm8+JkQsmQHAP6R0kXgRTwMI1OXlnUDyP
	 9P93hRc3wJM5m+CjJiUnpuC8uZZYukUDnIyp/8MCdLDIUwf9HaueCh4BecVK3/0Cwq
	 TiG3iLbn+bsbu9mKrJSp0bXl/AUfkKJRgBTEAWnKOigupv9jgNy5ivUcLHXHmGSZPX
	 FIrottMkY8S8AbPYckZJhEZiYSPHjlGxESvIYvEeqQomZ7LFsPzFnTMykgq2YIB/dX
	 /T+N30CUvpcWw==
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
Subject: [PATCH v5 22/38] KVM: arm64: Introduce host_stage2_set_owner_metadata_locked()
Date: Mon, 30 Mar 2026 15:48:23 +0100
Message-ID: <20260330144841.26181-23-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260330144841.26181-1-will@kernel.org>
References: <20260330144841.26181-1-will@kernel.org>
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


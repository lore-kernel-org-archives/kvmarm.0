Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0249535EDA5
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 12:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768826878; cv=none; b=dGjWDKojPF8ZLyDIFvYlk7wCP7IDrCHTphi6XqbSVAzzAVeXTcpL4ykt91FUHNDaPxj1UhJrcqg1zjonbgWV5p+FLdhv7hFfEJF1S3J6flJ99YMnP2QUee8AFiWyG28zvp4EJAzs5tTl5DJIX6SLtfP2IIWo2OoqiK+PkKWHlgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768826878; c=relaxed/simple;
	bh=uUL60sV+/ufbRutlnjjHRkQPedaXpLvo0DvrHx8Jcxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A4F2ghoN8hPDYBbLbVGfOCDkGtsLr6tddZosTfrRVI/C9k41UjddCfBt3GSKjyooiPbWE/B8QBwwDfyI0NmWXpB/75YSisAk0vEclmNdNUmByWNQ6CKh7gLTU3dXMNb2/R7Vm0TbLlPYco/PgkCUkt9peGEQQGiErbGPJmDerL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gGVi2o3S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gGVi2o3S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AB2AC116C6;
	Mon, 19 Jan 2026 12:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768826877;
	bh=uUL60sV+/ufbRutlnjjHRkQPedaXpLvo0DvrHx8Jcxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gGVi2o3SItUKI4TFnCfojdpXXcS4D+/KjYd3oLM/eAfD16q2a1MjgsDWuL2OpSCIP
	 fRDbYA6eg33yf94MNTH5+TswHmixolpuTG5EFfmhVp7WGF2LgEOPQEs4Q1UTuPIDJH
	 sEgPvpvHjuhHG+zEecHv27xyPUKUs12+vQMobso4z3k+eoaNeUt7wbn6Ci1K2fnK+X
	 kjicRsUVYA2C7TEuUL6PoSb83QX8ZhWEAgmF+br/J/fFV9hf4Ktrla/YfJITt/pXLB
	 75M/wWJeM9C4ft0YCIzx6JhGvRybQHf6ahueGiPVLnA86lKbdXJXGUAXrC5bD+DQBy
	 fqZGEktao39RA==
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
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v2 21/35] KVM: arm64: Introduce host_stage2_set_owner_metadata_locked()
Date: Mon, 19 Jan 2026 12:46:14 +0000
Message-ID: <20260119124629.2563-22-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260119124629.2563-1-will@kernel.org>
References: <20260119124629.2563-1-will@kernel.org>
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

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_pgtable.h  |  2 --
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 47 ++++++++++++++++++---------
 2 files changed, 32 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 4c41a8ed4a7c..eb2a6258d83d 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -97,8 +97,6 @@ typedef u64 kvm_pte_t;
 					 KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | \
 					 KVM_PTE_LEAF_ATTR_HI_S2_XN)
 
-#define KVM_INVALID_PTE_OWNER_MASK	GENMASK(9, 2)
-
 /* pKVM invalid pte encodings */
 #define KVM_INVALID_PTE_TYPE_MASK	GENMASK(63, 60)
 #define KVM_INVALID_PTE_ANNOT_MASK	~(KVM_PTE_VALID | \
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 3f8a73461f90..e090252d38a8 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -546,37 +546,54 @@ static void __host_update_page_state(phys_addr_t addr, u64 size, enum pkvm_page_
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
2.52.0.457.g6b5491de43-goog


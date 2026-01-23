Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF1A217733
	for <kvmarm@lists.linux.dev>; Fri, 23 Jan 2026 19:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769195803; cv=none; b=ZNLMCSqbnWYYs92SMaiiX/ZccI4f0IUvHiI+Ga1fuZPsGQQs9m+oN4/G2GgciYtdW790OVkAAayRhILFG462wPEaay0o3aTpJP5mF0YBWrQhUQo2AZVEM/KYYSpWRRhGlzxuAt6wcu2OM8ain3TBK42afUJF/m2/efTYLMLB6xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769195803; c=relaxed/simple;
	bh=SCVycz0ZO5P/i92rYNjTN7t6tRCsvv/79dcDHaL+Sdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=apzMXmbqJaWJKccgK5Jy/OKkaUYrYfXXFmYw2KQ79mivEK4OVWUJUAaj4Q09ok8bQ9vyrlXHIsSdSiJ7MihJWd5E9hTxsmuepH55tLDGLnLSjaT4sPWWtbiZ30FAG0rW8scS98bjM3yhBFlWz4+CKpXiXgnGRwLLqQ6bGa/k/2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GAZeuFdQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GAZeuFdQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AF54C2BCB0;
	Fri, 23 Jan 2026 19:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769195803;
	bh=SCVycz0ZO5P/i92rYNjTN7t6tRCsvv/79dcDHaL+Sdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GAZeuFdQnyOloHnDJx1XJwxnAIomurEvtVDyNyFsg2WdGCrBVgA/+IPvT+FSkoXPs
	 t0e5RyOBFPvy/Mj60a1Un9CL2Kd3VxeFOqot7g3DHJfaFtyY61vIZW3gfAYB9XNvfX
	 nk01pfZyqbsNwOMZ6JS8VnCpzFHA6zXUy4oNfEsFe4ZhO+iGZUOObnoQPK6QQN3Af5
	 DoI26PwoUeb3kskc2eu37FW5v14xpq0v/9VYaRa/nYSepJ3anOr/pRaC1+4Gsac6zH
	 hoDIwwdp2yksnIYCA6CBZaJKduhCI1ibsS3IDais/dMqVlYO+YHDdoKbVEIM6ebkqR
	 CXXlJ7wUd8QJA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vjMe9-00000005A2V-2Agh;
	Fri, 23 Jan 2026 19:16:41 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH v2 4/5] KVM: arm64: Kill KVM_PGTABLE_S2_NOFWB
Date: Fri, 23 Jan 2026 19:16:36 +0000
Message-ID: <20260123191637.715429-5-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260123191637.715429-1-maz@kernel.org>
References: <20260123191637.715429-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, will@kernel.org, qperret@google.com, tabba@google.com, alexandru.elisei@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Nobody is using this flag anymore, so remove it. This allows
some cleanup by removing stage2_has_fwb(), which is can be replaced
by a direct check on the capability.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_pgtable.h |  7 ++-----
 arch/arm64/kvm/hyp/pgtable.c         | 21 ++++++---------------
 2 files changed, 8 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 9ce51a637da0a..2198b62428832 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -229,15 +229,12 @@ struct kvm_pgtable_mm_ops {
 
 /**
  * enum kvm_pgtable_stage2_flags - Stage-2 page-table flags.
- * @KVM_PGTABLE_S2_NOFWB:	Don't enforce Normal-WB even if the CPUs have
- *				ARM64_HAS_STAGE2_FWB.
  * @KVM_PGTABLE_S2_IDMAP:	Only use identity mappings.
  * @KVM_PGTABLE_S2_AS_S1:	Final memory attributes are that of Stage-1.
  */
 enum kvm_pgtable_stage2_flags {
-	KVM_PGTABLE_S2_NOFWB			= BIT(0),
-	KVM_PGTABLE_S2_IDMAP			= BIT(1),
-	KVM_PGTABLE_S2_AS_S1			= BIT(2),
+	KVM_PGTABLE_S2_IDMAP			= BIT(0),
+	KVM_PGTABLE_S2_AS_S1			= BIT(1),
 };
 
 /**
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index c52a24c15ff28..00e33a16494bd 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -631,14 +631,6 @@ u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
 	return vtcr;
 }
 
-static bool stage2_has_fwb(struct kvm_pgtable *pgt)
-{
-	if (!cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
-		return false;
-
-	return !(pgt->flags & KVM_PGTABLE_S2_NOFWB);
-}
-
 void kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
 				phys_addr_t addr, size_t size)
 {
@@ -661,14 +653,13 @@ void kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
 
 #define KVM_S2_MEMATTR(pgt, attr)					\
 	({								\
+		bool __fwb = cpus_have_final_cap(ARM64_HAS_STAGE2_FWB);	\
 		kvm_pte_t __attr;					\
 									\
 		if ((pgt)->flags & KVM_PGTABLE_S2_AS_S1)		\
-			__attr = PAGE_S2_MEMATTR(AS_S1,			\
-						 stage2_has_fwb(pgt));	\
+			__attr = PAGE_S2_MEMATTR(AS_S1,	__fwb);		\
 		else							\
-			__attr = PAGE_S2_MEMATTR(attr,			\
-						 stage2_has_fwb(pgt));	\
+			__attr = PAGE_S2_MEMATTR(attr, __fwb);		\
 									\
 		__attr;							\
 	})
@@ -880,7 +871,7 @@ static bool stage2_unmap_defer_tlb_flush(struct kvm_pgtable *pgt)
 	 * system supporting FWB as the optimization is entirely
 	 * pointless when the unmap walker needs to perform CMOs.
 	 */
-	return system_supports_tlb_range() && stage2_has_fwb(pgt);
+	return system_supports_tlb_range() && cpus_have_final_cap(ARM64_HAS_STAGE2_FWB);
 }
 
 static void stage2_unmap_put_pte(const struct kvm_pgtable_visit_ctx *ctx,
@@ -1160,7 +1151,7 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
 		if (mm_ops->page_count(childp) != 1)
 			return 0;
 	} else if (stage2_pte_cacheable(pgt, ctx->old)) {
-		need_flush = !stage2_has_fwb(pgt);
+		need_flush = !cpus_have_final_cap(ARM64_HAS_STAGE2_FWB);
 	}
 
 	/*
@@ -1390,7 +1381,7 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
 		.arg	= pgt,
 	};
 
-	if (stage2_has_fwb(pgt))
+	if (cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
 		return 0;
 
 	return kvm_pgtable_walk(pgt, addr, size, &walker);
-- 
2.47.3


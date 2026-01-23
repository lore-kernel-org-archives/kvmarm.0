Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5E31E832A
	for <kvmarm@lists.linux.dev>; Fri, 23 Jan 2026 19:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769195803; cv=none; b=HuxW2X5lieKZ8YQzbm1c5GxWDw+PDuUKmWJ71hxi9clxMfHf5alkT0u6WxBpUHQwPFJS+9zM49PkU4KUvdbE/xXdShYMpGFkrDYC2IhW1QS4vt11DgDF5caai5DSWvGsn0IoSm5IYvvJuH3HfsasKxtgLFRn/nUV6d7mdCiG7do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769195803; c=relaxed/simple;
	bh=rWK31wXn61TDUD7Wh3d8yDUdkv93mnDeLCM+19FrlMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Udj2v+KkmKa93vNj7GLQiIIRCD8dZhWAVostPhYIkvTq5kmhH05DWHWa/Izjk9KZVOQcWdKlbqOCTAqySJ0JgAk/OO+7dKlVk9xuYCrpWJoksbN9ueMfEW+dPAx2tZ85scnNyLerrMGnpfmRD6zUdQgmoQeaBJX4kNG+BcsFyG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g3Wlyr8z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g3Wlyr8z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C401C2BC87;
	Fri, 23 Jan 2026 19:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769195803;
	bh=rWK31wXn61TDUD7Wh3d8yDUdkv93mnDeLCM+19FrlMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g3Wlyr8zdvb4Y2xc/QUWy0FbX7bSfuTlvEChqSuOX9pl5QWMMzljoMQ/vzsL/rFf2
	 /USIm0vKh8X0iauC61PMJx+CCGbl5jA1qGfCsyrXNL/VWUCwY4ILhWuYboPVqdv3Do
	 gvpRgFoYOKojlBxoUgnXES+BVvVK5B+maTDen1KOoOi/Hk47RKVLavUUxH6YLCVDsq
	 TePstyoA7gku2dmiF9oxsuqQlVi2z44fZc5D3lBdnaM3rtw7CR6skM9z59DqgwS1VJ
	 FKE+gobeuKFLZcLVtjbkIoa5KN7+oadOeLkaCds96MlgH6MjYtDIs0EHqK9nT/QDeN
	 J52i0nmG57gjA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vjMe9-00000005A2V-09CR;
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
Subject: [PATCH v2 2/5] KVM: arm64: Add KVM_PGTABLE_S2_AS_S1 flag
Date: Fri, 23 Jan 2026 19:16:34 +0000
Message-ID: <20260123191637.715429-3-maz@kernel.org>
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

Plumb the MT_S2{,_FWB}_AS_S1 memory types into the KVM_S2_MEMATTR()
macro with a new KVM_PGTABLE_S2_AS_S1 flag.

Nobody selects it yet.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_pgtable.h |  2 ++
 arch/arm64/kvm/hyp/pgtable.c         | 14 +++++++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index fc02de43c68dd..9ce51a637da0a 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -232,10 +232,12 @@ struct kvm_pgtable_mm_ops {
  * @KVM_PGTABLE_S2_NOFWB:	Don't enforce Normal-WB even if the CPUs have
  *				ARM64_HAS_STAGE2_FWB.
  * @KVM_PGTABLE_S2_IDMAP:	Only use identity mappings.
+ * @KVM_PGTABLE_S2_AS_S1:	Final memory attributes are that of Stage-1.
  */
 enum kvm_pgtable_stage2_flags {
 	KVM_PGTABLE_S2_NOFWB			= BIT(0),
 	KVM_PGTABLE_S2_IDMAP			= BIT(1),
+	KVM_PGTABLE_S2_AS_S1			= BIT(2),
 };
 
 /**
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 947ac1a951a5b..c52a24c15ff28 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -659,7 +659,19 @@ void kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
 	}
 }
 
-#define KVM_S2_MEMATTR(pgt, attr) PAGE_S2_MEMATTR(attr, stage2_has_fwb(pgt))
+#define KVM_S2_MEMATTR(pgt, attr)					\
+	({								\
+		kvm_pte_t __attr;					\
+									\
+		if ((pgt)->flags & KVM_PGTABLE_S2_AS_S1)		\
+			__attr = PAGE_S2_MEMATTR(AS_S1,			\
+						 stage2_has_fwb(pgt));	\
+		else							\
+			__attr = PAGE_S2_MEMATTR(attr,			\
+						 stage2_has_fwb(pgt));	\
+									\
+		__attr;							\
+	})
 
 static int stage2_set_xn_attr(enum kvm_pgtable_prot prot, kvm_pte_t *attr)
 {
-- 
2.47.3


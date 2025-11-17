Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E845F32720F
	for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 22:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763419413; cv=none; b=YSVD8xV5CzQZeU3pvxcOHCSWf9Al8ebss7UFepEhUwaoCb1yCv6IhUJ+qrzqXo5sLnMEv54ARi1q2HOVq70nZfZ3d2tYlQ+X1D4rMopPQUyqIlWkAFbOBmqHOqtk4wW/DhR+T4noHgPu9mnoIxtvE9JsijNGk5lOLvAvpUgsqBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763419413; c=relaxed/simple;
	bh=FIu3io4VTnOEqAQfTRWBkOFnMFTtZf3WQyHmX2RXw9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WeUDs5gHD1ERUMEql+fXuy4bxdEYm5GglMsGGWP0TrbydgxbjNnsGlqusmleOlHzPFpJULtHHg+k3XaZAtxSbMqgrThNfnf3O+eyVyoqnLsyZDNll926ibUAAcRfCi7mTuRD05aXVDspAoZnLEqhApoJtM5XuIUH14izqOZ+5tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TcsUVeMF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TcsUVeMF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82814C116B1;
	Mon, 17 Nov 2025 22:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763419412;
	bh=FIu3io4VTnOEqAQfTRWBkOFnMFTtZf3WQyHmX2RXw9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TcsUVeMFPO4jCz2wf4JEuvrxKLBXAJqoicWDu9ZuuR6QasKRpwGX07KAC+vQsCW1m
	 q4HAvzRRFMSWkbDSTHEO/XLHZsZNmOUygwprrvZYX2roezLX/d+S3ITGrsR1NQhU98
	 +eWy5vQ0F1dZyKxy1LaxyGtp/Nip26gXpwT6xyfkFmO/R6jiTl33XWeAsZzAjdaYjp
	 PmVdgvH3zbyiA9PuwBDvENYfXAaEsQWmLAAeWliE0yT8CjHG/4SsTUECsFrz1K8a1G
	 acDsts2HuJzBYLXBdLu4/7nS14eWjzFV+GbKUcerEtiPdVGLBmvsguVVBBdnC7+FkK
	 dy42qhLlKFtDg==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v2 10/14] KVM: arm64: Propagate PTW errors up to AT emulation
Date: Mon, 17 Nov 2025 14:43:21 -0800
Message-ID: <20251117224325.2431848-11-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251117224325.2431848-1-oupton@kernel.org>
References: <20251117224325.2431848-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KVM's software PTW will soon support 'hardware' updates to the access
flag. Similar to fault handling, races to update the descriptor will be
handled by restarting the instruction. Prepare for this by propagating
errors up to the AT emulation, only retiring the instruction if the walk
succeeds.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/include/asm/kvm_asm.h |  6 ++---
 arch/arm64/kvm/at.c              | 43 ++++++++++++++++++++++----------
 arch/arm64/kvm/sys_regs.c        |  9 ++++---
 3 files changed, 39 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 9da54d4ee49e..090f7b740bdc 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -246,9 +246,9 @@ extern void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu);
 extern int __kvm_tlbi_s1e2(struct kvm_s2_mmu *mmu, u64 va, u64 sys_encoding);
 
 extern void __kvm_timer_set_cntvoff(u64 cntvoff);
-extern void __kvm_at_s1e01(struct kvm_vcpu *vcpu, u32 op, u64 vaddr);
-extern void __kvm_at_s1e2(struct kvm_vcpu *vcpu, u32 op, u64 vaddr);
-extern void __kvm_at_s12(struct kvm_vcpu *vcpu, u32 op, u64 vaddr);
+extern int __kvm_at_s1e01(struct kvm_vcpu *vcpu, u32 op, u64 vaddr);
+extern int __kvm_at_s1e2(struct kvm_vcpu *vcpu, u32 op, u64 vaddr);
+extern int __kvm_at_s12(struct kvm_vcpu *vcpu, u32 op, u64 vaddr);
 
 extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 22e2ee4e182e..eece654b02a1 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -1234,7 +1234,7 @@ static void compute_s1_permissions(struct kvm_vcpu *vcpu,
 	wr->pr &= !pan;
 }
 
-static u64 handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
+static int handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr, u64 *par)
 {
 	struct s1_walk_result wr = {};
 	struct s1_walk_info wi = {};
@@ -1259,6 +1259,11 @@ static u64 handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 
 	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 
+	/*
+	 * Race to update a descriptor -- restart the walk.
+	 */
+	if (ret == -EAGAIN)
+		return ret;
 	if (ret)
 		goto compute_par;
 
@@ -1292,7 +1297,8 @@ static u64 handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 		fail_s1_walk(&wr, ESR_ELx_FSC_PERM_L(wr.level), false);
 
 compute_par:
-	return compute_par_s1(vcpu, &wi, &wr);
+	*par = compute_par_s1(vcpu, &wi, &wr);
+	return 0;
 }
 
 /*
@@ -1420,9 +1426,10 @@ static bool par_check_s1_access_fault(u64 par)
 		 !(par & SYS_PAR_EL1_S));
 }
 
-void __kvm_at_s1e01(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
+int __kvm_at_s1e01(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 {
 	u64 par = __kvm_at_s1e01_fast(vcpu, op, vaddr);
+	int ret;
 
 	/*
 	 * If PAR_EL1 reports that AT failed on a S1 permission or access
@@ -1434,15 +1441,20 @@ void __kvm_at_s1e01(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 	 */
 	if ((par & SYS_PAR_EL1_F) &&
 	    !par_check_s1_perm_fault(par) &&
-	    !par_check_s1_access_fault(par))
-		par = handle_at_slow(vcpu, op, vaddr);
+	    !par_check_s1_access_fault(par)) {
+		ret = handle_at_slow(vcpu, op, vaddr, &par);
+		if (ret)
+			return ret;
+	}
 
 	vcpu_write_sys_reg(vcpu, par, PAR_EL1);
+	return 0;
 }
 
-void __kvm_at_s1e2(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
+int __kvm_at_s1e2(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 {
 	u64 par;
+	int ret;
 
 	/*
 	 * We've trapped, so everything is live on the CPU. As we will be
@@ -1489,13 +1501,17 @@ void __kvm_at_s1e2(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 	}
 
 	/* We failed the translation, let's replay it in slow motion */
-	if ((par & SYS_PAR_EL1_F) && !par_check_s1_perm_fault(par))
-		par = handle_at_slow(vcpu, op, vaddr);
+	if ((par & SYS_PAR_EL1_F) && !par_check_s1_perm_fault(par)) {
+		ret = handle_at_slow(vcpu, op, vaddr, &par);
+		if (ret)
+			return ret;
+	}
 
 	vcpu_write_sys_reg(vcpu, par, PAR_EL1);
+	return 0;
 }
 
-void __kvm_at_s12(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
+int __kvm_at_s12(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 {
 	struct kvm_s2_trans out = {};
 	u64 ipa, par;
@@ -1522,13 +1538,13 @@ void __kvm_at_s12(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 		break;
 	default:
 		WARN_ON_ONCE(1);
-		return;
+		return 0;
 	}
 
 	__kvm_at_s1e01(vcpu, op, vaddr);
 	par = vcpu_read_sys_reg(vcpu, PAR_EL1);
 	if (par & SYS_PAR_EL1_F)
-		return;
+		return 0;
 
 	/*
 	 * If we only have a single stage of translation (EL2&0), exit
@@ -1536,14 +1552,14 @@ void __kvm_at_s12(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 	 */
 	if (compute_translation_regime(vcpu, op) == TR_EL20 ||
 	    !(vcpu_read_sys_reg(vcpu, HCR_EL2) & (HCR_VM | HCR_DC)))
-		return;
+		return 0;
 
 	/* Do the stage-2 translation */
 	ipa = (par & GENMASK_ULL(47, 12)) | (vaddr & GENMASK_ULL(11, 0));
 	out.esr = 0;
 	ret = kvm_walk_nested_s2(vcpu, ipa, &out);
 	if (ret < 0)
-		return;
+		return ret;
 
 	/* Check the access permission */
 	if (!out.esr &&
@@ -1552,6 +1568,7 @@ void __kvm_at_s12(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 
 	par = compute_par_s12(vcpu, par, &out);
 	vcpu_write_sys_reg(vcpu, par, PAR_EL1);
+	return 0;
 }
 
 /*
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index e67eb39ddc11..61830eb3607c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3767,7 +3767,8 @@ static bool handle_at_s1e01(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 {
 	u32 op = sys_insn(p->Op0, p->Op1, p->CRn, p->CRm, p->Op2);
 
-	__kvm_at_s1e01(vcpu, op, p->regval);
+	if (__kvm_at_s1e01(vcpu, op, p->regval))
+		return false;
 
 	return true;
 }
@@ -3784,7 +3785,8 @@ static bool handle_at_s1e2(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		return false;
 	}
 
-	__kvm_at_s1e2(vcpu, op, p->regval);
+	if (__kvm_at_s1e2(vcpu, op, p->regval))
+		return false;
 
 	return true;
 }
@@ -3794,7 +3796,8 @@ static bool handle_at_s12(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 {
 	u32 op = sys_insn(p->Op0, p->Op1, p->CRn, p->CRm, p->Op2);
 
-	__kvm_at_s12(vcpu, op, p->regval);
+	if (__kvm_at_s12(vcpu, op, p->regval))
+		return false;
 
 	return true;
 }
-- 
2.47.3


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF802C3272
	for <kvmarm@lists.linux.dev>; Mon, 24 Nov 2025 19:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764010922; cv=none; b=W/tS1S6TfP16ZRbbhqGHz67xgPEwOyFtVzX+q5UggyhavwXeCy0W8L9JK7KwvORpfw6Wgb6g6QN1hze/7yGZ4/cUfAqBXnOJev3s1C37+cna2QWHl6T2ZM1yaxWtNOcdzlKdFuu34cHUBrXzS4NIi0QUtQdNVykD7yXyrJvX99E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764010922; c=relaxed/simple;
	bh=UmajV47+FjgDXq1I8SdRerO+qrrl2MWyWLQGB4BiP98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lhoIyyKxTs79NDmBIx4yJtwSw1Knqb2z+gKUxpM7I7LH3wLfqzHp+/p8ce8643uCAHFa6LnDKctRVWmcIGK5h/7fFZeD6TKG07nzE4aONPe2es++CLlFtfnvCN3TbVyVSFl2VDefwTX3OMjMhkl9/kD3U0lGLDjEStm4zAtMuj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FnUZYKBK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FnUZYKBK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4DEC19422;
	Mon, 24 Nov 2025 19:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764010921;
	bh=UmajV47+FjgDXq1I8SdRerO+qrrl2MWyWLQGB4BiP98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FnUZYKBKa7ecaDTAxTgJ1YKmK/TvK7Cb560F/Li4ShxYGvngNsJUHmbUuyDHDS357
	 zjbpp726+17I4HyLocCBCfdTwAFOPN8Z7D1x3uSDyPFCeiMtS7DlTAU9so7AMfIazh
	 o/eG/c9kO05sZkRWOGgmzHBfDdLVWYWUWfsjd03OEDSzOQgyRME0csgSPmwvIpdr/T
	 JUCi1184Hm3pjE6CUYEvaQfLkSJW8fIEdp6j8//GocKrGL6wUwEmL521HP4zMwXpBq
	 +J/OGGQNO6IL9vUsTRreWwiJHRZasJdTh8MxIUYOY6xLAVmDavGUS+W9yjcC63EgQ9
	 zuN4cLHq+TwOg==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v3 11/15] KVM: arm64: Propagate PTW errors up to AT emulation
Date: Mon, 24 Nov 2025 11:01:53 -0800
Message-ID: <20251124190158.177318-12-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251124190158.177318-1-oupton@kernel.org>
References: <20251124190158.177318-1-oupton@kernel.org>
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
index 581c4c49d9cd..2a99380ada6f 100644
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


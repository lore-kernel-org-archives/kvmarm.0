Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587C8175B6
	for <kvmarm@lists.linux.dev>; Mon,  5 Feb 2024 10:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707129291; cv=none; b=XXwKx5u535igUto5N5o/XvXgG5xWui6Vs8cfGbIgNZkNCblVFQw9IbJsH5VDzi2bObjr98rKeLTCludtw9Srs7efDvWRleVRspyY9S5kIIUiFNGdcGm7TWYTjYTqklnZJyBzjtNO7y70YZlRzCoSah+XJy42dAaDj8qgEHYeuv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707129291; c=relaxed/simple;
	bh=hSdauJw9sqqU1t6o28/fU6gzi3FgMMGYcmtUrNcsBTQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kDyIIMM41LjpRrF3dE+q2o/0pyfp+CGY+VnXvHE8IhyMug5LCInC+PQUKWnpO5hY5RwmJv/uiBdKA5zu7my7uYLcy+E6Tvo+kFlvF7Dn0sMbgRvEqaZ1XcnZMfIbZcpDlWR+7WYphUUjLvHy19UVleaB8++9Rra5uqGZfrGEm1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BNbbzqX/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BNbbzqX/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBD87C43390;
	Mon,  5 Feb 2024 10:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707129290;
	bh=hSdauJw9sqqU1t6o28/fU6gzi3FgMMGYcmtUrNcsBTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BNbbzqX/t3XWjIs9DKj+llGWffCsqbtJwnlzvGsbxyf/hYcM1xHPMgUzeVcBEa1is
	 Y0Qv5B/5GRd9rZMa/n/OTMl/U2sT54bI8YwXoLiFX+FZ2UzCbQtolqcFRxirdj7W3E
	 QLFq6tcLGb0Bp9wRUZzldsfICf5+PcWr9uZQEmjpG80wEfNH6dJIbdvzfYWcT3b0n0
	 wkrlxpbZ4k/a36fHpQQ25nmVo3HhctgHr2ZvFUDxzh40jQYqIwzfLb9c12m4aGXTue
	 FI2Udvq4hKsyUygspJ28lbkBV5RNuqkoqWL0umj2HAGXVk62pZSG0HRrSX7ZlOsKWA
	 j8mlD945g+TZw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rWwJN-000Nc3-1o;
	Mon, 05 Feb 2024 10:34:49 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v3 20/26] KVM: arm64: Streamline save/restore of HFG[RW]TR_EL2
Date: Mon,  5 Feb 2024 10:34:25 +0000
Message-Id: <20240205103431.1104133-21-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240205103431.1104133-1-maz@kernel.org>
References: <20240205103431.1104133-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The way we save/restore HFG[RW]TR_EL2 can now be simplified, and
the Ampere erratum hack is the only thing that still stands out.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 42 ++++++-------------------
 1 file changed, 9 insertions(+), 33 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 245f9c1ca666..2d5891518006 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -157,8 +157,6 @@ static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *hctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
 	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
-	u64 r_clr = 0, w_clr = 0, r_set = 0, w_set = 0;
-	u64 r_val, w_val;
 
 	CHECK_FGT_MASKS(HFGRTR_EL2);
 	CHECK_FGT_MASKS(HFGWTR_EL2);
@@ -171,34 +169,10 @@ static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
 	if (!cpus_have_final_cap(ARM64_HAS_FGT))
 		return;
 
-	ctxt_sys_reg(hctxt, HFGRTR_EL2) = read_sysreg_s(SYS_HFGRTR_EL2);
-	ctxt_sys_reg(hctxt, HFGWTR_EL2) = read_sysreg_s(SYS_HFGWTR_EL2);
-
-	/*
-	 * Trap guest writes to TCR_EL1 to prevent it from enabling HA or HD.
-	 */
-	if (cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38))
-		w_set |= HFGxTR_EL2_TCR_EL1_MASK;
-
-	if (vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu)) {
-		compute_clr_set(vcpu, HFGRTR_EL2, r_clr, r_set);
-		compute_clr_set(vcpu, HFGWTR_EL2, w_clr, w_set);
-	}
-
-	compute_undef_clr_set(vcpu, kvm, HFGRTR_EL2, r_clr, r_set);
-	compute_undef_clr_set(vcpu, kvm, HFGWTR_EL2, w_clr, w_set);
-
-	r_val = __HFGRTR_EL2_nMASK;
-	r_val |= r_set;
-	r_val &= ~r_clr;
-
-	w_val = __HFGWTR_EL2_nMASK;
-	w_val |= w_set;
-	w_val &= ~w_clr;
-
-	write_sysreg_s(r_val, SYS_HFGRTR_EL2);
-	write_sysreg_s(w_val, SYS_HFGWTR_EL2);
-
+	update_fgt_traps(hctxt, vcpu, kvm, HFGRTR_EL2);
+	update_fgt_traps_cs(hctxt, vcpu, kvm, HFGWTR_EL2, 0,
+			    cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38) ?
+			    HFGxTR_EL2_TCR_EL1_MASK : 0);
 	update_fgt_traps(hctxt, vcpu, kvm, HFGITR_EL2);
 	update_fgt_traps(hctxt, vcpu, kvm, HDFGRTR_EL2);
 	update_fgt_traps(hctxt, vcpu, kvm, HDFGWTR_EL2);
@@ -223,9 +197,11 @@ static inline void __deactivate_traps_hfgxtr(struct kvm_vcpu *vcpu)
 	if (!cpus_have_final_cap(ARM64_HAS_FGT))
 		return;
 
-	write_sysreg_s(ctxt_sys_reg(hctxt, HFGRTR_EL2), SYS_HFGRTR_EL2);
-	write_sysreg_s(ctxt_sys_reg(hctxt, HFGWTR_EL2), SYS_HFGWTR_EL2);
-
+	__deactivate_fgt(hctxt, vcpu, kvm, HFGRTR_EL2);
+	if (cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38))
+		write_sysreg_s(ctxt_sys_reg(hctxt, HFGWTR_EL2), SYS_HFGWTR_EL2);
+	else
+		__deactivate_fgt(hctxt, vcpu, kvm, HFGWTR_EL2);
 	__deactivate_fgt(hctxt, vcpu, kvm, HFGITR_EL2);
 	__deactivate_fgt(hctxt, vcpu, kvm, HDFGRTR_EL2);
 	__deactivate_fgt(hctxt, vcpu, kvm, HDFGWTR_EL2);
-- 
2.39.2


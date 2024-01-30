Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE8471B4C
	for <kvmarm@lists.linux.dev>; Tue, 30 Jan 2024 20:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706647550; cv=none; b=lm/pgBozTjsWbhJxmef9GNuxdZ17di9bv8HgFGY1eTfGv4Ao1HpILdetzXMFytBCcbdhcwkQMYM60Be5Js0+j8Uu6vKu603XEg6jyxpyydkxw3+ptCS6r5LJVhcSpUCrYh9K/cCsQWTz0D3Xdhj0WomdWzUABfn1t41kPZs1pco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706647550; c=relaxed/simple;
	bh=hSdauJw9sqqU1t6o28/fU6gzi3FgMMGYcmtUrNcsBTQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dvsk4fZ+4AlbdukQET9krNJYEimQq5s2gY6nGXVI6av/vfP9xKXOlZe/NuJGLdstNQZKoN3I9JaoJImFRtuLhOVr3h9LnYNZwiZ4kZpodXf2Zbyd9k6xexrFvl1acw5aVDhPGyPCy9p3PVjiP/7o+GaDR8UbLBOxodmwtxbiQSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h2tpoKya; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h2tpoKya"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A76BFC433B1;
	Tue, 30 Jan 2024 20:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706647550;
	bh=hSdauJw9sqqU1t6o28/fU6gzi3FgMMGYcmtUrNcsBTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h2tpoKyaC0auS7mWWSe/9IaVVjmXel+Er2+ey+l/xO/gCOctUsvaX0mOX+ySYA2xS
	 HC2TGBfo4boKRu0g6t4r9zJTpdtaKsAmvEDQ0KHT4tZa4TrtTyjklIPriyRe/wvodF
	 kR3w5J3Et9WBbys8v+gSFr/I47AMuB9eDt+BqtY1fSIbUIoDYruHOf266iyCep/yIX
	 dy/KEEy8QZzXhgNskoRBJj66U93T5vtDciJrpLhscjMsehy+Uy7RcijGUKCfwsc25v
	 SXdb1UoQHBV887ltAvF2l2fZB+j9vnCumz09PmN8OsVOFc1cduJ4bxHzq4WQ30FZJa
	 6Ya3WI9swyxdg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rUuzM-00GNsE-TD;
	Tue, 30 Jan 2024 20:45:48 +0000
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
Subject: [PATCH v2 20/25] KVM: arm64: Streamline save/restore of HFG[RW]TR_EL2
Date: Tue, 30 Jan 2024 20:45:27 +0000
Message-Id: <20240130204533.693853-21-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240130204533.693853-1-maz@kernel.org>
References: <20240130204533.693853-1-maz@kernel.org>
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


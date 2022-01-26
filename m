Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC63DC2BA4C
	for <kvmarm@archiver.kernel.org>; Wed, 26 Jan 2022 15:14:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A187E49DF6;
	Wed, 26 Jan 2022 10:14:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id A7Ec5n37mumm; Wed, 26 Jan 2022 10:14:30 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7ACE3412FC;
	Wed, 26 Jan 2022 10:14:30 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0963540DCB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 10:14:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qHJU5f71DRsu for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Jan 2022 10:14:28 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 56BF549E33
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 10:14:27 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id E2CFB61883;
 Wed, 26 Jan 2022 15:14:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4818BC340E8;
 Wed, 26 Jan 2022 15:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1643210066;
 bh=copy4cRQ6puPNwPV3UaCKRsGUK05uLwxOUu+r7/XC10=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=Z78BLYv32FxtO975+1ZRXnyIDr1HVDi5tg9h1si/BHxCjOFnFExApxIrbNBgY1/8G
 2LaXk4DreF+ZgjE3rmluBZXR/kQC7ROFrKNaPukUIOo4HS+dUUsg/1ESIh8+v/Pj01
 XP0C7ML4IhpHSnU+mC9RyR/W9wdOWfMbntB/BoEGZHoBErvhoJJJJaBaLvK9Js54cu
 uFiK17q2ZyvkxwMnzgE0MqCRC9TAVBly4bPoneGEl8ag5oDI6qr1Ymqc5aYraXHIgp
 LY+k0xKH6buJicrdmx5qOvmYAi9VFZCFUJVLt3EwEj0zjkEGJPPke1K/1aPVBvi4a8
 W3ZY4reYpUZ4Q==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH v9 40/40] squqsh traps
Date: Wed, 26 Jan 2022 15:11:20 +0000
Message-Id: <20220126151120.3811248-41-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220126151120.3811248-1-broonie@kernel.org>
References: <20220126151120.3811248-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4479; h=from:subject;
 bh=copy4cRQ6puPNwPV3UaCKRsGUK05uLwxOUu+r7/XC10=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBh8WSWpilDW9eFLR9WsG+pu8O0oF7wMm6YV2gEwgCG
 DNHOJqqJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYfFklgAKCRAk1otyXVSH0CjgB/
 9L+PEoqD+XcoxnxNpfVepzo0f0TuyQ/QjuCAai209ngWlT2tkE+A7RbRVGotpHUNWdRqTru1xQJ2iR
 kPGJXAWAUkpDOZb8Xe661bgaYNXIEBgabR3RhuOdTH/6pwrHhO3vpg+m4LAQNRTShE/ieYIuAb2r4w
 4UdbuVJElFW0YcMiMsQgXTvwJgtG8RcS7zAs1I7YYTS85+x0jPrII3e4leiZJkS9vDt31Dgd7VXps1
 wl4suOMcTKs+sdlJNH0fzGVEzf0WAQryFYfIXBUpCtOu1VXDKGyrb8tIqH5Xy1arbux0iOyDdI8oAN
 S3q7A55s/MzSSBaWoQFUyEenBIgMQL
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Cc: Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Luis Machado <luis.machado@arm.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>,
 Mark Brown <broonie@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linux-kselftest@vger.kernel.org, Alan Hayward <alan.hayward@arm.com>,
 kvmarm@lists.cs.columbia.edu, Salil Akerkar <Salil.Akerkar@arm.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

---
 arch/arm64/kvm/fpsimd.c          | 22 ++++++++++------------
 arch/arm64/kvm/hyp/nvhe/switch.c | 20 ++++++++++----------
 arch/arm64/kvm/hyp/vhe/switch.c  |  4 ++--
 3 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index cecaddb644ce..1c585553d74f 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -153,18 +153,16 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 	 * If we have VHE then the Hyp code will reset CPACR_EL1 to
 	 * CPACR_EL1_DEFAULT and we need to reenable SME.
 	 */
-	if (has_vhe()) {
-		if (system_supports_sme()) {
-			/* Also restore EL0 state seen on entry */
-			if (vcpu->arch.flags & KVM_ARM64_HOST_SME_ENABLED)
-				sysreg_clear_set(CPACR_EL1, 0,
-						 CPACR_EL1_SMEN_EL0EN |
-						 CPACR_EL1_SMEN_EL1EN);
-			else
-				sysreg_clear_set(CPACR_EL1,
-						 CPACR_EL1_SMEN_EL0EN,
-						 CPACR_EL1_SMEN_EL1EN);
-		}
+	if (has_vhe() && system_supports_sme()) {
+		/* Also restore EL0 state seen on entry */
+		if (vcpu->arch.flags & KVM_ARM64_HOST_SME_ENABLED)
+			sysreg_clear_set(CPACR_EL1, 0,
+					 CPACR_EL1_SMEN_EL0EN |
+					 CPACR_EL1_SMEN_EL1EN);
+		else
+			sysreg_clear_set(CPACR_EL1,
+					 CPACR_EL1_SMEN_EL0EN,
+					 CPACR_EL1_SMEN_EL1EN);
 	}
 
 	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED) {
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 184bf6bd79b9..caace61ea459 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -47,21 +47,20 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 		val |= CPTR_EL2_TFP | CPTR_EL2_TZ;
 		__activate_traps_fpsimd32(vcpu);
 	}
-	if (IS_ENABLED(CONFIG_ARM64_SME) && cpus_have_final_cap(ARM64_SME))
+	if (cpus_have_final_cap(ARM64_SME))
 		val |= CPTR_EL2_TSM;
 
 	write_sysreg(val, cptr_el2);
 	write_sysreg(__this_cpu_read(kvm_hyp_vector), vbar_el2);
 
-	if (IS_ENABLED(CONFIG_ARM64_SME) && cpus_have_final_cap(ARM64_SME) &&
-	    cpus_have_final_cap(ARM64_HAS_FGT)) {
+	if (cpus_have_final_cap(ARM64_SME)) {
 		val = read_sysreg_s(SYS_HFGRTR_EL2);
-		val &= ~(HFGxTR_EL2_nTPIDR_EL0_MASK |
+		val &= ~(HFGxTR_EL2_nTPIDR2_EL0_MASK |
 			 HFGxTR_EL2_nSMPRI_EL1_MASK);
 		write_sysreg_s(val, SYS_HFGRTR_EL2);
 
 		val = read_sysreg_s(SYS_HFGWTR_EL2);
-		val &= ~(HFGxTR_EL2_nTPIDR_EL0_MASK |
+		val &= ~(HFGxTR_EL2_nTPIDR2_EL0_MASK |
 			 HFGxTR_EL2_nSMPRI_EL1_MASK);
 		write_sysreg_s(val, SYS_HFGWTR_EL2);
 	}
@@ -109,23 +108,24 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 
 	write_sysreg(this_cpu_ptr(&kvm_init_params)->hcr_el2, hcr_el2);
 
-	if (IS_ENABLED(CONFIG_ARM64_SME) && cpus_have_final_cap(ARM64_SME) &&
-	    cpus_have_final_cap(ARM64_HAS_FGT)) {
+	if (cpus_have_final_cap(ARM64_SME)) {
 		u64 val;
 
 		val = read_sysreg_s(SYS_HFGRTR_EL2);
-		val |= HFGxTR_EL2_nTPIDR_EL0_MASK | HFGxTR_EL2_nSMPRI_EL1_MASK;
+		val |= HFGxTR_EL2_nTPIDR2_EL0_MASK |
+			HFGxTR_EL2_nSMPRI_EL1_MASK;
 		write_sysreg_s(val, SYS_HFGRTR_EL2);
 
 		val = read_sysreg_s(SYS_HFGWTR_EL2);
-		val |= HFGxTR_EL2_nTPIDR_EL0_MASK | HFGxTR_EL2_nSMPRI_EL1_MASK;
+		val |= HFGxTR_EL2_nTPIDR2_EL0_MASK |
+			HFGxTR_EL2_nSMPRI_EL1_MASK;
 		write_sysreg_s(val, SYS_HFGWTR_EL2);
 	}
 
 	cptr = CPTR_EL2_DEFAULT;
 	if (vcpu_has_sve(vcpu) && (vcpu->arch.flags & KVM_ARM64_FP_ENABLED))
 		cptr |= CPTR_EL2_TZ;
-	if (IS_ENABLED(CONFIG_ARM64_SME) && cpus_have_final_cap(ARM64_SME))
+	if (cpus_have_final_cap(ARM64_SME))
 		cptr &= ~CPTR_EL2_TSM;
 
 	write_sysreg(cptr, cptr_el2);
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 21217485514d..a4d2fb5c9710 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -60,7 +60,7 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 		__activate_traps_fpsimd32(vcpu);
 	}
 
-	if (IS_ENABLED(CONFIG_ARM64_SME) && cpus_have_final_cap(ARM64_SME))
+	if (cpus_have_final_cap(ARM64_SME))
 		write_sysreg(read_sysreg(sctlr_el2) & ~SCTLR_ELx_ENTP2,
 			     sctlr_el2);
 
@@ -85,7 +85,7 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 	 */
 	asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_SPECULATIVE_AT));
 
-	if (IS_ENABLED(CONFIG_ARM64_SME) && cpus_have_final_cap(ARM64_SME))
+	if (cpus_have_final_cap(ARM64_SME))
 		write_sysreg(read_sysreg(sctlr_el2) | SCTLR_ELx_ENTP2,
 			     sctlr_el2);
 
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

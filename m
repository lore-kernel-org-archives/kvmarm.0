Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98C11171B4
	for <kvmarm@lists.linux.dev>; Mon,  5 Feb 2024 10:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707129291; cv=none; b=VKeI60SrbB3NJgtxbEnZ4DMw9ntBIC08M7VXzfcW2OfBmDFp55iE8ZGShC08zU7yy0emBVhJFHuuOP+HEPBXzs7xxv1EM3J2dDZBFqVDtb4Sbp+a12HNa6bkLlQ7qxXZaqSFOTK3xYaS6NLQKOQgGy1MMlMQlY1yKgMg4FxTdPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707129291; c=relaxed/simple;
	bh=MSK9uIvhVI7ocNChg+YpHLbRXohZWodSIZ69qXfzdQk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VnaKgK3wmW0x+v4+XT0gij302XzVvYFXE05jJOfmloGGdJ97ft7ssiSnHO1Sf8TGG5Gl65/ztr2x3J2LN5HGjCakUqjiplZ7WqeJQv/CIwivf5hmAaLoRywNgZxXwfEkyg0WBeBVaXrVVdWkyc+bBd0G5iFKDJmkFORN3aBlHts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jTqO7c9l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jTqO7c9l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FE87C43394;
	Mon,  5 Feb 2024 10:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707129291;
	bh=MSK9uIvhVI7ocNChg+YpHLbRXohZWodSIZ69qXfzdQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jTqO7c9lxCsaakb40aT8If6m5C89W9grS40am8mNO2NcXARUuAIWcJ7DD9pCceZiO
	 8cQ+PYpR5k/jOFb3q1hlTzMMWHDxHpVmV222Ba6CKhW4hazd3uU+sJlbSfAQnz7C2W
	 VlyxJ+Zy8KC5oUg0sLmSYqcpkEls83o1P0o+bNUFburxaQkf+TbNQ/0Cw5I/bvwHQQ
	 p4ESm8TnlB2M9nB9V+qo6H4oaPVXesKdfbOuB1Fc/Gw3oIuX0mMDB5v07jXKQQDMcg
	 /xQCilPjHZ9mw63XHBWOrn6CHDYNzaPr8L6RdrZ4z5+zSQo7XJuo1K71yL8qMbj9J5
	 fWneLug/VJWgw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rWwJN-000Nc3-Dy;
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
Subject: [PATCH v3 22/26] KVM: arm64: Make PIR{,E0}_EL1 UNDEF if S1PIE is not advertised to the guest
Date: Mon,  5 Feb 2024 10:34:27 +0000
Message-Id: <20240205103431.1104133-23-maz@kernel.org>
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

As part of the ongoing effort to honor the guest configuration,
add the necessary checks to make PIR_EL1 and co UNDEF if not
advertised to the guest, and avoid context switching them.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Joey Gouly <joey.gouly@arm.com>
---
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 24 +++++++++++++++++++---
 arch/arm64/kvm/sys_regs.c                  |  4 ++++
 2 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index bb6b571ec627..4be6a7fa0070 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -27,16 +27,34 @@ static inline void __sysreg_save_user_state(struct kvm_cpu_context *ctxt)
 	ctxt_sys_reg(ctxt, TPIDRRO_EL0)	= read_sysreg(tpidrro_el0);
 }
 
-static inline bool ctxt_has_mte(struct kvm_cpu_context *ctxt)
+static inline struct kvm_vcpu *ctxt_to_vcpu(struct kvm_cpu_context *ctxt)
 {
 	struct kvm_vcpu *vcpu = ctxt->__hyp_running_vcpu;
 
 	if (!vcpu)
 		vcpu = container_of(ctxt, struct kvm_vcpu, arch.ctxt);
 
+	return vcpu;
+}
+
+static inline bool ctxt_has_mte(struct kvm_cpu_context *ctxt)
+{
+	struct kvm_vcpu *vcpu = ctxt_to_vcpu(ctxt);
+
 	return kvm_has_mte(kern_hyp_va(vcpu->kvm));
 }
 
+static inline bool ctxt_has_s1pie(struct kvm_cpu_context *ctxt)
+{
+	struct kvm_vcpu *vcpu;
+
+	if (!cpus_have_final_cap(ARM64_HAS_S1PIE))
+		return false;
+
+	vcpu = ctxt_to_vcpu(ctxt);
+	return kvm_has_feat(kern_hyp_va(vcpu->kvm), ID_AA64MMFR3_EL1, S1PIE, IMP);
+}
+
 static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 {
 	ctxt_sys_reg(ctxt, SCTLR_EL1)	= read_sysreg_el1(SYS_SCTLR);
@@ -55,7 +73,7 @@ static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 	ctxt_sys_reg(ctxt, CONTEXTIDR_EL1) = read_sysreg_el1(SYS_CONTEXTIDR);
 	ctxt_sys_reg(ctxt, AMAIR_EL1)	= read_sysreg_el1(SYS_AMAIR);
 	ctxt_sys_reg(ctxt, CNTKCTL_EL1)	= read_sysreg_el1(SYS_CNTKCTL);
-	if (cpus_have_final_cap(ARM64_HAS_S1PIE)) {
+	if (ctxt_has_s1pie(ctxt)) {
 		ctxt_sys_reg(ctxt, PIR_EL1)	= read_sysreg_el1(SYS_PIR);
 		ctxt_sys_reg(ctxt, PIRE0_EL1)	= read_sysreg_el1(SYS_PIRE0);
 	}
@@ -131,7 +149,7 @@ static inline void __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
 	write_sysreg_el1(ctxt_sys_reg(ctxt, CONTEXTIDR_EL1), SYS_CONTEXTIDR);
 	write_sysreg_el1(ctxt_sys_reg(ctxt, AMAIR_EL1),	SYS_AMAIR);
 	write_sysreg_el1(ctxt_sys_reg(ctxt, CNTKCTL_EL1), SYS_CNTKCTL);
-	if (cpus_have_final_cap(ARM64_HAS_S1PIE)) {
+	if (ctxt_has_s1pie(ctxt)) {
 		write_sysreg_el1(ctxt_sys_reg(ctxt, PIR_EL1),	SYS_PIR);
 		write_sysreg_el1(ctxt_sys_reg(ctxt, PIRE0_EL1),	SYS_PIRE0);
 	}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index f07ee7c89822..da9db99c77e7 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3994,6 +3994,10 @@ void kvm_init_sysreg(struct kvm_vcpu *vcpu)
 						HFGITR_EL2_TLBIRVAAE1OS	|
 						HFGITR_EL2_TLBIRVAE1OS);
 
+	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, S1PIE, IMP))
+		kvm->arch.fgu[HFGxTR_GROUP] |= (HFGxTR_EL2_nPIRE0_EL1 |
+						HFGxTR_EL2_nPIR_EL1);
+
 	set_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags);
 out:
 	mutex_unlock(&kvm->arch.config_lock);
-- 
2.39.2


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2FDF53B8
	for <kvmarm@lists.linux.dev>; Mon,  6 Mar 2023 16:14:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F41C433EF;
	Mon,  6 Mar 2023 16:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1678119258;
	bh=PDs56VNU4oO2KDlbn2IQKreMw9ZyS7gdBFwViIXmDAw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ErTDHwKCRBQauxVsr5O859XgFOuvy0LxaMQBnhK8a7YNFai6cQt0VzxqXuT8tvXIU
	 Xh1CrBIPsxMuiX8Aeb3BPMVJrbhjl7ghqHEGQzGAPu7msZGz6ZBfYGVRUXuWg0WCXT
	 FohywE7v34KR1OfQWFV7b1RzlN7g7WrgbteLELhO2sAcq+IooeKWntN4BADuUxxKfd
	 J1WNcNq4Y8FKn/aBKiSSQEkrEJFmuapsUy5S4guprA7mRkFBfL0wJQnKmZk60jApb8
	 V4d+ilZDTyOKnPj5xT1WBq9bW6p6rzAys2dKzZNgt0SJVmMHm8Jouw3p7l2SdeonqX
	 ytuIO5yQ5y+5g==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 06 Mar 2023 16:08:52 +0000
Subject: [PATCH 2/2] KVM: arm64: Move FGT value configuration to vCPU state
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230301-kvm-arm64-fgt-v1-2-cfdf71ac67dc@kernel.org>
References: <20230301-kvm-arm64-fgt-v1-0-cfdf71ac67dc@kernel.org>
In-Reply-To: <20230301-kvm-arm64-fgt-v1-0-cfdf71ac67dc@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>, linux-arm-kernel@lists.infradead.org, 
 kvmarm@lists.linux.dev, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.13-dev-bd1bf
X-Developer-Signature: v=1; a=openpgp-sha256; l=4820; i=broonie@kernel.org;
 h=from:subject:message-id; bh=PDs56VNU4oO2KDlbn2IQKreMw9ZyS7gdBFwViIXmDAw=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBkBhFS8VPDXLq7ul3hp7T6S6dlGFBh9wrdCvmNpyW2
 IHdvtSqJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZAYRUgAKCRAk1otyXVSH0BlCB/
 sERbzViIB5DrDpKeMnR5SgCTwPODHZm3banAHO6si4uhF1FqU8xQj5RFavo4a0CxncxGm+vT49+hhA
 1WEK3qwdTRpswrn3XkpRs49z9LhokpxTxZKTPo88VGaC6j/I1SIWJe92IvQd6Vq6lyKnBuUrAAxJDU
 ls2VGAlXgm5U1hfUbVvAsvhzbivFJ82ctbpGxwrkVJYjUP3TON20Xg9xAfvdtHs/piHbnDgeedLDzI
 dIciun1QfFP0Sj6qvWMrbVuD2Ikp1AQJry4/jIy8xWHpeIYPQb9ybm5I2CK9Sp0q0ZHV8TvdhjeSL5
 sNhujCUSM5QsqOnDH3qiBzD+8yi6AZ
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

Currently the only fine grained traps we use are the SME ones and we decide
if we want to manage fine grained traps for the guest and which to
enable based on the presence of that feature. In order to support SME,
PIE and other features where we need fine grained traps we will need to
select per guest which traps are enabled. Move to storing the traps to
enable in the vCPU data, updating the registers if fine grained traps
are supported and any are enabled.

Currently we always set this register to 0 when running the guest and
unused bits in the registers are RES0 so unconditionally use that value
for guests, future patches will configure this.

The configuration for the host is saved at guest reset under the
assumption that the traps are not dynamically managed for the host at
runtime.  This is currently the case, if this changes then we will need
to save each time we enter the guest.

No functional change.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h    | 12 ++++++++++++
 arch/arm64/include/asm/kvm_host.h       |  6 ++++++
 arch/arm64/kvm/arm.c                    |  1 +
 arch/arm64/kvm/hyp/include/hyp/switch.h | 31 +++++++++++++++----------------
 4 files changed, 34 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index b31b32ecbe2d..20f2faae12d4 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -107,6 +107,18 @@ static inline unsigned long *vcpu_hcr(struct kvm_vcpu *vcpu)
 	return (unsigned long *)&vcpu->arch.hcr_el2;
 }
 
+static inline void vcpu_reset_fgt(struct kvm_vcpu *vcpu)
+{
+	if (!cpus_have_const_cap(ARM64_HAS_FGT))
+		return;
+
+	vcpu->arch.hfgrtr_el2_host = read_sysreg_s(SYS_HFGRTR_EL2);
+	vcpu->arch.hfgwtr_el2_host = read_sysreg_s(SYS_HFGWTR_EL2);
+
+	vcpu->arch.hfgrtr_el2 = 0;
+	vcpu->arch.hfgwtr_el2 = 0;
+}
+
 static inline void vcpu_clear_wfx_traps(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.hcr_el2 &= ~HCR_TWE;
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index a1892a8f6032..09b223635764 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -530,6 +530,12 @@ struct kvm_vcpu_arch {
 	/* Virtual SError ESR to restore when HCR_EL2.VSE is set */
 	u64 vsesr_el2;
 
+	/* Fine grained traps values for the guest and host */
+	u64 hfgrtr_el2;
+	u64 hfgwtr_el2;
+	u64 hfgrtr_el2_host;
+	u64 hfgwtr_el2_host;
+
 	/* Additional reset state */
 	struct vcpu_reset_state	reset_state;
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 3bd732eaf087..baa8d1a089bd 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1205,6 +1205,7 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
 	}
 
 	vcpu_reset_hcr(vcpu);
+	vcpu_reset_fgt(vcpu);
 	vcpu->arch.cptr_el2 = CPTR_EL2_DEFAULT;
 
 	/*
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 07d37ff88a3f..3abef074b91e 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -88,15 +88,14 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
 	vcpu->arch.mdcr_el2_host = read_sysreg(mdcr_el2);
 	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
 
-	if (cpus_have_final_cap(ARM64_SME)) {
-		sysreg_clear_set_s(SYS_HFGRTR_EL2,
-				   HFGxTR_EL2_nSMPRI_EL1_MASK |
-				   HFGxTR_EL2_nTPIDR2_EL0_MASK,
-				   0);
-		sysreg_clear_set_s(SYS_HFGWTR_EL2,
-				   HFGxTR_EL2_nSMPRI_EL1_MASK |
-				   HFGxTR_EL2_nTPIDR2_EL0_MASK,
-				   0);
+	if (cpus_have_final_cap(ARM64_HAS_FGT)) {
+		if (vcpu->arch.hfgrtr_el2_host != vcpu->arch.hfgrtr_el2)
+			write_sysreg_s(vcpu->arch.hfgrtr_el2,
+				       SYS_HFGRTR_EL2);
+
+		if (vcpu->arch.hfgwtr_el2_host != vcpu->arch.hfgwtr_el2)
+			write_sysreg_s(vcpu->arch.hfgwtr_el2,
+				       SYS_HFGWTR_EL2);
 	}
 }
 
@@ -108,13 +107,13 @@ static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
 	if (kvm_arm_support_pmu_v3())
 		write_sysreg(0, pmuserenr_el0);
 
-	if (cpus_have_final_cap(ARM64_SME)) {
-		sysreg_clear_set_s(SYS_HFGRTR_EL2, 0,
-				   HFGxTR_EL2_nSMPRI_EL1_MASK |
-				   HFGxTR_EL2_nTPIDR2_EL0_MASK);
-		sysreg_clear_set_s(SYS_HFGWTR_EL2, 0,
-				   HFGxTR_EL2_nSMPRI_EL1_MASK |
-				   HFGxTR_EL2_nTPIDR2_EL0_MASK);
+	if (cpus_have_final_cap(ARM64_HAS_FGT)) {
+		if (vcpu->arch.hfgrtr_el2_host != vcpu->arch.hfgrtr_el2)
+			write_sysreg_s(vcpu->arch.hfgrtr_el2_host,
+				       SYS_HFGRTR_EL2);
+		if (vcpu->arch.hfgwtr_el2_host != vcpu->arch.hfgwtr_el2)
+			write_sysreg_s(vcpu->arch.hfgwtr_el2_host,
+				       SYS_HFGWTR_EL2);
 	}
 }
 

-- 
2.30.2


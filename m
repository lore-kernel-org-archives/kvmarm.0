Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD26441F
	for <kvmarm@lists.linux.dev>; Wed, 12 Jul 2023 12:50:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F7F2C433CB;
	Wed, 12 Jul 2023 12:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1689166237;
	bh=lM0kLi7FjXJh4jmfl1kHjn621R4PVywtSYu+XxWfuJg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Su29W6tKSBaMwqoZKPJgA2EHfD12If8WXAjFfxE2C/ZH1LQ86yPkj4Zb3gSi6Yjvu
	 jIyAFnL2FS8FAsffcZjhbXxp12Pgi1fuxrHm1bYMJh1ylmKNNrqeCJuV2KtVczItnn
	 lEYO7XAvFhQIgRPmo4UYFYMj4QnRJSiJKY3nQ26+sw0h4+rRP+wjXtbXGqqKhQFVqD
	 B6CDUjMzQQA2FL0CuSL91ishliuqD0cve0cw9ysng+CMhGKKE/jQAyfBIL1lW6pXC2
	 x72xR3fZfcpEmUOK56HAo5zSHAsdehFjcjI4lVML5Eiqg1SFvqM5+nKSDqkz8SgViH
	 WM+9sKcuXcDmA==
From: Mark Brown <broonie@kernel.org>
Date: Wed, 12 Jul 2023 13:50:12 +0100
Subject: [PATCH v5 2/2] KVM: arm64: Move FGT value configuration to vCPU
 state
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230712-kvm-arm64-fgt-v5-2-dae3ec236288@kernel.org>
References: <20230712-kvm-arm64-fgt-v5-0-dae3ec236288@kernel.org>
In-Reply-To: <20230712-kvm-arm64-fgt-v5-0-dae3ec236288@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>, linux-arm-kernel@lists.infradead.org, 
 kvmarm@lists.linux.dev, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.13-dev-099c9
X-Developer-Signature: v=1; a=openpgp-sha256; l=6323; i=broonie@kernel.org;
 h=from:subject:message-id; bh=lM0kLi7FjXJh4jmfl1kHjn621R4PVywtSYu+XxWfuJg=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBkrqGV9LoBerJcZIf2/wGU6Q4PM+H6xffmiAba3HWJ
 AC0Qr/iJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZK6hlQAKCRAk1otyXVSH0N4EB/
 9Gy6aPGhgWsdVm1UWlDbFK551PhvRmD1dL1nAMFF1x20CFZ/wrk1KeDa4L4dlRFRsPK7YdCcBww8+B
 iINoUUB7VD644JROGH2XVqT1NJZghQYmpFak6F2IDoOatjHd+IN4MHe3I8G1ulDlDV818d2BBZe66z
 VLVIUIsHZyZTagoOOCYPSmauHNZHfHHpI2nALGvLo8fYv48xC/D1QW7PfA8+2M/N5Q7jVkaJqJtU4y
 R4EimH2P//o7oaAbP1XU2iwNP0vbwzTIad+ALppgUaWgfmHRRw+rw5LnuvtANCdE71V+rgeAQ4RcAN
 0Fyi0AY4q6FZNIZJH427amGMFystgX
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

Currently the only fine grained traps we use are the SME ones and we decide
which to enable based on the presence of that feature. In order to support
SME, GCS and other features where we need fine grained traps we will need to
select per guest which traps are enabled. Move to storing the traps to
enable in the vCPU data, updating the registers if fine grained traps are
supported and any are enabled.

The code assumes that we never change the set of fine grained traps for the
host after boot.

No functional change, though there will be a small overhead on systems with
fine grained traps supported.  We could optimise slightly by assuming that
host and guest always set the same pattern for read and write (they do
currently) but this seemed more likely to cause surprises in future than
it was worth.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h    | 21 +++++++++++
 arch/arm64/include/asm/kvm_host.h       |  6 ++++
 arch/arm64/kvm/arm.c                    |  1 +
 arch/arm64/kvm/hyp/include/hyp/switch.h | 62 +++++++++------------------------
 4 files changed, 44 insertions(+), 46 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index efc0b45d79c3..0d6c8d7e2aaa 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -108,6 +108,27 @@ static inline unsigned long *vcpu_hcr(struct kvm_vcpu *vcpu)
 	return (unsigned long *)&vcpu->arch.hcr_el2;
 }
 
+static inline void vcpu_reset_fgt(struct kvm_vcpu *vcpu)
+{
+	if (!cpus_have_const_cap(ARM64_HAS_FGT))
+		return;
+
+	vcpu->arch.hfgrtr_el2 = 0;
+	vcpu->arch.hfgwtr_el2 = 0;
+
+	/*
+	 * Trap guest writes to TCR_EL1 to prevent it from enabling HA or HD.
+	 */
+	if (cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38)) {
+		vcpu->arch.hfgrtr_el2 |= HFGxTR_EL2_TCR_EL1_MASK;
+		vcpu->arch.hfgwtr_el2 |= HFGxTR_EL2_TCR_EL1_MASK;
+	}
+
+	/* We currently assume the host configuration never changes */
+	vcpu->arch.hfgrtr_el2_host = read_sysreg_s(SYS_HFGRTR_EL2);
+	vcpu->arch.hfgwtr_el2_host = read_sysreg_s(SYS_HFGWTR_EL2);
+}
+
 static inline void vcpu_clear_wfx_traps(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.hcr_el2 &= ~HCR_TWE;
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 8b6096753740..a7f558ba0406 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -574,6 +574,12 @@ struct kvm_vcpu_arch {
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
index c2c14059f6a8..86866d05c6d5 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1306,6 +1306,7 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
 	}
 
 	vcpu_reset_hcr(vcpu);
+	vcpu_reset_fgt(vcpu);
 	vcpu->arch.cptr_el2 = kvm_get_reset_cptr_el2(vcpu);
 
 	/*
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 4bddb8541bec..f35f8fb6a489 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -70,54 +70,26 @@ static inline void __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
 	}
 }
 
-static inline bool __hfgxtr_traps_required(void)
+static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
 {
-	if (cpus_have_final_cap(ARM64_SME))
-		return true;
-
-	if (cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38))
-		return true;
-
-	return false;
-}
-
-static inline void __activate_traps_hfgxtr(void)
-{
-	u64 r_clr = 0, w_clr = 0, r_set = 0, w_set = 0, tmp;
-
-	if (cpus_have_final_cap(ARM64_SME)) {
-		tmp = HFGxTR_EL2_nSMPRI_EL1_MASK | HFGxTR_EL2_nTPIDR2_EL0_MASK;
-
-		r_clr |= tmp;
-		w_clr |= tmp;
-	}
-
-	/*
-	 * Trap guest writes to TCR_EL1 to prevent it from enabling HA or HD.
-	 */
-	if (cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38))
-		w_set |= HFGxTR_EL2_TCR_EL1_MASK;
+	if (!cpus_have_final_cap(ARM64_HAS_FGT))
+		return;
 
-	sysreg_clear_set_s(SYS_HFGRTR_EL2, r_clr, r_set);
-	sysreg_clear_set_s(SYS_HFGWTR_EL2, w_clr, w_set);
+	if (vcpu->arch.hfgrtr_el2_host != vcpu->arch.hfgrtr_el2)
+		write_sysreg_s(vcpu->arch.hfgrtr_el2, SYS_HFGRTR_EL2);
+	if (vcpu->arch.hfgwtr_el2_host != vcpu->arch.hfgwtr_el2)
+		write_sysreg_s(vcpu->arch.hfgwtr_el2,  SYS_HFGWTR_EL2);
 }
 
-static inline void __deactivate_traps_hfgxtr(void)
+static inline void __deactivate_traps_hfgxtr(struct kvm_vcpu *vcpu)
 {
-	u64 r_clr = 0, w_clr = 0, r_set = 0, w_set = 0, tmp;
-
-	if (cpus_have_final_cap(ARM64_SME)) {
-		tmp = HFGxTR_EL2_nSMPRI_EL1_MASK | HFGxTR_EL2_nTPIDR2_EL0_MASK;
-
-		r_set |= tmp;
-		w_set |= tmp;
-	}
-
-	if (cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38))
-		w_clr |= HFGxTR_EL2_TCR_EL1_MASK;
+	if (!cpus_have_final_cap(ARM64_HAS_FGT))
+		return;
 
-	sysreg_clear_set_s(SYS_HFGRTR_EL2, r_clr, r_set);
-	sysreg_clear_set_s(SYS_HFGWTR_EL2, w_clr, w_set);
+	if (vcpu->arch.hfgrtr_el2_host != vcpu->arch.hfgrtr_el2)
+		write_sysreg_s(vcpu->arch.hfgrtr_el2, SYS_HFGRTR_EL2);
+	if (vcpu->arch.hfgwtr_el2_host != vcpu->arch.hfgwtr_el2)
+		write_sysreg_s(vcpu->arch.hfgwtr_el2,  SYS_HFGWTR_EL2);
 }
 
 static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
@@ -145,8 +117,7 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
 	vcpu->arch.mdcr_el2_host = read_sysreg(mdcr_el2);
 	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
 
-	if (__hfgxtr_traps_required())
-		__activate_traps_hfgxtr();
+	__activate_traps_hfgxtr(vcpu);
 }
 
 static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
@@ -162,8 +133,7 @@ static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
 		vcpu_clear_flag(vcpu, PMUSERENR_ON_CPU);
 	}
 
-	if (__hfgxtr_traps_required())
-		__deactivate_traps_hfgxtr();
+	__deactivate_traps_hfgxtr(vcpu);
 }
 
 static inline void ___activate_traps(struct kvm_vcpu *vcpu)

-- 
2.30.2


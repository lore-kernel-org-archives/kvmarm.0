Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4202F30
	for <kvmarm@lists.linux.dev>; Wed, 29 Mar 2023 15:46:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49AF7C433A1;
	Wed, 29 Mar 2023 15:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1680104782;
	bh=UyhxdnHckHmYs+kiqd0ksP0HItdgnlrvkc2WP6XYbwk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=S0jmunuHxoUyMzRWxkx6fA1N3bNr1ocTyjRnxPryTuXQgGaLEzeeO/zHREOARcwas
	 n7nMiJAt6ScuEVP7n2EgzhkWt3HFOQxkkxpF5gArEoLT85XG9T+eoEPRMGhGUfsw41
	 IWgjgGa7gl1xtgMDGlmIEBOIz4pCd6zFpnbOhba5P5bmUtwudaUuJ2C/cYP5qMHsY+
	 kL/x3mmQxgVlXViAazwqSQ1mYKhhESraDBzOzsF/E34YFUwGqors0qd/IpiMKuwtGV
	 YMfUJS5SxzOFow6UKHvGAYifkyTD2doTtwdMLAVUuIgIaLCvCwF6N2eS2I20NcfIEA
	 BXaQFK/o8VRqA==
From: Mark Brown <broonie@kernel.org>
Date: Wed, 29 Mar 2023 16:38:18 +0100
Subject: [PATCH v3 2/2] KVM: arm64: Move FGT value configuration to vCPU
 state
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230301-kvm-arm64-fgt-v3-2-8f59543bb683@kernel.org>
References: <20230301-kvm-arm64-fgt-v3-0-8f59543bb683@kernel.org>
In-Reply-To: <20230301-kvm-arm64-fgt-v3-0-8f59543bb683@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>, linux-arm-kernel@lists.infradead.org, 
 kvmarm@lists.linux.dev, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.13-dev-bd1bf
X-Developer-Signature: v=1; a=openpgp-sha256; l=5280; i=broonie@kernel.org;
 h=from:subject:message-id; bh=UyhxdnHckHmYs+kiqd0ksP0HItdgnlrvkc2WP6XYbwk=;
 b=owEBbAGT/pANAwAKASTWi3JdVIfQAcsmYgBkJF1GpUGwd8p6NFh/kOh/JQwOspimD+baSEL8qpeI
 OSwwi3yJATIEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZCRdRgAKCRAk1otyXVSH0LwWB/
 jB7vwsNMgQJDiF7Wl+ylkEQFfb25INsa2vAnFszCkBOvR6fPaJbWMTJvEagjLR2HdOi3sr8qtYw3c/
 F8CRM+qOhIxaCRAIKyYZbZGlGDB9oWtXYquDZgL1MgH5jTkzXgJMDYb7s8njMLItUNZh15OqHsKQ2z
 fiuBu4K7VetSntLaQwxYuXEP/ONG+asVwSVl1U1w9THJce0t87Lau82JahBZP+cst1y93zLQj/eaQO
 AmwrnRoKMIhIuPgi5E9MVlc57hbJmfEod1jj3CfXdDVnZ9ZyyOHHFqjh1gY0rmFPG7u/+G4sMT1xgy
 YZ4X8mDJqQCAOMpUXPAEOw932VspY=
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

Currently the only fine grained traps we use are the SME ones and we decide
if we want to manage fine grained traps for the guest and which to
enable based on the presence of that feature. In order to support SME,
PIE and other features where we need fine grained traps we will need to
select per guest which traps are enabled. Move to storing the traps to
enable in the vCPU data, updating the registers if fine grained traps
are supported and any are enabled. In order to ensure that the fine
grained traps are restored along with other traps there is a bit of
asymmetry with where the registers are restored on guest exit.

Currently we always set this register to 0 when running the guest so
unconditionally use that value for guests, future patches will configure
this.

No functional change, though we will do additional saves of the guest
FGT register configurations and will save and restore even if the host
and guest states are identical.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h    | 16 ++++++++++++++
 arch/arm64/include/asm/kvm_host.h       |  3 +++
 arch/arm64/kvm/arm.c                    |  1 +
 arch/arm64/kvm/hyp/include/hyp/switch.h | 37 +++++++++++++++++++--------------
 4 files changed, 41 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index b31b32ecbe2d..979ffbe236a0 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -107,6 +107,22 @@ static inline unsigned long *vcpu_hcr(struct kvm_vcpu *vcpu)
 	return (unsigned long *)&vcpu->arch.hcr_el2;
 }
 
+static inline void vcpu_reset_fgt(struct kvm_vcpu *vcpu)
+{
+	if (!cpus_have_const_cap(ARM64_HAS_FGT))
+		return;
+
+	/*
+	 * Enable traps for the guest by default:
+	 *
+	 * ACCDATA_EL1, GCSPR_EL0, GCSCRE0_EL1, GCSPR_EL1, GCSCR_EL1,
+	 * SMPRI_EL1, TPIDR2_EL0, RCWMASK_EL1, PIRE0_EL1, PIR_EL1,
+	 * POR_EL0, POR_EL1, S2POR_EL1, MAIR2_EL1, and AMAIR_EL1,
+	 */
+	vcpu->arch.ctxt.hfgrtr_el2 = 0;
+	vcpu->arch.ctxt.hfgwtr_el2 = 0;
+}
+
 static inline void vcpu_clear_wfx_traps(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.hcr_el2 &= ~HCR_TWE;
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index bcd774d74f34..81a5ed81577a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -377,6 +377,9 @@ struct kvm_cpu_context {
 	u64	spsr_irq;
 	u64	spsr_fiq;
 
+	u64	hfgrtr_el2;
+	u64	hfgwtr_el2;
+
 	struct user_fpsimd_state fp_regs;
 
 	u64 sys_regs[NR_SYS_REGS];
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
index 07d37ff88a3f..972f3c71d57f 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -71,6 +71,8 @@ static inline void __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
 
 static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
 {
+	struct kvm_cpu_context *host_ctxt;
+
 	/* Trap on AArch32 cp15 c15 (impdef sysregs) accesses (EL1 or EL0) */
 	write_sysreg(1 << 15, hstr_el2);
 
@@ -88,33 +90,36 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
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
+		host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
+
+		host_ctxt->hfgrtr_el2 = read_sysreg_s(SYS_HFGRTR_EL2);
+		host_ctxt->hfgrtr_el2 = read_sysreg_s(SYS_HFGRTR_EL2);
+
+		write_sysreg_s(vcpu->arch.ctxt.hfgrtr_el2, SYS_HFGRTR_EL2);
+		write_sysreg_s(vcpu->arch.ctxt.hfgwtr_el2, SYS_HFGWTR_EL2);
 	}
 }
 
 static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
 {
+	struct kvm_cpu_context *host_ctxt;
+
 	write_sysreg(vcpu->arch.mdcr_el2_host, mdcr_el2);
 
 	write_sysreg(0, hstr_el2);
 	if (kvm_arm_support_pmu_v3())
 		write_sysreg(0, pmuserenr_el0);
 
-	if (cpus_have_final_cap(ARM64_SME)) {
-		sysreg_clear_set_s(SYS_HFGRTR_EL2, 0,
-				   HFGxTR_EL2_nSMPRI_EL1_MASK |
-				   HFGxTR_EL2_nTPIDR2_EL0_MASK);
-		sysreg_clear_set_s(SYS_HFGWTR_EL2, 0,
-				   HFGxTR_EL2_nSMPRI_EL1_MASK |
-				   HFGxTR_EL2_nTPIDR2_EL0_MASK);
+	/*
+	 * Restore the host FGT configuration here since it's managing
+	 * traps.
+	 */
+	if (cpus_have_final_cap(ARM64_HAS_FGT)) {
+		host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
+
+		write_sysreg_s(host_ctxt->hfgrtr_el2, SYS_HFGRTR_EL2);
+		write_sysreg_s(host_ctxt->hfgwtr_el2, SYS_HFGWTR_EL2);
 	}
 }
 

-- 
2.30.2


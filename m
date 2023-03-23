Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480C6A93A
	for <kvmarm@lists.linux.dev>; Thu, 23 Mar 2023 15:49:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8988C4339E;
	Thu, 23 Mar 2023 15:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1679586560;
	bh=bc/jDRoML8/rVwNAUXAs3Cta3BhHmQEWHxqYcAOab38=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Y8RnLkTBmRrhjiCyW130L+BNQBzbxNSG7I70XsoqngTJs4UHphHUZFAGhTmgR+Zn8
	 Tj3fjLbm9J1ESkhD9P8T3J5zRXQGdak+Xt32MJ9NuX1ksxf6Q99bYldMTACZ8jAV2r
	 JRCZdol00BS3X0vhCAupOAEba+h9t6wi463EqIitVRrdSDFuftdI3KaYnQzBVbJ4iJ
	 gNSk2iJQikA+sihToRxTke9Ju+IUTuEnKDFZRxr7MrPW2LzOhWEH3eK49SQFZJ9jbS
	 rnGTe74w3i/26ZWKDKQgJJHAKoIABhC5RFDmQVsQO4zL+LB/6W7z01l0Qj1aRd/95H
	 my6COBJHKQZug==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 23 Mar 2023 15:48:36 +0000
Subject: [PATCH v2 2/2] KVM: arm64: Move FGT value configuration to vCPU
 state
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230301-kvm-arm64-fgt-v2-2-c11c0dcf810a@kernel.org>
References: <20230301-kvm-arm64-fgt-v2-0-c11c0dcf810a@kernel.org>
In-Reply-To: <20230301-kvm-arm64-fgt-v2-0-c11c0dcf810a@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>, linux-arm-kernel@lists.infradead.org, 
 kvmarm@lists.linux.dev, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.13-dev-bd1bf
X-Developer-Signature: v=1; a=openpgp-sha256; l=5886; i=broonie@kernel.org;
 h=from:subject:message-id; bh=bc/jDRoML8/rVwNAUXAs3Cta3BhHmQEWHxqYcAOab38=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBkHHT39sie3zytPuOBFnmH9uhGc9ss/mq0VfLRht01
 hCRuD4mJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZBx09wAKCRAk1otyXVSH0FlkB/
 0RxLEG+X40SNnVIz0hYn4/XdONL1t4B3+Quz5D3RTDwfxYaCICBkGhvFlIvNs3I0ONe0ouxCy7GkCb
 o2vphAprPpa6ZfN/26Cx8QP+M2R/gSlANi8csCp6T0PrbRQFDk1XBPbmxi8o7vR6dVhC9aosyr+y3c
 KiG1fPbj4wzHLuO7Xglt/jO50TunIz13nzHriecgeQFsigqZqjSTlmIbkU+8l66r8uTHx0K91+MCTL
 J48+OqH/XB563y97UOme6HOTAUUmMwRtCYOqf0jbCmtpZnxrPbtrsd70Ev+4jPonshyDETmIj3WHQc
 Fdzv9U8ri0ccO2FT/VlGsjOw4lOmS0
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
 arch/arm64/include/asm/kvm_emulate.h       | 16 ++++++++++++++
 arch/arm64/include/asm/kvm_host.h          |  2 ++
 arch/arm64/kvm/arm.c                       |  1 +
 arch/arm64/kvm/hyp/include/hyp/switch.h    | 35 ++++++++++++++++--------------
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |  9 ++++++++
 5 files changed, 47 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index b31b32ecbe2d..9f88bcfdff70 100644
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
+	__vcpu_sys_reg(vcpu, HFGRTR_EL2) = 0;
+	__vcpu_sys_reg(vcpu, HFGWTR_EL2) = 0;
+}
+
 static inline void vcpu_clear_wfx_traps(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.hcr_el2 &= ~HCR_TWE;
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index bcd774d74f34..d81831e36443 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -365,6 +365,8 @@ enum vcpu_sysreg {
 	TPIDR_EL2,	/* EL2 Software Thread ID Register */
 	CNTHCTL_EL2,	/* Counter-timer Hypervisor Control register */
 	SP_EL2,		/* EL2 Stack Pointer */
+	HFGRTR_EL2,	/* Fine Grained Read Traps */
+	HFGWTR_EL2,	/* Fine Grained Write Traps */
 
 	NR_SYS_REGS	/* Nothing after this line! */
 };
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
index 07d37ff88a3f..bf0183a3a82d 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -88,33 +88,36 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
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
+		write_sysreg_s(__vcpu_sys_reg(vcpu, HFGRTR_EL2),
+			       SYS_HFGRTR_EL2);
+
+		write_sysreg_s(__vcpu_sys_reg(vcpu, HFGWTR_EL2),
+			       SYS_HFGWTR_EL2);
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
+		write_sysreg_s(__vcpu_sys_reg(vcpu, HFGRTR_EL2),
+			       SYS_HFGRTR_EL2);
+		write_sysreg_s(__vcpu_sys_reg(vcpu, HFGWTR_EL2),
+			       SYS_HFGWTR_EL2);
 	}
 }
 
diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index 699ea1f8d409..7e67a3e27749 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -19,6 +19,15 @@
 static inline void __sysreg_save_common_state(struct kvm_cpu_context *ctxt)
 {
 	ctxt_sys_reg(ctxt, MDSCR_EL1)	= read_sysreg(mdscr_el1);
+
+	/*
+	 * These are restored as part of trap disablement rather than
+	 * in __sysreg_restore_common_state().
+	 */
+	if (cpus_have_final_cap(ARM64_HAS_FGT)) {
+		ctxt_sys_reg(ctxt, HFGRTR_EL2) = read_sysreg_s(SYS_HFGRTR_EL2);
+		ctxt_sys_reg(ctxt, HFGWTR_EL2) = read_sysreg_s(SYS_HFGWTR_EL2);
+	}
 }
 
 static inline void __sysreg_save_user_state(struct kvm_cpu_context *ctxt)

-- 
2.30.2


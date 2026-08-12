Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4C23659EE;
	Wed, 12 Aug 2026 19:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786562006; cv=none; b=rUz67lBLnasT3WLsRVMbH1LzHgxVVvulNAfktrGpindssWMjflVeYo/jwBfeVRRJ3NrZRqeZbT1bLUP2BCLeBCWTfcsC2tQpjBpv34f/PMFlpa28AxHZmvTHPt13N1Nc2VNS6C9h5FmXoToZ68nXK5wS5ESpmX+BcqBYkPKWxJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786562006; c=relaxed/simple;
	bh=vOo4fIlGrqCibYd1MPCdhgCnu5drv0t2jmWbDLDJezc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=oMZpuzo9dpzRfZ+uZopqP9OmDx2B09hRqO4V4QF/FEylQhJXjtRjbcidIL/p6Jk7TWLgd34fiipRoqWkiS6vt6zuX0gW43wx1nMjHXJZo5QiGA+d69Myx9bX7WajbXT35v3S433UWT2PZlA9eDE8+YQp70hdcm2N893TrufO6fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P4ZZPkx4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P4ZZPkx4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0DA11F00A3A;
	Wed, 12 Aug 2026 19:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786562004;
	bh=3WCLDfc1FqK8yRgxFOjYyfnRNgWET/BMMgmbWFgfGJQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=P4ZZPkx42sg3Wn4cjNS7RSyEOPILYDRz1ZfCMKnpPNfu1BAAVjrImh1el2yw8JzKP
	 7H9Bsi5Rcgy/oOHOL68E8ydFzQ6P3CVRUv545HHLeA8SfyRCd0/78c5wWYfa5YIpsx
	 7mFXhAi6ICqksydwC2FBFHSQ0Ysv6eCgHdejE6efbpFNeTbvLpBHIrqvsuhyxG+BUl
	 i2o7/zrYXkAV3pPKB3pUscu+naGytbCGSVCARCTFcuBtuR9WlswnWinF5ahjc7R/ZQ
	 yVArj6It1INuXtqSSB/AIaAO17sot0wFgMBOkon5lnLMPwTbm0saohUYwZckggXvQq
	 q7eAFchoAKKeQ==
From: Mark Brown <broonie@kernel.org>
Date: Wed, 12 Aug 2026 20:12:02 +0100
Subject: [PATCH v19 03/14] KVM: arm64: Manage GCS access and registers for
 guests
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260812-arm64-gcs-v19-3-9105afd828ac@kernel.org>
References: <20260812-arm64-gcs-v19-0-9105afd828ac@kernel.org>
In-Reply-To: <20260812-arm64-gcs-v19-0-9105afd828ac@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Shuah Khan <shuah@kernel.org>, Fuad Tabba <tabba@google.com>, 
 Oliver Upton <oupton@kernel.org>
Cc: Peter Maydell <peter.maydell@linaro.org>, 
 Yao Yuan <yaoyuan@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, 
 linux-doc@vger.kernel.org, kvmarm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=12861; i=broonie@kernel.org;
 h=from:subject:message-id; bh=vOo4fIlGrqCibYd1MPCdhgCnu5drv0t2jmWbDLDJezc=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqfMW8NLOHl7TpxvCvMhS+khoX2lkKrCAwy0Vyp
 sfSsQNoJYiJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCanzFvAAKCRAk1otyXVSH
 0Hd6B/9KCYgwK2qHW4/cGpwXcZ8IGYVTYtiOZD+7brnSZOiD3mdZ8k8Gnae5pb9LJ/3AgSznJUZ
 BnDWp7ksCwI6AkOHi3zVF40aDi9ljPV73Ui/SvJ3IGB43hzFNC/+0uYEZURGjKNXxBmt9TZdPeU
 xJjFbDUspORGHkV3mmwuDNGxlWBD1rs7uVpZ+LFpYCKWxXJXpAm0+W3JH4o74M7bl9ZOH4nol5V
 HUsoB2Ew1vAdLBw4TbPtWMIHySEprylwn89kGN52miSQJD4kDpYSmErCKOLrgafX0HQ3y3Yxd/J
 sUpE/ui9q7uysb7lmgTTsD9IF5CMt5l7TGY9Z7VHGx7auK/e
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

GCS introduces a number of system registers, on systems with GCS we need
to context switch them and expose them to VMMs to allow guests to use
GCS.

In order to allow guests to use GCS we also need to configure
HCRX_EL2.GCSEn, if this is not set GCS instructions will be noops and
CHKFEAT will report GCS as disabled.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h       |  3 +++
 arch/arm64/include/asm/kvm_host.h          | 14 ++++++++++
 arch/arm64/include/asm/vncr_mapping.h      |  2 ++
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 31 ++++++++++++++++++++++
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c         | 10 +++++++
 arch/arm64/kvm/sys_regs.c                  | 42 ++++++++++++++++++++++++++++++
 6 files changed, 102 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 5bf3d7e1d92c..ee774c3b8dcd 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -686,6 +686,9 @@ static inline void vcpu_set_hcrx(struct kvm_vcpu *vcpu)
 
 		if (kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64_V))
 			vcpu->arch.hcrx_el2 |= HCRX_EL2_EnASR;
+
+		if (kvm_has_gcs(kvm))
+			vcpu->arch.hcrx_el2 |= HCRX_EL2_GCSEn;
 	}
 }
 #endif /* __ARM64_KVM_EMULATE_H__ */
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index bae2c4f92ef5..1f0da8988961 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -497,6 +497,10 @@ enum vcpu_sysreg {
 
 	POR_EL0,	/* Permission Overlay Register 0 (EL0) */
 
+	/* Guarded Control Stack registers */
+	GCSCRE0_EL1,	/* Guarded Control Stack Control (EL0) */
+	GCSPR_EL0,	/* Guarded Control Stack Pointer (EL0) */
+
 	/* FP/SIMD/SVE */
 	SVCR,
 	FPMR,
@@ -517,6 +521,8 @@ enum vcpu_sysreg {
 	PIRE0_EL2,	/* Permission Indirection Register 0 (EL2) */
 	PIR_EL2,	/* Permission Indirection Register 1 (EL2) */
 	POR_EL2,	/* Permission Overlay Register 2 (EL2) */
+	GCSCR_EL2,	/* Guarded Control Stack Control Register (EL2) */
+	GCSPR_EL2,	/* Guarded Control Stack Pointer Register (EL2) */
 	SPSR_EL2,	/* EL2 saved program status register */
 	ELR_EL2,	/* EL2 exception link register */
 	AFSR0_EL2,	/* Auxiliary Fault Status Register 0 (EL2) */
@@ -588,6 +594,10 @@ enum vcpu_sysreg {
 	VNCR(VDISR_EL2),
 	VNCR(VSESR_EL2),
 
+	/* Guarded Control Stack registers */
+	VNCR(GCSPR_EL1),	/* Guarded Control Stack Pointer (EL1) */
+	VNCR(GCSCR_EL1),	/* Guarded Control Stack Control (EL1) */
+
 	VNCR(HFGRTR_EL2),
 	VNCR(HFGWTR_EL2),
 	VNCR(HFGITR_EL2),
@@ -1648,6 +1658,10 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
 #define kvm_has_sctlr2(k)				\
 	(kvm_has_feat((k), ID_AA64MMFR3_EL1, SCTLRX, IMP))
 
+#define kvm_has_gcs(k)					\
+	(system_supports_gcs() &&			\
+	 kvm_has_feat((k), ID_AA64PFR1_EL1, GCS, IMP))
+
 static inline bool kvm_arch_has_irq_bypass(void)
 {
 	return true;
diff --git a/arch/arm64/include/asm/vncr_mapping.h b/arch/arm64/include/asm/vncr_mapping.h
index 14366d35ce82..b260008c5e3e 100644
--- a/arch/arm64/include/asm/vncr_mapping.h
+++ b/arch/arm64/include/asm/vncr_mapping.h
@@ -97,6 +97,8 @@
 #define VNCR_PMSNEVFR_EL1       0x850
 #define VNCR_PMSDSFR_EL1        0x858
 #define VNCR_TRFCR_EL1          0x880
+#define VNCR_GCSPR_EL1		0x8C0
+#define VNCR_GCSCR_EL1		0x8D0
 #define VNCR_MPAM1_EL1          0x900
 #define VNCR_MPAMHCR_EL2        0x930
 #define VNCR_MPAMVPMV_EL2       0x938
diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index a17cbe7582de..053d7b3c5104 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -17,6 +17,7 @@
 #include <asm/kvm_mmu.h>
 
 static inline bool ctxt_has_s1poe(struct kvm_cpu_context *ctxt);
+static inline bool ctxt_has_gcs(struct kvm_cpu_context *ctxt);
 
 static inline struct kvm_vcpu *ctxt_to_vcpu(struct kvm_cpu_context *ctxt)
 {
@@ -67,6 +68,11 @@ static inline void __sysreg_save_user_state(struct kvm_cpu_context *ctxt)
 {
 	ctxt_sys_reg(ctxt, TPIDR_EL0)	= read_sysreg(tpidr_el0);
 	ctxt_sys_reg(ctxt, TPIDRRO_EL0)	= read_sysreg(tpidrro_el0);
+
+	if (ctxt_has_gcs(ctxt)) {
+		ctxt_sys_reg(ctxt, GCSPR_EL0) = read_sysreg_s(SYS_GCSPR_EL0);
+		ctxt_sys_reg(ctxt, GCSCRE0_EL1)	= read_sysreg_s(SYS_GCSCRE0_EL1);
+	}
 }
 
 static inline bool ctxt_has_mte(struct kvm_cpu_context *ctxt)
@@ -131,6 +137,17 @@ static inline bool ctxt_has_sctlr2(struct kvm_cpu_context *ctxt)
 	return kvm_has_sctlr2(kern_hyp_va(vcpu->kvm));
 }
 
+static inline bool ctxt_has_gcs(struct kvm_cpu_context *ctxt)
+{
+	struct kvm_vcpu *vcpu;
+
+	if (!cpus_have_final_cap(ARM64_HAS_GCS))
+		return false;
+
+	vcpu = ctxt_to_vcpu(ctxt);
+	return kvm_has_feat(kern_hyp_va(vcpu->kvm), ID_AA64PFR1_EL1, GCS, IMP);
+}
+
 static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 {
 	ctxt_sys_reg(ctxt, SCTLR_EL1)	= read_sysreg_el1(SYS_SCTLR);
@@ -144,6 +161,10 @@ static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 		if (ctxt_has_s1pie(ctxt)) {
 			ctxt_sys_reg(ctxt, PIR_EL1)	= read_sysreg_el1(SYS_PIR);
 			ctxt_sys_reg(ctxt, PIRE0_EL1)	= read_sysreg_el1(SYS_PIRE0);
+			if (ctxt_has_gcs(ctxt)) {
+				ctxt_sys_reg(ctxt, GCSPR_EL1)	= read_sysreg_el1(SYS_GCSPR);
+				ctxt_sys_reg(ctxt, GCSCR_EL1)	= read_sysreg_el1(SYS_GCSCR);
+			}
 		}
 
 		if (ctxt_has_s1poe(ctxt))
@@ -206,6 +227,11 @@ static inline void __sysreg_restore_user_state(struct kvm_cpu_context *ctxt)
 {
 	write_sysreg(ctxt_sys_reg(ctxt, TPIDR_EL0),	tpidr_el0);
 	write_sysreg(ctxt_sys_reg(ctxt, TPIDRRO_EL0),	tpidrro_el0);
+	if (ctxt_has_gcs(ctxt)) {
+		write_sysreg_s(ctxt_sys_reg(ctxt, GCSPR_EL0), SYS_GCSPR_EL0);
+		write_sysreg_s(ctxt_sys_reg(ctxt, GCSCRE0_EL1),
+			       SYS_GCSCRE0_EL1);
+	}
 }
 
 static inline void __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt,
@@ -239,6 +265,11 @@ static inline void __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt,
 		if (ctxt_has_s1pie(ctxt)) {
 			write_sysreg_el1(ctxt_sys_reg(ctxt, PIR_EL1),	SYS_PIR);
 			write_sysreg_el1(ctxt_sys_reg(ctxt, PIRE0_EL1),	SYS_PIRE0);
+
+			if (ctxt_has_gcs(ctxt)) {
+				write_sysreg_el1(ctxt_sys_reg(ctxt, GCSPR_EL1),	SYS_GCSPR);
+				write_sysreg_el1(ctxt_sys_reg(ctxt, GCSCR_EL1),	SYS_GCSCR);
+			}
 		}
 
 		if (ctxt_has_s1poe(ctxt))
diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
index be685b63e8cf..4f775545c71b 100644
--- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
@@ -61,6 +61,9 @@ static void __sysreg_save_vel2_state(struct kvm_vcpu *vcpu)
 
 			if (ctxt_has_s1poe(&vcpu->arch.ctxt))
 				__vcpu_assign_sys_reg(vcpu, POR_EL2, read_sysreg_el1(SYS_POR));
+
+			if (ctxt_has_gcs(&vcpu->arch.ctxt))
+				__vcpu_assign_sys_reg(vcpu, GCSCR_EL2, read_sysreg_el1(SYS_GCSCR));
 		}
 
 		/*
@@ -77,6 +80,8 @@ static void __sysreg_save_vel2_state(struct kvm_vcpu *vcpu)
 	__vcpu_assign_sys_reg(vcpu, SP_EL2,	 read_sysreg(sp_el1));
 	__vcpu_assign_sys_reg(vcpu, ELR_EL2,	 read_sysreg_el1(SYS_ELR));
 	__vcpu_assign_sys_reg(vcpu, SPSR_EL2,	 read_sysreg_el1(SYS_SPSR));
+	if (ctxt_has_gcs(&vcpu->arch.ctxt))
+		__vcpu_assign_sys_reg(vcpu, GCSPR_EL2, read_sysreg_el1(SYS_GCSPR));
 
 	if (ctxt_has_sctlr2(&vcpu->arch.ctxt))
 		__vcpu_assign_sys_reg(vcpu, SCTLR2_EL2, read_sysreg_el1(SYS_SCTLR2));
@@ -129,6 +134,11 @@ static void __sysreg_restore_vel2_state(struct kvm_vcpu *vcpu)
 		if (ctxt_has_s1pie(&vcpu->arch.ctxt)) {
 			write_sysreg_el1(__vcpu_sys_reg(vcpu, PIR_EL2), SYS_PIR);
 			write_sysreg_el1(__vcpu_sys_reg(vcpu, PIRE0_EL2), SYS_PIRE0);
+
+			if (ctxt_has_gcs(&vcpu->arch.ctxt)) {
+				write_sysreg_el1(__vcpu_sys_reg(vcpu, GCSCR_EL2), SYS_GCSCR);
+				write_sysreg_el1(__vcpu_sys_reg(vcpu, GCSPR_EL2), SYS_GCSPR);
+			}
 		}
 
 		if (ctxt_has_s1poe(&vcpu->arch.ctxt))
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 5d5c579d4579..6aa4463c3d3a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -109,6 +109,8 @@ static enum sr_loc_attr locate_direct_register(const struct kvm_vcpu *vcpu,
 	case PIR_EL1:
 	case PIRE0_EL1:
 	case POR_EL1:
+	case GCSCR_EL1:
+	case GCSPR_EL1:
 	case ESR_EL1:
 	case AFSR0_EL1:
 	case AFSR1_EL1:
@@ -135,6 +137,8 @@ static enum sr_loc_attr locate_direct_register(const struct kvm_vcpu *vcpu,
 	case DACR32_EL2:
 	case IFSR32_EL2:
 	case DBGVCR32_EL2:
+	case GCSCRE0_EL1:
+	case GCSPR_EL0:
 		/* These registers are always loaded, no matter what */
 		return SR_LOC_LOADED;
 
@@ -200,6 +204,8 @@ static void locate_register(const struct kvm_vcpu *vcpu, enum vcpu_sysreg reg,
 		MAPPED_EL2_SYSREG(PIR_EL2,     PIR_EL1,     NULL	     );
 		MAPPED_EL2_SYSREG(PIRE0_EL2,   PIRE0_EL1,   NULL	     );
 		MAPPED_EL2_SYSREG(POR_EL2,     POR_EL1,     NULL	     );
+		MAPPED_EL2_SYSREG(GCSCR_EL2,   GCSCR_EL1,   NULL             );
+		MAPPED_EL2_SYSREG(GCSPR_EL2,   GCSPR_EL1,   NULL             );
 		MAPPED_EL2_SYSREG(AMAIR_EL2,   AMAIR_EL1,   NULL	     );
 		MAPPED_EL2_SYSREG(ELR_EL2,     ELR_EL1,	    NULL	     );
 		MAPPED_EL2_SYSREG(SPSR_EL2,    SPSR_EL1,    NULL	     );
@@ -228,6 +234,10 @@ static u64 read_sr_from_cpu(enum vcpu_sysreg reg)
 	case TCR2_EL1:		val = read_sysreg_s(SYS_TCR2_EL12);	break;
 	case PIR_EL1:		val = read_sysreg_s(SYS_PIR_EL12);	break;
 	case PIRE0_EL1:		val = read_sysreg_s(SYS_PIRE0_EL12);	break;
+	case GCSPR_EL0:		val = read_sysreg_s(SYS_GCSPR_EL0);	break;
+	case GCSCRE0_EL1:	val = read_sysreg_s(SYS_GCSCRE0_EL1);	break;
+	case GCSCR_EL1:		val = read_sysreg_s(SYS_GCSCR_EL12);	break;
+	case GCSPR_EL1:		val = read_sysreg_s(SYS_GCSPR_EL12);	break;
 	case POR_EL1:		val = read_sysreg_s(SYS_POR_EL12);	break;
 	case ESR_EL1:		val = read_sysreg_s(SYS_ESR_EL12);	break;
 	case AFSR0_EL1:		val = read_sysreg_s(SYS_AFSR0_EL12);	break;
@@ -267,6 +277,10 @@ static void write_sr_to_cpu(enum vcpu_sysreg reg, u64 val)
 	case PIR_EL1:		write_sysreg_s(val, SYS_PIR_EL12);	break;
 	case PIRE0_EL1:		write_sysreg_s(val, SYS_PIRE0_EL12);	break;
 	case POR_EL1:		write_sysreg_s(val, SYS_POR_EL12);	break;
+	case GCSCRE0_EL1:	write_sysreg_s(val, SYS_GCSCRE0_EL1);	break;
+	case GCSPR_EL0:		write_sysreg_s(val, SYS_GCSPR_EL0);	break;
+	case GCSCR_EL1:		write_sysreg_s(val, SYS_GCSCR_EL12);	break;
+	case GCSPR_EL1:		write_sysreg_s(val, SYS_GCSPR_EL12);	break;
 	case ESR_EL1:		write_sysreg_s(val, SYS_ESR_EL12);	break;
 	case AFSR0_EL1:		write_sysreg_s(val, SYS_AFSR0_EL12);	break;
 	case AFSR1_EL1:		write_sysreg_s(val, SYS_AFSR1_EL12);	break;
@@ -2995,6 +3009,21 @@ static unsigned int cnthv_visibility(const struct kvm_vcpu *vcpu,
 	return REG_HIDDEN;
 }
 
+static unsigned int gcs_visibility(const struct kvm_vcpu *vcpu,
+				   const struct sys_reg_desc *r)
+{
+	if (kvm_has_gcs(vcpu->kvm))
+		return 0;
+
+	return REG_HIDDEN;
+}
+
+static unsigned int gcs_el2_visibility(const struct kvm_vcpu *vcpu,
+				       const struct sys_reg_desc *rd)
+{
+	return __el2_visibility(vcpu, rd, gcs_visibility);
+}
+
 static bool access_mdcr(struct kvm_vcpu *vcpu,
 			struct sys_reg_params *p,
 			const struct sys_reg_desc *r)
@@ -3399,6 +3428,13 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	PTRAUTH_KEY(APDB),
 	PTRAUTH_KEY(APGA),
 
+	{ SYS_DESC(SYS_GCSCR_EL1), NULL, reset_val, GCSCR_EL1, 0,
+	  .visibility = gcs_visibility },
+	{ SYS_DESC(SYS_GCSPR_EL1), NULL, reset_unknown, GCSPR_EL1,
+	  .visibility = gcs_visibility },
+	{ SYS_DESC(SYS_GCSCRE0_EL1), NULL, reset_val, GCSCRE0_EL1, 0,
+	  .visibility = gcs_visibility },
+
 	{ SYS_DESC(SYS_SPSR_EL1), access_spsr},
 	{ SYS_DESC(SYS_ELR_EL1), access_elr},
 
@@ -3523,6 +3559,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 		    CTR_EL0_DminLine_MASK |
 		    CTR_EL0_L1Ip_MASK |
 		    CTR_EL0_IminLine_MASK),
+	{ SYS_DESC(SYS_GCSPR_EL0), NULL, reset_unknown, GCSPR_EL0,
+	  .visibility = gcs_visibility },
 	{ SYS_DESC(SYS_SVCR), undef_access, reset_val, SVCR, 0, .visibility = sme_visibility  },
 	{ SYS_DESC(SYS_FPMR), undef_access, reset_val, FPMR, 0, .visibility = fp8_visibility },
 
@@ -3764,6 +3802,10 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG_FILTERED(VNCR_EL2, bad_vncr_trap, reset_val, 0,
 			 vncr_el2_visibility),
 
+	EL2_REG_FILTERED(GCSCR_EL2, access_rw, reset_val, 0,
+			 gcs_el2_visibility),
+	EL2_REG_FILTERED(GCSPR_EL2, access_rw, reset_val, 0,
+			 gcs_el2_visibility),
 	{ SYS_DESC(SYS_DACR32_EL2), undef_access, reset_unknown, DACR32_EL2 },
 	EL2_REG_VNCR_FILT(HDFGRTR2_EL2, fgt2_visibility),
 	EL2_REG_VNCR_FILT(HDFGWTR2_EL2, fgt2_visibility),

-- 
2.47.3


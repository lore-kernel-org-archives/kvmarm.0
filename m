Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02F94229D9;
	Fri, 31 Jul 2026 12:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785501462; cv=none; b=hFHbJJeC3nPfGrLjxeexYcsuhL4YCjcaitsvomoc3u+pbN+PaIpVkP8WviKxHhIVs6s1TqcC+oklhKg7RI/8wM8PQlJppLHDnlf0v5pXDeUc1hAZoOcRZE39WRGykhCPMJO/19+2NLV4pNhglkkg8cvuRrdim+v0BI73BcJxwnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785501462; c=relaxed/simple;
	bh=7zdoDiSZtIPBRkLTnbLmk+cpfZHSDAyoiUh04SoLCEc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=lUNM6Hbwut7lR72znpWNzCFo7gT6zQJzA/CLMabDULv1cJ0rVDX/RhYZ1Wmu5NBkb+2r19AynrZw6bNbujRYjeCFvlftoIy/nPiD8Fnn5ineJOG5JbM+sX8FIj97CQF/9irjVlPHCSe11yEPu8a/SpAp3JZv0EYdmCg4/jKxlUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Twt4SM7C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Twt4SM7C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AE451F00A3D;
	Fri, 31 Jul 2026 12:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785501460;
	bh=Sq/32CJwoC+3LKwwZ2Hdzt+GTnbqDqOpNKVsROwEFp0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Twt4SM7CyntbQ3jL8ze9xQAlsa5Sb2QMwYdWqop9wkgp4O7I79EsiisF0YU54pQ3i
	 2GwVVv5YZTZ9K0T1TrSnu2o7bpyMcTcW1hb1IdqkCJqmihoatY7koEz92sxhSac8Ef
	 NbYTheGsPtI7IkOe6wgZnMoQ4Quht7VPl1/S9Rm0vYx66Nrt4upXLeZIvXhuBc+NzK
	 lsLhGvQxOglEUxRyMKvqwltbrVBdWBn6eVBO4e1UMKktmh+Y1F1uSIGpCXS2iDNd5J
	 DaGycMB7NRrolU7W2meRJJsHjqNFOIJ0OHw0yBD9T+I4ONndjMvwtkbLZ4tDySfL9l
	 lMK72CCHxaqBA==
From: Mark Brown <broonie@kernel.org>
Date: Fri, 31 Jul 2026 13:25:41 +0100
Subject: [PATCH v17 03/14] KVM: arm64: Manage GCS access and registers for
 guests
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260731-arm64-gcs-v17-3-5e39ca01b14e@kernel.org>
References: <20260731-arm64-gcs-v17-0-5e39ca01b14e@kernel.org>
In-Reply-To: <20260731-arm64-gcs-v17-0-5e39ca01b14e@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Shuah Khan <shuah@kernel.org>, Fuad Tabba <tabba@google.com>, 
 Oliver Upton <oupton@kernel.org>
Cc: Peter Maydell <peter.maydell@linaro.org>, 
 linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
 kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=12268; i=broonie@kernel.org;
 h=from:subject:message-id; bh=7zdoDiSZtIPBRkLTnbLmk+cpfZHSDAyoiUh04SoLCEc=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqbJb+Zc7B+KhMsHWt/s4PLQKmKVGpVD7wKkVAp
 7qTut3pGJqJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCamyW/gAKCRAk1otyXVSH
 0FOjB/476OmpBN3Ysgy5geU0qUJyxYSlTH1NRBx4Ihk39zI7E4rRwDEMVKNNJ0JXRYxFG3yf1kZ
 1pPnb2C2lI6wI/SsB6yAbha3A1aWhywIC1WoorEVqEhFlCqj0KOSEEg3yWWNikT7Q/kZIZGSEtX
 AY5fd+jfEvCUYd8dHkfXdNrXYxNc8XbYYSB1/budTz0OHA/eXHQLNFmHqli6hwZR0SJEwl9nrIH
 OF3rDWeOSItOR2ChXma92203fW4kfXBoSCLTYhtklepoWdB24532nQf2h+kgh6ILY8P3MrNbOlS
 Zrk2zsYn76vlXB/T5oiBgp80oSnMD1UP4ccMNANlrL9SUpvO
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
 arch/arm64/include/asm/kvm_host.h          | 14 ++++++++++++
 arch/arm64/include/asm/vncr_mapping.h      |  2 ++
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 31 +++++++++++++++++++++++++
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c         | 10 +++++++++
 arch/arm64/kvm/sys_regs.c                  | 36 ++++++++++++++++++++++++++++++
 6 files changed, 96 insertions(+)

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
index be685b63e8cf..2431c18f5792 100644
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
@@ -133,6 +138,11 @@ static void __sysreg_restore_vel2_state(struct kvm_vcpu *vcpu)
 
 		if (ctxt_has_s1poe(&vcpu->arch.ctxt))
 			write_sysreg_el1(__vcpu_sys_reg(vcpu, POR_EL2), SYS_POR);
+
+		if (ctxt_has_gcs(&vcpu->arch.ctxt)) {
+			write_sysreg_el1(__vcpu_sys_reg(vcpu, GCSCR_EL2), SYS_GCSCR);
+			write_sysreg_el1(__vcpu_sys_reg(vcpu, GCSPR_EL2), SYS_GCSPR);
+		}
 	}
 
 	write_sysreg_el1(__vcpu_sys_reg(vcpu, ESR_EL2),		SYS_ESR);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 5d5c579d4579..1a1e45d64552 100644
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
@@ -200,6 +202,8 @@ static void locate_register(const struct kvm_vcpu *vcpu, enum vcpu_sysreg reg,
 		MAPPED_EL2_SYSREG(PIR_EL2,     PIR_EL1,     NULL	     );
 		MAPPED_EL2_SYSREG(PIRE0_EL2,   PIRE0_EL1,   NULL	     );
 		MAPPED_EL2_SYSREG(POR_EL2,     POR_EL1,     NULL	     );
+		MAPPED_EL2_SYSREG(GCSCR_EL2,   GCSCR_EL1,   NULL             );
+		MAPPED_EL2_SYSREG(GCSPR_EL2,   GCSPR_EL1,   NULL             );
 		MAPPED_EL2_SYSREG(AMAIR_EL2,   AMAIR_EL1,   NULL	     );
 		MAPPED_EL2_SYSREG(ELR_EL2,     ELR_EL1,	    NULL	     );
 		MAPPED_EL2_SYSREG(SPSR_EL2,    SPSR_EL1,    NULL	     );
@@ -228,6 +232,8 @@ static u64 read_sr_from_cpu(enum vcpu_sysreg reg)
 	case TCR2_EL1:		val = read_sysreg_s(SYS_TCR2_EL12);	break;
 	case PIR_EL1:		val = read_sysreg_s(SYS_PIR_EL12);	break;
 	case PIRE0_EL1:		val = read_sysreg_s(SYS_PIRE0_EL12);	break;
+	case GCSCR_EL1:		val = read_sysreg_s(SYS_GCSCR_EL12);	break;
+	case GCSPR_EL1:		val = read_sysreg_s(SYS_GCSPR_EL12);	break;
 	case POR_EL1:		val = read_sysreg_s(SYS_POR_EL12);	break;
 	case ESR_EL1:		val = read_sysreg_s(SYS_ESR_EL12);	break;
 	case AFSR0_EL1:		val = read_sysreg_s(SYS_AFSR0_EL12);	break;
@@ -267,6 +273,8 @@ static void write_sr_to_cpu(enum vcpu_sysreg reg, u64 val)
 	case PIR_EL1:		write_sysreg_s(val, SYS_PIR_EL12);	break;
 	case PIRE0_EL1:		write_sysreg_s(val, SYS_PIRE0_EL12);	break;
 	case POR_EL1:		write_sysreg_s(val, SYS_POR_EL12);	break;
+	case GCSCR_EL1:		write_sysreg_s(val, SYS_GCSCR_EL12);	break;
+	case GCSPR_EL1:		write_sysreg_s(val, SYS_GCSPR_EL12);	break;
 	case ESR_EL1:		write_sysreg_s(val, SYS_ESR_EL12);	break;
 	case AFSR0_EL1:		write_sysreg_s(val, SYS_AFSR0_EL12);	break;
 	case AFSR1_EL1:		write_sysreg_s(val, SYS_AFSR1_EL12);	break;
@@ -2995,6 +3003,21 @@ static unsigned int cnthv_visibility(const struct kvm_vcpu *vcpu,
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
@@ -3399,6 +3422,13 @@ static const struct sys_reg_desc sys_reg_descs[] = {
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
 
@@ -3523,6 +3553,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 		    CTR_EL0_DminLine_MASK |
 		    CTR_EL0_L1Ip_MASK |
 		    CTR_EL0_IminLine_MASK),
+	{ SYS_DESC(SYS_GCSPR_EL0), NULL, reset_unknown, GCSPR_EL0,
+	  .visibility = gcs_visibility },
 	{ SYS_DESC(SYS_SVCR), undef_access, reset_val, SVCR, 0, .visibility = sme_visibility  },
 	{ SYS_DESC(SYS_FPMR), undef_access, reset_val, FPMR, 0, .visibility = fp8_visibility },
 
@@ -3764,6 +3796,10 @@ static const struct sys_reg_desc sys_reg_descs[] = {
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


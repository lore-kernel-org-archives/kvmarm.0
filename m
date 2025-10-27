Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B451C861D
	for <kvmarm@lists.linux.dev>; Mon, 27 Oct 2025 11:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761565189; cv=none; b=rH6ptpJuFSS/8D0nrHZawBY4Tbbctd+FU4B9ehsAXW7uWaHtAx+/oJ9mrh5lT2TpFkIONF/gBEyZV4G2uCMn1yaKVbzGazc8Po5pqBGaQtHv/UhxtdNgntMA2vI0AUzErjmcckNOWhS1u/pPjjOfcGVGudGuDMa8A14LsyrCoMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761565189; c=relaxed/simple;
	bh=aS44i9lkXXA1RZQZNrCH2TJg/EniiPMlxCwDAZLbsuw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=g4bMXThxDGy3LAUdilKfcC9mJMF2uoIlDJVArQRH3nFp/izJRcSRHB1O6qx3Ku1G6cu5larjEXiGGRBtxE9lQOISzXjAXiyjPFrD3xI7mU4UJ0h6WL+8uXZ5UieOYSO2XnzJxP4tGrAEVUp74YIUv3RbAZcSq9JUYSRChKUMqqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xBerPfPT; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xBerPfPT"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-426ce339084so4754580f8f.0
        for <kvmarm@lists.linux.dev>; Mon, 27 Oct 2025 04:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761565186; x=1762169986; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3nI15Jf/iGoG7V37uw3udiwZ7q1e+O6ke1i5+sgVrWY=;
        b=xBerPfPTwwzbJSBW/UnmhDN+By39xkuc+y4rVFBWVsqiv4Z9Sro8BvLCS6x6uyoLXS
         vmkxP3i3iTidBGchPH7K/YkE9eP9IdtjptWFojxXwReIS4+VE41ODpOa6r7aDl//Ib7V
         c73Z8a7zC8ecZlTuHgBhAL21vf1KntvW/5FY/WoqYfxAt2a+P+oIiJr4353pg/3mkHR7
         RL7vSgKNTdipRl/MW6tGVfVQrB74WqeCXjYZ0aidRmqAy5nboiuf6cM6/er1nQeB1x7c
         RUOMw3p07VRH9hutJaAQ8PLytn7Vt70L/rAUNSBBioOmrgI7wYrFNi0dblUfrpVo2WbE
         eG/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761565186; x=1762169986;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3nI15Jf/iGoG7V37uw3udiwZ7q1e+O6ke1i5+sgVrWY=;
        b=nRtPeYY3EE6Bl4+dwxyKcwTC925wak+xtlTXc00VwUH1+tOdRi2xa9ftrl/JyD7MhM
         dbKor3vHkbUzjrbQ52VFNFGRxTk+6kVC+OZ9qR84nzBPVCvpb0rTavf/QLz6dpK4q8ec
         J1uW+tkhjJOtPfPDdG1hTK4ay8wcM7z6hNglIPeWVTUIv3ychWZvLhcUTjYeZofn6xCp
         KzECu5n5HW5cVl0K5pJtg+LMfJWMUAV3L7Fhmra87PIysQaTDCblWgI4Kqc38JrSqL5m
         5qhv+5ltCplbCPNGESuX/vYQn4gcMq+ortuEVu22k5kKGmshThFp1/6OzS0kfbJWfPQz
         zrhw==
X-Gm-Message-State: AOJu0Yzojuy8HEO49Xb95CTqXSy4vb9/i3HRIVGPqLKk7fCsW0gcwwfs
	9cD54sOtEzhiEWhu01xqZfo810QWXrhvhQbu1b4c2atoeJCUm9mI12FjPZRT7/7l+mbbxrCugRx
	pwnhSSVOeAthXCnzaKnitS9cEDBKwwetRO8mnvixfWJI/GtT81EnkSFJC3n2SUi6JMefXUR1wzR
	rjQZGiwCd1582cdTEli57AR4wNhXvM1WI=
X-Google-Smtp-Source: AGHT+IHxO6GGxk7ktVssETqrBQmOnSpPcwnw933Ny4LpW7ctGRfTjUiWNhnQGC9lxe7gNWizPveWck/8Hw==
X-Received: from wraj10.prod.google.com ([2002:a5d:452a:0:b0:429:1f28:1d86])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:adf:e19b:0:b0:427:53e:ab3e
 with SMTP id ffacd0b85a97d-427053ead3bmr25262913f8f.56.1761565185723; Mon, 27
 Oct 2025 04:39:45 -0700 (PDT)
Date: Mon, 27 Oct 2025 11:39:40 +0000
In-Reply-To: <20251027113943.1282568-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251027113943.1282568-1-tabba@google.com>
X-Mailer: git-send-email 2.51.1.838.g19442a804e-goog
Message-ID: <20251027113943.1282568-2-tabba@google.com>
Subject: [PATCH v1 1/4] KVM: arm64: Switch reg and val parameter ordering in vcpu_write_sys_reg()
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The vcpu_write_sys_reg() function previously used the signature:
void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, enum vcpu_sysreg reg);

This was inconsistent with related functions and macros such as
__vcpu_assign_sys_reg() and __vcpu_rmw_sys_reg(), both of which
have the register parameter before the value.
'(vcpu, reg, ...)' ordering.

This inconsistency has been a direct source of parameter transposition
bugs in related functions. With the 'reg' and 'val' types being simple
integers, it was easy to mistake one for the other.

This patch swaps the `reg` and `val` parameters to create the logical
and consistent signature:
void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, enum vcpu_sysreg reg, u64 val);

All call sites are mechanically updated to match the new signature.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_emulate.h |  2 +-
 arch/arm64/include/asm/kvm_host.h    |  2 +-
 arch/arm64/kvm/at.c                  |  6 +++---
 arch/arm64/kvm/emulate-nested.c      |  4 ++--
 arch/arm64/kvm/hyp/exception.c       | 12 ++++++------
 arch/arm64/kvm/hyp/vhe/switch.c      |  2 +-
 arch/arm64/kvm/inject_fault.c        | 16 ++++++++--------
 arch/arm64/kvm/nested.c              |  4 ++--
 arch/arm64/kvm/sys_regs.c            | 16 ++++++++--------
 9 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index c9eab316398e..f82201b3e1c9 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -532,7 +532,7 @@ static inline void kvm_vcpu_set_be(struct kvm_vcpu *vcpu)
 
 		sctlr = vcpu_read_sys_reg(vcpu, r);
 		sctlr |= SCTLR_ELx_EE;
-		vcpu_write_sys_reg(vcpu, sctlr, r);
+		vcpu_write_sys_reg(vcpu, r, sctlr);
 	}
 }
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 64302c438355..1b8a420f9add 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1167,7 +1167,7 @@ u64 kvm_vcpu_apply_reg_masks(const struct kvm_vcpu *, enum vcpu_sysreg, u64);
 	})
 
 u64 vcpu_read_sys_reg(const struct kvm_vcpu *, enum vcpu_sysreg);
-void vcpu_write_sys_reg(struct kvm_vcpu *, u64, enum vcpu_sysreg);
+void vcpu_write_sys_reg(struct kvm_vcpu *, enum vcpu_sysreg, u64);
 
 struct kvm_vm_stat {
 	struct kvm_vm_stat_generic generic;
diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index be26d5aa668c..1421971349f4 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -1424,7 +1424,7 @@ void __kvm_at_s1e01(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 	    !par_check_s1_access_fault(par))
 		par = handle_at_slow(vcpu, op, vaddr);
 
-	vcpu_write_sys_reg(vcpu, par, PAR_EL1);
+	vcpu_write_sys_reg(vcpu, PAR_EL1, par);
 }
 
 void __kvm_at_s1e2(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
@@ -1479,7 +1479,7 @@ void __kvm_at_s1e2(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 	if ((par & SYS_PAR_EL1_F) && !par_check_s1_perm_fault(par))
 		par = handle_at_slow(vcpu, op, vaddr);
 
-	vcpu_write_sys_reg(vcpu, par, PAR_EL1);
+	vcpu_write_sys_reg(vcpu, PAR_EL1, par);
 }
 
 void __kvm_at_s12(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
@@ -1538,7 +1538,7 @@ void __kvm_at_s12(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 		out.esr = ESR_ELx_FSC_PERM_L(out.level & 0x3);
 
 	par = compute_par_s12(vcpu, par, &out);
-	vcpu_write_sys_reg(vcpu, par, PAR_EL1);
+	vcpu_write_sys_reg(vcpu, PAR_EL1, par);
 }
 
 /*
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 834f13fb1fb7..e30a059b71e6 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2722,7 +2722,7 @@ static void kvm_inject_el2_exception(struct kvm_vcpu *vcpu, u64 esr_el2,
 	switch (type) {
 	case except_type_sync:
 		kvm_pend_exception(vcpu, EXCEPT_AA64_EL2_SYNC);
-		vcpu_write_sys_reg(vcpu, esr_el2, ESR_EL2);
+		vcpu_write_sys_reg(vcpu, ESR_EL2, esr_el2);
 		break;
 	case except_type_irq:
 		kvm_pend_exception(vcpu, EXCEPT_AA64_EL2_IRQ);
@@ -2834,7 +2834,7 @@ int kvm_inject_nested_sea(struct kvm_vcpu *vcpu, bool iabt, u64 addr)
 			     iabt ? ESR_ELx_EC_IABT_LOW : ESR_ELx_EC_DABT_LOW);
 	esr |= ESR_ELx_FSC_EXTABT | ESR_ELx_IL;
 
-	vcpu_write_sys_reg(vcpu, addr, FAR_EL2);
+	vcpu_write_sys_reg(vcpu, FAR_EL2, addr);
 
 	if (__vcpu_sys_reg(vcpu, SCTLR2_EL2) & SCTLR2_EL1_EASE)
 		return kvm_inject_nested(vcpu, esr, except_type_serror);
diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
index bef40ddb16db..a5e5eda7aba0 100644
--- a/arch/arm64/kvm/hyp/exception.c
+++ b/arch/arm64/kvm/hyp/exception.c
@@ -28,10 +28,10 @@ static inline u64 __vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
 	return __vcpu_sys_reg(vcpu, reg);
 }
 
-static inline void __vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
+static inline void __vcpu_write_sys_reg(struct kvm_vcpu *vcpu, int reg, u64 val)
 {
 	if (has_vhe())
-		vcpu_write_sys_reg(vcpu, val, reg);
+		vcpu_write_sys_reg(vcpu, reg, val);
 	else
 		__vcpu_assign_sys_reg(vcpu, reg, val);
 }
@@ -41,9 +41,9 @@ static void __vcpu_write_spsr(struct kvm_vcpu *vcpu, unsigned long target_mode,
 {
 	if (has_vhe()) {
 		if (target_mode == PSR_MODE_EL1h)
-			vcpu_write_sys_reg(vcpu, val, SPSR_EL1);
+			vcpu_write_sys_reg(vcpu, SPSR_EL1, val);
 		else
-			vcpu_write_sys_reg(vcpu, val, SPSR_EL2);
+			vcpu_write_sys_reg(vcpu, SPSR_EL2, val);
 	} else {
 		__vcpu_assign_sys_reg(vcpu, SPSR_EL1, val);
 	}
@@ -103,12 +103,12 @@ static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
 	case PSR_MODE_EL1h:
 		vbar = __vcpu_read_sys_reg(vcpu, VBAR_EL1);
 		sctlr = __vcpu_read_sys_reg(vcpu, SCTLR_EL1);
-		__vcpu_write_sys_reg(vcpu, *vcpu_pc(vcpu), ELR_EL1);
+		__vcpu_write_sys_reg(vcpu, ELR_EL1, *vcpu_pc(vcpu));
 		break;
 	case PSR_MODE_EL2h:
 		vbar = __vcpu_read_sys_reg(vcpu, VBAR_EL2);
 		sctlr = __vcpu_read_sys_reg(vcpu, SCTLR_EL2);
-		__vcpu_write_sys_reg(vcpu, *vcpu_pc(vcpu), ELR_EL2);
+		__vcpu_write_sys_reg(vcpu, ELR_EL2, *vcpu_pc(vcpu));
 		break;
 	default:
 		/* Don't do that */
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 9984c492305a..c6731c83b174 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -449,7 +449,7 @@ static bool kvm_hyp_handle_cpacr_el1(struct kvm_vcpu *vcpu, u64 *exit_code)
 	if ((esr & ESR_ELx_SYS64_ISS_DIR_MASK) == ESR_ELx_SYS64_ISS_DIR_READ) {
 		vcpu_set_reg(vcpu, rt, __vcpu_sys_reg(vcpu, CPTR_EL2));
 	} else {
-		vcpu_write_sys_reg(vcpu, vcpu_get_reg(vcpu, rt), CPTR_EL2);
+		vcpu_write_sys_reg(vcpu, CPTR_EL2, vcpu_get_reg(vcpu, rt));
 		__activate_cptr_traps(vcpu);
 	}
 
diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index dfcd66c65517..17f4b5a9635b 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -158,8 +158,8 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr
 
 	esr |= fsc;
 
-	vcpu_write_sys_reg(vcpu, addr, exception_far_elx(vcpu));
-	vcpu_write_sys_reg(vcpu, esr, exception_esr_elx(vcpu));
+	vcpu_write_sys_reg(vcpu, exception_far_elx(vcpu), addr);
+	vcpu_write_sys_reg(vcpu, exception_esr_elx(vcpu), esr);
 }
 
 static void inject_undef64(struct kvm_vcpu *vcpu)
@@ -175,7 +175,7 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
 	if (kvm_vcpu_trap_il_is32bit(vcpu))
 		esr |= ESR_ELx_IL;
 
-	vcpu_write_sys_reg(vcpu, esr, exception_esr_elx(vcpu));
+	vcpu_write_sys_reg(vcpu, exception_esr_elx(vcpu), esr);
 }
 
 #define DFSR_FSC_EXTABT_LPAE	0x10
@@ -211,15 +211,15 @@ static void inject_abt32(struct kvm_vcpu *vcpu, bool is_pabt, u32 addr)
 		kvm_pend_exception(vcpu, EXCEPT_AA32_IABT);
 		far &= GENMASK(31, 0);
 		far |= (u64)addr << 32;
-		vcpu_write_sys_reg(vcpu, fsr, IFSR32_EL2);
+		vcpu_write_sys_reg(vcpu, IFSR32_EL2, fsr);
 	} else { /* !iabt */
 		kvm_pend_exception(vcpu, EXCEPT_AA32_DABT);
 		far &= GENMASK(63, 32);
 		far |= addr;
-		vcpu_write_sys_reg(vcpu, fsr, ESR_EL1);
+		vcpu_write_sys_reg(vcpu, ESR_EL1, fsr);
 	}
 
-	vcpu_write_sys_reg(vcpu, far, FAR_EL1);
+	vcpu_write_sys_reg(vcpu, FAR_EL1, far);
 }
 
 static void __kvm_inject_sea(struct kvm_vcpu *vcpu, bool iabt, u64 addr)
@@ -275,7 +275,7 @@ void kvm_inject_size_fault(struct kvm_vcpu *vcpu)
 
 	esr = vcpu_read_sys_reg(vcpu, exception_esr_elx(vcpu));
 	esr &= ~GENMASK_ULL(5, 0);
-	vcpu_write_sys_reg(vcpu, esr, exception_esr_elx(vcpu));
+	vcpu_write_sys_reg(vcpu, exception_esr_elx(vcpu), esr);
 }
 
 /**
@@ -352,7 +352,7 @@ int kvm_inject_serror_esr(struct kvm_vcpu *vcpu, u64 esr)
 	if (!serror_is_masked(vcpu)) {
 		pend_serror_exception(vcpu);
 		esr |= FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_SERROR);
-		vcpu_write_sys_reg(vcpu, esr, exception_esr_elx(vcpu));
+		vcpu_write_sys_reg(vcpu, exception_esr_elx(vcpu), esr);
 		return 1;
 	}
 
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index f04cda40545b..277e4971b253 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -804,8 +804,8 @@ int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu, struct kvm_s2_trans *trans)
 
 int kvm_inject_s2_fault(struct kvm_vcpu *vcpu, u64 esr_el2)
 {
-	vcpu_write_sys_reg(vcpu, vcpu->arch.fault.far_el2, FAR_EL2);
-	vcpu_write_sys_reg(vcpu, vcpu->arch.fault.hpfar_el2, HPFAR_EL2);
+	vcpu_write_sys_reg(vcpu, FAR_EL2, vcpu->arch.fault.far_el2);
+	vcpu_write_sys_reg(vcpu, HPFAR_EL2, vcpu->arch.fault.hpfar_el2);
 
 	return kvm_inject_nested_sync(vcpu, esr_el2);
 }
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index e67eb39ddc11..d0d696d0819a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -338,7 +338,7 @@ u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, enum vcpu_sysreg reg)
 	return __vcpu_sys_reg(vcpu, reg);
 }
 
-void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, enum vcpu_sysreg reg)
+void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, enum vcpu_sysreg reg, u64 val)
 {
 	struct sr_loc loc = {};
 
@@ -489,7 +489,7 @@ static bool access_rw(struct kvm_vcpu *vcpu,
 		      const struct sys_reg_desc *r)
 {
 	if (p->is_write)
-		vcpu_write_sys_reg(vcpu, p->regval, r->reg);
+		vcpu_write_sys_reg(vcpu, r->reg, p->regval);
 	else
 		p->regval = vcpu_read_sys_reg(vcpu, r->reg);
 
@@ -572,7 +572,7 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
 	}
 
 	val |= (p->regval & (mask >> shift)) << shift;
-	vcpu_write_sys_reg(vcpu, val, r->reg);
+	vcpu_write_sys_reg(vcpu, r->reg, val);
 
 	kvm_toggle_cache(vcpu, was_enabled);
 	return true;
@@ -866,14 +866,14 @@ static u64 reset_dbg_wb_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd
 static u64 reset_amair_el1(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	u64 amair = read_sysreg(amair_el1);
-	vcpu_write_sys_reg(vcpu, amair, AMAIR_EL1);
+	vcpu_write_sys_reg(vcpu, AMAIR_EL1, amair);
 	return amair;
 }
 
 static u64 reset_actlr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	u64 actlr = read_sysreg(actlr_el1);
-	vcpu_write_sys_reg(vcpu, actlr, ACTLR_EL1);
+	vcpu_write_sys_reg(vcpu, ACTLR_EL1, actlr);
 	return actlr;
 }
 
@@ -892,7 +892,7 @@ static u64 reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	mpidr |= ((vcpu->vcpu_id >> 4) & 0xff) << MPIDR_LEVEL_SHIFT(1);
 	mpidr |= ((vcpu->vcpu_id >> 12) & 0xff) << MPIDR_LEVEL_SHIFT(2);
 	mpidr |= (1ULL << 31);
-	vcpu_write_sys_reg(vcpu, mpidr, MPIDR_EL1);
+	vcpu_write_sys_reg(vcpu, MPIDR_EL1, mpidr);
 
 	return mpidr;
 }
@@ -2465,7 +2465,7 @@ static bool access_csselr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	int reg = r->reg;
 
 	if (p->is_write)
-		vcpu_write_sys_reg(vcpu, p->regval, reg);
+		vcpu_write_sys_reg(vcpu, reg, p->regval);
 	else
 		p->regval = vcpu_read_sys_reg(vcpu, reg);
 	return true;
@@ -2656,7 +2656,7 @@ static bool access_elr(struct kvm_vcpu *vcpu,
 		       const struct sys_reg_desc *r)
 {
 	if (p->is_write)
-		vcpu_write_sys_reg(vcpu, p->regval, ELR_EL1);
+		vcpu_write_sys_reg(vcpu, ELR_EL1, p->regval);
 	else
 		p->regval = vcpu_read_sys_reg(vcpu, ELR_EL1);
 
-- 
2.51.1.838.g19442a804e-goog


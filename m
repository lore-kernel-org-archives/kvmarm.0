Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 758EC32C30D
	for <kvmarm@lists.linux.dev>; Thu, 27 Nov 2025 12:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764246138; cv=none; b=Ps8iNhwRz5B+Nt80Ab7DcbNCcRx3pAguMO2vKivb8gSDROEWFtDXoSv614wJfNjvEbu/VwCC4AbRax6MhL6TnAoU6d2kofiRp33Ed/Y6AX4VlxgMcndet/8lm/M7dJ5Hhb5mmaw5xNK1IUGO/olB0cYDFgI/leUDqfHgpAMB00c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764246138; c=relaxed/simple;
	bh=SJc0jSk+3fXg4Ozyrd2DHNcr4jvj+bu+nAOCBlZUoFw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gJI84dAzAzhtC2amUZ7mv2Bxj/p1B4KEXziQMmWdMzok7gRkK5ukoTm1VsjBKLs+QeCXOlKNDxob1WmtdcWXcV+DU0Z1NpihVbF0NgJ0WoLpLk+KPN+n0qM2KOTLrsPfwj3eiOHFZ/emhe7hFGTvsPU+vx7UGGPOeOSDgv4To0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rzo2Qh2M; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rzo2Qh2M"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-429cce847c4so499560f8f.2
        for <kvmarm@lists.linux.dev>; Thu, 27 Nov 2025 04:22:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764246135; x=1764850935; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NL3nohAUMm3Ry+4eJheW6l7zR4hZI9Xj0bkr+tmysoM=;
        b=rzo2Qh2MmiFrQlkb5JbMvlbDQ7rwXtPtBLeYw0oNAzu/HwJjKRIe3JBlJjfQbonvtE
         RfwuPtkUv8aZBy+lEYOxyOuY6FnczcMUAGL1EU6t6B2GAQitGtIcPYsJ3eJ27XmQigFM
         hse8iT0Ek+bwvHxRH4AzhrX1RAZLXYX1P3E63GITXTVGRIS6oZXn1YfmGVOrbDUjNlQI
         doDWxoIhONk+bDo7dV59f1Lx9HC2p4r3myy3iPIc+/wRaiUS0vg2l4wuOkiykP9KGZR5
         GJJ/TBGkKqGKV2mUb+bRlB6fBKtha3uk+TE282dH1XmvNuGOPVBuOnPP1ggGWskQocfK
         samA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764246135; x=1764850935;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NL3nohAUMm3Ry+4eJheW6l7zR4hZI9Xj0bkr+tmysoM=;
        b=DW0HT1tqga8kvTRip+YWw8i2TarKTQd16o0yJ9MLBeWAlUs4rjRzWw7jWJ4OFN/yXT
         Zf7S1+EJO+kY3Z5cwzKvXTzjyGmZbwji3YMcZc1cnYzTaJbNSr8JNh/Iy2n+SKR4XWR9
         jmF3HsOiPLr2oTt2JMlcyxsTN/3HFAzE/RBDebZ82FXQ4byw8+sVMMnJZoPgK37KA2fC
         XOm4Ae6wEBpwiii5sBapS5wGuOz7pjxEz94DegoE4sYyxVH5K0iX6pmaBHxEEI/DQZoc
         iExzbvOz0T15xldsvUfpAyc8tNL1TowNUZ3y4RE1Lx+mxarIaZprccc9E38yT7YBhbwN
         j5Bg==
X-Gm-Message-State: AOJu0YwJ+hYI4v6USvLqN6PpTtwLW9yR8L81pCeTLvHh3nYNhDiwvXOr
	GphD0g6zP6ynp6ZpOHhoPEnuySVVnUQOeGHs87QsjZMI0N8eLmurTQzTge9wuA9f9PTjWnJFm+h
	sroPKYBVmMhsFIeXdp+/NnntgM+zW7vHaLSGC8wgpXZSSSqsyM5XbMJRn8oHynSrJitb6jH/F9/
	Y2FKB2RSXMqErc5kyeCUcEpG8xYovlCkw=
X-Google-Smtp-Source: AGHT+IHaE1Z60aMUWFE+E56EdAV7D3oDUPE/oBVYsqknsnsuq+E/Bv4NvcbiP0dfbKXnUdKyHt9/uc9ssw==
X-Received: from wmlc9.prod.google.com ([2002:a7b:c849:0:b0:477:76e1:9b4e])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:548b:b0:477:6d96:b3c8
 with SMTP id 5b1f17b1804b1-477c01c4c03mr226021975e9.23.1764246134589; Thu, 27
 Nov 2025 04:22:14 -0800 (PST)
Date: Thu, 27 Nov 2025 12:22:08 +0000
In-Reply-To: <20251127122210.4111702-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251127122210.4111702-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.487.g5c8c507ade-goog
Message-ID: <20251127122210.4111702-4-tabba@google.com>
Subject: [PATCH v1 3/5] KVM: arm64: Refactor enter_exception64()
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

From: Quentin Perret <qperret@google.com>

To simplify the injection of exceptions into the host in pKVM context,
refactor enter_exception64() to split out the logic for calculating the
exception vector offset and the target CPSR.

Extract two new helper functions:
 - get_except64_offset(): Calculates exception vector offset based on
   current/target exception levels and exception type
 - get_except64_cpsr(): Computes the new CPSR/PSTATE when taking an
   exception

A subsequent patch will use these helpers to inject UNDEF exceptions
into the host when MTE system registers are accessed with MTE disabled.
Extracting the helpers allows that code to reuse the exception entry
logic without duplicating the CPSR and vector offset calculations.

No functional change intended.

Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_emulate.h |   5 ++
 arch/arm64/kvm/hyp/exception.c       | 100 ++++++++++++++++-----------
 2 files changed, 63 insertions(+), 42 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index c9eab316398e..c3f04bd5b2a5 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -71,6 +71,11 @@ static inline int kvm_inject_serror(struct kvm_vcpu *vcpu)
 	return kvm_inject_serror_esr(vcpu, ESR_ELx_ISV);
 }
 
+unsigned long get_except64_offset(unsigned long psr, unsigned long target_mode,
+				  enum exception_type type);
+unsigned long get_except64_cpsr(unsigned long old, bool has_mte,
+				unsigned long sctlr, unsigned long mode);
+
 void kvm_vcpu_wfi(struct kvm_vcpu *vcpu);
 
 void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
index bef40ddb16db..d3bcda665612 100644
--- a/arch/arm64/kvm/hyp/exception.c
+++ b/arch/arm64/kvm/hyp/exception.c
@@ -65,12 +65,25 @@ static void __vcpu_write_spsr_und(struct kvm_vcpu *vcpu, u64 val)
 		vcpu->arch.ctxt.spsr_und = val;
 }
 
+unsigned long get_except64_offset(unsigned long psr, unsigned long target_mode,
+				  enum exception_type type)
+{
+	u64 mode = psr & (PSR_MODE_MASK | PSR_MODE32_BIT);
+	u64 exc_offset;
+
+	if      (mode == target_mode)
+		exc_offset = CURRENT_EL_SP_ELx_VECTOR;
+	else if ((mode | PSR_MODE_THREAD_BIT) == target_mode)
+		exc_offset = CURRENT_EL_SP_EL0_VECTOR;
+	else if (!(mode & PSR_MODE32_BIT))
+		exc_offset = LOWER_EL_AArch64_VECTOR;
+	else
+		exc_offset = LOWER_EL_AArch32_VECTOR;
+
+	return exc_offset + type;
+}
+
 /*
- * This performs the exception entry at a given EL (@target_mode), stashing PC
- * and PSTATE into ELR and SPSR respectively, and compute the new PC/PSTATE.
- * The EL passed to this function *must* be a non-secure, privileged mode with
- * bit 0 being set (PSTATE.SP == 1).
- *
  * When an exception is taken, most PSTATE fields are left unchanged in the
  * handler. However, some are explicitly overridden (e.g. M[4:0]). Luckily all
  * of the inherited bits have the same position in the AArch64/AArch32 SPSR_ELx
@@ -82,50 +95,17 @@ static void __vcpu_write_spsr_und(struct kvm_vcpu *vcpu, u64 val)
  * Here we manipulate the fields in order of the AArch64 SPSR_ELx layout, from
  * MSB to LSB.
  */
-static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
-			      enum exception_type type)
+unsigned long get_except64_cpsr(unsigned long old, bool has_mte,
+				unsigned long sctlr, unsigned long target_mode)
 {
-	unsigned long sctlr, vbar, old, new, mode;
-	u64 exc_offset;
-
-	mode = *vcpu_cpsr(vcpu) & (PSR_MODE_MASK | PSR_MODE32_BIT);
-
-	if      (mode == target_mode)
-		exc_offset = CURRENT_EL_SP_ELx_VECTOR;
-	else if ((mode | PSR_MODE_THREAD_BIT) == target_mode)
-		exc_offset = CURRENT_EL_SP_EL0_VECTOR;
-	else if (!(mode & PSR_MODE32_BIT))
-		exc_offset = LOWER_EL_AArch64_VECTOR;
-	else
-		exc_offset = LOWER_EL_AArch32_VECTOR;
-
-	switch (target_mode) {
-	case PSR_MODE_EL1h:
-		vbar = __vcpu_read_sys_reg(vcpu, VBAR_EL1);
-		sctlr = __vcpu_read_sys_reg(vcpu, SCTLR_EL1);
-		__vcpu_write_sys_reg(vcpu, *vcpu_pc(vcpu), ELR_EL1);
-		break;
-	case PSR_MODE_EL2h:
-		vbar = __vcpu_read_sys_reg(vcpu, VBAR_EL2);
-		sctlr = __vcpu_read_sys_reg(vcpu, SCTLR_EL2);
-		__vcpu_write_sys_reg(vcpu, *vcpu_pc(vcpu), ELR_EL2);
-		break;
-	default:
-		/* Don't do that */
-		BUG();
-	}
-
-	*vcpu_pc(vcpu) = vbar + exc_offset + type;
-
-	old = *vcpu_cpsr(vcpu);
-	new = 0;
+	u64 new = 0;
 
 	new |= (old & PSR_N_BIT);
 	new |= (old & PSR_Z_BIT);
 	new |= (old & PSR_C_BIT);
 	new |= (old & PSR_V_BIT);
 
-	if (kvm_has_mte(kern_hyp_va(vcpu->kvm)))
+	if (has_mte)
 		new |= PSR_TCO_BIT;
 
 	new |= (old & PSR_DIT_BIT);
@@ -161,6 +141,42 @@ static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
 
 	new |= target_mode;
 
+	return new;
+}
+
+/*
+ * This performs the exception entry at a given EL (@target_mode), stashing PC
+ * and PSTATE into ELR and SPSR respectively, and compute the new PC/PSTATE.
+ * The EL passed to this function *must* be a non-secure, privileged mode with
+ * bit 0 being set (PSTATE.SP == 1).
+ */
+static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
+			      enum exception_type type)
+{
+	u64 offset = get_except64_offset(*vcpu_cpsr(vcpu), target_mode, type);
+	unsigned long sctlr, vbar, old, new;
+
+	switch (target_mode) {
+	case PSR_MODE_EL1h:
+		vbar = __vcpu_read_sys_reg(vcpu, VBAR_EL1);
+		sctlr = __vcpu_read_sys_reg(vcpu, SCTLR_EL1);
+		__vcpu_write_sys_reg(vcpu, *vcpu_pc(vcpu), ELR_EL1);
+		break;
+	case PSR_MODE_EL2h:
+		vbar = __vcpu_read_sys_reg(vcpu, VBAR_EL2);
+		sctlr = __vcpu_read_sys_reg(vcpu, SCTLR_EL2);
+		__vcpu_write_sys_reg(vcpu, *vcpu_pc(vcpu), ELR_EL2);
+		break;
+	default:
+		/* Don't do that */
+		BUG();
+	}
+
+	*vcpu_pc(vcpu) = vbar + offset;
+
+	old = *vcpu_cpsr(vcpu);
+	new = get_except64_cpsr(old, kvm_has_mte(kern_hyp_va(vcpu->kvm)), sctlr,
+				target_mode);
 	*vcpu_cpsr(vcpu) = new;
 	__vcpu_write_spsr(vcpu, target_mode, old);
 }
-- 
2.52.0.487.g5c8c507ade-goog


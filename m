Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3968627D
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 09:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713261453; cv=none; b=X8/MbJRCBVbx3zLmYwW/B1AxbleCu3j6yv0LGV15vXD9RVms7iQQ3GzNlDxtdclAaFgXq3HxJdYB2dfDX2vSnot24t2DxNStAGKi2eLMDKf+9if0sb+JmZ7KzIRdtr/G3OqKqPLXAIam2MfRcMch7Xghed1TOFhfAXNo+gfyRZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713261453; c=relaxed/simple;
	bh=QmxnD6+yKtCtIqTzyOyTcDbRpq6+ehKEnbFZu2+2BlI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dTBsJ/xarTcFtRD99O0eGrzR0Z61aRtjaKt1YaTTPQToXgI4/r6VrZxq8v6E9UzO/XQq5VMTwF5/1AqZdbb4sxs9r8HvdA7Z1pHZVMCWYTrZ/wakY7m6CmCFnTqrktS7OkyYYYE+wFP7X3WeDo9sJedhcF020qTFKYLLkxACEio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AYQjKy/i; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AYQjKy/i"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dcd1779adbeso6783600276.3
        for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 02:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713261451; x=1713866251; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hUEUIl/BVLnUVGN/SDOObOSOs0LCwcSzCzIQSrAMp+k=;
        b=AYQjKy/iqeeVtFBAPc79xOuInLLr2S5AW/Yqw6nG9mixoct7N5N03DZlN2fgKSN0+3
         74iR2QIeWP1mHlIC1rlmbaAEn4PYgfjKmeE932gNtL8AUoyzlF/6/mIDWnmW4MAeOpMH
         9XC4n0NuQ+812lbBvUd7j7JIHA3xNGEpruJJaL3by2Uw4w9CwKeofhrOJjfYNPTATz0h
         BZ8o1M9z48aASJ3hLrwcUnUXL+bULAp5+dI1cqsIrCloNnCdesLwiX9SfrXvMfCk4ave
         BveIBih9jaKZTER70QoQf13Cc2f+p7yMhIE2/u77u7iy+vHlq4OFE+Qe2sQ1o8vqAarO
         /6Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713261451; x=1713866251;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hUEUIl/BVLnUVGN/SDOObOSOs0LCwcSzCzIQSrAMp+k=;
        b=WDU6Fz5Zv13mRHrgj7TLgoGbykJaLaIkMMJ/iUr4dFn1tRaFFyzoxFU05VphtTdY8J
         yk1rNaE/EtroUth/0LEfrpqR+jvwa5VdhcmqXa+JSe8Q9OVZE2Hkc60vzS01lK82/Edc
         XQB6mZETpAm3LaxQQdU9tgxTCFlZce0Ggllry3oXYiDfcUnSHBwKSp/Gs1q/itTORrI6
         P0ITf6C37G87FWsehpyZGQPxmSQ6njYBgV7bnCkmn/te97gYLgmidvP4C/Z6f425YTm0
         T6x9vrSgETrxwWTcc+3ie+kXtQw1aUF3Ss21Tsls41E8f/Cx3V0Mnq4jc/k+W0ES7RX1
         N4fQ==
X-Gm-Message-State: AOJu0Yzu8Ivo+CY2BwUs+iQfcayKVFdNPA6vWzEJdy8HiNTnmmxAiWvQ
	d/d37Xt/TBrVzOZNStr+1AWJL56ls5fKPyyzcf6AAmgWnWAiDhrJ5xO4mowGDlW2h6lmWD3Wfw8
	kiWADaOTwjx+LI0Mb+YxP+5lPFn5wFi5xEjoYqg3ewG/AFnDrEBVrOyvJOSzYaxSkgWnUXP02vM
	9T0V56AFCcoBdKzwe8J1r2zq4rlsc=
X-Google-Smtp-Source: AGHT+IFlH51p8L0UI52FJXt10MDVZd/ZTrZPRydyCtlsQ44L9jhrC9Nmr6fWEV4FkQ8P7ps/DaWRdeMP3w==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a25:8d83:0:b0:dd9:1dc0:b6c5 with SMTP id
 o3-20020a258d83000000b00dd91dc0b6c5mr3690001ybl.6.1713261451054; Tue, 16 Apr
 2024 02:57:31 -0700 (PDT)
Date: Tue, 16 Apr 2024 10:56:13 +0100
In-Reply-To: <20240416095638.3620345-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240416095638.3620345-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240416095638.3620345-23-tabba@google.com>
Subject: [PATCH v2 22/47] KVM: arm64: Refactor enter_exception64()
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

From: Quentin Perret <qperret@google.com>

In order to simplify the injection of exceptions in the host in pkvm
context, let's factor out of enter_exception64() the code calculating
the exception offset from VBAR_EL1 and the cpsr.

No functional change intended.

Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_emulate.h |   5 ++
 arch/arm64/kvm/hyp/exception.c       | 100 ++++++++++++++++-----------
 2 files changed, 63 insertions(+), 42 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 7ad5fdc34ec1..fd5b790af6bf 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -49,6 +49,11 @@ void kvm_inject_dabt(struct kvm_vcpu *vcpu, unsigned long addr);
 void kvm_inject_pabt(struct kvm_vcpu *vcpu, unsigned long addr);
 void kvm_inject_size_fault(struct kvm_vcpu *vcpu);
 
+unsigned long get_except64_offset(unsigned long psr, unsigned long target_mode,
+				  enum exception_type type);
+unsigned long get_except64_cpsr(unsigned long old, bool has_mte,
+				unsigned long sctlr, unsigned long mode);
+
 void kvm_vcpu_wfi(struct kvm_vcpu *vcpu);
 
 void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
index 424a5107cddb..da69a5685c47 100644
--- a/arch/arm64/kvm/hyp/exception.c
+++ b/arch/arm64/kvm/hyp/exception.c
@@ -71,31 +71,12 @@ static void __vcpu_write_spsr_und(struct kvm_vcpu *vcpu, u64 val)
 		vcpu->arch.ctxt.spsr_und = val;
 }
 
-/*
- * This performs the exception entry at a given EL (@target_mode), stashing PC
- * and PSTATE into ELR and SPSR respectively, and compute the new PC/PSTATE.
- * The EL passed to this function *must* be a non-secure, privileged mode with
- * bit 0 being set (PSTATE.SP == 1).
- *
- * When an exception is taken, most PSTATE fields are left unchanged in the
- * handler. However, some are explicitly overridden (e.g. M[4:0]). Luckily all
- * of the inherited bits have the same position in the AArch64/AArch32 SPSR_ELx
- * layouts, so we don't need to shuffle these for exceptions from AArch32 EL0.
- *
- * For the SPSR_ELx layout for AArch64, see ARM DDI 0487E.a page C5-429.
- * For the SPSR_ELx layout for AArch32, see ARM DDI 0487E.a page C5-426.
- *
- * Here we manipulate the fields in order of the AArch64 SPSR_ELx layout, from
- * MSB to LSB.
- */
-static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
-			      enum exception_type type)
+unsigned long get_except64_offset(unsigned long psr, unsigned long target_mode,
+				  enum exception_type type)
 {
-	unsigned long sctlr, vbar, old, new, mode;
+	u64 mode = psr & (PSR_MODE_MASK | PSR_MODE32_BIT);
 	u64 exc_offset;
 
-	mode = *vcpu_cpsr(vcpu) & (PSR_MODE_MASK | PSR_MODE32_BIT);
-
 	if      (mode == target_mode)
 		exc_offset = CURRENT_EL_SP_ELx_VECTOR;
 	else if ((mode | PSR_MODE_THREAD_BIT) == target_mode)
@@ -105,33 +86,32 @@ static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
 	else
 		exc_offset = LOWER_EL_AArch32_VECTOR;
 
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
+	return exc_offset + type;
+}
 
-	old = *vcpu_cpsr(vcpu);
-	new = 0;
+/*
+ * When an exception is taken, most PSTATE fields are left unchanged in the
+ * handler. However, some are explicitly overridden (e.g. M[4:0]). Luckily all
+ * of the inherited bits have the same position in the AArch64/AArch32 SPSR_ELx
+ * layouts, so we don't need to shuffle these for exceptions from AArch32 EL0.
+ *
+ * For the SPSR_ELx layout for AArch64, see ARM DDI 0487E.a page C5-429.
+ * For the SPSR_ELx layout for AArch32, see ARM DDI 0487E.a page C5-426.
+ *
+ * Here we manipulate the fields in order of the AArch64 SPSR_ELx layout, from
+ * MSB to LSB.
+ */
+unsigned long get_except64_cpsr(unsigned long old, bool has_mte,
+				unsigned long sctlr, unsigned long target_mode)
+{
+	u64 new = 0;
 
 	new |= (old & PSR_N_BIT);
 	new |= (old & PSR_Z_BIT);
 	new |= (old & PSR_C_BIT);
 	new |= (old & PSR_V_BIT);
 
-	if (kvm_has_mte(kern_hyp_va(vcpu->kvm)))
+	if (has_mte)
 		new |= PSR_TCO_BIT;
 
 	new |= (old & PSR_DIT_BIT);
@@ -167,6 +147,42 @@ static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
 
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
2.44.0.683.g7961c838ac-goog


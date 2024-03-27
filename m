Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 591AE14E2FB
	for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 17:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711560982; cv=none; b=az5R5GGEJ2v+FzgiZWKZAwbmmihi8G8U1NRvzCzBAUBrOOwNL9qEHakYkdm3oPxW5cUhfngE6ttz3UQsxOk5V1Wpi3h1cF9/fvLGTEbtFrWZCqqQkclnqdtSScVoLvrvvwKJOmC6uQTAlWwZKFhbiZ2jBi3QfOWLEnwvgF0GWS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711560982; c=relaxed/simple;
	bh=JlzmlU39RIxrWpX8b5CsUnKL9L8Uh1K/DtN4RaS04qY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rvQUN/d8oDtT3Nc0MwQZj4GlL4b/Yxwu2K01nz1xolVHrn0Dx1DCqnxhpywityFSS1OzDqZi5lw20kYuuC3dBI6SQU9RZBG0HSlzZmRNRqtajI00HrLT6aEbZBmwRsF9d+8EvLo6O8W7WfdKliITjYgpA+TX81hWLyuCslDwP9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nwQbJ9Iq; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nwQbJ9Iq"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-60ff1816749so1434307b3.3
        for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 10:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711560980; x=1712165780; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dScb409ZGdBrobW6nmNmtaSe3k/ekOVjSFdi+ucNScw=;
        b=nwQbJ9Iq4OLjJT73RbkLhkNJxL8GJo2/LBP32nndAzJx2QNV01qhsDj36wdEZhr4WF
         XXkDro6eNKCI2dB+geICBHjUftAeN7KCgEUfxzXmCwwMCYRKakdfU0tUvt02cdIuQHvV
         N5Z2IQp/aJdeBLlZg/+j84Y7knO9Yb0BGbWDcUCfLsZhwg+9oeR9J2RtwzU90ZPY5tCb
         XAJfcmhbYj+ctq0hzsVizkzjdB5f+ypGNRTWN6XcS21vJb3ZgS2FKShI/7Fkj3AH5fbi
         Xdh4pZeIpWelCm4qEw0HRGkIQ66id92SnsS5UMpLyye9aMUIpZeqDQSTaap94OOp0hdg
         Ictw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711560980; x=1712165780;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dScb409ZGdBrobW6nmNmtaSe3k/ekOVjSFdi+ucNScw=;
        b=oIAq/LnyW7u6fLQK7UNzEtIE/KRB+pymhTUegeI8aeiF8euwpCM4tyQBTwPFUIUo8X
         a5v4I6sJgvghleQy8pZWdbFOflh/jhfsKcvxArQuRyYWNGL8hUopMun6flQUHgNEggUb
         W1Nf8bAVN1ICZVgylWWvtgVS9akkut1PB9uYcxKJdiZ/azifIo5MDhZvJR9VBGb3994x
         +6xq7j63mYDgrkLmwrDM8DLq2hj7I2JwwTp7hXdOf0XloVamMHyj+9NkucHY2shU7MtW
         lL+Hf6fXtuJ3yHSsT4oDHNvkW2VTbefLrAqgWVWHjxQM7apZOVu6FBb4AaVnb0Ot57/D
         41LQ==
X-Gm-Message-State: AOJu0Yw77CwHIGqZWDsMPpHt763cmrqHp0d5Z+JX4U5oK0O5NOmJuiqh
	ddMAPXS13E0bcFiuJMmWM1CaEbMwMKvldpK5OyvNHA7kRWGKYZAsEUBZFUvzpSUcVuSZLqjy181
	SiofwwiLw1tS/yI7sY764VHN1GdWYe0c4APa+PvIi5Q62F795uzvrG7V/h7JxTmyajJKu0BG9Pa
	JCoA9vz6rGfL45lu68xz8Sk0Jx9Lk=
X-Google-Smtp-Source: AGHT+IFwwZ0ETo4SqFRefiNcM7hTIS4Xbpy//k/F/0trzbkKdb4fvH8OSbB2ZMBsUX3VdCZs3jDSSCsUNw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a0d:cc42:0:b0:60a:6a7b:3c61 with SMTP id
 o63-20020a0dcc42000000b0060a6a7b3c61mr63703ywd.5.1711560980279; Wed, 27 Mar
 2024 10:36:20 -0700 (PDT)
Date: Wed, 27 Mar 2024 17:35:07 +0000
In-Reply-To: <20240327173531.1379685-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240327173531.1379685-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240327173531.1379685-21-tabba@google.com>
Subject: [PATCH v1 20/44] KVM: arm64: Refactor enter_exception64()
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com
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
index dcb2aaf10d8c..4f0bc2df46f6 100644
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
2.44.0.478.gd926399ef9-goog


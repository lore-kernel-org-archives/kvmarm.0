Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E1562DF121
	for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 11:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765453115; cv=none; b=I85S491djPeKgFYpehYBBnMCp2w+SfbV8oB0TBDXmfsG+HYEzD/XlIQzt4pm4Pw87SCzenNfrAi+ylmVOWsxybUAD2yj52pgPyQXrJtGJDWEqt2NBKuQr/jeq1ze4FH0qU+6/z0cPZdwSCeM4wJ2UJ8gfUXhEsT+v2r3Dz1zngc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765453115; c=relaxed/simple;
	bh=gaOfSBo8TglljgQKxrEojEbdQojdJTsWq3QCRSV8U7M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=h9fx7puhQxCt1YOi1/8flLx3Rjlq8DT0Auaq+KLE46XDg377PhlbNXfibCioi0CkwU3wozOiZTSCzXd1iaYSXhcl9Z3C2UsTCQAY8GjyPebEvuzwdwJswsbg3gKnGwzPPqNPzY4a9Vkh5UI6AvUChXaEbCImEoPjgRikkmJwddM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aCzTE0mI; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aCzTE0mI"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-42b366a76ffso373819f8f.1
        for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 03:38:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765453112; x=1766057912; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gHedRetF8JCExxbKNzQuXO4B6ElqC9WxHZJNQma7Zow=;
        b=aCzTE0mITptywp7GcuHAcozjr4FY+88nPleU4uzVUhUtYRzwQGkZmvKUvx2hUBX3+t
         /wCXalZhfPFdA540t4PTpfcZC6o/14+o24Y0ny6caIcZl3mrhWigMaY2Vvq6AlQMsvPV
         uYDdaMuz6PGdnY/wEaDvDj82/ZLIT1/nc9YQzfjdDzfZa3GUY0pLf2f6ClsRNKmfJFGm
         WuZPq3ftO08zqGGnPkIxBpXSntiZPl0t4PA0jiyHPjyZ/xqmfhWEpj2YhkjxtA+Yx/3u
         7/ZgfjuKJn3mLZ0KYvbZr7fb1F5uKdHP3CaLm2A/Kza3OeTE/EXV+3MDHak03dtx47gd
         /a7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765453112; x=1766057912;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gHedRetF8JCExxbKNzQuXO4B6ElqC9WxHZJNQma7Zow=;
        b=RwEgsMXZFih6t/eUFSSyjvubSpXgGqhnKpuJuSQwxZCPRDruB5uqGzFDwXDSs0NLHo
         xg8NX9QA0gI/on/+6e8LstbilDvTx2wUsLQWx+AHYLE5AQ6wLvx1PZtQwdgEigpIgsme
         lTyEr7E46buC5EVMJjfCs5YlpDekb9TcR8TSnbKyOVr40RTySRBt5w9FRBQw0rbQB+ET
         CKyWHLMDSIln2Ch4sCIcL5WFTFB+9rG1TEO5+cooS636mzGpIRuu3I1RBIQFcBm4x4rb
         xDH5rmaBCFBo9v/T3dr+q/0l+QRPrqdN2CcTr9JJV6o6zLBBKQdbarS6Lfr9XTsy+l82
         GBhg==
X-Gm-Message-State: AOJu0YwOUDZ9eb9FpM1VJiBlHviItMOAvA2oIZWMrIEnQV6blSLCAqtc
	b87+HULYDLzisre9nO1LNQLyhokryqc9h64NCI7uhY+rUdF2U8jVmYSUXmU2d4kG6DiCZFH4ghB
	vDmqhPJfsyosYD7YBLatHK7Rt4GTHKVMgo/r7W62wSwGTIJQXxD4BBLTUzzzxw53B0hYZ3FNups
	z63WJdbGY/z37rde/Ihc8UpCyZybJ/T/c=
X-Google-Smtp-Source: AGHT+IHj8V7lfV5TT/EjlEumn+FTn7VW7DKux9btH2yvaecHOgsfDCdIPFZnSMgs4R5O36N6Zxfpsp7oew==
X-Received: from wrmq7.prod.google.com ([2002:adf:ea07:0:b0:42c:c2d6:2a1])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:adf:f243:0:b0:42f:a990:96a6
 with SMTP id ffacd0b85a97d-42fa9909750mr2267954f8f.40.1765453111808; Thu, 11
 Dec 2025 03:38:31 -0800 (PST)
Date: Thu, 11 Dec 2025 11:38:26 +0000
In-Reply-To: <20251211113828.370370-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251211113828.370370-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251211113828.370370-4-tabba@google.com>
Subject: [PATCH v2 3/5] KVM: arm64: Refactor enter_exception64()
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
2.52.0.223.gf5cc29aaa4-goog


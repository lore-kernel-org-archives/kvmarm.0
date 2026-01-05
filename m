Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 790902641C6
	for <kvmarm@lists.linux.dev>; Mon,  5 Jan 2026 15:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767628237; cv=none; b=RZBOghg+e0nNDoyApxlJCQWne6J1Mps8TY7o1XoWs0aP9QqYxZ+nixwzOSl29sHCblo37DqVp5FgQpienbjBGNM4AUcbto51FsX/ZpDlK+RgMt05EHg1Z4JA0VipgrGgVlnqcQll2lLakPdsZS/8J6q7iduNRqPHMjdExRzhAxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767628237; c=relaxed/simple;
	bh=cHEUkrGo3y/4MY7oFI28hC6uQmwsSVfrqToabC4Q4xE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sd67gJtxPaj+CJqrmq6aAkKtVJgeG7QNU8rWMFq8gdZCpzkp0sx745jgNGHPQ97vMov4vMws93NSLAnow47m7Z7VwPCyKZBOl31UXneUrFg55N6UaSVT+TryYW0jw2vnT+lD4IHsmlGzF8I/+YhifNyjv+A5VaigLFOWud1MeoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hXgVx2ZG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hXgVx2ZG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2607CC116D0;
	Mon,  5 Jan 2026 15:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767628236;
	bh=cHEUkrGo3y/4MY7oFI28hC6uQmwsSVfrqToabC4Q4xE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hXgVx2ZGVBaHAmsQA0EQ6kzuHkWtlrlQl+nCDIVHte7jOpS2T3l7OvW1fJ5XYdpNG
	 nyWDby1GYdEJ9koUVh5TAeUzA0OhAQqBc7qYdND0K70Oemg6Ry0uVmNBK7EgtwBiqa
	 1GCXep47EYfFuioDYfXZzBBPnfZfO6K4HYdum+WrcArTwwAZV9zuoUh6e7a/0FQGeP
	 zeoLNtNVz49PMzjOKg1BpL5z3Omi+WyKXofd/oPWIU05cCyYlSycOVMfDjwXtMatm8
	 sA8LI9PZLmqd73RKY+w+uCuZlT2FEfuQb/pPqkXxcyFJznwqpURS+A1bgU6IVE9s50
	 TT8B9UU8pXZRw==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH 15/30] KVM: arm64: Refactor enter_exception64()
Date: Mon,  5 Jan 2026 15:49:23 +0000
Message-ID: <20260105154939.11041-16-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260105154939.11041-1-will@kernel.org>
References: <20260105154939.11041-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Quentin Perret <qperret@google.com>

In order to simplify the injection of exceptions in the host in pkvm
context, refactor enter_exception64() to separate the code calculating
the exception offset from VBAR_EL1 and the cpsr.

No functional change intended.

Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
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
2.52.0.351.gbe84eed79e-goog


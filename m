Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F9170819
	for <kvmarm@lists.linux.dev>; Mon,  9 Dec 2024 18:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733767814; cv=none; b=PeIqcu70vaZ3/lrgaGpiIvzByhKk6JwXHPCsqEs2gFLDi21SJniDzoOjZyDDRGW0rT5sIWA5g3PhD3an7JmK90TQ1nV132wYxY3kmkODTJ2SESb3wLJjpY5WJE4vF3rt/XDkAHnW6J8B10fq45an/vuy8f6lsbjA1ibJoV4/28M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733767814; c=relaxed/simple;
	bh=t4Ig5welFqXclHBSwvcdZzDwX9mh7DA6tgaka00dq0M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Zz3QC6ZY2JrKdwHffIaO7DDVN4k4IT++Peh1kY2Wcr4LnWDmzcnwaDG7N51TYTqnePK66xZcugZvRinrngSUag/kqhen6TJylpuIuCRXzvIi40A985k0vMep4s/Ztf2WjVD3LNx15+VupVP6PlFCtRgOAwDwprZXu4dwLM6PO6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=v1eJz2bg; arc=none smtp.client-ip=91.218.175.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="v1eJz2bg"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1733767809;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xmzaaTHImIGMIjVZfIMDqxFMvzVa0yfOWuX0kqqA4iY=;
	b=v1eJz2bgANVn2xbWqZqEufAvIBIwc03FXaRNHgbgR2Rp/YBUdVRrHbJ5Une0WHKPj7vaDr
	KXnX876sFEsmCOB+UjHz/z3Qm7ActpPgrgSSA9/QjfBeeVVqFBsG1HJdyg5LH+hb2M2OAh
	5rL4AvP8ciCocu5mWlXEsg3Xb/SsK7s=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	James Clark <james.clark@linaro.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 11/16] KVM: arm64: Reload vCPU for accesses to OSLAR_EL1
Date: Mon,  9 Dec 2024 10:09:21 -0800
Message-Id: <20241209180926.2161373-12-oliver.upton@linux.dev>
In-Reply-To: <20241209180926.2161373-1-oliver.upton@linux.dev>
References: <20241209180926.2161373-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

KVM takes ownership of the debug regs if the guest enables the OS lock,
as it needs to use MDSCR_EL1 to mask debug exceptions. Just reload the
vCPU if the guest toggles the OS lock, relying on kvm_vcpu_load_debug()
to update the debug owner and get the right trap configuration in place.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/debug.c            | 13 +++++++++++++
 arch/arm64/kvm/sys_regs.c         |  9 +--------
 3 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index a6796a952af7..d61b8ed32a21 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1346,6 +1346,7 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
 void kvm_vcpu_load_debug(struct kvm_vcpu *vcpu);
 void kvm_debug_set_guest_ownership(struct kvm_vcpu *vcpu);
+void kvm_debug_handle_oslar(struct kvm_vcpu *vcpu, u64 val);
 
 #define kvm_vcpu_os_lock_enabled(vcpu)		\
 	(!!(__vcpu_sys_reg(vcpu, OSLSR_EL1) & OSLSR_EL1_OSLK))
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index 54c93b37a06a..91f484a566e4 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -289,3 +289,16 @@ void kvm_debug_set_guest_ownership(struct kvm_vcpu *vcpu)
 	WARN_ON_ONCE(vcpu->arch.debug_owner == VCPU_DEBUG_GUEST_OWNED);
 	vcpu->arch.debug_owner = VCPU_DEBUG_GUEST_OWNED;
 }
+
+void kvm_debug_handle_oslar(struct kvm_vcpu *vcpu, u64 val)
+{
+	if (val & OSLAR_EL1_OSLK)
+		__vcpu_sys_reg(vcpu, OSLSR_EL1) |= OSLSR_EL1_OSLK;
+	else
+		__vcpu_sys_reg(vcpu, OSLSR_EL1) &= ~OSLSR_EL1_OSLK;
+
+	preempt_disable();
+	kvm_arch_vcpu_put(vcpu);
+	kvm_arch_vcpu_load(vcpu, smp_processor_id());
+	preempt_enable();
+}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 5b8982bcc0bb..15e427c5fc4f 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -570,17 +570,10 @@ static bool trap_oslar_el1(struct kvm_vcpu *vcpu,
 			   struct sys_reg_params *p,
 			   const struct sys_reg_desc *r)
 {
-	u64 oslsr;
-
 	if (!p->is_write)
 		return read_from_write_only(vcpu, p, r);
 
-	/* Forward the OSLK bit to OSLSR */
-	oslsr = __vcpu_sys_reg(vcpu, OSLSR_EL1) & ~OSLSR_EL1_OSLK;
-	if (p->regval & OSLAR_EL1_OSLK)
-		oslsr |= OSLSR_EL1_OSLK;
-
-	__vcpu_sys_reg(vcpu, OSLSR_EL1) = oslsr;
+	kvm_debug_handle_oslar(vcpu, p->regval);
 	return true;
 }
 
-- 
2.39.5


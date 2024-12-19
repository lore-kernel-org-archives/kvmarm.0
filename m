Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FCFB86337
	for <kvmarm@lists.linux.dev>; Thu, 19 Dec 2024 22:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734648119; cv=none; b=s8r6TW0vEdNoWfzA4mrwQGeylMAQRT7jR9jPdEwFADX1/R9GRGCfrRUEef911v3rpbIeu0VXVSh5e9z9wNVIW1rdYr2OkskcBgblCD/BHvaXEnFp6s3oNxQmSpPPBCzb0/VuZz5Rm11xBlZP+fNzKwfSis2/KSuZEkJGQ0Ltk6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734648119; c=relaxed/simple;
	bh=Cl90S3Twg0/U9rQAsXMCUJWw41ovFaHSEGJXzIqfW/A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fZSgAXtE3e+5rw6e5pIwW7ju6eyH0BJUTGm2z3ShJe3CvoGPCGlT67DGPUVM9aSr3kCRHgMhArtVflfqVAVEjEtyt/jFKhS/i+DhDdypD0kke2OUdfFjNkLy6BjcCYdcdxJl+gFxfIsl4Ik/h0csC8LMN7i46dn66/55crudn+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bcNisL8I; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bcNisL8I"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1734648116;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e5c8427Hm/j7SXT55+HRd7K9hrN6t+7NlbGkOBL9mR4=;
	b=bcNisL8ISr372l11g0btEGsRs5vJOEmwpc02yY/xBXCUoVpBFrN5bUJWiPxYpJesQiEFlC
	nj4rPlUJKBAzrnCucM68XvO1urxPAJ4E0U6FPUKVY6jcmCy5SyxNmHOkMgjqkK3mi5pkLj
	t61VQtF/Ri/COjvvFMoNKT0WKSGJMxM=
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
Subject: [PATCH v4 12/19] KVM: arm64: Reload vCPU for accesses to OSLAR_EL1
Date: Thu, 19 Dec 2024 14:41:09 -0800
Message-Id: <20241219224116.3941496-13-oliver.upton@linux.dev>
In-Reply-To: <20241219224116.3941496-1-oliver.upton@linux.dev>
References: <20241219224116.3941496-1-oliver.upton@linux.dev>
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

Tested-by: James Clark <james.clark@linaro.org>
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
index 300ea3720bed..bf348c86758f 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -292,3 +292,16 @@ void kvm_debug_set_guest_ownership(struct kvm_vcpu *vcpu)
 
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
index 66db77fb6201..ed4adbf5a25e 100644
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


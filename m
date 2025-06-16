Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81453212B2B
	for <kvmarm@lists.linux.dev>; Mon, 16 Jun 2025 23:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750115020; cv=none; b=rZUlJ/slnNrB43JhZNldz7XmM9bC07eARLODYj7gVrWyv9EwveuwBDCCCLfH7B94+8KMplCTqTMu2z2kzUAPehWVOyzCivUwXEJb6CDdL0g4MOr8NIsQv1IEJolavQcX0y1M3nt0i2QkYTIdy64zyPErlsIlXJJhhPBv0q5QszQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750115020; c=relaxed/simple;
	bh=Th4i9GP1m5qbk4NXt22weeJSxyMtiJ0NixOuhn2CEVc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=m/P2NrV+PmSSLW81X81YfJG7a785fh284FfM4onihwDeXJt+2QFfNJpPYwGf8WMbL0q7tHB9gqwpNOwDveM0IZBX0/oQme31bITw+z7Zn4Z8B2/qxCxESbTjWAhIzJ1slrmNVkcRzINYMzwObjTWKfEuxyiyd2Fwegt45Fjxk3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=h1d2kIPw; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="h1d2kIPw"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750115014;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YOU+jwDxOuWRk2MOkB0s7PLHAo2lgjxv0y9rXahZYMM=;
	b=h1d2kIPw/Jtu0wdUey7WmyQm/z92oOgQsFCzfbfvhYHooCzSmjmh1mw8obG8XMdSesiZz2
	8+bhbd3Ie7QP8clL5IohuEAIScbwx+Cex1Vxa2RCJkU5KsyQHtn5EqEPoU4R+5qkxivgi4
	DYtpKLsZYrRgA3REftQNnlseP4AxNUw=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 08/27] KVM: arm64: nv: Use guest hypervisor's vSError state
Date: Mon, 16 Jun 2025 16:02:49 -0700
Message-Id: <20250616230308.1192565-9-oliver.upton@linux.dev>
In-Reply-To: <20250616230308.1192565-1-oliver.upton@linux.dev>
References: <20250616230308.1192565-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

When HCR_EL2.AMO is set, physical SErrors are routed to EL2 and virtual
SError injection is enabled for EL1. Conceptually treating
host-initiated SErrors as 'physical', this means we can delegate control
of the vSError injection context to the guest hypervisor when nesting &&
AMO is set.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_emulate.h       |  5 +++
 arch/arm64/kvm/hyp/include/hyp/switch.h    | 38 +++++++++++++++++++---
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 14 ++++++--
 3 files changed, 50 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 45029dd5e9c7..3ac11effed7d 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -257,6 +257,11 @@ static inline bool is_nested_ctxt(struct kvm_vcpu *vcpu)
 	return vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu);
 }
 
+static inline bool vserror_state_is_nested(struct kvm_vcpu *vcpu)
+{
+	return is_nested_ctxt(vcpu) && vcpu_el2_amo_is_set(vcpu);
+}
+
 /*
  * The layout of SPSR for an AArch32 state is different when observed from an
  * AArch64 SPSR_ELx or an AArch32 SPSR_*. This function generates the AArch32
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 71a66c910ab2..6a6ebc824aba 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -346,21 +346,49 @@ static inline void ___activate_traps(struct kvm_vcpu *vcpu, u64 hcr)
 
 	write_sysreg_hcr(hcr);
 
-	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN) && (hcr & HCR_VSE))
-		write_sysreg_s(vcpu->arch.vsesr_el2, SYS_VSESR_EL2);
+	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN) && (hcr & HCR_VSE)) {
+		u64 vsesr;
+
+		/*
+		 * When HCR_EL2.AMO is set, physical SErrors are taken to EL2
+		 * and vSError injection is enabled for EL1. Conveniently, for
+		 * NV this means that it is never the case where a 'physical'
+		 * SError (injected by KVM or userspace) and vSError are
+		 * deliverable to the same context.
+		 *
+		 * As such, we can trivially select between the host or guest's
+		 * VSESR_EL2.
+		 */
+		if (vserror_state_is_nested(vcpu))
+			vsesr = __vcpu_sys_reg(vcpu, VSESR_EL2);
+		else
+			vsesr = vcpu->arch.vsesr_el2;
+
+		write_sysreg_s(vsesr, SYS_VSESR_EL2);
+	}
 }
 
 static inline void ___deactivate_traps(struct kvm_vcpu *vcpu)
 {
+	u64 *hcr;
+
+	if (vserror_state_is_nested(vcpu))
+		hcr = __ctxt_sys_reg(&vcpu->arch.ctxt, HCR_EL2);
+	else
+		hcr = &vcpu->arch.hcr_el2;
+
 	/*
 	 * If we pended a virtual abort, preserve it until it gets
 	 * cleared. See D1.14.3 (Virtual Interrupts) for details, but
 	 * the crucial bit is "On taking a vSError interrupt,
 	 * HCR_EL2.VSE is cleared to 0."
+	 *
+	 * Additionally, when in a nested context we need to propagate the
+	 * updated state to the guest hypervisor's HCR_EL2.
 	 */
-	if (vcpu->arch.hcr_el2 & HCR_VSE) {
-		vcpu->arch.hcr_el2 &= ~HCR_VSE;
-		vcpu->arch.hcr_el2 |= read_sysreg(hcr_el2) & HCR_VSE;
+	if (*hcr & HCR_VSE) {
+		*hcr &= ~HCR_VSE;
+		*hcr |= read_sysreg(hcr_el2) & HCR_VSE;
 	}
 }
 
diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index 4d0dbea4c56f..7fffeaf71dec 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -159,7 +159,12 @@ static inline void __sysreg_save_el2_return_state(struct kvm_cpu_context *ctxt)
 	if (!has_vhe() && ctxt->__hyp_running_vcpu)
 		ctxt->regs.pstate	= read_sysreg_el2(SYS_SPSR);
 
-	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN))
+	if (!cpus_have_final_cap(ARM64_HAS_RAS_EXTN))
+		return;
+
+	if (vserror_state_is_nested(ctxt_to_vcpu(ctxt)))
+		ctxt_sys_reg(ctxt, VDISR_EL2) = read_sysreg_s(SYS_VDISR_EL2);
+	else
 		ctxt_sys_reg(ctxt, DISR_EL1) = read_sysreg_s(SYS_VDISR_EL2);
 }
 
@@ -293,7 +298,12 @@ static inline void __sysreg_restore_el2_return_state(struct kvm_cpu_context *ctx
 	write_sysreg_el2(ctxt->regs.pc,			SYS_ELR);
 	write_sysreg_el2(pstate,			SYS_SPSR);
 
-	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN))
+	if (!cpus_have_final_cap(ARM64_HAS_RAS_EXTN))
+		return;
+
+	if (vserror_state_is_nested(ctxt_to_vcpu(ctxt)))
+		write_sysreg_s(ctxt_sys_reg(ctxt, VDISR_EL2), SYS_VDISR_EL2);
+	else
 		write_sysreg_s(ctxt_sys_reg(ctxt, DISR_EL1), SYS_VDISR_EL2);
 }
 
-- 
2.39.5


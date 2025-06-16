Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284863BB44
	for <kvmarm@lists.linux.dev>; Mon, 16 Jun 2025 23:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750115115; cv=none; b=Y5Dg+rC5WOC14vCbI9TrslCg6zL9T1ArvesTBfxr3kmyjb9wFzqnjeVImrum5+8ryQdHjDU/v/CpvFQ4CLVj5Ju5GQqjm4bsPXC5PkWa/5HGQ1K86xhMuhiS3L6DXswjsn61QX4ZXf1kW5i1y3qhpv7Tt3Bzb9OHX7eqg/UtumM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750115115; c=relaxed/simple;
	bh=wDMRyaGnjZJp0mmsgfuSHRPxhxxF5+yrG3T0dpjJZJo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=r0USe0JW3dK3t8H2wCJRDGEtI84tQ+c1glF1GYo0KBpKdzFRhjYl15tCFfQ7g70Hc4h402kf0gzIHp8kBgc59VRzCdSpoUUco4IRu3F52hR4i0OhWhcz8BJ7Po43vvu+8vWjOkzEWJn1WZ3hGA4+y6vHq7NmhLeKaTq+QEs2igs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HW9BWKH7; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HW9BWKH7"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750115111;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KNNaO6QF8J7FNSD8yD1YOGHYrOr+cZk9OYkV2IkmTFA=;
	b=HW9BWKH7OdsuWWe2Dzv3ebSkZ9+DBYNiJFm7MJBCiuMLt6SyGKloXMtwt7VFXF7x3u++iI
	taUyrejq8bMYsTzD4nPeUFRg2wDbfBeYrwC1x8s00flPHKeQpomAiqQlX3pGfVZ/yjVQvb
	bgQ332MPeRFPqdwCUukjcThzR7WALYE=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 18/27] KVM: arm64: nv: Handle effects of HCRX_EL2.TMEA on SError injection
Date: Mon, 16 Jun 2025 16:02:59 -0700
Message-Id: <20250616230308.1192565-19-oliver.upton@linux.dev>
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

HCRX_EL2.TMEA further modifies the physical SError behavior where
unmasked SErrors are taken to EL1 and masked SErrors are taken to EL2.
This gets a bit hairy when considering the fact that TMEA also enables
vSErrors, i.e. KVM has delegated the HW vSError context to the guest
hypervisor.

We can keep the vSError context ownership by taking advantage of a
couple properties:

 - If SErrors are unmasked, the 'physical' SError can be taken
   in-context immediately. In other words, KVM can emulate the EL1
   SError while preserving vEL2's ownership of the vSError context.

 - If SErrors are masked, the 'physical' SError is taken to EL2 and
   needs the usual nested exception entry.

Note that the new in-context handling has the benign effect where
unmasked SError injections are emulated even for non-nested VMs.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/inject_fault.c | 36 +++++++++++++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index cab14a926bc6..e689002f10b6 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -97,6 +97,11 @@ static bool effective_sctlr2_ease(struct kvm_vcpu *vcpu)
 	return __effective_sctlr2_bit(vcpu, SCTLR2_EL1_EASE_SHIFT);
 }
 
+static bool effective_sctlr2_nmea(struct kvm_vcpu *vcpu)
+{
+	return __effective_sctlr2_bit(vcpu, SCTLR2_EL1_NMEA_SHIFT);
+}
+
 static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr)
 {
 	unsigned long cpsr = *vcpu_cpsr(vcpu);
@@ -258,14 +263,29 @@ void kvm_inject_undefined(struct kvm_vcpu *vcpu)
 		inject_undef64(vcpu);
 }
 
+static bool serror_is_masked(struct kvm_vcpu *vcpu)
+{
+	bool masked = *vcpu_cpsr(vcpu) & PSR_A_BIT;
+
+	if (!vcpu_mode_priv(vcpu))
+		masked |= effective_sctlr2_nmea(vcpu);
+
+	return masked;
+}
+
 static bool kvm_serror_target_is_el2(struct kvm_vcpu *vcpu)
 {
-	return is_hyp_ctxt(vcpu) || vcpu_el2_amo_is_set(vcpu);
+	if (is_hyp_ctxt(vcpu) || vcpu_el2_amo_is_set(vcpu))
+		return true;
+
+	return serror_is_masked(vcpu) &&
+	       (__vcpu_sys_reg(vcpu, HCRX_EL2) & HCRX_EL2_TMEA);
 }
 
 static bool kvm_serror_undeliverable_at_el2(struct kvm_vcpu *vcpu)
 {
-	return !(vcpu_el2_tge_is_set(vcpu) || vcpu_el2_amo_is_set(vcpu));
+	return !(vcpu_el2_tge_is_set(vcpu) || vcpu_el2_amo_is_set(vcpu) ||
+		 effective_sctlr2_nmea(vcpu));
 }
 
 int kvm_inject_serror_esr(struct kvm_vcpu *vcpu, u64 esr)
@@ -281,6 +301,18 @@ int kvm_inject_serror_esr(struct kvm_vcpu *vcpu, u64 esr)
 		return 1;
 	}
 
+	/*
+	 * Emulate the exception entry if SErrors are unmasked. This is useful if
+	 * the vCPU is in a nested context w/ vSErrors enabled then we've already
+	 * delegated he hardware vSError context (i.e. HCR_EL2.VSE, VSESR_EL2,
+	 * VDISR_EL2) to the guest hypervisor.
+	 */
+	if (!serror_is_masked(vcpu)) {
+		pend_serror_exception(vcpu);
+		vcpu_write_sys_reg(vcpu, esr, exception_esr_elx(vcpu));
+		return 1;
+	}
+
 	vcpu_set_vsesr(vcpu, esr & ESR_ELx_ISS_MASK);
 	*vcpu_hcr(vcpu) |= HCR_VSE;
 	return 1;
-- 
2.39.5


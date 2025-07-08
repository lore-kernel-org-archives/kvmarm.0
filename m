Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55FC2E6133
	for <kvmarm@lists.linux.dev>; Tue,  8 Jul 2025 17:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751995646; cv=none; b=OX8Wacmwbbr+eENCaWM9DIlJ5yFXTvVzNxc+0qf2MiP3wG/V+HbQU2OYqA2AuId/MUxvkJPXB517GmK0OFL+Z7Xu1AkgDDXmzsFNRAtQXfeHmJq2qROvwxJYjHiRVcwbCv+ZB0j1AFCOijBZ2i+GkQx5qv5FOnf/J7FDXllgNI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751995646; c=relaxed/simple;
	bh=D2d5LNwp9M9xXJcDaAK4YMQkKbXqquQeqazi7k0zX9w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ujJKnDEcZB6Uzd2lQxoUopdvLTtGMXxy25p0P2AbjFd9JAHnjNQYnq/MMopK4cuGe1ii3MJYAYyYAk9DJ2haO9VIcYQivW6fVOnOGEbAgMFPv8alZnhB/ddF5Ro03JW6eWff6xdovMBENPRqqzHNvblN69bMIAhE925sIq5rIGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FxMaa4yI; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FxMaa4yI"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751995643;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7Q08i24j5L35mCYrhKn1JqFQOu7q4e4hkCIpJhz5fNQ=;
	b=FxMaa4yIaxM9Fpe9ASKz+1RYFhKNAMDCs8OfCJkUroXAuUbOw/hLJRKpmhEEKq8tEYZqtt
	Le10BV3bwqLXKUvVhzVDSnUmbOB+vwIIOlpe+5nIOKT0qFBtUoJBX8YfGpoCZTlhCrIuPY
	XbcxSh5urOH82wFDuevGmAGAAqR/OfI=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 18/27] KVM: arm64: nv: Take "masked" aborts to EL2 when HCRX_EL2.TMEA is set
Date: Tue,  8 Jul 2025 10:25:23 -0700
Message-Id: <20250708172532.1699409-19-oliver.upton@linux.dev>
In-Reply-To: <20250708172532.1699409-1-oliver.upton@linux.dev>
References: <20250708172532.1699409-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

HCRX_EL2.TMEA further modifies the external abort behavior where
unmasked aborts are taken to EL1 and masked aborts are taken to EL2.
It's rather weird when you consider that SEAs are, well, *synchronous*
and therefore not actually maskable. However, for the purposes of
exception routing, they're considered "masked" if the A flag is set.

This gets a bit hairier when considering the fact that TMEA
also enables vSErrors, i.e. KVM has delegated the HW vSError context to
the guest hypervisor.  We can keep the vSError context delegation as-is
by taking advantage of a couple properties:

 - If SErrors are unmasked, the 'physical' SError can be taken
   in-context immediately. In other words, KVM can emulate the EL1
   SError while preserving vEL2's ownership of the vSError context.

 - If SErrors are masked, the 'physical' SError is taken to EL2
   immediately and needs the usual nested exception entry.

Note that the new in-context handling has the benign effect where
unmasked SError injections are emulated even for non-nested VMs.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/inject_fault.c | 34 ++++++++++++++++++++++++++++++++--
 1 file changed, 32 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index cab14a926bc6..91efc3ed1774 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -204,7 +204,14 @@ static void __kvm_inject_sea(struct kvm_vcpu *vcpu, bool iabt, u64 addr)
 
 static bool kvm_sea_target_is_el2(struct kvm_vcpu *vcpu)
 {
-	return __vcpu_sys_reg(vcpu, HCR_EL2) & (HCR_TGE | HCR_TEA);
+	if (__vcpu_sys_reg(vcpu, HCR_EL2) & (HCR_TGE | HCR_TEA))
+		return true;
+
+	if (!vcpu_mode_priv(vcpu))
+		return false;
+
+	return (*vcpu_cpsr(vcpu) & PSR_A_BIT) &&
+	       (__vcpu_sys_reg(vcpu, HCRX_EL2) & HCRX_EL2_TMEA);
 }
 
 int kvm_inject_sea(struct kvm_vcpu *vcpu, bool iabt, u64 addr)
@@ -258,9 +265,20 @@ void kvm_inject_undefined(struct kvm_vcpu *vcpu)
 		inject_undef64(vcpu);
 }
 
+static bool serror_is_masked(struct kvm_vcpu *vcpu)
+{
+	return *vcpu_cpsr(vcpu) & PSR_A_BIT;
+}
+
 static bool kvm_serror_target_is_el2(struct kvm_vcpu *vcpu)
 {
-	return is_hyp_ctxt(vcpu) || vcpu_el2_amo_is_set(vcpu);
+	if (is_hyp_ctxt(vcpu) || vcpu_el2_amo_is_set(vcpu))
+		return true;
+
+	if (!(__vcpu_sys_reg(vcpu, HCRX_EL2) & HCRX_EL2_TMEA))
+		return false;
+
+	return serror_is_masked(vcpu);
 }
 
 static bool kvm_serror_undeliverable_at_el2(struct kvm_vcpu *vcpu)
@@ -281,6 +299,18 @@ int kvm_inject_serror_esr(struct kvm_vcpu *vcpu, u64 esr)
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


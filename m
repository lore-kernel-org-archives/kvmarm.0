Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B8EC2E6139
	for <kvmarm@lists.linux.dev>; Tue,  8 Jul 2025 17:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751995648; cv=none; b=TLAA1ItkP4EzMuME65um9xaIh652ab9uNCHFev8Pxjzg9VLLsnYL7idzG3q0kMRRzH1h6PRV22FkxRRiZ5FdLiNiFKqH4jiVu498CtPqpmMz9ta5t7ubtATmtRGhxpm9wPVAVpQUMuCjW7Mj3KYKOYWOQuom+q9AvAYOTBP2xKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751995648; c=relaxed/simple;
	bh=v5OLdYmMshZ5ttbGYHJVonD8mv6F6nPmCAuqc+6v5L0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UeiKAxT4gro+KXzTFH/EwwijKdUC4XjIojOgU8su7UDLBe2cpvOVqSRVmQTxVxQxKawDtFfXoZakUTT46mL5LTKAnnyOzRI9WB3bx8+5zjsbY9Bp2wkpElWIduYI/FKKkRtVx0oAqkQihGNhnS/Ch+GrbA0CfA/rQHjMdaDD/zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=n7HvhXVM; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="n7HvhXVM"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751995644;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+QwFnauqXZGhdlzCxoB/2hvoCgbFWf2/d2Bxg+qlFnI=;
	b=n7HvhXVMPazXi7Ko+X1jgRPtjUTm/qhBTjZ6GrRtEXvJ67fVY3dWuLzxBGRXt9DXCTL3gK
	rVUsI143qMfZQHlgVd8c5ojo58yQntB3B6rQmkCSf8mC46DrJMv+posd5cGQWzQIdjtDCs
	Z2b+XbGTYk8NjNC5fn2lMKHZ9WHIFlE=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 19/27] KVM: arm64: nv: Honor SError routing effects of SCTLR2_ELx.NMEA
Date: Tue,  8 Jul 2025 10:25:24 -0700
Message-Id: <20250708172532.1699409-20-oliver.upton@linux.dev>
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

As the name might imply, when NMEA is set SErrors are non-maskable and
can be taken regardless of PSTATE.A. As is the recurring theme with
DoubleFault2, the effects on SError routing are entirely backwards to
this.

If at EL1, NMEA is *not* considered for SError routing when TMEA is set
and the exception is taken to EL2 when PSTATE.A is set.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/inject_fault.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index 91efc3ed1774..37f45461e32c 100644
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
@@ -267,7 +272,7 @@ void kvm_inject_undefined(struct kvm_vcpu *vcpu)
 
 static bool serror_is_masked(struct kvm_vcpu *vcpu)
 {
-	return *vcpu_cpsr(vcpu) & PSR_A_BIT;
+	return (*vcpu_cpsr(vcpu) & PSR_A_BIT) && !effective_sctlr2_nmea(vcpu);
 }
 
 static bool kvm_serror_target_is_el2(struct kvm_vcpu *vcpu)
@@ -278,6 +283,19 @@ static bool kvm_serror_target_is_el2(struct kvm_vcpu *vcpu)
 	if (!(__vcpu_sys_reg(vcpu, HCRX_EL2) & HCRX_EL2_TMEA))
 		return false;
 
+	/*
+	 * In another example where FEAT_DoubleFault2 is entirely backwards,
+	 * "masked" as it relates to the routing effects of HCRX_EL2.TMEA
+	 * doesn't consider SCTLR2_EL1.NMEA. That is to say, even if EL1 asked
+	 * for non-maskable SErrors, the EL2 bit takes priority if A is set.
+	 */
+	if (vcpu_mode_priv(vcpu))
+		return *vcpu_cpsr(vcpu) & PSR_A_BIT;
+
+	/*
+	 * Otherwise SErrors are considered unmasked when taken from EL0 and
+	 * NMEA is set.
+	 */
 	return serror_is_masked(vcpu);
 }
 
-- 
2.39.5


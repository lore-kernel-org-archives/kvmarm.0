Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869982E03E0
	for <kvmarm@lists.linux.dev>; Tue,  8 Jul 2025 17:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751995645; cv=none; b=t/SoKvov7RunjWV1s8Lq61b3b1Esf5cr7BATopqMcmtd+1mj9/Pmq6LBNZCujt9SicvyRRIlXSDpZOdzshX7HiYAdlsJ4Z7CDdPSZM0srrE5ch1ztP8GihMSs4pINm2nIzINVhEmb7R1bP3JfQz29iZuNyE3iBizJWPA4qsg76k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751995645; c=relaxed/simple;
	bh=AdbW29q7p7vmoPxrg7JG3hDasescXvB7yCQVSNe9AOU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rBF9kOhxbPSOCM5E9k4ccOXBj1p3w+R/t1WXNFG8tLCiwy2QKtSNtx6YHPmB7gttEMbq1bI1LdvIlBYMoXpxHXNXD5gIuZJXhnaA6iotzdFcM+uX3YwUZ5nNSwtCihMpEYsRufkh9KURHOv5aVzCgCpedhn8eCrOtDlpn0pFfgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lqiCQoqr; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lqiCQoqr"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751995641;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lCiL+2cvqix5Me/GWyEgFnezlFGiBGZIzcynzYNabZU=;
	b=lqiCQoqrOlojBzgzC5qvQr4jgzdULvZ3VYg5ivzXO/SvCY+aEeGy+mXeRG1zwUFp4RjeqX
	Mx9VVxoeVGQRVstPE12guMmRO372iqH3x+tT5yqXuOcpVClv6i1avPfpaFGr7JRDbuw4YF
	2M9/2JoRHA9Y6MIIORoY1RpfGL9Vwd0=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 17/27] KVM: arm64: Route SEAs to the SError vector when EASE is set
Date: Tue,  8 Jul 2025 10:25:22 -0700
Message-Id: <20250708172532.1699409-18-oliver.upton@linux.dev>
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

One of the finest additions of FEAT_DoubleFault2 is the ability for
software to request *synchronous* external aborts be taken to the
SError vector, which of coure are *asynchronous* in nature.

Opinions be damned, implement the architecture and send SEAs to the
SError vector if EASE is set for the target context.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/emulate-nested.c |  4 ++++
 arch/arm64/kvm/hyp/exception.c  |  6 +++++-
 arch/arm64/kvm/inject_fault.c   | 38 ++++++++++++++++++++++++++++++++-
 3 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index ff53109caa05..90cb4b7ae0ff 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2834,6 +2834,10 @@ int kvm_inject_nested_sea(struct kvm_vcpu *vcpu, bool iabt, u64 addr)
 	esr |= ESR_ELx_FSC_EXTABT | ESR_ELx_IL;
 
 	vcpu_write_sys_reg(vcpu, FAR_EL2, addr);
+
+	if (__vcpu_sys_reg(vcpu, SCTLR2_EL2) & SCTLR2_EL1_EASE)
+		return kvm_inject_nested(vcpu, esr, except_type_serror);
+
 	return kvm_inject_nested_sync(vcpu, esr);
 }
 
diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
index 592adc78b149..7dafd10e52e8 100644
--- a/arch/arm64/kvm/hyp/exception.c
+++ b/arch/arm64/kvm/hyp/exception.c
@@ -339,6 +339,10 @@ static void kvm_inject_exception(struct kvm_vcpu *vcpu)
 			enter_exception64(vcpu, PSR_MODE_EL1h, except_type_sync);
 			break;
 
+		case unpack_vcpu_flag(EXCEPT_AA64_EL1_SERR):
+			enter_exception64(vcpu, PSR_MODE_EL1h, except_type_serror);
+			break;
+
 		case unpack_vcpu_flag(EXCEPT_AA64_EL2_SYNC):
 			enter_exception64(vcpu, PSR_MODE_EL2h, except_type_sync);
 			break;
@@ -353,7 +357,7 @@ static void kvm_inject_exception(struct kvm_vcpu *vcpu)
 
 		default:
 			/*
-			 * Only EL1_SYNC and EL2_{SYNC,IRQ,SERR} makes
+			 * Only EL1_{SYNC,SERR} and EL2_{SYNC,IRQ,SERR} makes
 			 * sense so far. Everything else gets silently
 			 * ignored.
 			 */
diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index 88bc85ecdbb0..cab14a926bc6 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -65,13 +65,49 @@ static void pend_sync_exception(struct kvm_vcpu *vcpu)
 		kvm_pend_exception(vcpu, EXCEPT_AA64_EL2_SYNC);
 }
 
+static void pend_serror_exception(struct kvm_vcpu *vcpu)
+{
+	if (exception_target_el(vcpu) == PSR_MODE_EL1h)
+		kvm_pend_exception(vcpu, EXCEPT_AA64_EL1_SERR);
+	else
+		kvm_pend_exception(vcpu, EXCEPT_AA64_EL2_SERR);
+}
+
+static bool __effective_sctlr2_bit(struct kvm_vcpu *vcpu, unsigned int idx)
+{
+	u64 sctlr2;
+
+	if (!kvm_has_sctlr2(vcpu->kvm))
+		return false;
+
+	if (is_nested_ctxt(vcpu) &&
+	    !(__vcpu_sys_reg(vcpu, HCRX_EL2) & HCRX_EL2_SCTLR2En))
+		return false;
+
+	if (exception_target_el(vcpu) == PSR_MODE_EL1h)
+		sctlr2 = vcpu_read_sys_reg(vcpu, SCTLR2_EL1);
+	else
+		sctlr2 = vcpu_read_sys_reg(vcpu, SCTLR2_EL2);
+
+	return sctlr2 & BIT(idx);
+}
+
+static bool effective_sctlr2_ease(struct kvm_vcpu *vcpu)
+{
+	return __effective_sctlr2_bit(vcpu, SCTLR2_EL1_EASE_SHIFT);
+}
+
 static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr)
 {
 	unsigned long cpsr = *vcpu_cpsr(vcpu);
 	bool is_aarch32 = vcpu_mode_is_32bit(vcpu);
 	u64 esr = 0;
 
-	pend_sync_exception(vcpu);
+	/* This delight is brought to you by FEAT_DoubleFault2. */
+	if (effective_sctlr2_ease(vcpu))
+		pend_serror_exception(vcpu);
+	else
+		pend_sync_exception(vcpu);
 
 	/*
 	 * Build an {i,d}abort, depending on the level and the
-- 
2.39.5


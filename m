Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD18F3BB44
	for <kvmarm@lists.linux.dev>; Mon, 16 Jun 2025 23:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750115109; cv=none; b=PIogkhgM1jM7+jpcq25UsIXj/G5fE20GW99mOkvQHfua3C7xi7wxSK9gmEw7IPC6/2IIhL0Mjh29StmIga3te1/vxMgiUuV+vDIlxJFAqGhxu977WpyXyIDz1EJUAS9SjCmpzU1QJ1NGMYxTVQqoWSB+HncJOUYDYrD59/ek28k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750115109; c=relaxed/simple;
	bh=YwSRGybyvsENtMq2SyJSljl+1pZuMunVD2+HH95008A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=l834JFnJmOPOYvX8aS9+TJde68ZngrRf2kS4HnJ1+ROzzwZJ3q1od9e9GOll2pXlgHel/JrFAHkTysu3JBBYxftYWA6mTZDzCcAjXNuZX0JIUTUan0pekF5YXm8DjnaP5MfD/Sbu9VWgjpkjQZsmBYSO9x6r+Ie92XumGXDr5mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TURjKJ0U; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TURjKJ0U"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750115106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6M4hDy3PBAESdrXH5UcAlOOxwpM5uqptQszJh64bMLs=;
	b=TURjKJ0Uuw/XcYEwAhQYGdsD+dXiGsTU1kEb1zL5OICn7W4ZVFtp0AecvSsr6tgH/Z33oG
	iKeAzVgA/wVNig5nA77DD2wgWyQA2pByu0kEDntX9AymSitmlqf8poGZwrAxF2DdmdRnuI
	Iswn5PvkHlp+y9SpEoIcC8VYPYGhEfc=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 15/27] KVM: arm64: Factor out helper for selecting exception target EL
Date: Mon, 16 Jun 2025 16:02:56 -0700
Message-Id: <20250616230308.1192565-16-oliver.upton@linux.dev>
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

Pull out the exception target selection from pend_sync_exception() for
general use. Use PSR_MODE_ELxh as a shorthand for the target EL, as
SP_ELx selection is handled further along in the hyp's exception
emulation.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/inject_fault.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index 10773a8ef4cb..4df42a41d0ab 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -15,13 +15,11 @@
 #include <asm/kvm_nested.h>
 #include <asm/esr.h>
 
-static void pend_sync_exception(struct kvm_vcpu *vcpu)
+static unsigned int exception_target_el(struct kvm_vcpu *vcpu)
 {
 	/* If not nesting, EL1 is the only possible exception target */
-	if (likely(!vcpu_has_nv(vcpu))) {
-		kvm_pend_exception(vcpu, EXCEPT_AA64_EL1_SYNC);
-		return;
-	}
+	if (likely(!vcpu_has_nv(vcpu)))
+		return PSR_MODE_EL1h;
 
 	/*
 	 * With NV, we need to pick between EL1 and EL2. Note that we
@@ -32,23 +30,25 @@ static void pend_sync_exception(struct kvm_vcpu *vcpu)
 	switch(*vcpu_cpsr(vcpu) & PSR_MODE_MASK) {
 	case PSR_MODE_EL2h:
 	case PSR_MODE_EL2t:
-		kvm_pend_exception(vcpu, EXCEPT_AA64_EL2_SYNC);
-		break;
+		return PSR_MODE_EL2h;
 	case PSR_MODE_EL1h:
 	case PSR_MODE_EL1t:
-		kvm_pend_exception(vcpu, EXCEPT_AA64_EL1_SYNC);
-		break;
+		return PSR_MODE_EL1h;
 	case PSR_MODE_EL0t:
-		if (vcpu_el2_tge_is_set(vcpu))
-			kvm_pend_exception(vcpu, EXCEPT_AA64_EL2_SYNC);
-		else
-			kvm_pend_exception(vcpu, EXCEPT_AA64_EL1_SYNC);
-		break;
+		return vcpu_el2_tge_is_set(vcpu) ? PSR_MODE_EL2h : PSR_MODE_EL1h;
 	default:
 		BUG();
 	}
 }
 
+static void pend_sync_exception(struct kvm_vcpu *vcpu)
+{
+	if (exception_target_el(vcpu) == PSR_MODE_EL1h)
+		kvm_pend_exception(vcpu, EXCEPT_AA64_EL1_SYNC);
+	else
+		kvm_pend_exception(vcpu, EXCEPT_AA64_EL2_SYNC);
+}
+
 static bool match_target_el(struct kvm_vcpu *vcpu, unsigned long target)
 {
 	return (vcpu_get_flag(vcpu, EXCEPT_MASK) == target);
-- 
2.39.5


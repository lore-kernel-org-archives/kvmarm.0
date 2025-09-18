Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 180F923D2B1
	for <kvmarm@lists.linux.dev>; Thu, 18 Sep 2025 16:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758214006; cv=none; b=nn5n4ojaXWSoxEen+o8i1Nedc74MHTX6mzSKfJU+j+alj7QZkUqYZgxHUlTRm5QAEvLkMw2Hvntgtc8yuSAktUVhlTKnKYPF/ke7a0LTCf0CMX3XVYhMGi8uJMO4mDhzNC2W3scqY9GFlG3zc8I9sZARyrJhRkTikHurogAC84U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758214006; c=relaxed/simple;
	bh=3m5M5zktCjBtLkJfG0wy9s1rfY5VamPZHa500XDywbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sk83ipTrOx33NP9RJunnf2ipOLsty9EstGTEw8J8ISZatjtckKpATQAyUAsYZG35ZsHEwrpz+K+mzhss44590wF7C25CPTe32g+CEYoK8ESqBgHtf1ISslHtxJlaVVDXTcfiN2hY91hZAIes3iRhZIbOBBzc7Tu6Rdm434NnAkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sJBgImYu; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sJBgImYu"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758214003;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7aMu11Qvc+NzehRpue7UZztcDlq9y5VVKgPcgsyE8Ho=;
	b=sJBgImYuStARH9qjTMKoWzKlCGkkhBeyVYN7MCHYuWYSmzFAxpMtCnZN39TWHeKspRZYdI
	XfFiqJ6oMXuiOgzk9H41eTFUlS7dlvwj/KGNJB+zFbjiYPdjNjNwpYANxJ0wXo6QSnhjs/
	4JNiVT2wQ19IdD8qKI308YsDmL3odvA=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 1/2] KVM: arm64: nv: Treat AMO as 1 when at EL2 and {E2H,TGE} = {1, 0}
Date: Thu, 18 Sep 2025 09:46:31 -0700
Message-ID: <20250918164632.410404-2-oliver.upton@linux.dev>
In-Reply-To: <20250918164632.410404-1-oliver.upton@linux.dev>
References: <20250918164632.410404-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

SErrors are not deliverable at EL2 when the effective value of
HCR_EL2.{TGE,AMO} = {0, 0}. This is bothersome to deal with in nested
as we need to use auxiliary pending state to track the pending vSError
since HCR_EL2.VSE has no mechanism for honoring the guest HCR. On top of
that, we have no way of making that auxiliary pending state visible in
ISR_EL1.

A defect against the architecture now allows an implementation to treat
HCR_EL2.AMO as 1 when HCR_EL2.{E2H,TGE} = {1, 0}. Let's do exactly that,
meaning SErrors are always deliverable at EL2 for the typical E2H=RES1
VM.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_emulate.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index fa8a08a1ccd5..64ce3fec73ee 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -220,6 +220,20 @@ static inline bool vcpu_el2_tge_is_set(const struct kvm_vcpu *vcpu)
 
 static inline bool vcpu_el2_amo_is_set(const struct kvm_vcpu *vcpu)
 {
+	/*
+	 * DDI0487L.b Known Issue D22105
+	 *
+	 * When executing at EL2 and HCR_EL2.{E2H,TGE} = {1, 0} it is
+	 * IMPLEMENTATION DEFINED whether the effective value of HCR_EL2.AMO
+	 * is the value programmed or 1.
+	 *
+	 * Make the implementation choice of treating the effective value as 1 as
+	 * we cannot subsequently catch changes to TGE or AMO that would
+	 * otherwise lead to the SError becoming deliverable.
+	 */
+	if (vcpu_is_el2(vcpu) && vcpu_el2_e2h_is_set(vcpu) && !vcpu_el2_tge_is_set(vcpu))
+		return true;
+
 	return ctxt_sys_reg(&vcpu->arch.ctxt, HCR_EL2) & HCR_AMO;
 }
 
-- 
2.47.3


Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2D11B4C2C
	for <kvmarm@lists.linux.dev>; Thu, 20 Jun 2024 16:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718902052; cv=none; b=CW+B/UYoF3hapP6bBDG+sWrwMFkRcRhdSLA5IFDOtxuxBVDQps4awdtXIsOufYqdNLwNS9GLePtSlXKokZYubGE4FykI6QSINQBrOzVty8bJuMhomS0LJBjAzQ6iQCUdpdSde4MASNdOQfHEdeveEUFoh85H/txOH9gm59vIhUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718902052; c=relaxed/simple;
	bh=JhlcTE0mw0HU+iuzSo6ZzaFOPAAQYm8aEXGIEqANUU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jmi+GlDHtokHvnu5VdSbl2xKj4nRI7nCsZOjcw/x1vHnRZwKmZu10e21ZSXmrhFfwu0ca8Ai4H3WjSm/jsm7DDKl9OhjEwzUKvGY0RH6gJ5BrE5GeyITPfHI03inspXz9BI6p9S8fghlEpQ7em5c6hVGt9fdvWoZKKmHZkBKVmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mpVMlspE; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mpVMlspE"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718902048;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XgzC9jsNkREHCUhV560SZO3nTwTBAoSv9nxx7koTnRo=;
	b=mpVMlspEn7MfQU+uw/7tjCUhzacdSE837YPJ122MIE681FjCo4rrYtdw9ngfsE1ljDQoir
	apP2T4uBARCJhs1EMp40Zng7RU0x2JccTQOVFLa1D40ZekkkjU//0YAw3BgZPywoNdaxRn
	DF2xsZdFxT5DnmSZH7tn+8slTdL842g=
X-Envelope-To: maz@kernel.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: tabba@google.com
X-Envelope-To: oliver.upton@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org,
	Fuad Tabba <tabba@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 14/15] KVM: arm64: nv: Add additional trap setup for CPTR_EL2
Date: Thu, 20 Jun 2024 16:46:51 +0000
Message-ID: <20240620164653.1130714-15-oliver.upton@linux.dev>
In-Reply-To: <20240620164653.1130714-1-oliver.upton@linux.dev>
References: <20240620164653.1130714-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Marc Zyngier <maz@kernel.org>

We need to teach KVM a couple of new tricks. CPTR_EL2 and its
VHE accessor CPACR_EL1 need to be handled specially:

- CPACR_EL1 is trapped on VHE so that we can track the TCPAC
  and TTA bits

- CPTR_EL2.{TCPAC,E0POE} are propagated from L1 to L2

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/vhe/switch.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index b0b1935a3626..d30fee61fb17 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -87,11 +87,23 @@ static void __activate_cptr_traps(struct kvm_vcpu *vcpu)
 		__activate_traps_fpsimd32(vcpu);
 	}
 
+	if (!vcpu_has_nv(vcpu))
+		goto write;
+
+	/*
+	 * The architecture is a bit crap (what a surprise): an EL2 guest
+	 * writing to CPTR_EL2 via CPACR_EL1 can't set any of TCPAC or TTA,
+	 * as they are RES0 in the guest's view. To work around it, trap the
+	 * sucker using the very same bit it can't set...
+	 */
+	if (vcpu_el2_e2h_is_set(vcpu) && is_hyp_ctxt(vcpu))
+		val |= CPTR_EL2_TCPAC;
+
 	/*
 	 * Layer the guest hypervisor's trap configuration on top of our own if
 	 * we're in a nested context.
 	 */
-	if (!vcpu_has_nv(vcpu) || is_hyp_ctxt(vcpu))
+	if (is_hyp_ctxt(vcpu))
 		goto write;
 
 	cptr = vcpu_sanitised_cptr_el2(vcpu);
@@ -115,6 +127,11 @@ static void __activate_cptr_traps(struct kvm_vcpu *vcpu)
 	if (!(SYS_FIELD_GET(CPACR_ELx, ZEN, cptr) & BIT(0)))
 		val &= ~CPACR_ELx_ZEN;
 
+	if (kvm_has_feat(vcpu->kvm, ID_AA64MMFR3_EL1, S2POE, IMP))
+		val |= cptr & CPACR_ELx_E0POE;
+
+	val |= cptr & CPTR_EL2_TCPAC;
+
 write:
 	write_sysreg(val, cpacr_el1);
 }
-- 
2.45.2.741.gdbec12cfda-goog


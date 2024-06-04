Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503C7146019
	for <kvmarm@lists.linux.dev>; Tue,  4 Jun 2024 13:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717506360; cv=none; b=KprOxnJ9kINaNsFeDXEAL0FbstUVYeYn1+AtyGVerjlXYpTyNthzPOJwQc2FfBtmjqiHfYyqMQzlujmOdP+mjsLpDEvvVeh6+dPMxMzWlnmceTIh+0PGkcHwARah6rrknwZXcwXPmEHZE6H/aMS7NiUSTw0EF7lmtz+nFP3kOIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717506360; c=relaxed/simple;
	bh=dO+XJF3nG67IaCEKh9GyqHtcBuKo4Q0opdhUqxQxqTw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sDwZNG4lZBBVVmfjdV5kHJ41lF10vDRGPFMPEdnO+/OsXeMWP61CB+UH1dDy+YQVfZUWi4iq7WXHUfK1tkdYObLZnJKrqo3T/HLakhAetZdYX+xtjHa991wiffEOBvRILx4DB1F2kkdhA7lFvpbZWqxzuvVHKG95f8KruJdjKyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UrbEAVI+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UrbEAVI+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC6A7C4AF09;
	Tue,  4 Jun 2024 13:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717506359;
	bh=dO+XJF3nG67IaCEKh9GyqHtcBuKo4Q0opdhUqxQxqTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UrbEAVI+riz8pCuwSQlERH90z54PEMkp1QGJouQR7aVT70prddRrRa6p8OHoKUt8p
	 L1KHvLZEgml6UybMWz2ibI2aSnjX4NCRTD6hDe1+CrCFYQ4ucN6DveQgsq38Ft0U4f
	 6DrCS44Wh95eAuI3ozC6Xf6vq1UygXgdHqrXVosXGIOVmCggEKs4Zw79SSDzlDpBFO
	 aDYPp1jzjQdgaP1haAPvJcnqFIIB9zxKhUscJFaauLgKbADQdt7KXqTDV3dxGHB2+f
	 YeFMMC3mpv/eP5KzZ/9bwudXUBttos/8oGSbfHVhICa/m5+vIU/CpCMX2KojnBMXiq
	 LMrwy9DDqrsAQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sETrR-000ZSS-UM;
	Tue, 04 Jun 2024 14:05:58 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>
Subject: [PATCH 3/4] KVM: arm64: nv: Add additional trap setup for CPTR_EL2
Date: Tue,  4 Jun 2024 14:05:52 +0100
Message-Id: <20240604130553.199981-4-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240604130553.199981-1-maz@kernel.org>
References: <20240604130553.199981-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We need to teach KVM a couple of new tricks. CPTR_EL2 and its
VHE accessor CPACR_EL1 need to be handled specially:

- CPACR_EL1 is trapped on VHE so that we can track the TCPAC
  and TTA bits

- CPTR_EL2.{TCPAC,E0POE} are propagated from L1 to L2

As a consequence of CPTR_EL2 being always trapped, we update
vcpu_sanitised_cptr_el2() so that it doesn't try to read from
the CPU registers, but from the shadow copy (ensuring that we
always have up-to-date TCPAC and TTA bits).

This helper will also be used when handling the CPTR_EL1 trap.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h |  2 +-
 arch/arm64/kvm/hyp/vhe/switch.c      | 23 ++++++++++++++++++++++-
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index e86de04ba1c4..cc5c93b46e6f 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -607,7 +607,7 @@ static __always_inline void kvm_reset_cptr_el2(struct kvm_vcpu *vcpu)
  */
 static inline u64 vcpu_sanitised_cptr_el2(const struct kvm_vcpu *vcpu)
 {
-	u64 cptr = vcpu_read_sys_reg(vcpu, CPTR_EL2);
+	u64 cptr = __vcpu_sys_reg(vcpu, CPTR_EL2);
 
 	if (!vcpu_el2_e2h_is_set(vcpu))
 		cptr = translate_cptr_el2_to_cpacr_el1(cptr);
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index d07b4f4be5e5..b4ba236526d6 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -67,6 +67,8 @@ static u64 __compute_hcr(struct kvm_vcpu *vcpu)
 
 static void __activate_cptr_traps(struct kvm_vcpu *vcpu)
 {
+	u64 cptr;
+
 	/*
 	 * With VHE (HCR.E2H == 1), accesses to CPACR_EL1 are routed to
 	 * CPTR_EL2. In general, CPACR_EL1 has the same layout as CPTR_EL2,
@@ -85,11 +87,23 @@ static void __activate_cptr_traps(struct kvm_vcpu *vcpu)
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
 
 	if (guest_hyp_fpsimd_traps_enabled(vcpu))
@@ -97,6 +111,13 @@ static void __activate_cptr_traps(struct kvm_vcpu *vcpu)
 	if (guest_hyp_sve_traps_enabled(vcpu))
 		val &= ~CPACR_ELx_ZEN;
 
+	cptr = vcpu_sanitised_cptr_el2(vcpu);
+
+	if (kvm_has_feat(vcpu->kvm, ID_AA64MMFR3_EL1, S2POE, IMP))
+		val |= cptr & CPACR_ELx_E0POE;
+
+	val |= cptr & CPTR_EL2_TCPAC;
+
 write:
 	write_sysreg(val, cpacr_el1);
 }
-- 
2.39.2


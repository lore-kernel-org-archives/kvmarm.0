Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9F61B4C25
	for <kvmarm@lists.linux.dev>; Thu, 20 Jun 2024 16:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718902048; cv=none; b=alr3tm0k2SoVAjpCHD7ZypYifDEJcuFWb3zMkZp+Pj+zPnB2QwgN9deHQYS3/KkGnB3heUU9fVPuOl9VhnMReO5n+bpC5xvuGOYKYIiiPb5sjW6Cd/1YVAl0qXziNiu/gN2bneGMUfuXDrD7pvIMkTni1Dkdp03U5JOZN/ialQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718902048; c=relaxed/simple;
	bh=C5LEmrBiHT1xTeApGrYyneEYQCpGBT/Ty7lSjeiHStA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p8Eo9hXv/DJ9vZB1NcXa0mW3uBuZykywWS7bEWV6lsIUCneSFWK1/99vfkxu5RS5uw66p8cskegbx7Gr3o5JKlu34shnqTTAwDnO0NiIogokSphKY9KRuykjjlpFhRauC5BHq5yDylckA354fFidHVjmvLJNY6y/fo77VOU12x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=alz0b7Wp; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="alz0b7Wp"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718902042;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sHh2kb1Z2Qr4oSw9MwaKbtA4JNckM/+p9o6iCRwIjxg=;
	b=alz0b7WpkSSpddQOfhfzSGKS499wvF8Z7tQOLbIx1gKByOgmXA9Z6REO1oDwnpjcs/Uf2j
	EuEMumEnZRREdD+hJqOKp8NJhRsh/OckI2lFcCNi4Au4fb4Sz5Kt2sUT2NHlwB+/03aIG6
	xkv1KZUD9bGtm5BnpveWuFQb8YLXwq0=
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
Subject: [PATCH v3 11/15] KVM: arm64: nv: Honor guest hypervisor's FP/SVE traps in CPTR_EL2
Date: Thu, 20 Jun 2024 16:46:48 +0000
Message-ID: <20240620164653.1130714-12-oliver.upton@linux.dev>
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

Start folding the guest hypervisor's FP/SVE traps into the value
programmed in hardware. Note that as of writing this is dead code, since
KVM does a full put() / load() for every nested exception boundary which
saves + flushes the FP/SVE state.

However, this will become useful when we can keep the guest's FP/SVE
state alive across a nested exception boundary and the host no longer
needs to conservatively program traps.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/vhe/switch.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 925de4b4efd2..b0b1935a3626 100644
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
@@ -85,6 +87,35 @@ static void __activate_cptr_traps(struct kvm_vcpu *vcpu)
 		__activate_traps_fpsimd32(vcpu);
 	}
 
+	/*
+	 * Layer the guest hypervisor's trap configuration on top of our own if
+	 * we're in a nested context.
+	 */
+	if (!vcpu_has_nv(vcpu) || is_hyp_ctxt(vcpu))
+		goto write;
+
+	cptr = vcpu_sanitised_cptr_el2(vcpu);
+
+	/*
+	 * Pay attention, there's some interesting detail here.
+	 *
+	 * The CPTR_EL2.xEN fields are 2 bits wide, although there are only two
+	 * meaningful trap states when HCR_EL2.TGE = 0 (running a nested guest):
+	 *
+	 *  - CPTR_EL2.xEN = x0, traps are enabled
+	 *  - CPTR_EL2.xEN = x1, traps are disabled
+	 *
+	 * In other words, bit[0] determines if guest accesses trap or not. In
+	 * the interest of simplicity, clear the entire field if the guest
+	 * hypervisor has traps enabled to dispel any illusion of something more
+	 * complicated taking place.
+	 */
+	if (!(SYS_FIELD_GET(CPACR_ELx, FPEN, cptr) & BIT(0)))
+		val &= ~CPACR_ELx_FPEN;
+	if (!(SYS_FIELD_GET(CPACR_ELx, ZEN, cptr) & BIT(0)))
+		val &= ~CPACR_ELx_ZEN;
+
+write:
 	write_sysreg(val, cpacr_el1);
 }
 
-- 
2.45.2.741.gdbec12cfda-goog


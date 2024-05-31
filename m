Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C02184E0D
	for <kvmarm@lists.linux.dev>; Fri, 31 May 2024 23:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717197269; cv=none; b=VVN+lZbj1YP7PidNo6x5kJiFk6KfVG+s930DWmqPeJPba4BZlL5eFoPvDH0LGjeIE4tvDI93Kj6q7TpEIZbqCelzNk+fygP29ZoOgR463Lqd6ItgsSEVH/iyo46OdDFW1y6QTF3NZaYM9/r6tPobpzsiqGITr54QbS06MfWN1fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717197269; c=relaxed/simple;
	bh=nMYzFR2GeW5jABgWn0vERxXMPr2OBYm1bZSnsEWweRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=abO2ddsbJWlz7rqLAPmNay1098TWnIfKoJTSXZn7qnaP1/0SOOiDYxBR1akNfApbzVVMgJTepTDIdfvQwg6bC1w5X9ayIH1qSccKDrylK07fwYOZsqsCxwscB28v5HQJtJvxQBGmV6PSgxLpOpI1MncYp8ngPcHKDm3Io4VEeQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IKyOHz3D; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IKyOHz3D"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717197265;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g4BHYD2b8D9Lda/PSro18tcaFWkJMsLX9PrrgsuerwE=;
	b=IKyOHz3DCgiWZNiYe9L9GrJ95rnlDHFr6cIsRcJeqY/pfWXL+Es7gCHlcZcrDDgFDtluHv
	VyycjykXVAeQzEeoYSFGA5EVEGBTWT20hzenNOiCKXk33DWBO1SyHgHqUTnsxOdrZuvpcZ
	ShJyzlRqk0/8yCgL+6/ACpJWgdgYK8A=
X-Envelope-To: maz@kernel.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: oliver.upton@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 07/11] KVM: arm64: nv: Use guest hypervisor's max VL when running nested guest
Date: Fri, 31 May 2024 23:13:54 +0000
Message-ID: <20240531231358.1000039-8-oliver.upton@linux.dev>
In-Reply-To: <20240531231358.1000039-1-oliver.upton@linux.dev>
References: <20240531231358.1000039-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The max VL for nested guests is additionally constrained by the max VL
selected by the guest hypervisor. Use that instead of KVM's max VL when
running a nested guest.

Note that the guest hypervisor's ZCR_EL2 is sanitised against the VM's
max VL at the time of access, so there's no additional handling required
at the time of use.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index e1e888340739..d806a0c1d556 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -314,10 +314,22 @@ static bool kvm_hyp_handle_mops(struct kvm_vcpu *vcpu, u64 *exit_code)
 
 static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
 {
+	/*
+	 * The vCPU's saved SVE state layout always matches the max VL of the
+	 * vCPU. Start off with the max VL so we can load the SVE state.
+	 */
 	sve_cond_update_zcr_vq(vcpu_sve_max_vq(vcpu) - 1, SYS_ZCR_EL2);
 	__sve_restore_state(vcpu_sve_pffr(vcpu),
 			    &vcpu->arch.ctxt.fp_regs.fpsr);
 
+	/*
+	 * The effective VL for a VM could differ from the max VL when running a
+	 * nested guest, as the guest hypervisor could select a smaller VL. Slap
+	 * that into hardware before wrapping up.
+	 */
+	if (vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu))
+		sve_cond_update_zcr_vq(__vcpu_sys_reg(vcpu, ZCR_EL2), SYS_ZCR_EL2);
+
 	write_sysreg_el1(vcpu_sve_zcr_el1(vcpu), SYS_ZCR);
 }
 
-- 
2.45.1.288.g0e0cd299f1-goog


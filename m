Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD69472F6D;
	Wed, 22 Jul 2026 07:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784706182; cv=none; b=uYnOaxXnBFbHaMUrIwq+OppFmGJlk2sFiG96Pim2BxsQqBGr3fTUpoxRY4H8cQX2rCeHy87rBGxYue8GPOqW/QYzZGGwMKiYA1vu7DE4Nje/ngwXHKZR7jgtA+K7vGyY7joqwtkJB2IL53MStpLivcV+kojJUw6qxTOJG5TR7W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784706182; c=relaxed/simple;
	bh=3bsYBG1M9IuaTrqk3vHFO+kV2dV3d9oCSPOs8XXGKTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X+WjvfX75hR/+26VF+tLj39nqye31PU+tQliy3MWrDEqe5EUDUXzA3CE/+jI2jJ2HnFYk96O3uHWn2GqOpesPeL9UVkpi4FIcsOpisL2ACLBDzT9I72tnPzrru2SsI1v6Zv8p4NZmxbAhcodHxhurWSqTQWqbrJsL4MRiPHVCFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iNr85lId; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iNr85lId"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B3F1F00ADE;
	Wed, 22 Jul 2026 07:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784706179;
	bh=3ZzWfhxSs7Ijv/NWxS+JT1yf5R5x2XicAoTTuuWFkWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iNr85lIdopQKg3l7KZqWYrfH6e27xuHIjSRVwfzH1F4Kj99TUXok4c8KDiDh0UwJs
	 wvO5noUB14cAPBMy9F9pgWWmydSVFMWmr0F2PXs3mvqvr1MUglLJc4lsS+cSQTn9TA
	 30W1ZHsc9bV1Fz62z0tVDmgVKnBZ0SFXpZxyGGPElydqdf4nSMJJvwdLMkYPa5Ee7G
	 bXJbH/ZOnSXc1tpvp5SP1i0xJgMeVj8zF2wvCDZ1KcCqPFYzQZcytdZM0jKrdWXZER
	 gcTNV+mL/1mT/oeFI0PW+EbjH9qpPiYoXhDv/QM+/0PZ3UroK4edCUsooPeQCVZdSe
	 Hjiola0Sek0ZQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wmRbW-00000007VfN-1Dlb;
	Wed, 22 Jul 2026 07:42:58 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v3 18/28] KVM: arm64: Add kvm_has_nv{2,3}() predicates
Date: Wed, 22 Jul 2026 08:42:24 +0100
Message-ID: <20260722074234.3330999-19-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260722074234.3330999-1-maz@kernel.org>
References: <20260722074234.3330999-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, yaoyuan@linux.alibaba.com, weilin.chang@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Add a new set of predicates indicating whether VM is capable of
NV2, NV3, and is in a nested NV3 context.

This is going to become useful as we start dealing with a mix of
behaviours (NV2, NV3, NV2 on NV3...).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 9831166695186..c562d8171d5e1 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -266,6 +266,26 @@ static inline bool vserror_state_is_nested(struct kvm_vcpu *vcpu)
 	       (__vcpu_sys_reg(vcpu, HCRX_EL2) & HCRX_EL2_TMEA);
 }
 
+static inline bool kvm_has_nv2(struct kvm *kvm)
+{
+	return (cpus_have_final_cap(ARM64_HAS_NESTED_VIRT) &&
+		kvm_has_feat(kvm, ID_AA64MMFR4_EL1, NV_frac, NV2_ONLY));
+}
+
+static inline bool kvm_has_nv3(struct kvm *kvm)
+{
+	return (cpus_have_final_cap(ARM64_HAS_NESTED_VIRT) &&
+		cpus_have_final_cap(ARM64_HAS_NV3) &&
+		kvm_has_feat(kvm, ID_AA64MMFR4_EL1, NV_frac, NV3));
+}
+
+static inline bool is_nested_nv3_ctxt(struct kvm_vcpu *vcpu)
+{
+	return (has_vhe() && kvm_has_nv3(vcpu->kvm) && is_nested_ctxt(vcpu) &&
+		(__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_EL2_NV) &&
+		(__vcpu_sys_reg(vcpu, HCRX_EL2) & HCRX_EL2_NVTGE));
+}
+
 /*
  * The layout of SPSR for an AArch32 state is different when observed from an
  * AArch64 SPSR_ELx or an AArch32 SPSR_*. This function generates the AArch32
-- 
2.47.3


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 303A93BB10B;
	Thu, 30 Jul 2026 07:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785395466; cv=none; b=N3B5sxMSZqzKJunyJiVMIVLemR3DB/NM0nWmVe7bOoH3fTpdUlvKLWEtzqxoqVpePE5PEr7IqAIERyjMdX8i7scC1ITRQfaSsJ9K+JQZ+ux2mFW0s8SdDjFeGUCngVOvHhSMetkhtd20h+xdRzQrB9tFBnvQdOtkeUJibGZIDOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785395466; c=relaxed/simple;
	bh=Ctm60o0xAufdR3O8pdvaLg0AXjj7b4MUSwEs8kEpTXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tRcdt0D/2Cbl482fd7QUeP/mPRUQeJ56VQcWV21QnxI9o0ngcILsW8F24pXYCQIh/ix1FxxUCz9O8NzgCWQAN2T2/Nb0apdx420ab0I1+jXKm2iUTlviuayYBSKMxM/LQ4qEVck2PbHEvfCFtn/EtKOTQqxPXneJMakus3C+mwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SSBp+4jp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SSBp+4jp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDF7E1F01564;
	Thu, 30 Jul 2026 07:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785395453;
	bh=JAhWhZje9gmOpJhtyVPvANp/6kcIKzyOvMGnE5qE5Xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SSBp+4jpb1EWcn9BcacpjFcmc1dj4Xz9sU0xd3TFoPMuQ2q7JoQ9UFGMAUVLVBbjc
	 vB9atIHrq9B0r3IkwkeKbdOay1V7ujcU1dMMYiLMGaOAJhNBCIj/g+44AATLU7OgBg
	 yp6vfMFShyv5XhOCxiQxd0HqvWkKyYC2M+CGC3HDDsUc31+fFN48uSmNiPGV+Q+1er
	 I6Vri6GULZk8Q19PS7YHzDEl6SGIQGHErpm1lJqFvaQMkH9L/0dSIE+XKp70o+/ON8
	 F2WMVE0VZz5zOazzZ/s0ZZTPCmdjeNzHr4YzYEWqQPy+DV9M/SmGXi921pRdu6QyBZ
	 gt2o0gGzImG2A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wpKuq-0000000AOpW-18cG;
	Thu, 30 Jul 2026 07:10:52 +0000
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
	Wei-Lin Chang <weilin.chang@arm.com>,
	Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH v4 18/29] KVM: arm64: Add kvm_has_nv{2,3}() predicates
Date: Thu, 30 Jul 2026 08:10:11 +0100
Message-ID: <20260730071022.296811-19-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260730071022.296811-1-maz@kernel.org>
References: <20260730071022.296811-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, yaoyuan@linux.alibaba.com, weilin.chang@arm.com, vladimir.murzin@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Add a new set of predicates indicating whether VM is capable of
NV2, NV3, and is in a nested NV3 context.

This is going to become useful as we start dealing with a mix of
behaviours (NV2, NV3, NV2 on NV3...).

Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 9831166695186..bdb7dfaa271cd 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -266,6 +266,25 @@ static inline bool vserror_state_is_nested(struct kvm_vcpu *vcpu)
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
+	return (cpus_have_final_cap(ARM64_HAS_NV3) &&
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


Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF2F12F5B6
	for <kvmarm@lists.linux.dev>; Fri, 31 May 2024 23:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717197264; cv=none; b=X/5DP2WDqGxUXhD7hVhhyikBLjsyI8Y54BXvgTsCPhKgPmMBR1kcAS/W69n/H3xAaXL0ybb4e7DtoQJZe1LBLX6yOckGCJZHRsKyBX6kwZqvwKABbY6mgdU8RyVTjR4pJJRLL5yYYmgW5pk6+PODmRIhfE0jd7yxKAiLJbMud3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717197264; c=relaxed/simple;
	bh=6D8D9i3XydQ+ncxh2tn2cwLi/WZrfPVtOsD55yigttk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fUWP51Cd2npUoIwp3xJeLDe/GCc3HgSCyZb+Xj+vE67XCc/hLTayymYedWv08WeNkGHtW6/JzuVsVRtovjLG8zKaYpPsbICD2ApZzlO+DHe10fROMVubwWjVcRshJqYvUzl7JJc0qJPT2rVFoyHlEM+F5GaA4+lbfa3ygFhzhZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AeGkZ8V6; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AeGkZ8V6"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717197260;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=75vx2xB9G5elNFx0s0w58jNdeKZ7431l9UtTNZ3JoLI=;
	b=AeGkZ8V6qH123pi/2ON6eEU4ZxQHMkyQSxnpI/nu32ea1Q5IRnUdISmt66aoGphk6RBG/r
	lmjV99oUot34W+ghks1l7BCoFhsjyr2rLXsA0m4Xg+loSNgJjECqKa2xyHmVlK5b5FOn1a
	mYqCHO+4Aiw47HUh1eL2RjctdV7O5gc=
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
Subject: [PATCH 04/11] KVM: arm64: nv: Load guest hyp's ZCR into EL1 state
Date: Fri, 31 May 2024 23:13:51 +0000
Message-ID: <20240531231358.1000039-5-oliver.upton@linux.dev>
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

Load the guest hypervisor's ZCR_EL2 into the corresponding EL1 register
when restoring SVE state, as ZCR_EL2 affects the VL in the hypervisor
context.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h       | 4 ++++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 3 ++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 8170c04fde91..e01e6de414f1 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -844,6 +844,10 @@ struct kvm_vcpu_arch {
 
 #define vcpu_sve_max_vq(vcpu)	sve_vq_from_vl((vcpu)->arch.sve_max_vl)
 
+#define vcpu_sve_zcr_el1(vcpu)						\
+	(unlikely(is_hyp_ctxt(vcpu)) ? __vcpu_sys_reg(vcpu, ZCR_EL2) :	\
+				       __vcpu_sys_reg(vcpu, ZCR_EL1))
+
 #define vcpu_sve_state_size(vcpu) ({					\
 	size_t __size_ret;						\
 	unsigned int __vcpu_vq;						\
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 5872eaafc7f0..e1e888340739 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -317,7 +317,8 @@ static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
 	sve_cond_update_zcr_vq(vcpu_sve_max_vq(vcpu) - 1, SYS_ZCR_EL2);
 	__sve_restore_state(vcpu_sve_pffr(vcpu),
 			    &vcpu->arch.ctxt.fp_regs.fpsr);
-	write_sysreg_el1(__vcpu_sys_reg(vcpu, ZCR_EL1), SYS_ZCR);
+
+	write_sysreg_el1(vcpu_sve_zcr_el1(vcpu), SYS_ZCR);
 }
 
 /*
-- 
2.45.1.288.g0e0cd299f1-goog


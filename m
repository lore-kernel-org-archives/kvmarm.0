Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D4E1B29A8
	for <kvmarm@lists.linux.dev>; Thu, 20 Jun 2024 16:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718902031; cv=none; b=k8c/krMfyhuRthOR5ZT8b4AXtk8P9Nu0/BbQCM4yYZYyHtO+LZmZmTuU+tT4R1yxfDk1TwihGH/8pNObZe3nZTgReO/tFu1js0xwR+p21fQZ5QzG8hS3y29kx29S0mH5ULqSEV6rP9X7oBs0GwWyYY4q85gIjb4lbqONihMSroE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718902031; c=relaxed/simple;
	bh=ETX0LQ7kYSg7RqI/4kAd77n7iye+m5txnswDWv+x1iI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i6kJiTZSpwMPU7eC8TWgA4GaIdS6qShPhsBAfYCCktf295XAf8xQoBCCkcYXV4aa9rGsynkpbsNCNlsDduMkASorK9c2uwlp9+esS5R6XT/LAmIPb86gHnGO99bL1x5m/Ssw0VZY+CmAjIU8UUBaUQ5V6ScOlgN/APRFAHfHGB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lcnSzIhx; arc=none smtp.client-ip=95.215.58.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lcnSzIhx"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718902026;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H05WUL/HhblgxcxQS07XCyaa2Ay55FYE9vwptiKKacE=;
	b=lcnSzIhxLamBw3LAgU4LdacXsVx2zETov7WpP36KoPfoeZh2NHgOtCXK6tSSIk/B9zTxtm
	lT2DBf6zX9yTYS3b3n4GvTk2KJ8vUNFcqNbx99K4dDAuWmYWi7NFiRBFJmrsvA29StLHLj
	gBQ1rd10TnXC29zOCTwkxF63Cyfdz7U=
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
Subject: [PATCH v3 02/15] KVM: arm64: nv: Forward SVE traps to guest hypervisor
Date: Thu, 20 Jun 2024 16:46:39 +0000
Message-ID: <20240620164653.1130714-3-oliver.upton@linux.dev>
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

Similar to FPSIMD traps, don't load SVE state if the guest hypervisor
has SVE traps enabled and forward the trap instead. Note that ZCR_EL2
will require some special handling, as it takes a sysreg trap to EL2
when HCR_EL2.NV = 1.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_emulate.h    | 4 ++++
 arch/arm64/kvm/handle_exit.c            | 3 +++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 2 ++
 3 files changed, 9 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index c3c5a5999ed7..cc5c93b46e6f 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -641,5 +641,9 @@ static inline bool guest_hyp_fpsimd_traps_enabled(const struct kvm_vcpu *vcpu)
 	return __guest_hyp_cptr_xen_trap_enabled(vcpu, FPEN);
 }
 
+static inline bool guest_hyp_sve_traps_enabled(const struct kvm_vcpu *vcpu)
+{
+	return __guest_hyp_cptr_xen_trap_enabled(vcpu, ZEN);
+}
 
 #endif /* __ARM64_KVM_EMULATE_H__ */
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 59fe9b10a87a..e4f74699f360 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -217,6 +217,9 @@ static int kvm_handle_unknown_ec(struct kvm_vcpu *vcpu)
  */
 static int handle_sve(struct kvm_vcpu *vcpu)
 {
+	if (guest_hyp_sve_traps_enabled(vcpu))
+		return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));
+
 	kvm_inject_undefined(vcpu);
 	return 1;
 }
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index b302d32f8326..428ee15dd6ae 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -348,6 +348,8 @@ static bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 	case ESR_ELx_EC_SVE:
 		if (!sve_guest)
 			return false;
+		if (guest_hyp_sve_traps_enabled(vcpu))
+			return false;
 		break;
 	default:
 		return false;
-- 
2.45.2.741.gdbec12cfda-goog


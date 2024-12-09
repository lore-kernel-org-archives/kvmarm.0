Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB56154BFC
	for <kvmarm@lists.linux.dev>; Mon,  9 Dec 2024 18:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733767803; cv=none; b=ND7mlFb2OLK0t3X8/8uh/MwZJjYy1cTLEn0pRQmDRhRagkHWbAvcDHv8CHJar6MNkandzpcZaofAW3TA/6+cRGpMWrFBhAvjy0bRXh3G5VqlFbqvLdAsS7wzgguF2RY2RGFTBlpJie/02PWPI+gM4HAZggrC6q/wgqoFGvePA4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733767803; c=relaxed/simple;
	bh=s21/VGzOAcWsk6ZZ3h9MvAo46uX+bw5mgu6/8DbwR28=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dyEb4lCzRPP3AwDtPgrrH6AOxa4zoBlYEHhtLGapgWvPsJW2nVf6+JxotTzLtoguSeOZJEmFwVX+tZ3+/afOIBM9FonxPYSTOW9s5i92E5hVJmqyRkKgGIc0tFNNYslnVGbcvdNryVdN8RbdxLTzP7yrterV5FH1DugM7deX+5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lnHsN/m+; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lnHsN/m+"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1733767799;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Sx6KjOSn7Gcgp+Q0vi8+Sq/9E1GpL/6vDkLxaOIsHvY=;
	b=lnHsN/m+klRw46nsvsnt4irodhpyInaTCII77q76ZgxHBhdjoVkgV0pEI+c9K2KnIkXojb
	fSUC96WVnlrElerv8rs3W9fY9D52UEk0CF/Cs+wN0VHkGW099hwbimIrjQbpHeAxPgHTPA
	ywbdktuh36tpX9CjqNQZJ4clddLWjfA=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	James Clark <james.clark@linaro.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 07/16] KVM: arm64: Select debug state to save/restore based on debug owner
Date: Mon,  9 Dec 2024 10:09:17 -0800
Message-Id: <20241209180926.2161373-8-oliver.upton@linux.dev>
In-Reply-To: <20241209180926.2161373-1-oliver.upton@linux.dev>
References: <20241209180926.2161373-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Select the set of debug registers to use based on the owner rather than
relying on debug_ptr. Besides the code cleanup, this allows us to
eliminate a couple instances kern_hyp_va() as well.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h         |  2 ++
 arch/arm64/kvm/hyp/include/hyp/debug-sr.h | 23 +++++++++++++++++++----
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f65b30bab0ab..5ef1b2f69e89 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1357,6 +1357,8 @@ void kvm_debug_set_guest_ownership(struct kvm_vcpu *vcpu);
 #define kvm_vcpu_os_lock_enabled(vcpu)		\
 	(!!(__vcpu_sys_reg(vcpu, OSLSR_EL1) & OSLSR_EL1_OSLK))
 
+#define kvm_debug_regs_in_use(vcpu)		\
+	((vcpu)->arch.debug_owner != VCPU_DEBUG_FREE)
 #define kvm_host_owns_debug_regs(vcpu)		\
 	((vcpu)->arch.debug_owner == VCPU_DEBUG_HOST_OWNED)
 
diff --git a/arch/arm64/kvm/hyp/include/hyp/debug-sr.h b/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
index d00093699aaf..9e3051225039 100644
--- a/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
@@ -88,6 +88,21 @@
 	default:	write_debug(ptr[0], reg, 0);			\
 	}
 
+static struct kvm_guest_debug_arch *__vcpu_debug_regs(struct kvm_vcpu *vcpu)
+{
+	switch (vcpu->arch.debug_owner) {
+	case VCPU_DEBUG_FREE:
+		WARN_ON_ONCE(1);
+		fallthrough;
+	case VCPU_DEBUG_GUEST_OWNED:
+		return &vcpu->arch.vcpu_debug_state;
+	case VCPU_DEBUG_HOST_OWNED:
+		return &vcpu->arch.external_debug_state;
+	}
+
+	return NULL;
+}
+
 static void __debug_save_state(struct kvm_guest_debug_arch *dbg,
 			       struct kvm_cpu_context *ctxt)
 {
@@ -132,13 +147,13 @@ static inline void __debug_switch_to_guest_common(struct kvm_vcpu *vcpu)
 	struct kvm_guest_debug_arch *host_dbg;
 	struct kvm_guest_debug_arch *guest_dbg;
 
-	if (!vcpu_get_flag(vcpu, DEBUG_DIRTY))
+	if (!kvm_debug_regs_in_use(vcpu))
 		return;
 
 	host_ctxt = host_data_ptr(host_ctxt);
 	guest_ctxt = &vcpu->arch.ctxt;
 	host_dbg = host_data_ptr(host_debug_state.regs);
-	guest_dbg = kern_hyp_va(vcpu->arch.debug_ptr);
+	guest_dbg = __vcpu_debug_regs(vcpu);
 
 	__debug_save_state(host_dbg, host_ctxt);
 	__debug_restore_state(guest_dbg, guest_ctxt);
@@ -151,13 +166,13 @@ static inline void __debug_switch_to_host_common(struct kvm_vcpu *vcpu)
 	struct kvm_guest_debug_arch *host_dbg;
 	struct kvm_guest_debug_arch *guest_dbg;
 
-	if (!vcpu_get_flag(vcpu, DEBUG_DIRTY))
+	if (!kvm_debug_regs_in_use(vcpu))
 		return;
 
 	host_ctxt = host_data_ptr(host_ctxt);
 	guest_ctxt = &vcpu->arch.ctxt;
 	host_dbg = host_data_ptr(host_debug_state.regs);
-	guest_dbg = kern_hyp_va(vcpu->arch.debug_ptr);
+	guest_dbg = __vcpu_debug_regs(vcpu);
 
 	__debug_save_state(guest_dbg, guest_ctxt);
 	__debug_restore_state(host_dbg, host_ctxt);
-- 
2.39.5


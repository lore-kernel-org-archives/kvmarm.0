Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D8D1E1C2B
	for <kvmarm@lists.linux.dev>; Fri,  8 Nov 2024 22:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731104702; cv=none; b=HP9M6braXCF2chjfpi4gsIt6l8uvnQuLIYKVRDFdF26JLrfzOrn4KPlBklgWYDZTThTnVjawymDXaQY2eGaxh6ulRdWIo1DL9PsOrq4pVmIzX0m99dv+gJKBaUlMtW0lvkg/1mw5Xf855bUZs+SIQFwefRS+ikg0Wf/OCmFcdfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731104702; c=relaxed/simple;
	bh=hs6VQgcFQyZdn/xJSfAA4LeMucik7IzhE3DEjChi9xU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QF8yKbR+QnvTni8WfVnQl2xbdUtEsadT0W8Jj7MQPU+Bu80KXLpSKXFnJcxHGO67uRBTHy3Za7TTqz9YMouYOthzDXdGbiUeJZ1U7W1wpOnrfxFLZ+G0OJqB+JUwoera6Jaq1e1h82cPcp+8Qk5Inn4v2HQp/UKvCFfkXedNytA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LNPPF9Di; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LNPPF9Di"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731104699;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0JMewhVBljb5Oee+kNcTUhRONf1rXURSMcvcw1GcMa4=;
	b=LNPPF9Di4g2kmb8dkoOrel4kUetEKNRlOOBciU4P1/DyKGgrKyvdAduCNbscxkX3BDnK5c
	DsFZMfr1A/mv9Jz318IahiUPof/Sw6NoMiDuCET0SpmT9xCf2zjFKwUBP35Wuts3Ym941r
	Rdoqg1daUOKVgzy+bbenRZH5F7CoBL0=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 08/15] KVM: arm64: Select debug state to save/restore based on debug owner
Date: Fri,  8 Nov 2024 14:24:12 -0800
Message-Id: <20241108222418.1677420-9-oliver.upton@linux.dev>
In-Reply-To: <20241108222418.1677420-1-oliver.upton@linux.dev>
References: <20241108222418.1677420-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Select the set of debug registers to use based on the owner rather than
relying on debug_ptr.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h         | 21 +++++++++++++++++++++
 arch/arm64/kvm/hyp/include/hyp/debug-sr.h |  8 ++++----
 2 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index d76e4e44b65b..2d9aee66d5d4 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1357,9 +1357,30 @@ void kvm_handle_debug_access(struct kvm_vcpu *vcpu);
 #define kvm_vcpu_os_lock_enabled(vcpu)		\
 	(!!(__vcpu_sys_reg(vcpu, OSLSR_EL1) & OSLSR_EL1_OSLK))
 
+#define kvm_debug_regs_in_use(vcpu)		\
+	((vcpu)->arch.debug_owner != VCPU_DEBUG_FREE)
 #define kvm_host_owns_debug_regs(vcpu)		\
 	((vcpu)->arch.debug_owner == VCPU_DEBUG_HOST_OWNED)
 
+#define vcpu_debug_regs(vcpu)					\
+({								\
+	struct kvm_guest_debug_arch *__d;			\
+								\
+	switch ((vcpu)->arch.debug_owner) {			\
+	case VCPU_DEBUG_FREE:					\
+		WARN_ON_ONCE(1);				\
+		fallthrough;					\
+	case VCPU_DEBUG_GUEST_OWNED:				\
+		__d = &(vcpu)->arch.vcpu_debug_state;		\
+		break;						\
+	case VCPU_DEBUG_HOST_OWNED:				\
+		__d = &(vcpu)->arch.external_debug_state;	\
+		break;						\
+	}							\
+								\
+	__d;							\
+})
+
 int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
 			       struct kvm_device_attr *attr);
 int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
diff --git a/arch/arm64/kvm/hyp/include/hyp/debug-sr.h b/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
index d00093699aaf..acc47f77b3d0 100644
--- a/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
@@ -132,13 +132,13 @@ static inline void __debug_switch_to_guest_common(struct kvm_vcpu *vcpu)
 	struct kvm_guest_debug_arch *host_dbg;
 	struct kvm_guest_debug_arch *guest_dbg;
 
-	if (!vcpu_get_flag(vcpu, DEBUG_DIRTY))
+	if (!kvm_debug_regs_in_use(vcpu))
 		return;
 
 	host_ctxt = host_data_ptr(host_ctxt);
 	guest_ctxt = &vcpu->arch.ctxt;
 	host_dbg = host_data_ptr(host_debug_state.regs);
-	guest_dbg = kern_hyp_va(vcpu->arch.debug_ptr);
+	guest_dbg = vcpu_debug_regs(vcpu);
 
 	__debug_save_state(host_dbg, host_ctxt);
 	__debug_restore_state(guest_dbg, guest_ctxt);
@@ -151,13 +151,13 @@ static inline void __debug_switch_to_host_common(struct kvm_vcpu *vcpu)
 	struct kvm_guest_debug_arch *host_dbg;
 	struct kvm_guest_debug_arch *guest_dbg;
 
-	if (!vcpu_get_flag(vcpu, DEBUG_DIRTY))
+	if (!kvm_debug_regs_in_use(vcpu))
 		return;
 
 	host_ctxt = host_data_ptr(host_ctxt);
 	guest_ctxt = &vcpu->arch.ctxt;
 	host_dbg = host_data_ptr(host_debug_state.regs);
-	guest_dbg = kern_hyp_va(vcpu->arch.debug_ptr);
+	guest_dbg = vcpu_debug_regs(vcpu);
 
 	__debug_save_state(guest_dbg, guest_ctxt);
 	__debug_restore_state(host_dbg, host_ctxt);
-- 
2.39.5


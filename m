Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C58C1C07CB
	for <kvmarm@lists.linux.dev>; Thu, 19 Dec 2024 22:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734648110; cv=none; b=GOEzwE2VDF0WH1hoiq3AGWk24g1BRsAqs2NmhzhUNbdfOqTKYIFouQb1pA3nDkztREBb+/W8xwnbgyvehRMqQu+79dFzApL2lc6GRjLAFR+VN7kZTS8Fjs7okjhA801W1aJjtVHRVXz2IG1KKvYEqGrenFCBzxC3qn4Qwv3rfUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734648110; c=relaxed/simple;
	bh=zG1nWhE9FttCC0xmt2+w7O0G9ljXUhFKavFZhFaTGi0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rCzMOdD+EXpsJgDeS0uZ1MBVd7OknTzurXK/LaEuq5DsXrrLQS6ZLPgsIPGaz1pzsqFHXl4Z7CyDIjA89ZxlZZlQFSY1XqGYqsUvJ8ha8FBXSu7Mdc84IEMUgx9GuLGuGnzya0iOvZOYbHL2NZMv2zqTDuqOkXy7BdNQdiGeNfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RqedTGkF; arc=none smtp.client-ip=95.215.58.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RqedTGkF"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1734648106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HrieGFunAmQCNClD5ycM0IGAI4ncinyGjMgaNYcbpBI=;
	b=RqedTGkFAwVmuZrgAGhf3YmmyPhavhrB6XfgEkqGqgrQyGa/XZpa3jidI1eAE/hnUsKzeQ
	ub9qYS5A9aNtmIOJcb6pPbd6DcF/Pb/bNlQjE9sUFwRl6B2fiG81cxoLdAEaT4LSp1h+kt
	F0Gg8LdtHNuLMpop+XzJDW84Gqb/wzQ=
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
Subject: [PATCH v4 08/19] KVM: arm64: Select debug state to save/restore based on debug owner
Date: Thu, 19 Dec 2024 14:41:05 -0800
Message-Id: <20241219224116.3941496-9-oliver.upton@linux.dev>
In-Reply-To: <20241219224116.3941496-1-oliver.upton@linux.dev>
References: <20241219224116.3941496-1-oliver.upton@linux.dev>
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

Tested-by: James Clark <james.clark@linaro.org>
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


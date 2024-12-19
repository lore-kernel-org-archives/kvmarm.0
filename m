Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8041C07CB
	for <kvmarm@lists.linux.dev>; Thu, 19 Dec 2024 22:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734648106; cv=none; b=Ijg55D2HxQI5ExVG54homlASBkiSOmEM/K0ut+JF9Q/OLyXm5i+i2LyTe1kTopx7dbYjutStEgxbyz2rkE0NWtwIJXIz+a4TV2Q5YYtjK6WZCXsjhJ0LMJPPkOyGv7lGydyP4D62pXNVYLiztnxGS2rcYsZn8QWwPAwvSQzWoLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734648106; c=relaxed/simple;
	bh=iehCLGvr1x46u485zbE/juoCWh9z4xbA2vtBTglCBrQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eqXAYy5GT/TiHZfdMQfCLP0TkSRCHeIWWoZQIztLOr9BmnejF0s75Qp1Um2HW5evmr4CfBBPIAHnhBgz27+6Sd0hjGqTChXNStkgLbMPArngJOkIaEDIa278vqOh7BLdyT/RDiwX5T1pzjJpLW/G2FTPPmPO+ZiVfP+wBAG2pdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UdAJJ2p0; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UdAJJ2p0"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1734648102;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0iSDZy4BfV7h0Ji7ydbHPt9zQbHsf+xvQ8lUuY70hL8=;
	b=UdAJJ2p0d36rEbQaNTEKKzeCeTZniyFq3JMtsFT7PjIJc5toNuhDMo77/XhTok/1AQnsFz
	HZl+U91L9Dq5UAiQrwc/I1Ia/yAdlXxO8hUFODdMR4wggJaawmw3kQngd6gRTmgbUqkBBK
	xk9nDkVEKYVdbEEduTI2Z5t/QHlZpG8=
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
Subject: [PATCH v4 06/19] KVM: arm64: Evaluate debug owner at vcpu_load()
Date: Thu, 19 Dec 2024 14:41:03 -0800
Message-Id: <20241219224116.3941496-7-oliver.upton@linux.dev>
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

In preparation for tossing the debug_ptr mess, introduce an enumeration
to track the ownership of the debug registers while in the guest. Update
the owner at vcpu_load() based on whether the host needs to steal the
guest's debug context or if breakpoints/watchpoints are actively in use.

Tested-by: James Clark <james.clark@linaro.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h | 11 ++++++++
 arch/arm64/kvm/arm.c              |  1 +
 arch/arm64/kvm/debug.c            | 46 +++++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c         |  2 ++
 4 files changed, 60 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index d196bf0fce52..f65b30bab0ab 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -756,6 +756,12 @@ struct kvm_vcpu_arch {
 	struct kvm_guest_debug_arch vcpu_debug_state;
 	struct kvm_guest_debug_arch external_debug_state;
 
+	enum {
+		VCPU_DEBUG_FREE,
+		VCPU_DEBUG_HOST_OWNED,
+		VCPU_DEBUG_GUEST_OWNED,
+	} debug_owner;
+
 	/* VGIC state */
 	struct vgic_cpu vgic_cpu;
 	struct arch_timer_cpu timer_cpu;
@@ -1345,10 +1351,15 @@ void kvm_arm_vcpu_init_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu);
+void kvm_vcpu_load_debug(struct kvm_vcpu *vcpu);
+void kvm_debug_set_guest_ownership(struct kvm_vcpu *vcpu);
 
 #define kvm_vcpu_os_lock_enabled(vcpu)		\
 	(!!(__vcpu_sys_reg(vcpu, OSLSR_EL1) & OSLSR_EL1_OSLK))
 
+#define kvm_host_owns_debug_regs(vcpu)		\
+	((vcpu)->arch.debug_owner == VCPU_DEBUG_HOST_OWNED)
+
 int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
 			       struct kvm_device_attr *attr);
 int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 3822774840e1..a068337da52a 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -598,6 +598,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	kvm_vgic_load(vcpu);
 	kvm_timer_vcpu_load(vcpu);
+	kvm_vcpu_load_debug(vcpu);
 	if (has_vhe())
 		kvm_vcpu_load_vhe(vcpu);
 	kvm_arch_vcpu_load_fp(vcpu);
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index f01597f89067..3222729a559d 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -317,3 +317,49 @@ void kvm_init_host_debug_data(void)
 	    !(read_sysreg_s(SYS_TRBIDR_EL1) & TRBIDR_EL1_P))
 		host_data_set_flag(HAS_TRBE);
 }
+
+void kvm_vcpu_load_debug(struct kvm_vcpu *vcpu)
+{
+	u64 mdscr;
+
+	/* Must be called before kvm_vcpu_load_vhe() */
+	KVM_BUG_ON(vcpu_get_flag(vcpu, SYSREGS_ON_CPU), vcpu->kvm);
+
+	/*
+	 * Determine which of the possible debug states we're in:
+	 *
+	 *  - VCPU_DEBUG_HOST_OWNED: KVM has taken ownership of the guest's
+	 *    breakpoint/watchpoint registers, or needs to use MDSCR_EL1 to do
+	 *    software step or emulate the effects of the OS Lock being enabled.
+	 *
+	 *  - VCPU_DEBUG_GUEST_OWNED: The guest has debug exceptions enabled, and
+	 *    the breakpoint/watchpoint registers need to be loaded eagerly.
+	 *
+	 *  - VCPU_DEBUG_FREE: Neither of the above apply, no breakpoint/watchpoint
+	 *    context needs to be loaded on the CPU.
+	 */
+	if (vcpu->guest_debug || kvm_vcpu_os_lock_enabled(vcpu)) {
+		vcpu->arch.debug_owner = VCPU_DEBUG_HOST_OWNED;
+	} else {
+		mdscr = vcpu_read_sys_reg(vcpu, MDSCR_EL1);
+
+		if (mdscr & (MDSCR_EL1_KDE | MDSCR_EL1_MDE))
+			vcpu->arch.debug_owner = VCPU_DEBUG_GUEST_OWNED;
+		else
+			vcpu->arch.debug_owner = VCPU_DEBUG_FREE;
+	}
+}
+
+/*
+ * Updates ownership of the debug registers after a trapped guest access to a
+ * breakpoint/watchpoint register. Host ownership of the debug registers is of
+ * strictly higher priority, and it is the responsibility of the VMM to emulate
+ * guest debug exceptions in this configuration.
+ */
+void kvm_debug_set_guest_ownership(struct kvm_vcpu *vcpu)
+{
+	if (kvm_host_owns_debug_regs(vcpu))
+		return;
+
+	vcpu->arch.debug_owner = VCPU_DEBUG_GUEST_OWNED;
+}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index e2a5c2918d9e..e45a096be669 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -656,6 +656,7 @@ static bool trap_debug_regs(struct kvm_vcpu *vcpu,
 	if (p->is_write)
 		vcpu_set_flag(vcpu, DEBUG_DIRTY);
 
+	kvm_debug_set_guest_ownership(vcpu);
 	trace_trap_reg(__func__, r->reg, p->is_write, p->regval);
 
 	return true;
@@ -684,6 +685,7 @@ static void reg_to_dbg(struct kvm_vcpu *vcpu,
 	val |= (p->regval & (mask >> shift)) << shift;
 	*dbg_reg = val;
 
+	kvm_debug_set_guest_ownership(vcpu);
 	vcpu_set_flag(vcpu, DEBUG_DIRTY);
 }
 
-- 
2.39.5


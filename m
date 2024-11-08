Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B39D1DE896
	for <kvmarm@lists.linux.dev>; Fri,  8 Nov 2024 22:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731104696; cv=none; b=JIL8LWhxrlA7j/RvP+DrIy+7WascA0ZvwYXsDtcrdZxs+7HLSLdGS3lQqVK85Z4x2WuI4jGQdVb6ltH+TbBJzzRhRVJBZW3Uabsjx3KNPoNSM/FzWbcY+LwRCrWG7gu0DBk8KNH+8CjizPhAASQ22YzKrQv08030QNA78ZdKLx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731104696; c=relaxed/simple;
	bh=pzMEgZ0cCKxbR8Ki7kJGZSbn2mPflnDXtuupE4LeE2M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JB9IIQ9AwHX4qnBhYicWIaC3LNWI0b4zhPx39jPAHBhnUslcVbZAWAl+ONsieGXE8Ff0mULzwbkdF/La96MdHrnmKGe9N8CGOBSm+juGrRQ/BRWp/pSEhJdtFSN2OQ5orKkvLPPiJxfoqyC1pPyr2ZtQviNQxOO60A+YCyx5rFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XgSu9NXd; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XgSu9NXd"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731104693;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xPj8Cqstn6hlWS1zlDDmAUdgx8D+IUrp/0Ts6Bscyrk=;
	b=XgSu9NXd76opuN1Z3ZH6NLzLgnZJRTdIvpa7mk13H5ml8RsVg1qYeJ2KlJNBLMVIpNB3EQ
	WBaUTYwkS+fb6pwi5o74Uh85tnlvRKGUfpXVx8ygun7F5nVv1Bs1op1c4Z6GSQ7CVpTj/X
	OlDEyEke6QVvw5Hg+iltngj894H4Spw=
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
Subject: [PATCH 05/15] KVM: arm64: Evaluate debug owner at vcpu_load()
Date: Fri,  8 Nov 2024 14:24:09 -0800
Message-Id: <20241108222418.1677420-6-oliver.upton@linux.dev>
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

In preparation for tossing the debug_ptr mess, introduce an enumeration
to track the ownership of the debug registers while in the guest. Update
the owner at vcpu_load() based on whether the host needs to steal the
guest's debug context or if breakpoints/watchpoints are actively in use.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h | 10 ++++++++++
 arch/arm64/kvm/arm.c              |  1 +
 arch/arm64/kvm/debug.c            | 23 +++++++++++++++++++++++
 3 files changed, 34 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index cf5cdc468aa4..f954b082dc4f 100644
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
@@ -1345,10 +1351,14 @@ void kvm_arm_vcpu_init_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu);
+void kvm_vcpu_load_debug(struct kvm_vcpu *vcpu);
 
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
index 97d0c6fd5f61..e2798a4eec47 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -313,3 +313,26 @@ void kvm_init_host_debug_data(void)
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
+	if (vcpu->guest_debug || kvm_vcpu_os_lock_enabled(vcpu)) {
+		vcpu->arch.debug_owner = VCPU_DEBUG_HOST_OWNED;
+	} else {
+		mdscr = vcpu_read_sys_reg(vcpu, MDSCR_EL1);
+
+		/*
+		 * Eagerly restore the debug state if the debugger is actively
+		 * in use
+		 */
+		if (mdscr & (MDSCR_EL1_KDE | MDSCR_EL1_MDE))
+			vcpu->arch.debug_owner = VCPU_DEBUG_GUEST_OWNED;
+		else
+			vcpu->arch.debug_owner = VCPU_DEBUG_FREE;
+	}
+}
-- 
2.39.5


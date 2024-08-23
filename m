Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64BAD80C02
	for <kvmarm@lists.linux.dev>; Fri, 23 Aug 2024 21:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724448451; cv=none; b=J5bF1V5yrpiHviw/R//V/x7x4OItX8pLHmVAxeOpv+WGq3mXHvrR3l8UvSdtZWJfy5n0ccsciTO7FGoMfgsYDU0VdMjU01QCNlLmEa/SKvhWo2lP8mfLlBXKbsPu3ArpkQYbymV5rFUQNBvo8jngmHBDefqO+/QoX1/yd+gI9gE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724448451; c=relaxed/simple;
	bh=9pIaf7gNuQnMFIaWAZZyQ/6h+d05+Q52J/y+cvwUOkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fUvU75LYAjCGwZJvVHvnGSOwbdBQQE/sw5o/efjVLHq3JtfruVsDY0EpqHk8qlC4sfrz7EvwhOt82Ht5LmeQMcpJTQly14BNoaji3k+5GKwx7lFPO8VUCvliXwQDDelbFGuSofcisVsyzceGFKg3Y13faKkDnt+hUD/keDIh4o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Xzt6QyZ2; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Xzt6QyZ2"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724448447;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AVsh9kb6vW+Bt06Jn03oX1j/efdsDBql1xIMg/8pdI0=;
	b=Xzt6QyZ2RMgH8Lp9OMcSOmJ6IqS9GtHItiLjY1ySH+LhJE6Wnq2CCPXQRuqQKDsE1JmimN
	LBpYMJdoQEdg26QSdxVRYlgYGwcB5OP5NnMYtu4sj1MovKDFdKAPnKfv4ATec66TZLDN9s
	WRE+SqJrcSzPVWXKa1LG8T+gP8pyJ1c=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 3/3] KVM: arm64: nv: Request vPE doorbell upon nested ERET to L2
Date: Fri, 23 Aug 2024 21:27:03 +0000
Message-ID: <20240823212703.3576061-4-oliver.upton@linux.dev>
In-Reply-To: <20240823212703.3576061-1-oliver.upton@linux.dev>
References: <20240823212703.3576061-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Running an L2 guest with GICv4 enabled goes absolutely nowhere, and gets
into a vicious cycle of nested ERET followed by nested exception entry
into the L1.

When KVM does a put on a runnable vCPU, it marks the vPE as nonresident
but does not request a doorbell IRQ. Behind the scenes in the ITS
driver's view of the vCPU, its_vpe::pending_last gets set to true to
indicate that context is still runnable.

This comes to a head when doing the nested ERET into L2. The vPE doesn't
get scheduled on the redistributor as it is exclusively part of the L1's
VGIC context. kvm_vgic_vcpu_pending_irq() returns true because the vPE
appears runnable, and KVM does a nested exception entry into the L1
before L2 ever gets off the ground.

This issue can be papered over by requesting a doorbell IRQ when
descheduling a vPE as part of a nested ERET. KVM needs this anyway to
kick the vCPU out of the L2 when an IRQ becomes pending for the L1.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/kvm/emulate-nested.c   |  2 ++
 arch/arm64/kvm/vgic/vgic-v4.c     | 18 +++++++++++++++++-
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f959d03decfc..7d561f0bd9bf 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -897,6 +897,8 @@ struct kvm_vcpu_arch {
 #define PMUSERENR_ON_CPU	__vcpu_single_flag(sflags, BIT(4))
 /* WFI instruction trapped */
 #define IN_WFI			__vcpu_single_flag(sflags, BIT(5))
+/* KVM is currently emulating a nested ERET */
+#define IN_NESTED_ERET		__vcpu_single_flag(sflags, BIT(6))
 
 
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 05166eccea0a..fd3d6275b777 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2310,6 +2310,7 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
 	}
 
 	preempt_disable();
+	vcpu_set_flag(vcpu, IN_NESTED_ERET);
 	kvm_arch_vcpu_put(vcpu);
 
 	if (!esr_iss_is_eretax(esr))
@@ -2321,6 +2322,7 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
 	*vcpu_cpsr(vcpu) = spsr;
 
 	kvm_arch_vcpu_load(vcpu, smp_processor_id());
+	vcpu_clear_flag(vcpu, IN_NESTED_ERET);
 	preempt_enable();
 }
 
diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
index 74a67ad87f29..9f3f06ac76cc 100644
--- a/arch/arm64/kvm/vgic/vgic-v4.c
+++ b/arch/arm64/kvm/vgic/vgic-v4.c
@@ -336,6 +336,22 @@ void vgic_v4_teardown(struct kvm *kvm)
 	its_vm->vpes = NULL;
 }
 
+static inline bool vgic_v4_want_doorbell(struct kvm_vcpu *vcpu)
+{
+	if (vcpu_get_flag(vcpu, IN_WFI))
+		return true;
+
+	if (likely(!vcpu_has_nv(vcpu)))
+		return false;
+
+	/*
+	 * GICv4 hardware is only ever used for the L1. Mark the vPE (i.e. the
+	 * L1 context) nonresident and request a doorbell to kick us out of the
+	 * L2 when an IRQ becomes pending.
+	 */
+	return vcpu_get_flag(vcpu, IN_NESTED_ERET);
+}
+
 int vgic_v4_put(struct kvm_vcpu *vcpu)
 {
 	struct its_vpe *vpe = &vcpu->arch.vgic_cpu.vgic_v3.its_vpe;
@@ -343,7 +359,7 @@ int vgic_v4_put(struct kvm_vcpu *vcpu)
 	if (!vgic_supports_direct_msis(vcpu->kvm) || !vpe->resident)
 		return 0;
 
-	return its_make_vpe_non_resident(vpe, !!vcpu_get_flag(vcpu, IN_WFI));
+	return its_make_vpe_non_resident(vpe, vgic_v4_want_doorbell(vcpu));
 }
 
 int vgic_v4_load(struct kvm_vcpu *vcpu)
-- 
2.46.0.295.g3b9ea8a38a-goog


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F70025D53F
	for <kvmarm@lists.linux.dev>; Wed, 12 Feb 2025 18:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739384764; cv=none; b=JOXYnHh6TwA+wutyFeCUiO8b5j2KBPNhfBVDg7+4Z+Pe2NDAJUs4zS+uBO1Wfbv0Yai3HGnr8xcFdeyP41FUaLzEMkD29fm608Sa+4ZIapT4tEsHhEN4cCm23qoh1DV4mv9vi0ARbPtS0JakGXYrRhP/zKZ/ZixZ2RjLfXXUTtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739384764; c=relaxed/simple;
	bh=yuI+PECZbLFotsavzZF231/Cmz0gJvhWqdNSzbk7BQA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JnwP+FZa/aShTMQZYxk2GTzyYx3XkmrLfvG2BteJeeCm48lwM2PzAXkE4Xb/fAmLUH6xxjpXjpbDG+goXNCoIZwugV26K8zY/hcmDC7zb+G+t2ybssBdbOQxPeu2J76kTxrbrR7EOoHZK0abcQwkiGlN/6DRBWuWTG+GuymVDwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t8gMpc6+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t8gMpc6+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A54C4CEE4;
	Wed, 12 Feb 2025 18:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739384764;
	bh=yuI+PECZbLFotsavzZF231/Cmz0gJvhWqdNSzbk7BQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t8gMpc6+yMelKvFPQcDMCiiTNada/vjQOPGhftZ0hJImn0PuC8Eae0EaU/mumS0Sx
	 pH2Yxp7MJWz3vcYKCJrsaan7ygKbRcxgvTMNy4pENIYRl6nC2qIR0eGFg8gE5ziSvw
	 knqysUmFkqa7xl4vKsILig0+KVoiHlOr9W3GWIvuJI9urXJIySmuygcg4y7lgCxDEZ
	 CIQNHf2hfTOrs0LuYSkhH8OILdlFN8j4xwgiKAyAQc04+J7+Y2on0G2gcSuXhJv8+B
	 71MUmyhapiksUjXwQUefxu49cbxnKrGOT3WXG0nmmQ6274a87Sg1CAgVkwZSC6Re06
	 aYX6kWeeofMqw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tiHQw-003RQt-0Q;
	Wed, 12 Feb 2025 18:26:02 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Alexander Potapenko <glider@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 2/2] KVM: arm64: vgic: Hoist SGI/PPI alloc from vgic_init() to kvm_create_vgic()
Date: Wed, 12 Feb 2025 18:25:58 +0000
Message-Id: <20250212182558.2865232-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250212182558.2865232-1-maz@kernel.org>
References: <20250212182558.2865232-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, glider@google.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

If userspace creates vcpus, then a vgic, we end-up in a situation
where irqchip_in_kernel() will return true, but no private interrupt
has been allocated for these vcpus. This situation will continue
until userspace initialises the vgic, at which point we fix the
early vcpus. Should a vcpu run or be initialised in the interval,
bad things may happen.

An obvious solution is to move this fix-up phase to the point where
the vgic is created. This ensures that from that point onwards,
all vcpus have their private interrupts, as new vcpus will directly
allocate them.

With that, we have the invariant that when irqchip_in_kernel() is
true, all vcpus have their private interrupts.

Reported-by: Alexander Potapenko <glider@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-init.c | 74 ++++++++++++++++-----------------
 1 file changed, 37 insertions(+), 37 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index bc7e22ab5d812..775461cf2d2db 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -34,9 +34,9 @@
  *
  * CPU Interface:
  *
- * - kvm_vgic_vcpu_init(): initialization of static data that
- *   doesn't depend on any sizing information or emulation type. No
- *   allocation is allowed there.
+ * - kvm_vgic_vcpu_init(): initialization of static data that doesn't depend
+ *   on any sizing information. Private interrupts are allocated if not
+ *   already allocated at vgic-creation time.
  */
 
 /* EARLY INIT */
@@ -58,6 +58,8 @@ void kvm_vgic_early_init(struct kvm *kvm)
 
 /* CREATION */
 
+static int vgic_allocate_private_irqs_locked(struct kvm_vcpu *vcpu, u32 type);
+
 /**
  * kvm_vgic_create: triggered by the instantiation of the VGIC device by
  * user space, either through the legacy KVM_CREATE_IRQCHIP ioctl (v2 only)
@@ -112,6 +114,22 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 		goto out_unlock;
 	}
 
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		ret = vgic_allocate_private_irqs_locked(vcpu, type);
+		if (ret)
+			break;
+	}
+
+	if (ret) {
+		kvm_for_each_vcpu(i, vcpu, kvm) {
+			struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+			kfree(vgic_cpu->private_irqs);
+			vgic_cpu->private_irqs = NULL;
+		}
+
+		goto out_unlock;
+	}
+
 	kvm->arch.vgic.in_kernel = true;
 	kvm->arch.vgic.vgic_model = type;
 
@@ -180,7 +198,7 @@ static int kvm_vgic_dist_init(struct kvm *kvm, unsigned int nr_spis)
 	return 0;
 }
 
-static int vgic_allocate_private_irqs_locked(struct kvm_vcpu *vcpu)
+static int vgic_allocate_private_irqs_locked(struct kvm_vcpu *vcpu, u32 type)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	int i;
@@ -218,17 +236,28 @@ static int vgic_allocate_private_irqs_locked(struct kvm_vcpu *vcpu)
 			/* PPIs */
 			irq->config = VGIC_CONFIG_LEVEL;
 		}
+
+		switch (type) {
+		case KVM_DEV_TYPE_ARM_VGIC_V3:
+			irq->group = 1;
+			irq->mpidr = kvm_vcpu_get_mpidr_aff(vcpu);
+			break;
+		case KVM_DEV_TYPE_ARM_VGIC_V2:
+			irq->group = 0;
+			irq->targets = BIT(vcpu->vcpu_id);
+			break;
+		}
 	}
 
 	return 0;
 }
 
-static int vgic_allocate_private_irqs(struct kvm_vcpu *vcpu)
+static int vgic_allocate_private_irqs(struct kvm_vcpu *vcpu, u32 type)
 {
 	int ret;
 
 	mutex_lock(&vcpu->kvm->arch.config_lock);
-	ret = vgic_allocate_private_irqs_locked(vcpu);
+	ret = vgic_allocate_private_irqs_locked(vcpu, type);
 	mutex_unlock(&vcpu->kvm->arch.config_lock);
 
 	return ret;
@@ -258,7 +287,7 @@ int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
 	if (!irqchip_in_kernel(vcpu->kvm))
 		return 0;
 
-	ret = vgic_allocate_private_irqs(vcpu);
+	ret = vgic_allocate_private_irqs(vcpu, dist->vgic_model);
 	if (ret)
 		return ret;
 
@@ -295,7 +324,7 @@ int vgic_init(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 	struct kvm_vcpu *vcpu;
-	int ret = 0, i;
+	int ret = 0;
 	unsigned long idx;
 
 	lockdep_assert_held(&kvm->arch.config_lock);
@@ -315,35 +344,6 @@ int vgic_init(struct kvm *kvm)
 	if (ret)
 		goto out;
 
-	/* Initialize groups on CPUs created before the VGIC type was known */
-	kvm_for_each_vcpu(idx, vcpu, kvm) {
-		ret = vgic_allocate_private_irqs_locked(vcpu);
-		if (ret)
-			goto out;
-
-		for (i = 0; i < VGIC_NR_PRIVATE_IRQS; i++) {
-			struct vgic_irq *irq = vgic_get_vcpu_irq(vcpu, i);
-
-			switch (dist->vgic_model) {
-			case KVM_DEV_TYPE_ARM_VGIC_V3:
-				irq->group = 1;
-				irq->mpidr = kvm_vcpu_get_mpidr_aff(vcpu);
-				break;
-			case KVM_DEV_TYPE_ARM_VGIC_V2:
-				irq->group = 0;
-				irq->targets = 1U << idx;
-				break;
-			default:
-				ret = -EINVAL;
-			}
-
-			vgic_put_irq(kvm, irq);
-
-			if (ret)
-				goto out;
-		}
-	}
-
 	/*
 	 * If we have GICv4.1 enabled, unconditionally request enable the
 	 * v4 support so that we get HW-accelerated vSGIs. Otherwise, only
-- 
2.39.2


Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97DB636CDE0
	for <kvmarm@lists.linux.dev>; Fri,  5 Sep 2025 14:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757082110; cv=none; b=F5viwhNi23eomdIaxOKRfrMCIzJa7OkP/dRSdeOAV14hxE3UqH/8xp701KVEhkuMQmZVeX4YtG7KBpRth8s/hxbd1RprwoY/c+oPhvPL5tvKIpR1T4cun0+q7jetYVxh40Jj756M/Ja2iCVpaENO1laRDrqQTRaTHv0W2iiRhRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757082110; c=relaxed/simple;
	bh=gCzI9bKknZa+8KVhj8nP5YmbBOdZvziJNE1W5rM7GCw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BAAPCG+nMFuC/vtZ9tM7cfiNwk2fjwPaI5A0On6vUf0qC02MNVrAI6vF48yiE7ZvpjhjSK2DLwTMEmasGEL4nnNQ4moWkDRD7GmCuuqQWDDpnLpkCwGDep1VqQLdh2h42njMYMNsxzXHJCdf4YR9lQ7MdKG4DZJChsvYLBSUjYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GorDkF7H; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GorDkF7H"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757082106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I9CqEZQzFCzl7EPd2einhfkNHzNk8frQSW1N4atGh5U=;
	b=GorDkF7HywWR5dC9dTxOwt/cjTq2FOaDoXk745sPsNvEUOmOt/49SpgBvCf67BpBwEciJF
	qLwvpCemWmT1KHkUWj5cEDJIOMX+coPMkemi8vo/sCbB9d9DxmWW4Ir9l6KhW2QDSbxOdL
	QcCnMLXpim0iAwXKn4IxVTtqG8zRDJc=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ben Horgan <ben.horgan@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 5/6] KVM: arm64: vgic-v3: Don't require IRQs be disabled for LPI xarray lock
Date: Fri,  5 Sep 2025 03:05:30 -0700
Message-Id: <20250905100531.282980-6-oliver.upton@linux.dev>
In-Reply-To: <20250905100531.282980-1-oliver.upton@linux.dev>
References: <20250905100531.282980-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Now that releases of LPIs have been unnested from the ap_list_lock there
are no xarray writers that exist in a context where IRQs are already
disabled. As such we can relax the locking to the non-IRQ disabling
spinlock to guard the LPI xarray.

Note that there are still readers of the LPI xarray where IRQs are
disabled however the readers rely on RCU protection instead of the lock.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-init.c |  2 +-
 arch/arm64/kvm/vgic/vgic-its.c  |  7 +++----
 arch/arm64/kvm/vgic/vgic.c      | 13 ++++++-------
 3 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 4c777136ea5f..4c3c0d82e476 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -53,7 +53,7 @@ void kvm_vgic_early_init(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 
-	xa_init_flags(&dist->lpi_xa, XA_FLAGS_LOCK_IRQ);
+	xa_init(&dist->lpi_xa);
 }
 
 /* CREATION */
diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index f162206adb48..ce3e3ed3f29f 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -78,7 +78,6 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 	struct vgic_irq *irq = vgic_get_irq(kvm, intid), *oldirq;
-	unsigned long flags;
 	int ret;
 
 	/* In this case there is no put, since we keep the reference. */
@@ -89,7 +88,7 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 	if (!irq)
 		return ERR_PTR(-ENOMEM);
 
-	ret = xa_reserve_irq(&dist->lpi_xa, intid, GFP_KERNEL_ACCOUNT);
+	ret = xa_reserve(&dist->lpi_xa, intid, GFP_KERNEL_ACCOUNT);
 	if (ret) {
 		kfree(irq);
 		return ERR_PTR(ret);
@@ -104,7 +103,7 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 	irq->target_vcpu = vcpu;
 	irq->group = 1;
 
-	xa_lock_irqsave(&dist->lpi_xa, flags);
+	xa_lock(&dist->lpi_xa);
 
 	/*
 	 * There could be a race with another vgic_add_lpi(), so we need to
@@ -126,7 +125,7 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 	}
 
 out_unlock:
-	xa_unlock_irqrestore(&dist->lpi_xa, flags);
+	xa_unlock(&dist->lpi_xa);
 
 	if (ret)
 		return ERR_PTR(ret);
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 480391a0dcad..a21b482844ce 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -28,7 +28,7 @@ struct vgic_global kvm_vgic_global_state __ro_after_init = {
  *     kvm->arch.config_lock (mutex)
  *       its->cmd_lock (mutex)
  *         its->its_lock (mutex)
- *           vgic_dist->lpi_xa.xa_lock		must be taken with IRQs disabled
+ *           vgic_dist->lpi_xa.xa_lock
  *             vgic_cpu->ap_list_lock		must be taken with IRQs disabled
  *               vgic_irq->irq_lock		must be taken with IRQs disabled
  *
@@ -141,30 +141,29 @@ static __must_check bool vgic_put_irq_norelease(struct kvm *kvm, struct vgic_irq
 void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
-	unsigned long flags;
 
 	if (!__vgic_put_irq(kvm, irq))
 		return;
 
-	xa_lock_irqsave(&dist->lpi_xa, flags);
+	xa_lock(&dist->lpi_xa);
 	vgic_release_lpi_locked(dist, irq);
-	xa_unlock_irqrestore(&dist->lpi_xa, flags);
+	xa_unlock(&dist->lpi_xa);
 }
 
 static void vgic_release_deleted_lpis(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
-	unsigned long flags, intid;
+	unsigned long intid;
 	struct vgic_irq *irq;
 
-	xa_lock_irqsave(&dist->lpi_xa, flags);
+	xa_lock(&dist->lpi_xa);
 
 	xa_for_each(&dist->lpi_xa, intid, irq) {
 		if (irq->pending_release)
 			vgic_release_lpi_locked(dist, irq);
 	}
 
-	xa_unlock_irqrestore(&dist->lpi_xa, flags);
+	xa_unlock(&dist->lpi_xa);
 }
 
 void vgic_flush_pending_lpis(struct kvm_vcpu *vcpu)
-- 
2.39.5


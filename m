Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BEF8155733
	for <kvmarm@lists.linux.dev>; Mon, 22 Apr 2024 20:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713816156; cv=none; b=FdrPDs5qiZxJ2m6j5k5ywJhk1V0udT9QP1ddMvT7FozSAW/VfXTaTRQnz6DkGfIrVpmtI4LS4ptSTsFZakdyQOVWhFXjlzIVMVTv+iz6WE+vWbcQyrfPv8t/0dtbL+xuji/+miQZuTTA0Aez9suRyjFeilVELvMTnt331MpQPug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713816156; c=relaxed/simple;
	bh=KTO8N7rhQafHz+X53eNN51WXjxTOZ5u1oSFHbAXvOTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W9c1JdlI00jpxnS9tQAdZ9nclSSwoVdSwa2AAXAogrU6/us+SZ0VVXhulGxDH/CpVtnq7WGmuY6H6yN8ouKZE9btm0ZRfRQ5MXt0dFM4LGHW9dUexgQOaimgkMwNnrhcRaDoOH/FpeNgKiTTrkxQGg/11rRW5Qc6CT3XfMzCFjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Q4o4xsX2; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Q4o4xsX2"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713816153;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ve6KPxN2aB8mhOkKoIXEW5C+TjmlSunVAKr4aI9OaE4=;
	b=Q4o4xsX2caxS4RdePSoRNENrUmRk5H23BmkqbQTipAnS10d80HRadn2Y4l2w1BlGAMXMMw
	7w+d5IontHJVR67vYtLYjPNFQYS3zq5RWZI9CqQZQT3RSilx0m47za46jzwq3vh2++A+Q6
	NeN0s+E/ahg4A+wGlzbQ9z+QHqhWbu0=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	kvm@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 12/19] KVM: arm64: vgic-its: Get rid of the lpi_list_lock
Date: Mon, 22 Apr 2024 20:01:51 +0000
Message-ID: <20240422200158.2606761-13-oliver.upton@linux.dev>
In-Reply-To: <20240422200158.2606761-1-oliver.upton@linux.dev>
References: <20240422200158.2606761-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The last genuine use case for the lpi_list_lock was the global LPI
translation cache, which has been removed in favor of a per-ITS xarray.
Remove a layer from the locking puzzle by getting rid of it.

vgic_add_lpi() still has a critical section that needs to protect
against the insertion of other LPIs; change it to take the LPI xarray's
xa_lock to retain this property.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-init.c | 1 -
 arch/arm64/kvm/vgic/vgic-its.c  | 6 +++---
 arch/arm64/kvm/vgic/vgic.c      | 5 ++---
 include/kvm/arm_vgic.h          | 3 ---
 4 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 6ee42f395253..aee6083d0da6 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -53,7 +53,6 @@ void kvm_vgic_early_init(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 
-	raw_spin_lock_init(&dist->lpi_list_lock);
 	xa_init_flags(&dist->lpi_xa, XA_FLAGS_LOCK_IRQ);
 }
 
diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index bb7f4fd35b2b..40bb43f20bf3 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -69,7 +69,7 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 	irq->target_vcpu = vcpu;
 	irq->group = 1;
 
-	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
+	xa_lock_irqsave(&dist->lpi_xa, flags);
 
 	/*
 	 * There could be a race with another vgic_add_lpi(), so we need to
@@ -84,14 +84,14 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 		goto out_unlock;
 	}
 
-	ret = xa_err(xa_store(&dist->lpi_xa, intid, irq, 0));
+	ret = xa_err(__xa_store(&dist->lpi_xa, intid, irq, 0));
 	if (ret) {
 		xa_release(&dist->lpi_xa, intid);
 		kfree(irq);
 	}
 
 out_unlock:
-	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
+	xa_unlock_irqrestore(&dist->lpi_xa, flags);
 
 	if (ret)
 		return ERR_PTR(ret);
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index e3ee1bc1214a..d0c59b51a6b0 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -29,9 +29,8 @@ struct vgic_global kvm_vgic_global_state __ro_after_init = {
  *       its->cmd_lock (mutex)
  *         its->its_lock (mutex)
  *           vgic_cpu->ap_list_lock		must be taken with IRQs disabled
- *             kvm->lpi_list_lock		must be taken with IRQs disabled
- *               vgic_dist->lpi_xa.xa_lock	must be taken with IRQs disabled
- *                 vgic_irq->irq_lock		must be taken with IRQs disabled
+ *             vgic_dist->lpi_xa.xa_lock	must be taken with IRQs disabled
+ *               vgic_irq->irq_lock		must be taken with IRQs disabled
  *
  * As the ap_list_lock might be taken from the timer interrupt handler,
  * we have to disable IRQs before taking this lock and everything lower
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 76ed097500c0..50b828b278fd 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -280,9 +280,6 @@ struct vgic_dist {
 	 */
 	u64			propbaser;
 
-	/* Protects the lpi_list. */
-	raw_spinlock_t		lpi_list_lock;
-
 #define LPI_XA_MARK_DEBUG_ITER	XA_MARK_0
 	struct xarray		lpi_xa;
 
-- 
2.44.0.769.g3c40516874-goog


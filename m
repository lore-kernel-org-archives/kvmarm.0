Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781F41353ED
	for <kvmarm@lists.linux.dev>; Wed, 24 Jan 2024 20:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706129374; cv=none; b=R08ONF/436DOGZdsgqJ3/+7q0eApikSK94DvyiGqrluenQ2tFh/cOZ9YJVms6KQyTtURxkHtQZ5UqBucvcKentVbCWSvzCqBIhzccBQ780BRUOkQmV+X5GoFqC+z5QmxUuKFRBFuYsrS6Gb3pw4zhxQexNw5oX2QMWThAX9KSeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706129374; c=relaxed/simple;
	bh=OWQPlGbJfv74O6Ejj1hlEx603Lza1Ej43wwVmD20d6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BpohHk7ktI7GiTcztjXHRvvYTsCwfKol8XSUfc6S+m8Cb4/NTCRbuZdvZCxGk5vksUi0IaEyTG9P+D78FxLYb/npbyZCrJMdszoWqB+T2ofbS7qsQVZtSCxes7wyhVoUvVNiY8rZAEm6Bn1yrEG0OHHCU+sAlwa8caFNUGJzLJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gFQ+wblN; arc=none smtp.client-ip=95.215.58.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gFQ+wblN"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706129370;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gMHb8qwOgYdG295rXfmcu6C9eixNCueL5GSPuTMDr/M=;
	b=gFQ+wblN+DmTLfOxsU/cOMUDyxDFW0xoVLAf2Jm7QHEUY17RoeBiXHE9NhjmcsVxvLDzTU
	AL8jxKTuIA8AMTw+YFAb2VHW6n4BAPi4BClJ/iVglMe0Cuz+/MYPiMMOioLpy4LXMBp0US
	hbJHrg86q579EmLXYL6RG99jEhxkLN4=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Jing Zhang <jingzhangos@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 05/15] KVM: arm64: vgic: Get rid of the LPI linked-list
Date: Wed, 24 Jan 2024 20:48:59 +0000
Message-ID: <20240124204909.105952-6-oliver.upton@linux.dev>
In-Reply-To: <20240124204909.105952-1-oliver.upton@linux.dev>
References: <20240124204909.105952-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

All readers of LPI configuration have been transitioned to use the LPI
xarray. Get rid of the linked-list altogether.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-init.c | 1 -
 arch/arm64/kvm/vgic/vgic-its.c  | 7 ++-----
 arch/arm64/kvm/vgic/vgic.c      | 1 -
 include/kvm/arm_vgic.h          | 1 -
 4 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 411719053107..e25672d6e846 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -53,7 +53,6 @@ void kvm_vgic_early_init(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 
-	INIT_LIST_HEAD(&dist->lpi_list_head);
 	INIT_LIST_HEAD(&dist->lpi_translation_cache);
 	raw_spin_lock_init(&dist->lpi_list_lock);
 	xa_init_flags(&dist->lpi_xa, XA_FLAGS_LOCK_IRQ);
diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index a2d95a279798..0486d3779d11 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -74,10 +74,8 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 	 * There could be a race with another vgic_add_lpi(), so we need to
 	 * check that we don't add a second list entry with the same LPI.
 	 */
-	list_for_each_entry(oldirq, &dist->lpi_list_head, lpi_list) {
-		if (oldirq->intid != intid)
-			continue;
-
+	oldirq = xa_load(&dist->lpi_xa, intid);
+	if (oldirq) {
 		/* Someone was faster with adding this LPI, lets use that. */
 		kfree(irq);
 		irq = oldirq;
@@ -99,7 +97,6 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 		return ERR_PTR(ret);
 	}
 
-	list_add_tail(&irq->lpi_list, &dist->lpi_list_head);
 	dist->lpi_list_count++;
 
 out_unlock:
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index d90c42ff051d..e58ce68e325c 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -121,7 +121,6 @@ void __vgic_put_lpi_locked(struct kvm *kvm, struct vgic_irq *irq)
 	if (!kref_put(&irq->refcount, vgic_irq_release))
 		return;
 
-	list_del(&irq->lpi_list);
 	xa_erase(&dist->lpi_xa, irq->intid);
 	dist->lpi_list_count--;
 
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 795b35656b54..39037db3fa90 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -277,7 +277,6 @@ struct vgic_dist {
 	/* Protects the lpi_list and the count value below. */
 	raw_spinlock_t		lpi_list_lock;
 	struct xarray		lpi_xa;
-	struct list_head	lpi_list_head;
 	int			lpi_list_count;
 
 	/* LPI translation cache */
-- 
2.43.0.429.g432eaa2c6b-goog


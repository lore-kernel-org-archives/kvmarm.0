Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EFE2299957
	for <kvmarm@lists.linux.dev>; Fri,  7 Nov 2025 18:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762541330; cv=none; b=m7v86iDE/gUqgUk+y9apU0uMwkllWnAjhYjN14NormOVR3jNDvQqoW/4GWfGliQDHA31v/FcGZ5hxKR3edepNY4w2Muov2ASZvOOwI1dbWbLXfvzkdg1RZ4ORbGmZhGkT2kaouXsLYugHDKx6P6Ty/62BwRyz5iG3atWKfMGQq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762541330; c=relaxed/simple;
	bh=e1vjNYNiu36ZKrtGbutC1vZ9yKKdwfGFA2nNSz8MYk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZPUjC6/IQtrwW5OrRznDzrkheKH+xcSrxX42ffqbT+LyE6fokS/XWrQ2P8FpSffrVsz8tQo7ExAVDOAxEbTauzoTRCMATiIx1nkjLvBPwX+NFhPLhYTs2nNXgvgVMScxV+G/VZVcL4Q6LWjHapLMBXGvCC2F/MhxIzj7FeyANqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TxUzxfXG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TxUzxfXG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E7EEC4CEF5;
	Fri,  7 Nov 2025 18:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762541329;
	bh=e1vjNYNiu36ZKrtGbutC1vZ9yKKdwfGFA2nNSz8MYk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TxUzxfXG08u2XSlRkstHdVv47Nj8dNbZJX46uqYQeQyX9HVM9MMC+iLihZQNnJ4o+
	 uCQachBAgiZG5JNyQ97uTGMP6UavkCOzlJYkXzSd6j67Gj4Jlb9JBs2uwe2Ylhx7F8
	 qQvR+wKC08csrSXu/I4Oth2lR27rgBgOd8O9XhlH4WmhYJNACps4cPGGteOa3qafIp
	 HXVpm3PbjQI/AO/G5h4OAekIrVzTk8tkHoHXez71sfYNBgIVW0VsLh3eCeNBc5lbzb
	 +MKLZHvjZAn5Pf0xnT3TNAlV9SPfHJzhraAAl775NX+LIi291YG0d83Y0ql2/6xfNn
	 Ld5Q5EWKb0//Q==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v2 1/2] KVM: arm64: vgic-v3: Reinstate IRQ lock ordering for LPI xarray
Date: Fri,  7 Nov 2025 10:48:46 -0800
Message-ID: <20251107184847.1784820-2-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251107184847.1784820-1-oupton@kernel.org>
References: <20251107184847.1784820-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Zenghui reports that running a KVM guest with an assigned device and
lockdep enabled produces an unfriendly splat due to an inconsistent irq
context when taking the lpi_xa's spinlock.

This is no good as in rare cases the last reference to an LPI can get
dropped after injection of a cached LPI translation. In this case,
vgic_put_irq() will release the IRQ struct and take the lpi_xa's
spinlock to erase it from the xarray.

Reinstate the IRQ ordering and update the lockdep hint accordingly. Note
that there is no irqsave equivalent of might_lock(), so just explictly
grab and release the spinlock on lockdep kernels.

Reported-by: Zenghui Yu <yuzenghui@huawei.com>
Closes: https://lore.kernel.org/kvmarm/b4d7cb0f-f007-0b81-46d1-998b15cc14bc@huawei.com/
Fixes: 982f31bbb5b0 ("KVM: arm64: vgic-v3: Don't require IRQs be disabled for LPI xarray lock")
Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-debug.c | 16 ++++++++++++----
 arch/arm64/kvm/vgic/vgic-init.c  |  2 +-
 arch/arm64/kvm/vgic/vgic-its.c   |  7 ++++---
 arch/arm64/kvm/vgic/vgic.c       | 23 +++++++++++++++--------
 4 files changed, 32 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-debug.c b/arch/arm64/kvm/vgic/vgic-debug.c
index 4c1209261b65..bb92853d1fd3 100644
--- a/arch/arm64/kvm/vgic/vgic-debug.c
+++ b/arch/arm64/kvm/vgic/vgic-debug.c
@@ -64,29 +64,37 @@ static void iter_next(struct kvm *kvm, struct vgic_state_iter *iter)
 static int iter_mark_lpis(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
+	unsigned long intid, flags;
 	struct vgic_irq *irq;
-	unsigned long intid;
 	int nr_lpis = 0;
 
+	xa_lock_irqsave(&dist->lpi_xa, flags);
+
 	xa_for_each(&dist->lpi_xa, intid, irq) {
 		if (!vgic_try_get_irq_ref(irq))
 			continue;
 
-		xa_set_mark(&dist->lpi_xa, intid, LPI_XA_MARK_DEBUG_ITER);
+		__xa_set_mark(&dist->lpi_xa, intid, LPI_XA_MARK_DEBUG_ITER);
 		nr_lpis++;
 	}
 
+	xa_unlock_irqrestore(&dist->lpi_xa, flags);
+
 	return nr_lpis;
 }
 
 static void iter_unmark_lpis(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
+	unsigned long intid, flags;
 	struct vgic_irq *irq;
-	unsigned long intid;
 
 	xa_for_each_marked(&dist->lpi_xa, intid, irq, LPI_XA_MARK_DEBUG_ITER) {
-		xa_clear_mark(&dist->lpi_xa, intid, LPI_XA_MARK_DEBUG_ITER);
+		xa_lock_irqsave(&dist->lpi_xa, flags);
+		__xa_clear_mark(&dist->lpi_xa, intid, LPI_XA_MARK_DEBUG_ITER);
+		xa_unlock_irqrestore(&dist->lpi_xa, flags);
+
+		/* vgic_put_irq() expects to be called outside of the xa_lock */
 		vgic_put_irq(kvm, irq);
 	}
 }
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 1796b1a22a72..7208776ba4bf 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -53,7 +53,7 @@ void kvm_vgic_early_init(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 
-	xa_init(&dist->lpi_xa);
+	xa_init_flags(&dist->lpi_xa, XA_FLAGS_LOCK_IRQ);
 }
 
 /* CREATION */
diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index ce3e3ed3f29f..f162206adb48 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -78,6 +78,7 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 	struct vgic_irq *irq = vgic_get_irq(kvm, intid), *oldirq;
+	unsigned long flags;
 	int ret;
 
 	/* In this case there is no put, since we keep the reference. */
@@ -88,7 +89,7 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 	if (!irq)
 		return ERR_PTR(-ENOMEM);
 
-	ret = xa_reserve(&dist->lpi_xa, intid, GFP_KERNEL_ACCOUNT);
+	ret = xa_reserve_irq(&dist->lpi_xa, intid, GFP_KERNEL_ACCOUNT);
 	if (ret) {
 		kfree(irq);
 		return ERR_PTR(ret);
@@ -103,7 +104,7 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 	irq->target_vcpu = vcpu;
 	irq->group = 1;
 
-	xa_lock(&dist->lpi_xa);
+	xa_lock_irqsave(&dist->lpi_xa, flags);
 
 	/*
 	 * There could be a race with another vgic_add_lpi(), so we need to
@@ -125,7 +126,7 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 	}
 
 out_unlock:
-	xa_unlock(&dist->lpi_xa);
+	xa_unlock_irqrestore(&dist->lpi_xa, flags);
 
 	if (ret)
 		return ERR_PTR(ret);
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 6dd5a10081e2..8d20c53faef0 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -28,7 +28,7 @@ struct vgic_global kvm_vgic_global_state __ro_after_init = {
  *     kvm->arch.config_lock (mutex)
  *       its->cmd_lock (mutex)
  *         its->its_lock (mutex)
- *           vgic_dist->lpi_xa.xa_lock
+ *           vgic_dist->lpi_xa.xa_lock		must be taken with IRQs disabled
  *             vgic_cpu->ap_list_lock		must be taken with IRQs disabled
  *               vgic_irq->irq_lock		must be taken with IRQs disabled
  *
@@ -141,32 +141,39 @@ static __must_check bool vgic_put_irq_norelease(struct kvm *kvm, struct vgic_irq
 void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
+	unsigned long flags;
 
-	if (irq->intid >= VGIC_MIN_LPI)
-		might_lock(&dist->lpi_xa.xa_lock);
+	/*
+	 * Normally the lock is only taken when the refcount drops to 0.
+	 * Acquire/release it early on lockdep kernels to make locking issues
+	 * in rare release paths a bit more obvious.
+	 */
+	if (IS_ENABLED(CONFIG_LOCKDEP) && irq->intid >= VGIC_MIN_LPI) {
+		guard(spinlock_irqsave)(&dist->lpi_xa.xa_lock);
+	}
 
 	if (!__vgic_put_irq(kvm, irq))
 		return;
 
-	xa_lock(&dist->lpi_xa);
+	xa_lock_irqsave(&dist->lpi_xa, flags);
 	vgic_release_lpi_locked(dist, irq);
-	xa_unlock(&dist->lpi_xa);
+	xa_unlock_irqrestore(&dist->lpi_xa, flags);
 }
 
 static void vgic_release_deleted_lpis(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
-	unsigned long intid;
+	unsigned long flags, intid;
 	struct vgic_irq *irq;
 
-	xa_lock(&dist->lpi_xa);
+	xa_lock_irqsave(&dist->lpi_xa, flags);
 
 	xa_for_each(&dist->lpi_xa, intid, irq) {
 		if (irq->pending_release)
 			vgic_release_lpi_locked(dist, irq);
 	}
 
-	xa_unlock(&dist->lpi_xa);
+	xa_unlock_irqrestore(&dist->lpi_xa, flags);
 }
 
 void vgic_flush_pending_lpis(struct kvm_vcpu *vcpu)
-- 
2.47.3


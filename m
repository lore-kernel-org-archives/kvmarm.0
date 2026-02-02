Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C7F2F5321
	for <kvmarm@lists.linux.dev>; Mon,  2 Feb 2026 08:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770022647; cv=none; b=urff0cLobslRL46biPEH1dvaTXFUqUYLg7PH2I5AklwSEBp8KdPmw1ttqqODSvBWOJKb3i9J3bC80fAJ3Y1tO0X1NCudls2QZUc4IPNPxJxGkUKIkRjmiBvw4a38bfBO9ma39TLp/fqjfRzIWa0HB34GOv5Er59/AQWa7uugads=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770022647; c=relaxed/simple;
	bh=U1bqRjqLDXm7+Kp/Ls7yUhMWX5A1fXxHSERSBzh3KnM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bCjXd4+BX0xhvqQG8EbtaSnGO/k7zgOsHgjbcdybnwfZj1XIRCMILXXeuDobi3xNoPlIpDcU8pd0FXiySGA2s4PaapX9+WEuMawRCYvybXntId/ASFyD8948GiIuGNRNeDLJd+26wdm1/busq3xfllmS94CPpAtfORnRQi/iXmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Fpq6vnR0; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Fpq6vnR0"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4806cfffca6so50169845e9.2
        for <kvmarm@lists.linux.dev>; Mon, 02 Feb 2026 00:57:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770022644; x=1770627444; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZLZMuDSaLum3lZeNGFbi2PdhCi3/HMn1WnF6o814fEI=;
        b=Fpq6vnR03Wo8PysF90ng/nOqGqFOpmjEk5VmgQmWzDSmmkVoWCgg9J9mVhjtMxT3w4
         JYwwdHG3h0REvRkdP6Eff0HukJhoYdT4s9Dd+H8hyheBSNp/G2l/SWnBFzK8wyOz/rj5
         10SWnQtt6+19kLwrCq3In2rnHYDCb4c7Bs9m7p/kSBo6ERApe4BS6huY4uts2rHmlYBu
         nVh4N30YCYlk7ABQGC4HFcQPUi9rp+qn1K2hHFJPgAQwC/agtgFA+222c2fv8wK2nBbv
         4wV13htHbGbv62ob6voFRdnDK78P14rd/FELUI1INeDDWtqKH+xLv4MM0YUPIqhfbzhi
         Rkaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770022644; x=1770627444;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZLZMuDSaLum3lZeNGFbi2PdhCi3/HMn1WnF6o814fEI=;
        b=ZcWxNMp9zsmh5Wu0jCDAbi+I89vkyeTQB2w8+prKXP2Tke33Z+zJ3VO0z7GLQqqaeM
         CR4C5CO3vc4+al3WB5vsXNPNhKVpf0Fkf93YFaE+1W9rltNMU3dVvFM/SaCRRNrTazvp
         U0NW4VGBcQdlZfHYeYJdK1RfRF8tVIzVFIj8qRL5i8Atv1vXlf7qZ8tuSRy07gmGmYp3
         5Zo3k3W13IEhvANf5cM3hP78dc583oeLPOb723SY0/8Hd+0E7lMCYCOCG0iKov+lG/jy
         fux0Bs2FioaGCSn9efM9tzk73gqM2zyOUO2853o3Tj6/WHxgS+/wFkyN8XAgnMzN6baK
         aILA==
X-Forwarded-Encrypted: i=1; AJvYcCUfTiHDdI4B+RpIS+QtKguYP2XTXLayuTAkegDT5pvu94cIr7Lt2H9MmwAwOXuLMQYq5Zsf89Q=@lists.linux.dev
X-Gm-Message-State: AOJu0YwdvImmrJ/QmgjrsUSfpilUxkycybK7HevY9KMyzX8u4qgPRK4n
	VCAx18OuAMYrZ3MxxednopmonHBiBr+bSPv93xdYeCI/6iC+i9+4sPDY+/ZF1wRlyyUgWqHAmP3
	HGg==
X-Received: from wmi9.prod.google.com ([2002:a05:600c:209:b0:480:4a03:7b77])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8716:b0:47e:d943:ec08
 with SMTP id 5b1f17b1804b1-482db4919a6mr128609935e9.28.1770022644456; Mon, 02
 Feb 2026 00:57:24 -0800 (PST)
Date: Mon,  2 Feb 2026 08:57:20 +0000
In-Reply-To: <20260202085721.3954942-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260202085721.3954942-1-tabba@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260202085721.3954942-3-tabba@google.com>
Subject: [PATCH v1 2/3] KVM: arm64: Reimplement vgic-debug XArray iteration
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The vgic-debug interface implementation uses XArray marks
(`LPI_XA_MARK_DEBUG_ITER`) to "snapshot" LPIs at the start of iteration.
This modifies global state for a read-only operation and complicates
reference counting, leading to leaks if iteration is aborted or fails.

Reimplement the iterator to use dynamic iteration logic:

- Remove `lpi_idx` from `struct vgic_state_iter`.
- Replace the XArray marking mechanism with dynamic iteration using
  `xa_find_after(..., XA_PRESENT)`.
- Wrap XArray traversals in `rcu_read_lock()`/`rcu_read_unlock()` to
  ensure safety against concurrent modifications (e.g., LPI unmapping).
- Handle potential races where an LPI is removed during iteration by
  gracefully skipping it in `show()`, rather than warning.
- Remove the unused `LPI_XA_MARK_DEBUG_ITER` definition.

This simplifies the lifecycle management of the iterator and prevents
resource leaks associated with the marking mechanism, and paves the way
for using a standard seq_file iterator.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/vgic/vgic-debug.c | 68 ++++++++++----------------------
 include/kvm/arm_vgic.h           |  1 -
 2 files changed, 20 insertions(+), 49 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-debug.c b/arch/arm64/kvm/vgic/vgic-debug.c
index bb92853d1fd3..ec3d0c1fe703 100644
--- a/arch/arm64/kvm/vgic/vgic-debug.c
+++ b/arch/arm64/kvm/vgic/vgic-debug.c
@@ -25,11 +25,9 @@
 struct vgic_state_iter {
 	int nr_cpus;
 	int nr_spis;
-	int nr_lpis;
 	int dist_id;
 	int vcpu_id;
 	unsigned long intid;
-	int lpi_idx;
 };
 
 static void iter_next(struct kvm *kvm, struct vgic_state_iter *iter)
@@ -45,13 +43,15 @@ static void iter_next(struct kvm *kvm, struct vgic_state_iter *iter)
 	 * Let the xarray drive the iterator after the last SPI, as the iterator
 	 * has exhausted the sequentially-allocated INTID space.
 	 */
-	if (iter->intid >= (iter->nr_spis + VGIC_NR_PRIVATE_IRQS - 1) &&
-	    iter->nr_lpis) {
-		if (iter->lpi_idx < iter->nr_lpis)
-			xa_find_after(&dist->lpi_xa, &iter->intid,
-				      VGIC_LPI_MAX_INTID,
-				      LPI_XA_MARK_DEBUG_ITER);
-		iter->lpi_idx++;
+	if (iter->intid >= (iter->nr_spis + VGIC_NR_PRIVATE_IRQS - 1)) {
+		if (iter->intid == VGIC_LPI_MAX_INTID + 1)
+			return;
+
+		rcu_read_lock();
+		if (!xa_find_after(&dist->lpi_xa, &iter->intid,
+				   VGIC_LPI_MAX_INTID, XA_PRESENT))
+			iter->intid = VGIC_LPI_MAX_INTID + 1;
+		rcu_read_unlock();
 		return;
 	}
 
@@ -61,44 +61,21 @@ static void iter_next(struct kvm *kvm, struct vgic_state_iter *iter)
 		iter->intid = 0;
 }
 
-static int iter_mark_lpis(struct kvm *kvm)
+static int vgic_count_lpis(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
-	unsigned long intid, flags;
 	struct vgic_irq *irq;
+	unsigned long intid;
 	int nr_lpis = 0;
 
-	xa_lock_irqsave(&dist->lpi_xa, flags);
-
-	xa_for_each(&dist->lpi_xa, intid, irq) {
-		if (!vgic_try_get_irq_ref(irq))
-			continue;
-
-		__xa_set_mark(&dist->lpi_xa, intid, LPI_XA_MARK_DEBUG_ITER);
+	rcu_read_lock();
+	xa_for_each(&dist->lpi_xa, intid, irq)
 		nr_lpis++;
-	}
-
-	xa_unlock_irqrestore(&dist->lpi_xa, flags);
+	rcu_read_unlock();
 
 	return nr_lpis;
 }
 
-static void iter_unmark_lpis(struct kvm *kvm)
-{
-	struct vgic_dist *dist = &kvm->arch.vgic;
-	unsigned long intid, flags;
-	struct vgic_irq *irq;
-
-	xa_for_each_marked(&dist->lpi_xa, intid, irq, LPI_XA_MARK_DEBUG_ITER) {
-		xa_lock_irqsave(&dist->lpi_xa, flags);
-		__xa_clear_mark(&dist->lpi_xa, intid, LPI_XA_MARK_DEBUG_ITER);
-		xa_unlock_irqrestore(&dist->lpi_xa, flags);
-
-		/* vgic_put_irq() expects to be called outside of the xa_lock */
-		vgic_put_irq(kvm, irq);
-	}
-}
-
 static void iter_init(struct kvm *kvm, struct vgic_state_iter *iter,
 		      loff_t pos)
 {
@@ -108,8 +85,6 @@ static void iter_init(struct kvm *kvm, struct vgic_state_iter *iter,
 
 	iter->nr_cpus = nr_cpus;
 	iter->nr_spis = kvm->arch.vgic.nr_spis;
-	if (kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)
-		iter->nr_lpis = iter_mark_lpis(kvm);
 
 	/* Fast forward to the right position if needed */
 	while (pos--)
@@ -121,7 +96,7 @@ static bool end_of_vgic(struct vgic_state_iter *iter)
 	return iter->dist_id > 0 &&
 		iter->vcpu_id == iter->nr_cpus &&
 		iter->intid >= (iter->nr_spis + VGIC_NR_PRIVATE_IRQS) &&
-		(!iter->nr_lpis || iter->lpi_idx > iter->nr_lpis);
+		iter->intid > VGIC_LPI_MAX_INTID;
 }
 
 static void *vgic_debug_start(struct seq_file *s, loff_t *pos)
@@ -178,7 +153,6 @@ static void vgic_debug_stop(struct seq_file *s, void *v)
 
 	mutex_lock(&kvm->arch.config_lock);
 	iter = kvm->arch.vgic.iter;
-	iter_unmark_lpis(kvm);
 	kfree(iter);
 	kvm->arch.vgic.iter = NULL;
 	mutex_unlock(&kvm->arch.config_lock);
@@ -188,13 +162,14 @@ static void print_dist_state(struct seq_file *s, struct vgic_dist *dist,
 			     struct vgic_state_iter *iter)
 {
 	bool v3 = dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3;
+	struct kvm *kvm = s->private;
 
 	seq_printf(s, "Distributor\n");
 	seq_printf(s, "===========\n");
 	seq_printf(s, "vgic_model:\t%s\n", v3 ? "GICv3" : "GICv2");
 	seq_printf(s, "nr_spis:\t%d\n", dist->nr_spis);
 	if (v3)
-		seq_printf(s, "nr_lpis:\t%d\n", iter->nr_lpis);
+		seq_printf(s, "nr_lpis:\t%d\n", vgic_count_lpis(kvm));
 	seq_printf(s, "enabled:\t%d\n", dist->enabled);
 	seq_printf(s, "\n");
 
@@ -291,16 +266,13 @@ static int vgic_debug_show(struct seq_file *s, void *v)
 	if (iter->vcpu_id < iter->nr_cpus)
 		vcpu = kvm_get_vcpu(kvm, iter->vcpu_id);
 
-	/*
-	 * Expect this to succeed, as iter_mark_lpis() takes a reference on
-	 * every LPI to be visited.
-	 */
 	if (iter->intid < VGIC_NR_PRIVATE_IRQS)
 		irq = vgic_get_vcpu_irq(vcpu, iter->intid);
 	else
 		irq = vgic_get_irq(kvm, iter->intid);
-	if (WARN_ON_ONCE(!irq))
-		return -EINVAL;
+
+	if (!irq)
+		return 0;
 
 	raw_spin_lock_irqsave(&irq->irq_lock, flags);
 	print_irq_state(s, irq, vcpu);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index b261fb3968d0..d32fafbd2907 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -300,7 +300,6 @@ struct vgic_dist {
 	 */
 	u64			propbaser;
 
-#define LPI_XA_MARK_DEBUG_ITER	XA_MARK_0
 	struct xarray		lpi_xa;
 
 	/* used by vgic-debug */
-- 
2.53.0.rc1.225.gd81095ad13-goog


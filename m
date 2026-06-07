Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554B07082D
	for <kvmarm@lists.linux.dev>; Sun,  7 Jun 2026 22:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780871114; cv=none; b=aOnstU9kBIx5ZdwfHIdWgo6xxN/rSX1yTe/xlBd6C2ADbxRCwhG5jvBUxwL2LsfRXBZTsbNgeAaIOYEUqWcfhgvepZNx+0eMhoKIFViiQUqG3BdLBuBA9w2FmimcsqQyLbwW2H8BOtDGuIf0d7xxQbPiknyymh57+pKtT9/9MPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780871114; c=relaxed/simple;
	bh=s77Qf6Odwqp3OC7+V+qkg96k6SAZIyA0HsSFMWeauLc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pg0KBsJYIYQFhiK0aP8dTfaGkPXc4426Jx6FX7wyCfDxGHyt99xphE+uNsS07W2XVbNU/mK5SYPIXMizfXl+g5Xz6tlq9OypWgFSyh3EI/ycHkwV48hrRwtpfhkIW7OQUnnVavN/fVnmEO9JaPzzTyAgo1Aa/sgGtnTzpWmRUqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IDQ5+l+P; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IDQ5+l+P"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-c85825bbc4fso2249467a12.2
        for <kvmarm@lists.linux.dev>; Sun, 07 Jun 2026 15:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780871111; x=1781475911; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0itC2qO70gJYijc+S4/89kNYU8jUE/h/YyEMUrP+me4=;
        b=IDQ5+l+P7KJL+MtwMB3F2bZ2E8QuQK75nYGKNQbH9HPCm7jD9qgbHHLhNSDNuLM3Pn
         UNaa2f+iTyg4YwxxZg4WaPWzg7gMov5tD8T10bzHpXe3r9Y6esIzXufTmmq2XsmMelhi
         019Ndkse+iKodrNR23ol731L7EZNZvM8o9FHfiVYpAaDvzty+u8v2EZq4+lkvYRuLoA2
         v0VvZg+bWQrkx9ZD2w8Chl1h2ry03qG+BBklKyhNqFJY2R+FkikSItDJZYMp/W6CEcyl
         wEmvhuxe1yFdCMH35nHb+RTW286Nu+zBfEWn+DR2IfEgODuWKEbkLqxHWl454BUOqHqK
         xdSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780871111; x=1781475911;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0itC2qO70gJYijc+S4/89kNYU8jUE/h/YyEMUrP+me4=;
        b=P+bejpoTI0sjCITSagkB6IJHHesjezBwRfTW0tOwkOFi8O6UdkkUE6r5eIKCUGtww8
         7ZnmsR06otA8m9mC197ayzPuyRNHxrFjp4GqD2cd9Z645bt14+dLSh2JtDPesr/EI4AM
         woPOnGZdRxgBnPvgwsUan+P6eZg6bsI7pX3BjlOhZ0+Um9sYKyNvN89TlKvX2JE2YJ/r
         lrBpoiOptqq9M89leo0o9lkDzi4kLarcnlkZ/8UsFKpqWJz43tr3WkByCU5TttccVr3N
         VnQ8qW/txVmlbpNUXD5Kzum7q7VO7KizUefMulcdodflnwT3zQbAyKywRB3RA0pL/37P
         FGQg==
X-Forwarded-Encrypted: i=1; AFNElJ+Z93JJqJeh6HARrpZrC01kNSiIR3f78IIfhBG81mYOScJOP0EBc/Ye4a+LTiCqCRUf8SwN97Y=@lists.linux.dev
X-Gm-Message-State: AOJu0YxadYYWTqcwr1D4C4DdkIu2YvAP/IlQSvot/NkqYn++b8+fn36V
	ypxOwGF5kfjrnCmAAWKWllmEuYXsC68LZPuonaTiqdV8mnqNmPcIxIMs
X-Gm-Gg: Acq92OHD+pLlbhw8DVtg/TtygzcmfhrzCFgnw0tXRHPxS6/VurLnUDLedUi5NdIX4Xx
	8N1UzIjNHu/jgwgkPcNSR2TUR1HD+o7nk6FQeVnI1O4jMmzXRrW8jOW9UO03toZp3di2tTX9AdZ
	QyVFN6wSYJ4e//oh8VeTktZQMpi25h65Rdbun4Tbg4zhn63SOERVaQNNBHO4CcxAgFiHaS/mM7q
	sUYUZqQu0oOcYyAbWMY+KPQv9GMh49uCZw6QpJG1IFNR4Qe1GDNkbIl8F+bC7bnGEmMcVPKk26F
	2L+24LCwSRsB2vG0N49l4PrUX8ZYPZjZhWSMFfqCfqgxtuIDrSqIhGkz3sk+ONf/8FV56PVoexM
	GnAfhXGxb99KQOZr8ZgqWJzliDXXKYwnZtAnbBgqV36cgz3otok78shfO7YCwPTXrPYiXaiOy20
	lhhZKNfnBHw68xmQyyktwIMEk5WYoiXpPHbl3SNPEqkQOddzsCuFcVNg==
X-Received: by 2002:a05:6a00:228d:b0:842:6c02:2fa4 with SMTP id d2e1a72fcca58-842b0d60127mr12645069b3a.14.1780871111352;
        Sun, 07 Jun 2026 15:25:11 -0700 (PDT)
Received: from v4bel ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-842828e02f9sm15847420b3a.48.2026.06.07.15.25.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2026 15:25:09 -0700 (PDT)
Date: Mon, 8 Jun 2026 07:25:04 +0900
From: Hyunwoo Kim <imv4bel@gmail.com>
To: Marc Zyngier <maz@kernel.org>, oupton@kernel.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
	Sascha.Bischoff@arm.com, jic23@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	imv4bel@gmail.com
Subject: Re: [PATCH] KVM: arm64: vgic: Use list_del_rcu() when flushing
 pending LPIs
Message-ID: <aiXvwGD1hS6vwLEd@v4bel>
References: <aiHrGM1f8czcUby4@v4bel>
 <aiJi5a3JJ-TbWL-s@kernel.org>
 <87a4t99z9n.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a4t99z9n.wl-maz@kernel.org>

On Fri, Jun 05, 2026 at 09:17:56AM +0100, Marc Zyngier wrote:
> On Fri, 05 Jun 2026 06:47:17 +0100,
> Oliver Upton <oupton@kernel.org> wrote:
> > 
> > Hi Hyunwoo,
> > 
> > On Fri, Jun 05, 2026 at 06:16:08AM +0900, Hyunwoo Kim wrote:
> > > vgic_v3_fold_lr_state() walks the ap_list from last_lr_irq without holding
> > > the ap_list_lock, relying on vgic_irq being freed via kfree_rcu() and on
> > > interrupts being disabled. vgic_flush_pending_lpis() removes entries with
> > > list_del(), which clobbers a node's next pointer, so when another vCPU
> > > disables LPIs via GICR_CTLR the walk can follow the clobbered next pointer
> > > from a removed node, or from the node that last_lr_irq points to.
> > > 
> > > Remove entries with list_del_rcu() so that the next pointer stays valid
> > > until the walk completes.
> > > 
> > > Fixes: 3cfd59f81e0f ("KVM: arm64: GICv3: Handle LR overflow when EOImode==0")
> > > Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
> > 
> > Changing only one of the writer paths to use the rculist helpers does
> > not make the ap_list an rculist. Insertions are not RCU-safe, nor are
> > deleations from vgic_prune_ap_list().
> > 
> > And TBH, the real bug here is the fact that vgic_v3_fold_lr_state() isn't
> > taking the ap_list_lock.
> 
> Yup, that'd be more sensible. I need to convince myself that there is
> no possible path from vgic_v*_fold_lr() to vgic_irq_queue_unlock(),
> because that one does actually acquire that lock.

I did some more digging into this. What are your thoughts on this 
ap_list_lock approach? It doesn't seem like there's a deadlock problem.
Additionally, this also fixes the eventfd lock-nesting.

This is quite a substantial change, though.


Best regards,
Hyunwoo Kim

---

vgic_v3_fold_lr_state() and vgic_v2_fold_lr_state() walk the tail of the
ap_list starting from last_lr_irq to replay EOIcount-based deactivations.
This walk runs without the ap_list_lock, yet the other paths that touch the
ap_list (vgic_flush_state, vgic_flush_pending_lpis, vgic_prune_ap_list,
vgic_queue_irq_unlock) all take that lock.

Another vCPU can therefore change the ap_list during the walk. For example,
clearing ENABLE_LPIS in GICR_CTLR makes vgic_flush_pending_lpis() remove an
LPI with list_del(), and prune and interrupt injection also add and remove
entries. A lock-free walk can follow the next pointer of a node that has
already been removed. last_lr_irq is also recorded at flush time and
consumed at fold time, so it spans the guest run and may be unlinked from
the ap_list or released in the meantime.

Take the ap_list_lock in vgic_fold_state(), as vgic_flush_state() does, to
serialize the walk against the ap_list modifiers.

vgic_put_irq() takes lpi_xa, and the lock order places lpi_xa above the
ap_list_lock, so calling it while the fold holds the ap_list_lock inverts
that order. The fold therefore only drops the reference with
vgic_put_irq_norelease() and reclaims the LPIs with
vgic_release_deleted_lpis() after dropping the lock, the same way
vgic_flush_pending_lpis() and vgic_prune_ap_list() already do.

Pin last_lr_irq with vgic_get_irq_ref() in vgic_flush_lr_state() so it is
not released during the guest run, continue the tail walk only while it is
still on this vCPU's ap_list, and drop the reference at the end of the
fold.

kvm_notify_acked_irq() takes a regular spinlock via eventfd_signal()
through a registered irqfd resampler, and can re-enter the vgic via
kvm_set_irq() to reach vgic_queue_irq_unlock(), which takes the
ap_list_lock. Neither may run under the raw ap_list_lock, so during the
fold, record only the SPI in question and notify after dropping the
ap_list_lock. The vgic_v3_deactivate() and vgic_v2_deactivate() paths,
which do not take the ap_list_lock, notify directly as before.

---

diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
index cafa3cb32bda6..fd3db099e1fe9 100644
--- a/arch/arm64/kvm/vgic/vgic-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-v2.c
@@ -53,7 +53,7 @@ static bool lr_signals_eoi_mi(u32 lr_val)
 	       !(lr_val & GICH_LR_HW);
 }

-static void vgic_v2_fold_lr(struct kvm_vcpu *vcpu, u32 val)
+static bool vgic_v2_fold_lr(struct kvm_vcpu *vcpu, u32 val, unsigned long *eoi_spis)
 {
 	u32 cpuid, intid = val & GICH_LR_VIRTUALID;
 	struct vgic_irq *irq;
@@ -63,9 +63,13 @@ static void vgic_v2_fold_lr(struct kvm_vcpu *vcpu, u32 val)
 	cpuid = FIELD_GET(GICH_LR_PHYSID_CPUID, val) & 7;

 	/* Notify fds when the guest EOI'ed a level-triggered SPI */
-	if (lr_signals_eoi_mi(val) && vgic_valid_spi(vcpu->kvm, intid))
-		kvm_notify_acked_irq(vcpu->kvm, 0,
-				     intid - VGIC_NR_PRIVATE_IRQS);
+	if (lr_signals_eoi_mi(val) && vgic_valid_spi(vcpu->kvm, intid)) {
+		if (eoi_spis)
+			__set_bit(intid - VGIC_NR_PRIVATE_IRQS, eoi_spis);
+		else
+			kvm_notify_acked_irq(vcpu->kvm, 0,
+					     intid - VGIC_NR_PRIVATE_IRQS);
+	}

 	irq = vgic_get_vcpu_irq(vcpu, intid);

@@ -98,7 +102,7 @@ static void vgic_v2_fold_lr(struct kvm_vcpu *vcpu, u32 val)
 		irq->on_lr = false;
 	}

-	vgic_put_irq(vcpu->kvm, irq);
+	return vgic_put_irq_norelease(vcpu->kvm, irq);
 }

 static u32 vgic_v2_compute_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq);
@@ -110,19 +114,25 @@ static u32 vgic_v2_compute_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq);
  *   - transferred as is in case of edge sensitive IRQs
  *   - set to the line-level (resample time) for level sensitive IRQs
  */
-void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
+bool vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu, unsigned long *eoi_spis)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	struct vgic_v2_cpu_if *cpuif = &vgic_cpu->vgic_v2;
 	u32 eoicount = FIELD_GET(GICH_HCR_EOICOUNT, cpuif->vgic_hcr);
-	struct vgic_irq *irq = *host_data_ptr(last_lr_irq);
+	struct vgic_irq *last = *host_data_ptr(last_lr_irq);
+	struct vgic_irq *irq = last;
+	bool deleted = false;

 	DEBUG_SPINLOCK_BUG_ON(!irqs_disabled());
+	lockdep_assert_held(&vgic_cpu->ap_list_lock);

 	for (int lr = 0; lr < vgic_cpu->vgic_v2.used_lrs; lr++)
-		vgic_v2_fold_lr(vcpu, cpuif->vgic_lr[lr]);
+		deleted |= vgic_v2_fold_lr(vcpu, cpuif->vgic_lr[lr], eoi_spis);

 	/* See the GICv3 equivalent for the EOIcount handling rationale */
+	if (!last || last->vcpu != vcpu)
+		goto done;
+
 	list_for_each_entry_continue(irq, &vgic_cpu->ap_list_head, ap_list) {
 		u32 lr;

@@ -141,11 +151,17 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
 		if (lr & GICH_LR_HW)
 			writel_relaxed(FIELD_GET(GICH_LR_PHYSID_CPUID, lr),
 				       kvm_vgic_global_state.gicc_base + GIC_CPU_DEACTIVATE);
-		vgic_v2_fold_lr(vcpu, lr);
+		deleted |= vgic_v2_fold_lr(vcpu, lr, eoi_spis);
 		eoicount--;
 	}

+done:
+	if (last)
+		deleted |= vgic_put_irq_norelease(vcpu->kvm, last);
+
 	cpuif->used_lrs = 0;
+
+	return deleted;
 }

 void vgic_v2_deactivate(struct kvm_vcpu *vcpu, u32 val)
@@ -205,7 +221,7 @@ void vgic_v2_deactivate(struct kvm_vcpu *vcpu, u32 val)
 		writel_relaxed(FIELD_GET(GICH_LR_PHYSID_CPUID, lr),
 			       kvm_vgic_global_state.gicc_base + GIC_CPU_DEACTIVATE);

-	vgic_v2_fold_lr(vcpu, lr);
+	vgic_v2_fold_lr(vcpu, lr, NULL);

 put:
 	vgic_put_irq(vcpu->kvm, irq);
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 9e841e7afd4a7..f019edf574c3e 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -71,7 +71,7 @@ static bool lr_signals_eoi_mi(u64 lr_val)
 	       !(lr_val & ICH_LR_HW);
 }

-static void vgic_v3_fold_lr(struct kvm_vcpu *vcpu, u64 val)
+static bool vgic_v3_fold_lr(struct kvm_vcpu *vcpu, u64 val, unsigned long *eoi_spis)
 {
 	struct vgic_irq *irq;
 	bool is_v2_sgi = false;
@@ -87,7 +87,7 @@ static void vgic_v3_fold_lr(struct kvm_vcpu *vcpu, u64 val)

 	irq = vgic_get_vcpu_irq(vcpu, intid);
 	if (!irq)	/* An LPI could have been unmapped. */
-		return;
+		return false;

 	scoped_guard(raw_spinlock, &irq->irq_lock) {
 		/* Always preserve the active bit for !LPIs, note deactivation */
@@ -125,12 +125,15 @@ static void vgic_v3_fold_lr(struct kvm_vcpu *vcpu, u64 val)

 	/* Notify fds when the guest EOI'ed a level-triggered SPI, and drop the refcount */
 	if (deactivated && lr_signals_eoi_mi(val) && vgic_valid_spi(vcpu->kvm, intid)) {
-		kvm_notify_acked_irq(vcpu->kvm, 0,
-				     intid - VGIC_NR_PRIVATE_IRQS);
+		if (eoi_spis)
+			__set_bit(intid - VGIC_NR_PRIVATE_IRQS, eoi_spis);
+		else
+			kvm_notify_acked_irq(vcpu->kvm, 0,
+					     intid - VGIC_NR_PRIVATE_IRQS);
 		atomic_dec_if_positive(&vcpu->kvm->arch.vgic.active_spis);
 	}

-	vgic_put_irq(vcpu->kvm, irq);
+	return vgic_put_irq_norelease(vcpu->kvm, irq);
 }

 static u64 vgic_v3_compute_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq);
@@ -143,17 +146,20 @@ static void vgic_v3_deactivate_phys(u32 intid)
 		gic_write_dir(intid);
 }

-void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
+bool vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu, unsigned long *eoi_spis)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	struct vgic_v3_cpu_if *cpuif = &vgic_cpu->vgic_v3;
 	u32 eoicount = FIELD_GET(ICH_HCR_EL2_EOIcount, cpuif->vgic_hcr);
-	struct vgic_irq *irq = *host_data_ptr(last_lr_irq);
+	struct vgic_irq *last = *host_data_ptr(last_lr_irq);
+	struct vgic_irq *irq = last;
+	bool deleted = false;

 	DEBUG_SPINLOCK_BUG_ON(!irqs_disabled());
+	lockdep_assert_held(&vgic_cpu->ap_list_lock);

 	for (int lr = 0; lr < cpuif->used_lrs; lr++)
-		vgic_v3_fold_lr(vcpu, cpuif->vgic_lr[lr]);
+		deleted |= vgic_v3_fold_lr(vcpu, cpuif->vgic_lr[lr], eoi_spis);

 	/*
 	 * EOIMode=0: use EOIcount to emulate deactivation. We are
@@ -161,8 +167,12 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
 	 * just pick one active interrupt after the other in the tail part
 	 * of the ap_list, past the LRs, and replay the deactivation as if
 	 * the CPU was doing it. We also rely on priority drop to have taken
-	 * place, and the list to be sorted by priority.
+	 * place, and the list to be sorted by priority. Skip if a remote
+	 * flush/prune unlinked last_lr_irq during the guest run.
 	 */
+	if (!last || last->vcpu != vcpu)
+		goto done;
+
 	list_for_each_entry_continue(irq, &vgic_cpu->ap_list_head, ap_list) {
 		u64 lr;

@@ -185,11 +195,17 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
 		if (lr & ICH_LR_HW)
 			vgic_v3_deactivate_phys(FIELD_GET(ICH_LR_PHYS_ID_MASK, lr));

-		vgic_v3_fold_lr(vcpu, lr);
+		deleted |= vgic_v3_fold_lr(vcpu, lr, eoi_spis);
 		eoicount--;
 	}

+done:
+	if (last)
+		deleted |= vgic_put_irq_norelease(vcpu->kvm, last);
+
 	cpuif->used_lrs = 0;
+
+	return deleted;
 }

 void vgic_v3_deactivate(struct kvm_vcpu *vcpu, u64 val)
@@ -278,7 +294,7 @@ void vgic_v3_deactivate(struct kvm_vcpu *vcpu, u64 val)
 	if (lr & ICH_LR_HW)
 		vgic_v3_deactivate_phys(FIELD_GET(ICH_LR_PHYS_ID_MASK, lr));

-	vgic_v3_fold_lr(vcpu, lr);
+	vgic_v3_fold_lr(vcpu, lr, NULL);

 put:
 	vgic_put_irq(vcpu->kvm, irq);
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 1e9fe8764584d..2461a77576a2b 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -145,7 +145,7 @@ static __must_check bool __vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
 	return refcount_dec_and_test(&irq->refcount);
 }

-static __must_check bool vgic_put_irq_norelease(struct kvm *kvm, struct vgic_irq *irq)
+__must_check bool vgic_put_irq_norelease(struct kvm *kvm, struct vgic_irq *irq)
 {
 	if (!__vgic_put_irq(kvm, irq))
 		return false;
@@ -855,6 +855,11 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)

 static void vgic_fold_state(struct kvm_vcpu *vcpu)
 {
+	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+	DECLARE_BITMAP(eoi_spis, VGIC_MAX_SPI - VGIC_NR_PRIVATE_IRQS + 1);
+	bool deleted = false;
+	int spi;
+
 	if (vgic_is_v5(vcpu->kvm)) {
 		vgic_v5_fold_ppi_state(vcpu);
 		return;
@@ -863,10 +868,21 @@ static void vgic_fold_state(struct kvm_vcpu *vcpu)
 	if (!*host_data_ptr(last_lr_irq))
 		return;

-	if (kvm_vgic_global_state.type == VGIC_V2)
-		vgic_v2_fold_lr_state(vcpu);
-	else
-		vgic_v3_fold_lr_state(vcpu);
+	bitmap_zero(eoi_spis, VGIC_MAX_SPI - VGIC_NR_PRIVATE_IRQS + 1);
+
+	scoped_guard(raw_spinlock, &vgic_cpu->ap_list_lock) {
+		if (kvm_vgic_global_state.type == VGIC_V2)
+			deleted = vgic_v2_fold_lr_state(vcpu, eoi_spis);
+		else
+			deleted = vgic_v3_fold_lr_state(vcpu, eoi_spis);
+	}
+
+	if (unlikely(deleted))
+		vgic_release_deleted_lpis(vcpu->kvm);
+
+	/* kvm_notify_acked_irq() grabs regular spinlocks; call after unlock. */
+	for_each_set_bit(spi, eoi_spis, VGIC_MAX_SPI - VGIC_NR_PRIVATE_IRQS + 1)
+		kvm_notify_acked_irq(vcpu->kvm, 0, spi);
 }

 /* Requires the irq_lock to be held. */
@@ -1023,6 +1039,10 @@ static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
 			break;
 	}

+	/* Pin the EOIcount walk start; it may be freed during the guest run. */
+	if (*host_data_ptr(last_lr_irq))
+		vgic_get_irq_ref(*host_data_ptr(last_lr_irq));
+
 	/* Nuke remaining LRs */
 	for (int i = count ; i < kvm_vgic_global_state.nr_lr; i++)
 		vgic_clear_lr(vcpu, i);
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 9d941241c8a2b..e52012f4bdec9 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -262,6 +262,7 @@ vgic_get_mmio_region(struct kvm_vcpu *vcpu, struct vgic_io_device *iodev,
 struct vgic_irq *vgic_get_irq(struct kvm *kvm, u32 intid);
 struct vgic_irq *vgic_get_vcpu_irq(struct kvm_vcpu *vcpu, u32 intid);
 void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq);
+__must_check bool vgic_put_irq_norelease(struct kvm *kvm, struct vgic_irq *irq);
 struct kvm_vcpu *vgic_target_oracle(struct vgic_irq *irq);
 bool vgic_get_phys_line_level(struct vgic_irq *irq);
 void vgic_irq_set_phys_pending(struct vgic_irq *irq, bool pending);
@@ -276,7 +277,7 @@ int vgic_check_iorange(struct kvm *kvm, phys_addr_t ioaddr,
 		       phys_addr_t addr, phys_addr_t alignment,
 		       phys_addr_t size);

-void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu);
+bool vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu, unsigned long *eoi_spis);
 void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
 void vgic_v2_deactivate(struct kvm_vcpu *vcpu, u32 val);
 void vgic_v2_clear_lr(struct kvm_vcpu *vcpu, int lr);
@@ -317,7 +318,7 @@ static inline void vgic_get_irq_ref(struct vgic_irq *irq)
 	WARN_ON_ONCE(!vgic_try_get_irq_ref(irq));
 }

-void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu);
+bool vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu, unsigned long *eoi_spis);
 void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
 void vgic_v3_clear_lr(struct kvm_vcpu *vcpu, int lr);
 void vgic_v3_deactivate(struct kvm_vcpu *vcpu, u64 val);

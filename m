Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E50A40863A
	for <kvmarm@lists.linux.dev>; Wed, 10 Jun 2026 13:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781099539; cv=none; b=bbYucZuBTtA02a1VkZ2Xw9MnE/vC+mZnVj7oTD+OBIdQinJC7MFoqf5OnHhxBq0p0puD34xSSVYMf21UsbKEJzW2ccoqWyYMX/tMHnWPO2C4b6O0aMNcLGsfkB8aX5NJiHYPQ3bHXhuaZsvXozrYkUcPEc7JgYqNJo3x1PoWAqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781099539; c=relaxed/simple;
	bh=1nfS/i8MeWrnmlz3RnYWlCdiS2SVt8caZN1sMYHeGXc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BpaeYmynG7F7agzlHp4DF5OMC9CYrZUml7tHWrTwRSXa1VnIbvs5tOrh9fVBJr7I2tRJ4PDkxjuKYdLp/Wcxd5lxJHw9KLKlccEmAtLF+GoVz1dtu2U/RFP2e6f9iffD6r2BnW7Ie/imNfuH2QkyqjvNBq/9BsWknY0Zgrb7TwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H60GOdRD; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H60GOdRD"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-8422a92b6d6so3586869b3a.1
        for <kvmarm@lists.linux.dev>; Wed, 10 Jun 2026 06:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781099536; x=1781704336; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=m8cH7ELiB7PUfRPmkIhoyO3yqncqCyIggpzl6Mz6h3k=;
        b=H60GOdRDkeLRSlZNP0bG2u7QPKkEmlfvHSQM8ccmlP/VBchTpSs1Ra20wX/3uZmEI2
         m3zfARTSZf8P7DvjSFASVxxdABrzvVeDihj6+ffTckhqAuDhykSpMupciGVJ36oO5ikP
         Cc72atnzZ9EpdactclEcqmv8GsboSDwnAsXA3h7+7NFC6v4dF4Gbfw71SpwAh5GreNH8
         U503mvaP2ZdagT1S6IeUJtB56Bt3HQpVB0SsxvQgS0hABR/000qL6CiR/AJKG6ZzeKIP
         8MghN1EPbKrs1tzD+A4ES6RnzeMBFha/PWclUfyCa1FV0Nf83vGFfgWTh66iUOfrWkhJ
         n14Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781099536; x=1781704336;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m8cH7ELiB7PUfRPmkIhoyO3yqncqCyIggpzl6Mz6h3k=;
        b=U7Ho9B0mFJsEuqdffWfcRDN/rF3BxOaDP0YGK4gXvUn+DLwoVnrZHCEN2VivWN7ckl
         9le24RWLsQhrrIseSVEnQT+gg7CW+XMSsk8XOetrLlZWD69zM/6sJMg0sH1Qhlngwi5y
         V70AJ7DS58YuLk7+DxkFvv8bfHbqVEl6ZeDHvNS+WydRQdM8QRXxJ0d6tKSmQdsyMvYG
         M8zPzHXxRt4r6XeBIL0ZtKxk5o5QHFDy7JbLVAC5Ircnm1gnAYGwAh7cPzopTFRB1J35
         FnsbdVtej++0kRrfSg999q20c+ShqdLFZYD7ApDUPh484aY3lNtS9v8zo5qns3Gj8S8z
         Mrxw==
X-Forwarded-Encrypted: i=1; AFNElJ9ERvzaw6ch+7apBOO/1QPD7ute7XgEP/K/U+R2kyrhlB1d7DMXTXH4Hh/TS/N4e9/tJvdN6Rk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz3vsSCtmd3THKgL1KjiCsz6RvOXud9I4VihMECokMbGYF2Ga2P
	9HvFWB+MKfxCKoBMXzzBc7ZoAtrlH1U4CDE/r8u3AvBnMG1jR6p+claH
X-Gm-Gg: Acq92OE0jIuLFmn0XG60rFZAlcF9IuWnAMFe1QuGwZejI4nmog4JLJPJIFIaD5JCjfh
	kaqAihQ8s6q+NDVE2h/GRWQaHcYUfiJac5mvAuW8Z7qy5vJItgYILLnCliVLO+laSaJ7dTnl0Fp
	40Womj/8m0ZPSMWkwNvep5XK5K8N3gfp0BvBaZySgdp2sJouYFJtLujwZY03LSs4iHKSQ0kvxXP
	3AiBuQYiLFirl5eCIFCPEMvzIZMlREO3F7JAs1plH5RUl3A8Vm+UAEzPZmiuAqip9VqpGzUzGIw
	S4nfnOWaJ4ZzEFjgUATiMlc9/JDXekKb6hKfQfmfQbNv1Wq/GsuqFFtodI9QtlPLpOkoqDgcltM
	3E3J4YEw4qWrHkFN391n5CP5ji/t1LDS9NPmt2GqXZrIgSxbM25vsrJmZs/nhLIf5tF5GSS9Yny
	eT04DwgTGWxEMCSnH6vaDTUBBUJ5lc1docqmGGyMc8mKoAjlTxYw+uxA==
X-Received: by 2002:a05:6a00:32c4:b0:842:6259:5e2b with SMTP id d2e1a72fcca58-842b685d4demr20157465b3a.33.1781099536132;
        Wed, 10 Jun 2026 06:52:16 -0700 (PDT)
Received: from v4bel ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84282372a16sm29689105b3a.18.2026.06.10.06.52.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2026 06:52:15 -0700 (PDT)
Date: Wed, 10 Jun 2026 22:52:10 +0900
From: Hyunwoo Kim <imv4bel@gmail.com>
To: Oliver Upton <oupton@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, joey.gouly@arm.com, seiden@linux.ibm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, Sascha.Bischoff@arm.com,
	jic23@kernel.org, timothy.hayes@arm.com, andre.przywara@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	imv4bel@gmail.com
Subject: Re: [PATCH] KVM: arm64: vgic: Check the interrupt is still ours
 before migrating it
Message-ID: <ailsCnyoS82r_QRz@v4bel>
References: <aiHnI1mu6SGQrgnz@v4bel>
 <aiJmBfXAxcytfGha@kernel.org>
 <87ecila0w3.wl-maz@kernel.org>
 <aiKMNIUMv9GQiIbD@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiKMNIUMv9GQiIbD@kernel.org>

On Fri, Jun 05, 2026 at 01:43:32AM -0700, Oliver Upton wrote:
> On Fri, Jun 05, 2026 at 08:42:52AM +0100, Marc Zyngier wrote:
> > On Fri, 05 Jun 2026 07:00:37 +0100,
> > Oliver Upton <oupton@kernel.org> wrote:
> > > 
> > > On Fri, Jun 05, 2026 at 05:59:15AM +0900, Hyunwoo Kim wrote:
> > > > vgic_prune_ap_list() drops both ap_list_lock and irq_lock while migrating
> > > > an interrupt to another vCPU. After reacquiring the locks it only checks
> > > > that the affinity is unchanged (target_vcpu == vgic_target_oracle(irq))
> > > > before moving the interrupt, which assumes that an interrupt whose affinity
> > > > is preserved is still queued on this vCPU's ap_list.
> > > > 
> > > > That assumption no longer holds if the interrupt is taken off the ap_list
> > > > while the locks are dropped. vgic_flush_pending_lpis() removes the
> > > > interrupt from the list and sets irq->vcpu to NULL, but leaves
> > > > enabled/pending/target_vcpu untouched. As the interrupt is still enabled
> > > > and pending, vgic_target_oracle() returns the same target_vcpu, so the
> > > > affinity check passes and list_del() is run a second time on an entry that
> > > > has already been removed.
> > > > 
> > > > Also check that the interrupt is still assigned to this vCPU
> > > > (irq->vcpu == vcpu) before moving it.
> > > > 
> > > > Fixes: 0919e84c0fc1 ("KVM: arm/arm64: vgic-new: Add IRQ sync/flush framework")
> > > > Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
> > > 
> > > Looking at this and the other VGIC patch you sent (which should've been
> > > a combined series), are you trying to deal with a vCPU writing to
> > > another vCPU's redistributor? I.e. vCPU B setting GICR_CTLR.EnableLPIs=0
> > > behind the back of vCPU A?
> > > 
> > > That is extremely relevant information as the off-the-cuff reaction is
> > > that no race exists. But since the GIC architecture is awesome and
> > > allows for this sort of insanity, it obviously does....
> > > 
> > > Anyway, for LPIs resident on a particular RD, there's zero expectation
> > > that the pending state is preserved when EnableLPIs=0. So I'd rather
> > > vgic_flush_pending_lpis() just invalidate the pending state.
> > 
> > Just clearing the pending state introduces a potential problem as we
> > now have an interrupt that is neither active nor pending on the AP
> > list. It is not impossible to solve (we now have similar behaviours
> > with SPI deactivation from another vcpu), but that requires posting a
> > KVM_REQ_VGIC_PROCESS_UPDATE to the target vcpu.
> 
> Right, I was suggesting that in addition to deleting the LPI from the AP
> list we actually invalidate the pending state so that someone sitting on
> a pointer to a to-be-freed LPI sees vgic_target_oracle() returning
> NULL
> 
> > > Beyond that, I see two other fixes for lifetime issues around the
> > > vgic_irq in the middle of migration. I'd like to see explicit RCU
> > > protection around the release && reacquire of the ap_list_lock rather
> > > than depending on the precondition that IRQs are disabled.
> > 
> > I'm not sure I follow. Are you suggesting turning the AP list into an
> > RCU protected list?
> 
> No, sorry, I should expand a little.
> 
> We store a reference on the vgic_irq struct in the AP list, which is
> stable so long as the ap_list_lock is held. It should be possible for
> the refcount to drop to 0 between releasing the ap_list_lock and
> reacquiring it.
> 
> So either vgic_prune_ap_list() takes an additional reference on the
> vgic_irq before dropping the ap_list_lock or rely on RCU to protect
> vgic_irq structs observed with a non-zero refcount.

What are your thoughts on this approach?


Best regards,
Hyunwoo Kim

---

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 933983bb2005..7fb871c3ccd8 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -523,7 +523,7 @@ static void __kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
 	 * Retire all pending LPIs on this vcpu anyway as we're
 	 * going to destroy it.
 	 */
-	vgic_flush_pending_lpis(vcpu);
+	vgic_flush_pending_lpis(vcpu, true);

 	INIT_LIST_HEAD(&vgic_cpu->ap_list_head);
 	kfree(vgic_cpu->private_irqs);
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 5913a20d8301..f85d63f17af0 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -303,7 +303,7 @@ static void vgic_mmio_write_v3r_ctlr(struct kvm_vcpu *vcpu,
 		if (ctlr != GICR_CTLR_ENABLE_LPIS)
 			return;

-		vgic_flush_pending_lpis(vcpu);
+		vgic_flush_pending_lpis(vcpu, false);
 		vgic_its_invalidate_all_caches(vcpu->kvm);
 		atomic_set_release(&vgic_cpu->ctlr, 0);
 	} else {
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 1e9fe8764584..09629a38fc0a 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -192,7 +192,7 @@ static void vgic_release_deleted_lpis(struct kvm *kvm)
 	xa_unlock_irqrestore(&dist->lpi_xa, flags);
 }

-void vgic_flush_pending_lpis(struct kvm_vcpu *vcpu)
+void vgic_flush_pending_lpis(struct kvm_vcpu *vcpu, bool destroy)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	struct vgic_irq *irq, *tmp;
@@ -204,6 +204,13 @@ void vgic_flush_pending_lpis(struct kvm_vcpu *vcpu)
 	list_for_each_entry_safe(irq, tmp, &vgic_cpu->ap_list_head, ap_list) {
 		if (irq_is_lpi(vcpu->kvm, irq->intid)) {
 			raw_spin_lock(&irq->irq_lock);
+			/* Leave interrupts pending a migration for prune. */
+			if (!destroy && irq->vcpu != vgic_target_oracle(irq)) {
+				raw_spin_unlock(&irq->irq_lock);
+				continue;
+			}
+			/* Pending state is not preserved across EnableLPIs=0. */
+			irq->pending_latch = false;
 			list_del(&irq->ap_list);
 			irq->vcpu = NULL;
 			raw_spin_unlock(&irq->irq_lock);
@@ -797,6 +804,9 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)

 		/* This interrupt looks like it has to be migrated. */

+		/* Keep the interrupt alive while the locks are dropped. */
+		vgic_get_irq_ref(irq);
+
 		raw_spin_unlock(&irq->irq_lock);
 		raw_spin_unlock(&vgic_cpu->ap_list_lock);

@@ -839,6 +849,8 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 		raw_spin_unlock(&vcpuB->arch.vgic_cpu.ap_list_lock);
 		raw_spin_unlock(&vcpuA->arch.vgic_cpu.ap_list_lock);

+		deleted_lpis |= vgic_put_irq_norelease(vcpu->kvm, irq);
+
 		if (target_vcpu_needs_kick) {
 			kvm_make_request(KVM_REQ_IRQ_PENDING, target_vcpu);
 			kvm_vcpu_kick(target_vcpu);
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 9d941241c8a2..c1ac24ede899 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -341,7 +341,7 @@ void vgic_v3_put(struct kvm_vcpu *vcpu);
 bool vgic_has_its(struct kvm *kvm);
 int kvm_vgic_register_its_device(void);
 void vgic_enable_lpis(struct kvm_vcpu *vcpu);
-void vgic_flush_pending_lpis(struct kvm_vcpu *vcpu);
+void vgic_flush_pending_lpis(struct kvm_vcpu *vcpu, bool destroy);
 int vgic_its_inject_msi(struct kvm *kvm, struct kvm_msi *msi);
 int vgic_v3_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr);
 int vgic_v3_dist_uaccess(struct kvm_vcpu *vcpu, bool is_write,

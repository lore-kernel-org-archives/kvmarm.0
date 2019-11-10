Return-Path: <SRS0=Yyg7=ZC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6C6BC43331
	for <kvmarm@archiver.kernel.org>; Sun, 10 Nov 2019 14:29:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 644BB2080F
	for <kvmarm@archiver.kernel.org>; Sun, 10 Nov 2019 14:29:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 644BB2080F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D04984ACD6;
	Sun, 10 Nov 2019 09:29:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9gkybqjfLNSG; Sun, 10 Nov 2019 09:29:19 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 769ED4ACFC;
	Sun, 10 Nov 2019 09:29:19 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A81664ACE8
 for <kvmarm@lists.cs.columbia.edu>; Sun, 10 Nov 2019 09:29:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id D2+KUHUZFgs8 for <kvmarm@lists.cs.columbia.edu>;
 Sun, 10 Nov 2019 09:29:17 -0500 (EST)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 53E6F4ACD6
 for <kvmarm@lists.cs.columbia.edu>; Sun, 10 Nov 2019 09:29:17 -0500 (EST)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why)
 by cheepnis.misterjones.org with esmtpsa (TLSv1.2:AES256-GCM-SHA384:256)
 (Exim 4.80) (envelope-from <maz@kernel.org>)
 id 1iToDL-0002g2-Vn; Sun, 10 Nov 2019 15:29:16 +0100
Date: Sun, 10 Nov 2019 14:29:14 +0000
From: Marc Zyngier <maz@kernel.org>
To: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH 2/3] kvm: arm: VGIC: Scan all IRQs when interrupt group
 gets enabled
Message-ID: <20191110142914.6ffdfdfa@why>
In-Reply-To: <20191108174952.740-3-andre.przywara@arm.com>
References: <20191108174952.740-1-andre.przywara@arm.com>
 <20191108174952.740-3-andre.przywara@arm.com>
Organization: Approximate
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Fri,  8 Nov 2019 17:49:51 +0000
Andre Przywara <andre.przywara@arm.com> wrote:

> Our current VGIC emulation code treats the "EnableGrpX" bits in GICD_CTLR
> as a single global interrupt delivery switch, where in fact the GIC
> architecture asks for this being separate for the two interrupt groups.
> 
> To implement this properly, we have to slightly adjust our design, to
> *not* let IRQs from a disabled interrupt group be added to the ap_list.
> 
> As a consequence, enabling one group requires us to re-evaluate every
> pending IRQ and potentially add it to its respective ap_list. Similarly
> disabling an interrupt group requires pending IRQs to be removed from
> the ap_list (as long as they have not been activated yet).
> 
> Implement a rather simple, yet not terribly efficient algorithm to
> achieve this: For each VCPU we iterate over all IRQs, checking for
> pending ones and adding them to the list. We hold the ap_list_lock
> for this, to make this atomic from a VCPU's point of view.
> 
> When an interrupt group gets disabled, we can't directly remove affected
> IRQs from the ap_list, as a running VCPU might have already activated
> them, which wouldn't be immediately visible to the host.
> Instead simply kick all VCPUs, so that they clean their ap_list's
> automatically when running vgic_prune_ap_list().
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic.c | 88 ++++++++++++++++++++++++++++++++++++----
>  1 file changed, 80 insertions(+), 8 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> index 3b88e14d239f..28d9ff282017 100644
> --- a/virt/kvm/arm/vgic/vgic.c
> +++ b/virt/kvm/arm/vgic/vgic.c
> @@ -339,6 +339,38 @@ int vgic_dist_enable_group(struct kvm *kvm, int group, bool status)
>  	return 0;
>  }
>  
> +/*
> + * Check whether a given IRQs need to be queued to this ap_list, and do
> + * so if that's the case.
> + * Requires the ap_list_lock to be held (but not the irq lock).
> + *
> + * Returns 1 if that IRQ has been added to the ap_list, and 0 if not.
> + */
> +static int queue_enabled_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
> +			     int intid)

true/false seems better than 1/0.

> +{
> +	struct vgic_irq *irq = vgic_get_irq(kvm, vcpu, intid);
> +	int ret = 0;
> +
> +	raw_spin_lock(&irq->irq_lock);
> +	if (!irq->vcpu && vcpu == vgic_target_oracle(irq)) {
> +		/*
> +		 * Grab a reference to the irq to reflect the
> +		 * fact that it is now in the ap_list.
> +		 */
> +		vgic_get_irq_kref(irq);
> +		list_add_tail(&irq->ap_list,
> +			      &vcpu->arch.vgic_cpu.ap_list_head);

Two things:
- This should be the job of vgic_queue_irq_unlock. Why are you
  open-coding it?
- What if the interrupt isn't pending? Non-pending, non-active
  interrupts should not be on the AP list!

> +		irq->vcpu = vcpu;
> +
> +		ret = 1;
> +	}
> +	raw_spin_unlock(&irq->irq_lock);
> +	vgic_put_irq(kvm, irq);
> +
> +	return ret;
> +}
> +
>  /*
>   * The group enable status of at least one of the groups has changed.
>   * If enabled is true, at least one of the groups got enabled.
> @@ -346,17 +378,57 @@ int vgic_dist_enable_group(struct kvm *kvm, int group, bool status)
>   */
>  void vgic_rescan_pending_irqs(struct kvm *kvm, bool enabled)
>  {
> +	int cpuid;
> +	struct kvm_vcpu *vcpu;
> +
>  	/*
> -	 * TODO: actually scan *all* IRQs of the VM for pending IRQs.
> -	 * If a pending IRQ's group is now enabled, add it to its ap_list.
> -	 * If a pending IRQ's group is now disabled, kick the VCPU to
> -	 * let it remove this IRQ from its ap_list. We have to let the
> -	 * VCPU do it itself, because we can't know the exact state of an
> -	 * IRQ pending on a running VCPU.
> +	 * If no group got enabled, we only have to potentially remove
> +	 * interrupts from ap_lists. We can't do this here, because a running
> +	 * VCPU might have ACKed an IRQ already, which wouldn't immediately
> +	 * be reflected in the ap_list.
> +	 * So kick all VCPUs, which will let them re-evaluate their ap_lists
> +	 * by running vgic_prune_ap_list(), removing no longer enabled
> +	 * IRQs.
> +	 */
> +	if (!enabled) {
> +		vgic_kick_vcpus(kvm);
> +
> +		return;
> +	}
> +
> +	/*
> +	 * At least one group went from disabled to enabled. Now we need
> +	 * to scan *all* IRQs of the VM for newly group-enabled IRQs.
> +	 * If a pending IRQ's group is now enabled, add it to the ap_list.
> +	 *
> +	 * For each VCPU this needs to be atomic, as we need *all* newly
> +	 * enabled IRQs in be in the ap_list to determine the highest
> +	 * priority one.
> +	 * So grab the ap_list_lock, then iterate over all private IRQs and
> +	 * all SPIs. Once the ap_list is updated, kick that VCPU to
> +	 * forward any new IRQs to the guest.
>  	 */
> +	kvm_for_each_vcpu(cpuid, vcpu, kvm) {
> +		unsigned long flags;
> +		int i;
>  
> -	 /* For now just kick all VCPUs, as the old code did. */
> -	vgic_kick_vcpus(kvm);
> +		raw_spin_lock_irqsave(&vcpu->arch.vgic_cpu.ap_list_lock, flags);
> +
> +		for (i = 0; i < VGIC_NR_PRIVATE_IRQS; i++)
> +			queue_enabled_irq(kvm, vcpu, i);
> +
> +		for (i = VGIC_NR_PRIVATE_IRQS;
> +		     i < kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS; i++)
> +			queue_enabled_irq(kvm, vcpu, i);

On top of my questions above, what happens to LPIs? And if a group has
been disabled, how do you retire these interrupts from the AP list?

> +
> +                raw_spin_unlock_irqrestore(&vcpu->arch.vgic_cpu.ap_list_lock,
> +                                           flags);
> +
> +		if (kvm_vgic_vcpu_pending_irq(vcpu)) {
> +			kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
> +			kvm_vcpu_kick(vcpu);
> +		}
> +	}
>  }
>  
>  bool vgic_dist_group_enabled(struct kvm *kvm, int group)

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

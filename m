Return-Path: <SRS0=mm64=ZL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BE30C43215
	for <kvmarm@archiver.kernel.org>; Tue, 19 Nov 2019 09:40:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CA38722304
	for <kvmarm@archiver.kernel.org>; Tue, 19 Nov 2019 09:40:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CA38722304
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F3A64AE94;
	Tue, 19 Nov 2019 04:40:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zrkqs9-YVnz9; Tue, 19 Nov 2019 04:40:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 845974A94E;
	Tue, 19 Nov 2019 04:40:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CF044A94E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Nov 2019 04:40:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Gv5XmjDlefaq for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Nov 2019 04:40:44 -0500 (EST)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D1CC94A5BD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Nov 2019 04:40:44 -0500 (EST)
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1iX000-0001Fd-RT; Tue, 19 Nov 2019 10:40:40 +0100
To: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH 2/3] kvm: arm: VGIC: Scan all IRQs when interrupt group
 gets enabled
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Date: Tue, 19 Nov 2019 09:40:40 +0000
From: Marc Zyngier <maz@kernel.org>
In-Reply-To: <20191118141216.352a3a0a@donnerap.cambridge.arm.com>
References: <20191108174952.740-1-andre.przywara@arm.com>
 <20191108174952.740-3-andre.przywara@arm.com> <20191110142914.6ffdfdfa@why>
 <20191112093658.08f248c5@donnerap.cambridge.arm.com>
 <9ddab86ca3959acbb8b7aad24be5f1ad@www.loen.fr>
 <20191118141216.352a3a0a@donnerap.cambridge.arm.com>
Message-ID: <4245ee82a03c9403f8e4ff815f032709@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Andre,

On 2019-11-18 14:12, Andre Przywara wrote:
> On Thu, 14 Nov 2019 11:16:55 +0000
> Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Marc,
>
>> On 2019-11-12 09:36, Andre Przywara wrote:
>> > On Sun, 10 Nov 2019 14:29:14 +0000
>> > Marc Zyngier <maz@kernel.org> wrote:
>> >
>> > Hi Marc,
>> >
>> >> On Fri,  8 Nov 2019 17:49:51 +0000
>> >> Andre Przywara <andre.przywara@arm.com> wrote:
>> >>
>> >> > Our current VGIC emulation code treats the "EnableGrpX" bits in
>> >> GICD_CTLR
>> >> > as a single global interrupt delivery switch, where in fact the
>> >> GIC
>> >> > architecture asks for this being separate for the two interrupt
>> >> groups.
>> >> >
>> >> > To implement this properly, we have to slightly adjust our 
>> design,
>> >> to
>> >> > *not* let IRQs from a disabled interrupt group be added to the
>> >> ap_list.
>> >> >
>> >> > As a consequence, enabling one group requires us to re-evaluate
>> >> every
>> >> > pending IRQ and potentially add it to its respective ap_list.
>> >> Similarly
>> >> > disabling an interrupt group requires pending IRQs to be 
>> removed
>> >> from
>> >> > the ap_list (as long as they have not been activated yet).
>> >> >
>> >> > Implement a rather simple, yet not terribly efficient algorithm 
>> to
>> >> > achieve this: For each VCPU we iterate over all IRQs, checking 
>> for
>> >> > pending ones and adding them to the list. We hold the 
>> ap_list_lock
>> >> > for this, to make this atomic from a VCPU's point of view.
>> >> >
>> >> > When an interrupt group gets disabled, we can't directly remove
>> >> affected
>> >> > IRQs from the ap_list, as a running VCPU might have already
>> >> activated
>> >> > them, which wouldn't be immediately visible to the host.
>> >> > Instead simply kick all VCPUs, so that they clean their 
>> ap_list's
>> >> > automatically when running vgic_prune_ap_list().
>> >> >
>> >> > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> >> > ---
>> >> >  virt/kvm/arm/vgic/vgic.c | 88
>> >> ++++++++++++++++++++++++++++++++++++----
>> >> >  1 file changed, 80 insertions(+), 8 deletions(-)
>> >> >
>> >> > diff --git a/virt/kvm/arm/vgic/vgic.c 
>> b/virt/kvm/arm/vgic/vgic.c
>> >> > index 3b88e14d239f..28d9ff282017 100644
>> >> > --- a/virt/kvm/arm/vgic/vgic.c
>> >> > +++ b/virt/kvm/arm/vgic/vgic.c
>> >> > @@ -339,6 +339,38 @@ int vgic_dist_enable_group(struct kvm 
>> *kvm,
>> >> int group, bool status)
>> >> >  	return 0;
>> >> >  }
>> >> >
>> >> > +/*
>> >> > + * Check whether a given IRQs need to be queued to this 
>> ap_list,
>> >> and do
>> >> > + * so if that's the case.
>> >> > + * Requires the ap_list_lock to be held (but not the irq 
>> lock).
>> >> > + *
>> >> > + * Returns 1 if that IRQ has been added to the ap_list, and 0 
>> if
>> >> not.
>> >> > + */
>> >> > +static int queue_enabled_irq(struct kvm *kvm, struct kvm_vcpu
>> >> *vcpu,
>> >> > +			     int intid)
>> >>
>> >> true/false seems better than 1/0.
>> >
>> > Mmh, indeed. I think I had more in there in an earlier version.
>> >
>> >> > +{
>> >> > +	struct vgic_irq *irq = vgic_get_irq(kvm, vcpu, intid);
>> >> > +	int ret = 0;
>> >> > +
>> >> > +	raw_spin_lock(&irq->irq_lock);
>> >> > +	if (!irq->vcpu && vcpu == vgic_target_oracle(irq)) {
>> >> > +		/*
>> >> > +		 * Grab a reference to the irq to reflect the
>> >> > +		 * fact that it is now in the ap_list.
>> >> > +		 */
>> >> > +		vgic_get_irq_kref(irq);
>> >> > +		list_add_tail(&irq->ap_list,
>> >> > +			      &vcpu->arch.vgic_cpu.ap_list_head);
>> >>
>> >> Two things:
>> >> - This should be the job of vgic_queue_irq_unlock. Why are you
>> >>   open-coding it?
>> >
>> > I was *really* keen on reusing that, but couldn't  for two 
>> reasons:
>> > a) the locking code inside vgic_queue_irq_unlock spoils that: It
>> > requires the irq_lock to be held, but not the ap_list_lock. Then 
>> it
>> > takes both locks, but returns with both of them dropped. We need 
>> to
>> > hold the ap_list_lock all of the time, to prevent any VCPU 
>> returning
>> > to the HV to interfere with this routine.
>> > b) vgic_queue_irq_unlock() kicks the VCPU already, where I want to
>> > just add all of them first, then kick the VCPU at the end.
>>
>> Indeed, and that is why you need to change the way you queue these
>> pending, enabled, group-disabled interrupts (see the LPI issue 
>> below).
>>
>> >
>> > So I decided to go with the stripped-down version of it, because I
>> > didn't dare to touch the original function. I could refactor this
>> > "actually add to the list" part of vgic_queue_irq_unlock() into 
>> this
>> > new function, then call it from both vgic_queue_irq_unlock() and 
>> from
>> > the new users.
>> >
>> >> - What if the interrupt isn't pending? Non-pending, non-active
>> >>   interrupts should not be on the AP list!
>> >
>> > That should be covered by vgic_target_oracle() already, shouldn't 
>> it?
>>
>> Ah, yes, you're right.
>>
>> >
>> >> > +		irq->vcpu = vcpu;
>> >> > +
>> >> > +		ret = 1;
>> >> > +	}
>> >> > +	raw_spin_unlock(&irq->irq_lock);
>> >> > +	vgic_put_irq(kvm, irq);
>> >> > +
>> >> > +	return ret;
>> >> > +}
>> >> > +
>> >> >  /*
>> >> >   * The group enable status of at least one of the groups has
>> >> changed.
>> >> >   * If enabled is true, at least one of the groups got enabled.
>> >> > @@ -346,17 +378,57 @@ int vgic_dist_enable_group(struct kvm 
>> *kvm,
>> >> int group, bool status)
>> >> >   */
>> >> >  void vgic_rescan_pending_irqs(struct kvm *kvm, bool enabled)
>> >> >  {
>> >> > +	int cpuid;
>> >> > +	struct kvm_vcpu *vcpu;
>> >> > +
>> >> >  	/*
>> >> > -	 * TODO: actually scan *all* IRQs of the VM for pending IRQs.
>> >> > -	 * If a pending IRQ's group is now enabled, add it to its
>> >> ap_list.
>> >> > -	 * If a pending IRQ's group is now disabled, kick the VCPU to
>> >> > -	 * let it remove this IRQ from its ap_list. We have to let 
>> the
>> >> > -	 * VCPU do it itself, because we can't know the exact state 
>> of
>> >> an
>> >> > -	 * IRQ pending on a running VCPU.
>> >> > +	 * If no group got enabled, we only have to potentially 
>> remove
>> >> > +	 * interrupts from ap_lists. We can't do this here, because a
>> >> running
>> >> > +	 * VCPU might have ACKed an IRQ already, which wouldn't
>> >> immediately
>> >> > +	 * be reflected in the ap_list.
>> >> > +	 * So kick all VCPUs, which will let them re-evaluate their
>> >> ap_lists
>> >> > +	 * by running vgic_prune_ap_list(), removing no longer 
>> enabled
>> >> > +	 * IRQs.
>> >> > +	 */
>> >> > +	if (!enabled) {
>> >> > +		vgic_kick_vcpus(kvm);
>> >> > +
>> >> > +		return;
>> >> > +	}
>> >> > +
>> >> > +	/*
>> >> > +	 * At least one group went from disabled to enabled. Now we 
>> need
>> >> > +	 * to scan *all* IRQs of the VM for newly group-enabled IRQs.
>> >> > +	 * If a pending IRQ's group is now enabled, add it to the
>> >> ap_list.
>> >> > +	 *
>> >> > +	 * For each VCPU this needs to be atomic, as we need *all* 
>> newly
>> >> > +	 * enabled IRQs in be in the ap_list to determine the highest
>> >> > +	 * priority one.
>> >> > +	 * So grab the ap_list_lock, then iterate over all private 
>> IRQs
>> >> and
>> >> > +	 * all SPIs. Once the ap_list is updated, kick that VCPU to
>> >> > +	 * forward any new IRQs to the guest.
>> >> >  	 */
>> >> > +	kvm_for_each_vcpu(cpuid, vcpu, kvm) {
>> >> > +		unsigned long flags;
>> >> > +		int i;
>> >> >
>> >> > -	 /* For now just kick all VCPUs, as the old code did. */
>> >> > -	vgic_kick_vcpus(kvm);
>> >> > +		raw_spin_lock_irqsave(&vcpu->arch.vgic_cpu.ap_list_lock,
>> >> flags);
>> >> > +
>> >> > +		for (i = 0; i < VGIC_NR_PRIVATE_IRQS; i++)
>> >> > +			queue_enabled_irq(kvm, vcpu, i);
>> >> > +
>> >> > +		for (i = VGIC_NR_PRIVATE_IRQS;
>> >> > +		     i < kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS; i++)
>> >> > +			queue_enabled_irq(kvm, vcpu, i);
>> >>
>> >> On top of my questions above, what happens to LPIs?
>> >
>> > Oh dear. Looks like wishful thinking on my side ;-) Iterating over
>> > all interrupts is probably not a good idea anymore.
>> > Do you think this idea of having a list with group-disabled IRQs 
>> is a
>> > better approach: In vgic_queue_irq_unlock, if a pending IRQ's 
>> group
>> > is
>> > enabled, it goes into the ap_list, if not, it goes into another 
>> list
>> > instead. Then we would only need to consult this other list when a
>> > group gets enabled. Both lists protected by the same ap_list_lock.
>> > Does that make sense?
>>
>> I think that could work. One queue for each group, holding pending,
>> enabled, group-disabled interrupts. Pending, disabled interrupts are
>> not queued anywhere, just like today.
>>
>> The only snag is per-cpu interrupts. On which queue do they live?
>> Do you have per-CPU queues? or a global one?
>
> Yes, the idea was to have a per-VCPU "grp_dis_list" in addition to
> the ap_list, reusing the ap_list list_head in struct vgic_irq.
> vgic_queue_irq_unlock() would put them into *one* of those two lists,
> depending on their group-enabled status. When a group gets enabled, 
> we
> just have to transfer the IRQs from grp_dis_list to ap_list.
>
> But fleshing this out I was wondering if it couldn't be much simpler:
> We ignore the group-enabled status most of the time, except in
> vgic_flush_lr_state(). So group-disabled IRQs *would go* to the
> ap_list (when they are otherwise pending|active and enabled), but
> would be skipped when eventually populating the LRs.
> vgic_prune_ap_list would also not touch them, so they would stay in
> the ap_list (unless removed for other reasons).
>
> That might raise some eyebrows (because we keep IRQs in the ap_list
> which are not ready), but would require only minimal changes and 
> avoid
> all kind of nasty/racy code to be added. The only downside I see is
> that the ap_list could potentially be much longer, but we could 
> change
> the sorting algorithm if needed to keep group-disabled IRQs at the
> end, at which point it wouldn't really matter.
>
> Do you see any problem with that approach? Alex seemed to remember
> that you had an objection against a very similar (if not identical)
> idea before.

My main worry with this is that it causes overhead on the fast path.
Disabled interrupts (for whichever reason they are disabled) shouldn't
have to be evaluated on the fast path.

Take for example kvm_vgic_vcpu_pending_irq(), which we evaluate pretty
often (each time a vcpu wakes up). Do we want to scan a bunch of
group-disabled interrupts there? No.

At the end of the day, what we're looking at is a list of disabled,
pending interrupts. They can be disabled for multiple reasons
(group is disabled, or interrupt itself is disabled). But they should
*not* end-up on the AP list, because that list has a precise semantic.

Your suggestion to add the group-disabled interrupts to the AP list
may be a cool hack, but it is mostly a hack that opens the whole thing
to a bunch of corner cases. Let's not do that.

>> >> And if a group has
>> >> been disabled, how do you retire these interrupts from the AP 
>> list?
>> >
>> > This is done above: we kick the respective VCPU and rely on
>> > vgic_prune_ap_list() to remove them (that uses 
>> vgic_target_oracle(),
>> > which in turn checks vgic_irq_is_grp_enabled()).
>>
>> But what if the CPU isn't running? Kicking it isn't going to do 
>> much,
>> is it?
>
> Not directly, but in either approach that would be handled similar to
> disabled interrupts: once the VCPU runs, they would *not* end up in
> LRs (because we check the oracle before), and would be cleaned up in
> prune() once the guest exits (at least for the original approach).

I lost track of the original approach already :-/

Try and build the above suggestion. It should follow the same flow as
the enabled, group-enabled interrupts, just with a different list.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

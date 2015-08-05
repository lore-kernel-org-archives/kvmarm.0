From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 09/11] KVM: arm/arm64: vgic: Prevent userspace
 injection of a mapped interrupt
Date: Wed, 5 Aug 2015 15:47:54 +0200
Message-ID: <20150805134754.GB4657@cbox>
References: <1437753309-17989-1-git-send-email-marc.zyngier@arm.com>
 <1437753309-17989-10-git-send-email-marc.zyngier@arm.com>
 <55C0E690.1090808@linaro.org> <55C0EBF5.2060708@arm.com>
 <55C1BBF9.2060004@linaro.org> <55C1DAE9.1050609@arm.com>
 <20150805105345.GA4657@cbox> <55C1F7CF.5070904@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 13E5C5A1EB
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Aug 2015 09:34:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bWmvIbT3Ia5a for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Aug 2015 09:34:24 -0400 (EDT)
Received: from mail-la0-f50.google.com (mail-la0-f50.google.com
 [209.85.215.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F126E5A1EA
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Aug 2015 09:34:23 -0400 (EDT)
Received: by labkb6 with SMTP id kb6so7204644lab.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 05 Aug 2015 06:47:10 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <55C1F7CF.5070904@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <Andre.Przywara@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Aug 05, 2015 at 01:47:27PM +0200, Eric Auger wrote:
> On 08/05/2015 12:53 PM, Christoffer Dall wrote:
> > On Wed, Aug 05, 2015 at 10:44:09AM +0100, Marc Zyngier wrote:
> >> On 05/08/15 08:32, Eric Auger wrote:
> >>> Hi Marc,
> >>> On 08/04/2015 06:44 PM, Marc Zyngier wrote:
> >>>> On 04/08/15 17:21, Eric Auger wrote:
> >>>>> Hi Marc,
> >>>>> On 07/24/2015 05:55 PM, Marc Zyngier wrote:
> >>>>>> Virtual interrupts mapped to a HW interrupt should only be triggered
> >>>>>> from inside the kernel. Otherwise, you could end up confusing the
> >>>>>> kernel (and the GIC's) state machine.
> >>>>>>
> >>>>>> Rearrange the injection path so that kvm_vgic_inject_irq is
> >>>>>> used for non-mapped interrupts, and kvm_vgic_inject_mapped_irq is
> >>>>>> used for mapped interrupts. The latter should only be called from
> >>>>>> inside the kernel (timer, VFIO).
> >>>>> nit: I would replace VFIO by irqfd.
> >>>>> VFIO just triggers the eventfd/irqfd. This is KVM/irqfd that injects the
> >>>>> virtual irq upon the irqfd signaling and he irqfd adaptation/ARM
> >>>>> currently is implemented in vgic.c
> >>>>
> >>>> Ah, thanks for reminding me of the right terminology, I tend to think of
> >>>> it as one big bag of nasty tricks... ;-)
> >>>>
> >>>> I'll update the commit message.
> >>>>
> >>>>>>
> >>>>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> >>>>>> ---
> >>>>>>  include/kvm/arm_vgic.h |  2 +
> >>>>>>  virt/kvm/arm/vgic.c    | 99 ++++++++++++++++++++++++++++++++++----------------
> >>>>>>  2 files changed, 70 insertions(+), 31 deletions(-)
> >>>>>>
> >>>>>> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> >>>>>> index 7306b4b..f6bfd79 100644
> >>>>>> --- a/include/kvm/arm_vgic.h
> >>>>>> +++ b/include/kvm/arm_vgic.h
> >>>>>> @@ -351,6 +351,8 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu);
> >>>>>>  void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu);
> >>>>>>  int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int irq_num,
> >>>>>>  			bool level);
> >>>>>> +int kvm_vgic_inject_mapped_irq(struct kvm *kvm, int cpuid,
> >>>>>> +			       struct irq_phys_map *map, bool level);
> >>>>>>  void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg);
> >>>>>>  int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
> >>>>>>  int kvm_vgic_vcpu_active_irq(struct kvm_vcpu *vcpu);
> >>>>>> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> >>>>>> index 3f7b690..e40ef70 100644
> >>>>>> --- a/virt/kvm/arm/vgic.c
> >>>>>> +++ b/virt/kvm/arm/vgic.c
> >>>>>> @@ -1533,7 +1533,8 @@ static int vgic_validate_injection(struct kvm_vcpu *vcpu, int irq, int level)
> >>>>>>  }
> >>>>>>  
> >>>>>>  static int vgic_update_irq_pending(struct kvm *kvm, int cpuid,
> >>>>>> -				  unsigned int irq_num, bool level)
> >>>>>> +				   struct irq_phys_map *map,
> >>>>>> +				   unsigned int irq_num, bool level)
> >>>>>>  {
> >>>>> In vgic_update_irq_pending, I needed to modify the following line and
> >>>>> add the "&& !map".
> >>>>>
> >>>>>         if (!vgic_validate_injection(vcpu, irq_num, level) && !map) {
> >>>>>
> >>>>> Without that, the level being not properly modeled for level sensitive
> >>>>> forwarded IRQs, the 2d injection fails.
> >>>>
> >>>> Ah! Is that because we never see the line being reset to zero, and the
> >>>> VGIC still sees the line as pending at the distributor level?
> >>> yes indeed
> >>
> >> Then it is a bigger problem we need to solve, and your solution just
> >> papers over the issue.
> >>
> >> The main problem is that irqfd is essentially an edge-triggered
> >> signalling. Fire and forget. Given that we're dealing with a level
> >> triggered interrupt, we end up with the interrupt still marked as
> >> pending (nobody took the signal down).
> this does not really relate to irqfd: irqfd also comes with the concept
> of resamplefd. in case the IRQ is not forwarded, this is the
> irqfd_resampler_ack function that toggles the IRQ down (eventfd.c). Its
> execution is triggered in vgic_process_maintenance. With forwarding the
> EOI is not trappable anymore so this disappears.
> 
> 
> >> The usual way to get out of that mess in is to evaluate the state of the
> >> level on EOI. But we can't trap on EOI for a HW interrupt.
> >>
> >> So it raises the question: should we instead consider the HW pending
> >> state instead of the software one for mapped interrupts? It is
> >> expensive, but it feels more correct.
> >>
> > I thought we already covered this at LCA.  For mapped interrupts
> > (forwarded) we should never consider the software pending state, because
> > that state is managed by the hardware.  Or am I confusing concepts here?
> 
> Yes we discussed we should bypass most of the SW states.
> 
> in my previous integration I proposed a patch "KVM: arm: vgic: fix state
> machine for forwarded IRQ". What's wrong with the below approach?
> 
> 
>     Fix multiple injection of level sensitive forwarded IRQs.
>     With current code, the second injection fails since the
>     state bitmaps are not reset (process_maintenance is not
>     called anymore).
> 
>     New implementation follows those principles:
>     - A forwarded IRQ only can be sampled when it is pending
>     - when queueing the IRQ (programming the LR), the pending state
>       is removed as for edge sensitive IRQs
>     - an injection of a forwarded IRQ is considered always valid since
>       coming from the HW and level always is 1.
> 
I don't see anything wrong, and I thought this was what we discussed.

-Christoffer

From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC v2 2/4] KVM: arm: vgic: fix state machine for forwarded IRQ
Date: Thu, 7 May 2015 11:20:59 +0200
Message-ID: <20150507092059.GB25885@cbox>
References: <1423642857-24240-1-git-send-email-eric.auger@linaro.org>
 <1423642857-24240-3-git-send-email-eric.auger@linaro.org>
 <20150506142649.GB6796@cbox> <554B18C9.7020903@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 27A6450B89
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 May 2015 05:12:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KoMhqyFkrwmO for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 May 2015 05:12:11 -0400 (EDT)
Received: from mail-la0-f45.google.com (mail-la0-f45.google.com
 [209.85.215.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B8CF350B85
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 May 2015 05:12:10 -0400 (EDT)
Received: by lagv1 with SMTP id v1so26068852lag.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 May 2015 02:20:58 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <554B18C9.7020903@linaro.org>
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
Cc: eric.auger@st.com, kvm@vger.kernel.org, patches@linaro.org, marc.zyngier@arm.com, andre.przywara@arm.com, alex.williamson@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, May 07, 2015 at 09:48:25AM +0200, Eric Auger wrote:
> Hi Christoffer,
> 
> On 05/06/2015 04:26 PM, Christoffer Dall wrote:
> > On Wed, Feb 11, 2015 at 09:20:55AM +0100, Eric Auger wrote:
> >> Fix multiple injection of level sensitive forwarded IRQs.
> >> With current code, the second injection fails since the state bitmaps
> >> are not reset (process_maintenance is not called anymore).
> >>
> >> New implementation follows those principles:
> >> - A forwarded IRQ only can be sampled when it is pending
> > 
> > why?
> For forwarded IRQ there is no modeled queued state (same as edge). The
> pending state is reset as soon as the vIRQ gets queued, in
> vgic_queue_hwirq (also same as edge). This modeling makes sure the vIRQ
> is injected once. I did not model the pending state since the above
> modeling looks simple and modeling the queued state did not work
> properly: I observed new forwarded IRQ could hit before the LR was seen
> cleaned. So overall, to me, current model looks closer to edge sensitive
> IRQs and looks simple & reliable compared to attempting to model any
> queued state.
> 

hmm, reading this, I'm remembering that the rationale was that the
pending state is maintained in the hardware so we never need to resample
any software state.  If the interrupt hits again (injected from VFIO for
example) it must have not been pending, otherwise we have a bug.

Is this the right way to look at it?

I think this needs to be documented somewhere in the code.


> > 
> >> - when queueing the IRQ (programming the LR), the pending state is removed
> >>   as for edge sensitive IRQs
> >> - an injection of a forwarded IRQ is considered always valid since
> >>   coming from the HW and level always is 1.
> >>
> >> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> >>
> >> ---
> >>
> >> v1 -> v2:
> >> - integration in new vgic_can_sample_irq
> >> - remove the pending state when programming the LR
> >> ---
> >>  virt/kvm/arm/vgic.c | 16 ++++++++++++----
> >>  1 file changed, 12 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> >> index cd00cf2..433ecba 100644
> >> --- a/virt/kvm/arm/vgic.c
> >> +++ b/virt/kvm/arm/vgic.c
> >> @@ -361,7 +361,10 @@ static void vgic_cpu_irq_clear(struct kvm_vcpu *vcpu, int irq)
> >>  
> >>  static bool vgic_can_sample_irq(struct kvm_vcpu *vcpu, int irq)
> >>  {
> >> -	return vgic_irq_is_edge(vcpu, irq) || !vgic_irq_is_queued(vcpu, irq);
> >> +	bool is_forwarded =  (vgic_get_phys_irq(vcpu, irq) >= 0);
> > 
> > can you create a wrapper function for is_forwarded?
> yes sure
> > 
> >> +
> >> +	return vgic_irq_is_edge(vcpu, irq) || !vgic_irq_is_queued(vcpu, irq) ||
> >> +		(is_forwarded && vgic_dist_irq_is_pending(vcpu, irq));
> >>  }
> >>  
> >>  static u32 mmio_data_read(struct kvm_exit_mmio *mmio, u32 mask)
> >> @@ -1296,6 +1299,7 @@ static bool vgic_queue_irq(struct kvm_vcpu *vcpu, u8 sgi_source_id, int irq)
> >>  	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
> >>  	struct vgic_lr vlr;
> >>  	int lr;
> >> +	bool is_forwarded =  (vgic_get_phys_irq(vcpu, irq) >= 0);
> >>  
> >>  	/* Sanitize the input... */
> >>  	BUG_ON(sgi_source_id & ~7);
> >> @@ -1331,7 +1335,7 @@ static bool vgic_queue_irq(struct kvm_vcpu *vcpu, u8 sgi_source_id, int irq)
> >>  	vlr.irq = irq;
> >>  	vlr.source = sgi_source_id;
> >>  	vlr.state = LR_STATE_PENDING;
> >> -	if (!vgic_irq_is_edge(vcpu, irq))
> >> +	if (!vgic_irq_is_edge(vcpu, irq) && !is_forwarded)
> >>  		vlr.state |= LR_EOI_INT;
> >>  
> >>  	vgic_set_lr(vcpu, lr, vlr);
> >> @@ -1372,11 +1376,12 @@ static bool vgic_queue_sgi(struct kvm_vcpu *vcpu, int irq)
> >>  
> >>  static bool vgic_queue_hwirq(struct kvm_vcpu *vcpu, int irq)
> >>  {
> >> +	bool is_forwarded = (vgic_get_phys_irq(vcpu, irq) >= 0);
> >>  	if (!vgic_can_sample_irq(vcpu, irq))
> >>  		return true; /* level interrupt, already queued */
> >>  
> >>  	if (vgic_queue_irq(vcpu, 0, irq)) {
> >> -		if (vgic_irq_is_edge(vcpu, irq)) {
> >> +		if (vgic_irq_is_edge(vcpu, irq) || is_forwarded) {
> >>  			vgic_dist_irq_clear_pending(vcpu, irq);
> >>  			vgic_cpu_irq_clear(vcpu, irq);
> >>  		} else {
> >> @@ -1626,14 +1631,17 @@ static int vgic_update_irq_pending(struct kvm *kvm, int cpuid,
> >>  	int edge_triggered, level_triggered;
> >>  	int enabled;
> >>  	bool ret = true;
> >> +	bool is_forwarded;
> >>  
> >>  	spin_lock(&dist->lock);
> >>  
> >>  	vcpu = kvm_get_vcpu(kvm, cpuid);
> >> +	is_forwarded = (vgic_get_phys_irq(vcpu, irq_num) >= 0);
> >> +
> >>  	edge_triggered = vgic_irq_is_edge(vcpu, irq_num);
> >>  	level_triggered = !edge_triggered;
> >>  
> >> -	if (!vgic_validate_injection(vcpu, irq_num, level)) {
> >> +	if (!vgic_validate_injection(vcpu, irq_num, level) && !is_forwarded) {
> > 
> > why is it again that we don't trust validate for forwarded irqs?
> forwarded IRQs are directly linked to HW IRQs. If the forwarded IRQ is
> received this means the guest completed last HW IRQ occurence and it is
> valid to inject the new one so following the discussions we had with
> Marc I skipped that check.

right, like I said above.  We need to document this; it's not trivial.

> 
>   Should
> > it not be checked inside validate?  Otherwise, this seems to deserve a
> > comment.
> It is equal to me. Let me know what is your preference according to
> above comment.
> 
I would fold it into validate and clearly comment that function so that
it's clear what it does.

Thanks,
-Christoffer

From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 07/10] KVM: arm/arm64: vgic: Allow HW interrupts for
 non-shared devices
Date: Mon, 14 Sep 2015 12:59:31 +0200
Message-ID: <20150914105931.GE15712@cbox>
References: <1439212864-12954-1-git-send-email-eric.auger@linaro.org>
 <1439212864-12954-8-git-send-email-eric.auger@linaro.org>
 <20150902194246.GV10991@cbox> <55EECEBF.200@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DCBDA412EF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2015 06:56:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1QQzk48Fs2VP for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Sep 2015 06:56:57 -0400 (EDT)
Received: from mail-la0-f46.google.com (mail-la0-f46.google.com
 [209.85.215.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B958241291
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2015 06:56:56 -0400 (EDT)
Received: by lagj9 with SMTP id j9so85155765lag.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2015 03:57:48 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <55EECEBF.200@linaro.org>
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
Cc: eric.auger@st.com, kvm@vger.kernel.org, patches@linaro.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, alex.williamson@redhat.com, pbonzini@redhat.com, feng.wu@intel.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Sep 08, 2015 at 02:04:15PM +0200, Eric Auger wrote:
> Hi Christoffer,
> On 09/02/2015 09:42 PM, Christoffer Dall wrote:
> > On Mon, Aug 10, 2015 at 03:21:01PM +0200, Eric Auger wrote:
> >> From: Marc Zyngier <marc.zyngier@arm.com>
> >>
> >> So far, the only use of the HW interrupt facility was the timer,
> >> implying that the active state is context-switched for each vcpu,
> >> as the device is is shared across all vcpus.
> >>
> >> This does not work for a device that has been assigned to a VM,
> >> as the guest is entierely in control of that device (the HW is
> >> not shared). In that case, it makes sense to bypass the whole
> >> active state switching.
> >>
> >> Also the VGIC state machine is adapted to support those assigned
> >> (non shared) HW IRQs:
> >> - nly can be sampled when it is pending
> >> - when queueing the IRQ (programming the LR), the pending state is
> >>   removed as for edge sensitive IRQs
> >> - queued state is not modelled. Level state is not modelled
> >> - its injection always is valid since steming from the HW.
> >>
> >> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> >> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> >>
> >> ---
> >>
> >> - a mix of
> >>   [PATCH v4 11/11] KVM: arm/arm64: vgic: Allow HW interrupts for
> >>                    non-shared devices
> >>   [RFC v2 2/4] KVM: arm: vgic: fix state machine for forwarded IRQ
> >> ---
> >>  include/kvm/arm_vgic.h    |  6 +++--
> >>  virt/kvm/arm/arch_timer.c |  3 ++-
> >>  virt/kvm/arm/vgic.c       | 58 +++++++++++++++++++++++++++++++++++------------
> >>  3 files changed, 49 insertions(+), 18 deletions(-)
> >>
> >> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> >> index d901f1a..7ef9ce0 100644
> >> --- a/include/kvm/arm_vgic.h
> >> +++ b/include/kvm/arm_vgic.h
> >> @@ -163,7 +163,8 @@ struct irq_phys_map {
> >>  	u32			virt_irq;
> >>  	u32			phys_irq;
> >>  	u32			irq;
> >> -	bool			active;
> >> +	bool			shared;
> >> +	bool			active; /* Only valid if shared */
> >>  };
> >>  
> >>  struct irq_phys_map_entry {
> >> @@ -356,7 +357,8 @@ void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg);
> >>  int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
> >>  int kvm_vgic_vcpu_active_irq(struct kvm_vcpu *vcpu);
> >>  struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
> >> -					   int virt_irq, int irq);
> >> +					   int virt_irq, int irq,
> >> +					   bool shared);
> >>  int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, struct irq_phys_map *map);
> >>  bool kvm_vgic_get_phys_irq_active(struct irq_phys_map *map);
> >>  void kvm_vgic_set_phys_irq_active(struct irq_phys_map *map, bool active);
> >> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> >> index 76e38d2..db21d8f 100644
> >> --- a/virt/kvm/arm/arch_timer.c
> >> +++ b/virt/kvm/arm/arch_timer.c
> >> @@ -203,7 +203,8 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
> >>  	 * Tell the VGIC that the virtual interrupt is tied to a
> >>  	 * physical interrupt. We do that once per VCPU.
> >>  	 */
> >> -	map = kvm_vgic_map_phys_irq(vcpu, irq->irq, host_vtimer_irq);
> >> +	map = kvm_vgic_map_phys_irq(vcpu, irq->irq,
> >> +				    host_vtimer_irq, true);
> >>  	if (WARN_ON(IS_ERR(map)))
> >>  		return PTR_ERR(map);
> >>  
> >> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> >> index 9eb489a..fbd5ba5 100644
> >> --- a/virt/kvm/arm/vgic.c
> >> +++ b/virt/kvm/arm/vgic.c
> >> @@ -400,7 +400,11 @@ void vgic_cpu_irq_clear(struct kvm_vcpu *vcpu, int irq)
> >>  
> >>  static bool vgic_can_sample_irq(struct kvm_vcpu *vcpu, int irq)
> >>  {
> >> -	return !vgic_irq_is_queued(vcpu, irq);
> >> +	struct irq_phys_map *map = vgic_irq_map_search(vcpu, irq);
> >> +	bool shared_hw = map && !map->shared;
> > 
> > why is shared true when map->shared is false?
> definitively upside down
> > 
> >> +
> >> +	return !vgic_irq_is_queued(vcpu, irq) ||
> >> +			(shared_hw && vgic_dist_irq_is_pending(vcpu, irq));
> > 
> > so for forwarded, non-shared, level-triggered IRQs, we always sample the
> > line if it's pending?  Why?
> 
> No we only sampled it if it was pending. The pending state was reset
> when programming the LR.
> 
> Now that we model the queued state for mapped IRQ I will use that instead

ok, it is certainly very counterintuitive to have to check the pending
state only if the pending state is set.

Not sure how this will look after your rework, but it may deserve a
comment in either case.

Thanks,
-Christoffer

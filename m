From: "Paul E. McKenney" <paulmck@linux.ibm.com>
Subject: Re: [PATCH 16/16] KVM: arm/arm64: vgic: Replace spin_is_locked()
 with lockdep
Date: Fri, 2 Nov 2018 12:42:18 -0700
Message-ID: <20181102194218.GB4170@linux.ibm.com>
References: <20181003053902.6910-1-ldr709@gmail.com>
 <20181003053902.6910-17-ldr709@gmail.com>
 <20181102184533.GA12057@e113682-lin.lund.arm.com>
Reply-To: paulmck@linux.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181102184533.GA12057@e113682-lin.lund.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@arm.com>
Cc: Lance Roy <ldr709@gmail.com>, linux-kernel@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Nov 02, 2018 at 07:45:33PM +0100, Christoffer Dall wrote:
> On Tue, Oct 02, 2018 at 10:39:02PM -0700, Lance Roy wrote:
> > lockdep_assert_held() is better suited to checking locking requirements,
> > since it won't get confused when someone else holds the lock. This is
> > also a step towards possibly removing spin_is_locked().
> > 
> > Signed-off-by: Lance Roy <ldr709@gmail.com>
> > Cc: Christoffer Dall <christoffer.dall@arm.com>
> > Cc: Marc Zyngier <marc.zyngier@arm.com>
> > Cc: Eric Auger <eric.auger@redhat.com>
> > Cc: linux-arm-kernel@lists.infradead.org
> > Cc: <kvmarm@lists.cs.columbia.edu>
> 
> Acked-by: Christoffer Dall <christoffer.dall@arm.com>

Applied, thank you!

							Thanx, Paul

> > ---
> >  virt/kvm/arm/vgic/vgic.c | 12 ++++++------
> >  1 file changed, 6 insertions(+), 6 deletions(-)
> > 
> > diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> > index 7cfdfbc910e0..50e25438fb3c 100644
> > --- a/virt/kvm/arm/vgic/vgic.c
> > +++ b/virt/kvm/arm/vgic/vgic.c
> > @@ -196,7 +196,7 @@ void vgic_irq_set_phys_active(struct vgic_irq *irq, bool active)
> >   */
> >  static struct kvm_vcpu *vgic_target_oracle(struct vgic_irq *irq)
> >  {
> > -	DEBUG_SPINLOCK_BUG_ON(!spin_is_locked(&irq->irq_lock));
> > +	lockdep_assert_held(&irq->irq_lock);
> >  
> >  	/* If the interrupt is active, it must stay on the current vcpu */
> >  	if (irq->active)
> > @@ -273,7 +273,7 @@ static void vgic_sort_ap_list(struct kvm_vcpu *vcpu)
> >  {
> >  	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
> >  
> > -	DEBUG_SPINLOCK_BUG_ON(!spin_is_locked(&vgic_cpu->ap_list_lock));
> > +	lockdep_assert_held(&vgic_cpu->ap_list_lock);
> >  
> >  	list_sort(NULL, &vgic_cpu->ap_list_head, vgic_irq_cmp);
> >  }
> > @@ -311,7 +311,7 @@ bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
> >  {
> >  	struct kvm_vcpu *vcpu;
> >  
> > -	DEBUG_SPINLOCK_BUG_ON(!spin_is_locked(&irq->irq_lock));
> > +	lockdep_assert_held(&irq->irq_lock);
> >  
> >  retry:
> >  	vcpu = vgic_target_oracle(irq);
> > @@ -702,7 +702,7 @@ static inline void vgic_fold_lr_state(struct kvm_vcpu *vcpu)
> >  static inline void vgic_populate_lr(struct kvm_vcpu *vcpu,
> >  				    struct vgic_irq *irq, int lr)
> >  {
> > -	DEBUG_SPINLOCK_BUG_ON(!spin_is_locked(&irq->irq_lock));
> > +	lockdep_assert_held(&irq->irq_lock);
> >  
> >  	if (kvm_vgic_global_state.type == VGIC_V2)
> >  		vgic_v2_populate_lr(vcpu, irq, lr);
> > @@ -736,7 +736,7 @@ static int compute_ap_list_depth(struct kvm_vcpu *vcpu,
> >  
> >  	*multi_sgi = false;
> >  
> > -	DEBUG_SPINLOCK_BUG_ON(!spin_is_locked(&vgic_cpu->ap_list_lock));
> > +	lockdep_assert_held(&vgic_cpu->ap_list_lock);
> >  
> >  	list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list) {
> >  		int w;
> > @@ -761,7 +761,7 @@ static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
> >  	bool multi_sgi;
> >  	u8 prio = 0xff;
> >  
> > -	DEBUG_SPINLOCK_BUG_ON(!spin_is_locked(&vgic_cpu->ap_list_lock));
> > +	lockdep_assert_held(&vgic_cpu->ap_list_lock);
> >  
> >  	count = compute_ap_list_depth(vcpu, &multi_sgi);
> >  	if (count > kvm_vgic_global_state.nr_lr || multi_sgi)
> > -- 
> > 2.19.0
> > 
> > 
> > _______________________________________________
> > linux-arm-kernel mailing list
> > linux-arm-kernel@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 9/9] KVM: arm/arm64: vgic: Improve sync_hwstate
 performance
Date: Tue, 21 Mar 2017 15:13:24 +0100
Message-ID: <20170321141324.GH15920@cbox>
References: <20170320105818.20481-1-cdall@linaro.org>
 <20170320105818.20481-10-cdall@linaro.org>
 <822a56eb-0989-493a-545e-15deb3de7ddc@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <822a56eb-0989-493a-545e-15deb3de7ddc@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, Eric Auger <eric.auger@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Mar 21, 2017 at 01:29:06PM +0000, Marc Zyngier wrote:
> On 20/03/17 10:58, Christoffer Dall wrote:
> > There is no need to call any functions to fold LRs when we don't use any
> > LRs and we don't need to mess with overflow flags, take spinlocks, or
> > prune the AP list if the AP list is empty.
> > 
> > Note: list_empty is a single atomic read (uses READ_ONCE) and can
> > therefore check if a list is empty or not without the need to take the
> > spinlock protecting the list.
> > 
> > Signed-off-by: Christoffer Dall <cdall@linaro.org>
> > ---
> >  virt/kvm/arm/vgic/vgic.c | 13 ++++++++-----
> >  1 file changed, 8 insertions(+), 5 deletions(-)
> > 
> > diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> > index 093873e..8ecb009 100644
> > --- a/virt/kvm/arm/vgic/vgic.c
> > +++ b/virt/kvm/arm/vgic/vgic.c
> > @@ -639,15 +639,18 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
> >  {
> >  	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
> >  
> > -	if (unlikely(!vgic_initialized(vcpu->kvm)))
> 
> Could this be folded with the previous patch? It is the same optimisation.
> 

Sure.

> > +	/* An empty ap_list_head implies used_lrs == 0 */
> > +	if (list_empty(&vcpu->arch.vgic_cpu.ap_list_head))
> >  		return;
> >  
> >  	vgic_clear_uie(vcpu);
> > -	vgic_fold_lr_state(vcpu);
> > -	vgic_prune_ap_list(vcpu);
> >  
> > -	/* Make sure we can fast-path in flush_hwstate */
> > -	vgic_cpu->used_lrs = 0;
> > +	if (vgic_cpu->used_lrs) {
> > +		vgic_fold_lr_state(vcpu);
> > +		vgic_cpu->used_lrs = 0;
> 
> This zeroing could also be moved to vgic_fold_lr_state(), though I don't
> feel strongly about it.
> 

Hmm, I'll have a look.

> > +	}
> > +
> > +	vgic_prune_ap_list(vcpu);
> >  }
> >  
> >  /* Flush our emulation state into the GIC hardware before entering the guest. */
> > 
> 
> Otherwise looks good to me.
> 

Thanks,
-Christoffer

From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 7/9] KVM: arm/arm64: vgic: Implement early VGIC init
 functionality
Date: Tue, 21 Mar 2017 13:29:35 +0100
Message-ID: <20170321122935.GE15920@cbox>
References: <20170320105818.20481-1-cdall@linaro.org>
 <20170320105818.20481-8-cdall@linaro.org>
 <3aba3207-24e4-c832-2b84-1c0a7790eb46@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 39E3F40C2F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 08:27:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JGSkTLKYr72d for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Mar 2017 08:27:51 -0400 (EDT)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com [74.125.82.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B201E40BDA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 08:27:50 -0400 (EDT)
Received: by mail-wm0-f43.google.com with SMTP id n11so11208079wma.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 05:29:37 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <3aba3207-24e4-c832-2b84-1c0a7790eb46@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Mar 21, 2017 at 12:05:30PM +0000, Marc Zyngier wrote:
> On 20/03/17 10:58, Christoffer Dall wrote:
> > Implement early initialization for both the distributor and the CPU
> > interfaces.  The basic idea is that even though the VGIC is not
> > functional or not requested from user space, the critical path of the
> > run loop can still call VGIC functions that just won't do anything,
> > without them having to check additional initialization flags to ensure
> > they don't look at uninitialized data structures.
> > 
> > Signed-off-by: Christoffer Dall <cdall@linaro.org>
> > ---
> >  virt/kvm/arm/vgic/vgic-init.c | 96 +++++++++++++++++++++++++------------------
> >  1 file changed, 56 insertions(+), 40 deletions(-)
> > 
> > diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
> > index 3762fd1..25fd1b9 100644
> > --- a/virt/kvm/arm/vgic/vgic-init.c
> > +++ b/virt/kvm/arm/vgic/vgic-init.c
> > @@ -24,7 +24,12 @@
> >  
> >  /*
> >   * Initialization rules: there are multiple stages to the vgic
> > - * initialization, both for the distributor and the CPU interfaces.
> > + * initialization, both for the distributor and the CPU interfaces.  The basic
> > + * idea is that even though the VGIC is not functional or not requested from
> > + * user space, the critical path of the run loop can still call VGIC functions
> > + * that just won't do anything, without them having to check additional
> > + * initialization flags to ensure they don't look at uninitialized data
> > + * structures.
> >   *
> >   * Distributor:
> >   *
> > @@ -39,23 +44,67 @@
> >   *
> >   * CPU Interface:
> >   *
> > - * - kvm_vgic_cpu_early_init(): initialization of static data that
> > + * - kvm_vgic_vcpu_early_init(): initialization of static data that
> >   *   doesn't depend on any sizing information or emulation type. No
> >   *   allocation is allowed there.
> >   */
> >  
> >  /* EARLY INIT */
> >  
> > -/*
> > - * Those 2 functions should not be needed anymore but they
> > - * still are called from arm.c
> > +/**
> > + * kvm_vgic_early_init() - Initialize static VGIC VCPU data structures
> > + * @kvm: The VM whose VGIC districutor should be initialized
> > + *
> > + * Only do initialization of static structures that don't require any
> > + * allocation or sizing information from userspace.  vgic_init() called
> > + * kvm_vgic_dist_init() which takes care of the rest.
> >   */
> >  void kvm_vgic_early_init(struct kvm *kvm)
> >  {
> > +	struct vgic_dist *dist = &kvm->arch.vgic;
> > +
> > +	INIT_LIST_HEAD(&dist->lpi_list_head);
> > +	spin_lock_init(&dist->lpi_list_lock);
> >  }
> >  
> > +/**
> > + * kvm_vgic_vcpu_early_init() - Initialize static VGIC VCPU data structures
> > + * @vcpu: The VCPU whose VGIC data structures whould be initialized
> > + *
> > + * Only do initialization, but do not actually enable the VGIC CPU interface
> > + * yet.
> > + */
> >  void kvm_vgic_vcpu_early_init(struct kvm_vcpu *vcpu)
> >  {
> > +	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
> > +	int i;
> > +
> > +	INIT_LIST_HEAD(&vgic_cpu->ap_list_head);
> > +	spin_lock_init(&vgic_cpu->ap_list_lock);
> > +
> > +	/*
> > +	 * Enable and configure all SGIs to be edge-triggered and
> > +	 * configure all PPIs as level-triggered.
> > +	 */
> > +	for (i = 0; i < VGIC_NR_PRIVATE_IRQS; i++) {
> > +		struct vgic_irq *irq = &vgic_cpu->private_irqs[i];
> > +
> > +		INIT_LIST_HEAD(&irq->ap_list);
> > +		spin_lock_init(&irq->irq_lock);
> > +		irq->intid = i;
> > +		irq->vcpu = NULL;
> > +		irq->target_vcpu = vcpu;
> > +		irq->targets = 1U << vcpu->vcpu_id;
> > +		kref_init(&irq->refcount);
> > +		if (vgic_irq_is_sgi(i)) {
> > +			/* SGIs */
> > +			irq->enabled = 1;
> > +			irq->config = VGIC_CONFIG_EDGE;
> > +		} else {
> > +			/* PPIs */
> > +			irq->config = VGIC_CONFIG_LEVEL;
> > +		}
> > +	}
> >  }
> >  
> >  /* CREATION */
> > @@ -148,9 +197,6 @@ static int kvm_vgic_dist_init(struct kvm *kvm, unsigned int nr_spis)
> >  	struct kvm_vcpu *vcpu0 = kvm_get_vcpu(kvm, 0);
> >  	int i;
> >  
> > -	INIT_LIST_HEAD(&dist->lpi_list_head);
> > -	spin_lock_init(&dist->lpi_list_lock);
> > -
> >  	dist->spis = kcalloc(nr_spis, sizeof(struct vgic_irq), GFP_KERNEL);
> >  	if (!dist->spis)
> >  		return  -ENOMEM;
> > @@ -181,41 +227,11 @@ static int kvm_vgic_dist_init(struct kvm *kvm, unsigned int nr_spis)
> >  }
> >  
> >  /**
> > - * kvm_vgic_vcpu_init: initialize the vcpu data structures and
> > - * enable the VCPU interface
> > - * @vcpu: the VCPU which's VGIC should be initialized
> > + * kvm_vgic_vcpu_init() - Enable the VCPU interface
> > + * @vcpu: the VCPU which's VGIC should be enabled
> >   */
> >  static void kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
> >  {
> > -	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
> > -	int i;
> > -
> > -	INIT_LIST_HEAD(&vgic_cpu->ap_list_head);
> > -	spin_lock_init(&vgic_cpu->ap_list_lock);
> > -
> > -	/*
> > -	 * Enable and configure all SGIs to be edge-triggered and
> > -	 * configure all PPIs as level-triggered.
> > -	 */
> > -	for (i = 0; i < VGIC_NR_PRIVATE_IRQS; i++) {
> > -		struct vgic_irq *irq = &vgic_cpu->private_irqs[i];
> > -
> > -		INIT_LIST_HEAD(&irq->ap_list);
> > -		spin_lock_init(&irq->irq_lock);
> > -		irq->intid = i;
> > -		irq->vcpu = NULL;
> > -		irq->target_vcpu = vcpu;
> > -		irq->targets = 1U << vcpu->vcpu_id;
> > -		kref_init(&irq->refcount);
> > -		if (vgic_irq_is_sgi(i)) {
> > -			/* SGIs */
> > -			irq->enabled = 1;
> > -			irq->config = VGIC_CONFIG_EDGE;
> > -		} else {
> > -			/* PPIs */
> > -			irq->config = VGIC_CONFIG_LEVEL;
> > -		}
> > -	}
> >  	if (kvm_vgic_global_state.type == VGIC_V2)
> >  		vgic_v2_enable(vcpu);
> >  	else
> > 
> 
> Since this function is now about enabling the vgic on a given vcpu,
> shouldn't the name reflect this? Other than that:

The v3 version does something which is a bit of a mix between
initialization and enabling, plus it would add even more churn, so, meh,
not really sure.  If you feel it should be kvm_vgic_vcpu_enable(), I'm
okay with changing it.

> 
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> 

Thanks,
-Christoffer

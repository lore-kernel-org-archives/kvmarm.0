From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 09/12] KVM: arm/arm64: prepare GICv2 emulation to be
 handled by kvm_io_bus
Date: Tue, 17 Mar 2015 19:51:18 +0100
Message-ID: <20150317185118.GD26480@cbox>
References: <1426263012-22935-1-git-send-email-andre.przywara@arm.com>
 <1426263012-22935-10-git-send-email-andre.przywara@arm.com>
 <20150314143044.GE10935@cbox>
 <55086C41.9070209@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55086C41.9070209@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "n.nikolaev@virtualopensystems.com" <n.nikolaev@virtualopensystems.com>, "eric.auger@linaro.org" <eric.auger@linaro.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Mar 17, 2015 at 06:02:41PM +0000, Andre Przywara wrote:
> Hej,
> 
> On 14/03/15 14:30, Christoffer Dall wrote:
> > On Fri, Mar 13, 2015 at 04:10:09PM +0000, Andre Przywara wrote:
> >> Using the framework provided by the recent vgic.c changes we register
> >> a kvm_io_bus device when initializing the virtual GICv2.
> >>
> >> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> >> ---
> >>  include/kvm/arm_vgic.h      |    1 +
> >>  virt/kvm/arm/vgic-v2-emul.c |   13 +++++++++----
> >>  virt/kvm/arm/vgic.c         |   16 ++++++++++++++++
> >>  3 files changed, 26 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> >> index 4bfc6a3..74a4ac4 100644
> >> --- a/include/kvm/arm_vgic.h
> >> +++ b/include/kvm/arm_vgic.h
> >> @@ -245,6 +245,7 @@ struct vgic_dist {
> >>  	unsigned long		*irq_pending_on_cpu;
> >>  
> >>  	struct vgic_vm_ops	vm_ops;
> >> +	struct vgic_io_device	dist_iodev;
> >>  };
> >>  
> >>  struct vgic_v2_cpu_if {
> >> diff --git a/virt/kvm/arm/vgic-v2-emul.c b/virt/kvm/arm/vgic-v2-emul.c
> >> index 0defac6..6f685c9 100644
> >> --- a/virt/kvm/arm/vgic-v2-emul.c
> >> +++ b/virt/kvm/arm/vgic-v2-emul.c
> >> @@ -490,6 +490,7 @@ static bool vgic_v2_queue_sgi(struct kvm_vcpu *vcpu, int irq)
> >>  static int vgic_v2_map_resources(struct kvm *kvm,
> >>  				 const struct vgic_params *params)
> >>  {
> >> +	struct vgic_dist *dist = &kvm->arch.vgic;
> >>  	int ret = 0;
> >>  
> >>  	if (!irqchip_in_kernel(kvm))
> >> @@ -500,13 +501,17 @@ static int vgic_v2_map_resources(struct kvm *kvm,
> >>  	if (vgic_ready(kvm))
> >>  		goto out;
> >>  
> >> -	if (IS_VGIC_ADDR_UNDEF(kvm->arch.vgic.vgic_dist_base) ||
> >> -	    IS_VGIC_ADDR_UNDEF(kvm->arch.vgic.vgic_cpu_base)) {
> >> +	if (IS_VGIC_ADDR_UNDEF(dist->vgic_dist_base) ||
> >> +	    IS_VGIC_ADDR_UNDEF(dist->vgic_cpu_base)) {
> >>  		kvm_err("Need to set vgic cpu and dist addresses first\n");
> >>  		ret = -ENXIO;
> >>  		goto out;
> >>  	}
> >>  
> >> +	vgic_register_kvm_io_dev(kvm, dist->vgic_dist_base,
> >> +				 KVM_VGIC_V2_DIST_SIZE,
> >> +				 vgic_dist_ranges, -1, &dist->dist_iodev);
> >> +
> >>  	/*
> >>  	 * Initialize the vgic if this hasn't already been done on demand by
> >>  	 * accessing the vgic state from userspace.
> >> @@ -517,7 +522,7 @@ static int vgic_v2_map_resources(struct kvm *kvm,
> >>  		goto out;
> >>  	}
> >>  
> >> -	ret = kvm_phys_addr_ioremap(kvm, kvm->arch.vgic.vgic_cpu_base,
> >> +	ret = kvm_phys_addr_ioremap(kvm, dist->vgic_cpu_base,
> >>  				    params->vcpu_base, KVM_VGIC_V2_CPU_SIZE,
> >>  				    true);
> >>  	if (ret) {
> >> @@ -525,7 +530,7 @@ static int vgic_v2_map_resources(struct kvm *kvm,
> >>  		goto out;
> >>  	}
> >>  
> >> -	kvm->arch.vgic.ready = true;
> >> +	dist->ready = true;
> >>  out:
> >>  	if (ret)
> >>  		kvm_vgic_destroy(kvm);
> >> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> >> index 71389b8..b1dd717 100644
> >> --- a/virt/kvm/arm/vgic.c
> >> +++ b/virt/kvm/arm/vgic.c
> >> @@ -908,6 +908,20 @@ int vgic_register_kvm_io_dev(struct kvm *kvm, gpa_t base, int len,
> >>  	return 0;
> >>  }
> >>  
> >> +static void vgic_unregister_kvm_io_dev(struct kvm *kvm)
> >> +{
> >> +	struct vgic_dist *dist = &kvm->arch.vgic;
> >> +
> >> +	if (!dist || !kvm->buses[KVM_MMIO_BUS])
> >> +		return;
> >> +
> >> +	mutex_lock(&kvm->slots_lock);
> >> +	if (dist->dist_iodev.dev.ops)
> >> +		kvm_io_bus_unregister_dev(kvm, KVM_MMIO_BUS,
> >> +					  &dist->dist_iodev.dev);
> > 
> > why are we only unregisttering the iodev when we have ops?
> 
> Because vgic_unregister_kvm_io_dev() is called by kvm_vgic_destroy(),
> which we call on some occasions during vgic_init() when we encounter an
> error. There is quite a window of cases where the kvm_io_bus devices
> haven't been registered yet, so we shouldn't try to unregister them at
> this place. Using the .ops parameter seemed like an elegant way to
> detect this case.
> Does that make sense? Or have I missed something?
> 
That's ok, but it derserves a comment explaining this.

-Christoffer

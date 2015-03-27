From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 10/11] KVM: arm/arm64: prepare GICv3 emulation to use
 kvm_io_bus MMIO handling
Date: Fri, 27 Mar 2015 07:34:50 +0000
Message-ID: <20150327073450.5cc33e5c@arm.com>
References: <1427380778-942-1-git-send-email-andre.przywara@arm.com>
	<1427380778-942-11-git-send-email-andre.przywara@arm.com>
	<20150326220632.64ee91ec@arm.com>
	<5514A0D4.4040302@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <5514A0D4.4040302@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "n.nikolaev@virtualopensystems.com" <n.nikolaev@virtualopensystems.com>, "eric.auger@linaro.org" <eric.auger@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, 27 Mar 2015 00:14:12 +0000
Andre Przywara <andre.przywara@arm.com> wrote:

> On 03/26/2015 10:06 PM, Marc Zyngier wrote:
> > On Thu, 26 Mar 2015 14:39:37 +0000
> > Andre Przywara <andre.przywara@arm.com> wrote:
> > 
> >> Using the framework provided by the recent vgic.c changes, we
> >> register a kvm_io_bus device on mapping the virtual GICv3 resources.
> >> The distributor mapping is pretty straight forward, but the
> >> redistributors need some more love, since they need to be tagged with
> >> the respective redistributor (read: VCPU) they are connected with.
> >> We use the kvm_io_bus framework to register one devices per VCPU.
> >>
> >> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> >> ---
> >>  include/kvm/arm_vgic.h      |    1 +
> >>  virt/kvm/arm/vgic-v3-emul.c |   39 ++++++++++++++++++++++++++++++++++++++-
> >>  2 files changed, 39 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> >> index 4523984..d6705f4 100644
> >> --- a/include/kvm/arm_vgic.h
> >> +++ b/include/kvm/arm_vgic.h
> >> @@ -252,6 +252,7 @@ struct vgic_dist {
> >>  
> >>  	struct vgic_vm_ops	vm_ops;
> >>  	struct vgic_io_device	dist_iodev;
> >> +	struct vgic_io_device	*redist_iodevs;
> >>  };
> >>  
> >>  struct vgic_v2_cpu_if {
> >> diff --git a/virt/kvm/arm/vgic-v3-emul.c b/virt/kvm/arm/vgic-v3-emul.c
> >> index 2f03a36..eb1a797 100644
> >> --- a/virt/kvm/arm/vgic-v3-emul.c
> >> +++ b/virt/kvm/arm/vgic-v3-emul.c
> >> @@ -758,6 +758,9 @@ static int vgic_v3_map_resources(struct kvm *kvm,
> >>  {
> >>  	int ret = 0;
> >>  	struct vgic_dist *dist = &kvm->arch.vgic;
> >> +	gpa_t rdbase = dist->vgic_redist_base;
> >> +	struct vgic_io_device *iodevs = NULL;
> >> +	int i;
> >>  
> >>  	if (!irqchip_in_kernel(kvm))
> >>  		return 0;
> >> @@ -783,7 +786,41 @@ static int vgic_v3_map_resources(struct kvm *kvm,
> >>  		goto out;
> >>  	}
> >>  
> >> -	kvm->arch.vgic.ready = true;
> >> +	ret = vgic_register_kvm_io_dev(kvm, dist->vgic_dist_base,
> >> +				       GIC_V3_DIST_SIZE, vgic_v3_dist_ranges,
> >> +				       -1, &dist->dist_iodev);
> > 
> >> +	if (ret)
> >> +		goto out;
> >> +
> >> +	iodevs = kcalloc(dist->nr_cpus, sizeof(iodevs[0]), GFP_KERNEL);
> >> +	if (!iodevs) {
> >> +		ret = -ENOMEM;
> >> +		goto out_unregister;
> >> +	}
> >> +
> >> +	for (i = 0; i < dist->nr_cpus; i++) {
> >> +		ret = vgic_register_kvm_io_dev(kvm, rdbase,
> >> +					       SZ_128K, vgic_redist_ranges,
> >> +					       i, &iodevs[i]);
> > 
> > This looks really weird. You seems to be mapping all redistributors at
> > the same IPA. Have you actually tested this with an SMP guest?
> 
> But the patch continues:
> 
> +		if (ret)
> +			goto out_unregister;
> +		rdbase += GIC_V3_REDIST_SIZE;
> 
> Is that too confusing to re-use the rdbase variable? The spec speaks of
> RD_base for each redistributor, so that seemed sane to me.
> Shall I add a comment or use "rdbase + i * GIC_V3_REDIST_SIZE" for clarity?

That would have been nicer, but let's face the harsh truth: I can't
read, ignore me (well, for this time only ;-).

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny.

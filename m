From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 5/7] KVM: arm/arm64: build a default routing table
Date: Thu, 14 Apr 2016 14:05:05 +0200
Message-ID: <20160414120505.GG30804@cbox>
References: <1459759657-7402-1-git-send-email-eric.auger@linaro.org>
 <1459759657-7402-6-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1459759657-7402-6-git-send-email-eric.auger@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@linaro.org>
Cc: eric.auger@st.com, marc.zyngier@arm.com, andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, patches@linaro.org, pbonzini@redhat.com, p.fedin@samsung.com, Manish.Jaggi@caviumnetworks.com
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Apr 04, 2016 at 10:47:35AM +0200, Eric Auger wrote:
> Implement a default routing table made of flat irqchip routing
> entries (gsi = irqchip.pin) covering the VGIC SPI indexes.
> This routing table is overwritten by the first user-space call
> to KVM_SET_GSI_ROUTING ioctl.
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> 

so before applying this patch, but after applying the previous patch,
will our current GICv2m-based MSI injection work?

If not, is there a better split of these patches (e.g. squash this one
into the previous one)?

> ---
> ---
>  virt/kvm/arm/vgic/vgic_init.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/virt/kvm/arm/vgic/vgic_init.c b/virt/kvm/arm/vgic/vgic_init.c
> index e4459e3..041443b 100644
> --- a/virt/kvm/arm/vgic/vgic_init.c
> +++ b/virt/kvm/arm/vgic/vgic_init.c
> @@ -261,6 +261,10 @@ int vgic_init(struct kvm *kvm)
>  	kvm_for_each_vcpu(i, vcpu, kvm)
>  		kvm_vgic_vcpu_init(vcpu);
>  
> +	ret = kvm_setup_default_irq_routing(kvm);
> +	if (ret)
> +		goto out;
> +
>  	dist->initialized = true;
>  out:
>  	return ret;
> @@ -454,3 +458,23 @@ out_free_irq:
>  			kvm_get_running_vcpus());
>  	return ret;
>  }
> +
> +int kvm_setup_default_irq_routing(struct kvm *kvm)
> +{
> +	struct kvm_irq_routing_entry *entries;
> +	struct vgic_dist *dist = &kvm->arch.vgic;
> +	u32 nr = dist->nr_spis;
> +	int i, ret;
> +
> +	entries = kcalloc(nr, sizeof(struct kvm_kernel_irq_routing_entry),
> +			  GFP_KERNEL);

I think you need to check if the allocation succeeded here or not...

> +	for (i = 0; i < nr; i++) {
> +		entries[i].gsi = i;
> +		entries[i].type = KVM_IRQ_ROUTING_IRQCHIP;
> +		entries[i].u.irqchip.irqchip = 0;
> +		entries[i].u.irqchip.pin = i;
> +	}
> +	ret = kvm_set_irq_routing(kvm, entries, nr, 0);
> +	kfree(entries);
> +	return ret;
> +}
> -- 
> 1.9.1
> 

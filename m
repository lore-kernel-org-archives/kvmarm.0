From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 5/5] arm64: KVM: vgic-v2: Enable GICV access from HYP if
 access from guest is unsafe
Date: Thu, 1 Sep 2016 15:30:55 +0200
Message-ID: <20160901133055.GH10162@cbox>
References: <1471610295-1456-1-git-send-email-marc.zyngier@arm.com>
 <1471610295-1456-6-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1471610295-1456-6-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Aug 19, 2016 at 01:38:15PM +0100, Marc Zyngier wrote:
> So far, we've been disabling KVM on systems where the GICV region couldn't
> be safely given to a guest. Now that we're able to handle this access
> safely by emulating it in HYP, we can enable this feature when we detect
> an unsafe configuration.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic-v2.c | 69 +++++++++++++++++++++++++++------------------
>  1 file changed, 42 insertions(+), 27 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
> index b8da901..d1dcfc76 100644
> --- a/virt/kvm/arm/vgic/vgic-v2.c
> +++ b/virt/kvm/arm/vgic/vgic-v2.c
> @@ -278,12 +278,14 @@ int vgic_v2_map_resources(struct kvm *kvm)
>  		goto out;
>  	}
>  
> -	ret = kvm_phys_addr_ioremap(kvm, dist->vgic_cpu_base,
> -				    kvm_vgic_global_state.vcpu_base,
> -				    KVM_VGIC_V2_CPU_SIZE, true);
> -	if (ret) {
> -		kvm_err("Unable to remap VGIC CPU to VCPU\n");
> -		goto out;
> +	if (!static_branch_unlikely(&vgic_v2_cpuif_trap)) {
> +		ret = kvm_phys_addr_ioremap(kvm, dist->vgic_cpu_base,
> +					    kvm_vgic_global_state.vcpu_base,
> +					    KVM_VGIC_V2_CPU_SIZE, true);
> +		if (ret) {
> +			kvm_err("Unable to remap VGIC CPU to VCPU\n");
> +			goto out;
> +		}
>  	}
>  
>  	dist->ready = true;
> @@ -312,45 +314,51 @@ int vgic_v2_probe(const struct gic_kvm_info *info)
>  		return -ENXIO;
>  	}
>  
> -	if (!PAGE_ALIGNED(info->vcpu.start)) {
> -		kvm_err("GICV physical address 0x%llx not page aligned\n",
> -			(unsigned long long)info->vcpu.start);
> -		return -ENXIO;
> -	}
> +	if (!PAGE_ALIGNED(info->vcpu.start) ||
> +	    !PAGE_ALIGNED(resource_size(&info->vcpu))) {
> +		kvm_info("GICV region size/alignement is unsafe, using trapping\n");
> +		kvm_vgic_global_state.vcpu_base_va = ioremap(info->vcpu.start,
> +							     resource_size(&info->vcpu));
> +		if (!kvm_vgic_global_state.vcpu_base_va) {
> +			kvm_err("Cannot ioremap GICV\n");
> +			return -ENOMEM;
> +		}
>  
> -	if (!PAGE_ALIGNED(resource_size(&info->vcpu))) {
> -		kvm_err("GICV size 0x%llx not a multiple of page size 0x%lx\n",
> -			(unsigned long long)resource_size(&info->vcpu),
> -			PAGE_SIZE);
> -		return -ENXIO;
> +		ret = create_hyp_io_mappings(kvm_vgic_global_state.vcpu_base_va,
> +					     kvm_vgic_global_state.vcpu_base_va + resource_size(&info->vcpu),
> +					     info->vcpu.start);
> +		if (ret) {
> +			kvm_err("Cannot map GICV into hyp\n");
> +			goto out;
> +		}
> +
> +		static_branch_enable(&vgic_v2_cpuif_trap);
>  	}
>  
>  	kvm_vgic_global_state.vctrl_base = ioremap(info->vctrl.start,
>  						   resource_size(&info->vctrl));
>  	if (!kvm_vgic_global_state.vctrl_base) {
>  		kvm_err("Cannot ioremap GICH\n");
> -		return -ENOMEM;
> +		ret = -ENOMEM;
> +		goto out;
>  	}
>  
>  	vtr = readl_relaxed(kvm_vgic_global_state.vctrl_base + GICH_VTR);
>  	kvm_vgic_global_state.nr_lr = (vtr & 0x3f) + 1;
>  
> -	ret = kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V2);
> -	if (ret) {
> -		kvm_err("Cannot register GICv2 KVM device\n");
> -		iounmap(kvm_vgic_global_state.vctrl_base);
> -		return ret;
> -	}
> -
>  	ret = create_hyp_io_mappings(kvm_vgic_global_state.vctrl_base,
>  				     kvm_vgic_global_state.vctrl_base +
>  					 resource_size(&info->vctrl),
>  				     info->vctrl.start);
>  	if (ret) {
>  		kvm_err("Cannot map VCTRL into hyp\n");
> -		kvm_unregister_device_ops(KVM_DEV_TYPE_ARM_VGIC_V2);
> -		iounmap(kvm_vgic_global_state.vctrl_base);
> -		return ret;
> +		goto out;
> +	}
> +
> +	ret = kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V2);
> +	if (ret) {
> +		kvm_err("Cannot register GICv2 KVM device\n");
> +		goto out;
>  	}
>  
>  	kvm_vgic_global_state.can_emulate_gicv2 = true;
> @@ -361,4 +369,11 @@ int vgic_v2_probe(const struct gic_kvm_info *info)
>  	kvm_info("vgic-v2@%llx\n", info->vctrl.start);
>  
>  	return 0;
> +out:
> +	if (kvm_vgic_global_state.vctrl_base)
> +		iounmap(kvm_vgic_global_state.vctrl_base);
> +	if (kvm_vgic_global_state.vcpu_base_va)
> +		iounmap(kvm_vgic_global_state.vcpu_base_va);
> +
> +	return ret;
>  }
> -- 
> 2.1.4

With the spelling fix from Peter, and the slightly more alarming message
(shouldn't this be a kvm_warn("...using trapping") as well?) then:

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

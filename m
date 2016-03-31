From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH 13/45] KVM: arm/arm64: vgic-new: Export register
 access interface
Date: Thu, 31 Mar 2016 11:24:46 +0200
Message-ID: <20160331092446.GS4126@cbox>
References: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
 <1458871508-17279-14-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1458871508-17279-14-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Mar 25, 2016 at 02:04:36AM +0000, Andre Przywara wrote:
> Userland can access the emulated GIC to save and restore its state
> for initialization or migration purposes.
> The kvm_io_bus API requires an absolute gpa, which does not fit the
> KVM_DEV_ARM_VGIC_GRP_DIST_REGS user API, that only provides relative
> offsets. So we explicitly iterate our register list to connect
> userland to the VGIC.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> Reviewed-by: Eric Auger <eric.auger@linaro.org>
> ---
>  virt/kvm/arm/vgic/vgic.h      |  2 ++
>  virt/kvm/arm/vgic/vgic_mmio.c | 45 +++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 47 insertions(+)
> 
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index 53730ba..a462e2b 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -25,6 +25,8 @@ void vgic_v2_process_maintenance(struct kvm_vcpu *vcpu);
>  void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu);
>  void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
>  void vgic_v2_set_underflow(struct kvm_vcpu *vcpu);
> +int vgic_v2_dist_access(struct kvm_vcpu *vcpu, bool is_write,
> +			int offset, int len, void *val);
>  
>  #ifdef CONFIG_KVM_ARM_VGIC_V3
>  void vgic_v3_irq_change_affinity(struct kvm *kvm, u32 intid, u64 mpidr);
> diff --git a/virt/kvm/arm/vgic/vgic_mmio.c b/virt/kvm/arm/vgic/vgic_mmio.c
> index 26c46e7..e1fd17f 100644
> --- a/virt/kvm/arm/vgic/vgic_mmio.c
> +++ b/virt/kvm/arm/vgic/vgic_mmio.c
> @@ -113,6 +113,51 @@ struct vgic_register_region vgic_v2_dist_registers[] = {
>  		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 16),
>  };
>  
> +/*
> + * Using kvm_io_bus_* to access GIC registers directly from userspace does
> + * not work, since we would need the absolute IPA address of the register
> + * in question, but the userland interface only provides relative offsets.
> + * So we provide our own dispatcher function for that purpose here.
> + */
> +static int vgic_mmio_access(struct kvm_vcpu *vcpu,
> +			    struct vgic_register_region *region, int nr_regions,
> +			    bool is_write, int offset, int len, void *val)
> +{

I suspect this is going to get rewored based on previous discussions
with the IO api...

> +	int i;
> +	struct vgic_io_device dev;
> +
> +	for (i = 0; i < nr_regions; i++) {
> +		int reg_size = region[i].len;
> +
> +		if (!reg_size)
> +			reg_size = (region[i].bits_per_irq * 1024) / 8;
> +
> +		if ((offset < region[i].reg_offset) ||
> +		    (offset + len > region[i].reg_offset + reg_size))
> +			continue;
> +
> +		dev.base_addr	= region[i].reg_offset;
> +		dev.redist_vcpu	= vcpu;
> +
> +		if (is_write)
> +			return region[i].ops.write(vcpu, &dev.dev,
> +						   offset, len, val);
> +		else
> +			return region[i].ops.read(vcpu, &dev.dev,
> +						  offset, len, val);
> +	}
> +
> +	return -ENODEV;
> +}
> +
> +int vgic_v2_dist_access(struct kvm_vcpu *vcpu, bool is_write,
> +			int offset, int len, void *val)
> +{
> +	return vgic_mmio_access(vcpu, vgic_v2_dist_registers,
> +				ARRAY_SIZE(vgic_v2_dist_registers),
> +				is_write, offset, len, val);
> +}
> +

this makes me wonder if the v2 region declarations and functions like
this should go in a separate file?  vgic/mmio-v2.c ?

>  int kvm_vgic_register_mmio_region(struct kvm *kvm, struct kvm_vcpu *vcpu,
>  				  struct vgic_register_region *reg_desc,
>  				  struct vgic_io_device *region,
> -- 
> 2.7.3
> 

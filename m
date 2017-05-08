From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH 6/8] KVM: arm/arm64: Register iodevs when setting redist
 base and creating VCPUs
Date: Mon, 8 May 2017 19:09:07 +0200
Message-ID: <3d4125d4-7635-54e6-1cac-73963cf7260f@redhat.com>
References: <20170508115454.5075-1-cdall@linaro.org>
 <20170508115454.5075-7-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F1C7D40AF5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 May 2017 13:05:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id suJSDEP-Cs21 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 May 2017 13:05:58 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A79CA40625
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 May 2017 13:05:58 -0400 (EDT)
In-Reply-To: <20170508115454.5075-7-cdall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 08/05/2017 13:54, Christoffer Dall wrote:
> Instead of waiting with registering KVM iodevs until the very last VCPU
> is created,
aren't they registered on the 1st VCPU run?
 we can actually create the iodevs when the redist base
> address is set.  The only downside is that we must now also check if we
> need to do this for VCPUs which are created after creating the VGIC,
> because there is no enforced ordering between creating the VGIC
(and setting its base addresses)
 and the
> VCPUs.
> 
> Signed-off-by: Christoffer Dall <cdall@linaro.org>
> ---
>  include/kvm/arm_vgic.h              |  1 +
>  virt/kvm/arm/arm.c                  |  6 +++++-
>  virt/kvm/arm/vgic/vgic-init.c       | 21 ++++++++++++++++++
>  virt/kvm/arm/vgic/vgic-kvm-device.c |  7 +++++-
>  virt/kvm/arm/vgic/vgic-mmio-v3.c    | 43 +++++++++++++++++++++++++++++++++++--
>  virt/kvm/arm/vgic/vgic-v3.c         |  6 ------
>  virt/kvm/arm/vgic/vgic.h            |  3 ++-
>  7 files changed, 76 insertions(+), 11 deletions(-)
> 
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index fabcc64..4ff65ef 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -286,6 +286,7 @@ extern struct static_key_false vgic_v2_cpuif_trap;
>  
>  int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write);
>  void kvm_vgic_early_init(struct kvm *kvm);
> +int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu);
>  int kvm_vgic_create(struct kvm *kvm, u32 type);
>  void kvm_vgic_destroy(struct kvm *kvm);
>  void kvm_vgic_vcpu_early_init(struct kvm_vcpu *vcpu);
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 7941699..dd74d39 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -326,6 +326,8 @@ void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
>  
>  int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
>  {
> +	int ret = 0;
> +
>  	/* Force users to call KVM_ARM_VCPU_INIT */
>  	vcpu->arch.target = -1;
>  	bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
> @@ -335,7 +337,9 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
>  
>  	kvm_arm_reset_debug_ptr(vcpu);
>  
> -	return 0;
> +	ret = kvm_vgic_vcpu_init(vcpu);
> +
> +	return ret;
nit: ret can be removed
>  }
>  
>  void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
> index 0ea64a1..962bb57 100644
> --- a/virt/kvm/arm/vgic/vgic-init.c
> +++ b/virt/kvm/arm/vgic/vgic-init.c
> @@ -226,6 +226,27 @@ static int kvm_vgic_dist_init(struct kvm *kvm, unsigned int nr_spis)
>  	return 0;
>  }
>  
> +/**
> + * kvm_vgic_vcpu_init() - Register VCPU-specific KVM iodevs
> + * @vcpu: pointer to the VCPU being created and initialized
> + */
> +int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
> +{
> +	int ret = 0;
> +	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
> +
> +	if (!irqchip_in_kernel(vcpu->kvm))
> +		return 0;
> +
> +	/*
> +	 * If we are creating a VCPU with a GICv3 we must also register the
> +	 * KVM io device for the redistributor that belongs to this VCPU.
> +	 */
> +	if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)
> +		ret = vgic_register_redist_iodev(vcpu);
> +	return ret;
> +}
> +
>  static void kvm_vgic_vcpu_enable(struct kvm_vcpu *vcpu)
>  {
>  	if (kvm_vgic_global_state.type == VGIC_V2)
> diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
> index 69ccfd5..10ae6f3 100644
> --- a/virt/kvm/arm/vgic/vgic-kvm-device.c
> +++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
> @@ -86,8 +86,13 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
>  		break;
>  	case KVM_VGIC_V3_ADDR_TYPE_REDIST:
>  		r = vgic_check_type(kvm, KVM_DEV_TYPE_ARM_VGIC_V3);
> +		if (r)
> +			break;
> +		if (write) {
> +			r = vgic_v3_set_redist_base(kvm, *addr);
> +			goto out;
> +		}
>  		addr_ptr = &vgic->vgic_redist_base;
> -		alignment = SZ_64K;
>  		break;
>  	default:
>  		r = -ENODEV;
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> index 1828ac7..297557b 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> @@ -565,7 +565,7 @@ unsigned int vgic_v3_init_dist_iodev(struct vgic_io_device *dev)
>   *
>   * Return 0 on success, -ERRNO otherwise.
>   */
> -static int vgic_register_redist_iodev(struct kvm_vcpu *vcpu)
> +int vgic_register_redist_iodev(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm *kvm = vcpu->kvm;
>  	struct vgic_dist *vgic = &kvm->arch.vgic;
> @@ -574,6 +574,18 @@ static int vgic_register_redist_iodev(struct kvm_vcpu *vcpu)
>  	gpa_t rd_base, sgi_base;
>  	int ret;
>  
> +	/*
> +	 * We may be creating VCPUs before having set the base address for the
> +	 * redistributor region, in which case we will come back to this
> +	 * function for all VCPUs when the base address is set.  Just return
> +	 * without doing any work for now.
> +	 */
> +	if (IS_VGIC_ADDR_UNDEF(vgic->vgic_redist_base))
> +		return 0;
> +
> +	if (!vgic_v3_check_base(kvm))
> +		return -EINVAL;
> +
>  	rd_base = vgic->vgic_redist_base + vcpu->vcpu_id * SZ_64K * 2;
>  	sgi_base = rd_base + SZ_64K;
>  
> @@ -619,7 +631,7 @@ static void vgic_unregister_redist_iodev(struct kvm_vcpu *vcpu)
>  	kvm_io_bus_unregister_dev(vcpu->kvm, KVM_MMIO_BUS, &sgi_dev->dev);
>  }
>  
> -int vgic_register_redist_iodevs(struct kvm *kvm)
> +static int vgic_register_all_redist_iodevs(struct kvm *kvm)
>  {
>  	struct kvm_vcpu *vcpu;
>  	int c, ret = 0;
> @@ -641,6 +653,33 @@ int vgic_register_redist_iodevs(struct kvm *kvm)
>  	return ret;
>  }
>  
> +int vgic_v3_set_redist_base(struct kvm *kvm, u64 addr)
> +{
> +	struct vgic_dist *vgic = &kvm->arch.vgic;
> +	int ret;
> +
> +	/* vgic_check_ioaddr makes sure we don't do this twice */
> +	ret = vgic_check_ioaddr(kvm, &vgic->vgic_redist_base, addr, SZ_64K);
> +	if (ret)
> +		return ret;
> +
> +	vgic->vgic_redist_base = addr;
> +	if (!vgic_v3_check_base(kvm)) {
So we must make sure this check takes into account the case dist base
address is not set yet.

Otherwise looks good to me.

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks


Eric


> +		vgic->vgic_redist_base = VGIC_ADDR_UNDEF;
> +		return -EINVAL;
> +	}
> +
> +	/*
> +	 * Register iodevs for each existing VCPU.  Adding more VCPUs
> +	 * afterwards will register the iodevs when needed.
> +	 */
> +	ret = vgic_register_all_redist_iodevs(kvm);
> +	if (ret)
> +		return ret;
> +
> +	return 0;
> +}
> +
>  int vgic_v3_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr)
>  {
>  	const struct vgic_register_region *region;
> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> index b934e78..4d51d1f 100644
> --- a/virt/kvm/arm/vgic/vgic-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> @@ -396,12 +396,6 @@ int vgic_v3_map_resources(struct kvm *kvm)
>  		goto out;
>  	}
>  
> -	ret = vgic_register_redist_iodevs(kvm);
> -	if (ret) {
> -		kvm_err("Unable to register VGICv3 redist MMIO regions\n");
> -		goto out;
> -	}
> -
>  	if (vgic_has_its(kvm)) {
>  		ret = vgic_register_its_iodevs(kvm);
>  		if (ret) {
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index 89eb935..5f17eac 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -174,7 +174,8 @@ int vgic_v3_probe(const struct gic_kvm_info *info);
>  int vgic_v3_map_resources(struct kvm *kvm);
>  int vgic_v3_lpi_sync_pending_status(struct kvm *kvm, struct vgic_irq *irq);
>  int vgic_v3_save_pending_tables(struct kvm *kvm);
> -int vgic_register_redist_iodevs(struct kvm *kvm);
> +int vgic_v3_set_redist_base(struct kvm *kvm, u64 addr);
> +int vgic_register_redist_iodev(struct kvm_vcpu *vcpu);
>  bool vgic_v3_check_base(struct kvm *kvm);
>  
>  void vgic_v3_load(struct kvm_vcpu *vcpu);
> 

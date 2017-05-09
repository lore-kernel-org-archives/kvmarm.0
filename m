From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v2 04/11] KVM: arm/arm64: Refactor
 vgic_register_redist_iodevs
Date: Tue, 9 May 2017 11:44:54 +0200
Message-ID: <518b63b7-7d54-ad44-1355-236fe985c9e5@redhat.com>
References: <20170509085618.28311-1-cdall@linaro.org>
 <20170509085618.28311-5-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 14DCD405DA
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 May 2017 05:41:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aFGEQ306k5UP for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 May 2017 05:41:43 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DEBD740430
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 May 2017 05:41:42 -0400 (EDT)
In-Reply-To: <20170509085618.28311-5-cdall@linaro.org>
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

Hi,

On 09/05/2017 10:56, Christoffer Dall wrote:
> Split out the function to register all the redistributor iodevs into a
> function that handles a single redistributor at a time in preparation
> for being able to call this per VCPU as these get created.
> 
> Signed-off-by: Christoffer Dall <cdall@linaro.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  virt/kvm/arm/vgic/vgic-mmio-v3.c | 108 ++++++++++++++++++++++++---------------
>  virt/kvm/arm/vgic/vgic-v3.c      |   2 +-
>  virt/kvm/arm/vgic/vgic.h         |   2 +-
>  3 files changed, 68 insertions(+), 44 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> index 6afb3b4..168269b 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> @@ -556,61 +556,85 @@ unsigned int vgic_v3_init_dist_iodev(struct vgic_io_device *dev)
>  	return SZ_64K;
>  }
>  
> -int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t redist_base_address)
> +/**
> + * vgic_register_redist_iodev - register a single redist iodev
> + * @vcpu:    The VCPU to which the redistributor belongs
> + *
> + * Register a KVM iodev for this VCPU's redistributor using the address
> + * provided.
> + *
> + * Return 0 on success, -ERRNO otherwise.
> + */
> +static int vgic_register_redist_iodev(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	struct vgic_dist *vgic = &kvm->arch.vgic;
> +	struct vgic_io_device *rd_dev = &vcpu->arch.vgic_cpu.rd_iodev;
> +	struct vgic_io_device *sgi_dev = &vcpu->arch.vgic_cpu.sgi_iodev;
> +	gpa_t rd_base, sgi_base;
> +	int ret;
> +
> +	rd_base = vgic->vgic_redist_base + kvm_vcpu_get_idx(vcpu) * SZ_64K * 2;
> +	sgi_base = rd_base + SZ_64K;
> +
> +	kvm_iodevice_init(&rd_dev->dev, &kvm_io_gic_ops);
> +	rd_dev->base_addr = rd_base;
> +	rd_dev->iodev_type = IODEV_REDIST;
> +	rd_dev->regions = vgic_v3_rdbase_registers;
> +	rd_dev->nr_regions = ARRAY_SIZE(vgic_v3_rdbase_registers);
> +	rd_dev->redist_vcpu = vcpu;
> +
> +	mutex_lock(&kvm->slots_lock);
> +	ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, rd_base,
> +				      SZ_64K, &rd_dev->dev);
> +	mutex_unlock(&kvm->slots_lock);
> +
> +	if (ret)
> +		return ret;
> +
> +	kvm_iodevice_init(&sgi_dev->dev, &kvm_io_gic_ops);
> +	sgi_dev->base_addr = sgi_base;
> +	sgi_dev->iodev_type = IODEV_REDIST;
> +	sgi_dev->regions = vgic_v3_sgibase_registers;
> +	sgi_dev->nr_regions = ARRAY_SIZE(vgic_v3_sgibase_registers);
> +	sgi_dev->redist_vcpu = vcpu;
> +
> +	mutex_lock(&kvm->slots_lock);
> +	ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, sgi_base,
> +				      SZ_64K, &sgi_dev->dev);
> +	mutex_unlock(&kvm->slots_lock);
> +	if (ret)
> +		kvm_io_bus_unregister_dev(kvm, KVM_MMIO_BUS,
> +					  &rd_dev->dev);
> +
> +	return ret;
> +}
> +
> +static void vgic_unregister_redist_iodev(struct kvm_vcpu *vcpu)
> +{
> +	struct vgic_io_device *rd_dev = &vcpu->arch.vgic_cpu.rd_iodev;
> +	struct vgic_io_device *sgi_dev = &vcpu->arch.vgic_cpu.sgi_iodev;
> +
> +	kvm_io_bus_unregister_dev(vcpu->kvm, KVM_MMIO_BUS, &rd_dev->dev);
> +	kvm_io_bus_unregister_dev(vcpu->kvm, KVM_MMIO_BUS, &sgi_dev->dev);
> +}
> +
> +int vgic_register_redist_iodevs(struct kvm *kvm)
>  {
>  	struct kvm_vcpu *vcpu;
>  	int c, ret = 0;
>  
>  	kvm_for_each_vcpu(c, vcpu, kvm) {
> -		gpa_t rd_base = redist_base_address + c * SZ_64K * 2;
> -		gpa_t sgi_base = rd_base + SZ_64K;
> -		struct vgic_io_device *rd_dev = &vcpu->arch.vgic_cpu.rd_iodev;
> -		struct vgic_io_device *sgi_dev = &vcpu->arch.vgic_cpu.sgi_iodev;
> -
> -		kvm_iodevice_init(&rd_dev->dev, &kvm_io_gic_ops);
> -		rd_dev->base_addr = rd_base;
> -		rd_dev->iodev_type = IODEV_REDIST;
> -		rd_dev->regions = vgic_v3_rdbase_registers;
> -		rd_dev->nr_regions = ARRAY_SIZE(vgic_v3_rdbase_registers);
> -		rd_dev->redist_vcpu = vcpu;
> -
> -		mutex_lock(&kvm->slots_lock);
> -		ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, rd_base,
> -					      SZ_64K, &rd_dev->dev);
> -		mutex_unlock(&kvm->slots_lock);
> -
> +		ret = vgic_register_redist_iodev(vcpu);
>  		if (ret)
>  			break;
> -
> -		kvm_iodevice_init(&sgi_dev->dev, &kvm_io_gic_ops);
> -		sgi_dev->base_addr = sgi_base;
> -		sgi_dev->iodev_type = IODEV_REDIST;
> -		sgi_dev->regions = vgic_v3_sgibase_registers;
> -		sgi_dev->nr_regions = ARRAY_SIZE(vgic_v3_sgibase_registers);
> -		sgi_dev->redist_vcpu = vcpu;
> -
> -		mutex_lock(&kvm->slots_lock);
> -		ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, sgi_base,
> -					      SZ_64K, &sgi_dev->dev);
> -		mutex_unlock(&kvm->slots_lock);
> -		if (ret) {
> -			kvm_io_bus_unregister_dev(kvm, KVM_MMIO_BUS,
> -						  &rd_dev->dev);
> -			break;
> -		}
>  	}
>  
>  	if (ret) {
>  		/* The current c failed, so we start with the previous one. */
>  		for (c--; c >= 0; c--) {
> -			struct vgic_cpu *vgic_cpu;
> -
>  			vcpu = kvm_get_vcpu(kvm, c);
> -			vgic_cpu = &vcpu->arch.vgic_cpu;
> -			kvm_io_bus_unregister_dev(kvm, KVM_MMIO_BUS,
> -						  &vgic_cpu->rd_iodev.dev);
> -			kvm_io_bus_unregister_dev(kvm, KVM_MMIO_BUS,
> -						  &vgic_cpu->sgi_iodev.dev);
> +			vgic_unregister_redist_iodev(vcpu);
>  		}
>  	}
>  
> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> index 54dee72..12e52a0 100644
> --- a/virt/kvm/arm/vgic/vgic-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> @@ -386,7 +386,7 @@ int vgic_v3_map_resources(struct kvm *kvm)
>  		goto out;
>  	}
>  
> -	ret = vgic_register_redist_iodevs(kvm, dist->vgic_redist_base);
> +	ret = vgic_register_redist_iodevs(kvm);
>  	if (ret) {
>  		kvm_err("Unable to register VGICv3 redist MMIO regions\n");
>  		goto out;
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index 8259f0a..a2aeaa8 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -174,7 +174,7 @@ int vgic_v3_probe(const struct gic_kvm_info *info);
>  int vgic_v3_map_resources(struct kvm *kvm);
>  int vgic_v3_lpi_sync_pending_status(struct kvm *kvm, struct vgic_irq *irq);
>  int vgic_v3_save_pending_tables(struct kvm *kvm);
> -int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t dist_base_address);
> +int vgic_register_redist_iodevs(struct kvm *kvm);
>  
>  void vgic_v3_load(struct kvm_vcpu *vcpu);
>  void vgic_v3_put(struct kvm_vcpu *vcpu);
> 

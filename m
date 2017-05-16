From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v2 07/11] KVM: arm/arm64: Register iodevs when setting
 redist base and creating VCPUs
Date: Tue, 16 May 2017 14:39:18 +0200
Message-ID: <c6d828a8-e763-bdec-09fa-22d94a717acb@redhat.com>
References: <20170509085618.28311-1-cdall@linaro.org>
 <20170509085618.28311-8-cdall@linaro.org>
 <de4eb037-2837-fe77-d5ee-514529bfcd99@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <de4eb037-2837-fe77-d5ee-514529bfcd99@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>, Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Jean, Christoffer,

On 16/05/2017 13:23, Jean-Philippe Brucker wrote:
> Hi,
> 
> On 09/05/17 09:56, Christoffer Dall wrote:
>> Instead of waiting with registering KVM iodevs until the first VCPU is
>> run, we can actually create the iodevs when the redist base address is
>> set.  The only downside is that we must now also check if we need to do
>> this for VCPUs which are created after creating the VGIC, because there
>> is no enforced ordering between creating the VGIC (and setting its base
>> addresses) and creating the VCPUs.
> 
> This triggers a BUG(), when the order is VGIC init, then VCPU init (which
> is what kvmtool does).
> 
> Issuing KVM_CREATE_VCPU after VGIC intialization produces the following calls:
> 
> kvm_vm_ioctl_create_vcpu
>  kvm_arch_vcpu_create
>   kvm_vcpu_init
>    kvm_arch_vcpu_init
>     kvm_vgic_vcpu_init
>      vgic_register_redist_iodev
>       kvm_vcpu_get_idx
>        ... no VCPU registered yet in kvm->vcpus :(
>        BUG();

in QEMU use case, kvm_vgic_vcpu_init/vgic_register_redist_iodev does
nothing since KVM_VGIC_V3_ADDR_TYPE_REDIST was not called yet and
vgic->vgic_redist_base is undefined. Thus we postpone the redist_iodev
registration until the redist base address is set.

In QEMU case KVM_VGIC_V3_ADDR_TYPE_REDIST is called when all the CPUs
are initialized and we were lucky.
> 
>  ... would later register vcpu:
>  kvm->vcpus[atomic_read(&kvm->online_vcpus)] = vcpu
> 
> My quick fix is to move kvm_vgic_vcpu_init into kvm_arch_vcpu_postcreate,
> but it discards the return value of kvm_vgic_vcpu_init, so I don't know
> how to do it properly.

changing the proto of kvm_arch_vcpu_postcreate and moving the
kvm_vgic_vcpu_init there could be an alternative.
By the way kvm_arch_vcpu_postcreate calls kvm_vgic_early_init() which
looks strange now that we do something clever before.

Thoughts?

Thanks

Eric
> 
> Thanks,
> Jean
> 
>> Signed-off-by: Christoffer Dall <cdall@linaro.org>
>> Reviewed-by: Eric Auger <eric.auger@redhat.com>
>> ---
>>  include/kvm/arm_vgic.h              |  1 +
>>  virt/kvm/arm/arm.c                  |  2 +-
>>  virt/kvm/arm/vgic/vgic-init.c       | 21 ++++++++++++++++++
>>  virt/kvm/arm/vgic/vgic-kvm-device.c |  7 +++++-
>>  virt/kvm/arm/vgic/vgic-mmio-v3.c    | 43 +++++++++++++++++++++++++++++++++++--
>>  virt/kvm/arm/vgic/vgic-v3.c         |  6 ------
>>  virt/kvm/arm/vgic/vgic.h            |  3 ++-
>>  7 files changed, 72 insertions(+), 11 deletions(-)
>>
>> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
>> index fabcc64..4ff65ef 100644
>> --- a/include/kvm/arm_vgic.h
>> +++ b/include/kvm/arm_vgic.h
>> @@ -286,6 +286,7 @@ extern struct static_key_false vgic_v2_cpuif_trap;
>>  
>>  int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write);
>>  void kvm_vgic_early_init(struct kvm *kvm);
>> +int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu);
>>  int kvm_vgic_create(struct kvm *kvm, u32 type);
>>  void kvm_vgic_destroy(struct kvm *kvm);
>>  void kvm_vgic_vcpu_early_init(struct kvm_vcpu *vcpu);
>> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
>> index 7941699..9f6f522a4b 100644
>> --- a/virt/kvm/arm/arm.c
>> +++ b/virt/kvm/arm/arm.c
>> @@ -335,7 +335,7 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
>>  
>>  	kvm_arm_reset_debug_ptr(vcpu);
>>  
>> -	return 0;
>> +	return kvm_vgic_vcpu_init(vcpu);
>>  }
>>  
>>  void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>> diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
>> index 0ea64a1..962bb57 100644
>> --- a/virt/kvm/arm/vgic/vgic-init.c
>> +++ b/virt/kvm/arm/vgic/vgic-init.c
>> @@ -226,6 +226,27 @@ static int kvm_vgic_dist_init(struct kvm *kvm, unsigned int nr_spis)
>>  	return 0;
>>  }
>>  
>> +/**
>> + * kvm_vgic_vcpu_init() - Register VCPU-specific KVM iodevs
>> + * @vcpu: pointer to the VCPU being created and initialized
>> + */
>> +int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
>> +{
>> +	int ret = 0;
>> +	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
>> +
>> +	if (!irqchip_in_kernel(vcpu->kvm))
>> +		return 0;
>> +
>> +	/*
>> +	 * If we are creating a VCPU with a GICv3 we must also register the
>> +	 * KVM io device for the redistributor that belongs to this VCPU.
>> +	 */
>> +	if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)
>> +		ret = vgic_register_redist_iodev(vcpu);
>> +	return ret;
>> +}
>> +
>>  static void kvm_vgic_vcpu_enable(struct kvm_vcpu *vcpu)
>>  {
>>  	if (kvm_vgic_global_state.type == VGIC_V2)
>> diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
>> index 69ccfd5..10ae6f3 100644
>> --- a/virt/kvm/arm/vgic/vgic-kvm-device.c
>> +++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
>> @@ -86,8 +86,13 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
>>  		break;
>>  	case KVM_VGIC_V3_ADDR_TYPE_REDIST:
>>  		r = vgic_check_type(kvm, KVM_DEV_TYPE_ARM_VGIC_V3);
>> +		if (r)
>> +			break;
>> +		if (write) {
>> +			r = vgic_v3_set_redist_base(kvm, *addr);
>> +			goto out;
>> +		}
>>  		addr_ptr = &vgic->vgic_redist_base;
>> -		alignment = SZ_64K;
>>  		break;
>>  	default:
>>  		r = -ENODEV;
>> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> index 168269b..99da1a2 100644
>> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> @@ -565,7 +565,7 @@ unsigned int vgic_v3_init_dist_iodev(struct vgic_io_device *dev)
>>   *
>>   * Return 0 on success, -ERRNO otherwise.
>>   */
>> -static int vgic_register_redist_iodev(struct kvm_vcpu *vcpu)
>> +int vgic_register_redist_iodev(struct kvm_vcpu *vcpu)
>>  {
>>  	struct kvm *kvm = vcpu->kvm;
>>  	struct vgic_dist *vgic = &kvm->arch.vgic;
>> @@ -574,6 +574,18 @@ static int vgic_register_redist_iodev(struct kvm_vcpu *vcpu)
>>  	gpa_t rd_base, sgi_base;
>>  	int ret;
>>  
>> +	/*
>> +	 * We may be creating VCPUs before having set the base address for the
>> +	 * redistributor region, in which case we will come back to this
>> +	 * function for all VCPUs when the base address is set.  Just return
>> +	 * without doing any work for now.
>> +	 */
>> +	if (IS_VGIC_ADDR_UNDEF(vgic->vgic_redist_base))
>> +		return 0;
>> +
>> +	if (!vgic_v3_check_base(kvm))
>> +		return -EINVAL;
>> +
>>  	rd_base = vgic->vgic_redist_base + kvm_vcpu_get_idx(vcpu) * SZ_64K * 2;
>>  	sgi_base = rd_base + SZ_64K;
>>  
>> @@ -619,7 +631,7 @@ static void vgic_unregister_redist_iodev(struct kvm_vcpu *vcpu)
>>  	kvm_io_bus_unregister_dev(vcpu->kvm, KVM_MMIO_BUS, &sgi_dev->dev);
>>  }
>>  
>> -int vgic_register_redist_iodevs(struct kvm *kvm)
>> +static int vgic_register_all_redist_iodevs(struct kvm *kvm)
>>  {
>>  	struct kvm_vcpu *vcpu;
>>  	int c, ret = 0;
>> @@ -641,6 +653,33 @@ int vgic_register_redist_iodevs(struct kvm *kvm)
>>  	return ret;
>>  }
>>  
>> +int vgic_v3_set_redist_base(struct kvm *kvm, u64 addr)
>> +{
>> +	struct vgic_dist *vgic = &kvm->arch.vgic;
>> +	int ret;
>> +
>> +	/* vgic_check_ioaddr makes sure we don't do this twice */
>> +	ret = vgic_check_ioaddr(kvm, &vgic->vgic_redist_base, addr, SZ_64K);
>> +	if (ret)
>> +		return ret;
>> +
>> +	vgic->vgic_redist_base = addr;
>> +	if (!vgic_v3_check_base(kvm)) {
>> +		vgic->vgic_redist_base = VGIC_ADDR_UNDEF;
>> +		return -EINVAL;
>> +	}
>> +
>> +	/*
>> +	 * Register iodevs for each existing VCPU.  Adding more VCPUs
>> +	 * afterwards will register the iodevs when needed.
>> +	 */
>> +	ret = vgic_register_all_redist_iodevs(kvm);
>> +	if (ret)
>> +		return ret;
>> +
>> +	return 0;
>> +}
>> +
>>  int vgic_v3_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr)
>>  {
>>  	const struct vgic_register_region *region;
>> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
>> index 2d53d7a..bb35078 100644
>> --- a/virt/kvm/arm/vgic/vgic-v3.c
>> +++ b/virt/kvm/arm/vgic/vgic-v3.c
>> @@ -397,12 +397,6 @@ int vgic_v3_map_resources(struct kvm *kvm)
>>  		goto out;
>>  	}
>>  
>> -	ret = vgic_register_redist_iodevs(kvm);
>> -	if (ret) {
>> -		kvm_err("Unable to register VGICv3 redist MMIO regions\n");
>> -		goto out;
>> -	}
>> -
>>  	if (vgic_has_its(kvm)) {
>>  		ret = vgic_register_its_iodevs(kvm);
>>  		if (ret) {
>> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
>> index 89eb935..5f17eac 100644
>> --- a/virt/kvm/arm/vgic/vgic.h
>> +++ b/virt/kvm/arm/vgic/vgic.h
>> @@ -174,7 +174,8 @@ int vgic_v3_probe(const struct gic_kvm_info *info);
>>  int vgic_v3_map_resources(struct kvm *kvm);
>>  int vgic_v3_lpi_sync_pending_status(struct kvm *kvm, struct vgic_irq *irq);
>>  int vgic_v3_save_pending_tables(struct kvm *kvm);
>> -int vgic_register_redist_iodevs(struct kvm *kvm);
>> +int vgic_v3_set_redist_base(struct kvm *kvm, u64 addr);
>> +int vgic_register_redist_iodev(struct kvm_vcpu *vcpu);
>>  bool vgic_v3_check_base(struct kvm *kvm);
>>  
>>  void vgic_v3_load(struct kvm_vcpu *vcpu);
>>
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> 

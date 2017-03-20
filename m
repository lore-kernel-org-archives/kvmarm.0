From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v3 11/19] KVM: arm64: ITS: KVM_DEV_ARM_VGIC_GRP_ITS_TABLES
 group
Date: Mon, 20 Mar 2017 18:14:31 +0000
Message-ID: <799d0724-6352-4ff9-4d88-5f379435db4b@arm.com>
References: <1488800074-21991-1-git-send-email-eric.auger@redhat.com>
 <1488800074-21991-12-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CF8140C4E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Mar 2017 14:10:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tQJKi9+6T31X for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Mar 2017 14:10:53 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E034740AE8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Mar 2017 14:10:52 -0400 (EDT)
In-Reply-To: <1488800074-21991-12-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Prasun.Kapoor@cavium.com, quintela@redhat.com, dgilbert@redhat.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Eric,

On 06/03/17 11:34, Eric Auger wrote:
> Introduce a new group aiming at saving/restoring the ITS
> tables to/from the guest memory.
> 
> We hold the its lock during the save and restore to prevent
> any command from being executed. This also garantees the LPI
> list is not going to change and no MSI injection can happen
> during the operation.
> 
> At this stage the functionality is not yet implemented. Only
> the skeleton is put in place.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> 
> v1 -> v2:
> - remove useless kvm parameter
> 
> At the end of the restore I trigger a map_resources. This aims
> at accomodating the virtio-net-pci guest use case. On restore I
> can see the virtio-net-pci device sends MSI before the first
> VCPU run. The fact we are not able to handle MSIs at that stage
> stalls the virtio-net-pci device. We may fix this issue at QEMU
> level instead.
> ---
>  arch/arm/include/uapi/asm/kvm.h   |   1 +
>  arch/arm64/include/uapi/asm/kvm.h |   1 +
>  virt/kvm/arm/vgic/vgic-its.c      | 115 +++++++++++++++++++++++++++++++++++++-
>  3 files changed, 116 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
> index 4beb83b..7b165e9 100644
> --- a/arch/arm/include/uapi/asm/kvm.h
> +++ b/arch/arm/include/uapi/asm/kvm.h
> @@ -193,6 +193,7 @@ struct kvm_arch_memory_slot {
>  #define KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS 6
>  #define KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO  7
>  #define KVM_DEV_ARM_VGIC_GRP_ITS_REGS	8
> +#define KVM_DEV_ARM_VGIC_GRP_ITS_TABLES	9
>  #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT	10
>  #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
>  			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index 7e8dd69..166df68 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -213,6 +213,7 @@ struct kvm_arch_memory_slot {
>  #define KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS 6
>  #define KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO  7
>  #define KVM_DEV_ARM_VGIC_GRP_ITS_REGS 8
> +#define KVM_DEV_ARM_VGIC_GRP_ITS_TABLES 9
>  #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT	10
>  #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
>  			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 322e370..dd7545a 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -1551,6 +1551,112 @@ int vgic_its_attr_regs_access(struct kvm_device *dev,
>  	return 0;
>  }
>  
> +/**
> + * vgic_its_flush_pending_tables - Flush the pending tables into guest RAM
> + */
> +static int vgic_its_flush_pending_tables(struct vgic_its *its)

Mmh, it sounds a bit odd to flush/restore pending tables, which are a
redistributor property, really, in an ITS context. But I think it's fine
for them to stay here for now.
I will check again when I arrive at the actual implementation ...

> +{
> +	return -ENXIO;
> +}
> +
> +/**
> + * vgic_its_restore_pending_tables - Restore the pending tables from guest
> + * RAM to internal data structs
> + */
> +static int vgic_its_restore_pending_tables(struct vgic_its *its)
> +{
> +	return -ENXIO;
> +}
> +
> +/**
> + * vgic_its_flush_device_tables - flush the device table and all ITT
> + * into guest RAM
> + */
> +static int vgic_its_flush_device_tables(struct vgic_its *its)
> +{
> +	return -ENXIO;
> +}
> +
> +/**
> + * vgic_its_restore_device_tables - restore the device table and all ITT
> + * from guest RAM to internal data structs
> + */
> +static int vgic_its_restore_device_tables(struct vgic_its *its)
> +{
> +	return -ENXIO;
> +}
> +
> +/**
> + * vgic_its_flush_collection_table - flush the collection table into
> + * guest RAM
> + */
> +static int vgic_its_flush_collection_table(struct vgic_its *its)
> +{
> +	return -ENXIO;
> +}
> +
> +/**
> + * vgic_its_restore_collection_table - reads the collection table
> + * in guest memory and restores the ITS internal state. Requires the
> + * BASER registers to be restored before.
> + */
> +static int vgic_its_restore_collection_table(struct vgic_its *its)
> +{
> +	return -ENXIO;
> +}
> +
> +/**
> + * vgic_its_table_flush - Flush all the tables into guest RAM
> + */
> +static int vgic_its_table_flush(struct vgic_its *its)
> +{
> +	int ret;
> +
> +	mutex_lock(&its->its_lock);
> +
> +	ret = vgic_its_flush_pending_tables(its);
> +	if (ret)
> +		goto out;
> +	ret = vgic_its_flush_device_tables(its);
> +	if (ret)
> +		goto out;
> +
> +	ret = vgic_its_flush_collection_table(its);
> +out:
> +	mutex_unlock(&its->its_lock);
> +	return ret;
> +}
> +
> +/**
> + * vgic_its_table_restore - Restore all tables from guest RAM to internal
> + * data structs
> + */
> +static int vgic_its_table_restore(struct vgic_its *its)
> +{
> +	int ret;
> +
> +	mutex_lock(&its->its_lock);
> +	ret = vgic_its_restore_collection_table(its);
> +	if (ret)
> +		goto out;
> +
> +	ret = vgic_its_restore_device_tables(its);
> +	if (ret)
> +		goto out;
> +
> +	ret = vgic_its_restore_pending_tables(its);
> +out:
> +	mutex_unlock(&its->its_lock);
> +
> +	/**
> +	 *  In real use case we observe MSI injection before
> +	 *  the first CPU run. This is likely to stall virtio-net-pci
> +	 *  for instance
> +	 */
> +	ret = kvm_vgic_map_resources(its->dev->kvm);
> +	return ret;
> +}
> +
>  static int vgic_its_has_attr(struct kvm_device *dev,
>  			     struct kvm_device_attr *attr)
>  {
> @@ -1569,6 +1675,8 @@ static int vgic_its_has_attr(struct kvm_device *dev,
>  		break;
>  	case KVM_DEV_ARM_VGIC_GRP_ITS_REGS:
>  		return vgic_its_has_attr_regs(dev, attr);
> +	case KVM_DEV_ARM_VGIC_GRP_ITS_TABLES:
> +		return 0;

So maybe this has been discussed before and I missed it, but wouldn't it
be more natural to trigger flush/restore via the
KVM_DEV_ARM_VGIC_GRP_CTRL group, next to the (currently only one)
KVM_DEV_ARM_VGIC_CTRL_INIT command? To me that sounds more like a fit,
since this group is explicitly about control commands. Encoding flush as
a dummy read and restore as a dummy write sounds a bit of a stretch to me.
So I'd suggest to just implement two more commands in that group:
KVM_DEV_ARM_VGIC_CTRL_FLUSH_TABLES	and KVM_DEV_ARM_VGIC_CTRL_RESTORE_TABLES

Does that make sense or do I miss something?

Cheers,
Andre.

>  	}
>  	return -ENXIO;
>  }
> @@ -1617,6 +1725,8 @@ static int vgic_its_set_attr(struct kvm_device *dev,
>  
>  		return vgic_its_attr_regs_access(dev, attr, &reg, true);
>  	}
> +	case KVM_DEV_ARM_VGIC_GRP_ITS_TABLES:
> +		return vgic_its_table_restore(its);
>  	}
>  	return -ENXIO;
>  }
> @@ -1624,9 +1734,10 @@ static int vgic_its_set_attr(struct kvm_device *dev,
>  static int vgic_its_get_attr(struct kvm_device *dev,
>  			     struct kvm_device_attr *attr)
>  {
> +	struct vgic_its *its = dev->private;
> +
>  	switch (attr->group) {
>  	case KVM_DEV_ARM_VGIC_GRP_ADDR: {
> -		struct vgic_its *its = dev->private;
>  		u64 addr = its->vgic_its_base;
>  		u64 __user *uaddr = (u64 __user *)(long)attr->addr;
>  		unsigned long type = (unsigned long)attr->attr;
> @@ -1647,6 +1758,8 @@ static int vgic_its_get_attr(struct kvm_device *dev,
>  		if (ret)
>  			return ret;
>  		return put_user(reg, uaddr);
> +	case KVM_DEV_ARM_VGIC_GRP_ITS_TABLES:
> +		return vgic_its_table_flush(its);
>  	}
>  	default:
>  		return -ENXIO;
> 

From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v5 14/22] KVM: arm64: vgic-its:
 KVM_DEV_ARM_ITS_SAVE/RESTORE_TABLES
Date: Thu, 27 Apr 2017 10:24:25 -0700
Message-ID: <20170427172425.GR50776@lvm>
References: <1492164934-988-1-git-send-email-eric.auger@redhat.com>
 <1492164934-988-15-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 344D041050
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Apr 2017 13:21:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id B7Gff+Y3hUoE for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 Apr 2017 13:21:34 -0400 (EDT)
Received: from mail-wr0-f172.google.com (mail-wr0-f172.google.com
 [209.85.128.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7183A41009
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Apr 2017 13:21:34 -0400 (EDT)
Received: by mail-wr0-f172.google.com with SMTP id l9so21115413wre.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Apr 2017 10:24:27 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1492164934-988-15-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@redhat.com>
Cc: kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, marc.zyngier@arm.com, andre.przywara@arm.com, quintela@redhat.com, dgilbert@redhat.com, Vijaya.Kumar@cavium.com, vijayak@caviumnetworks.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Apr 14, 2017 at 12:15:26PM +0200, Eric Auger wrote:
> Introduce new attributes in KVM_DEV_ARM_VGIC_GRP_CTRL group:
> - KVM_DEV_ARM_ITS_SAVE_TABLES: saves the ITS tables into guest RAM
> - KVM_DEV_ARM_ITS_RESTORE_TABLES: restores them into VGIC internal
>   structures.
> 
> We hold the vcpus lock during the save and restore to make
> sure no vcpu is running.
> 
> At this stage the functionality is not yet implemented. Only
> the skeleton is put in place.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> 
> v4 -> v5:
> - use KVM_DEV_ARM_ITS_SAVE_TABLES and KVM_DEV_ARM_ITS_RESTORE_TABLES
> - rename *flush* into *save*
> - call its_sync_lpi_pending_table at the end of restore
> - use abi framework
> 
> v3 -> v4:
> - pass kvm struct handle to vgic_its_flush/restore_pending_tables
> - take the kvm lock and vcpu locks
> - ABI revision check
> - check attr->attr is null
> 
> v1 -> v2:
> - remove useless kvm parameter
> ---
>  arch/arm/include/uapi/asm/kvm.h   |   4 +-
>  arch/arm64/include/uapi/asm/kvm.h |   4 +-
>  virt/kvm/arm/vgic/vgic-its.c      | 108 ++++++++++++++++++++++++++++++++++++--
>  3 files changed, 110 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
> index 4beb83b..8e6563c 100644
> --- a/arch/arm/include/uapi/asm/kvm.h
> +++ b/arch/arm/include/uapi/asm/kvm.h
> @@ -199,7 +199,9 @@ struct kvm_arch_memory_slot {
>  #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INTID_MASK 0x3ff
>  #define VGIC_LEVEL_INFO_LINE_LEVEL	0
>  
> -#define   KVM_DEV_ARM_VGIC_CTRL_INIT    0
> +#define   KVM_DEV_ARM_VGIC_CTRL_INIT		0
> +#define   KVM_DEV_ARM_ITS_SAVE_TABLES		1
> +#define   KVM_DEV_ARM_ITS_RESTORE_TABLES	2
>  
>  /* KVM_IRQ_LINE irq field index values */
>  #define KVM_ARM_IRQ_TYPE_SHIFT		24
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index 7e8dd69..1e35115 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -219,7 +219,9 @@ struct kvm_arch_memory_slot {
>  #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INTID_MASK	0x3ff
>  #define VGIC_LEVEL_INFO_LINE_LEVEL	0
>  
> -#define   KVM_DEV_ARM_VGIC_CTRL_INIT	0
> +#define   KVM_DEV_ARM_VGIC_CTRL_INIT		0
> +#define   KVM_DEV_ARM_ITS_SAVE_TABLES           1
> +#define   KVM_DEV_ARM_ITS_RESTORE_TABLES        2
>  
>  /* Device Control API on vcpu fd */
>  #define KVM_ARM_VCPU_PMU_V3_CTRL	0
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index de1ed6d..55267ab 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -1648,12 +1648,68 @@ int vgic_its_attr_regs_access(struct kvm_device *dev,
>  }
>  
>  /**
> + * vgic_its_save_device_tables - Save the device table and all ITT
> + * into guest RAM
> + */
> +static int vgic_its_save_device_tables(struct vgic_its *its)
> +{
> +	return -ENXIO;
> +}
> +
> +/**
> + * vgic_its_restore_device_tables - Restore the device table and all ITT
> + * from guest RAM to internal data structs
> + */
> +static int vgic_its_restore_device_tables(struct vgic_its *its)
> +{
> +	return -ENXIO;
> +}
> +
> +/**
> + * vgic_its_save_collection_table - Save the collection table into
> + * guest RAM
> + */
> +static int vgic_its_save_collection_table(struct vgic_its *its)
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
>   * vgic_its_save_tables_v0 - Save the ITS tables into guest ARM
>   * according to v0 ABI
>   */
>  static int vgic_its_save_tables_v0(struct vgic_its *its)
>  {
> -	return -ENXIO;
> +	struct kvm *kvm = its->dev->kvm;
> +	int ret;
> +
> +	mutex_lock(&kvm->lock);
> +
> +	if (!lock_all_vcpus(kvm)) {
> +		mutex_unlock(&kvm->lock);
> +		return -EBUSY;
> +	}
> +
> +	ret = vgic_its_save_device_tables(its);
> +	if (ret)
> +		goto out;
> +
> +	ret = vgic_its_save_collection_table(its);
> +
> +out:
> +	unlock_all_vcpus(kvm);
> +	mutex_unlock(&kvm->lock);
> +	return ret;
>  }
>  
>  /**
> @@ -1663,7 +1719,41 @@ static int vgic_its_save_tables_v0(struct vgic_its *its)
>   */
>  static int vgic_its_restore_tables_v0(struct vgic_its *its)
>  {
> -	return -ENXIO;
> +	struct kvm *kvm = its->dev->kvm;
> +	struct kvm_vcpu *vcpu;
> +	int ret, c;
> +
> +	mutex_lock(&kvm->lock);
> +
> +	if (!lock_all_vcpus(kvm)) {
> +		mutex_unlock(&kvm->lock);
> +		return -EBUSY;
> +	}
> +
> +	ret = vgic_its_restore_collection_table(its);
> +	if (ret)
> +		goto out;
> +
> +	ret = vgic_its_restore_device_tables(its);
> +
> +	kvm_for_each_vcpu(c, vcpu, kvm) {
> +		ret = its_sync_lpi_pending_table(vcpu);
> +		if (ret)
> +			break;
> +	}
> +
> +out:
> +	unlock_all_vcpus(kvm);
> +	mutex_unlock(&kvm->lock);
> +
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * On restore path, MSI injections can happen before the
> +	 * first VCPU run so let's complete the GIC init here.
> +	 */
> +	return kvm_vgic_map_resources(its->dev->kvm);

wait, this is supposed to run when everything else is done and just
before running a VCPU, but now we run this way earlier?  Is that safe.
It feels incredibly dangerous.

Otherwise I'll wait with looking at this patch in more detail until you
respin based on not doing the its_sync_lpi_pending_table() here anymore
as a result of the ABI discussion.

Thanks,
-Christoffer

>  }
>  
>  static int vgic_its_commit_v0(struct vgic_its *its)
> @@ -1718,6 +1808,10 @@ static int vgic_its_has_attr(struct kvm_device *dev,
>  		switch (attr->attr) {
>  		case KVM_DEV_ARM_VGIC_CTRL_INIT:
>  			return 0;
> +		case KVM_DEV_ARM_ITS_SAVE_TABLES:
> +			return 0;
> +		case KVM_DEV_ARM_ITS_RESTORE_TABLES:
> +			return 0;
>  		}
>  		break;
>  	case KVM_DEV_ARM_VGIC_GRP_ITS_REGS:
> @@ -1753,14 +1847,20 @@ static int vgic_its_set_attr(struct kvm_device *dev,
>  
>  		return 0;
>  	}
> -	case KVM_DEV_ARM_VGIC_GRP_CTRL:
> +	case KVM_DEV_ARM_VGIC_GRP_CTRL: {
> +		const struct vgic_its_abi *abi = vgic_its_get_abi(its);
> +
>  		switch (attr->attr) {
>  		case KVM_DEV_ARM_VGIC_CTRL_INIT:
>  			its->initialized = true;
>  
>  			return 0;
> +		case KVM_DEV_ARM_ITS_SAVE_TABLES:
> +			return abi->save_tables(its);
> +		case KVM_DEV_ARM_ITS_RESTORE_TABLES:
> +			return abi->restore_tables(its);
>  		}
> -		break;
> +	}
>  	case KVM_DEV_ARM_VGIC_GRP_ITS_REGS: {
>  		u64 __user *uaddr = (u64 __user *)(long)attr->addr;
>  		u64 reg;
> -- 
> 2.5.5
> 

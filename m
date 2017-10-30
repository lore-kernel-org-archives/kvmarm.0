From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v6 9/9] KVM: arm/arm64: vgic-its: Implement
 KVM_DEV_ARM_ITS_CTRL_RESET
Date: Mon, 30 Oct 2017 07:11:33 +0100
Message-ID: <20171030061133.GK2166@lvm>
References: <1509031391-4407-1-git-send-email-eric.auger@redhat.com>
 <1509031391-4407-10-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1509031391-4407-10-git-send-email-eric.auger@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, peter.maydell@linaro.org, andre.przywara@arm.com, wanghaibin.wang@huawei.com, wu.wubin@huawei.com, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Oct 26, 2017 at 05:23:11PM +0200, Eric Auger wrote:
> On reset we clear the valid bits of GITS_CBASER and GITS_BASER<n>.
> We also clear command queue registers and free the cache (device,
> collection, and lpi lists).
> 
> As we need to take the same locks as save/restore functions, we
> create a vgic_its_ctrl() wrapper that handles KVM_DEV_ARM_VGIC_GRP_CTRL
> group functions.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

> ---
> 
> v5 -> v6:
> - Rework the locking and create vgic_its_ctrl
> 
> v2 -> v3:
> - added Christoffer's R-b
> ---
>  arch/arm/include/uapi/asm/kvm.h   |   1 +
>  arch/arm64/include/uapi/asm/kvm.h |   1 +
>  virt/kvm/arm/vgic/vgic-its.c      | 105 ++++++++++++++++++++------------------
>  3 files changed, 58 insertions(+), 49 deletions(-)
> 
> diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
> index 5db2d4c..7ef0c06 100644
> --- a/arch/arm/include/uapi/asm/kvm.h
> +++ b/arch/arm/include/uapi/asm/kvm.h
> @@ -215,6 +215,7 @@ struct kvm_arch_memory_slot {
>  #define   KVM_DEV_ARM_ITS_SAVE_TABLES		1
>  #define   KVM_DEV_ARM_ITS_RESTORE_TABLES	2
>  #define   KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES	3
> +#define   KVM_DEV_ARM_ITS_CTRL_RESET		4
>  
>  /* KVM_IRQ_LINE irq field index values */
>  #define KVM_ARM_IRQ_TYPE_SHIFT		24
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index 9f3ca24..b5306ce 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -227,6 +227,7 @@ struct kvm_arch_memory_slot {
>  #define   KVM_DEV_ARM_ITS_SAVE_TABLES           1
>  #define   KVM_DEV_ARM_ITS_RESTORE_TABLES        2
>  #define   KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES	3
> +#define   KVM_DEV_ARM_ITS_CTRL_RESET		4
>  
>  /* Device Control API on vcpu fd */
>  #define KVM_ARM_VCPU_PMU_V3_CTRL	0
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 2a92d4d..09a459b 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -2301,29 +2301,13 @@ static int vgic_its_restore_collection_table(struct vgic_its *its)
>   */
>  static int vgic_its_save_tables_v0(struct vgic_its *its)
>  {
> -	struct kvm *kvm = its->dev->kvm;
>  	int ret;
>  
> -	mutex_lock(&kvm->lock);
> -	mutex_lock(&its->its_lock);
> -
> -	if (!lock_all_vcpus(kvm)) {
> -		mutex_unlock(&its->its_lock);
> -		mutex_unlock(&kvm->lock);
> -		return -EBUSY;
> -	}
> -
>  	ret = vgic_its_save_device_tables(its);
>  	if (ret)
> -		goto out;
> -
> -	ret = vgic_its_save_collection_table(its);
> +		return ret;
>  
> -out:
> -	unlock_all_vcpus(kvm);
> -	mutex_unlock(&its->its_lock);
> -	mutex_unlock(&kvm->lock);
> -	return ret;
> +	return vgic_its_save_collection_table(its);
>  }
>  
>  /**
> @@ -2333,29 +2317,13 @@ static int vgic_its_save_tables_v0(struct vgic_its *its)
>   */
>  static int vgic_its_restore_tables_v0(struct vgic_its *its)
>  {
> -	struct kvm *kvm = its->dev->kvm;
>  	int ret;
>  
> -	mutex_lock(&kvm->lock);
> -	mutex_lock(&its->its_lock);
> -
> -	if (!lock_all_vcpus(kvm)) {
> -		mutex_unlock(&its->its_lock);
> -		mutex_unlock(&kvm->lock);
> -		return -EBUSY;
> -	}
> -
>  	ret = vgic_its_restore_collection_table(its);
>  	if (ret)
> -		goto out;
> -
> -	ret = vgic_its_restore_device_tables(its);
> -out:
> -	unlock_all_vcpus(kvm);
> -	mutex_unlock(&its->its_lock);
> -	mutex_unlock(&kvm->lock);
> +		return ret;
>  
> -	return ret;
> +	return vgic_its_restore_device_tables(its);
>  }
>  
>  static int vgic_its_commit_v0(struct vgic_its *its)
> @@ -2374,6 +2342,19 @@ static int vgic_its_commit_v0(struct vgic_its *its)
>  	return 0;
>  }
>  
> +static void vgic_its_reset(struct kvm *kvm, struct vgic_its *its)
> +{
> +	/* We need to keep the ABI specific field values */
> +	its->baser_coll_table &= ~GITS_BASER_VALID;
> +	its->baser_device_table &= ~GITS_BASER_VALID;
> +	its->cbaser = 0;
> +	its->creadr = 0;
> +	its->cwriter = 0;
> +	its->enabled = 0;
> +	vgic_its_free_device_list(kvm, its);
> +	vgic_its_free_collection_list(kvm, its);
> +}
> +
>  static int vgic_its_has_attr(struct kvm_device *dev,
>  			     struct kvm_device_attr *attr)
>  {
> @@ -2388,6 +2369,8 @@ static int vgic_its_has_attr(struct kvm_device *dev,
>  		switch (attr->attr) {
>  		case KVM_DEV_ARM_VGIC_CTRL_INIT:
>  			return 0;
> +		case KVM_DEV_ARM_ITS_CTRL_RESET:
> +			return 0;
>  		case KVM_DEV_ARM_ITS_SAVE_TABLES:
>  			return 0;
>  		case KVM_DEV_ARM_ITS_RESTORE_TABLES:
> @@ -2400,6 +2383,41 @@ static int vgic_its_has_attr(struct kvm_device *dev,
>  	return -ENXIO;
>  }
>  
> +static int vgic_its_ctrl(struct kvm *kvm, struct vgic_its *its, u64 attr)
> +{
> +	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
> +	int ret = 0;
> +
> +	if (attr == KVM_DEV_ARM_VGIC_CTRL_INIT) /* Nothing to do */
> +		return 0;
> +
> +	mutex_lock(&kvm->lock);
> +	mutex_lock(&its->its_lock);
> +
> +	if (!lock_all_vcpus(kvm)) {
> +		mutex_unlock(&its->its_lock);
> +		mutex_unlock(&kvm->lock);
> +		return -EBUSY;
> +	}
> +
> +	switch (attr) {
> +	case KVM_DEV_ARM_ITS_CTRL_RESET:
> +		vgic_its_reset(kvm, its);
> +		break;
> +	case KVM_DEV_ARM_ITS_SAVE_TABLES:
> +		ret = abi->save_tables(its);
> +		break;
> +	case KVM_DEV_ARM_ITS_RESTORE_TABLES:
> +		ret = abi->restore_tables(its);
> +		break;
> +	}
> +
> +	unlock_all_vcpus(kvm);
> +	mutex_unlock(&its->its_lock);
> +	mutex_unlock(&kvm->lock);
> +	return ret;
> +}
> +
>  static int vgic_its_set_attr(struct kvm_device *dev,
>  			     struct kvm_device_attr *attr)
>  {
> @@ -2425,19 +2443,8 @@ static int vgic_its_set_attr(struct kvm_device *dev,
>  
>  		return vgic_register_its_iodev(dev->kvm, its, addr);
>  	}
> -	case KVM_DEV_ARM_VGIC_GRP_CTRL: {
> -		const struct vgic_its_abi *abi = vgic_its_get_abi(its);
> -
> -		switch (attr->attr) {
> -		case KVM_DEV_ARM_VGIC_CTRL_INIT:
> -			/* Nothing to do */
> -			return 0;
> -		case KVM_DEV_ARM_ITS_SAVE_TABLES:
> -			return abi->save_tables(its);
> -		case KVM_DEV_ARM_ITS_RESTORE_TABLES:
> -			return abi->restore_tables(its);
> -		}
> -	}
> +	case KVM_DEV_ARM_VGIC_GRP_CTRL:
> +		return vgic_its_ctrl(dev->kvm, its, attr->attr);
>  	case KVM_DEV_ARM_VGIC_GRP_ITS_REGS: {
>  		u64 __user *uaddr = (u64 __user *)(long)attr->addr;
>  		u64 reg;
> -- 
> 2.5.5
> 

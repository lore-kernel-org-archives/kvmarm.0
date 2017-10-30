From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v6 7/9] KVM: arm/arm64: vgic-its: Free caches when GITS_BASER Valid bit is cleared
Date: Mon, 30 Oct 2017 03:19:54 +0000
Message-ID: <86efpl725h.fsf@arm.com>
References: <1509031391-4407-1-git-send-email-eric.auger@redhat.com>
        <1509031391-4407-8-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1509031391-4407-8-git-send-email-eric.auger@redhat.com> (Eric
        Auger's message of "Thu, 26 Oct 2017 17:23:09 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, cdall@linaro.org, peter.maydell@linaro.org, andre.przywara@arm.com, wanghaibin.wang@huawei.com, wu.wubin@huawei.com, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Oct 26 2017 at  6:23:09 pm BST, Eric Auger <eric.auger@redhat.com> wrote:
> When the GITS_BASER<n>.Valid gets cleared, the data structures in
> guest RAM are not valid anymore. The device, collection
> and LPI lists stored in the in-kernel ITS represent the same
> information in some form of cache. So let's void the cache.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>
> ---
> v5 -> v6:
> - rename type into device_type and revert tthe u64 -> int change
> - remove the default clause
> - take the its mutex lock around vgic_its_free_device/collection_list
>
> v4 -> v5:
> - add comment about locking
>
> v2 -> v3:
> - add a comment and clear cache in if block
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 26 ++++++++++++++++++++++----
>  1 file changed, 22 insertions(+), 4 deletions(-)
>
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 5b7be85..2a92d4d 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -1428,7 +1428,7 @@ static void vgic_mmio_write_its_baser(struct kvm *kvm,
>  				      unsigned long val)
>  {
>  	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
> -	u64 entry_size, device_type;
> +	u64 entry_size, table_type;
>  	u64 reg, *regptr, clearbits = 0;
>  
>  	/* When GITS_CTLR.Enable is 1, we ignore write accesses. */
> @@ -1439,12 +1439,12 @@ static void vgic_mmio_write_its_baser(struct kvm *kvm,
>  	case 0:
>  		regptr = &its->baser_device_table;
>  		entry_size = abi->dte_esz;
> -		device_type = GITS_BASER_TYPE_DEVICE;
> +		table_type = GITS_BASER_TYPE_DEVICE;
>  		break;
>  	case 1:
>  		regptr = &its->baser_coll_table;
>  		entry_size = abi->cte_esz;
> -		device_type = GITS_BASER_TYPE_COLLECTION;
> +		table_type = GITS_BASER_TYPE_COLLECTION;
>  		clearbits = GITS_BASER_INDIRECT;
>  		break;
>  	default:
> @@ -1456,10 +1456,28 @@ static void vgic_mmio_write_its_baser(struct kvm *kvm,
>  	reg &= ~clearbits;
>  
>  	reg |= (entry_size - 1) << GITS_BASER_ENTRY_SIZE_SHIFT;
> -	reg |= device_type << GITS_BASER_TYPE_SHIFT;
> +	reg |= table_type << GITS_BASER_TYPE_SHIFT;
>  	reg = vgic_sanitise_its_baser(reg);
>  
>  	*regptr = reg;
> +
> +	/*
> +	 * If the table is no longer valid, we clear the associated cached data.
> +	 * Note: there cannot be any race with save/restore code which locks
> +	 * all vcpus.
> +	 */

nit: I found this comment to be pretty confusing, as it talks about
locks that we don't try to take here. The actual mutual exclusion is
done by taking the its_lock, which is also taken on the save/restore
path.

Christoffer: can you fix that when applying this patch? I don't think
there is a need for a respin of the series just for this.

> +	if (!(reg & GITS_BASER_VALID)) {
> +		mutex_lock(&its->its_lock);
> +		switch (table_type) {
> +		case GITS_BASER_TYPE_DEVICE:
> +			vgic_its_free_device_list(kvm, its);
> +			break;
> +		case GITS_BASER_TYPE_COLLECTION:
> +			vgic_its_free_collection_list(kvm, its);
> +			break;
> +		}
> +		mutex_unlock(&its->its_lock);
> +	}
>  }
>  
>  static unsigned long vgic_mmio_read_its_ctlr(struct kvm *vcpu,

Otherwise:

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.

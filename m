From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v6 19/24] KVM: arm64: vgic-its: Collection table
 save/restore
Date: Fri, 5 May 2017 05:28:31 -0700
Message-ID: <20170505122831.GG1419@lvm>
References: <1493898284-29504-1-git-send-email-eric.auger@redhat.com>
 <1493898284-29504-20-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DDC724095A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 May 2017 08:25:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eKeolZrIJqd0 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 May 2017 08:25:27 -0400 (EDT)
Received: from mail-lf0-f43.google.com (mail-lf0-f43.google.com
 [209.85.215.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8209D40905
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 May 2017 08:25:26 -0400 (EDT)
Received: by mail-lf0-f43.google.com with SMTP id r17so2639513lfg.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 05 May 2017 05:28:34 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1493898284-29504-20-git-send-email-eric.auger@redhat.com>
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
Cc: kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, marc.zyngier@arm.com, andre.przywara@arm.com, quintela@redhat.com, dgilbert@redhat.com, bjsprakash.linux@gmail.com, Vijaya.Kumar@cavium.com, vijayak@caviumnetworks.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, May 04, 2017 at 01:44:39PM +0200, Eric Auger wrote:
> The save path copies the collection entries into guest RAM
> at the GPA specified in the BASER register. This obviously
> requires the BASER to be set. The last written element is a
> dummy collection table entry.
> 
> We do not index by collection ID as the collection entry
> can fit into 8 bytes while containing the collection ID.
> 
> On restore path we re-allocate the collection objects.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> v5 -> v6:
> - remove the valid pointer from vgic_its_restore_cte and
>   return +1 if no error and last elt not found
> - check the BASER valid bit
> - add BUG_ON to check esz versus val size
> 
> v4 -> v5:
> - add macros for field encoding/decoding
> - use abi->cte_esz
> - rename flush into save
> - check the target_addr is valid
> 
> v3 -> v4:
> - replaced u64 *ptr by gpa_t gpa
> - check the collection does not exist before allocating it
> 
> v1 -> v2:
> - reword commit message and directly use 8 as entry size
> - no kvm parameter anymore
> - add helper for flush/restore cte
> - table size computed here
> - add le64/cpu conversions
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 102 ++++++++++++++++++++++++++++++++++++++++++-
>  virt/kvm/arm/vgic/vgic.h     |   9 ++++
>  2 files changed, 109 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 1db7e38..6bef9147 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -1804,13 +1804,91 @@ static int vgic_its_restore_device_tables(struct vgic_its *its)
>  	return -ENXIO;
>  }
>  
> +static int vgic_its_save_cte(struct vgic_its *its,
> +			     struct its_collection *collection,
> +			     gpa_t gpa, int esz)
> +{
> +	u64 val;
> +
> +	val = (1ULL << KVM_ITS_CTE_VALID_SHIFT |
> +	       ((u64)collection->target_addr << KVM_ITS_CTE_RDBASE_SHIFT) |
> +	       collection->collection_id);
> +	val = cpu_to_le64(val);
> +	return kvm_write_guest(its->dev->kvm, gpa, &val, esz);
> +}
> +
> +static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa, int esz)
> +{
> +	struct its_collection *collection;
> +	struct kvm *kvm = its->dev->kvm;
> +	u32 target_addr, coll_id;
> +	u64 val;
> +	int ret;
> +
> +	BUG_ON(esz > sizeof(val));
> +	ret = kvm_read_guest(kvm, gpa, &val, esz);
> +	if (ret)
> +		return ret;
> +	val = le64_to_cpu(val);
> +	if (!(val & KVM_ITS_CTE_VALID_MASK))
> +		return 0;
> +
> +	target_addr = (u32)(val >> KVM_ITS_CTE_RDBASE_SHIFT);
> +	coll_id = val & KVM_ITS_CTE_ICID_MASK;
> +
> +	if (target_addr >= atomic_read(&kvm->online_vcpus))
> +		return -EINVAL;
> +
> +	collection = find_collection(its, coll_id);
> +	if (collection)
> +		return -EEXIST;
> +	ret = vgic_its_alloc_collection(its, &collection, coll_id);
> +	if (ret)
> +		return ret;
> +	collection->target_addr = target_addr;
> +	return 1;
> +}
> +
>  /**
>   * vgic_its_save_collection_table - Save the collection table into
>   * guest RAM
>   */
>  static int vgic_its_save_collection_table(struct vgic_its *its)
>  {
> -	return -ENXIO;
> +	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
> +	struct its_collection *collection;
> +	u64 val;
> +	gpa_t gpa;
> +	size_t max_size, filled = 0;
> +	int ret, cte_esz = abi->cte_esz;
> +
> +	gpa = BASER_ADDRESS(its->baser_coll_table);
> +	if (!gpa)
> +		return 0;
> +
> +	max_size = GITS_BASER_NR_PAGES(its->baser_coll_table) * SZ_64K;
> +
> +	list_for_each_entry(collection, &its->collection_list, coll_list) {
> +		if (filled == max_size)
> +			return -ENOSPC;

should this ever happen?  Shouldn't we check limit in
vgic_its_cmd_handle_mapi() ?

We can fix that later, and it shouldn't block this patch, just asking
the question here because I'm noticing it.

> +		ret = vgic_its_save_cte(its, collection, gpa, cte_esz);
> +		if (ret)
> +			return ret;
> +		gpa += cte_esz;
> +		filled += cte_esz;
> +	}
> +
> +	if (filled == max_size)
> +		return 0;
> +
> +	/*
> +	 * table is not fully filled, add a last dummy element
> +	 * with valid bit unset
> +	 */
> +	val = 0;
> +	BUG_ON(cte_esz > sizeof(val));
> +	ret = kvm_write_guest(its->dev->kvm, gpa, &val, cte_esz);
> +	return ret;
>  }
>  
>  /**
> @@ -1820,7 +1898,27 @@ static int vgic_its_save_collection_table(struct vgic_its *its)
>   */
>  static int vgic_its_restore_collection_table(struct vgic_its *its)
>  {
> -	return -ENXIO;
> +	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
> +	int cte_esz = abi->cte_esz;
> +	size_t max_size, read = 0;
> +	gpa_t gpa;
> +	int ret;
> +
> +	if (!(its->baser_coll_table & GITS_BASER_VALID))
> +		return 0;
> +
> +	gpa = BASER_ADDRESS(its->baser_coll_table);
> +
> +	max_size = GITS_BASER_NR_PAGES(its->baser_coll_table) * SZ_64K;
> +
> +	while (read < max_size) {
> +		ret = vgic_its_restore_cte(its, gpa, cte_esz);
> +		if (ret <= 0)
> +			break;
> +		gpa += cte_esz;
> +		read += cte_esz;
> +	}
> +	return ret;
>  }
>  
>  /**
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index 309ab64..58adcae 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -73,6 +73,15 @@
>  				      KVM_REG_ARM_VGIC_SYSREG_CRM_MASK | \
>  				      KVM_REG_ARM_VGIC_SYSREG_OP2_MASK)
>  
> +/*
> + * As per Documentation/virtual/kvm/devices/arm-vgic-its.txt,
> + * below macros are defined for ITS table entry encoding.
> + */
> +#define KVM_ITS_CTE_VALID_SHIFT		63
> +#define KVM_ITS_CTE_VALID_MASK		BIT_ULL(63)
> +#define KVM_ITS_CTE_RDBASE_SHIFT	16
> +#define KVM_ITS_CTE_ICID_MASK		GENMASK_ULL(15, 0)
> +
>  static inline bool irq_is_pending(struct vgic_irq *irq)
>  {
>  	if (irq->config == VGIC_CONFIG_EDGE)
> -- 
> 2.5.5
> 

Reviewed-by: Christoffer Dall <cdall@linaro.org>

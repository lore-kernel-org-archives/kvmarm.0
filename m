From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v4 02/11] KVM: arm/arm64: vgic-its: fix
 vgic_its_restore_collection_table returned value
Date: Tue, 17 Oct 2017 23:54:16 +0200
Message-ID: <20171017215416.GB8326@lvm>
References: <1508224209-15366-1-git-send-email-eric.auger@redhat.com>
 <1508224209-15366-3-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1508224209-15366-3-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, peter.maydell@linaro.org, andre.przywara@arm.com, wanghaibin.wang@huawei.com, wu.wubin@huawei.com, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Oct 17, 2017 at 09:10:00AM +0200, Eric Auger wrote:
> vgic_its_restore_cte returns +1 if the collection table entry
> is valid and properly decoded. As a consequence, if the
> collection table is fully filled with valid data that are
> decoded without error, vgic_its_restore_collection_table()
> returns +1.  This is wrong.
> 
> Let's use the standard C convention for both vgic_its_restore_cte
> and vgic_its_restore_collection_table. vgic_its_restore_cte now
> returns whether we have reached the end of the table in the @last
> output parameter. vgic_its_restore_collection_table aborts in case
> of error or if the end is found. Otherwise, it now returns 0.
> 
> Fixes: ea1ad53e1e31a3 (KVM: arm64: vgic-its: Collection table save/restore)
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> 
> v2 -> v3: creation
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 40 +++++++++++++++++++++++++++++++---------
>  1 file changed, 31 insertions(+), 9 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index eea14a1..a4ff8f7 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -2204,7 +2204,19 @@ static int vgic_its_save_cte(struct vgic_its *its,
>  	return kvm_write_guest(its->dev->kvm, gpa, &val, esz);
>  }
>  
> -static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa, int esz)
> +/**
> + * vgic_its_restore_cte - Restore a collection table entry
> + *
> + * @its: its handle
> + * @gpa: guest physical address of the entry
> + * @esz: entry size
> + * @last: output boolean indicating whether we have reached the
> + *       end of the collection table (ie. an invalid entry was decoded)
> + *
> + * Return: 0 upon success, < 0 on error
> + */
> +static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa, int esz,
> +				bool *last)
>  {
>  	struct its_collection *collection;
>  	struct kvm *kvm = its->dev->kvm;
> @@ -2217,7 +2229,8 @@ static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa, int esz)
>  	if (ret)
>  		return ret;
>  	val = le64_to_cpu(val);
> -	if (!(val & KVM_ITS_CTE_VALID_MASK))
> +	*last = !(val & KVM_ITS_CTE_VALID_MASK);
> +	if (*last)
>  		return 0;
>  
>  	target_addr = (u32)(val >> KVM_ITS_CTE_RDBASE_SHIFT);
> @@ -2233,7 +2246,7 @@ static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa, int esz)
>  	if (ret)
>  		return ret;
>  	collection->target_addr = target_addr;
> -	return 1;
> +	return 0;
>  }
>  
>  /**
> @@ -2278,8 +2291,13 @@ static int vgic_its_save_collection_table(struct vgic_its *its)
>  
>  /**
>   * vgic_its_restore_collection_table - reads the collection table
> - * in guest memory and restores the ITS internal state. Requires the
> - * BASER registers to be restored before.
> + * in guest memory and restores the ITS collection cache.
> + *
> + * @its: its handle
> + *
> + * Requires the Collection BASER to be previously restored.
> + *
> + * Returns 0 on success or < 0 on error
>   */
>  static int vgic_its_restore_collection_table(struct vgic_its *its)
>  {
> @@ -2297,13 +2315,17 @@ static int vgic_its_restore_collection_table(struct vgic_its *its)
>  	max_size = GITS_BASER_NR_PAGES(its->baser_coll_table) * SZ_64K;
>  
>  	while (read < max_size) {
> -		ret = vgic_its_restore_cte(its, gpa, cte_esz);
> -		if (ret <= 0)
> -			break;
> +		bool last;
> +
> +		ret = vgic_its_restore_cte(its, gpa, cte_esz, &last);
> +		if (ret < 0 || last)
> +			return ret;
>  		gpa += cte_esz;
>  		read += cte_esz;
>  	}
> -	return ret;
> +
> +	/* table was fully filled with valid entries, decoded without error */
> +	return 0;
>  }
>  
>  /**
> -- 
> 2.5.5
> 

It's not that I find this looking particularly elegant, but I'm not sure
I have a better alternative, perhaps it's just the natur of the beast:

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

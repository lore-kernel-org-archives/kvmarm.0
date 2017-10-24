From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v5 01/10] KVM: arm/arm64: vgic-its: Fix return value for
 device table restore
Date: Tue, 24 Oct 2017 18:02:20 +0200
Message-ID: <20171024160220.GB91785@lvm>
References: <1508767709-15256-1-git-send-email-eric.auger@redhat.com>
 <1508767709-15256-2-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1508767709-15256-2-git-send-email-eric.auger@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, peter.maydell@linaro.org, andre.przywara@arm.com, wanghaibin.wang@huawei.com, wu.wubin@huawei.com, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Oct 23, 2017 at 04:08:20PM +0200, Eric Auger wrote:
> From: wanghaibin <wanghaibin.wang@huawei.com>
> 
> If ITT only contains invalid entries, vgic_its_restore_itt
> returns 1 and this is considered as an an error in
> vgic_its_restore_dte.
> 
> Also in case the device table only contains invalid entries,
> the table restore fails and this is not correct.
> 
> This patch fixes those 2 issues:
> - vgic_its_restore_itt now returns <= 0 values. If all
>   ITEs are invalid, this is considered as successful.
> - vgic_its_restore_device_tables also returns <= 0 values.
> 
> We also simplify the returned value computation in
> handle_l1_dte.
> 
> Signed-off-by: wanghaibin <wanghaibin.wang@huawei.com>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

> 
> ---
> 
> need to CC'ed stable
> 
> v2 -> v3:
> - add comments
> - vgic_its_restore_itt don't return +1 anymore
> - reword the commit message
> 
> v1 -> v2:
> - if (ret > 0) ret = 0
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 20 +++++++++++++++-----
>  1 file changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index f51c1e1..d27a301 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -1940,6 +1940,14 @@ static int vgic_its_save_itt(struct vgic_its *its, struct its_device *device)
>  	return 0;
>  }
>  
> +/**
> + * vgic_its_restore_itt - restore the ITT of a device
> + *
> + * @its: its handle
> + * @dev: device handle
> + *
> + * Return 0 on success, < 0 on error
> + */
>  static int vgic_its_restore_itt(struct vgic_its *its, struct its_device *dev)
>  {
>  	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
> @@ -1951,6 +1959,10 @@ static int vgic_its_restore_itt(struct vgic_its *its, struct its_device *dev)
>  	ret = scan_its_table(its, base, max_size, ite_esz, 0,
>  			     vgic_its_restore_ite, dev);
>  
> +	/* scan_its_table returns +1 if all ITEs are invalid */
> +	if (ret > 0)
> +		ret = 0;
> +
>  	return ret;
>  }
>  
> @@ -2107,10 +2119,7 @@ static int handle_l1_dte(struct vgic_its *its, u32 id, void *addr,
>  	ret = scan_its_table(its, gpa, SZ_64K, dte_esz,
>  			     l2_start_id, vgic_its_restore_dte, NULL);
>  
> -	if (ret <= 0)
> -		return ret;
> -
> -	return 1;
> +	return ret;
>  }
>  
>  /**
> @@ -2140,8 +2149,9 @@ static int vgic_its_restore_device_tables(struct vgic_its *its)
>  				     vgic_its_restore_dte, NULL);
>  	}
>  
> +	/* scan_its_table returns +1 if all entries are invalid */
>  	if (ret > 0)
> -		ret = -EINVAL;
> +		ret = 0;
>  
>  	return ret;
>  }
> -- 
> 2.5.5
> 

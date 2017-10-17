From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v4 04/11] KVM: arm/arm64: vgic-its: Check CBASER/BASER
 validity before enabling the ITS
Date: Wed, 18 Oct 2017 00:02:03 +0200
Message-ID: <20171017220203.GD8326@lvm>
References: <1508224209-15366-1-git-send-email-eric.auger@redhat.com>
 <1508224209-15366-5-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1508224209-15366-5-git-send-email-eric.auger@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, peter.maydell@linaro.org, andre.przywara@arm.com, wanghaibin.wang@huawei.com, wu.wubin@huawei.com, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Oct 17, 2017 at 09:10:02AM +0200, Eric Auger wrote:
> The spec says it is UNPREDICTABLE to enable the ITS
> if any of the following conditions are true:
> 
> - GITS_CBASER.Valid == 0.
> - GITS_BASER<n>.Valid == 0, for any GITS_BASER<n> register
>   where the Type field indicates Device.
> - GITS_BASER<n>.Valid == 0, for any GITS_BASER<n> register
>   where the Type field indicates Interrupt Collection and
>   GITS_TYPER.HCC == 0.
> 
> In that case, let's keep the ITS disabled.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Reported-by: Andre Przywara <andre.przywara@arm.com>
> 
> ---
> 
> v3: creation
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index e59363e..e61736b 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -1488,6 +1488,16 @@ static void vgic_mmio_write_its_ctlr(struct kvm *kvm, struct vgic_its *its,
>  	its->enabled = !!(val & GITS_CTLR_ENABLE);
>  
>  	/*
> +	 * It is UNPREDICTABLE to enable the ITS if any of the CBASER or
> +	 * device/collection BASER are invalid
> +	 */
> +	if (its->enabled &&
> +		(!(its->baser_device_table & GITS_BASER_VALID) ||
> +		 !(its->baser_coll_table & GITS_BASER_VALID) ||
> +		 !(its->cbaser && GITS_CBASER_VALID)))
> +		its->enabled = false;
> +

uh, why don't we check these conditions before we enable the ITS instead
of enabling, checking, and then disabling?


Thanks,
-Christoffer

> +	/*
>  	 * Try to process any pending commands. This function bails out early
>  	 * if the ITS is disabled or no commands have been queued.
>  	 */
> -- 
> 2.5.5
> 

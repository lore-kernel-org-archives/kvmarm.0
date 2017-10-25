From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v5 03/10] KVM: arm/arm64: vgic-its: Check CBASER/BASER
 validity before enabling the ITS
Date: Wed, 25 Oct 2017 13:52:22 +0200
Message-ID: <20171025115222.GG91785@lvm>
References: <1508767709-15256-1-git-send-email-eric.auger@redhat.com>
 <1508767709-15256-4-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1508767709-15256-4-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, peter.maydell@linaro.org, andre.przywara@arm.com, wanghaibin.wang@huawei.com, wu.wubin@huawei.com, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Oct 23, 2017 at 04:08:22PM +0200, Eric Auger wrote:
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

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

> 
> ---
> 
> need to be CC'ed stable
> 
> v4 -> v5:
> - check the condition before updating its->enabled and
>   fix its->cbaser && GITS_CBASER_VALID
> 
> v3: creation
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index b0ba80f..1eb355e 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -1466,6 +1466,16 @@ static void vgic_mmio_write_its_ctlr(struct kvm *kvm, struct vgic_its *its,
>  {
>  	mutex_lock(&its->cmd_lock);
>  
> +	/*
> +	 * It is UNPREDICTABLE to enable the ITS if any of the CBASER or
> +	 * device/collection BASER are invalid
> +	 */
> +	if (!its->enabled && (val & GITS_CTLR_ENABLE) &&
> +		(!(its->baser_device_table & GITS_BASER_VALID) ||
> +		 !(its->baser_coll_table & GITS_BASER_VALID) ||
> +		 !(its->cbaser & GITS_CBASER_VALID)))
> +		goto out;
> +
>  	its->enabled = !!(val & GITS_CTLR_ENABLE);
>  
>  	/*
> @@ -1474,6 +1484,7 @@ static void vgic_mmio_write_its_ctlr(struct kvm *kvm, struct vgic_its *its,
>  	 */
>  	vgic_its_process_commands(kvm, its);
>  
> +out:
>  	mutex_unlock(&its->cmd_lock);
>  }
>  
> -- 
> 2.5.5
> 

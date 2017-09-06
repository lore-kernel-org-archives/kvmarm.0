From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH] KVM: arm64: vgic-its: Fix wrong return value check in
 vgic_its_restore_device_tables
Date: Wed, 6 Sep 2017 09:22:41 +0200
Message-ID: <65a66715-4f22-07d4-879a-1181c8dad889@redhat.com>
References: <1504675565-13641-1-git-send-email-vkilari@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 34F1749C2A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Sep 2017 03:20:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id T4APpkabbZh5 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Sep 2017 03:20:20 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4F30440A86
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Sep 2017 03:20:20 -0400 (EDT)
In-Reply-To: <1504675565-13641-1-git-send-email-vkilari@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Vijaya Kumar K <vkilari@codeaurora.org>, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, cdall@linaro.org, andre.przywara@arm.com
Cc: vvenkat@codeaurora.org, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Vijaya,

On 06/09/2017 07:26, Vijaya Kumar K wrote:
> scan_its_table() return 1 on success.

As mentioned in the kernel-doc comment of scan_its_table, this latter
returns 1 if the last element is not found. Than can happen while
scanning an L2 table but shouldn't happen if we scan an L1 table.

 * Return: < 0 on error, 0 if last element was identified, 1 otherwise
 * (the last element may not be found on second level tables)


 In the function vgic_its_restore_device_tables()
> the return value of scan_its_table() is checked against success value
> and returns -EINVAL. Hence migration fails for VM with ITS.
> 
> With this patch the failure return value is checked while returning
> -EINVAL.
> 
> Signed-off-by: Vijaya Kumar K <vkilari@codeaurora.org>
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index aa6b68d..63f8ac3 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -2142,7 +2142,7 @@ static int vgic_its_restore_device_tables(struct vgic_its *its)
>  				     vgic_its_restore_dte, NULL);
>  	}
>  
> -	if (ret > 0)
> +	if (ret <= 0)
>  		ret = -EINVAL;
your modification would return -EINVAL for whatever error encountered
during the scan table or if last element is found. I don't think this is
what we want.

Thanks

Eric
>  
>  	return ret;
> 

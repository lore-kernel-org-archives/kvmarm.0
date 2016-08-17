From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] arm64: KVM: report configured SRE value to 32-bit world
Date: Wed, 17 Aug 2016 12:46:02 +0200
Message-ID: <20160817104602.GE8808@cbox>
References: <1470822583-9014-1-git-send-email-vladimir.murzin@arm.com>
 <1470822583-9014-2-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 261E841145
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Aug 2016 06:36:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PGpbgv80VLkO for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Aug 2016 06:36:34 -0400 (EDT)
Received: from mail-wm0-f47.google.com (mail-wm0-f47.google.com [74.125.82.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1CF74410B5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Aug 2016 06:36:34 -0400 (EDT)
Received: by mail-wm0-f47.google.com with SMTP id f65so189251013wmi.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Aug 2016 03:44:03 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1470822583-9014-2-git-send-email-vladimir.murzin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Aug 10, 2016 at 10:49:43AM +0100, Vladimir Murzin wrote:
> After commit b34f2bc ("arm64: KVM: Make ICC_SRE_EL1 access return the
> configured SRE value") we report SRE value to 64-bit guest, but 32-bit
> one still handled as RAZ/WI what leads to funny promise we do not keep:
> 
> "GICv3: GIC: unable to set SRE (disabled at EL2), panic ahead"
> 
> We could keep that promise and force panic, but it doesn't look
> reliable, instead report configured SRE value to 32-bit guest.

I don't really understand this part of the commit message?

Why would we force a panic, and at what time?

It is obviously correct to return the actual value that the guest should
see...

Thanks,
-Christoffer

> 
> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index b0b225c..0940bfc 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1360,7 +1360,7 @@ static const struct sys_reg_desc cp15_regs[] = {
>  	{ Op1( 0), CRn(10), CRm( 3), Op2( 1), access_vm_reg, NULL, c10_AMAIR1 },
>  
>  	/* ICC_SRE */
> -	{ Op1( 0), CRn(12), CRm(12), Op2( 5), trap_raz_wi },
> +	{ Op1( 0), CRn(12), CRm(12), Op2( 5), access_gic_sre },
>  
>  	{ Op1( 0), CRn(13), CRm( 0), Op2( 1), access_vm_reg, NULL, c13_CID },
>  
> -- 
> 2.0.0
> 

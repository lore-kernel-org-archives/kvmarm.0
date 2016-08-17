From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2] kvm: arm: Enforce some NS-SVC initialisation
Date: Wed, 17 Aug 2016 13:16:36 +0200
Message-ID: <20160817111636.GF8808@cbox>
References: <5322cdb9cb397741d15b60c6693ad39dbf74b6d5.1469101945.git.robin.murphy@arm.com>
 <6d030bee2db08c2fe1b7569e692e8f66800b1e4c.1471369569.git.robin.murphy@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A7BEF41145
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Aug 2016 07:07:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Di1xg9p46+vE for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Aug 2016 07:07:08 -0400 (EDT)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AE645410B5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Aug 2016 07:07:08 -0400 (EDT)
Received: by mail-wm0-f41.google.com with SMTP id o80so225383307wme.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Aug 2016 04:14:37 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <6d030bee2db08c2fe1b7569e692e8f66800b1e4c.1471369569.git.robin.murphy@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Robin Murphy <robin.murphy@arm.com>
Cc: marc.zyngier@arm.com, linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Aug 16, 2016 at 06:49:18PM +0100, Robin Murphy wrote:
> Since the non-secure copies of banked registers lack architecturally
> defined reset values, there is no actual guarantee when entering in Hyp
> from secure-only firmware that the Non-Secure PL1 state will look the
> way that kernel entry (in particular the decompressor stub) expects.
> So far, we've been getting away with it thanks to implementation details
> of ARMv7 cores and/or bootloader behaviour, but for the sake of forwards
> compatibility let's try to ensure that we have a minimally sane state
> before dropping down into it.
> 
> Signed-off-by: Robin Murphy <robin.murphy@arm.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

> ---
> 
> v2: Initialise SED/ITD to safe values as well.
> 
>  arch/arm/kernel/hyp-stub.S | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/arch/arm/kernel/hyp-stub.S b/arch/arm/kernel/hyp-stub.S
> index 0b1e4a93d67e..15d073ae5da2 100644
> --- a/arch/arm/kernel/hyp-stub.S
> +++ b/arch/arm/kernel/hyp-stub.S
> @@ -142,6 +142,19 @@ ARM_BE8(orr	r7, r7, #(1 << 25))     @ HSCTLR.EE
>  	and	r7, #0x1f		@ Preserve HPMN
>  	mcr	p15, 4, r7, c1, c1, 1	@ HDCR
>  
> +	@ Make sure NS-SVC is initialised appropriately
> +	mrc	p15, 0, r7, c1, c0, 0	@ SCTLR
> +	orr	r7, #(1 << 5)		@ CP15 barriers enabled
> +	bic	r7, #(3 << 7)		@ Clear SED/ITD for v8 (RES0 for v7)
> +	bic	r7, #(3 << 19)		@ WXN and UWXN disabled
> +	mcr	p15, 0, r7, c1, c0, 0	@ SCTLR
> +
> +	mrc	p15, 0, r7, c0, c0, 0	@ MIDR
> +	mcr	p15, 4, r7, c0, c0, 0	@ VPIDR
> +
> +	mrc	p15, 0, r7, c0, c0, 5	@ MPIDR
> +	mcr	p15, 4, r7, c0, c0, 5	@ VMPIDR
> +
>  #if !defined(ZIMAGE) && defined(CONFIG_ARM_ARCH_TIMER)
>  	@ make CNTP_* and CNTPCT accessible from PL1
>  	mrc	p15, 0, r7, c0, c1, 1	@ ID_PFR1
> -- 
> 2.8.1.dirty
> 

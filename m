From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 07/10] ARM: Introduce MPIDR_LEVEL_SHIFT macro
Date: Tue, 13 Sep 2016 10:38:55 +0200
Message-ID: <20160913083855.GC5680@cbox>
References: <1473691764-29424-1-git-send-email-vladimir.murzin@arm.com>
 <1473691764-29424-8-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4275D49B5A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2016 04:27:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iAvpQiBcGabR for <kvmarm@lists.cs.columbia.edu>;
 Tue, 13 Sep 2016 04:27:35 -0400 (EDT)
Received: from mail-wm0-f51.google.com (mail-wm0-f51.google.com [74.125.82.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EB5F849B58
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2016 04:27:34 -0400 (EDT)
Received: by mail-wm0-f51.google.com with SMTP id i130so19158092wmf.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2016 01:36:18 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1473691764-29424-8-git-send-email-vladimir.murzin@arm.com>
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
Cc: marc.zyngier@arm.com, andre.przywara@arm.com, Russell King <rmk+kernel@armlinux.org.uk>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Sep 12, 2016 at 03:49:21PM +0100, Vladimir Murzin wrote:
> vgic-v3 driver uses architecture specific MPIDR_LEVEL_SHIFT macro to
> encode the affinity in a form compatible with ICC_SGI* registers.
> Unfortunately, that macro is missing on ARM, so let's add it.
> 
> Cc: Russell King <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
> ---
>  arch/arm/include/asm/cputype.h |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/include/asm/cputype.h b/arch/arm/include/asm/cputype.h
> index 1ee94c7..e2d94c1 100644
> --- a/arch/arm/include/asm/cputype.h
> +++ b/arch/arm/include/asm/cputype.h
> @@ -55,6 +55,7 @@
>  
>  #define MPIDR_LEVEL_BITS 8
>  #define MPIDR_LEVEL_MASK ((1 << MPIDR_LEVEL_BITS) - 1)
> +#define MPIDR_LEVEL_SHIFT(level) (MPIDR_LEVEL_BITS * level)
>  

I'm not sure I follow the correctness of this completely.

This is called from vgic_v3_dispatch_sgi, which takes a u64 value, which
may have something in the Aff3 field, which we now shift left 24 bits,
but that is not the Aff3 field of AArch32's MPIDR.

What is the rationale for this making sense again?

Thanks,
-Christoffer

>  #define MPIDR_AFFINITY_LEVEL(mpidr, level) \
>  	((mpidr >> (MPIDR_LEVEL_BITS * level)) & MPIDR_LEVEL_MASK)
> -- 
> 1.7.9.5
> 

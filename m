From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 10/15] arm64: kvm: Fix {V}TCR_EL2_TG0 mask
Date: Thu, 8 Oct 2015 17:17:46 +0200
Message-ID: <20151008151746.GE20936@cbox>
References: <1442331684-28818-1-git-send-email-suzuki.poulose@arm.com>
 <1442331684-28818-11-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6405B41457
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Oct 2015 11:15:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bQ95QeWW21BQ for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Oct 2015 11:15:33 -0400 (EDT)
Received: from mail-lb0-f174.google.com (mail-lb0-f174.google.com
 [209.85.217.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2D0EE412F3
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Oct 2015 11:15:32 -0400 (EDT)
Received: by lbwr8 with SMTP id r8so50443098lbw.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Oct 2015 08:17:31 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1442331684-28818-11-git-send-email-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "Suzuki K. Poulose" <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, ard.biesheuvel@linaro.org, Marc.Zyngier@arm.com, Catalin.Marinas@arm.com, Will.Deacon@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Sep 15, 2015 at 04:41:19PM +0100, Suzuki K. Poulose wrote:
> From: "Suzuki K. Poulose" <suzuki.poulose@arm.com>
> 
> {V}TCR_EL2_TG0 is a 2bit wide field, where:
> 
>  00 - 4K
>  01 - 64K
>  10 - 16K
> 
> But we use only 1 bit, which has worked well so far since
> we never cared about 16K. Fix it for 16K support.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <christoffer.dall@linaro.org>
> Cc: kvmarm@lists.cs.columbia.edu
> Acked-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Suzuki K. Poulose <suzuki.poulose@arm.com>
> ---
>  arch/arm64/include/asm/kvm_arm.h |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index 7605e09..bdf139e 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -98,7 +98,7 @@
>  #define TCR_EL2_TBI	(1 << 20)
>  #define TCR_EL2_PS	(7 << 16)
>  #define TCR_EL2_PS_40B	(2 << 16)
> -#define TCR_EL2_TG0	(1 << 14)
> +#define TCR_EL2_TG0	(3 << 14)
>  #define TCR_EL2_SH0	(3 << 12)
>  #define TCR_EL2_ORGN0	(3 << 10)
>  #define TCR_EL2_IRGN0	(3 << 8)
> @@ -110,7 +110,7 @@
>  
>  /* VTCR_EL2 Registers bits */
>  #define VTCR_EL2_PS_MASK	(7 << 16)
> -#define VTCR_EL2_TG0_MASK	(1 << 14)
> +#define VTCR_EL2_TG0_MASK	(3 << 14)
>  #define VTCR_EL2_TG0_4K		(0 << 14)
>  #define VTCR_EL2_TG0_64K	(1 << 14)
>  #define VTCR_EL2_SH0_MASK	(3 << 12)
> -- 
> 1.7.9.5
> 

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 17/19] arm64: KVM: Dynamically compute the HYP VA mask
Date: Thu, 18 Jan 2018 21:28:16 +0100
Message-ID: <20180118202816.GE21802@cbox>
References: <20180104184334.16571-1-marc.zyngier@arm.com>
 <20180104184334.16571-18-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B342249E0E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jan 2018 15:23:11 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tBZFsIyTQ3T2 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Jan 2018 15:23:11 -0500 (EST)
Received: from mail-wm0-f66.google.com (mail-wm0-f66.google.com [74.125.82.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D9F9149DBE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jan 2018 15:23:10 -0500 (EST)
Received: by mail-wm0-f66.google.com with SMTP id g1so24328529wmg.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jan 2018 12:28:18 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20180104184334.16571-18-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jan 04, 2018 at 06:43:32PM +0000, Marc Zyngier wrote:
> As we're moving towards a much more dynamic way to compute our
> HYP VA, let's express the mask in a slightly different way.
> 
> Instead of comparing the idmap position to the "low" VA mask,
> we directly compute the mask by taking into account the idmap's
> (VA_BIT-1) bit.
> 
> No functionnal change.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kvm/va_layout.c | 17 ++++++-----------
>  1 file changed, 6 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm64/kvm/va_layout.c b/arch/arm64/kvm/va_layout.c
> index aee758574e61..75bb1c6772b0 100644
> --- a/arch/arm64/kvm/va_layout.c
> +++ b/arch/arm64/kvm/va_layout.c
> @@ -21,24 +21,19 @@
>  #include <asm/insn.h>
>  #include <asm/kvm_mmu.h>
>  
> -#define HYP_PAGE_OFFSET_HIGH_MASK	((UL(1) << VA_BITS) - 1)
> -#define HYP_PAGE_OFFSET_LOW_MASK	((UL(1) << (VA_BITS - 1)) - 1)
> -
>  static u64 va_mask;
>  
>  static void compute_layout(void)
>  {
>  	phys_addr_t idmap_addr = __pa_symbol(__hyp_idmap_text_start);
> -	unsigned long mask = HYP_PAGE_OFFSET_HIGH_MASK;
> +	u64 region;

the naming here really confused me.  Would it make sense to call this
'hyp_va_msb' or something like that instead?

>  
> -	/*
> -	 * Activate the lower HYP offset only if the idmap doesn't
> -	 * clash with it,
> -	 */
> -	if (idmap_addr > HYP_PAGE_OFFSET_LOW_MASK)
> -		mask = HYP_PAGE_OFFSET_HIGH_MASK;

Ah, the series was tested, it was just that this code only existed for a
short while.  Amusingly, I think this ephemeral bug goes against the "No
function change" statement in the commit message.

> +	/* Where is my RAM region? */
> +	region  = idmap_addr & BIT(VA_BITS - 1);
> +	region ^= BIT(VA_BITS - 1);
>  
> -	va_mask = mask;
> +	va_mask  = BIT(VA_BITS - 1) - 1;

nit: This could also be written as GENMASK_ULL(VA_BITS - 2, 0) --- and
now I'm not sure which one I prefer.

> +	va_mask |= region;
>  }
>  
>  static u32 compute_instruction(int n, u32 rd, u32 rn)
> -- 
> 2.14.2
> 
Otherwise looks good:

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

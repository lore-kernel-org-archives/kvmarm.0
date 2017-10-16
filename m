From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 04/10] arm64: KVM: PTE/PMD S2 XN bit definition
Date: Mon, 16 Oct 2017 22:07:57 +0200
Message-ID: <20171016200757.GG1845@lvm>
References: <20171009152032.27804-1-marc.zyngier@arm.com>
 <20171009152032.27804-5-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171009152032.27804-5-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Oct 09, 2017 at 04:20:26PM +0100, Marc Zyngier wrote:
> As we're about to make S2 page-tables eXecute Never by default,
> add the required bits for both PMDs and PTEs.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

> ---
>  arch/arm64/include/asm/pgtable-hwdef.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
> index eb0c2bd90de9..af035331fb09 100644
> --- a/arch/arm64/include/asm/pgtable-hwdef.h
> +++ b/arch/arm64/include/asm/pgtable-hwdef.h
> @@ -177,9 +177,11 @@
>   */
>  #define PTE_S2_RDONLY		(_AT(pteval_t, 1) << 6)   /* HAP[2:1] */
>  #define PTE_S2_RDWR		(_AT(pteval_t, 3) << 6)   /* HAP[2:1] */
> +#define PTE_S2_XN		(_AT(pteval_t, 2) << 53)  /* XN[1:0] */
>  
>  #define PMD_S2_RDONLY		(_AT(pmdval_t, 1) << 6)   /* HAP[2:1] */
>  #define PMD_S2_RDWR		(_AT(pmdval_t, 3) << 6)   /* HAP[2:1] */
> +#define PMD_S2_XN		(_AT(pmdval_t, 2) << 53)  /* XN[1:0] */
>  
>  /*
>   * Memory Attribute override for Stage-2 (MemAttr[3:0])
> -- 
> 2.14.1
> 

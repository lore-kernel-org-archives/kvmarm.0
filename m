From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 04/17] arm64: Introduce pmd_thp_or_huge
Date: Fri, 8 Apr 2016 14:43:53 +0200
Message-ID: <20160408124353.GO8961@cbox>
References: <1459787177-12767-1-git-send-email-suzuki.poulose@arm.com>
 <1459787177-12767-5-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C57FB40F9B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2016 08:42:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nkguWLuWcx2H for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Apr 2016 08:42:14 -0400 (EDT)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F22ED4053F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2016 08:42:13 -0400 (EDT)
Received: by mail-wm0-f54.google.com with SMTP id f198so63086861wme.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Apr 2016 05:43:40 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1459787177-12767-5-git-send-email-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Apr 04, 2016 at 05:26:04PM +0100, Suzuki K Poulose wrote:
> Add a helper to determine if a given pmd represents a huge page
> either by hugetlb or thp, as we have for arm. This will be used
> by KVM MMU code.
> 
> Suggested-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Steve Capper <steve.capper@linaro.org>
> Cc: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>

> ---
>  arch/arm64/include/asm/pgtable.h |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 989fef1..dda4aa9 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -290,6 +290,8 @@ static inline pgprot_t mk_sect_prot(pgprot_t prot)
>  #define pmd_mkyoung(pmd)	pte_pmd(pte_mkyoung(pmd_pte(pmd)))
>  #define pmd_mknotpresent(pmd)	(__pmd(pmd_val(pmd) & ~PMD_TYPE_MASK))
>  
> +#define pmd_thp_or_huge(pmd)	(pmd_huge(pmd) || pmd_trans_huge(pmd))
> +
>  #define __HAVE_ARCH_PMD_WRITE
>  #define pmd_write(pmd)		pte_write(pmd_pte(pmd))
>  
> -- 
> 1.7.9.5
> 

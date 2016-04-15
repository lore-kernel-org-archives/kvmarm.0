From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2 04/17] arm64: Introduce pmd_thp_or_huge
Date: Fri, 15 Apr 2016 16:17:04 +0100
Message-ID: <20160415151703.GP22906@arm.com>
References: <1460640065-27658-1-git-send-email-suzuki.poulose@arm.com>
 <1460640065-27658-5-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E165849BE2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2016 11:15:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HE1roV6xG50H for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Apr 2016 11:15:19 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2861A49BE0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2016 11:15:19 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1460640065-27658-5-git-send-email-suzuki.poulose@arm.com>
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
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Apr 14, 2016 at 02:20:52PM +0100, Suzuki K Poulose wrote:
> Add a helper to determine if a given pmd represents a huge page
> either by hugetlb or thp, as we have for arm. This will be used
> by KVM MMU code.
> 
> Suggested-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Steve Capper <steve.capper@linaro.org>
> Cc: Will Deacon <will.deacon@arm.com>
> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
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

Acked-by: Will Deacon <will.deacon@arm.com>

Will

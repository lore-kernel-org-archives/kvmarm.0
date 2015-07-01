From: Steve Capper <steve.capper@linaro.org>
Subject: Re: [PATCH] arm64: Don't report clear pmds and puds as huge
Date: Wed, 1 Jul 2015 13:24:34 +0100
Message-ID: <CAPvkgC3qJEca1cL8DSuz5=7_xnmyKO2AQ0g+XyF+D-KmYNs9=A@mail.gmail.com>
References: <1435752511-7079-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1435752511-7079-1-git-send-email-christoffer.dall@linaro.org>
Sender: stable-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Alexander Graf <agraf@suse.de>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, =?UTF-8?B?RGlyayBNw7xsbGVy?= <dirk@dmllr.de>, stable@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 1 July 2015 at 13:08, Christoffer Dall <christoffer.dall@linaro.org> wrote:
> The current pmd_huge() and pud_huge() functions simply check if the table
> bit is not set and reports the entries as huge in that case.  This is
> counter-intuitive as a clear pmd/pud cannot also be a huge pmd/pud, and
> it is inconsistent with at least arm and x86.
>
> To prevent others from making the same mistake as me in looking at code
> that calls these functions and to fix an issue with KVM on arm64 that
> causes memory corruption due to incorrect page reference counting
> resulting from this mistake, let's change the behavior.
>
> Cc: stable@vger.kernel.org

Thanks Christoffer.

It may be worth adding:

Fixes: 084bd29810a5 ("ARM64: mm: HugeTLB support.")

And, please feel free to add:

Reviewed-by: Steve Capper <steve.capper@linaro.org>

> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  arch/arm64/mm/hugetlbpage.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
> index 2de9d2e..0eeb4f09 100644
> --- a/arch/arm64/mm/hugetlbpage.c
> +++ b/arch/arm64/mm/hugetlbpage.c
> @@ -40,13 +40,13 @@ int huge_pmd_unshare(struct mm_struct *mm, unsigned long *addr, pte_t *ptep)
>
>  int pmd_huge(pmd_t pmd)
>  {
> -       return !(pmd_val(pmd) & PMD_TABLE_BIT);
> +       return pmd_val(pmd) && !(pmd_val(pmd) & PMD_TABLE_BIT);
>  }
>
>  int pud_huge(pud_t pud)
>  {
>  #ifndef __PAGETABLE_PMD_FOLDED
> -       return !(pud_val(pud) & PUD_TABLE_BIT);
> +       return pud_val(pud) && !(pud_val(pud) & PUD_TABLE_BIT);
>  #else
>         return 0;
>  #endif
> --
> 2.1.2.330.g565301e.dirty
>

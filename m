From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v2] KVM: arm64: Clarify explanation of
 STAGE2_PGTABLE_LEVELS
Date: Tue, 6 Nov 2018 12:39:34 +0000
Message-ID: <44340035-ed11-bbd1-cc42-5df19b6a8246@arm.com>
References: <20181106123338.3786-1-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 71C9B4A322
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Nov 2018 07:39:38 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rRtitbJ-cuji for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Nov 2018 07:39:37 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A3784A31B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Nov 2018 07:39:37 -0500 (EST)
In-Reply-To: <20181106123338.3786-1-christoffer.dall@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu



On 06/11/2018 12:33, Christoffer Dall wrote:
> In attempting to re-construct the logic for our stage 2 page table
> layout I found the reaoning in the comment explaining how we calculate

nit: reasoning

> the number of levels used for stage 2 page tables a bit backwards.
> 
> This commit attempts to clarify the comment, to make it slightly easier
> to read without having the Arm ARM open on the right page.
> 
> While we're at it, fixup a typo in a comment that was recently changed.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> ---
> Changes since v1:
>   - Dropped note about (PAGE_SHIFT - 3) > 4
> 
>   arch/arm64/include/asm/stage2_pgtable.h | 14 ++++++--------
>   virt/kvm/arm/mmu.c                      |  2 +-
>   2 files changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/stage2_pgtable.h b/arch/arm64/include/asm/stage2_pgtable.h
> index d352f6df8d2c..72ecf8ac3668 100644
> --- a/arch/arm64/include/asm/stage2_pgtable.h
> +++ b/arch/arm64/include/asm/stage2_pgtable.h
> @@ -31,15 +31,13 @@
>   
>   /*
>    * The hardware supports concatenation of up to 16 tables at stage2 entry level
> - * and we use the feature whenever possible.
> + * and we use the feature whenever possible, which means we resolve 4 bits of

4 additional bits

> + * address at the entry level.
>    *
> - * Now, the minimum number of bits resolved at any level is (PAGE_SHIFT - 3).
> - * On arm64, the smallest PAGE_SIZE supported is 4k, which means
> - *             (PAGE_SHIFT - 3) > 4 holds for all page sizes.
> - * This implies, the total number of page table levels at stage2 expected
> - * by the hardware is actually the number of levels required for (IPA_SHIFT - 4)
> - * in normal translations(e.g, stage1), since we cannot have another level in
> - * the range (IPA_SHIFT, IPA_SHIFT - 4).
> + * This implies, the total number of page table levels required for
> + * IPA_SHIFT at stage2 expected by the hardware can be calculated using
> + * the same logic used for the (non-collapsable) stage1 page tables but for
> + * (IPA_SHIFT - 4).

Thanks for cleaning up the mess. With the above changes :

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>

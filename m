From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 2/2] KVM: arm/arm64: harden unmap_stage2_ptes in case
 end is not PAGE_SIZE aligned
Date: Fri, 18 May 2018 10:48:31 +0100
Message-ID: <2185a61e-c157-e177-9bad-83b6f27fd784@arm.com>
References: <1526635630-18917-1-git-send-email-hejianet@gmail.com>
 <1526635630-18917-2-git-send-email-hejianet@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 90B454A0CB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 May 2018 05:38:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Pva23Q8PSB8s for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 May 2018 05:38:09 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA438402AA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 May 2018 05:38:09 -0400 (EDT)
In-Reply-To: <1526635630-18917-2-git-send-email-hejianet@gmail.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Jia He <hejianet@gmail.com>, Christoffer Dall <christoffer.dall@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: jia.he@hxt-semitech.com, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 18/05/18 10:27, Jia He wrote:
> If it passes addr=0x202920000,size=0xfe00 to unmap_stage2_range->
> ...->unmap_stage2_ptes, unmap_stage2_ptes will get addr=0x202920000,
> end=0x20292fe00. After first while loop addr=0x202930000, end=0x20292fe00,
> then addr!=end. Thus it will touch another pages by put_pages() in the
> 2nd loop.
> 
> This patch fixes it by hardening the break condition of while loop.
> 
> Signed-off-by: jia.he@hxt-semitech.com
> ---
> v2: newly added
> 
>  virt/kvm/arm/mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index 8dac311..45cd040 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -217,7 +217,7 @@ static void unmap_stage2_ptes(struct kvm *kvm, pmd_t *pmd,
>  
>  			put_page(virt_to_page(pte));
>  		}
> -	} while (pte++, addr += PAGE_SIZE, addr != end);
> +	} while (pte++, addr += PAGE_SIZE, addr < end);
>  
>  	if (stage2_pte_table_empty(start_pte))
>  		clear_stage2_pmd_entry(kvm, pmd, start_addr);
> 

I don't think this change is the right thing to do. You get that failure
because you're being passed a size that is not a multiple of PAGE_SIZE.
That's the mistake.

You should ensure that this never happens, rather than changing the page
table walkers (which are consistent with the way this kind of code is
written in other places of the kernel). As you mentioned in your first
patch, the real issue is that KSM is broken, and this is what should be
fixed.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...

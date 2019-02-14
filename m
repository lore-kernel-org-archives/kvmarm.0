From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH V2 3/10] KVM/MMU: Add last_level in the struct
 mmu_spte_page
Date: Thu, 14 Feb 2019 17:32:17 +0100
Message-ID: <572a6ce3-23f6-7b16-a070-4d4a81ee4335@redhat.com>
References: <20190202013825.51261-1-Tianyu.Lan@microsoft.com>
 <20190202013825.51261-4-Tianyu.Lan@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B4A704A0CC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Feb 2019 11:32:40 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NlDvg8OX0dnI for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Feb 2019 11:32:40 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E5A2449E3E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Feb 2019 11:32:39 -0500 (EST)
In-Reply-To: <20190202013825.51261-4-Tianyu.Lan@microsoft.com>
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
To: lantianyu1986@gmail.com
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, paulus@ozlabs.org, hpa@zytor.com, kys@microsoft.com, kvmarm@lists.cs.columbia.edu, mpe@ellerman.id.au, x86@kernel.org, linux@armlinux.org.uk, michael.h.kelley@microsoft.com, mingo@redhat.com, benh@kernel.crashing.org, jhogan@kernel.org, linux-mips@vger.kernel.org, Lan Tianyu <Tianyu.Lan@microsoft.com>, marc.zyngier@arm.com, kvm-ppc@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, ralf@linux-mips.org, paul.burton@mips.com, vkuznets@redhat.com, linuxppc-dev@lists.ozlabs.org
List-Id: kvmarm@lists.cs.columbia.edu

On 02/02/19 02:38, lantianyu1986@gmail.com wrote:
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index ce770b446238..70cafd3f95ab 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -2918,6 +2918,9 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>  
>  	if (level > PT_PAGE_TABLE_LEVEL)
>  		spte |= PT_PAGE_SIZE_MASK;
> +
> +	sp->last_level = is_last_spte(spte, level);

Wait, I wasn't thinking straight.  If a struct kvm_mmu_page exists, it
is never the last level.  Page table entries for the last level do not
have a struct kvm_mmu_page.

Therefore you don't need the flag after all.  I suspect your
calculations in patch 2 are off by one, and you actually need

	hlist_for_each_entry(sp, range->flush_list, flush_link) {
		int pages = KVM_PAGES_PER_HPAGE(sp->role.level + 1);
		...
	}

For example, if sp->role.level is 1 then the struct kvm_mmu_page is for
a page containing PTEs and covers an area of 2 MiB.

Thanks,

Paolo

>  	if (tdp_enabled)
>  		spte |= kvm_x86_ops->get_mt_mask(vcpu, gfn,
>  			kvm_is_mmio_pfn(pfn));

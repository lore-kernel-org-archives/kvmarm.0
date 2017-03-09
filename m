From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v5 09/10] arm64/mmu: replace 'page_mappings_only'
 parameter with flags argument
Date: Thu, 9 Mar 2017 18:19:53 +0000
Message-ID: <20170309181953.GF11966@leverpostej>
References: <1489047912-642-1-git-send-email-ard.biesheuvel@linaro.org>
 <1489047912-642-10-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 37E5240A7B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Mar 2017 13:18:43 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7zgHLwtFKQgD for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Mar 2017 13:18:41 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ADF4C40625
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Mar 2017 13:18:41 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1489047912-642-10-git-send-email-ard.biesheuvel@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: keescook@chromium.org, kernel-hardening@lists.openwall.com, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, labbott@fedoraproject.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Mar 09, 2017 at 09:25:11AM +0100, Ard Biesheuvel wrote:
> In preparation of extending the policy for manipulating kernel mappings
> with whether or not contiguous hints may be used in the page tables,
> replace the bool 'page_mappings_only' with a flags field and a flag
> NO_BLOCK_MAPPINGS.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Thanks for attacking this.

I was going to comment on the name change, but I see that the next patch
introduces and uses NO_CONT_MAPPINGS, so that's fine by me.

>  void __init create_pgd_mapping(struct mm_struct *mm, phys_addr_t phys,
>  			       unsigned long virt, phys_addr_t size,
>  			       pgprot_t prot, bool page_mappings_only)
>  {
> +	int flags;
> +
>  	BUG_ON(mm == &init_mm);
>  
> +	if (page_mappings_only)
> +		flags = NO_BLOCK_MAPPINGS;

> +
>  	__create_pgd_mapping(mm->pgd, phys, virt, size, prot,
> -			     pgd_pgtable_alloc, page_mappings_only);
> +			     pgd_pgtable_alloc, flags);
>  }

Given we can't pass the flags in to create_pgd_mapping() without
exposing those more generally, this also looks fine.

FWIW:

Reviewed-by: Mark Rutland <mark.rutland@arm.com>

Mark.

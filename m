From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH] kvmtool: ARM: madvise mergeable and hugepage separately
Date: Mon, 8 Aug 2016 17:11:55 +0100
Message-ID: <37ee2136-f382-497b-41f4-c8b2aab73529@arm.com>
References: <20160808070144.17712-1-stefan@agner.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160808070144.17712-1-stefan@agner.ch>
Sender: kvm-owner@vger.kernel.org
To: Stefan Agner <stefan@agner.ch>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Marc.Zyngier@arm.com, penberg@kernel.org, will.deacon@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 08/08/16 08:01, Stefan Agner wrote:
> The madvise behavior is not a bit field and hence can not be or'ed.
> Also madvise_behavior_valid checks the flag using a case statement
> hence only one behavior is supposed to be supplied. Call madvise
> twice, once for MERGEABLE and once for HUGEPAGE.

thanks for that catch! Indeed we are only setting HUGEPAGE right now,
dropping MERGEABLE due to the OR'ing.

Acked-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre.

> 
> Signed-off-by: Stefan Agner <stefan@agner.ch>
> ---
>  arm/kvm.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arm/kvm.c b/arm/kvm.c
> index ce40897..3cfa90a 100644
> --- a/arm/kvm.c
> +++ b/arm/kvm.c
> @@ -80,7 +80,10 @@ void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64 ram_size)
>  					SZ_2M);
>  
>  	madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
> -		MADV_MERGEABLE | MADV_HUGEPAGE);
> +		MADV_MERGEABLE);
> +
> +	madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
> +		MADV_HUGEPAGE);
>  
>  	/* Create the virtual GIC. */
>  	if (gic__create(kvm, kvm->cfg.arch.irqchip))
> 

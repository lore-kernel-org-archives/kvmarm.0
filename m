From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH] kvmtool: ARM: madvise mergeable and hugepage separately
Date: Thu, 25 Aug 2016 12:01:25 +0100
Message-ID: <17255e99-4f5e-1875-a7b8-b44cdc6ace26@arm.com>
References: <20160808070144.17712-1-stefan@agner.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 94E3D40F77
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2016 06:53:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Det7O-pxNLR8 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Aug 2016 06:53:38 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D50840C9A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2016 06:53:37 -0400 (EDT)
In-Reply-To: <20160808070144.17712-1-stefan@agner.ch>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Stefan Agner <stefan@agner.ch>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Marc.Zyngier@arm.com, penberg@kernel.org, will.deacon@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On 08/08/16 08:01, Stefan Agner wrote:
> The madvise behavior is not a bit field and hence can not be or'ed.
> Also madvise_behavior_valid checks the flag using a case statement
> hence only one behavior is supposed to be supplied. Call madvise
> twice, once for MERGEABLE and once for HUGEPAGE.
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

Should we also do a MADV_DONTDUMP for guest RAM pages ? This is a security option
to strip off any guest data in case of crash in kvmtool. This could also help
to reduce the size of the kvmtool core dumps. I think Qemu does this already.

Suzuki

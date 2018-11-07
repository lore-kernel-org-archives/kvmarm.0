From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 5/7] arm64: Do not apply BP hardening for hyp entries
 from EL2
Date: Wed, 7 Nov 2018 21:59:20 +0000
Message-ID: <20181107215918.GG12248@brain-police>
References: <1537970184-44348-1-git-send-email-julien.thierry@arm.com>
 <1537970184-44348-6-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E437F4A34A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Nov 2018 16:59:23 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id doPnrKIwOj4n for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Nov 2018 16:59:22 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA4FC4A349
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Nov 2018 16:59:22 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1537970184-44348-6-git-send-email-julien.thierry@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Julien Thierry <julien.thierry@arm.com>
Cc: marc.zyngier@arm.com, catalin.marinas@arm.com, kvmarm@lists.cs.columbia.edu, Dave.Martin@arm.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Sep 26, 2018 at 02:56:22PM +0100, Julien Thierry wrote:
> When an EL2 entry of __kvm_hyp_vector is taken, it means an entry from a
> lower EL was previously taken to exit the guest. Taking that lower EL entry
> already applied BP hardening if it was needed, so there is no need to do
> it again.
> 
> Only apply BP hardening for exception coming from lower EL.
> 
> Signed-off-by: Julien Thierry <julien.thierry@arm.com>
> Cc: kvmarm@lists.cs.columbia.edu
> ---
>  arch/arm64/kernel/cpu_errata.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
> index dec1089..9db5ecc 100644
> --- a/arch/arm64/kernel/cpu_errata.c
> +++ b/arch/arm64/kernel/cpu_errata.c
> @@ -103,10 +103,16 @@ static void __copy_hyp_vect_bpi(int slot, const char *hyp_vecs_start,
>  	void *dst = lm_alias(__bp_harden_hyp_vecs_start + slot * SZ_2K);
>  	int i;
> 
> -	for (i = 0; i < SZ_2K; i += 0x80)
> +	/*
> +	 * Only overwrite hyp entries for exceptions from lower EL.
> +	 * Exception vection vector is 2K bytes, first 1K bytes concern
> +	 * exception from EL2 (EL2t, EL2h), last 1K concert lower exception
> +	 * levels (ELx-64bits, ELx-32bits).
> +	 */
> +	for (i = SZ_1K; i < SZ_2K; i += 0x80)
>  		memcpy(dst + i, hyp_vecs_start, hyp_vecs_end - hyp_vecs_start);
> 
> -	__flush_icache_range((uintptr_t)dst, (uintptr_t)dst + SZ_2K);
> +	__flush_icache_range((uintptr_t)dst + SZ_1K, (uintptr_t)dst + SZ_2K);
>  }

I'd personally find this clearer if you did:

	dst += SZ_1K;

before the for loop and with your comment above it. Then the for loop
becomes:

	for (i = 0; i < SZ_1K; i += 0x80)

and the range of the cache maintenance is [dst, dst + SZ_1K)

But I'll leave it up to Marc.

Will

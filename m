Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A28263DD
	for <kvmarm@lists.linux.dev>; Mon, 17 Apr 2023 11:40:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07054C433D2;
	Mon, 17 Apr 2023 11:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1681731632;
	bh=mIQHO7+k2jNUk1GJ9SsvgtdCa75k5x9GzXYwLhevS84=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SaZPU+wcSR498p/rcRkowFB0g4mwA8v9D9xL7q4zMnb2eGdVDE1SXaXHR7NLSWc7k
	 es2Xi0xQBS9VfbZmh7YF0UEAMriaoIrFHncxdPVwiloEfd7sWTAO8jw3G3B73zTaNy
	 UexbJKlbedrSAAplAaHzQW93NHeTQXtIEjNzBFpWOBcUfR+8Nnz06q6+FKDRFmTiJ8
	 mduRdP1wrdcJ5BG0FTxxeysNaSssmKt/BrAYMS/SNsRxY8OIu2SFlfNcFsMHxQD9of
	 A5Jld4lvFvdXqaBhI6l2j+1SNiqRZ5iWuqELnnQRcGaCO9H5KYymhMKFUzRXEix494
	 fAbF0eXye95Zg==
Date: Mon, 17 Apr 2023 12:40:26 +0100
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>,
	Mostafa Saleh <smostafa@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Make vcpu flag updates non-preemptible
Message-ID: <20230417114025.GA30826@willie-the-truck>
References: <20230417093629.1440039-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230417093629.1440039-1-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Apr 17, 2023 at 10:36:29AM +0100, Marc Zyngier wrote:
> Per-vcpu flags are updated using a non-atomic RMW operation.
> Which means it is possible to get preempted between the read and
> write operations.
> 
> Another interesting thing to note is that preemption also updates
> flags, as we have some flag manipulation in both the load and put
> operations.
> 
> It is thus possible to lose information communicated by either
> load or put, as the preempted flag update will overwrite the flags
> when the thread is resumed. This is specially critical if either
> load or put has stored information which depends on the physical
> CPU the vcpu runs on.
> 
> This results in really elusive bugs, and kudos must be given to
> Mostafa for the long hours of debugging, and finally spotting
> the problem.
> 
> Fixes: e87abb73e594 ("KVM: arm64: Add helpers to manipulate vcpu flags among a set")
> Reported-by: Mostafa Saleh <smostafa@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: stable@vger.kernel.org
> ---
>  arch/arm64/include/asm/kvm_host.h | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index bcd774d74f34..d716cfd806e8 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -579,6 +579,19 @@ struct kvm_vcpu_arch {
>  		v->arch.flagset & (m);				\
>  	})
>  
> +/*
> + * Note that the set/clear accessors must be preempt-safe in order to
> + * avoid nesting them with load/put which also manipulate flags...
> + */
> +#ifdef __KVM_NVHE_HYPERVISOR__
> +/* the nVHE hypervisor is always non-preemptible */
> +#define __vcpu_flags_preempt_disable()
> +#define __vcpu_flags_preempt_enable()
> +#else
> +#define __vcpu_flags_preempt_disable()	preempt_disable()
> +#define __vcpu_flags_preempt_enable()	preempt_enable()
> +#endif

If it makes things cleaner, we could define local (empty) copies of these
preempt_*() macros at EL2 to save you having to wrap them here. Up to you.

>  #define __vcpu_set_flag(v, flagset, f, m)			\
>  	do {							\
>  		typeof(v->arch.flagset) *fset;			\
> @@ -586,9 +599,11 @@ struct kvm_vcpu_arch {
>  		__build_check_flag(v, flagset, f, m);		\
>  								\
>  		fset = &v->arch.flagset;			\
> +		__vcpu_flags_preempt_disable();			\
>  		if (HWEIGHT(m) > 1)				\
>  			*fset &= ~(m);				\
>  		*fset |= (f);					\
> +		__vcpu_flags_preempt_enable();			\
>  	} while (0)
>  
>  #define __vcpu_clear_flag(v, flagset, f, m)			\
> @@ -598,7 +613,9 @@ struct kvm_vcpu_arch {
>  		__build_check_flag(v, flagset, f, m);		\
>  								\
>  		fset = &v->arch.flagset;			\
> +		__vcpu_flags_preempt_disable();			\
>  		*fset &= ~(m);					\
> +		__vcpu_flags_preempt_enable();			\
>  	} while (0)
>  
>  #define vcpu_get_flag(v, ...)	__vcpu_get_flag((v), __VA_ARGS__)

Given that __vcpu_get_flag() is still preemptible, we should probably
add a READ_ONCE() in there when we access the relevant flags field. In
practice, they're all single-byte fields so it should be ok, but I think
the READ_ONCE() is still worthwhile.

Will

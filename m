Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE3DE2C11D5
	for <kvmarm@lists.linux.dev>; Thu, 22 Jan 2026 15:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769094211; cv=none; b=ASLiFRzsteAw0tD4R7C8Sy3DZUUuIWh3qKFT3oKwuOCVtArr/CLfzIxSCY8DpjWOJ+4zMGgzGB6mu7PqRtTmJvi0Fg5wR+nY7M6/+sANu/fPJRcRvDi3gKbjPwjADLReykw5slg7frYno7PDk9QA5d/NuryFFdxpdh2yZ4xmqoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769094211; c=relaxed/simple;
	bh=W7OL1DzXiTNMqnoJ2zpzUEZ753uxhw9UxvzRwjFtEyc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bszUY4ovvxsP/8aaVE2bNRbGINcWVyVgjPYVDQY4NNbGizYVshCw5LB0zxDbgg1qQLW3tFTZ75oplreFyeCCf9j/R9ez2lKeYE1b9qfYxdR/J+/4OH3OC0b/qtF5H21reTpfGPYLb6eKmJ46CmcmZPknvoBrWYhuAX+mgxo0jeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JSCY3zfM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JSCY3zfM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8546CC116C6;
	Thu, 22 Jan 2026 15:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769094211;
	bh=W7OL1DzXiTNMqnoJ2zpzUEZ753uxhw9UxvzRwjFtEyc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JSCY3zfMOG2pyN9chEr5QNrJet6vWraeb0GFj+2Gc2JMh9b4hWS1+dH5uZ4p7MAhk
	 upJmDaKq1bG8Zb+8Ty/Q6C0SUSOF5KlTmb6rjCcPv/l6AHESoh8YLCL+LjBT2fvZpu
	 ezEEshS82H3rIKcv2ZCpBcrsikiohMyrjOM4SgDJPeyflNGP128ChDjGV4E47catyY
	 gFD7Axsn+wCPMvC79Y4+W4ZBnOlQkQk75Vzgw44Jh2Ms4LbkijT+nPTe4xXxkLTaZi
	 Sya/Z3gch/vT+UyA7cHvGszxfsp2x9f+b+SKtnBRvhJrLyixLHBajT+CiQ2kCuiUqC
	 U2mHZaJDY1mbQ==
Date: Thu, 22 Jan 2026 15:03:26 +0000
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH 6/6] KVM: arm64: Simplify PAGE_S2_MEMATTR
Message-ID: <aXI8PqEi0tnn6RP6@willie-the-truck>
References: <20260119105651.255693-1-maz@kernel.org>
 <20260119105651.255693-7-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260119105651.255693-7-maz@kernel.org>

On Mon, Jan 19, 2026 at 10:56:51AM +0000, Marc Zyngier wrote:
> Restore PAGE_S2_MEMATTR() to its former glory, keeping the use of
> FWB as an implementation detail.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/pgtable-prot.h | 4 ++--
>  arch/arm64/kvm/hyp/pgtable.c          | 6 ++----
>  2 files changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable-prot.h b/arch/arm64/include/asm/pgtable-prot.h
> index 161e8660edddc..d27e8872fe3c8 100644
> --- a/arch/arm64/include/asm/pgtable-prot.h
> +++ b/arch/arm64/include/asm/pgtable-prot.h
> @@ -109,10 +109,10 @@ static inline bool __pure lpa2_is_enabled(void)
>  #define PAGE_KERNEL_EXEC	__pgprot(_PAGE_KERNEL_EXEC)
>  #define PAGE_KERNEL_EXEC_CONT	__pgprot(_PAGE_KERNEL_EXEC_CONT)
>  
> -#define PAGE_S2_MEMATTR(attr, has_fwb)					\
> +#define PAGE_S2_MEMATTR(attr)						\
>  	({								\
>  		u64 __val;						\
> -		if (has_fwb)						\
> +		if (cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))		\
>  			__val = PTE_S2_MEMATTR(MT_S2_FWB_ ## attr);	\
>  		else							\
>  			__val = PTE_S2_MEMATTR(MT_S2_ ## attr);		\
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 3c2f7967fdc03..34c9afa442932 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -660,11 +660,9 @@ void kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
>  	({								\
>  		kvm_pte_t __attr;					\
>  		if((pgt)->flags & KVM_PGTABLE_S2_AS_S1)			\
> -			__attr = PAGE_S2_MEMATTR(AS_S1,			\
> -						 stage2_has_fwb());	\
> +			__attr = PAGE_S2_MEMATTR(AS_S1);		\
>  		else							\
> -			__attr = PAGE_S2_MEMATTR(attr,			\
> -						 stage2_has_fwb());	\
> +			__attr = PAGE_S2_MEMATTR(attr);			\
>  									\


tbh, I'd probably just kill stage2_has_fwb() entirely and use the cap
everywhere...

Up to you.

Will

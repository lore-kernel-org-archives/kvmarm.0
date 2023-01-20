Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2E517E6
	for <kvmarm@lists.linux.dev>; Fri, 20 Jan 2023 10:14:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E184EC433D2;
	Fri, 20 Jan 2023 10:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1674209661;
	bh=8coKsEGNOLVnML+qzF/cIjseg/P2bFDNfepu0vc5CHc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jtc/Lu/Am8c4uVLCAKluT/KlboKnPU98ZUzaj4diA4eURXvZlRnakfAQjwEhUyv9N
	 xxxUi/2bQzrIn9y37fhMtOvNTo4g2QiQy+Bq7Kc4k5OY+C+isMgYIJFOfH5DnfdSBz
	 pFlGxHbfvpTPeTbYI2LQHNybWeIQhN1v0mUNYdIrZYQyxzYu7ZR4tGP1PFuM3U2/St
	 4BQd1WnxJIsTZldWfhkY7NQ3bgyAHOwdBYNZYgANuMNYtzcWPX8toc0xOUs5l+pfet
	 KQdG+TS49OeCDrmep/qNFw9ojv4C9jmRd4edEP8KYRN9wNiRJtSNA+yQFvA7H4+2MH
	 bth0iY00R8QIg==
Date: Fri, 20 Jan 2023 10:14:16 +0000
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 1/2] KVM: arm64: Disable KVM on systems with a VPIPT
 i-cache
Message-ID: <20230120101415.GA21784@willie-the-truck>
References: <20230113172523.2063867-1-maz@kernel.org>
 <20230113172523.2063867-2-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113172523.2063867-2-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri, Jan 13, 2023 at 05:25:22PM +0000, Marc Zyngier wrote:
> Systems with a VMID-tagged PIPT i-cache have been supported for
> a while by Linux and KVM. However, these systems never appeared
> on our side of the multiverse.
> 
> Refuse to initialise KVM on such a machine, should then ever appear.
> Following changes will drop the support from the hypervisor.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/arm.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 9c5573bc4614..508deed213a2 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -2195,6 +2195,11 @@ int kvm_arch_init(void *opaque)
>  	int err;
>  	bool in_hyp_mode;
>  
> +	if (icache_is_vpipt()) {
> +		kvm_info("Incompatible VPIPT I-Cache policy\n");
> +		return -ENODEV;
> +	}

Hmm, does this work properly with late CPU onlining? For example, if my set
of boot CPUs are all friendly PIPT and KVM initialises happily, but then I
late online a CPU with a horrible VPIPT policy, I worry that we'll quietly
do the wrong thing wrt maintenance.

If that's the case, then arguably we already have a bug in the cases where
we trap and emulate accesses to CTR_EL0 from userspace because I _think_
we'll change the L1Ip field at runtime after userspace could've already read
it.

Is there something that stops us from ended up in this situation?

Will

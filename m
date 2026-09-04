Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656F348124D;
	Fri,  4 Sep 2026 12:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788524206; cv=none; b=n5PtUP4a8XCnOe2TRigZz/LA+TwNnY2F+gopuGgk6mTxiJ+L6PuJHTX+1Mp3SfVYR+NGeiAR9A2Q8P1J6TzHHZOJfsG3HbotNsQze1rJP6ZjDTPMW4SOSGl8AOD3BWaYBvTWRK1ZHRGv0IMSio0245sZ8joJji6NqzJA5YWgS8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788524206; c=relaxed/simple;
	bh=Jey8dTHOMZL8lhnLz/EEl3ZPEZ/I9uIeImx25dVzMjE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m1E2NiiF+xnqDkVkF2Tmc039+k1a51AQr3ul6VzbhEzK3sIDNeyn+Ooybsu/fHA7+2aqCeoVZWoPWVXiy38WhvbRhJ4mfIk0M7GgGhmwTr2MKB1znutHG08/rksuv80JFCtisf8UAIWC2frNKdv7Edpqiaylsf+RMdDZNbkuJnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mu+FEdit; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mu+FEdit"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED0B61F00A3E;
	Fri,  4 Sep 2026 12:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788524205;
	bh=CVzSSbg8XaitZU0IkO8eE2sTOp/ww7mlfLdDvjSnX2s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mu+FEditeFfFWeBQsjsOVdiyitKk6CkH6ibVFyfuaecAV4bM4QIW02DQV3LDNYkdB
	 DYqIG+n415agvw+nw4fukOIh+OkXSoGaug+j4bw25BpQigNpuS7Pp7C6xKlEUMbIEE
	 x6IsSYwP7vu6jDRi0CmIJhPs2xbLuhPXQeH+2dKjzpeogLjmJQkZtaq8HiSn5O4qdY
	 hk2TTGga7vCGp050/nBj7gqyFsjBrW1RyMzCye7S1p5KCzXDEqpo8sZP9jUgAk68Oi
	 rSPum/esWrV6+bQQ4qq0Kd7NB9fSh8LKdchZlUF4iP4hMzQIxxv9J4J/c5Is3a2tQv
	 ZBovheJJhygbQ==
Date: Fri, 4 Sep 2026 13:16:38 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Peter Maydell <peter.maydell@linaro.org>, 
	Leonardo Bras <leo.bras@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>, 
	Yao Yuan <yaoyuan@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v20 04/14] KVM: arm64: Ensure GCS memory effects are
 visible
Message-ID: <apqyNz7cKC8thMfN@gremlin>
References: <20260901-arm64-gcs-v20-0-f31750bdfadb@kernel.org>
 <20260901-arm64-gcs-v20-4-f31750bdfadb@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901-arm64-gcs-v20-4-f31750bdfadb@kernel.org>

On Tue, Sep 01, 2026 at 10:47:02PM +0100, Mark Brown wrote:
> In order to allow efficient implementation of GCS implementations are
> permitted to do GCS specific caching, with barriers implicit in stack
> switch operations and GCSB DSYNC as an explicit barrier.  Since we do
> not use GCS in the hypervisor or host kernel the hypervisor cannot rely
> on any barriers being present in vCPU context switches other than those
> it explicitly inserts.  Add explicit barriers when loading and saving
> vCPU state.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>
> ---
>  arch/arm64/kvm/arm.c               | 7 +++++++
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 7 +++++++
>  2 files changed, 14 insertions(+)
>
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 8b080804bc90..52f53f682e6a 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -755,6 +755,13 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)

So this seems to be where -> vCPU unscheduled so the right place to do it.

>  			vcpu_set_flag(vcpu, PKVM_HOST_STATE_DIRTY);
>  	}
>
> +	/*
> +	 * Ensure any GCS memory effects from the outgoing vCPU are
> +	 * visible elsewhere.
> +	 */
> +	if (kvm_has_gcs(vcpu->kvm))
> +		gcsb_dsync();

Makes sense.

I did notice the curious:

static inline void gcsb_dsync(void)
{
	asm volatile(".inst 0xd503227f" : : : "memory");
}

And various sludging around suggests this is HINT #19 and guaranteed to be a nop
on arches that don't implement the feature :)

> +
>  	kvm_vcpu_put_debug(vcpu);
>  	kvm_arch_vcpu_put_fp(vcpu);
>  	if (has_vhe())
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index 9a3b92e626ad..534db037c5f6 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -261,6 +261,13 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)

And here similar for pKVM.

>  	fpsimd_sve_sync(&hyp_vcpu->vcpu);
>  	sync_debug_state(hyp_vcpu);
>
> +	/*
> +	 * Ensure any GCS memory effects from the outgoing vCPU are
> +	 * visible elsewhere even if the host skips syncing.
> +	 */
> +	if (kvm_has_gcs(hyp_vcpu->vcpu.kvm))
> +		gcsb_dsync();
> +
>  	if (pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
>  		host_vcpu->arch.ctxt = hyp_vcpu->vcpu.arch.ctxt;
>  	} else {
>
> --
> 2.47.3
>
>

--
Cheers, Lorenzo

Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 897E767A1B
	for <kvmarm@lists.linux.dev>; Tue, 20 Feb 2024 11:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708430293; cv=none; b=CaPFG1CdSArZqxdOGcteeUCl4sCI1ChFrBVoquTWSR0YrSeb3gfH7gqmuIEuM0jqBnoXdkTyRwdu4/PTFfv5KmWCPbR+M6Vi8l/rNvyCTjyygQJx3wa6IWZ6VBZqObKjqd3bn+yyXojVsJkvEklMljvUhfx3vPegMmbV5C9sRKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708430293; c=relaxed/simple;
	bh=DoSyF9oBMF7hKFHPTOjGEgAD/7Q3cAcgAGoQkG7Ph7Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gK25AiaFw2vm8D6/HyCTp3vgmylJ/jRy4VgA0sh2gELJgXvEpTmIA7F/6V43f+SRC7mvItPJvTAvB3TEsTmraHBKMRqz+Ut+rNeCgICCbSnxN1BmqoIK4cnLl18kuC6MGP5xbVz/rCoeU2X93iSVG2++JAClv7MnOiKS+jHJZTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0A717FEC;
	Tue, 20 Feb 2024 03:58:49 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9E9513F762;
	Tue, 20 Feb 2024 03:58:08 -0800 (PST)
Date: Tue, 20 Feb 2024 11:58:06 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 03/13] KVM: arm64: nv: Drop VCPU_HYP_CONTEXT flag
Message-ID: <20240220115806.GC16168@e124191.cambridge.arm.com>
References: <20240219092014.783809-1-maz@kernel.org>
 <20240219092014.783809-4-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240219092014.783809-4-maz@kernel.org>

On Mon, Feb 19, 2024 at 09:20:04AM +0000, Marc Zyngier wrote:
> It has become obvious that HCR_EL2.NV serves the exact same use
> as VCPU_HYP_CONTEXT, only in an architectural way. So just drop
> the flag for good.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h | 2 --
>  arch/arm64/kvm/hyp/vhe/switch.c   | 7 +------
>  2 files changed, 1 insertion(+), 8 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index a5ec4c7d3966..75eb8e170515 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -816,8 +816,6 @@ struct kvm_vcpu_arch {
>  #define DEBUG_STATE_SAVE_SPE	__vcpu_single_flag(iflags, BIT(5))
>  /* Save TRBE context if active  */
>  #define DEBUG_STATE_SAVE_TRBE	__vcpu_single_flag(iflags, BIT(6))
> -/* vcpu running in HYP context */
> -#define VCPU_HYP_CONTEXT	__vcpu_single_flag(iflags, BIT(7))
>  
>  /* SVE enabled for host EL0 */
>  #define HOST_SVE_ENABLED	__vcpu_single_flag(sflags, BIT(0))
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index 1581df6aec87..58415783fd53 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -197,7 +197,7 @@ static void early_exit_filter(struct kvm_vcpu *vcpu, u64 *exit_code)
>  	 * If we were in HYP context on entry, adjust the PSTATE view
>  	 * so that the usual helpers work correctly.
>  	 */
> -	if (unlikely(vcpu_get_flag(vcpu, VCPU_HYP_CONTEXT))) {
> +	if (unlikely(read_sysreg(hcr_el2) & HCR_NV)) {
>  		u64 mode = *vcpu_cpsr(vcpu) & (PSR_MODE_MASK | PSR_MODE32_BIT);
>  
>  		switch (mode) {
> @@ -240,11 +240,6 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
>  	sysreg_restore_guest_state_vhe(guest_ctxt);
>  	__debug_switch_to_guest(vcpu);
>  
> -	if (is_hyp_ctxt(vcpu))
> -		vcpu_set_flag(vcpu, VCPU_HYP_CONTEXT);
> -	else
> -		vcpu_clear_flag(vcpu, VCPU_HYP_CONTEXT);
> -
>  	do {
>  		/* Jump in the fire! */
>  		exit_code = __guest_enter(vcpu);

Makes sense to me.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

Thanks,
Joey

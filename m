Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AE90244667
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 13:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779282148; cv=none; b=OGujtHvAUew8r6UzWP30ittJurAcAgpKTHd6COcj3TZFgD0iC4XqmJBi8ftB2e5hdcuJrKVokVI9qltlT/W9npx2T5AfkvZa2gTwIjpJuQeZoRMaHRheJExS2zyWxsikTTstvX7NmFHFFtKiVpw7db2LX1UVGHKHn/CtBX9fZZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779282148; c=relaxed/simple;
	bh=EouBC0yqkVKdLRVBmbSVOwjS0lsH3zO5YOwcji/96BI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sq5pzGfm+FE404GdN3FtzYUywFiNQsFIF5LQ8itK+KRj9lCMc6VkUp9U/xYcZNKF0fNOY16knyp44y4OWq22E7C3c/82uMT1R8PcaP5TZ6LeLSWcRJbTuakziJcnxPKXthN1/y9jCGLL7jPLm+mY9hBDCfzpgPJyVNNb+v7Bd3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=SOF+eZMX; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="SOF+eZMX"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 62A691516;
	Wed, 20 May 2026 06:02:20 -0700 (PDT)
Received: from J2N7QTR9R3.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5E18A3F85F;
	Wed, 20 May 2026 06:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779282145; bh=EouBC0yqkVKdLRVBmbSVOwjS0lsH3zO5YOwcji/96BI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SOF+eZMXF24B1OFynsRWIEETVfZ0f67BmjjkvJRHBGxpQrmojbkVsqClEWUipTkch
	 t+BKe5MqCoHhbo6wv2ohysbnGpMe3aZPxCwR4fRh5SAzhvyWgo9pbK19+xcNFQhHcC
	 X2zZhkc2C4d7z7D27aVI2NQ5p/qsqU/0+vWT3u/4=
Date: Wed, 20 May 2026 14:02:08 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v2 2/2] KVM: arm64: nv: Don't save/restore FP register
 during a nested ERET or exception
Message-ID: <ag2w0G34NycT2456@J2N7QTR9R3.cambridge.arm.com>
References: <20260520085036.541666-1-maz@kernel.org>
 <20260520085036.541666-3-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520085036.541666-3-maz@kernel.org>

On Wed, May 20, 2026 at 09:50:36AM +0100, Marc Zyngier wrote:
> When switching between L1 and L2, we save the old state using
> kvm_arch_vcpu_put(), mutate the state in memory, then load the new
> state using kvm_arch_vcpu_load(). Any live FPSIMD/SVE state is saved
> and unbound, such that it can be lazily restored on a subsequent trap.
> 
> The FPSIMD/SVE state is shared by exception levels, and only a handful
> of related control registers need to be changed when transitioning
> between L1 and L2. The save/restore of the common state is needless
> overhead, especially as trapping becomes exponentially more expensive
> with nesting.
> 
> Avoid this overhead by leaving the common FPSIMD/SVE state live on the
> CPU, and only switching the state that is distinct for L1 and L2:
> 
> - the trap controls: the effective values are recomputed on each entry
>   into the guest to take the EL into account and merge the L0 and L1
>   configuration if in a nested context, or directly use the L0 configuration
>   in non-nested context (see __activate_traps()).
> 
> - the VL settings: the effective values are are also recomputed on each
>   entry into the guest (see fpsimd_lazy_switch_to_guest()).
>
> Since we appear to cover all bases, use the vcpu flags indicating the
> handling of a nested ERET or exception delivery to avoid the whole FP
> save/restore shenanigans. SME will have to be similarly dealt with when
> it eventually gets supported.
> 
> For an EL1 L3 guest where L1 and L2 have this optimisation, this
> results in at least a 10% wall clock reduction when running an I/O
> heavy workload, generating a high rate of nested exceptions.

There's on additional thing that's important, but I forgot to mention
last time: in the window between kvm_arch_vcpu_put() and
kvm_arch_vcpu_load(), it's possible to take an interrupt, and for a
softirq handler to try to use kernel mode NEON.

Due to that, kvm_arch_vcpu_put() must leave the L1 guest's maximum VL
configured in the host's ZCR_ELx, such that the guest's state can be
saved.

That value is configured by fpsimd_lazy_switch_to_host(), so we just
need to make sure that kvm_arch_vcpu_put() doesn't clobber it. I *think*
that's fine today, but maybe that warrants a comment somewhere.

Other than that, this all looks good to me:

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/fpsimd.c | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
> 
> diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
> index 15e17aca1dec0..aca98752a6e42 100644
> --- a/arch/arm64/kvm/fpsimd.c
> +++ b/arch/arm64/kvm/fpsimd.c
> @@ -28,6 +28,20 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
>  	if (!system_supports_fpsimd())
>  		return;
>  
> +	/*
> +	 * Avoid needless save/restore of the guest's common
> +	 * FPSIMD/SVE/SME regs during transitions between L1/L2.
> +	 *
> +	 * These transitions only happens in a non-preemptible context
> +	 * where the host regs have already been saved and unbound. The
> +	 * live registers are either free or owned by the guest.
> +	 */
> +	if (vcpu_get_flag(vcpu, IN_NESTED_ERET) ||
> +	    vcpu_get_flag(vcpu, IN_NESTED_EXCEPTION)) {
> +		WARN_ON_ONCE(host_owns_fp_regs());
> +		return;
> +	}
> +
>  	/*
>  	 * Ensure that any host FPSIMD/SVE/SME state is saved and unbound such
>  	 * that the host kernel is responsible for restoring this state upon
> @@ -102,6 +116,15 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
>  {
>  	unsigned long flags;
>  
> +	/*
> +	 * See comment in kvm_arch_vcpu_load_fp().
> +	 */
> +	if (vcpu_get_flag(vcpu, IN_NESTED_ERET) ||
> +	    vcpu_get_flag(vcpu, IN_NESTED_EXCEPTION)) {
> +		WARN_ON_ONCE(host_owns_fp_regs());
> +		return;
> +	}
> +
>  	local_irq_save(flags);
>  
>  	if (guest_owns_fp_regs()) {
> -- 
> 2.47.3
> 

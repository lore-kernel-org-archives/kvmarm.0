Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13A5B3BB110
	for <kvmarm@lists.linux.dev>; Wed, 13 May 2026 12:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778675346; cv=none; b=AQ+xUhyg5KT+NejO11kAhL0LaykIfMVpzBMF0NadmKLcC6br2u4Hjuqfpwyz6CBlUS4Z18CG7+Kw6bbGDjUBD40bp7Tk8ehgr53yhp+54l7E8MdGcXmyB7mQLKKGpihhsMG7wjaZ2PV/TqTYJwNLwffCl7QhN3DHSqNuAp/czNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778675346; c=relaxed/simple;
	bh=8MAloSmMAMMd4l/G/g/2yUICqF0/LT/W/Bue6X2uJOo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hsALK4Cv4wZnSgJ78euo/Az6ZEcNNYfrz1Qy2iLePoEdmLLs0BkKTTtnSduew/F9DxRvBtzIX6PfcmgAPYGWLs5arRdwAOi9EmslrziHuWTOk3pwbgrCuRkKh5Fo70vT/V7Q0CSdAw6tpFr51e6nR7mBMKf2x54bLpEWdVmmh9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=tOxuLBMW; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="tOxuLBMW"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 466EF165C;
	Wed, 13 May 2026 05:28:59 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 13EC63F7B4;
	Wed, 13 May 2026 05:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778675344; bh=8MAloSmMAMMd4l/G/g/2yUICqF0/LT/W/Bue6X2uJOo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tOxuLBMWjuVKvUJwvt6sg+sZg7VuI/aVrYvZYaRm2ztF/5yBmwIjwwPc4VEbn5Dbj
	 FHE1xGMqksAu4sLf3v102nT1j/sWILjF11x/y6CCqYOd2LYl0ET9yghwCD0qJGJ6A9
	 cXS5ZM3SzTGUcjIMhlnKP31YKmdCXqI7/d2ceOrQ=
Date: Wed, 13 May 2026 13:28:56 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH 2/2] KVM: arm64: nv: Don't save/restore FP register
 during a nested ERET or exception
Message-ID: <agRuiKHWWn_88YzT@J2N7QTR9R3>
References: <20260512140755.3676306-1-maz@kernel.org>
 <20260512140755.3676306-3-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512140755.3676306-3-maz@kernel.org>

On Tue, May 12, 2026 at 03:07:55PM +0100, Marc Zyngier wrote:
> When switching between L1 and L2, we diligently use a non-preemptible
> put/load sequence in order to make sure that the old state is saved,
> while the new state is brought in. Crucially, this includes the FP
> registers.
> 
> However, this is a bit silly. The FP registers are completely shared
> between the various ELs (just like the GPRs, really), and eagerly
> save/restoring those in a non-preemptible section is just overhead.
> Not to mention that the next access will end-up trapping, something
> that becomes exponentially expensive as we nest deeper.
> 
> The temptation is therefore to completely drop this save/restore thing.
> Why is it valid to do so? By analogy, the hypervisor doesn't try to
> poloce things between EL1 and EL0, or between EL2 and EL0. Why should
> it do so between EL2 and EL1 (or EL2 and L2 EL0)?
>
> Once you admit that the FP (and by extension SVE) registers are EL-agnostic,
> the things that matter are:

s/poloce/police/ ?

The above is a bit flowery; it would be nice to remove the rhetorical
questions and just state that (aside from some control registers) the
FPSIMD/SVE/SME state is shared between exception levels and doesn't need
to be saved/restored.

How about:

  When switching between L1 and L2, we save the old state using
  kvm_arch_vcpu_put(), mutate the state in memory, then load the new
  state using kvm_arch_vcpu_load(). Any live FPSIMD/SVE state is saved
  and unbound, such that it can be lazily restored on a subsequent trap.

  The FPSIMD/SVE state is shared by exception levels, and only a handful
  of related control registers need to be changed when transitioning
  between L1 and L2. The save/restore of the common state is needless
  overhead, especially as trapping becomes exponentially more expensive
  with nesting.

  Avoid this overhead by leaving the common FPSIMD/SVE state live on the
  CPU, and only switching the state that is distinct for L1 and L2:
 
> - the trap controls: the effective values are recomputed on each entry
>   into the guest to take the EL into account and merge the L0 and L1
>   configuration if in a nested context, or directly use the L0 configuration
>   in non-nested context (see __activate_traps()).
> 
> - the VL settings: the effective values are are also recomputed on each
>   entry into the guest (see fpsimd_lazy_switch_to_guest()).

This is true for FPSIMD+SVE today. For SME, SMCR_ELx also contains other
controls, and will need to be dealt with similarly. It might be worth
noting that (and that ZCR_ELx could gain new controls in future).

> Since we appear to cover all bases, use the vcpu flags indicating the
> handling of a nested ERET or exception delivery to avoid the whole FP
> save/restore shenanigans.
> 
> For an EL1 L3 guest where L1 and L2 have this optimisation, this
> results in at least a 10% wall clock reduction when running an I/O
> heavy workload, generating a high rate of nested exceptions.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/fpsimd.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
> index 15e17aca1dec0..73eda0f46b127 100644
> --- a/arch/arm64/kvm/fpsimd.c
> +++ b/arch/arm64/kvm/fpsimd.c
> @@ -28,6 +28,10 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
>  	if (!system_supports_fpsimd())
>  		return;
>  
> +	if (vcpu_get_flag(vcpu, IN_NESTED_ERET) ||
> +	    vcpu_get_flag(vcpu, IN_NESTED_EXCEPTION))
> +		return;
> +

I think we need a comment as to why this is safe, with some other detail
from the commit message. It would also be good to have asserts here to
catch if something goes wrong.

How about:

	/*
	 * Avoid needless save/restore of the guest's common
	 * FPSIMD/SVE/SME regs during transitions between L1/L2.
	 *
	 * These transitions only happens in a non-preemptible context
	 * where the host regs have already been saved and unbound. The
	 * live registers are either free or owned by the guest.
	 */
	if (vcpu_get_flag(vcpu, IN_NESTED_ERET) ||
	    vcpu_get_flag(vcpu, IN_NESTED_EXCEPTION) {
		WARN_ON_ONCE(host_owns_fp_regs());
		return;
	}

... ?

Note: I didn't add WARN_ON_ONCE(preemptible()), since
kvm_arch_vcpu_load_fp() should *never* be called in a preemptible
context.

>  	/*
>  	 * Ensure that any host FPSIMD/SVE/SME state is saved and unbound such
>  	 * that the host kernel is responsible for restoring this state upon
> @@ -102,6 +106,10 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
>  {
>  	unsigned long flags;
>  
> +	if (vcpu_get_flag(vcpu, IN_NESTED_ERET) ||
> +	    vcpu_get_flag(vcpu, IN_NESTED_EXCEPTION))
> +		return;

Likewise here, but we can reduce the comment, e.g.

	/*
	 * See comment in kvm_arch_vcpu_load_fp().
	 */
	if (vcpu_get_flag(vcpu, IN_NESTED_ERET) ||
	    vcpu_get_flag(vcpu, IN_NESTED_EXCEPTION) {
		WARN_ON_ONCE(host_owns_fp_regs());
		return;
	}

Thanks,
Mark.

> +
>  	local_irq_save(flags);
>  
>  	if (guest_owns_fp_regs()) {
> -- 
> 2.47.3
> 

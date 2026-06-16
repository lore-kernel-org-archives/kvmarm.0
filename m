Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB68C38237F
	for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 20:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781640881; cv=none; b=eM8g7wHutRqLyt+a++HKvgYQRzz6O2ld2cYDvjB6t1R89m6VhXhJRs5lMMDV9wl7moTxIk7jpa+yut4DfDTeCdrHv/rvQm1aUfuzNBwz1kch2A0hAohIu0iMEqS8ppGy0P+cqlzgVB8H0Sy3JaBYmJqHEfNaafQmA8X0XuHNcKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781640881; c=relaxed/simple;
	bh=tMcKLV7BgsDO/NkKWZwDkPQjSBOii3S37wSmv1ze9Dk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qOonmkw5eYPgUis/SYh9AX5NM9OhhoH/aqtmlM7I2+kIoxWnVoQno3bI38qJgRvl7MVvwfKCxQb3FmslTlPYA41ABsMykfZ5d/0A+J3YgyHlrUTysGUNSF68AvicB/iQkZXon4rsbyeVPGbdhkJejGT9W2kgQ71ro0/eblTADbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QiYGCEuT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QiYGCEuT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6044B1F000E9;
	Tue, 16 Jun 2026 20:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781640880;
	bh=mX65hj6pHJKi5UZV5lw/UMIZ0zXM54bmOLByN+V/vGs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QiYGCEuTZ/ct0jFJNuBbo5YeJwkX0i3J2Rj1OFr54KSD85o8iFZ6avC0An/qnKWXW
	 p7bS61sBaEzlSOw0ZS3VmR2ao0iNIQt3SErQxjE8sBf9Tj2GlXMhEUyoOl9ACCSmBC
	 CIbdHIDMvZ0W4ejSakSn2uG9lMyQoX63Z16Uh4ZfHNAKDgtWA1GGszKEyd/ZefhOQ9
	 EQy9dZil82utpIkQoGZ06OZ2QJfdCbIajeDjO9+VzpSAyEKclk+jbb9oOhsfSUHtuP
	 aLbsDP5W7TQcSxTKGByZFqo32tj2BlM2txKR5PAt6k5KK632bf4sucoSBc87TgPD5V
	 OMBsJ1WpoVMJg==
Date: Tue, 16 Jun 2026 13:14:39 -0700
From: Oliver Upton <oupton@kernel.org>
To: Weiming Shi <bestswngs@gmail.com>
Cc: Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Kristina Martsenko <kristina.martsenko@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Zhong Wang <wangzhong.c0ss4ck@bytedance.com>,
	Xuanqing Shi <shixuanqing.11@bytedance.com>
Subject: Re: [PATCH] KVM: arm64: nv: Translate vEL2 PSTATE to EL1 in
 kvm_hyp_handle_mops()
Message-ID: <ajGur_YEMoMLZPSF@kernel.org>
References: <20260616114943.81188-2-bestswngs@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616114943.81188-2-bestswngs@gmail.com>

Hi Weiming,

Thanks for the fix.

On Tue, Jun 16, 2026 at 07:49:44PM +0800, Weiming Shi wrote:
> When a nested virtualisation guest is running its virtual EL2 (vEL2),
> fixup_guest_exit() rewrites vcpu_cpsr() to the guest's virtual exception
> level: a hardware PSTATE.M of EL1{t,h} is presented as EL2{t,h}. The
> hardware, however, executes vEL2 at EL1.
> 
> kvm_hyp_handle_mops() runs on the fast guest re-entry path, where it
> clears the single-step bit and restores SPSR_EL2 directly from
> vcpu_cpsr():
> 
> 	*vcpu_cpsr(vcpu) &= ~DBG_SPSR_SS;
> 	write_sysreg_el2(*vcpu_cpsr(vcpu), SYS_SPSR);
> 
> For a guest hypervisor this writes the vEL2 view (PSTATE.M == EL2h) into
> the hardware SPSR_EL2 without translating it back. The fast path re-enters
> the guest via __guest_enter()/ERET without going through
> __sysreg_restore_el2_return_state(), so neither to_hw_pstate() nor the
> "return to a less privileged mode" safety check there (which would set
> PSR_IL_BIT) is applied. The ERET therefore restores PSTATE.M = EL2h and
> re-enters the guest at the real EL2 with a guest-controlled ELR, escaping
> stage-2 and the guest/host boundary.
> 
> This is reachable on a kernel with FEAT_MOPS running a KVM nested guest
> (kvm-arm.mode=nested): KVM sets HCRX_EL2.MCE2, which the guest hypervisor
> cannot clear for its own context (is_nested_ctxt() is false), so a vEL2
> MOPS exception is taken to the host and dispatched to kvm_hyp_handle_mops()
> with VCPU_IN_HYP_CONTEXT set.
> 
> Translate EL2{t,h} back to EL1{t,h} before writing SPSR_EL2, mirroring
> kvm_hyp_handle_eret(). For non-nested guests vcpu_cpsr() never holds an
> EL2 mode, so the translation is a no-op and behaviour is unchanged.

The changelog is unnecessarily verbose, instead:

  kvm_hyp_handle_mops() resets the single-step state machine as part of
  rewinding state for a MOPS exception by modifying vcpu_cpsr() and
  writing the result directly into hardware.

  In the case of nested virtualization, vcpu_cpsr() is a synthetic value
  such that the rest of KVM can deal with vEL2 cleanly. That means the 
  value requires translation before being written into hardware, which is
  unfortunately missing from the MOPS handler.

  Fix it by directly modifying SPSR_EL2 and avoiding the synthetic state
  altogether, which will be resynchronized on the next 'full' exit back
  to KVM.

Also:

Cc: stable@vger.kernel.org

Definitely meets the bar :)

> Fixes: 2de451a329cf ("KVM: arm64: Add handler for MOPS exceptions")
> Assisted-by: Claude:claude-opus-4-8
> Reported-by: Zhong Wang <wangzhong.c0ss4ck@bytedance.com>
> Reported-by: Xuanqing Shi <shixuanqing.11@bytedance.com>
> Signed-off-by: Weiming Shi <bestswngs@gmail.com>
> ---
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 23 ++++++++++++++++++++++-
>  1 file changed, 22 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index e9b36a3b27bbc..a6b7963ddbf0b 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -448,6 +448,8 @@ static inline bool __populate_fault_info(struct kvm_vcpu *vcpu)
>  
>  static inline bool kvm_hyp_handle_mops(struct kvm_vcpu *vcpu, u64 *exit_code)
>  {
> +	u64 spsr, mode;
> +
>  	*vcpu_pc(vcpu) = read_sysreg_el2(SYS_ELR);
>  	arm64_mops_reset_regs(vcpu_gp_regs(vcpu), vcpu->arch.fault.esr_el2);
>  	write_sysreg_el2(*vcpu_pc(vcpu), SYS_ELR);
> @@ -457,7 +459,26 @@ static inline bool kvm_hyp_handle_mops(struct kvm_vcpu *vcpu, u64 *exit_code)
>  	 * instruction.
>  	 */
>  	*vcpu_cpsr(vcpu) &= ~DBG_SPSR_SS;
> -	write_sysreg_el2(*vcpu_cpsr(vcpu), SYS_SPSR);
> +
> +	/*
> +	 * For a guest hypervisor, vcpu_cpsr() holds the vEL2 view
> +	 * (PSTATE.M == EL2h) installed by fixup_guest_exit(), but vEL2
> +	 * runs at EL1. Translate it back before restoring SPSR_EL2, as in
> +	 * kvm_hyp_handle_eret().
> +	 */
> +	spsr = *vcpu_cpsr(vcpu);
> +	mode = spsr & (PSR_MODE_MASK | PSR_MODE32_BIT);
> +	switch (mode) {
> +	case PSR_MODE_EL2t:
> +		mode = PSR_MODE_EL1t;
> +		break;
> +	case PSR_MODE_EL2h:
> +		mode = PSR_MODE_EL1h;
> +		break;
> +	}
> +	spsr = (spsr & ~(PSR_MODE_MASK | PSR_MODE32_BIT)) | mode;
> +
> +	write_sysreg_el2(spsr, SYS_SPSR);

As I allude to in the modified changelog, I'd rather we just manipulate
the hardware value of SPSR_EL2 directly. We already do this in
kvm_hyp_handle_eret()

	spsr = read_sysreg_el2(SYS_SPSR);
	write_sysreg_el2(spsr & ~DBG_SPSR_SS, SYS_SPSR);

Thanks,
Oliver

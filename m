Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41565197A7D;
	Wed, 15 Jul 2026 08:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784102440; cv=none; b=cZ28jlityg2SA1XSY13pR44K7EyvM3blHQzOU2fxvktDt1Bx9KzlDHu5HsnN2q2XeiQsNcUvggupP5hdZ3eWESmX0G/g/YrDBZKEHwEw+dU187hnJlv5hsVbXLAc04upfblEjG9HokU56zjoVo2Z+MQZXWALk4k0nDhwgbdcHeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784102440; c=relaxed/simple;
	bh=tfoWpu7/6Gp0yYtOxEES2MM3JNboyLhmH3IRIIIrQyw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SJCE3jaaw/K7c88V5Ic6Y232ge4V4Nc3EY4ByOoOTi4ySXV2ZezOd6mTtMaw+csyWe4BnSUxgtf1z2Fm7X3WogZq83qJO3E4KghDgWEFS6UXM7VFajnE04dlI+LSUSd585+ZnfB9VcgzD/ig9xn6x9bIX/CdiortcSJSnkicZ9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nA3IRwwE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nA3IRwwE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D96691F00A3A;
	Wed, 15 Jul 2026 08:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784102439;
	bh=6xRWik7oMk39agPS8Gpaej2sQhyVer8C5rt7PdSERk0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nA3IRwwErLKqfQGojuyqxnTXbJwwXvZDVgVhUl5OuKarcqsxrQo+7R4J6Kyi8skLH
	 mhsFU97kz0buOOx8UicSxnPYXuznj0hqYYsMIhD2Wx2d5ZcSI9xgJJFphb4NP8Id8g
	 t7CpwYDb1R7o/hfz7Ef78aDJdv1xn5kNBoG7Xv29w4F63eWdSjhlY1idsLxcq/y7v4
	 7txuwuMXKNzwQxdQBAaG36/frJQxOmwBPCZJ9fFHiIyeze7MmuP6YlQYp01saXJckl
	 EtgJaT9VJ0Q/eQiCEZkRQ3BY2cioFM3JMI+3A7QJUjg5KjXf166H2nSxZ6NcmcB+g9
	 5J7g75j2La4jw==
Date: Wed, 15 Jul 2026 01:00:37 -0700
From: Oliver Upton <oupton@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 07/28] KVM: arm64: Don't evaluate HCR_EL2.NV nor
 HFGITR_EL2.ERET on ERET fast path
Message-ID: <alc-JSvHDjSV5c_G@kernel.org>
References: <20260714091641.1970822-1-maz@kernel.org>
 <20260714091641.1970822-8-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714091641.1970822-8-maz@kernel.org>

Hey,

On Tue, Jul 14, 2026 at 10:16:20AM +0100, Marc Zyngier wrote:
> We currently avoid using the ERET fast path if the guest has HCR_EL2.NV
> set. This is an odd check, as NV doesn't mean much if HCR_EL2.TGE==1.
> 
> Similarly, evaluating HFGITR_EL2.ERET makes little sense, as
> this only applies to the nested context, while the ERET fast-path
> is purely for the benefit of L1.
> 
> Replace these bizarre checks with is_nested_ctxt() which makes a lot
> more sense: if we are running an L2, the ERET trap must go to L1.
> 
> Fixes: dd0717a998f77 ("KVM: arm64: nv: Fast-track 'InHost' exception returns")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/vhe/switch.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index bbe9cebd3d9d5..a83be345f8450 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -344,13 +344,10 @@ static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcpu, u64 *exit_code)
>  	 * if this is a VHE guest hypervisor returning to its own
>  	 * userspace, or the hypervisor performing a local exception
>  	 * return. No need to save/restore registers, no need to
> -	 * switch S2 MMU. Just do the canonical ERET.
> -	 *
> -	 * Unless the trap has to be forwarded further down the line,
> -	 * of course...
> +	 * switch S2 MMU. Just do the canonical ERET unlesss we are in
> +	 * nested context.
>  	 */

typo: unless

I feel like it wouldn't hurt to add a bit more detail to the comment
here, that L0 KVM doesn't use ERET traps in the nested context.
Otherwise it isn't clear why these always belong to the L1.

Thanks,
Oliver

> -	if ((__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_NV) ||
> -	    (__vcpu_sys_reg(vcpu, HFGITR_EL2) & HFGITR_EL2_ERET))
> +	if (is_nested_ctxt(vcpu))
>  		return false;
>  
>  	spsr = read_sysreg_el1(SYS_SPSR);
> -- 
> 2.47.3
> 

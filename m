Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF86276028;
	Tue, 28 Apr 2026 13:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777384229; cv=none; b=UGg2RwvTJgxlnZjSXHtJQhowYEvBCvvx0PdpcDOxzSbTYrT1IrZJ6XtI+MPRQ6wVSCiRLfHlF++TVhumkT+4UotSzRuYx31j5gZTYk9WiYFb8lEkaYQqvUWX6C/u9cjZ2Dw2sE8+6tMGe64q1stle0k7Z+oCbciTp3ucJD0kME4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777384229; c=relaxed/simple;
	bh=C5KSRh53zUUnHlfowXZ4LbxgWa/gXflfi32aQpqJdG8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UF93VhZyV69+NXcyz92iL43THlUsNDJBtY9oZVEqEsrvfJGxTfiPP4sr7JCVumCRSnXVZhpVUaVyhmo56H1cPos6vx2z2tPuMNjBLcZhW20hqOVejeXehvoqRzbzuOpxSM7SLqY1j3YdSQa3VpV/xBu37XuWMs+0w16mdmAiP58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VCBmAicR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VCBmAicR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25837C2BCAF;
	Tue, 28 Apr 2026 13:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777384228;
	bh=C5KSRh53zUUnHlfowXZ4LbxgWa/gXflfi32aQpqJdG8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VCBmAicRsBEGMMPKnS6mfeRIsjZM73pool8RdEf0m7TaJhDQrMg9QCfOXrqATsCKn
	 44me2Coqd+8h7Yg0OG1VpbvysEn9YkkzxGVM/d5GOlTADW0io+Jrv7AAn86R5b4q4o
	 7n1UCPxhTWKr0ZUNuAn6fKDM6e7OBRYBx2/GAv2IW804DZyXN81aEfbnYLZQRD068d
	 fqnWuMsPuZx0jLLcErSl++pqobVk14f+edlUxYz32ybKhVmICFjxecWaMO9DFYAoFy
	 Wkz0SyJkruKD17nDeJ7aYrPIe/KzidwX7/CNNX1LJlihv/AFGGhOnraH4dZlMu1F3V
	 85cgj+ud9i79A==
Date: Tue, 28 Apr 2026 14:50:23 +0100
From: Will Deacon <will@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, james.morse@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, qperret@google.com,
	vdonnefort@google.com, catalin.marinas@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/8] KVM: arm64: Synchronise HCR_EL2 writes on the guest
 exit path
Message-ID: <afC7H1fu4vFzTRTt@willie-the-truck>
References: <20260428103008.696141-1-tabba@google.com>
 <20260428103008.696141-3-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260428103008.696141-3-tabba@google.com>

On Tue, Apr 28, 2026 at 11:30:02AM +0100, Fuad Tabba wrote:
> MSR HCR_EL2 is not self-synchronising. Per ARM DDI 0487 M.b K1.2.4
> (p.K1-16823) and B2.6.1 (p.B2-297), a Context Synchronisation Event
> is required between an HCR_EL2 write and any subsequent direct
> register access at the same EL that depends on the new value being
> in effect.
> 
> On the entry path, the HCR_EL2 write in __activate_traps is followed
> by further EL2 sysreg work (MDCR_EL2, CPTR_EL2, VBAR_EL2, and on the
> speculative-AT errata path SCTLR_EL1/TCR_EL1) before ERET into the
> guest. None of those intervening accesses depend on the new HCR_EL2
> value, and ERET is a CSE per ARM DDI 0487 M.b D1.4.4.1 rule RBWCFK
> (p. D1-7209) conditional on SCTLR_EL2.EOS=1, which is set
> unconditionally by INIT_SCTLR_EL2_MMU_ON (see the prerequisite patch
> in this series). The requirement is therefore satisfied implicitly
> on the activate path.
> 
> The deactivate path is different: after write_sysreg_hcr() in
> __deactivate_traps() further EL2 sysreg work runs before any natural
> CSE - on nVHE, __deactivate_cptr_traps and the VBAR_EL2 write; on
> VHE, the timer context save which reads CNTP_CVAL_EL0 under the new
> TGE/E2H, and the EL1 sysreg restore. Add an explicit isb() at each
> of the two deactivate sites.
> 
> The practical impact today is bounded: HCR_EL2.E2H does not toggle
> in either path, and the trap bits being changed primarily affect
> EL1&0 behaviour. But the architectural rule should be honoured.
> Note that write_sysreg_hcr() itself already issues isb() on the
> Ampere errata path (sysreg.h), confirming the architectural
> expectation; the fast path optimises that away.
> 
> The fix is at the call sites rather than inside write_sysreg_hcr()
> because the macro has many users (e.g. the activate path, at.c,
> hardirq.h, ptrauth alternatives) where the immediately-following
> code either reaches ERET or has another CSE; making the macro emit
> an unconditional ISB would impose unnecessary cost on those
> well-formed users.
> 
> Fixes: 9404673293b0 ("KVM: arm64: timers: Correctly handle TGE flip with CNTPOFF_EL2")
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/switch.c | 11 +++++++++++
>  arch/arm64/kvm/hyp/vhe/switch.c  | 11 +++++++++++
>  2 files changed, 22 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> index 8d1df3d33595..9d7ead5a5503 100644
> --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> @@ -105,6 +105,17 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
>  	__deactivate_traps_common(vcpu);
>  
>  	write_sysreg_hcr(this_cpu_ptr(&kvm_init_params)->hcr_el2);
> +	/*
> +	 * MSR HCR_EL2 is not self-synchronising. Per ARM ARM K1.2.4 p.K1-16823
> +	 * and B2.6.1 p.B2-297, a Context Synchronisation Event is required
> +	 * between an HCR_EL2 write and any subsequent direct register access at
> +	 * the same EL that depends on the new value being in effect.
> +	 * The activate_traps path falls through to ERET (a CSE), but the
> +	 * deactivate path still executes further EL2 sysreg work (CPTR/VBAR
> +	 * writes below) before any natural CSE, so make the synchronisation
> +	 * explicit.
> +	 */
> +	isb();

Sorry, but I don't understand this. Please can you explain why you think
that CPTR and VBAR have an ordering dependency on HCR_EL2? Preferably,
the comment would talk about the specific fields that are relevant.

Will

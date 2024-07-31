Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4AC71A8C14
	for <kvmarm@lists.linux.dev>; Wed, 31 Jul 2024 10:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722420313; cv=none; b=tGwQgl+uQFl8qjSwhZF4A9nSWelMEe90lTRiBZBmRspaka5nddd7ewOfS0tJpXa8mGj+jGsnovdEBRNdmc+9FHCkuhdmuqTdZts4ted7rM365+DoD6mf7Veh12euS+VilRAwc36Pj3wPP2CtbfFOK/cc1EFlrG70AmHTuwUBcRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722420313; c=relaxed/simple;
	bh=K+vD9/aMeC1TJMgPdGGFbotOzCqA5/w8SWFYS2npk0I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OJ/i54RUnmR4tBRJ43DawaKrcX/aaaOL3JF7Vo0B6KTXJNzwyrznwtxBF+pNScyWl+8GqIQZbH3dvN7hVK8nLhFDdscWNUgwHLMG1PK39w3d2xVNnSN037FM9wKNvtHDCvXM3WTDvWIOQKznFC0F8WgT7agr5FZZrOlQWwkHR8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 49EBF1007;
	Wed, 31 Jul 2024 03:05:35 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0D7233F5A1;
	Wed, 31 Jul 2024 03:05:07 -0700 (PDT)
Date: Wed, 31 Jul 2024 11:05:05 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Joey Gouly <joey.gouly@arm.com>
Subject: Re: [PATCH 00/12] KVM: arm64: nv: Add support for address
 translation instructions
Message-ID: <ZqoMUb_Q6n8J_pYq@raptor>
References: <20240625133508.259829-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240625133508.259829-1-maz@kernel.org>

Hi Marc,

On Tue, Jun 25, 2024 at 02:34:59PM +0100, Marc Zyngier wrote:
> Another task that a hypervisor supporting NV on arm64 has to deal with
> is to emulate the AT instruction, because we multiplex all the S1
> translations on a single set of registers, and the guest S2 is never
> truly resident on the CPU.

I'm unfamiliar with the state of NV support in KVM, but I thought I would have a
look at when AT trapping is enabled. As far as I can tell, it's only enabled in
vhe/switch.c::__activate_traps() -> compute_hcr() if is_hyp_ctct(vcpu). Found
this by grep'ing for HCR_AT.

Assuming the above is correct, I am curious about the following:

- The above paragraph mentions guest's stage 2 (and the code takes that into
  consideration), yet when is_hyp_ctxt() is true it is likely that the guest
  stage 2 is not enabled. Are you planning to enable the AT trap based on
  virtual HCR_EL2.VM being set in a later series?

- A guest might also set the HCR_EL2.AT bit in the virtual HCR_EL2 register. I
  suppose I have the same question, injecting the exception back into the guest
  is going to be handled in another series?

Thanks,
Alex

> 
> So given that we lie about page tables, we also have to lie about
> translation instructions, hence the emulation. Things are made
> complicated by the fact that guest S1 page tables can be swapped out,
> and that our shadow S2 is likely to be incomplete. So while using AT
> to emulate AT is tempting (and useful), it is not going to always
> work, and we thus need a fallback in the shape of a SW S1 walker.
> 
> This series is built in 4 basic blocks:
> 
> - Add missing definition and basic reworking
> 
> - Dumb emulation of all relevant AT instructions using AT instructions
> 
> - Add a SW S1 walker that is using our S2 walker
> 
> - Add FEAT_ATS1A support, which is almost trivial
> 
> This has been tested by comparing the output of a HW walker with the
> output of the SW one. Obviously, this isn't bullet proof, and I'm
> pretty sure there are some nasties in there.
> 
> In a departure from my usual habit, this series is on top of
> kvmarm/next, as it depends on the NV S2 shadow code.
> 
> Joey Gouly (1):
>   KVM: arm64: make kvm_at() take an OP_AT_*
> 
> Marc Zyngier (11):
>   arm64: Add missing APTable and TCR_ELx.HPD masks
>   arm64: Add PAR_EL1 field description
>   KVM: arm64: nv: Turn upper_attr for S2 walk into the full descriptor
>   KVM: arm64: nv: Honor absence of FEAT_PAN2
>   KVM: arm64: nv: Add basic emulation of AT S1E{0,1}{R,W}[P]
>   KVM: arm64: nv: Add basic emulation of AT S1E2{R,W}
>   KVM: arm64: nv: Add emulation of AT S12E{0,1}{R,W}
>   KVM: arm64: nv: Make ps_to_output_size() generally available
>   KVM: arm64: nv: Add SW walker for AT S1 emulation
>   KVM: arm64: nv: Plumb handling of AT S1* traps from EL2
>   KVM: arm64: nv: Add support for FEAT_ATS1A
> 
>  arch/arm64/include/asm/kvm_arm.h       |    1 +
>  arch/arm64/include/asm/kvm_asm.h       |    6 +-
>  arch/arm64/include/asm/kvm_nested.h    |   18 +-
>  arch/arm64/include/asm/pgtable-hwdef.h |    7 +
>  arch/arm64/include/asm/sysreg.h        |   19 +
>  arch/arm64/kvm/Makefile                |    2 +-
>  arch/arm64/kvm/at.c                    | 1007 ++++++++++++++++++++++++
>  arch/arm64/kvm/emulate-nested.c        |    2 +
>  arch/arm64/kvm/hyp/include/hyp/fault.h |    2 +-
>  arch/arm64/kvm/nested.c                |   26 +-
>  arch/arm64/kvm/sys_regs.c              |   60 ++
>  11 files changed, 1125 insertions(+), 25 deletions(-)
>  create mode 100644 arch/arm64/kvm/at.c
> 
> -- 
> 2.39.2
> 
> 

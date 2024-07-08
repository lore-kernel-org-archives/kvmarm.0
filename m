Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87DD6146016
	for <kvmarm@lists.linux.dev>; Mon,  8 Jul 2024 16:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720456099; cv=none; b=NP1nTNTlklqwXJGcmJPjaLXbMeV8hH/0Nvd+iY08IcOEqFYfbXIE18HOO8SjddLhRl+LyQN5DMc1m8Fi3SLVr8UJjOKVnnzM2hunXzN+gvuvCI8rSVzMIDXWvZlMC/whGuMf9veIOuzrjmyOG10WNI708IGNft0mV8LycR2nFQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720456099; c=relaxed/simple;
	bh=JHTA5erMNEhfc4CBy7in9bn/seuATamqgPxt4vY6faA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TbyrhPxTj3AfZg7PjVSccLArr9MsAh2DphIi8XuwzhYKAOrA+PPKgN/BB9qYkiSbY7WXlYt0g6HE+3CvoiF+QTfNcpt4LTPyvNsby0I89ijBaL53P5/DTWUVJA5Rb0hv7b2Vb1eHWfybY9HqFOvVCEm1oMfmXnn423qHT0lmmjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 14C3A1042;
	Mon,  8 Jul 2024 09:28:41 -0700 (PDT)
Received: from arm.com (e121798.manchester.arm.com [10.32.101.22])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 77F323F641;
	Mon,  8 Jul 2024 09:28:14 -0700 (PDT)
Date: Mon, 8 Jul 2024 17:28:11 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Joey Gouly <joey.gouly@arm.com>
Subject: Re: [PATCH 00/12] KVM: arm64: nv: Add support for address
 translation instructions
Message-ID: <ZowTm99y4fp9xWL7@arm.com>
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

I wanted to have a look at the S1 walker, and in my inbox I only have
patches #1 to #9 ("KVM: arm64: nv: Make ps_to_output_size() generally
available"). Checked on the kvm mailing list archive [1], same thing; a
google search for the string "KVM: arm64: nv: Add SW walker for AT S1
emulation" (quotes included) turns up the cover letter.

Am I looking in the wrong places?

[1] https://www.spinics.net/lists/kvm/msg351826.html

Thanks,
Alex

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

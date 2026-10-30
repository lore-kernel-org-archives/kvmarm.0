Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793377118;
	b=m6Mbfgy0bd853I2viW8xGD71wBWE0+95EKjE4XF52WdTYO5wkaMQ0RPb4HVB3GDUNUZq
	 w4blTxFue7/PX7uBGfrXThm8xaAyyJxcVPMd6WI/4P41K/Gwrtco/PrhdtKCN90iIRyux
	 KaeDjWx7RaPknKVg8Venb31FPucxjQgBYQS6HZyXP8wSeQNvSrc5gXYIs0e0dlMwhaA4z
	 BwXDYuILlqKROMs0o0fqqX/MG6JJCoHWWr+MUqrDePpxnu1cuDqpFo15AxO767Sns2kPq
	 OMjc5Yw4+Z4jtghtK6kK9CWjRERBqxrW37tjcR4F0UNxKPKGbRO80woOTc9Xtv1TsJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793377118;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=Lp6EuBO/yUZZMjLIO6sxTrSSoT4jD8wY3QkSoLkgUeY=;
	b=4FrfAEDmbWEEs10c+sTfX3FU3kcBlL256WS2UhDFhZylgnEt/3OvMGuI53NIp1DVPm9q
	 7qXL84lfbqMfqlwnLeVFJpJWgt0N8l8MhyWcK52OiXPCckpCAEfYHhZ8wV03HC1wI0WIK
	 bdnQt/AQqA5wvmyLCeolJrh4PF1paT42S/scRhZLZXAsZhibt7sfMM4GgJdx8FrqzWfjP
	 /tl3im4b9Z/F3VrBoJWDwgSBZiXPP+nODp5qaub+uQm7rzmDIjXTNs7cixc56fkLe+v1x
	 lwX/vv9rD5n4goSrZDj/sXR45QokssMlWvN5Ru8RxBpJPvqkepDqORS26W6B7flVvOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=uAwB7+ly;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAD90606A321
	for <kvmarm@lists.linux.dev>; Fri, 30 Oct 2026 16:18:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CAD90606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=uAwB7+ly
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 629A11682;
	Fri, 30 Oct 2026 09:18:32 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C8A6A3F673;
	Fri, 30 Oct 2026 09:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793377115; bh=7oTpehWmFbYAsoZtB/D9o/RfJCE3obn/J8/upR1nrKI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uAwB7+lyL90I+g2BBk+QSjpwL46XuovIUDrreeJpBOgYrX3eL0HtAc5t/KyQ6LCJe
	 bGnxDtE7u0bxV9OvrWyJhNIsmGMKt1Iu+dSRnU3JKdJ/kRk9Td+uIY8B9e1JPIFFM2
	 c1j7rW3wuzkSxND9PoYkOWoeTf2fUw0O1qkShnBI=
Date: Fri, 30 Oct 2026 16:18:25 +0000
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Fuad Tabba <fuad.tabba@linux.dev>, sashiko-bot@kernel.org
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH] KVM: arm64: nv: Size nested stage-2 MMUs by the NV
 PARange cap
Message-ID: <e6bxdvc4utkt3circfrvzdxhtgdqxz2y736ufhjyxpi6xa5caf@qmtah7wbjx6g>
References: <20261030105139.3543230-1-fuad.tabba@linux.dev>
 <sashiko-outbox-190923@kernel.org>
 <20261030120837.3752397-1-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261030120837.3752397-1-fuad.tabba@linux.dev>

On Fri, Oct 30, 2026 at 12:08:37PM +0000, Fuad Tabba wrote:
> On Fri, 30 Oct 2026 11:09:43 +0000, sashiko-bot@kernel.org wrote:
> [...]
> > Because fault_ipa < BIT_ULL(get_kvm_ipa_limit()) (52) and
> > fault_ipa >= BIT_ULL(VTCR_EL2_IPA(vcpu->arch.hw_mmu->vtcr)) (48), won't
> > kvm_handle_guest_abort() fall through to kvm_inject_sea() and inject a
> > synchronous external abort into the guest instead of calling
> > kvm_inject_size_fault() to inject a stage-1 level 0 address size fault?
> 
> Yes. I'll fold this into v2:
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 705f6d84770e9..2a05c7cf8552a 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -2440,8 +2440,8 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>  	is_iabt = esr_trap_is_iabt(esr);
>  
>  	if (esr_fsc_is_translation_fault(esr)) {
> -		/* Beyond sanitised PARange (which is the IPA limit) */
> -		if (fault_ipa >= BIT_ULL(get_kvm_ipa_limit())) {
> +		/* Beyond sanitised PARange */
> +		if (fault_ipa >= BIT_ULL(kvm_get_pa_bits(kvm))) {
>  			kvm_inject_size_fault(vcpu);
>  			return 1;
>  		}
> 
> [...]
> > Should setup_s1_walk() and setup_s2_walk() use kvm_get_pa_bits(vcpu->kvm)
> > instead of get_kvm_ipa_limit() so that check_output_size() raises a
> > stage-1 address size fault for TTBR base addresses and descriptors with
> > bits [51:48] set rather than letting walk_s1() and __kvm_at_s12() truncate
> > those bits when passing the address to stage-2?
> 
> No. setup_s2_walk() passes pa52bit=false, so its output size is
> already at most 48. setup_s1_walk()'s output size can only exceed 48
> because, on an LPA2 host, NV guests see stage-1 TGRAN4/TGRAN16 at
> 52_BIT, which Wei-Lin's patch [1] stops advertising.

Agreed, however would it be more future-proof if they are changed to
kvm_get_pa_bits() anyway?

I.e. If kvm_get_pa_bits() < get_kvm_ipa_limit() is possible in the
future, the resulting max_oa_bits could be too large.

Also I don't see why we should use get_kvm_ipa_limit() (a host KVM
global limit) during a guest specific translation table walk.

Thanks,
Wei-Lin Chang

> 
> Cheers,
> /fuad
> 
> [1] https://lore.kernel.org/all/20261029223732.103785-2-oupton@kernel.org/

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8496B3CAA3A
	for <kvmarm@lists.linux.dev>; Sun, 14 Jun 2026 16:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781455458; cv=none; b=bnMVP2yfUwxm3FGM/eLAtoMuRDNaoz0vbAq9HZiHZjDAX6KrD5anDiR7maBnelYLliwSkd0Q+/++2Sf3yK0G7zK1Wx0PrIXLOieC7VapERhmgBVslwD9pd755i7+mny3zdt814BdUuDRMceHO+Zmp6XE35JbEfIGu9UQtUQxj5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781455458; c=relaxed/simple;
	bh=4dt+kpOblcoBHX3GrQdIj9TvcyZ5dpBxv8pWJ0g88R0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JgkueiglXSJZC4AtCaRCyQFvtxkFbNpHIg1hY12x87UBXEi4oojst8/MglNBvJD+kVUVZWrjkkKyG+9nvTyxncgjnLUjdyGkegOEkQMc7GKIQNAObnz94TUDqWZuG5IBIMO6rsvW1LB2+alfRMoM+EdG3L+ljpkrBrD0U71WtAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ljdmMrCW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ljdmMrCW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D37E61F000E9;
	Sun, 14 Jun 2026 16:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781455457;
	bh=dp1IEDCTihVOXIrUY62HxqMeePUnxbsAGurul1adsd0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ljdmMrCWUAIauIMxxIVlomt61NJ+1E8k6JHKTZRNEBQriikn1zI8nR1a+iWAa3/RR
	 HNQzEiwizL81RusvT2JkzLCIeXnr8sUzYA/O6kQ726ZzBVaVLxueJE6k/20FaZcS3a
	 vqwbcZAB9cZR0YWuU4YsMbXODF87dYzYz11JBAn9aYQ+9YXk7fsJwWWU7qOvKC9upt
	 rIm0JSf4IiD80yt4VkAzP2eADV6FGlB+aSgLJyZKlQSkJyHK6dAQzFt964f6Jj8iRv
	 3P/suAYYV0K3tM4YiH+J24l5wlIcNF2rsas8xXt02zU9zYo9jSvClYFRA28tO8Qf3B
	 KXxZFmE6UfQsw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6/7] KVM: arm64: Set IL for nested SError injection
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <tabba@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260614163336.3490925-7-tabba@google.com>
References: <20260614163336.3490925-7-tabba@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 14 Jun 2026 16:44:16 +0000
Message-Id: <20260614164416.D37E61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The constructed SError syndrome (ESR) is silently dropped during n=
ested EL2 exception injection because `ESR_EL2` is never updated.
- [High] When SCTLR2_EL1_EASE routes a Synchronous External abort to an SEr=
ror, the ESR injected has the wrong EC (IABT/DABT instead of SERROR) and an=
 incorrect ISS format.
--

commit 09fd06d56ab3236a0e7af03e0d026ed6725ad6d6
Author: Fuad Tabba <tabba@google.com>

KVM: arm64: Set IL for nested SError injection

This patch modifies the emulated SError injection to unconditionally
set the IL (Instruction Length) bit in the generated ESR, as mandated
by the architecture.

> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nes=
ted.c
> index 4b39363cf8911..4262d4c17a877 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -2938,6 +2938,6 @@ int kvm_inject_nested_serror(struct kvm_vcpu *vcpu,=
 u64 esr)
>  	 * vSError injection. Manually populate EC for an emulated SError
>  	 * exception.
>  	 */
> -	esr |=3D FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_SERROR);
> +	esr |=3D FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_SERROR) | ESR_ELx_IL;
>  	return kvm_inject_nested(vcpu, esr, except_type_serror);

[Severity: High]
This isn't a bug introduced by this patch, but does the carefully construct=
ed
esr value actually get written to the guest's ESR_EL2?

Looking at kvm_inject_nested(), it passes the esr_el2 argument down:

kvm_inject_nested(vcpu, esr_el2, type) {
    ...
    kvm_inject_el2_exception(vcpu, esr_el2, type);
    ...
}

However, in kvm_inject_el2_exception():

static void kvm_inject_el2_exception(...) {
    ...
    switch (type) {
    ...
    case except_type_serror:
        kvm_pend_exception(vcpu, EXCEPT_AA64_EL2_SERR);
        break;
    ...
}

Since except_type_serror only pends the exception and doesn't explicitly
write the esr_el2 argument into ESR_EL2 (unlike except_type_sync), does the
nested hypervisor observe a stale or uninitialized syndrome when it takes
the SError?

[Severity: High]
This is a pre-existing issue, but since this code deals with fixing SError
syndromes, what happens when SCTLR2_ELx.EASE is enabled and a Synchronous
External abort is routed to an SError?

Looking at kvm_inject_nested_sea() in the same file:

int kvm_inject_nested_sea(struct kvm_vcpu *vcpu) {
    ...
    u64 esr =3D FIELD_PREP(ESR_ELx_EC_MASK,
                         iabt ? ESR_ELx_EC_IABT_LOW : ESR_ELx_EC_DABT_LOW);
    ...
    if (__vcpu_sys_reg(vcpu, SCTLR2_EL2) & SCTLR2_EL1_EASE)
        return kvm_inject_nested(vcpu, esr, except_type_serror);
    ...
}

Does this result in an SError being injected with a Data/Instruction Abort
EC? According to the ARM Architecture Reference Manual (D8.2.5), shouldn't
an SError always have its ESR_ELx.EC field set to 0b101111 (SError)?

A similar pattern appears in inject_abt64() for EL1, where a DABT/IABT
syndrome is constructed and actively written to exception_esr_elx(vcpu)
even though an SError exception was pended. Would this incorrect EC format
confuse the guest's exception handlers?

>  }
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260614163336.3490=
925-1-tabba@google.com?part=3D6

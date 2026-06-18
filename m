Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3ADA3563E1
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 12:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781786030; cv=none; b=W6mAnj3kLqY3P/RJIdG3r1uzD3WrQ23c1H37COPY+jr+jDMTjqaA/JFZL2P1VpOKcRPfGgqly23qsrG4Ny4xxfAt3p+u4V8W5nFsN2wrThNOQHiw6Q1pIfAs6KXIWhVHlriACItmYGjEo+4zOvRx1vgIMesk2gu0uh4xaxYdVJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781786030; c=relaxed/simple;
	bh=p7+Fv9jEVQa2+4UfSJWKCGyV1ejyx4huWdTWIQ26TWw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=V62ZU0P5AmULD7N1+5kW2I5TnrIoL9+u1vYsay3G4k9h58GgEuO/Nzpn3IKyjJjCjTI71Hz4T7RyTsZNkFN3WmX8btzkq7ElOKvhJTvIijMqd1oq+mDzJX411os5klhbQ5sfhEUvqPwFPZquei9SW6p0y+28cZJjBVlgQgQ+8+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=md6R88T6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="md6R88T6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F2ED1F000E9;
	Thu, 18 Jun 2026 12:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781786029;
	bh=43Bwlx8yvFLNtjVX4VcOTnWIJQxHPiHZY8v2kC3GPQ0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=md6R88T635sPjmC1XuWo3TIQ86ITdNcZh9BD7Ww7A5HRjLxPbnhSpJaAOUGlPKUSj
	 psvJZSOQ5zS6zhq5D7sKLeS+YIilHYb4+3luu8U7xpdrClEPaD3wVub9eLIWGamX4M
	 NoiyrRR8JyEj1546kBxGZYDVQAQdJZX0y6DdKJ4Bk0tlTJ0saOz078/OR9XsL8cMdR
	 rQwOBRr9gEWM2Rl7JubM2gr8mSgY/6CCIqGVUW92kjpCTct2a0i29i9XVyPF3cv+5E
	 LODDbSZG60iHZwAVpyIGw4BWVMMEDvSezf1QAFPqSaHoTZAzUR+LoLjJpDRSz/eNp6
	 +gW0GJH9sx2Nw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 6/7] KVM: arm64: Set IL for nested SError injection
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <tabba@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260618121643.4105064-7-tabba@google.com>
References: <20260618121643.4105064-1-tabba@google.com>
 <20260618121643.4105064-7-tabba@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 18 Jun 2026 12:33:48 +0000
Message-Id: <20260618123349.1F2ED1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The SError syndrome constructed by `kvm_inject_nested_serror()` (i=
ncluding the newly added IL bit) is a dead store because the downstream inj=
ection logic silently drops the syndrome.
- [High] When a Synchronous External Abort is routed to an SError via FEAT_=
DoubleFault2 (`EASE`), KVM incorrectly populates the ESR with an IABT or DA=
BT Exception Class (EC) instead of the architectural SError EC.
--

commit 889dc0193654a25a0ce52006ebe91e58fc4c4ed8
Author: Fuad Tabba <tabba@google.com>

KVM: arm64: Set IL for nested SError injection

This patch modifies kvm_inject_nested_serror() to unconditionally set the IL
bit in the SError syndrome, as mandated by the architecture.

> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nes=
ted.c
> index b74369e9ad7ff..6f12496cae815 100644
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
>  }

[Severity: High]
This isn't a bug introduced by this patch, but does the constructed syndrome
value get silently dropped downstream?

Looking at kvm_inject_nested(), it forwards the esr to
kvm_inject_el2_exception():

arch/arm64/kvm/emulate-nested.c:kvm_inject_el2_exception() {
    ...
    case except_type_serror:
        kvm_pend_exception(vcpu, EXCEPT_AA64_EL2_SERR);
        break;
    ...
}

The except_type_serror case doesn't write esr_el2 to ESR_EL2 (unlike the
except_type_sync case), and downstream exception entry code doesn't write
it either.

The constructed payload appears to be entirely discarded.

Would the nested hypervisor observe a stale ESR_EL2 value when taking the
SError, rendering this fix functionally ineffective?

[Severity: High]
This is a pre-existing issue, but when a Synchronous External Abort is rout=
ed
to an SError via EASE (FEAT_DoubleFault2), does KVM incorrectly populate the
ESR with an Abort Exception Class instead of SError?

In kvm_inject_nested_sea(), if SCTLR2_EL1_EASE is set, an SError is request=
ed
using an ESR constructed with an Abort EC:

arch/arm64/kvm/emulate-nested.c:kvm_inject_nested_sea() {
    ...
    if (__vcpu_sys_reg(vcpu, SCTLR2_EL2) & SCTLR2_EL1_EASE)
        return kvm_inject_nested(vcpu, esr, except_type_serror);
    ...
}

Similarly in arch/arm64/kvm/inject_fault.c:inject_abt64(), the ESR is
populated with ESR_ELx_EC_IABT_* or ESR_ELx_EC_DABT_* before being written.

Architecturally, all SError interrupts must have an SError Exception Class,
even when representing a routed SEA.

Does supplying an Abort EC violate the architecture and provide the guest w=
ith
a malformed exception syndrome?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260618121643.4105=
064-1-tabba@google.com?part=3D6

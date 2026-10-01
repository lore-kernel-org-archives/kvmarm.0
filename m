Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B2951A73A
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 14:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790864370; cv=none; b=NHriP4LHVti+jR9WhDQuyjnDbkVx101FW0MNKIqBYel0ZlK7iC51XZSVq5x0ncjg1ThB0+hCXWcR/YN+o8NSHxmBR8m8+NBfSWKnROsczFL1B+Ct4hEf6FJ46xHbVWzbkm3uAbchLxRv1LQUex1BFNJkCyNDlRrhsmC208+Wr0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790864370; c=relaxed/simple;
	bh=+l7TaTAWFQ09+z46qEvj1Q/5Vrhk6KFFrG4SGiptJZ0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jgWlnn5pZv40gJ96VYXrV5htS2xeD2g8zArpspWSjei9CQOc091qrlcATeun+2S41PD10KiY1xr5TkaB/GZDNjH3KEMnE6/2RwddkCyc/6qPtHG8R/Hr8kQzV1peXcqB590U61HRiCdIcBCSx3xQekvbzl1PlrTdsSZQvdGrCUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OfPeXGAp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OfPeXGAp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F621F000FF;
	Thu,  1 Oct 2026 14:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790864368;
	bh=ZZ5UYkKTm3VB0JgyMS9/7yMBYCsq5BpnI19r/1mJBYE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OfPeXGApLDeY2Xshek8JnTJhw62AAHNtwXXpkJfDOvv8JaCJdaAZnIX82btp38E6n
	 dJewNSx6FaGmn3J2yYTMi0j34VNXsgLLnKsasA3L81mN23mJzSMYs0egwoCCuU4VvN
	 kyobiVeJTJCIA+EABJ0Q/U2qiuKTHAuW1Jka1qkFI5MMMAyb+cabOkQjuNXXXrRetB
	 6IxAA5Nd5aLDkl/R1SfFq0h69Jqf6jAXIcjsGeRpudYV06YRC0DZwshVBPG0aJ3ghc
	 DeYgdIc172SuS5kGvGpBafoc+YgpfI1yMDdOSqi+P/5Ofc40fPkylokP6GfrgSoBi3
	 fh32SvoNRzweA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 06/18] KVM: arm64: Skip fixed-feature state flush for
 protected vCPUs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20261001135711.1640520-7-fuad.tabba@linux.dev>
References: <20261001135711.1640520-1-fuad.tabba@linux.dev>
 <20261001135711.1640520-7-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 14:19:28 +0000
Message-Id: <20261001141928.87F621F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] kvm: arm64: host hardware breakpoints leak into protected guests
--

commit 678dfb9fd1576272693dba360820510bcb1ec938
Author: Fuad Tabba <fuad.tabba@linux.dev>

    KVM: arm64: Skip fixed-feature state flush for protected vCPUs

This commit moves the mdcr_el2 and TWI/TWE copies into the non-protected
branch. It returns early from flush_debug_state() and sync_debug_state() for
protected vCPUs, as their debug registers are hypervisor-owned, and
configures HPMN at vCPU load.

> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe=
/hyp-main.c
> index e3f4bbb623492..b7b9f5afb673b 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -200,6 +200,9 @@ static void flush_debug_state(struct pkvm_hyp_vcpu *h=
yp_vcpu)
>  {
>  	struct kvm_vcpu *host_vcpu =3D hyp_vcpu->host_vcpu;
> =20
> +	if (pkvm_hyp_vcpu_is_protected(hyp_vcpu))
> +		return;
> +

[Severity: High]
Could this early return cause a regression by allowing the host's hardware
breakpoints to leak into the protected guest?

By returning early here, the hyp vCPU's debug_owner remains VCPU_DEBUG_FREE=
 (0)
for protected VMs.

During the world switch, this causes the hypervisor to skip context-switchi=
ng
the hardware debug registers because kvm_debug_regs_in_use() evaluates to f=
alse:

arch/arm64/kvm/hyp/include/hyp/debug-sr.h:__debug_switch_to_guest_common() {
    ...
	if (!kvm_debug_regs_in_use(vcpu))
		return;
    ...
}

As a result, the host's physical breakpoints remain active in hardware.

If the guest implements DebugVer, MDCR_EL2.TDA is not set:

arch/arm64/kvm/hyp/nvhe/pkvm.c:pvm_init_traps_mdcr() {
    ...
	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, DebugVer, IMP))
		val |=3D MDCR_EL2_TDRA | MDCR_EL2_TDA;
    ...
}

This gives the guest untrapped access to MDSCR_EL1. If the guest sets
MDSCR_EL1.MDE=3D1, the host's hardware breakpoints could fire inside the gu=
est
at EL1, circumventing guest isolation.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001135711.1640=
520-1-fuad.tabba@linux.dev?part=3D6

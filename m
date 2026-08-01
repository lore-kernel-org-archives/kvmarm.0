Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C102147E6;
	Sat,  1 Aug 2026 13:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785589839; cv=none; b=Ju3TbfEeJpse3C2nn5UDr1pl1aDCg6CAs1QBTIUxlUcOcZOvwLjBpAaChsRSlZFE9mvrXbHvY0DBk+LZUcNOIKs5jHNNzUTbtkDYnAYLr+B3X9WxC1K3dc2D55oPkcuHquHEQbiFyUsMQVkdBvBjpaKcUW4HOckzrw5Qn3Uj2Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785589839; c=relaxed/simple;
	bh=flJm2xAdcAKOgoJ1XIr0N9Mfuu5n+wEKJSSaC9SqnVQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=l/eWua5fJhG37krGFAShMpUbGcedpA+3aYcFDuZCC6xQFCU9Sctq4YIMVWRVUwMPCqMyBoIYoK1J4tPqITAFmEZkcK+BO0OoQjL4bZwkViEAkiD/5BzdOId9pDDtEhnl3cD7EdK6AVUzElOdtK4o+dxmR3EyYZUGoPsv051eM0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eaDinGI0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eaDinGI0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09C3C1F00AC4;
	Sat,  1 Aug 2026 13:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785589838;
	bh=sAZOE12TO7gWIJtkxdjbxebWjL0YUrDg+vJ56qKM9Vo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eaDinGI0G1xU5w7lSysCKYyBeUfJTt/2qLFXLQtVHXXp1CVtbgaP58IMXKEjfEQbi
	 fKDUk7YuW3dIPx0kROeTxMoUv0aTocBawxDrJuMNc+xJ+mMjK59mzBrh58fpf1dH6A
	 A0yOAJaf1wFK8LS/Tm8tjJS/nGlQ2sOSL5kqPhxJSvsH89bcvR8xQ3bb1OB4hO5lm4
	 WRyvbCl4F+t09xKsoW4wJ8WVF2yU+2rzZdEU4+hiNpQToJagNlqqRlNIiPrF1XiQVE
	 3nBiJzZY+WaHH16DN9/kCzYniLINDakwd/75B5kk2FmdCOTA0EwTdAQ/lv3QFOU59h
	 mo/KM2qi/tLag==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/6] KVM: arm64: Consider SCTLR_EL2.M when mapping the
 L1 VNCR page
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260801124818.366274-4-maz@kernel.org>
References: <20260801124818.366274-1-maz@kernel.org>
 <20260801124818.366274-4-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 01 Aug 2026 13:10:37 +0000
Message-Id: <20260801131038.09C3C1F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Acquiring `mmu_lock` (an `rwlock_t`) while preemption is disabled =
causes a sleep-in-atomic bug on PREEMPT_RT kernels.
--

--- Patch [3]: [PATCH 3/6] KVM: arm64: Consider SCTLR_EL2.M when mapping th=
e L1 VNCR page ---
commit 35765bd8ff67c3b2b00cff5d84e75d6902846a0f
Author: Marc Zyngier <maz@kernel.org>
Subject: KVM: arm64: Consider SCTLR_EL2.M when mapping the L1 VNCR page

This commit ensures the S1 MMU state is verified against the cached state
in the TLB when mapping the L1 VNCR page. If the cached state does not match
the current MMU state, the mapping is ignored to prevent inconsistent
translations.

[ ... ]

> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index b026d160f253d..711c0d0ff8339 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -1579,6 +1579,9 @@ static void kvm_map_l1_vncr(struct kvm_vcpu *vcpu)
>  	if (!vt->valid)
>  		return;

[Severity: High]
This isn't a regression introduced by this patch, but looking at the earlier
lines in kvm_map_l1_vncr():

arch/arm64/kvm/nested.c:kvm_map_l1_vncr() {
    ...
	guard(preempt)();
	guard(read_lock)(&vcpu->kvm->mmu_lock);
    ...
}

I noticed the order of these guards causes preemption to be disabled prior =
to
acquiring mmu_lock (which is an rwlock_t).

On Preempt-RT kernels, rwlock_t is mapped to an rt_rw_lock which is a
sleepable lock. Does acquiring it while preemption is explicitly disabled
trigger a sleep-in-atomic splat here?

Since this path is reachable by a nested guest's normal operations, could t=
his
allow an untrusted guest to panic the host kernel on a Preempt-RT system?

> +	if (!(vcpu_read_sys_reg(vcpu, SCTLR_EL2) & SCTLR_ELx_M) !=3D s1_mmu_dis=
abled(&vt->wr))
> +		return;
> +
>  	if (read_vncr_el2(vcpu) !=3D vt->gva)
>  		return;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260801124818.3662=
74-1-maz@kernel.org?part=3D3

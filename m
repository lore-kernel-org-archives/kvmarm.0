Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 098543D667D;
	Thu,  6 Aug 2026 09:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786008448; cv=none; b=AThuZ6mGOhwKb5a1sF4eotgPG6Fgz6ZKsGWF3NK4/vfdKcq06Akna4FotPMDJPTpHzaTq+C6GvYSCona5ZaEdLgOy/DNzchrCHuggFg0ORxmQikyf0D6PDMLGpcvbapRZ7gfzEG+VO9OhehiP4D52STk8ie1l3PDbJFQZHcfgEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786008448; c=relaxed/simple;
	bh=A7uw6ZaklIRoMnNaapHDKzCcho9DfGQ+FF25o6Z51Uc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=GfmB3LLQs7RRNAyQDyPWJV8wUJzA31+6Zx72jVlboXBCIU2/YfROn6q5oHJgGT1kjuyQWj61zLr/YK6gJdc8rvFKhcD9/dZTDc9nAHsOoj7qbDLgBycPDDiq4r2h8JsdHmq2m7zPWYlo97Fcz1co5E29ZTQbzMlTKInjbKbJwGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QPHRYxjR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QPHRYxjR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5547F1F000E9;
	Thu,  6 Aug 2026 09:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786008446;
	bh=PWF6Z3Yq+cfbAu/vHrp0lUmmHWObGLgBRyiV8Ie7B+E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QPHRYxjRWku8bxMScarj7M+qAC+R0wRv6MEQJImykjYXYImV5QYu8iWNEWSGvE6O5
	 x8rU4AI/EXgE1D9FF9IO4vqGpYbV25HPpaochfGZPTwAFijm/e/h9fkiBv7ik/NqkC
	 8pV796P+0FG/EoQ1SKAoq52o/axuv71Popkm8Jmy6/bWW0Gj3zIw2i0OB24Uc5S3Yf
	 EsWNeBknpIf4bEx4uDg0o+jcTyhTvJ4g5OIdwsfWhscyu52rBK2BdvJAats/8V3Ar8
	 D3HKJ3A3QHltsNIJITb8ckR0ufhPQbaQj9bdAem0BLF3hpE4jrv9WCyJbcsHyJ+aTW
	 Cz+aA+LTukCNw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 3/8] KVM: arm64: Consider SCTLR_EL2.M when mapping
 the L1 VNCR page
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260806091026.620700-4-maz@kernel.org>
References: <20260806091026.620700-1-maz@kernel.org>
 <20260806091026.620700-4-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 06 Aug 2026 09:27:25 +0000
Message-Id: <20260806092726.5547F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Acquiring `mmu_lock` while preemption is disabled causes a 'sleepi=
ng in atomic context' BUG on PREEMPT_RT kernels.
--

--- Patch [3]: [PATCH v2 3/8] KVM: arm64: Consider SCTLR_EL2.M when mapping=
 the L1 VNCR page ---
commit 20af1a04bc308d515b8afd3fe9909a21ff7706cb
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: Consider SCTLR_EL2.M when mapping the L1 VNCR page

We record a VNCR TLB even when SCTLR_EL2.M is 0 in order to make
our life easier. But this is not something that the architecture
anticipate.

[ ... ]

> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index b026d160f253d..939813aebaafa 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -1579,6 +1579,10 @@ static void kvm_map_l1_vncr(struct kvm_vcpu *vcpu)

[Severity: High]
This is a pre-existing issue, but looking at the beginning of
kvm_map_l1_vncr():

static void kvm_map_l1_vncr(struct kvm_vcpu *vcpu)
{
	...
	guard(preempt)();
	guard(read_lock)(&vcpu->kvm->mmu_lock);
	...

Can acquiring mmu_lock while preemption is disabled cause a sleeping in
atomic context warning on PREEMPT_RT kernels?

Since rwlock_t is sleepable on RT, does this sequence need adjustment to
avoid panicking the host during nested virtualization execution?

>  	if (!vt->valid)
>  		return;
> =20
> +	/* We cache the MMU state in the TLB. Check that it matches. */
> +	if (!!(vcpu_read_sys_reg(vcpu, SCTLR_EL2) & SCTLR_ELx_M) !=3D s1_walk_t=
ranslated(&vt->wr))
> +		return;
> +
>  	if (read_vncr_el2(vcpu) !=3D vt->gva)
>  		return;
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260806091026.6207=
00-1-maz@kernel.org?part=3D3

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FFB814ABE
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 23:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781827054; cv=none; b=j7aWYS43iAAGn0I5OFET/UUsIl2sgMjJV8Q1xtSQ14e/mK7wa2tl75zTplkWgF80l4PIpECEHLkXoZb/vMLDd0M8YGYZ/BRHOerFBea1L7148EfaeXBWFWRV8sNhOmcNWwlxeOfr3zA4cOxW1pOwvBf2KwS0NohgMCfsSjzJBvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781827054; c=relaxed/simple;
	bh=VnUr3M7+PVmlplQ87wva8vyYNbdEbv1oxYPz19Otni8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=L5UDutKtD7yp5zmkp71o0lUF5DptyDK3nOZ+Y2QmYDExX107km7Hv3f8u94PbyKf/MdNwO4tJzOh3xg+lZJApJMV3YBpCzezS1dJzEDOhGhOj3eRwMbNRQMyJW11L6B1SPFgto0PLYf1VBXe500526tfkWo2BB0alord1/JtaZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nG1yOE15; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nG1yOE15"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 197C01F000E9;
	Thu, 18 Jun 2026 23:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781827053;
	bh=8GKqA+4Lr7cjUc/AzyepH5069Ts+/Nd0/J0UTDV2fTU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nG1yOE15C38DJY+y5SgynsF8DMkWbnplqwrSMymuyQVzwUN2WLpiGDmR8CbA3nkdg
	 kMD3k2O0VgmoVorlFR9mmuy+WI77nc2j2K8+SXbsuA1SnmYXPcgwjJUAZSWfhpAQuk
	 Q3I6ZSs9IrDuQPk0KeaUS3BC2zwKp9aycQLsxlkgKCeSmSVVI1QCKbUqA2qs4OJUk+
	 xZFGzpQoLFGLNFfRMRTWzL1BzTVxEKiTYuEoYTB4oA7XOge0Cay9pKRdyjqEebsmi8
	 vGTPDhwKdcyLBMEsjilYA87i/kRjaCamov2TAzvK5GwI90q8O7sUnQuPlwjvc8UImI
	 0S9S5+bTEAHlg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/5] KVM: arm64: nv: Inject SEA if
 kvm_translate_vncr() can't resolve PFN
Reply-To: sashiko-reviews@lists.linux.dev
To: "Oliver Upton" <oupton@kernel.org>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260618234207.1063941-3-oupton@kernel.org>
References: <20260618234207.1063941-1-oupton@kernel.org>
 <20260618234207.1063941-3-oupton@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 18 Jun 2026 23:57:32 +0000
Message-Id: <20260618235733.197C01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] Unhandled guest_memfd errors ignore prepared memory fault exits an=
d inject malformed guest exceptions.

Pre-existing issues:
- [High] Host-side PFN resolution errors (e.g., SIGPENDING, HWPOISON) are s=
ilently converted into guest Synchronous External Aborts (SEA).
--

commit 68bfda7f1617f64f7121c49b477f4cf4e33b2e10
Author: Oliver Upton <oupton@kernel.org>

KVM: arm64: nv: Inject SEA if kvm_translate_vncr() can't resolve PFN

This commit updates kvm_translate_vncr() to prepare an external abort
when failing to resolve a PFN instead of returning -EFAULT and relying
on kvm_handle_vncr_abort() to BUG_ON() or correctly guess the failure.
It drops the BUG_ON() in the abort handler to safely inject the SEA.

> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 903ccabca78c5..53dea9c3f14f8 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -1395,15 +1395,19 @@ static int kvm_translate_vncr(struct kvm_vcpu *vc=
pu, bool *is_gmem)
> =20
>  	gfn =3D vt->wr.pa >> PAGE_SHIFT;
>  	memslot =3D gfn_to_memslot(vcpu->kvm, gfn);
> -	if (!memslot)
> +	if (!memslot) {
> +		fail_s1_walk(&vt->wr, ESR_ELx_FSC_EXTABT, false);
>  		return -EFAULT;
> +	}
> =20
>  	*is_gmem =3D kvm_slot_has_gmem(memslot);
>  	if (!*is_gmem) {
>  		pfn =3D __kvm_faultin_pfn(memslot, gfn, write_fault ? FOLL_WRITE : 0,
>  					&writable, &page);
> -		if (is_error_noslot_pfn(pfn))
> +		if (is_error_noslot_pfn(pfn)) {
> +			fail_s1_walk(&vt->wr, ESR_ELx_FSC_EXTABT, false);
>  			return -EFAULT;
> +		}

[Severity: High]
This is a pre-existing issue, but does this improperly convert host PFN
resolution errors into guest aborts?

If __kvm_faultin_pfn() encounters a pending host signal or poisoned memory,
it can return KVM_PFN_ERR_SIGPENDING or KVM_PFN_ERR_HWPOISON. These are
caught by is_error_noslot_pfn().

By calling fail_s1_walk() and returning -EFAULT here, kvm_handle_vncr_abort=
()
will inject a Synchronous External Abort (SEA) into the guest instead of
returning to userspace. Will this cause a simple host signal to randomly
crash the VM and break host HWPOISON recovery?

[ ... ]

> @@ -1530,8 +1534,6 @@ int kvm_handle_vncr_abort(struct kvm_vcpu *vcpu)
>  			 * Translation failed, inject the corresponding
>  			 * exception back to EL2.
>  			 */
> -			BUG_ON(!vt->wr.failed);
> -

[Severity: High]
Does removing this BUG_ON() unmask an issue when kvm_gmem_get_pfn() fails
with -EINVAL, -ENOENT, or -EACCES?

In kvm_translate_vncr(), if kvm_gmem_get_pfn() fails, it prepares a memory
fault exit for userspace and returns the error code without calling
fail_s1_walk().

Because kvm_handle_vncr_abort() lacks an 'if (is_gmem) return 0;' check for
-EINVAL, -ENOENT, and -EACCES, it will fall through to the exception inject=
ion
path below. Since vt->wr.fst is uninitialized (0), won't KVM ignore the
prepared memory fault exit and inject a malformed exception (FSC=3D0) into =
the
guest?

>  			esr &=3D ~ESR_ELx_FSC;
>  			esr |=3D FIELD_PREP(ESR_ELx_FSC, vt->wr.fst);
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260618234207.1063=
941-1-oupton@kernel.org?part=3D2

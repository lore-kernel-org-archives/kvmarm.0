Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B5863CB
	for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 00:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781827236; cv=none; b=aL8S7ab88NiKRtRzaXR/ZqJAe7aB59kshbMRD5BdtGqjr4Y7KdiBunoJqGl92y6g3O/UnzAvDm2eYB0vke/DDYEph/ozxMSffPKarFsSZZFUfCUOqrkqdBRgN+rSwSVnRiOGWomqhY9ERHd10AbWdr9qA/O1W//szRjpQ63fgZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781827236; c=relaxed/simple;
	bh=lZP1c6WuTi9gsInnLk6zW0ES9uEGox/IW3IUoZc3gNo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hhvj4W27E1yVtKFHSABfbLErl8TnRWCT6mytDnym5V9FS/V2ROzPXb8pU74BU9eAK9bnS1wSTdPE2NCRtY+9c+CaS8WVDmp/1sCLOUtQ1Qu+bczARPnk+GaFursmkwATUQODp5a9EjalzQsejz+2LhhtLq57tHx040QWDnM+PCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S/iJlBfL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S/iJlBfL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F2511F000E9;
	Fri, 19 Jun 2026 00:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781827234;
	bh=D8dT7VmTyw+Tv2U0vLdUa9cJl6ZlFJMBjKINVCVWJ/Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=S/iJlBfLgSUggj0BxIjmc6ctnv4RLbAkArReQAXTE4eFvZjbVeKvqZA/W/nTrUp4G
	 afogEAv/KI3n4mBp+CgxSj/QkYFHO0YYVnW9um9LKS+eyzgBEDBywPXbQLOQ8xZ6pZ
	 YI/PKeFY1M5oCmY8DHCmrMtdlN+P0R24wjJX40j3iPxTOyyLx0h2EKFqjK2RBzs2r3
	 WZJBcKxgLDjU4zZ0F9AjXI/Fn5ecm2972r2XjeAeg70Ele8vU2r52kHQScWGrPB8gG
	 HkaqcFwZNPgOuHHTM577La3AMkmOmo86+uwwrOuUb9/au5dbewfePcSnJ/XNLJz+Pf
	 Zj2qcKOjCpzQg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 3/5] KVM: arm64: nv: Re-translate VNCR before
 injecting abort
Reply-To: sashiko-reviews@lists.linux.dev
To: "Oliver Upton" <oupton@kernel.org>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260618234207.1063941-4-oupton@kernel.org>
References: <20260618234207.1063941-1-oupton@kernel.org>
 <20260618234207.1063941-4-oupton@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 19 Jun 2026 00:00:33 +0000
Message-Id: <20260619000034.7F2511F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] Guest Stage-1 permission faults on VNCR are incorrectly promoted t=
o External Aborts when backed by a read-only memslot.
- [High] Removing the `kvm_vncr_tlb_lookup()` check introduces an infinite =
host CPU livelock for Write-Only guest VNCR mappings.

Pre-existing issues:
- [High] If `kvm_gmem_get_pfn()` returns `-EINVAL`, KVM drops the prepared =
userspace memory fault exit and injects a bogus nested exception.
--

commit 51cca6668ae197c096ae8a70f22546dc1a8163be
Author: Oliver Upton <oupton@kernel.org>

    KVM: arm64: nv: Re-translate VNCR before injecting abort
   =20
    KVM faults in the VNCR page with FOLL_WRITE whenever the guest aborts
    for a write, similar to how a regular stage-2 mapping is handled. It is
    entirely possible that the guest reads from the VNCR before writing to
    it, in which case the PFN could only be read-only.
   =20
    Invalidate the VNCR TLB and re-fetch the translation upon taking a VNCR
    abort, allowing the host mapping to be faulted in for write the second
    time around. Interestingly enough, this also satisfies the ordering
    requirements of FEAT_ETS2/3 between descriptor updates and MMU faults.

> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 53dea9c3f14f8..7fffd86eee944 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
[ ... ]
> @@ -1466,88 +1466,61 @@ static void handle_vncr_perm(struct kvm_vcpu *vcp=
u)
[ ... ]
> +	ret =3D kvm_translate_vncr(vcpu, &is_gmem);
> +	switch (ret) {
> +	case -EAGAIN:
[ ... ]
> +	case -EFAULT:
> +	case -EIO:
> +	case -EHWPOISON:
> +		if (is_gmem)
> +			return 0;
> +		fallthrough;
> +	case -EINVAL:
> +	case -ENOENT:
> +	case -EACCES:
> +		/*
> +		 * Translation failed, inject the corresponding
> +		 * exception back to EL2.
> +		 */
> +		esr &=3D ~ESR_ELx_FSC;
> +		esr |=3D FIELD_PREP(ESR_ELx_FSC, vt->wr.fst);
> =20
> -			kvm_inject_nested_sync(vcpu, esr);
> -			break;
> -		case -EPERM:
> -			/* Hack to deal with POE until we get kernel support */
> +		kvm_inject_nested_sync(vcpu, esr);
> +		break;

[Severity: High]
This is a pre-existing issue, but if kvm_gmem_get_pfn() fails and returns
-EINVAL, -ENOENT, or -EACCES, does this branch bypass the userspace exit?

If those errors are returned, they skip the is_gmem check because they bypa=
ss
the fallthrough block above. Instead of returning to userspace, KVM handles
them by injecting a nested exception back to the guest using an uninitializ=
ed
or stale value in vt->wr.fst. Does this destroy the memory fault exit state
and inject a bogus exception?

[ ... ]
> -			handle_vncr_perm(vcpu);
> -			break;
> -		case 0:
> -			break;
> -		}
> -	} else {
> -		WARN_ONCE(1, "Unhandled VNCR abort, ESR=3D%llx\n", esr);
> +	case 0:
> +		perm =3D kvm_is_write_fault(vcpu) ? vt->wr.pw && vt->hpa_writable : vt=
->wr.pr;
> +		if (!perm)
>  			handle_vncr_perm(vcpu);
> +		break;
>  	}
> =20
>  	return 1;

[Severity: High]
Does removing the -EPERM loop breaker introduce a host CPU livelock for
Write-Only guest VNCR mappings?

If the guest configures a Write-Only mapping, kvm_map_l1_vncr() falls back
to mapping it as PAGE_NONE. When the hardware accesses the fixmap, it trigg=
ers
a Data Abort. KVM then traps and re-translates the mapping.

Because vt->wr.pw is true, the perm check evaluates to true, and KVM return=
s 1
to resume the guest instead of injecting a fault. The hardware will then fa=
ult
again indefinitely.

[Severity: High]
Also, does calling kvm_translate_vncr() unconditionally request FOLL_WRITE
on a write fault without verifying if the guest's own Stage-1 mapping
actually permits writes?

In kvm_translate_vncr(), __kvm_faultin_pfn() is called with FOLL_WRITE if i=
t's
a write fault. If the host memslot happens to be read-only, __kvm_faultin_p=
fn()
fails and returns -EFAULT.

This error bubbles up to the switch statement above, which injects an Exter=
nal
Abort into the guest. Should the guest instead receive a Stage-1 Permission
Fault if its own Stage-1 translation does not permit writes, regardless of =
the
memslot permissions?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260618234207.1063=
941-1-oupton@kernel.org?part=3D3

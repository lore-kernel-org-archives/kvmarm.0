Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BEBC28373;
	Mon, 22 Jun 2026 17:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782148203; cv=none; b=oqAnpgcqAqr7QJHnlUL+Ask7zodx6leN6DZLYgsGHbe6q/I8BDlJCeUuvE2UYvl4ffCgvkzTY4MwfKu0BF38EQP8jpeYXnuhbeHpzl8LBYa4G5dIHCBG+vkcJ7D6xPCfqVCXmZoivQaDlg/llAVJ8ZWsk8YJNcRWVym4auqLfBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782148203; c=relaxed/simple;
	bh=5/h5elIbKsKcQMM9MRMA2ovhjrwqPWyv+QGmSfKJvmQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aGhyXf79dYDzJfHOfwbwT4HNOSH/D+09PBQ1ny9/VdI7bZB2NN3Vg/RCPDGP9kXGqiKRjfNipB1uqX99XEprPrBy6yL0w6Wt4dzuow/RLKt+9in+BS5cZYw4ICf3Kjt0pnvXTHEr7a2OL37xW0z0jgzQxUNPd5g9SofahvDjsqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DlFdklDC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DlFdklDC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10CA51F000E9;
	Mon, 22 Jun 2026 17:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782148202;
	bh=JFDD7SfNV52tNiCqZ8At5/zQRJGbjXaPTa/sGj3uSVg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DlFdklDCsaw8IX3W+KNXjjok9zRTQYkcQGoJXnI/d5qdbkFfe9MwnJ6axk/p8VaJ/
	 gNTBp0jPvTpc1jEl2BzN5UW7IFV5em5zMHExC/+X1hFpBmTqboGbQHG3Tnon3EJsDG
	 ZCID8PXTxEpSfWTusXw0ZT2Mj1+K3nNfAqiFvXS0y4NMdb3LH5U/rp/Lfa8fajloSS
	 /9jVlMkMV1+6xTKu3ksu6o+blqy0x5fHudQliOiuFuuD9ImTvxbPRvtnmxKY/7YoT2
	 T/mXAQyUKt1gwFgmomAlQr9pUTB2Wf0OhdwHZGSF8LBzsK6p9+gDrnski9U6qYAvpI
	 aeHLrrxFGSTGA==
Date: Mon, 22 Jun 2026 10:10:00 -0700
From: Oliver Upton <oupton@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 1/5] KVM: arm64: nv: Respect read-only PFN when
 mapping L1 VNCR
Message-ID: <ajlsaD5uidI_mWWg@kernel.org>
References: <20260618234207.1063941-1-oupton@kernel.org>
 <20260618234207.1063941-2-oupton@kernel.org>
 <20260619000703.89F731F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260619000703.89F731F000E9@smtp.kernel.org>

On Fri, Jun 19, 2026 at 12:07:03AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> 
> Pre-existing issues:
> - [High] KVM injects an External Abort instead of a Permission Fault when a guest accesses a read-only memslot via VNCR with guest stage-1 write protections.
> --
> 
> commit be3537f8a87d3f507b2b54b34084b37b1630155a
> Author: Oliver Upton <oupton@kernel.org>
> KVM: arm64: nv: Respect read-only PFN when mapping L1 VNCR
> 
> This commit updates KVM to cache the writability of the PFN in the VNCR
> TLB to constrain the resulting fixmap permissions. It also promotes VNCR
> permission faults to a Synchronous External Abort (SEA) when the guest
> attempts to write to a read-only endpoint.
> 
> Link: https://lore.kernel.org/kvm/20260608082603.16AEC1F00893@smtp.kernel.org/
> 
> > diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> > index 3a5571c3c1142..903ccabca78c5 100644
> > --- a/arch/arm64/kvm/nested.c
> > +++ b/arch/arm64/kvm/nested.c
> [ ... ]
> > @@ -1401,7 +1402,7 @@ static int kvm_translate_vncr(struct kvm_vcpu *vcpu, bool *is_gmem)
> >  	if (!*is_gmem) {
> >  		pfn = __kvm_faultin_pfn(memslot, gfn, write_fault ? FOLL_WRITE : 0,
> >  					&writable, &page);
> > -		if (is_error_noslot_pfn(pfn) || (write_fault && !writable))
> > +		if (is_error_noslot_pfn(pfn))
> >  			return -EFAULT;
> 
> [Severity: High]
> This is a pre-existing issue, but does this leak host memory configuration
> to the guest by incorrectly prioritizing an External Abort over a Permission
> Fault?
> 
> When a guest takes a VNCR write fault, this code unconditionally requests
> FOLL_WRITE from __kvm_faultin_pfn() without checking if the guest's
> stage-1 page tables actually permit writes (vt->wr.pw).
> 
> If the backing host memslot is read-only, __kvm_faultin_pfn() fails and KVM
> returns -EFAULT, which ultimately causes KVM to inject a guest External Abort
> (ESR_ELx_FSC_EXTABT). Architecturally, if the guest's stage-1 translation
> lacks write permission, the guest should receive a Stage-1 Permission Fault
> regardless of the host's physical memory permissions.
> 
> Could this cause unexpected guest panics if the guest OS relies on handling
> Permission Faults gracefully before the host RO mapping is enforced?

The goal here is to have a localized, stable-worthy fix to plug a nasty
bug that allows the guest to bypass host permissions. A fix for the
fault prioritization can be done later, ideally as part of a more
significant cleanup to the whole VNCR handling.

A guest is far more likely to use normal memory (i.e. in a RW memslot) for the
VNCR page anyway.

Thanks,
Oliver

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18203359A91;
	Tue, 23 Jun 2026 20:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782245105; cv=none; b=f3owjIYUNYaTK6ZqCNPlfwIXW3bbrV7NbS1iy3vJGMwxDHCRZqXWhfRUdXW646sqHoGHQqyND8U0+ztgE6aJSDm2/b4XP0+59JkUulRykcYfnyoqKupdT1Iw6umZ59SDjUgrU0Cj4DTmJTZNVutlqsJdbEaGC0V1Ftsl0nuYEbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782245105; c=relaxed/simple;
	bh=WXTJvS8nTBoZayCCQ1UkDdbyJOKhq3Upt7bB2bWi/yA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u7K7gbL8stmPl6kB7NG3m0VaRlZ2PGm4hgqvBjkMf4rtB5jh3FtltZ5NW1QrnP/ffddGVeMcPEdpfMSdPM4XLe8RzR+IKf+ToI6ZNO9pauXkR4poCNIYn+Lq9RPywuvRPvp+JkySCRv/lHKQSxsD1F0fEttoSIaSNoEdr5mZGgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QrUYuk7L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QrUYuk7L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDC7B1F000E9;
	Tue, 23 Jun 2026 20:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782245103;
	bh=HPChuZ1mWnlDaBUCXDkMUFJwjArhwD0pAA7GS75DrHo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QrUYuk7Lz4ZAxRyzXVeEw/m13CLKqUUEVuTEpKJIzfQ52UulJ0PEOLLUv3L6YUKZ4
	 VeSa5uQAWapb9/q0sIn+EyX3sscGxrg2mCDHKdyaTHMF3j/nzeC+MCTp5KEq6NqKjk
	 MHQ31wF4IWmxMd4SbkYwoYh0NiqLwafSWYG/PNagfuv0mPFtagoVLDsy+UayEmmcWW
	 joCSflrovj0JzFe2/grT80q8w/NK2fH+3m4MkycXHioBF2G+IZKcRO9XznJ4kgmQxs
	 38luD68JUaYvQgAGFeAHeSurzzmq8qXaY5zGKZDLbnZEDXnciYw+iGWIjPOBS0fi7h
	 bqCv0zZcqygVQ==
Date: Tue, 23 Jun 2026 13:05:02 -0700
From: Oliver Upton <oupton@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 04/22] KVM: arm64: nv: Only shadow writable-dirty guest
 descs as writable
Message-ID: <ajrm7rc4WjemIBxE@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org>
 <20260623184201.1518871-5-oupton@kernel.org>
 <20260623185810.08CC61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260623185810.08CC61F000E9@smtp.kernel.org>

On Tue, Jun 23, 2026 at 06:58:09PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> 
> New issues:
> - [High] Uninitialized or incorrectly evaluated `wr->dirty` field during Stage-1 page table walks causes an infinite VNCR trap loop.
> 
> Pre-existing issues:
> - [High] Write-Only VNCR mappings cause an infinite trap loop because KVM falls back to `PAGE_KERNEL_NONE` but considers write faults resolved.
> --
> 
> commit fb5a66a1eb4ac6175aad6cbbd38f45328f4f937b
> Author: Oliver Upton <oupton@kernel.org>
> 
> KVM: arm64: nv: Only shadow writable-dirty guest descs as writable
>     
> KVM will soon add support for hardware dirty state management for nested
> guests. In order to emulate dirty state transitions on the guest
> desciptor, KVM will need to use read-only hardware mappings and re-walk
> the guest page tables upon taking a permission fault.
>     
> Prepare by limiting shadow stage-2 and shadow VNCR translations to
> read-only for writable-clean guest translations.
> 
> > diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> > index 86b499e7a9a06..7a84495a2e6d4 100644
> > --- a/arch/arm64/kvm/at.c
> > +++ b/arch/arm64/kvm/at.c
> [ ... ]
> > @@ -1317,6 +1317,7 @@ static void compute_s1_permissions(struct kvm_vcpu *vcpu,
> >  			  (pan3_enabled(vcpu, wi->regime) && wr->ux));
> >  	wr->pw &= !pan;
> >  	wr->pr &= !pan;
> > +	wr->dirty = !(wr->desc & BIT(7));
> 
> [Severity: High]
> Could the unconditional use of BIT(7) here cause issues when S1PIE is
> enabled?
> 
> With S1PIE, BIT(7) becomes PIIndex[3], so using it to evaluate the dirty
> state might be incorrect.

Bit 7 is nDirty when using indirect permissions, so this is wrong.

Thanks,
Oliver

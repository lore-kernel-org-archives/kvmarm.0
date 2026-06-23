Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F6313790B;
	Tue, 23 Jun 2026 20:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782245845; cv=none; b=DkyOuR4xBwpTBmgGYDBqKpJaarsH0WxyFqa0fUuGd+sSVZZ7QPuf8QRcj+ZvSZ3/TGnBPdIbq4Rwx7swRV0NrHzG0sTEpkNzJQxlnJ0nAZVHuVIyWvryask5CPxLHZmvnnSLkIGHD1f0k4fmncJGm++J1lX951DfdYtEbNPzWZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782245845; c=relaxed/simple;
	bh=VpHBiKtXrZDHf+F3uZs41SenJUJZp6kT3puuFnBCCek=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LR1E5Sh47IWvIv96FT/2TsH742BXwQuemyRa3KrJ6dKG2rfjv9EJ2bwhfgesPjZ5bxPDZrYWDZ3PcbovmSVGWC7A7ptrmIupjVHDO6tP1raJQK6xHEUkp8TSWquYsORhBGB78DXZiDG6JkJduwdq48yNyCZTckzyq+1QUftzMHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bg2HRMiq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bg2HRMiq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E7041F000E9;
	Tue, 23 Jun 2026 20:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782245844;
	bh=uMjp7h2KVgpzawF7sRk1P9s/hw5ch8yKOiSbSMFF6XM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bg2HRMiqcWlD2g9ZF1wVvqbT6QQ5YeRdndmPkNzA9ERvXnd+/ngiPHupwfptp6Y9D
	 c14K1EoQYGT8hcZFlvbtzw3jJkVzWpVBh8q3t8TQXWjd1YX67AjeADgaKL6pMW03mn
	 KIvK0NTvbadU8cCKebyx34wCrYm1P1KhBDGx1Z9euqpwcKrxGPdm78GJ6aSKyIYitw
	 3SDB8uPhweghUsWb6b3+kT/YZYIMyYUzGJcQYFfnE99BVyL4wCDod3VyeZMMlSVpsO
	 pzXj2H8OCg1Osx38vmwOalfcLAfv6JUAA/3XqrtqnonSSKFJonegcDr78Cu5mJJEey
	 O1L37vtJ5qXzw==
Date: Tue, 23 Jun 2026 13:17:22 -0700
From: Oliver Upton <oupton@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev
Subject: Re: [PATCH 21/22] KVM: arm64: selftests: Test AT emulation for
 FEAT_HAFT
Message-ID: <ajrp0kEFvyMvWci1@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org>
 <20260623184201.1518871-22-oupton@kernel.org>
 <20260623190541.17C0A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260623190541.17C0A1F000E9@smtp.kernel.org>

On Tue, Jun 23, 2026 at 07:05:40PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [Medium] Missing `isb()` instructions between consecutive writes to control-plane system registers.
> - [Low] Typo `sysrec_clear_set_s` instead of `sysreg_clear_set_s` causes a build failure.
> --
> 
> commit 72540780d6ff6cb4b6ed1c45760fb4372cfa7e9b
> Author: Oliver Upton <oupton@kernel.org>
> 
> KVM: arm64: selftests: Test AT emulation for FEAT_HAFT
> 
> Test that KVM's AT emulation sets the access flag on table descriptors
> when FEAT_HAFT is enabled at stage-1. Additionally, add test coverage
> that asserts the access flag is clear on table/page descriptors when the
> AT instruction generates an access flag fault.
> 
> > diff --git a/tools/testing/selftests/kvm/arm64/at.c b/tools/testing/selftests/kvm/arm64/at.c
> > index d7289f3df04fa..fb7399736f442 100644
> > --- a/tools/testing/selftests/kvm/arm64/at.c
> > +++ b/tools/testing/selftests/kvm/arm64/at.c
> 
> [ ... ]
> 
> > @@ -93,9 +103,43 @@ static void guest_code(void)
> >  	isb();
> >  	test_at(false);
> >  
> > +	if (!guest_has_haft())
> > +		GUEST_DONE();
> > +
> > +	sysrec_clear_set_s(SYS_HCRX_EL2, 0, HCRX_EL2_TCR2En);
> 
> [Severity: Low]
> There is a typo here: sysrec_clear_set_s instead of sysreg_clear_set_s.

Oops!

> > +	sysreg_clear_set_s(SYS_TCR2_EL12, 0, TCR2_EL1_HAFT);
> 
> [Severity: Medium]
> Does this sequence need an isb() between the register updates?
> 
> Updates to control-plane system registers must be synchronized with an
> explicit Context Synchronization Event before any subsequent sysreg accesses.
> Because sysreg_clear_set_s() performs reads, issuing back-to-back calls
> without an intervening isb() causes the second access to execute against an
> architecturally undefined pipeline state.

This is wrong, direct reads / writes of a system register through the
same alias appear in program order.

Thanks,
Oliver

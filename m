Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755E717C96;
	Tue,  4 Jun 2024 20:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717533757; cv=none; b=n/ebQ5E5Mau9bzSfr3esnRfro+PWm9JBB9QltVHY03M2cVF4cSh8FX9cU3Rnz16hhfQx1oj84bxi8qZz8h9SxwGhdHtYLKLNRZ//kp1xxj5nhNVI88+/L4szJ13gJql+oUkgJECfWVcrmmaB3cXvhbN2hlnuCTQ4chN115JOzwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717533757; c=relaxed/simple;
	bh=uQLOOzbWqSKTADuADTiMo4MekQ86BWWGFWy1aSoS7xQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yr0bD/FfU6jjjjdROtDYe3TBYG17JQ+c6p7isdwRWPmRe8L+8751C+Zj3VBF/jNhASsud1W9CfGHMpy4eO2AtRvP4DtmnyQKmypO1RGk9/uoGzOZQMK83vjJE4wzOEAeYeQn2Eo3u/PfN5MUYDY+GYjxoBj78h8/R0Ae/oowJhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OYUkD4Us; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OYUkD4Us"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA435C2BBFC;
	Tue,  4 Jun 2024 20:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717533757;
	bh=uQLOOzbWqSKTADuADTiMo4MekQ86BWWGFWy1aSoS7xQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OYUkD4Usqn60C9R0lp44HfgE+h1mDo/yoEBsBIJcUlLvoY5rom3AxalWO2O5Eqo5Z
	 5ZJnN4EKNnZvEklMlJhgclPLHS4aGSSJJAE/U6sNUUG0CYnaO+P7pqeHAuPHhZhEwx
	 nCeZepAhMjTgd5a3yBV7XYXk9R3U02rzSm90Q2QSdKmb0Ls4HocmtluAF/AEjbdRR/
	 zwWif3NWxk+ZQMRLo0YZgWblL/TBYEbbU23hT1AyeBOcYKGY/SEVp8wuwln5udszDN
	 8z+Z/jZJuA4ndvxwPaBuhcqvn3QtWBNreVmC9gtC2cAd2x/QB8AI9vvC94Q7BFEXyX
	 YbAoTwaE8h/Vw==
Date: Tue, 4 Jun 2024 21:42:31 +0100
From: Mark Brown <broonie@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Fix confusion in documentation for pKVM SME
 assert
Message-ID: <97fab321-21fb-40cd-b90e-daf42b5db62e@sirena.org.uk>
References: <20240604-kvm-arm64-sme-assert-v1-1-5d98348d00f8@kernel.org>
 <Zl9oVUriFDYbLFW8@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="OssUhU3cRSMRch4o"
Content-Disposition: inline
In-Reply-To: <Zl9oVUriFDYbLFW8@linux.dev>
X-Cookie: Is it clean in other dimensions?


--OssUhU3cRSMRch4o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 04, 2024 at 12:17:41PM -0700, Oliver Upton wrote:
> On Tue, Jun 04, 2024 at 07:47:01PM +0100, Mark Brown wrote:

> > As raised in the review comments for the original patch the assert and
> > comment added in afb91f5f8ad7 ("KVM: arm64: Ensure that SME controls are
> > disabled in protected mode") are bogus. The comments says that we check
> > that we do not have SME enabled for a pKVM guest but the assert actually
> > checks to see if the host has anything set in SVCR which is unrelated to
> > the guest features or state, regardless of if those guests are protected
> > or not.

> > What I believe the check is actually intended to validate is that we do
> > not enter the pKVM hypervisor with SME enabled since the pKVM hypervisor
> > does not yet understand SME and is therefore unable to save or restore
> > host state with SME enabled, indeed attempting to save SVE state would
> > fault if streaming mode is enabled on a system without FA64 due to FFR.
> > Update the comment to reflect this.

> The added context likely isn't necessary in what winds up getting
> applied. Can this just directly state the WARN_ON() exists b/c the
> protected mode hypervisor doesn't know how to manage SME state?

It could definitely be briefer, I was being super detailed because I was
guessing between the intent being what the comment says or what the code
says, or if we want an assert here at all for that matter.  It seemed
better to be verbose.

> >  	WARN_ON(is_protected_kvm_enabled() && system_supports_sme() &&
> >  		read_sysreg_s(SYS_SVCR));

> While we're here, this should be WARN_ON_ONCE() or WARN_RATELIMIT() if
> we _really_ want some spam. But a single WARN ought to be enough.

Good point, and I agree that WARN_ON_ONCE is the better option.

> It'd be a good idea to also document why we're testing for SME state
> twice on the KVM_RUN path, as any WARN() in the hyp code is currently
> fatal. I'm guessing Fuad meant to have a non-fatal way of getting some
> debug information out.

Yes, this was one of the reasons I was unclear if the check or the
comment was the intention.  Possibly it's due to getting much better
diagnostics for a warning generated in the host kernel than an error
returned from the hypervisor when we try to run the guest?

--OssUhU3cRSMRch4o
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZffDcACgkQJNaLcl1U
h9DSkQf8CCVg3xupmEhXxr52ob2JwQvQsUfHWim7KvttAq/EtITOJlK3tovzZyv1
cIVLi8HGI0tgfLFUL5GEXj14V47etBLAWBJrMJWYTS6830EWjAr5nPKk3tMkDlke
9PpdWP4rKZcpD1G6Lw4MUobCOE1tkrLq9AI/y9ZNidpF9iGkB0+gr2NZWZk0uikR
hoZ06Dr3pNLzFVzBBehURrPVvWIk1ZaZnCQX/XlKrpAItMEiaNn1rNnStzC6hzbe
K0ap59Tu6icxcgRHjzAVTU8eRKhKa2+0pT95RFZWaJFfFnpkgeUvq61shLeV18Mo
ICb6001h8LqRoHRV44uEYU9fudLyag==
=r54Z
-----END PGP SIGNATURE-----

--OssUhU3cRSMRch4o--

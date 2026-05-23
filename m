Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B93026D4DD;
	Sat, 23 May 2026 14:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779547112; cv=none; b=t395PEiuw5Dm5v0Jt71iqF8O4MDS+KklwbaoTxxOq7B4NcsQbZTBQY5X6dQnYfiSuNIMyyEaaW2/usDL13PIwQLTvw10Th6TncvRq1tVFF5DYFwuYQzRTJl+awfTWQyNrKAodrIV8X+P3g0Y5jLyb9lqJUyDPvalQF34hx+zxDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779547112; c=relaxed/simple;
	bh=023tlZF12dovue6J00qht1wkoW76tnUZMaZYDyRarQM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NoO7ZykK32r8WCvioNWh3gQr7VrmIf4aJIc0abiQ3utLJwsyOj4xY2TgZWCgh2MgPXbA9T9QCNMpJyf8Chi4fiXAuw2LSH9MaInb4a+xzIl8rDzfglt8Z3Dw+05LKF+eLRvvtj6Kn/RIOWGgPDuXBLDhOKDY3kdxstjZmbKqeC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KcoMatwx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KcoMatwx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20ABD1F000E9;
	Sat, 23 May 2026 14:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779547111;
	bh=/+ubvDUlSsvQcamv6R6/8JNc1sEXNBLDKT0SjoQyXvM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KcoMatwxjKddir3IoKztxEj1GkTKlI9B5yeKq8fTprt/TMC7Dz7ZbiTzP6NKuRXML
	 NpcfWdUBHoxrK2CNpmviC1IteTr1V8SCcGf65drd7glqzYhluE5NreS/CXC9MaS0hf
	 jAr228hK1ElQnPhI9MHXrQg1Eo6SsWcF0NOho+MWcGEQ0qC/oTZZIbaBG1CTzu4uNM
	 X5aGux7w36uixb7IMB47COOBphy1CcLRWZ48tYae4DIppHZnUuCilWEW57jOmBkCEN
	 Eq7smvv9A4vTqofgtSMeA9PX2IbOkkJQsOX5NwcKarL2wNNJgAvGEog3vG/TV53hBx
	 JG1PcXv6bwjyQ==
Received: by traversing.sirena.org.uk (Postfix, from userid 1000)
	id 31D2A3036D4; Sat, 23 May 2026 15:38:28 +0100 (BST)
Date: Sat, 23 May 2026 15:38:28 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Preserve all guest ZCR_EL2.LEN values
Message-ID: <ahG75BY6yvaePj-B@sirena.org.uk>
References: <20260522-kvm-arm64-fix-zcr-len-nv-v1-1-ec254e9078cf@kernel.org>
 <87h5nya4wl.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Fl2vJPm84SLt6fHJ"
Content-Disposition: inline
In-Reply-To: <87h5nya4wl.wl-maz@kernel.org>
X-Cookie: Don't hit the keys so hard, it hurts.


--Fl2vJPm84SLt6fHJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, May 23, 2026 at 09:47:38AM +0100, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > The reasoning for the current behaviour is not specifically articulated, my
> > best guess is that it is intended to ensure that the guest can not see an
> > effective VL greater than the maximum that has been configured. This can
> > instead be achieved by configuring ZCR_EL2 when loading guest state:

> >  - When running at EL0 or EL1 configure ZCR_EL2.LEN to the minimum of the
> >    guest ZCR_EL2.LEN and vcpu_sve_max_vq(vcpu)-1.

> This is not EL0 or EL1. This is when in a nested context (i.e. running
> a L2 guest), as EL0 exists for L1 as well.

Sorry, this was intended to be specifically for a L2 guest but didn't
actually say that.  I originally had more verbosity in the commit log
that I cleaned up too much, making things unclear.  I will clarify.

> > Currently all other bits in ZCR_EL2 are either RES0 or RAZ/WI, values
> > written are sanitised based on this.

> Only for the direct writes to ZCR_EL2, as they are trapping. I don't
> see any sanitisation for writes using the ZCR_EL1 accessor, which is
> the common case. This needs fixing at the same time.

OK, I'll convert ZCR_EL2 to a sanitised register.  As I mentioned I was
a bit confused about why the existing code is the way it is and so
followed it in only managing the direct writes.  I figured it was
considered OK to rely on the hardware for the RES0 and WI behaviour for
untrapped access.

> > -		if (is_nested_ctxt(vcpu)) -			zcr_el2
> > = __vcpu_sys_reg(vcpu, ZCR_EL2); -		else -
> > zcr_el2 = vcpu_sve_max_vq(vcpu) - 1; +		if
> > (is_nested_ctxt(vcpu) && !is_hyp_ctxt(vcpu)) +
> > zcr_el2 = min(zcr_el2, __vcpu_sys_reg(vcpu, ZCR_EL2));

> Why the change in the condition guarding this? Given the definition of
> is_nested_ctxt(), this seems unnecessary.

You're right, this change is not needed.  I had misremembered what
is_nested_ctxt() was checking.

--Fl2vJPm84SLt6fHJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmoRu9sACgkQJNaLcl1U
h9C/VAf8CHZI6LDLsoBR45fz935sHLDY6GBcMRErBG6zSvckEaREGCpajYeVTdTK
7GAi1UK0NMGWmS37NR6mIm745ua6rqg0Sxs+U0ZX83O38reW3XNtJWnnpXfk2nJ2
WZbUH35PBd0uaOQrKsCY0WxkS1Kmau/4Dx7GcUhS8orQl5PbCz7EVP6i1+IDjzai
yW6fCJk4o5TLrYJrgAzgvnup1U3tHEusmWQSo60pFOQ7lG+EPuwljWJ77ocXtlLT
7MYzk8cs2trZxO8oWT7Atu1tomCgDSdpXU9bZC24r/zzP3X83187ymk0yc34WD6x
+Fh+zTBHHV5neQDlJre0nVfezhQI2w==
=abUa
-----END PGP SIGNATURE-----

--Fl2vJPm84SLt6fHJ--

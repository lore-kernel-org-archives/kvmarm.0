Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 662DD4FD7AF;
	Tue, 29 Sep 2026 21:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790718425; cv=none; b=IcFjXF1+5LpbyPFCHXXzlza4KHMknhbD7xPQbli/DbqSbyWuAZkfMUsgJKox+SZDRJqCHsVgxBSzwre3UcioP9ejtTKZuX9o+NwKUaFpAyryfo/N4Q3jWKeBzWvKzXSqj8x/vLKVtmw4oPpxybQCGTptXxGfBtgzOUzClmM486w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790718425; c=relaxed/simple;
	bh=pzWPE/FsBXmNVTESJIsQmnK4rcy6psGCAwguo6i/EjQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IRMpbs9nF8kIXyh7mzZpgYl/XR2L1tcgsLWkE9xQLUnSnEiEhdfUQPePC5zoqVLObtyu8ryKyvw73CvJEqbltHZsPV9U90eSd3sVotx2GWPTuB6VHH+AdbNw6MpWQvzgKe0FR1LVJPo6WA5zZa7sJaZvgypWd5bcFxwe8sXiuWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bmi6EEbB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bmi6EEbB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DFC51F00893;
	Tue, 29 Sep 2026 21:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790718414;
	bh=UTwrgYZlPSkPGo6lYw20vGwlNY4gPjktN4L/m/Kq5rQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bmi6EEbB3m6fqmWSMAFijzYeY9vtF1RdlYWgmHHFBMrikKyKBUsXdwgSBoMPM7MiO
	 79Tp8UyPzJ1ar/uEbeEx7ZPZ1UdB+HPdWR0CEPWqWj4ZG1cZk4OhJ8alXQA4X/5Aog
	 QwrVo/CWz0+tF7k1A00gibR0MVl2rwX5u3ux/ziD2t/ca4A7m+Uc+vwXQyPH2TYDCy
	 L1jB8ycPzCYJRpsJMctqnWOb+vGEAQyyqQhEg5DrFlOHqBfApVKgBUBfUK6Z/1/dHX
	 /K97MwOt8xOG3I/o2DjmlIeGqiUzoIhOGYKlEuw20U3c9apw8FU2DSLO2j0Y0FM1T8
	 tnXPny1BJ+sZg==
Date: Tue, 29 Sep 2026 22:46:51 +0100
From: Mark Brown <broonie@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>, kvm@vger.kernel.org
Subject: Re: [PATCH v8 3/3] KVM: selftests: arm64: Make set_id_regs bitfield
 validity checks non-fatal
Message-ID: <fb5448a2-8d8a-4101-8964-6b08b5887eab@sirena.org.uk>
References: <20260929-kvm-arm64-set-id-regs-aarch64-v8-0-58aabe2c2fac@kernel.org>
 <20260929-kvm-arm64-set-id-regs-aarch64-v8-3-58aabe2c2fac@kernel.org>
 <20260929163445.0D9331F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="6BSZv4amUqQksatZ"
Content-Disposition: inline
In-Reply-To: <20260929163445.0D9331F000FF@smtp.kernel.org>
X-Cookie: 1 bulls, 3 cows.


--6BSZv4amUqQksatZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 29, 2026 at 04:34:44PM +0000, sashiko-bot@kernel.org wrote:

> >  	vcpu_set_reg(vcpu, reg, val);
>=20
> [Severity: Low]
> Does using vcpu_set_reg() here defeat the stated goal of making write
> validation checks non-fatal?=20

These are all ID registers so the register should always exist and be
writable, we'll need updates if we extend to non-ID registers but that's
out of scope for this test.

--6BSZv4amUqQksatZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmq8McoACgkQJNaLcl1U
h9Aj7wf/SM/VHq0aNl1s920wfr+FqgenDv3QwXQ47UuouubE+neUR1ENpW9RCybM
pEtpwHChpS4EBzycKQ3Lg6UdYtmBBLnW+5UGQWo2xgaDAEz5wmPii0oKcpxkBvIB
e9ChxWN6vXfApHdDL6iAFU8yeyVZRiRIJRfgkeDpaTwkFaB4PpL7CmOyTA7o0Ume
lM9lzjLTpGZ2m7W8TW4qB71YYU00qDajvdpLLjds870mI8n77lMCfMl+NQ5XTlKU
+8uD1NHH8ULFc1XF7IwUuKiHCkJxJZwcfDl3NCToefoES0MkrikGjPfMPvtxgE51
0wtg4wwc/tX35J+DfW0fGIUR7rvKBg==
=gICA
-----END PGP SIGNATURE-----

--6BSZv4amUqQksatZ--

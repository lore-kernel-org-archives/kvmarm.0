Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4813D1953A3;
	Wed,  5 Jun 2024 12:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717590704; cv=none; b=OLMBUNgYZpLUjZs/XxMhS2Gd9FPf/cFSjHnYblOkPVAK3wfpUwVxdWdyl06LiEREaLcdtUh0yHsQGq7HtpXX0a38f8QW2Ru+w6FN0K7iRvfrOrnxrM/8nP9wcNRQVxZ0DDb3dLvu8C6YtPf2ggWMS2Q+XMoYBncCyuMSLHJ83Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717590704; c=relaxed/simple;
	bh=WqX/iaOAQS6MZ5oQl3ZCdSns0vW4s+x/vrm13fm7laY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZcBNz7EZ0UGm+fK18E4fgM4bw1MvikmP4R8RGCEyNN/hIRX0hPWl4SIpFWF75ss1tnVDZ6BT+G4A9NAyyyYjfjgckzlrpQw4DoaYMU1kHHBse/V+/v11wUhQL3IQ319LI6CgYoJyKKgWq9nO5gxDqPR9dR4FMS9b5VdYn8Gtlx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DIl2tBBZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DIl2tBBZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE75BC3277B;
	Wed,  5 Jun 2024 12:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717590703;
	bh=WqX/iaOAQS6MZ5oQl3ZCdSns0vW4s+x/vrm13fm7laY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DIl2tBBZ6oihhI/f5/7BbeecgSbZ7aK+ZKiHZGsMPZkLUiGDSiY71IFcHbLIN+LHl
	 /5SklmW8EF3ndFp5BSgUVb7d8wUzYF0kHDfD6BsiU9NVCl3J+Tigjr9gKz5pd0Njhp
	 3OmzuekhB/C051H6yFE/fEYxeMXHSqSeaKD93UXoZdv8f1LOlZWXacU4kOHUt9FPdv
	 2DWPxkGGjJLkIiiVeOoDMEiOJb8QLbnsaNQEf2swWOkU03v2EqLJOs/2A54L3S2Yp8
	 EJVyvCl9xGJ1X49jit06Aepfj7KS0+Gpp4j1nEBvprW8V66jPGicwITi9cpqjoQG0a
	 VKUQJs+Ta454A==
Date: Wed, 5 Jun 2024 13:31:38 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH 2/4] arm64/fpsimd: Discover maximum vector length
 implemented by any CPU
Message-ID: <1875ba4e-02c7-4331-b9c6-7ab68d2157b3@sirena.org.uk>
References: <20240605-kvm-arm64-fix-pkvm-sve-vl-v1-0-680d6b43b4c1@kernel.org>
 <20240605-kvm-arm64-fix-pkvm-sve-vl-v1-2-680d6b43b4c1@kernel.org>
 <86bk4flh9b.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ysVZwPn+MwR2sALq"
Content-Disposition: inline
In-Reply-To: <86bk4flh9b.wl-maz@kernel.org>
X-Cookie: Simulated picture.


--ysVZwPn+MwR2sALq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 05, 2024 at 01:13:20PM +0100, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > +	/*
> > +	 * pKVM allocates and uses storage for host state based on the
> > +	 * largest per-PE VL, reject new PEs with a larger maximum.
> > +	 */
> > +	if (is_protected_kvm_enabled()) {
> > +		if (max_vl > info->max_cpu_vl) {
> > +			pr_warn("%s: cpu%d: would increase maximum VL\n",
> > +				info->name, smp_processor_id());
> > +			return -EINVAL;
> > +		}
> > +	}

> Once protected mode is enabled, no new CPU can be booted (see
> psci_relay.c::psci_cpu_on()).

Ah, that's a bit easier.  Might still be worth keeping the check just in
case that changes or we acquire some further use of this value but it's
not currently needed and the comment could be updated.

--ysVZwPn+MwR2sALq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZgWqkACgkQJNaLcl1U
h9AyJQf+MY+KJBHvUdEZTyWsyWafn1JsdBv59+XpSqS/no1XW//XIGvcCvJvQ9/I
/d+4iNDJO5KfECkTL2Zsp4w0k5ogpe14dxnNoSAk6coLY1C9O/QlVZveuR96VMEQ
kFIqT86CC8zZ53FMJkiSPSvh4xCot2/jVaDEIZ7Hc6XTy4iAWZCcmt0NS4TYtIpf
QtvfMeVCkKft6/Na8pjSWKlKkiNRxPbNxaXFBsKXdeltidzOuXdX/JS4J0QtANjo
byDIxgwAy453h+6JGn5/9lqtVP/33/ZGAqqakPPhxVZRfg09C8+RuT/GVcs8r6Xz
SAo4rWVbNS9hGnQxwuEOvSpQnnx/EQ==
=kQnc
-----END PGP SIGNATURE-----

--ysVZwPn+MwR2sALq--

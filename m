Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792592384;
	b=baeTqWLD/iKIKD8na/ev4Pde8tp9ixRy2ZPEE/e8WHUOv4PWZGKI15Pb1DpZfzZcgMTz
	 EdCxv4GP8m40sd5jJs2oabvgmySC+K1GkiWolK35Unh1d/kx7XY80Fp9Cj9RFqJ+/qweZ
	 6SNOPHG4B3Lda899NIdT6yQy7ICTN+5Sz15LNL/UKaixnFNG2F88J6IKGx70Woct2GQHV
	 hq5do2nmoLFko1VbV37eU6WXnrzyHQSqCULVXY7lilNwX1kcuvdmc9GClzjpL+pf4DNfO
	 QlJueTw59956JJAZWLzpbaZorF8ScsNSckEHP+w4poMt5upQj+mw8eXRFDYB+KNiHAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792592384;
	h=Received:DKIM-Signature:Received:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
	 X-Cookie;
	bh=UEVidBOtJkGIF4/dj6UUdp9Wd3YXp7nSAWdH8eAbb7E=;
	b=Ly2p/rTsL+1lMwRWovJw4mjRdai5fAll+Qgl1Y/LRXvJLFDqoORw5UR80nktEhftC2Rm
	 58V5vHVHyaBaWw32YS6vv2/0P8dIvVORZWtgLw0VDLdDvXS+kIFJPhoAOYEkckePWGf+u
	 9E+k+ZhbkcM9eaR9Ysj0FtfXju559oOW7uwR7I2VrSlChWb7dmkxg5AdWu/Wq9qFlhjQo
	 cToVjXWcf0qEuhZAsUtaPLghwxqBnq4TMhWSekqUZi/Zp5da+ENKBrMhi2emTVwjZcOFD
	 Wb1nsmv+mtYOl70Fa8//MlJrkZtImTjL6ARmdCzOoo+7waiM0EIhW6ReimRtWJxKYBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J3YF5IEx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8956E606A31A;
	Wed, 21 Oct 2026 14:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J3YF5IEx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 091A11F000C4;
	Wed, 21 Oct 2026 14:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792592384;
	bh=UEVidBOtJkGIF4/dj6UUdp9Wd3YXp7nSAWdH8eAbb7E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=J3YF5IEx+f0xM3L6lGSedpqw1xZILeSBg9+qBCG3fPIh0Im2Qi3dVV9QwWk54g/Ow
	 f/fUNUXG/IWtyORuoTDz/YC8zut+S8kBe6l1nKAWd7K/7O2DnxERSzSwOIDxd2Ky3G
	 OUulGror7/GFlnXow42JXkVC36VdSWTiDalLfNb5CUi7HyDHauAuKmy49J+FBWi9g6
	 y4SJUN4A6JfdAQJTet1Qwm7VwdtzEGpW3oYwNZFsIzB7LhhUrderhVq4JJdV+kozwK
	 csXe7/1qYnBwKEZUDeAzIzzLb+VQ+mOYFntgFWrhkFs+ohgXlcTtqYfQ61laSvDyeI
	 36QCVCxA9FeNw==
Received: by traversing.sirena.org.uk (Postfix, from userid 1000)
	id D42661CB526D; Wed, 21 Oct 2026 15:19:41 +0100 (BST)
Date: Wed, 21 Oct 2026 15:19:41 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Stoakes <ljs@kernel.org>, Fuad Tabba <tabba@google.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] KVM: arm64: Sanitise ID_AA64MMFR3_EL1.S1P[IO]E
Message-ID: <atjJ_WuM_6GuLkmI@sirena.org.uk>
References: <20261020064306.1542865-1-fuad.tabba@linux.dev>
 <ati3_lymW0zaBsSU@sirena.co.uk>
 <86mrs7ywsc.wl-maz@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="myDSwi2Ph81d1HS6"
Content-Disposition: inline
In-Reply-To: <86mrs7ywsc.wl-maz@kernel.org>
X-Cookie: Whoever dies with the most toys wins.


--myDSwi2Ph81d1HS6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 21, 2026 at 03:04:51PM +0100, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > It would be nice to have it be more obvious to the VMM and/or it's users
> > that it messed up, as things stand features it thought it had set will
> > just silently vanish from the guest - they'd need to know that this is
> > something that might happen and check after finalization or similar.
> > That's probably more a documentation/education thing than anything for
> > the patch.

> The VMM is an integral part of implementing the architecture. If the
> VMM doesn't cooperate, that's its problem.

Absolutely, it's a bug if the VMM is doing this.  What I'm saying is
that it could be helpful if the bug was made visible, with the silent
fixup VMM bugs could easily lurk around for longer before someone
notices the problem than they might otherwise.

--myDSwi2Ph81d1HS6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQReagvpf3TrrA7BoYYv73Ows9A4iQUCatjJ+AAKCRAv73Ows9A4
iZeYAQDZSaktjduuIlbdaY9J9HfNbTXXohL5Mg9RtMggk2fZTwD/RWuP/83tS3ju
xCr8sa/Wa91fFPcj6epcub0Aat5XBAo=
=KMvg
-----END PGP SIGNATURE-----

--myDSwi2Ph81d1HS6--

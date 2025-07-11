Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C05018D;
	Fri, 11 Jul 2025 09:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752225232; cv=none; b=qcK6C3Xe5gbtljFYzjOlsIXGefRlou5drZZrY/R7T5+9lV5pqLwrOyI7ZCxph0N9dLp71DgrnydE6hrmkgiZ0uonbUYsvsf/oGvIZDliya6azQz9UYf84z2slW/JQEiZ4GgNshPOG2dWUipsY5BrwGuLzeHgm/rw0jb3vZ28kPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752225232; c=relaxed/simple;
	bh=D+J1UiQEH3Rtesh/EDPg41C9ly4Q28WAviDALAty324=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=evla+zZ801cRytjZRPLRcmd19ItDc+0s+308dcuHdYWSaQ5RV4fYnu0FxZlp8MGG+mXba7RCAJGN5oxycAtbasv2vQ2w3wUSDkOteIZDQhijV5QNX1bP2E3IOnnSUFYzTADaxXXTvpeLk97ELLyh/decfo5W8Vm3/U/H6qoEkHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rB7i/wSn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rB7i/wSn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A27C4CEED;
	Fri, 11 Jul 2025 09:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752225232;
	bh=D+J1UiQEH3Rtesh/EDPg41C9ly4Q28WAviDALAty324=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rB7i/wSnyCsoVTs9OQknYxwFVOVpM2CusWxCqIs1eVhOcPRvap/k39SzKRXhEt0FV
	 Rfs0JSKM60g5cpuD+ce/+cBEUW1BFJsV9+17g+VaUk5mK7cJFZ0Giwai74c1aPg9RC
	 +DAQjJKe5NcHKdmdAJ3wT5mTxTOLmawWsOZvD22RXuHgzrf7XIVGa98VywnGlWhtkV
	 aEu+oCLzZ960iRceCHbj2JpvEyLL2/wVJHdF76NJLuPKe4mYlXTK7rYzdMqlHKI5dS
	 p8c5b/Rh+v/3LhuC+VYqz6fcYoUL9SR5VxdESBR1vSvbsmJ3Qh5UgK8xn2BS2Aat7q
	 24/CTHe93DLzA==
Date: Fri, 11 Jul 2025 10:13:48 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Arnd Bergmann <arnd@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Morse <james.morse@arm.com>,
	Sebastian Ott <sebott@redhat.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: fix u64_replace_bits() usage
Message-ID: <aHDVzKnJ2Yb6kmAC@finisterre.sirena.org.uk>
References: <20250711072752.2781647-1-arnd@kernel.org>
 <86h5zj9laj.wl-maz@kernel.org>
 <4befb9eb-96e6-4a7c-9746-286144564f4e@app.fastmail.com>
 <86frf39kh6.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="8OlcYUwNPTX3vWXV"
Content-Disposition: inline
In-Reply-To: <86frf39kh6.wl-maz@kernel.org>
X-Cookie: Do not cut switchbacks.


--8OlcYUwNPTX3vWXV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 11, 2025 at 09:53:41AM +0100, Marc Zyngier wrote:
> "Arnd Bergmann" <arnd@arndb.de> wrote:

> > Yes, as far as I can tell, the warning only showed up in linux-next
> > after f66f9c3d09c1 ("bitfield: Ensure the return values of helper
> > functions are checked").

> > As far as I can tell, Ben added the check in linux/bitfield.h
> > when he sent you his version of the fix, they just ended up
> > in linux-next in the wrong order, so I ended up recreating his
> > original fix slightly differently.

> I don't think Ben's fix is in -next, as I queued it in the kvmarm
> fixes branch, which isn't pulled by -next.

We should really get that added to -next, that'll ensure it gets covered
in the pending-fixes testing coverage and avoid issues like this with
the main -next tree.

--8OlcYUwNPTX3vWXV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmhw1ckACgkQJNaLcl1U
h9CYHQgAhW0ZGSJZA9yZmoehX8pya7ceC2yx43u8tF7XehnZB4F8M4KuYj+WWPBf
e5XXehH+M4lv2LggQYFAoVOZtIvkIfKeiyYa67R5SHd0dgKATCWBvVCLg0JiFFil
DuGffTyg6C5bZA4S+Q812aGk1XJsmycaDgwTHwb1fMTWvr+AUoAWGH4fWOvt2WtX
6qw/gaEg3NdNAgMgWzCr5hJ2WJCEtA969vSm1vFPG6SvLxHnrLsMYhOkUCiePE4h
GfbSce0UsS7U/S0qPU/a4l/05pWaRoGgu82sOvepjW48lqOFvsIuuaTcGs2+amJ7
H+J2nbsIdT0rPC58X4TKumZDsOZcjw==
=sUyb
-----END PGP SIGNATURE-----

--8OlcYUwNPTX3vWXV--

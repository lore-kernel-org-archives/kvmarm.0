Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792597469;
	b=sr/AFjr9BwcdmNqfNM4vzaFLeRlmgrFolJaHteyrCVVxXeqIh1+KLeOqjfCsh+fVcCAY
	 jzSLUgFtr+hU3MtXc9fY2cjW1hXoPxvbs1IgvMya+i4yxuJO3hkM2fC+8pp/32TxmZN9V
	 A5XHWGQMwYb/CEoeoamZBpwm6Eqds78c7pEvt/gF+Mbm2B9dAdM4R7y7jg9Jc7Ib00k5U
	 DLtxMkwGUDhWv8Sw2FQi9ld03VntyqB2znTfwuvxe2dnsKgbMP25CkMzHbHTvjqkpOUBf
	 uGbSEbUhNsnxeXGpL0RQy/pfynld7XxaBFgxfjZ4nXpzOWHccikMns9/zNuxVvVJIGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792597469;
	h=Received:DKIM-Signature:Received:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
	 X-Cookie;
	bh=4kcXDJhEfENFHuyA+lYroTo7cmLFPG8UX1ID8jIbjAE=;
	b=DZV+r++Gr3GyZTXlMphzsmOOfs5PRiTCV6Da7i7ZS2k4JaXGagE/KLqv7dQ7Tkc4zgBY
	 JvT27SgziQHKYcOLG9Yp3ptjEcPjG3ocEMN/rL/EqnfYhoxFMKbSXKwMeOjIY9xA2S7zR
	 grua6Ye5lyld59/gPxemsIrTm/XcfQLGZipP0jClPzKp4dvDTbNUV+Ctcj8PapdgiPGKp
	 IJPOCJx7xBs3NfEYMDXB52ebnDkLEgNAjkOGeCvH/pHm7qD1C+UMDJXy2B76+K4EB7jgn
	 PbndO/IE5bPmIOQMA0drpLSRYvtOpshq4JVFb/8s4gv2tq5pGJuCOFvPac4rTaPXqwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Mo7xzRhE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 548DE606A334;
	Wed, 21 Oct 2026 15:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Mo7xzRhE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B49D11F000C1;
	Wed, 21 Oct 2026 15:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792597468;
	bh=4kcXDJhEfENFHuyA+lYroTo7cmLFPG8UX1ID8jIbjAE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Mo7xzRhEgPIbjPjOPjzFXzBcvgAiCuOyW6f2SHflaCGJu6mCMwAKU1OlP3dYvjw5y
	 HH69cHHF8gH1/Te1jqAcddWOpBFIhC0TNcN8ByBSDaZ1M76BZqur9sVejIM15JW5H5
	 EsAgq/Gp7juChmcyxYcJPj4YICO1or8l2c7j5d4k/o3TlBMBrBJcRSMgfxAgKGiAAl
	 gvBmzj6q6cMHVMAEJNfU/g2r8/SCu3ZxrjWzcxk/nY1J2J206ZSwf76cQgw90/1ujH
	 mFlax4+tAZ4/o79FkDQmci6XRBJpivOn3e0ooAbvvP/STS/ReSLqmG+EOujh4qrtfk
	 mYIpGhIScBaSQ==
Received: by traversing.sirena.org.uk (Postfix, from userid 1000)
	id B7F9C1CEA6B9; Wed, 21 Oct 2026 16:44:26 +0100 (BST)
Date: Wed, 21 Oct 2026 16:44:26 +0100
From: Mark Brown <broonie@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Peter Maydell <peter.maydell@linaro.org>,
	Leonardo Bras <leo.bras@arm.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v21 02/15] KVM: arm64: Refuse to start a guest with S1PIE
 or S1POE but not TCR2
Message-ID: <atjd2g25X3YUtOPY@sirena.org.uk>
References: <20260930-arm64-gcs-v21-0-3556644cd927@kernel.org>
 <20260930-arm64-gcs-v21-2-3556644cd927@kernel.org>
 <86fqyn2che.wl-maz@kernel.org>
 <as-f1JfUy38Xt9QA@gremlin>
 <ae24e80c-1b34-4827-9c93-e80b987e9cd7@sirena.org.uk>
 <atdebC62zPS1sQeR@gremlin>
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
	protocol="application/pgp-signature"; boundary="XlGPDImXBOHBZN3B"
Content-Disposition: inline
In-Reply-To: <atdebC62zPS1sQeR@gremlin>
X-Cookie: Whoever dies with the most toys wins.


--XlGPDImXBOHBZN3B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 20, 2026 at 02:16:50PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Wed, Oct 14, 2026 at 06:48:37PM +0100, Mark Brown wrote:

> > TBH when I said in the commit log I was thinking of something more data
> > driven I was thinking more of having the dependencies expressed as pure
> > data, more like the way the test in set_id_regs is written.  This also
> > seems fine to me, the checks are similar.  It's just much more invasive.

> Indeed. Perhaps the config.c approach will make it easier to convert JSON
> -> code also?

I'm not sure how much of a difference it makes given that there's still
code for the actual dependency set.

--XlGPDImXBOHBZN3B
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQReagvpf3TrrA7BoYYv73Ows9A4iQUCatjd2gAKCRAv73Ows9A4
iZlOAP4sLpPvccqJReB8Mwy526cPBNWAF6ETiDO4ErTN2k8z1AEAsIpkS9DcFELc
uBP7TL5YvgkbZg81LWuZNJGnIL2vMQU=
=g8kZ
-----END PGP SIGNATURE-----

--XlGPDImXBOHBZN3B--

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9553F33B97B;
	Mon, 30 Mar 2026 17:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774890324; cv=none; b=JzmpCLiFDMC5ZMhlNK42FexUN4v2RpIiRGuTXxBM91/BTbT/uwUFqylFPhQKNvHq5pLplzrQ73/qXYMJHHiLMAqZa8dRKBXP3mdrDcXRVZERi7H7dHkog3KTGwdxfrcc7t0229CUC4nXRLrUO6z21VQl/3lV0GdEPHYB8Va/uVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774890324; c=relaxed/simple;
	bh=OFtDuFmsAEV2mQbq8ryV0+0J0YdGy5oZq6dDxXj1x3Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mucjuE2uVvUllTGfHBJX9B5CbCjFN5Gl3T1M+SQtI67QJ762+GHZDapU9CVQ/JNRNES4I1lMNGVDkwBUoZtg4gd614CVUGBROCK2OA8jPNUGi0ZQ+laKo+cC/NGn4fmn6zkEFsTFlGsl6rgVBKIeuA5GWAFTOpXQErO1CRpQ5No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tvxa/aqa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tvxa/aqa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59691C4CEF7;
	Mon, 30 Mar 2026 17:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774890324;
	bh=OFtDuFmsAEV2mQbq8ryV0+0J0YdGy5oZq6dDxXj1x3Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Tvxa/aqaN+wKCzER2P/+leTkpZMUSiJPc61rt3WJbW7IGVU8Iw4uPhyK78Gpcan24
	 9hHmPKOcK2A03Zdrb1OBgJQgMzvRkhDkwqQSBk/aYEU2Mp9QbgNj7R/4+NNQX16kC2
	 kzSjJ9Oq2HLYXJG2gUQg1+Pv3AvO0FIkWQMxz9aY0pwvu3a+7temfgn+7ZLfN2z7zI
	 KQ7qoX9BT9V+4601dsGVG1gga7DX+DrJuVG8aRqCyfv2TIUSoBoBGoV3Aa26qteggB
	 pkRlekyM3lUArwuaw1F8w31mEzIA/RLPqn4mJCJl6beuSck8ITp/ku7lOkDBP07Ca/
	 SZKmCZBr8HsgA==
Date: Mon, 30 Mar 2026 18:05:19 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>
Subject: Re: [PATCH 00/15] KVM: arm64: First batch of vgic-v5 related fixes
Message-ID: <687585f6-8948-4e71-bdb1-44af69417ff6@sirena.org.uk>
References: <20260326153530.3981879-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="FEqMr0d8osX/JtEA"
Content-Disposition: inline
In-Reply-To: <20260326153530.3981879-1-maz@kernel.org>
X-Cookie: HUGH BEAUMONT died in 1982!!


--FEqMr0d8osX/JtEA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 26, 2026 at 03:35:15PM +0000, Marc Zyngier wrote:
> Well, merging the first batch of vgic-v5 patches didn't go smoothly at
> all. We initially found a couple of regressions, but most of the crap
> was actually uncovered by everyone's new best friend (enemy?), the AI
> bot sitting behind sashiko.dev [1].

I threw this at my CI, nothing blew up though that's not testing any
GICv5 stuff particuarly.  FWIW:

Tested-by: Mark Brown <broonie@kernel..org>

--FEqMr0d8osX/JtEA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnKrU4ACgkQJNaLcl1U
h9AW3wf9EdXqIBsaQlQwQxuOvZ3k/PpuS/CZNW4ACvUO2DScpqwdQ0kqubK0wzr6
Kr0C7MKhZYadbDGhFYyVzPe7xXv4eCLm9UQgW/cxz+81H0eKEYqHEadi5vqcpx7h
CdL85S6ZoSQmX4MQAB3A7qgH47+a6ZCpklKWnhM07hSYdO4eBcLtDz3GgsC+gLIA
+ShtQ+egZ3fNVCGqbxCKumRMT3kB9p83xzlOZahLP/S9ZwMRX0KMEdbTmTlA0yUE
ZsN5c7jW6Ab6rQcwgBB9spUYPZ3eF6/OosLMDBupD/eeFtXazmKw+7D4ws+ha6nJ
5n6SHqstbRQoNg0wohXPl169w9a4Dw==
=eT1A
-----END PGP SIGNATURE-----

--FEqMr0d8osX/JtEA--

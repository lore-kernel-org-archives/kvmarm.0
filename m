Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9773207
	for <kvmarm@lists.linux.dev>; Wed,  1 Feb 2023 14:18:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 832E1C433D2;
	Wed,  1 Feb 2023 14:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1675261084;
	bh=vTP/X6ya/oaxLU99qz7rXk2PwqTpzySESekwPkpiGPw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J5RGF1iOPGw8fMgb5L/4bBVFta8ZX1PBWQ89IFmrXAuCKP/7BQqYEoK6YfT0iO8Wy
	 w/vwfgZ5ShWrg6Y8uVCw3f6N/mJ0xd5NOab5CttDoKQB1jI1RyusgVrZw6pIBTO/kN
	 yDgnBkbVquIuzvTj7LOlhp3Jl71XoYh/damOs+PQ9zuBHqVbU7dDu6jvdvGINrxXUq
	 oHTeLquX9NmO3YT9Bg3JRV5TSB4QAeNhCKpHKNFaaLGUvJ4Nk+Z/gZBVBLL2hF5Pit
	 JSDrI3QFm75nxfNvn415Gxs1suwDCFV41FK9iovVh2ib14CdjFNqCzmgtSNXMKuEL1
	 B55ECUbu0myUw==
Date: Wed, 1 Feb 2023 14:17:57 +0000
From: Mark Brown <broonie@kernel.org>
To: Quentin Perret <qperret@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
	kernel-team@android.com
Subject: Re: [PATCH 2/4] KVM: arm64: Introduce finalise_el2_state macro
Message-ID: <Y9p0lWH9xTphfnxU@sirena.org.uk>
References: <20230201103755.1398086-1-qperret@google.com>
 <20230201103755.1398086-3-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="+lYXR+bUApKLkVCw"
Content-Disposition: inline
In-Reply-To: <20230201103755.1398086-3-qperret@google.com>
X-Cookie: Oh no, not again.


--+lYXR+bUApKLkVCw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 01, 2023 at 10:37:52AM +0000, Quentin Perret wrote:
> Factor out the first half of the finalise_el2 function into a macro to
> allow its reuse from the nVHE PSCI relay code. While at it, make the
> register allocation parametric for the check_override macros as they are
> now more widely exposed.

Reviewed-by: Mark Brown <broonie@kernel.org>

--+lYXR+bUApKLkVCw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmPadJQACgkQJNaLcl1U
h9Bslgf+OZ8HuOi4ji7AehHmLidk3usjkIfXZ3xsQgfT91cOI9A7fvx6/vbkw1DT
tuILvtqEmD8oHn/ELWUiuKA8+cCtP4H5jSU7Q3+R0OrjaF+yluTFaHofc+lwXA6S
Unz9NKJy0/pxzouiEoLpUI+SXURv7Bf3MPuh7cuWn2BMQFKRlbFYA2hvHbIMVLSO
fEvwe3LX8hg1oP8Bzh1drAsqlT1KICg8XYNCBh18kP82GmO8gMcQKbTHYN7f0pM/
9BloBdWbp42hAme8cy1KOBPwE1PBxapIaKt2P+Xw3SXUD/RnO1piI26feCZbnWG8
2M2agEtd3G4AeI37ZcfRqtRSIO78Qg==
=wgJY
-----END PGP SIGNATURE-----

--+lYXR+bUApKLkVCw--

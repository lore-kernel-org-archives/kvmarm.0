Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80AB1175A89
	for <kvmarm@lists.linux.dev>; Thu, 28 May 2026 17:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779988666; cv=none; b=DzcFeZDbzviGD750DlGWK/WIhUE6ld5Kxr3FaBHMj7XOIXK1epyaUeq9tz1DFtq3zJDmq4VQUGOJm+ZolOB0uiCKzWNUbn4wk3o7T9nX+OIMNh8zYTXSP8+vhNW1kKQqUgjdAF5hP80HTHJ8fe6p/XJUdhhpCI96By/p2sF/PS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779988666; c=relaxed/simple;
	bh=JybsP6neEqqAoTM7Pmz67kz4XFEEsypjyO3C0cAT568=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hOGPKPvY2uvR/hdIwDpxyqmywbeXpUIgIxKvH6kU82m6/l+Ob4xBuw/hsYe288y6oWZks173JUbbIb76HSPrB04qHlLPaqpPEKShew9lW9LXRKV3J4RB5+xHlnLPka3Z1i1XfjnQ1EoBcLL16BHUNTeFwJqZTVqvL5zjBkxoteo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FlKbuqVo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FlKbuqVo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37D671F000E9;
	Thu, 28 May 2026 17:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779988665;
	bh=JybsP6neEqqAoTM7Pmz67kz4XFEEsypjyO3C0cAT568=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FlKbuqVoxin9BLegA3sg3biseLmdaVMO1PnqCdx8LvD1f8DcBffox7650Yc260tK2
	 gP0GEPhu5hN2/kkH+OQGQrDTMacga0OXZSzLs6laneERn1UyKrAAlbSkYOtpNKYvfA
	 YFbIIHnYwezbCQSL7JVTfh3YB8QycgpfbP/RJ9wOgZOce37OBJeZ87FyFTTbqNhVlo
	 /HAeLxd9QeHu9eLIBQC9wrIF5565tv8NkXkG+HXn76gqdFeAQUdby29tEKnWTFQEPC
	 fG2ObPech+/o/yGAgMxM10GWvn0sBBTNKGCFBR+K2FvaLqLSjWaLjsQiZxNm5oKGXC
	 eTuGNOLyq5TiQ==
Date: Thu, 28 May 2026 18:17:40 +0100
From: Mark Brown <broonie@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	catalin.marinas@arm.com, james.morse@arm.com, maz@kernel.org,
	oupton@kernel.org, tabba@google.com, vladimir.murzin@arm.com,
	will@kernel.org
Subject: Re: [PATCH v2 11/18] arm64: fpsimd: Split FPSR/FPCR from SVE
 save/restore
Message-ID: <9259e443-6fa3-4ba3-9aac-42f78dc7e72e@sirena.org.uk>
References: <20260528165446.701944-1-mark.rutland@arm.com>
 <20260528165446.701944-12-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Q8zKy3wNANHFD/wm"
Content-Disposition: inline
In-Reply-To: <20260528165446.701944-12-mark.rutland@arm.com>
X-Cookie: Someone is speaking well of you.


--Q8zKy3wNANHFD/wm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 28, 2026 at 05:54:39PM +0100, Mark Rutland wrote:
> Regardless of whether the vector registers are saved in FPSIMD or SVE
> format, we store FPSR and FPCR in user_fpsimd_state::{fpsr,fpcr}.

Reviewed-by: Mark Brown <broonie@kernel.org>

--Q8zKy3wNANHFD/wm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmoYeLQACgkQJNaLcl1U
h9DDEwf+J+W4JjW776kpG0Xg7vg+iA+6PmZWSrsUvZskElWJSW1cuu6mvBAsYJyT
H6LykUmBu71WW0og4iNP+pmNr0KHfKZ/AhcQGtpHTbgHaykmBMqRO0msDWaFcdJD
wzUs3JZUTcK89tSPKTMqTFNG8BafpifqpRn54Z0LZVz+LST2WF8Bf0WedhrMpwiL
CW23BHGS8WQy8w1CCpcaJ43lsJe45yPl45mJfm+Rv37xuCZh/DZZsE6ywL0Lj8vH
V3MTUyQ+zZR9g4tlED3/W/kmyU0Fc6bCeUwN7dxp1BjwMvHyPae1r7zj/4Zs/q95
eh/0jEU3iOF4VGECfL0h3qnRHinzFA==
=BXnO
-----END PGP SIGNATURE-----

--Q8zKy3wNANHFD/wm--

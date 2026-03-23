Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E7F3AB295;
	Mon, 23 Mar 2026 14:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274934; cv=none; b=ZlYKR1By2/qcN3+98Uy5mY2D+41dzXNDrE1iS65T9WlcPZ3mBkKmzfflNyUlW/ZuYj9B8AkrmPnXaXSW+6PFdJO/YyTK/eRhl5p88ko01H0Ty55dnTU1PWcUle8LpfIY/yahHju+C+3G7heQno4xoopGaDPW5Qnsikj0A8FG+yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274934; c=relaxed/simple;
	bh=ibUEYe4GutvPEuyapGFe2ws3ChvH52UKKu92kP5Juwg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lVexq6TH6elWPjwyxXnxqP86hHwxSe70Xozu34cyaz2VqrZxIKRsiKiHRDahTej6hzRu7MBbpM1S0xJlkHF3q7apW3AMZMb3SUy31WHiVFeyX2obw7kg3X4ydvAHwnV7+yoFa1YKVOH8CawoHE5sn6uCe8LPl2/4KegvodVOiDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YXO0PCmw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YXO0PCmw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 316AEC2BCB1;
	Mon, 23 Mar 2026 14:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774274933;
	bh=ibUEYe4GutvPEuyapGFe2ws3ChvH52UKKu92kP5Juwg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YXO0PCmwrRlPmNBfdqj+2xY1tZ8lfmetGhg534KH/K5FERePA+ZTQGECkMUmKsePd
	 KfSbiLUlfWmtRkU0Oekn2bqZavw3y9uvwwqwaiW5Qlj9u+euHwMV/AQT1yJbfZ9lFv
	 tgeGj9D+RcLHfJnX2mnMwP41/AxcYi/SDEr878+iziQff9Wvi+L5XJ3GFcdfzRSuGd
	 e4maIyyjnFFISi7jL2BFppVjuidaQeZJ1amNUNtHuaiccZnpIxawfhwn6sLdMe7sSo
	 28EQRgmvkwKBy1ZSwPV8tIjvDfow/lP6RcGPrKDsfP6jwFEQPjStc1ZeY7YEJEat5g
	 /ddfhR4bHEpnw==
Date: Mon, 23 Mar 2026 14:08:48 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Sascha Bischoff <Sascha.Bischoff@arm.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, nd <nd@arm.com>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	Joey Gouly <Joey.Gouly@arm.com>,
	Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>,
	"jonathan.cameron@huawei.com" <jonathan.cameron@huawei.com>
Subject: Re: [PATCH v7 12/41] KVM: arm64: gic-v5: Sanitize
 ID_AA64PFR2_EL1.GCIE
Message-ID: <aa0085c6-6b5c-45ed-91af-55fc68939fe9@sirena.org.uk>
References: <20260319154937.3619520-1-sascha.bischoff@arm.com>
 <20260319154937.3619520-13-sascha.bischoff@arm.com>
 <3be4971e-31a4-4033-9583-88d7fc96104f@sirena.org.uk>
 <86y0ji4pu5.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="vd+FgqXVSRBWfKWZ"
Content-Disposition: inline
In-Reply-To: <86y0ji4pu5.wl-maz@kernel.org>
X-Cookie: Avoid gunfire in the bathroom tonight.


--vd+FgqXVSRBWfKWZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 23, 2026 at 01:50:42PM +0000, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > I'm seeing a regression in -next in set_id_regs on a range of platforms,
> > including physical ones like the Toradex Verdin AM62 and i.MX8MP-EVK,
> > with a GICv3:

> What CPUs do these machines have?

The physical boards are all running shiny new A53s.

--vd+FgqXVSRBWfKWZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnBSW8ACgkQJNaLcl1U
h9DZtQf+OZCVNVbOqhkxeUB5zWWSOVy3pZGFgtFTYQydWn2Z6+S6Nyzwc4TPcN1u
SoeQ/qHxWFQnl84KR3Ponu6jdImw/2WYjmhHCe3vhg6cFmxXbILMahCjTf14wQs6
j4iwRDBaXHuh0+8D553n0BMKY0CmXsmJH3Fvb0lD+74m+HvxtgxFBR8FDhQTFD7R
4w9hUlxiPpYT3iyRf0oUZeZi9UTl7xXizHN/uiVxLrUdFU7lzlCkqncX/c4IB48l
lSdUd9MiwXY7IQYCeb+qD4F7X+BpSAk0dEBOn0YxH/8xa37HDRoiSDF1q+ye3Uz7
6X4yALlwL5PlkjlzgEGsel1UaD9T6g==
=7vYS
-----END PGP SIGNATURE-----

--vd+FgqXVSRBWfKWZ--

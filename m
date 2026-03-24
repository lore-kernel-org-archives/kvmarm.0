Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0AC35959;
	Tue, 24 Mar 2026 18:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774376190; cv=none; b=oDHzEejuCezYFJGNKHYf1AH2Mt3Sk+KkiY/v2/d2mXOe6vD7tdvt76fr7mxKTGbM24VC0jL2vCDG2AoJYoBv6OM/BprqUuUqX6sqPWegkJervrlJTA3MIzD5pCuBmKMwjix39750X2HZxOJ7QlyVLWk3BbiiiGxRWNqxmUdvuQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774376190; c=relaxed/simple;
	bh=/ypStTJ7CiAGmDRziRUG/EYQwZPTjlxVm5e6SeBw5M8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ul3NScTg9p+BP6AZqMUPbtjTvzYP/uR4mQ2IH3AhEg66uMY4HExfLcuWToGwMB9x4v960n1/RuB7EeQjMRufUOE6bDSjeLHLsd6LoTfRIEHUb0IN45ASfQ0vai5fvSgv7S4k4E4Qqt7G/uG2DNB47UE2s+JKXqEBmB7I4vGY9nE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tbqXfTDd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tbqXfTDd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4209FC2BC87;
	Tue, 24 Mar 2026 18:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774376189;
	bh=/ypStTJ7CiAGmDRziRUG/EYQwZPTjlxVm5e6SeBw5M8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tbqXfTDdnLGmbaxrDp1vSCXsAKADjs+oRPf/RyU4V8803jSuLAGriWNCpc2ejpyIY
	 LjkahALqhZOvS14r4BPdBpNasv2znuWoA0xyslMOhThP8DmKScpf2+bxpQ5p/K+JZq
	 ysmETT0UKUMHpJj0nMBOnQTIbHx5kGVn1mNVCNMU/KoPw8TCEfU98ga3GZvsiHlkNR
	 h9A8tTzpn87Bv3eqalAkyQCy0wrWCW38nYwvEv3L0y6pF2sMt3rO7Ym8DrgXbBYvXt
	 Gk9R5v2tYcRiqEoXnEDxsxc0P+CZLQ/bzffeAa/yLvM320CnkKoMjJLr3z+MAfL054
	 L7+sd4W/j+ovw==
Date: Tue, 24 Mar 2026 18:16:23 +0000
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
Message-ID: <b3f9e10d-75f6-4da9-858c-3f85d2d7db57@sirena.org.uk>
References: <20260319154937.3619520-1-sascha.bischoff@arm.com>
 <20260319154937.3619520-13-sascha.bischoff@arm.com>
 <638a3453-91c9-4a76-8241-25d5c27ca518@sirena.org.uk>
 <86se9p472z.wl-maz@kernel.org>
 <ebd9ebb4-06ac-41a1-af16-664a4eedf3fd@sirena.org.uk>
 <86qzp945d1.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="GbtyFO5MUSHSk1Kb"
Content-Disposition: inline
In-Reply-To: <86qzp945d1.wl-maz@kernel.org>
X-Cookie: Forest fires cause Smokey Bears.


--GbtyFO5MUSHSk1Kb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 24, 2026 at 03:25:14PM +0000, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > > Is your TX2 the only machine you have that is AArch64 only at all ELs?

> > Yes, that should be the case.

> The hack below fixes it on my favourite Qualcomm box.

Confirmed on TX2:

Tested-by: Mark Brown <broonie@kernel.org>

--GbtyFO5MUSHSk1Kb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnC1PYACgkQJNaLcl1U
h9BYzgf+LFxJQeWg+73NmCmRJGV5mrNVAhnE6ndhSgdZo7SUugOdDP+kU1SyiQEl
PTmurB4rqTx512siq0ZuVjIeLhpVEEbBfMN+P7dASp5lswwGKACS5bursUDkXOpk
Ekn64HC1i6qb0dXH1sKM31khPXtc+j+HZUHpYJqkxCCzAPqGtFYhs9h9z+nqIsQD
73KAjEEunUGxVqecRCqTbtrh1iYHdQuNURbdidA+alFGXFJLlnVN7n1PRO3wJhnj
BYsqhwJExjwN2sd/84ucRtHSwF2If3xiwqcPLPBi7liYlcvWBApEQ5jyBlP8hdLk
IFoTX2g5bU15Cnql1zjDJGKfiM1NNg==
=A7dD
-----END PGP SIGNATURE-----

--GbtyFO5MUSHSk1Kb--

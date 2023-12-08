Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA11A1C68F
	for <kvmarm@lists.linux.dev>; Fri,  8 Dec 2023 13:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ecWcsIQz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97EF7C433C7;
	Fri,  8 Dec 2023 13:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702042995;
	bh=NIaopYdM2dcbSTLvNOf5TaMdJYI+SlfvYNK2Nc//1iM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ecWcsIQzokRORkTk2si2o+3xKZi3O8jZNZEeTQa9nOgNuR9v/Tqw0sQxjX9ToUiJy
	 aZ4wo/h6Ia8IxpslKFYVeJEaBhpgbmLrAWoYylnVndtlYR3FTlRB1CbsMxUelkdDrc
	 OtiFut4SwJQAGObYqp43weVKzxijedIXScsAISxDmk+vEAEV2GRXtfinpGm6IRK9O7
	 6RShr0b/eNsml/kM6tNUdv123TWP2f3d15iywmKb9Eeq+F7ETkjYCcpq8R94igCD9y
	 4C28DLPMmSVi5t9ETMcS/xwnTVm6vXWE5woyJoxz59kJorLLlzA9AvHLd8av296OHd
	 VG00orUmcB1ng==
Date: Fri, 8 Dec 2023 13:43:06 +0000
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev,
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, eric.auger@redhat.com,
	jingzhangos@google.com, joey.gouly@arm.com,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 01/12] KVM: Add missing HCRX_EL2 field definitions
Message-ID: <ZXMdasQNGNPFPP3E@finisterre.sirena.org.uk>
References: <20231206100503.564090-1-tabba@google.com>
 <20231206100503.564090-2-tabba@google.com>
 <7c85421b-5dfd-4931-bb14-aa2416e54b58@sirena.org.uk>
 <CA+EHjTx7LJJzOHbO=ubWtuwhbVXd3FyX99Y6LxkT6u9vSx8qxA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="P8UFquSP/kpFpiGD"
Content-Disposition: inline
In-Reply-To: <CA+EHjTx7LJJzOHbO=ubWtuwhbVXd3FyX99Y6LxkT6u9vSx8qxA@mail.gmail.com>
X-Cookie: Slow day.  Practice crawling.


--P8UFquSP/kpFpiGD
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 08, 2023 at 08:14:58AM +0000, Fuad Tabba wrote:
> On Thu, Dec 7, 2023 at 4:57=E2=80=AFPM Mark Brown <broonie@kernel.org> wr=
ote:

> > (that series does make use of EnFPM).  Given the likelyhood of overlaps
> > like this I really think we should be merging these sysreg updates even
> > if the serieses that depend on them are still in flight, it doesn't make
> > sense for multiple people to end up doing the typing.

> Makes sense. We'll ask one of the maintainers to pick up your updates.

Thanks.  I'm in the middle of pulling a series together which gathers
all the sysreg additions I'm aware of together which are ready
(including yours from this series) - should be out later today unless
something unexpected happens in my CI, hopefully one way or another
everything will get pulled in.  I'll Cc you when I post.

--P8UFquSP/kpFpiGD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmVzHWkACgkQJNaLcl1U
h9BGtQf+NM9tYc+9+rWjKm73CKYuewaN1IoSTN2pe8uD4f5xMHsHfpHyhsouSSzk
46X9BiWJtjtB2fvCHzHLbMZ5T+Euf5gpMonn5QS9DXkJfqz6P8x93xEFn2FYmfIb
z5mwz5SyZ2pZ11k4hJ5aUfBHY7Xyvum8N1v4xNgYs90+bZwNaTJY12U/w2gUOi46
HlG8mPXrXrVtan7iyreL4E3v5WbPIuHlXgFvlPgTqoemPrFq1cdmlt+BL9MtfeDW
pFUC+JI7T+FoiaKtuFzVV9kyNSdhbWMMDyBg6WDOT35U7bMuIGBn7cGEkGzqjzss
IHjZhgcnUJqCN03K3SNezKI+40Ni7Q==
=yrCp
-----END PGP SIGNATURE-----

--P8UFquSP/kpFpiGD--

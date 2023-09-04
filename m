Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27461C2DF
	for <kvmarm@lists.linux.dev>; Mon,  4 Sep 2023 16:03:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E58C433CB;
	Mon,  4 Sep 2023 16:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1693843425;
	bh=FSkoRscREztpVl8dG4jfCaISWyFn1m6DwZlTvCVuoXY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sh9RmTJWClbiRlhHJ6BqmF9gj6tmLdk5AB2so/mf1PhJLSGtn0OMG7UTLRJkwOP2E
	 fY9Z8XcAS5uhIBcieeOhLJXvNODh6bWSgjdT/k8zRXT1wiFzpHwxszAIDHbKdaFig7
	 LA3RjwaxocAo0dxr5t6hBCPDCR0x+t7BlwIn20fBNxjCDKnTa7CZsG4fEg0jPDnYCY
	 +5T6me8hrVEZXzGJ1eAV2kQJVVLIzduc4qxbVeOX7CdXwtcUVUUAFvcpOKBFHQTISm
	 oKW0tsBpx1N3/jYy7jdU+GcQ/U8qmPTgz/obyqwOj0zOHuJ7+3u4CjVtNinvIQFggJ
	 ejlKZskT6velw==
Date: Mon, 4 Sep 2023 17:03:38 +0100
From: Mark Brown <broonie@kernel.org>
To: James Clark <james.clark@arm.com>
Cc: coresight@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, maz@kernel.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Mike Leach <mike.leach@linaro.org>, Leo Yan <leo.yan@linaro.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	James Morse <james.morse@arm.com>,
	Kristina Martsenko <kristina.martsenko@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Rob Herring <robh@kernel.org>, Jintack Lim <jintack.lim@linaro.org>,
	Joey Gouly <joey.gouly@arm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] arm64/sysreg: Move TRFCR definitions to sysreg
Message-ID: <9fab3e6a-b6b5-4376-8af9-0bbfcd98bbe9@sirena.org.uk>
References: <20230904140705.1620708-1-james.clark@arm.com>
 <20230904140705.1620708-2-james.clark@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="r2mWafTzFFcOIUyk"
Content-Disposition: inline
In-Reply-To: <20230904140705.1620708-2-james.clark@arm.com>
X-Cookie: Immanuel doesn't pun, he Kant.


--r2mWafTzFFcOIUyk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 04, 2023 at 03:07:02PM +0100, James Clark wrote:

> +SysregFields TRFCR_EL2
> +Res0	63:7
> +UnsignedEnum	6:5	TS
> +	0b0001	VIRTUAL
> +	0b0010	GUEST_PHYSICAL
> +	0b0011	PHYSICAL
> +EndEnum

DDO0601 2023-06 also defines the value 0b0000 as "Timestamp controlled
by TRFCR_EL1.TS or TRFCR.TS". =20

> +Field	0	E0TRE

DDO0601 2023-06 calls this bit EH0HTRE.

Otherwise this looks good.

--r2mWafTzFFcOIUyk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmT1/9kACgkQJNaLcl1U
h9AufQf9H8NV67Tub8va+pIcI4JrHGdresAShHQawd4nzCgGbpObcY3XP+SI8lqP
Z91W7pKj6C8gIfeaah7pYiyIBfAzGoeTYkz6Xsn1WOcRltFl54eSg2970PjsbMDB
a5oAujtQqnZ7Hlb/X4NDcXs9IQKlKZfRW/5T3W8ChwxLkfWn34fFX0oEk3+08AQj
MBnYycNzeklPkqEv/Y51HZratasdaJv/nDIRv6F8bF1Xw9h/Z8E3tyhZO1QTWuCi
/+fJx1HarwIKHsOSfzvLGDIjpFeBad0qfyOSaIIgpNkvGXVZOVhScNV9gC0K84zB
Yp7f+iqDwzwI+ZUEEPZRl7e8TvWp1w==
=RTKP
-----END PGP SIGNATURE-----

--r2mWafTzFFcOIUyk--

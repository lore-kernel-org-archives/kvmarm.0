Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC708C09
	for <kvmarm@lists.linux.dev>; Mon,  9 Jan 2023 19:33:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7220DC433EF;
	Mon,  9 Jan 2023 19:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1673292820;
	bh=bTSoMPcMcmLPaD3oxUR9mFEaflJdAiTqYCb5O5A+MJM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Lv3cEa/aSGwho+07n//aR6cSlJsY/GTswOJlakzLyZPXAPlWbnXN8oSQaDd6nsm7x
	 vBJczEXe3POhwslvIc0HxQOFU42+bL/DhgnpBwPNOpUbx5/rNkDZMT7icCEsb3KasW
	 gyIG7LdHNzG3zJyCFnxCKnC0972eylTGpPlavnLdwrZawxKKOfVmSxgY8y+PMmAc3Y
	 9gy/nHWJ1Mvk0CuErrlMgunN8O67pJbLydqMZIlL9p38G466X0Jskf+xFwhqsdVwAE
	 keYy2jTyJKLgeplPwQ2tieYgL+fyzoAa+NmTOJQ8AbsPAkH1bZnxW9/9Dxg4C3VMiU
	 6o9a9CC3yrJOQ==
Date: Mon, 9 Jan 2023 19:33:33 +0000
From: Mark Brown <broonie@kernel.org>
To: Rob Herring <robh@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org,
	James Clark <james.clark@arm.com>
Subject: Re: [PATCH v4 3/8] arm64/sysreg: Convert SPE registers to automatic
 generation
Message-ID: <Y7xsDXFlNjiQ1AIe@sirena.org.uk>
References: <20220825-arm-spe-v8-7-v4-0-327f860daf28@kernel.org>
 <20220825-arm-spe-v8-7-v4-3-327f860daf28@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="+R5R38EZaqmBSfGK"
Content-Disposition: inline
In-Reply-To: <20220825-arm-spe-v8-7-v4-3-327f860daf28@kernel.org>
X-Cookie: Editing is a rewording activity.


--+R5R38EZaqmBSfGK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 09, 2023 at 01:26:19PM -0600, Rob Herring wrote:
> Convert all the SPE register defines to automatic generation. No
> functional changes.
>=20
> New registers and fields for SPEv1.2 are added with the conversion.
>=20
> Some of the PMBSR MSS field defines are kept as the automatic generation
> has no way to create multiple names for the same register bits. The
> meaning of the MSS field depends on other bits.
>=20
> Tested-by: James Clark <james.clark@arm.com>
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
> v4:
>  - Rebase on v6.2-rc1
> v3:
>  - Make some fields enums and add some missing fields

What changed to invalidate my Reviewed-by?

   https://lore.kernel.org/all/Y2kgC9QlBwvXTLe6@sirena.org.uk/

--+R5R38EZaqmBSfGK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmO8bAwACgkQJNaLcl1U
h9DxNAf/WsewNj2Jsxe561AMAVfSZGGTeD3cxMiIkJu7/i6seiPbUAVmRQAU/3AO
hWLnAE0qdAZHyp47NwC6fd04WBq7W2910I+Sx7ESUbrXKciJqp1lpG2DBauU4HpZ
Hu8Ak7/eEe2gHvooa2ku3X1jFK59X9jKjXtTJLkky0jxXqZV0DhAWEhRukPLEen/
GAx9GzqacaRbZ0d6e95U9F/WyvmMLzv5J8NkuT97Ue+AD37691GJ1ECeb/WsrdOV
wPAqZ0l0BVqnMxBPzVa0SpMXL0uooYlvfyLzvFotPrilxwgMoQ3WI6ULCM7fj5O4
nxuNXWR2kEZuo4b0jsXjvfYIQJfNTg==
=hyzN
-----END PGP SIGNATURE-----

--+R5R38EZaqmBSfGK--

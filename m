Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244DC2F32
	for <kvmarm@lists.linux.dev>; Mon,  9 Jan 2023 20:40:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5239C433D2;
	Mon,  9 Jan 2023 20:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1673296854;
	bh=ntZPimoI5coAlKdMrcaOdpUwrWa2LY/Q3irbWCzsKCA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VKiqNBM4dBxXJWJ9FWSUyjYaLt41JtbYn6uU7S8SNsi2XnOXsxUuLGvoEIAC2k7tw
	 Bdqa6//ADO6mol2VUQ6zUFJ2M3ngayBPb3TDgH8PdN9BvfO3noxTuonocu5LFPy+LM
	 oqDcGN2OpC9sl5TvxLoHrZdj827WjB3C/+A05Jmduz1q0ERm+R4vZLB8WXIuh+0N7M
	 /XChEh2GtBiXguiAiCCgQQbcDm1UVVIJ0kr4JSoHUuPqik42xExbA2Rid020IVIasN
	 khTFmZy2mfZfX4194aBCmyd5gwo+2gle/4DcyFBab2pu2XnMZiAE7agSGJOagGjkqP
	 hh1nLFXHiWSAQ==
Date: Mon, 9 Jan 2023 20:40:47 +0000
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
Message-ID: <Y7x7z3C+voadToys@sirena.org.uk>
References: <20220825-arm-spe-v8-7-v4-0-327f860daf28@kernel.org>
 <20220825-arm-spe-v8-7-v4-3-327f860daf28@kernel.org>
 <Y7xsDXFlNjiQ1AIe@sirena.org.uk>
 <CAL_JsqLFSMzmTSAjtWWotzFy=JLr+rjim4F_X5thWK9ji6z22g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="1XIdtARmznQkOCwl"
Content-Disposition: inline
In-Reply-To: <CAL_JsqLFSMzmTSAjtWWotzFy=JLr+rjim4F_X5thWK9ji6z22g@mail.gmail.com>
X-Cookie: Editing is a rewording activity.


--1XIdtARmznQkOCwl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 09, 2023 at 02:18:41PM -0600, Rob Herring wrote:
> On Mon, Jan 9, 2023 at 1:33 PM Mark Brown <broonie@kernel.org> wrote:

> > What changed to invalidate my Reviewed-by?

> >    https://lore.kernel.org/all/Y2kgC9QlBwvXTLe6@sirena.org.uk/

> Ugg, sorry. Nothing changed, I just forgot to add it.

Ah, no worries, glad I asked before redoing the review - I'll add one
here for the benefit of the bots:

Reviewed-by: Mark Brown <broonie@kernel.org>

--1XIdtARmznQkOCwl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmO8e84ACgkQJNaLcl1U
h9CpzAf7BoOwriuFtR17xQbp7rTn/cRof+X5gGKrd6Tu8F5Yu5rNxhiWewqU091n
8NwzucxAPyhzP6NsCnijhrHB2yh8qv7a+z1OoDKqfkwMaZV+B9e0+DeenN2w3trL
+fJVGjIJBLBIjM/3ExIp6OszN+Qs7Rmf1seL9DV0msIlPGKUoSDwdaDMHgeI7He5
H6qsid510KHNcKfT06nGQC/e0hTA1k/65TsDtguxqrc4wEiFniTO3QCY1GcQ4aBX
icbGJDuc27FMFrgYHsI8/gWorlPkki8ABGuHyEywhDIQlvyX/LIx0+GiFs2sZ8C/
O4JqNcC8Z3FIGtXv13qYTsgwa2Hq9g==
=GN38
-----END PGP SIGNATURE-----

--1XIdtARmznQkOCwl--

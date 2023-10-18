Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38FB200DE;
	Wed, 18 Oct 2023 12:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c8+v+ykH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F41F7C433C8;
	Wed, 18 Oct 2023 12:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1697631390;
	bh=snOg2kwIwvrklgP16FSVRjBs8P6XXlk92g89ZTHGFmk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c8+v+ykHpLVEceMm7LkYUVPjCWS4qHd3H4eQKatnCb3sP4Bc7CCStareG6HlmU0/O
	 12+h9fzYm80IgVqAB+eLTFn0t0DdcMDZ/4x7j9+ziqldIz6h24k2OKUAVXw4aXfXat
	 +pUxpaCGLKzhNn242WgV0vcQr2zNnVSCvEYQhadVKmkrOYjVyKPBM6G13usJ3cT38w
	 TTuiC2emY1VzizQHGvAEkrRN/HLUuxsrt3sNR91laBXIqskOI9euK/Ef5J1qzj6GdL
	 kPXdpl4lLUFIINhn/SX7XFylGs15jmyo/9n64jAAI4qloqC0LgEhD7U6MZAsndBtnh
	 gy57UPN7fNOzQ==
Date: Wed, 18 Oct 2023 13:16:22 +0100
From: Mark Brown <broonie@kernel.org>
To: Eric Auger <eauger@redhat.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-perf-users@vger.kernel.org,
	Jing Zhang <jingzhangos@google.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>, Marc Zyngier <maz@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v3 4/5] tools headers arm64: Update sysreg.h with kernel
 sources
Message-ID: <3c5332b0-9035-4cb8-96ce-7a9b8d513c3a@sirena.org.uk>
References: <20231011195740.3349631-1-oliver.upton@linux.dev>
 <20231011195740.3349631-5-oliver.upton@linux.dev>
 <73b94274-4561-1edd-6b1e-8c6245133af2@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="uhv6snMZQuJsviI5"
Content-Disposition: inline
In-Reply-To: <73b94274-4561-1edd-6b1e-8c6245133af2@redhat.com>
X-Cookie: Santa Claus is watching!


--uhv6snMZQuJsviI5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 18, 2023 at 01:57:31PM +0200, Eric Auger wrote:
> On 10/11/23 21:57, Oliver Upton wrote:

> >  #define set_pstate_pan(x)		asm volatile(SET_PSTATE_PAN(x))
> >  #define set_pstate_uao(x)		asm volatile(SET_PSTATE_UAO(x))
> >  #define set_pstate_ssbs(x)		asm volatile(SET_PSTATE_SSBS(x))
> > +#define set_pstate_dit(x)		asm volatile(SET_PSTATE_DIT(x))

> could you comment on the *DIT* addictions, what is it for?

DIT is data independent timing, this tells the processor to ensure that
instructions take a constant time regardless of the data they are
handling.

Note that this file is just a copy of arch/arm64/include/asm/gpr-num.h,
the main purpose here is to sync with the original.

> > +/*
> > + * Automatically generated definitions for system registers, the
> > + * manual encodings below are in the process of being converted to
> > + * come from here. The header relies on the definition of sys_reg()
> > + * earlier in this file.
> > + */
> > +#include "asm/sysreg-defs.h"

> strange to have this include in the middle of the file

It relies on defines from earlier in the header.

--uhv6snMZQuJsviI5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmUvzJYACgkQJNaLcl1U
h9CzNwf/clb+PGgsMFa+eCK+j+HuF014tCaZnioLYv8VnZelhp7XJYblpFKBu96C
BYJbsasNvFQfrk9GslEXlkmwhC01AtySSh6tJlUmlJ5Jiw/pqm7gbiNOCNm3nLBK
SrEevhgINNICVEsoT99kWfWXdOfqGzTwfge0+IZFsFqgwFGmf6q4x8iENlfv8URr
ZPG78fR4O8PabkMbLK83zih4re0mUs1HMlP3Z7KzPOhPwJThnvIx5Jst60tkyYxa
5vHaqojTJ1ViNIYd2K/oCwrT84Y1uFE4IcVhRVRww/1aM8JJpIsg3Y5/JfQ8Z8Qb
Vi8MLZJTfm+yjlOi4QfKGLtOZMamXA==
=3eRG
-----END PGP SIGNATURE-----

--uhv6snMZQuJsviI5--

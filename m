Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8214C7B
	for <kvmarm@lists.linux.dev>; Fri, 21 Oct 2022 10:45:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4577AC433D6;
	Fri, 21 Oct 2022 10:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1666349102;
	bh=J7/tgj0zGETukgrM7kBytQZ9k9B0vXsbKGc9ccx9mwE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V9jDZnDKZ4ly7SGBtpEnWUgSo4oWfTF5Tv5/EN3XbynhRsqs7T/+03XWHp8sWs19C
	 fqPEyZlxOMIm/DIr91kDpoegLD5bWdFWE436SY/ZCTgVhfL7HCd5nwposBFyPMxiJN
	 Wte9FNAJstcg5uEgiE0eW28UDAUT1sztXXp//DpJkRihq6g33sH2F+NOiHbDuzqADJ
	 VgftPFM+qTuDk8loSTSeZoAaRH4XTtdCLQw6nvSxMTBGjxc+wrwMSCSRoWeuZRlytC
	 s+GXOnyHtrqpiTVy5QKJpaFeZT8Ved/SAanLjeMtWF0cgFlzkBTyVncTW6IoATAPkY
	 qYh/4h4oY+VeA==
Date: Fri, 21 Oct 2022 11:44:54 +0100
From: Mark Brown <broonie@kernel.org>
To: Rob Herring <robh@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>, James Morse <james.morse@arm.com>,
	Ingo Molnar <mingo@redhat.com>, Mark Rutland <mark.rutland@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Oliver Upton <oliver.upton@linux.dev>, Jiri Olsa <jolsa@kernel.org>,
	kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/7] arm64/sysreg: Convert SPE registers to automatic
 generation
Message-ID: <Y1J4JhJZs9w1zn6q@sirena.org.uk>
References: <20220825-arm-spe-v8-7-v2-0-e37322d68ac0@kernel.org>
 <20220825-arm-spe-v8-7-v2-3-e37322d68ac0@kernel.org>
 <Y1FcRNhFpZxZ7AMx@sirena.org.uk>
 <CAL_JsqLVjWH-x3jxGQpJ3ax_ddvBqHd-P2DE=DEnrknoHuq+Qg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="h8OqzCyx1D8l8y4i"
Content-Disposition: inline
In-Reply-To: <CAL_JsqLVjWH-x3jxGQpJ3ax_ddvBqHd-P2DE=DEnrknoHuq+Qg@mail.gmail.com>
X-Cookie: On the eighth day, God created FORTRAN.
Message-ID: <20221021104454.OTHpcFUqtOhLUv95DilK8ol0T71AG7e-zVJ9GsCrV4M@z>


--h8OqzCyx1D8l8y4i
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 20, 2022 at 02:51:02PM -0500, Rob Herring wrote:
> On Thu, Oct 20, 2022 at 9:33 AM Mark Brown <broonie@kernel.org> wrote:

> > > +Field        11:8    EA

> > This looks like it should be described as an enum.

>     0b0000    Not_Described
>     0b0001    Ignored
>     0b0010    SError

> What's the preferred case here?

Either option is good for case I think, it's a taste question - going
with upper case is more the kernel coding style so fine there, though
sometimes it makes things hard to read.

--h8OqzCyx1D8l8y4i
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmNSeCYACgkQJNaLcl1U
h9Atiwf+OSs1WYEEU3S40lQi7fccTKxTPnixytK3Sph02dBD9R/EnwsFK6DnnBsA
hyaxC2aWvjmz1oplivZ7qQwM6CKRyfPoi3f62/L2Ne0A+PILHTWjsr8CRkYHaipd
iPss2Dszd5K65d9ZULDEuUR6tgCWodejetEY1bCu3g7dtB2ZoZPDlfXnvssxm3MP
pKjj58ynCwhGeHMJ6T7ASJOmvvkLbTvLTni4MJ7o56/ltB0+JuNyf28MQzRiG+Ts
A19juSTfZvW8g6aG9P2+byuIXeMJJyas2bz46021mDn6Ch/jkrIfeIsVVlf8UpCp
gHbpAw48zWWXQbb3phklP/cvtYisSQ==
=/DQ9
-----END PGP SIGNATURE-----

--h8OqzCyx1D8l8y4i--

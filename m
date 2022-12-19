Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B31A53217;
	Mon, 19 Dec 2022 15:00:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDE70C433D2;
	Mon, 19 Dec 2022 15:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1671462024;
	bh=JbD1CERCvAqPiTchVboz7aWPTf4CqkVZl5hSSLWV8+Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TWOHbnn13mEX9dougL+e1l5NCO4uC1JocxLiRTSuLMFPPooSOsduPqT9WpQeOtG6O
	 w2zJBKPFa+CLq98BUmfOJTMjK7bvGLBCpvveQ1ekQ8bR2LmWkgnufJ4Obi/Awvwz3M
	 n7qP1lNleQHNul8coOBFRf32nkDXxU7wxe4tfgcU8ogUOrPfC1Itbs9hxlkmwndsXj
	 2rBH/FnRTPol7uGGixifpUdUvmPnbyxy+o72SDzNKVoOPR7m7cPSHLft1yAfwpc1h5
	 lGiwqAGg8ay3BTPXtyoQlRsnMWvSY6wtMMPNexp2/Kzyu25GTC7kKoU8xhzOMlmWgc
	 3GMADB2IG5MTQ==
Date: Mon, 19 Dec 2022 15:00:15 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Akihiko Odaki <akihiko.odaki@daynix.com>, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
	linux-arm-kernel@lists.infradead.org,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	James Morse <james.morse@arm.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>, asahi@lists.linux.dev,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>,
	Sven Peter <sven@svenpeter.dev>, Hector Martin <marcan@marcan.st>
Subject: Re: [PATCH v3 1/7] arm64/sysreg: Convert CCSIDR_EL1 to automatic
 generation
Message-ID: <Y6B8fzaFSwmJ5VC1@sirena.org.uk>
References: <20221218051412.384657-1-akihiko.odaki@daynix.com>
 <20221218051412.384657-2-akihiko.odaki@daynix.com>
 <87cz8hez0i.wl-maz@kernel.org>
 <1ef32b0c-6cee-75f7-e1e0-ede1f5b9a016@daynix.com>
 <87bko0g8m2.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="u5kU4UMJcC0W4wyS"
Content-Disposition: inline
In-Reply-To: <87bko0g8m2.wl-maz@kernel.org>
X-Cookie: I brake for chezlogs!
Message-ID: <20221219150015.u0jfXyKIGTjigQwSOotlGIMKSUisgkHCgJ71D62ykkQ@z>


--u5kU4UMJcC0W4wyS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Dec 18, 2022 at 01:11:01PM +0000, Marc Zyngier wrote:
> Akihiko Odaki <akihiko.odaki@daynix.com> wrote:

> > arch/arm64/tools/gen-sysreg.awk does not allow a hole and requires all
> > bits are described hence these descriptions. If you have an
> > alternative idea I'd like to hear.

> I'd simply suggest creating an UNKNOWN field encompassing bits
> [21:28]. Alternatively, feel free to try the patch below, which allows
> you to describe these 4 bits as "Unkn	31:28", similar to Res0/Res1.

I agree, where practical we should add new field types and other
features as needed rather than trying to shoehorn things into what the
tool currently supports.  It is very much a work in progress which can't
fully represent everything in the spec yet.  For things like the
registers with multiple possible views it's much more effort which
shouldn't get in the way of progress on features but with something like
this just updating the tool so we can match the architecture spec is the
right thing.

> Define an 'Unkn' field type modeled after the Res0/Res1 types
> to allow such description. This allows the generation of

I'd be tempted to spell out Unknown fully since Unkn is not such a
common abbreviation but I can see the desire to keep the name shorter
and it doesn't really matter so either way:

Reviewed-by: Mark Brown <broonie@kernel.org>

--u5kU4UMJcC0W4wyS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmOgfH4ACgkQJNaLcl1U
h9BsAgf/SbrRls2l2YJ4ke3IATlZrBSMsZVI98FuGsLwHeKknHxUHGkJKrMfdbk4
diEmW0Bk69Cn4VAzsMwg7l0x8JMGJwE94sMyUwX0DOC0r1xI/KrAxhS/PetsIlVv
tJQPP9FYO33oJmjDsAqCwaO90Qkdk4I7QrDos/eO+yucA6tISgrM95FSufMwTZqX
9pu8j5CizDnf77pZIXVUjhDMVzdqJsiGg3YTuHZpDXdfXq/COW4ECCMKB25GmCSh
/pB2NEvWJoX6ZiDoyi7XxokmMv8nOPnMYyahTM1jO2N5tEcav9E4t9levchdQ5n0
PTo3pY7o2LisFYorkFn5o4eys9hYRw==
=BwsC
-----END PGP SIGNATURE-----

--u5kU4UMJcC0W4wyS--

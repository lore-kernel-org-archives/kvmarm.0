Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69EE72F33
	for <kvmarm@lists.linux.dev>; Thu, 15 Dec 2022 13:21:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10AB6C433D2;
	Thu, 15 Dec 2022 13:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1671110483;
	bh=+CxRf97wKw5LZIy3L7qadCeea3KfzKiwi/UZlTglQt0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MWdAn2Z8H3skxtEsZe+M6i5sp+w58R0QFQY1okL/ZHQkjDTyECg7azxap2eGkoCv5
	 F6u4jVPr7K6ERZAtYZPtvk/NUL37YcIRtHEEonyfF3Z+PUKXKKvqkcYPVCfCCKmsWo
	 63pnUJ0lhXtS7pzo915/Jg7DEzLO6rrUuXD5JJY2/PtiZCYn6vDEg/ohr5RofbN4q5
	 IS8VJK5ti+iP16tOz3ty7aPZWLGx0Ay64mmeMyAQ3r4u/7oHv3KAWzkzBIsGSXtYnZ
	 sULfNocW1wb9/jfrfp16TYBXzrFW/jzgDCwx/yyiEbW4BLajJnPUcrNtWxs9H/kr2I
	 cBgrFCklmbmJA==
Date: Thu, 15 Dec 2022 13:21:17 +0000
From: Mark Brown <broonie@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sami Mujawar <Sami.Mujawar@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 10/14] arm64/nmi: Manage masking for superpriority
 interrupts along with DAIF
Message-ID: <Y5sfTaKuaXhX0io9@sirena.org.uk>
References: <20221112151708.175147-1-broonie@kernel.org>
 <20221112151708.175147-11-broonie@kernel.org>
 <Y5c9SLeJacLYHmP7@FVFF77S0Q05N>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="KCOqecMlU6no7mXW"
Content-Disposition: inline
In-Reply-To: <Y5c9SLeJacLYHmP7@FVFF77S0Q05N>
X-Cookie: Today is what happened to yesterday.


--KCOqecMlU6no7mXW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 12, 2022 at 02:40:08PM +0000, Mark Rutland wrote:

> Please, no. NAK to pretending this is part of DAIF.

> The existing hacks to bodge pseudo-NMI into the DAIF management code are
> convoluted, difficult to maintain, and they have known cases where they
> *cannot* do the right thing. Those existing hacks have proved to be more
> trouble than they're worth, and continuing down that path makes things worse.

As discussed elsehwere I do agree that the current "DAIF is an
abstraction" approach isn't great and cleanup is needed but have a hard
time seeing these changes as making things appreciably worse than they
already are with pseudo NMI.  In any case there was some demand for the
patches to be out there, and for collaboration on the GIC parts so I'll
keep posting the patches in parallel with the refactoring.

--KCOqecMlU6no7mXW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmObH0wACgkQJNaLcl1U
h9CNqgf/XR9+Ops3ZVM0iyqSZV26wNG8n4C4vKx5+G4qpgn7iTnnrOTpZf9ekCac
k+XF+UbFvDQIajTP2d5119dYLcmhYbQgceqjjJFzoeGpHlZAtWm15Z4dt+DDlaWv
DAbmYbfAaMzu9RfHI0D6n4d38oYxpto+Ssdj2Qdcjta0q/V80tJlbLbEfh5iX9V7
WhCoeNaFX6e9e4Aggf0GH9P7Unn0BGnGhRqXygaJv+Pm/CPDZIzwXxMjsWoaMSVR
B5CpT7/32fQyXo5R5TO0U5LimRCM0N8uj1eA3KzAix2SUFLlLUzRupCED/L+sLqn
FXQInLmAkae3nseNdgYvB43zROTHGg==
=Mj2W
-----END PGP SIGNATURE-----

--KCOqecMlU6no7mXW--

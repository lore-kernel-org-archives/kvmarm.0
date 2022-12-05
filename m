Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48798485
	for <kvmarm@lists.linux.dev>; Mon,  5 Dec 2022 18:24:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 446AEC433D6;
	Mon,  5 Dec 2022 18:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1670264656;
	bh=RSmRtYzc6i2xvWBsvFS8Uf0biPw7jPX/IOIw/QKoJAw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ffIX/X/BU2ooqX9ZGJW7MtTCFO+K3PoCQ0H04qsA9BV+loNYVoUVrj6cdG+KkiSGy
	 2mXbfuC9qvaM3CLYaKKgXAfVdqpeu3JRzoPgTYEnbYQ5CB1AEv3KoRzE+12lQ38rm5
	 TwjU4c9TPjpaWXsyt3SdWZFSoDJll7VSkJ53sErQnGMquVKMCuDonQKQgctUOTMcwm
	 mZVjYQqZmwhHaaNiba1Dvg3o6G5XHbgcu3MrCcCHwE+THaS4w412iBfFYUoAI0CMF8
	 qElJY6w/0Rb/jM1wxOckzQUuFzZBBvCWmv7CmdG90uIb56c80Op6d1veCxtKFGCoNX
	 MZbgE561+jdjw==
Date: Mon, 5 Dec 2022 18:24:09 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Sami Mujawar <Sami.Mujawar@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 05/14] arm64/asm: Introduce assembly macros for
 managing ALLINT
Message-ID: <Y443SY8/lCcDQvYj@sirena.org.uk>
References: <20221112151708.175147-1-broonie@kernel.org>
 <20221112151708.175147-6-broonie@kernel.org>
 <86tu29lpwt.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="7QND8mUu06fa87IG"
Content-Disposition: inline
In-Reply-To: <86tu29lpwt.wl-maz@kernel.org>
X-Cookie: If it ain't broke, don't fix it.


--7QND8mUu06fa87IG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 05, 2022 at 05:29:54PM +0000, Marc Zyngier wrote:
> On Sat, 12 Nov 2022 15:16:59 +0000,
> Mark Brown <broonie@kernel.org> wrote:

> > In order to allow assembly code to ensure that not even superpriorty
> > interrupts can preempt it provide macros for enabling and disabling
>                         ^
>                         \ Insert comma here

That would give ...not even superpriority interrupts can preempt, it"
which doesn't make sense to me?

--7QND8mUu06fa87IG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmOON0gACgkQJNaLcl1U
h9AvbAf9GTO7sLLBg775rHVe168BJWhX8iLLrsIAL5Q90mcLBiV5O98ZQEy518n0
HAYzetU/gKA704uZTnBC0mricf4Zua4kUGZQxtlTdAW/3M6XEKFrIAdPT229pUky
m8gbeIMDeaVSvgGE2K5Q821HJvLx5sktlxGuRFX8UN9TMYcTIUCZPDUIX3XNdiDv
AjDUTi6vLzFFI0txqm/xN99H9saaAVUeOo0tanv/Z0YI90lQ4xsl1nJgat9t+/QM
eyJGWScaseVAuFqCeqq8iYxZ3BPccjC4Lxtu73SvlsG6axp7YfxIUNanrnCPHjOZ
EPml8/bc3EK/Z6/4NH7/09ph3O/FJg==
=eNNl
-----END PGP SIGNATURE-----

--7QND8mUu06fa87IG--

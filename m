Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4599F186A
	for <kvmarm@lists.linux.dev>; Thu, 27 Oct 2022 12:01:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41F8BC433D6;
	Thu, 27 Oct 2022 12:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1666872068;
	bh=NBHku0LesE6Ebansrxog0289M6p4acLf0fbsGZZm1Yo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bmuIq15H15nKzb+yTXO7crv1NcpgwswZ4K8LpyiPiEkvFMNZ+vqtLUGY4tTN605z7
	 Q5yGeCIdJCz3XEynDnCtcn38kKJbujCdW9cD2r8DLXTa7D+fCY2wtow6TDxSRfKxQN
	 N6xG5HhuLNJYCPJaBN9O/9nSQl11brbZ1pT95SaO3M9NurFSDJnb3Aw2DTQPaissy/
	 wjmefquA94ZWqbljzXXXL9kyZKn83ctC9CR6zhg9BIZwi3eBKllejN+UCeswtcoy/C
	 MnL5/RDU0QOaOIEtVksAPccbedmDG8s4J/g6tT4hGDYpcw8ARS1IDD6L0Ah4v0g8Zo
	 lz4kt2wukhx3A==
Date: Thu, 27 Oct 2022 13:01:03 +0100
From: Mark Brown <broonie@kernel.org>
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Marc Zyngier <maz@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>, kvmarm@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org,
	Richard Henderson <richard.henderson@linaro.org>
Subject: Re: Hang with nVHE mode and SME
Message-ID: <Y1py/6L+UtLL0QJy@sirena.org.uk>
References: <Y1lEWJ7rO4m1CKWL@google.com>
 <Y1lNKcXfy/nHzTQ9@sirena.org.uk>
 <86ilk6ef5x.wl-maz@kernel.org>
 <Y1lhrB3lq5dZAin1@sirena.org.uk>
 <CAFEAcA-mo_ywRnC53aFfkYP=q3zDBD7U4sBSrzg7ZfRQA7QYXA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="yYXKwQkUu+g2jShh"
Content-Disposition: inline
In-Reply-To: <CAFEAcA-mo_ywRnC53aFfkYP=q3zDBD7U4sBSrzg7ZfRQA7QYXA@mail.gmail.com>
X-Cookie: Forgive and forget.


--yYXKwQkUu+g2jShh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 27, 2022 at 10:44:39AM +0100, Peter Maydell wrote:
> On Wed, 26 Oct 2022 at 17:34, Mark Brown <broonie@kernel.org> wrote:
> > On Wed, Oct 26, 2022 at 05:13:46PM +0100, Marc Zyngier wrote:

> > > So the question is whether we work around this in the kernel (not
> > > enabling either KVM or SME if FEAT_FGT is not present), or leave it as
> > > is with the hope that QEMU gets updated.

> > > I'm inclined to do the latter. Thoughts anyone?

> Is the "kernel needs FEAT_FGT here" requirement a strong "the design
> just means it's kind of expected" one, or a weak "the features
> aren't really strongly tied together, it would be easy to do without"
> one?

We need it for nVHE mode since we need nTPIDR2_EL0 to trap access to
TPIDR2_EL0, in VHE mode this is controlled by SCTLR_EL2.EnTP2.  Looking
again I need to double check but I think I missed control of nSMPRI_EL1
which will be needed in both VHE and nVHE cases to trap access to
SMPRI_EL1, that's not controlled by the overall SME enable.

--yYXKwQkUu+g2jShh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmNacv4ACgkQJNaLcl1U
h9AwEAf/Z3VvvuoQdEbqIKMcIeRporna7fSLxko6pxrWMywNHAu6VkWwskdf0ZxQ
LdV0j/J/CZUuCduHuuQPYpjs3VMVgdmacQ3CE7gyNOdUU7mLjqfZyq5s0e+ihq98
m/+FCTjWyKu95vOOtNDf/LwnaUxpoBThe0Ry96kpb0YvSDu2gLrTIcNsd+CLzDDD
GQbZVbXoNEXVLcpuJH5z9WjnINh3/Jn0E4EJ2Z8fKkYTuvIP8VfkgDosG2UGHARv
fLfSIIfn086QuCdID28vrd29ORmIkVb8imKU+BL1VKzPn9emUCZ4p4R4ljawAp96
bcW2LZAwV3ouGer2XIbF9T/BBieqpA==
=bSxN
-----END PGP SIGNATURE-----

--yYXKwQkUu+g2jShh--

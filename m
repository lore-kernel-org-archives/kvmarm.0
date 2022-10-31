Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0570F210D
	for <kvmarm@lists.linux.dev>; Mon, 31 Oct 2022 12:41:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11C8AC433D6;
	Mon, 31 Oct 2022 12:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1667220069;
	bh=HMNx1hrp11jgENjF5RzmPDz9iyn1uE2eUxOGlwvFQRM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Bps13rvmm+i9wk07EuLbGooylHl7SySIrIc3DFLaucOD+lamE9kofflondovmqtbv
	 L8RXvDCldQD3yF/GcNOuJ8oS1NC0NQwoS+YmyH+IRXfgd8PCNVZqZENxBTemO7lDfF
	 Z6adh+hBmK/BNNe6vEERR+lZfPGh6a+t/kETfCZ7ZUplwkAF9WIRxQQoA8dBYEfLoi
	 8HxJR0LJXDFgO/Z/QuuJkcx71ahKk2++EzdJenZBd8TUvCGjytHQ6zUesPgZsBp/HO
	 qXTFTUfVrsrJtuLgLZ4JkNI11Ktum4gkOpSX/NRyPSxSncUjncIIQQwnFd8EQDgT39
	 Tlfh9uaxIiqUQ==
Date: Mon, 31 Oct 2022 12:41:03 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	stable@vger.kernel.org
Subject: Re: [PATCH v1 2/2] KVM: arm64: Trap access to SMPRI_EL1 in VHE mode
Message-ID: <Y1/CXxJAlKh+1a5c@sirena.org.uk>
References: <20221027210441.814061-1-broonie@kernel.org>
 <20221027210441.814061-3-broonie@kernel.org>
 <86eduoe377.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="6QAplWSIK0pbcPbR"
Content-Disposition: inline
In-Reply-To: <86eduoe377.wl-maz@kernel.org>
X-Cookie: Sign here without admitting guilt.


--6QAplWSIK0pbcPbR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 31, 2022 at 09:45:48AM +0000, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > +		/*
> > +		 * Disable access to SMPRI_EL1 - we don't need to control
> > +		 * nTPIDR2_EL0 in VHE mode.

> It really isn't obvious to me why this is the case. The pseudocode
> says for a 'MSR TPIDR2_EL0, <Xt>' (DDI0616 A.a p225):

Yes, I was just discovering that while checking and replying to your
earlier mail about the other series.  I'll respin.

--6QAplWSIK0pbcPbR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmNfwl4ACgkQJNaLcl1U
h9Cqowf+POMGFXj80Qia1N+Z4neZMmila0dYQipsa5ubWgGpzSukyBme6dX61G0q
DYa3amIF6ctMnoPh9XfvFeX+fc075k/e9Okk7zapokK+atyNwSCjG12qfY9l9CkK
4M2VIACD3fASlphaRC0tYSW3CS9B9uNmlj/+JZ33IFpUfdRgejSuhAGx6H/up9sL
nuxBpmstZ05UwJNINfAibEACjZcYdkwcB9x6/5jKOyM29vp2+63tpFj8NzTvwNDO
CgrvpPzYE1O3p1hJOeM7jyWkZ2xqqw0ew/Gt9c2dA8aXRcn7LTRPs22L5ikQd7ly
3Q8NFLu3YZZArUZti2KjdVcWAmUk4A==
=QHLy
-----END PGP SIGNATURE-----

--6QAplWSIK0pbcPbR--

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA6815AE8
	for <kvmarm@lists.linux.dev>; Tue, 10 Oct 2023 11:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z6w98R1D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43271C433C7;
	Tue, 10 Oct 2023 11:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1696938456;
	bh=dGsrZo+vQ1VzJbbq+maOQwDfORosg5+dHAq6SOZW1fU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z6w98R1DPjR+hK+Pvfba9+Oe+swBF1fj3sbhODwLVVzS4l0cNsbvPqOyQNlKURMDu
	 6nadmgt7plrPizzdJ1voklnWCigMP4z+cRGtDLbXCHx/2WfSMk7JBIB9BF0wh8X22S
	 1rSBtn7QQKsiWKay3ZeX2JPUILNKfQIuC03XZbHWENdHW++GPegW8rCBjUhHnc/He8
	 60QYi96y4h0xXS2JqshRiHKYttFtMk2O/l6Hgl5Bqx5AdHjOg5b+S3lKeY+nhBWNNK
	 o+BhRIn+ukTgFldxd7spQOCVf6FCTGaw825s99Q3IfZ+8HxKxT3szW5RMNhEk6DuP8
	 3DvuSsMmkMm5A==
Date: Tue, 10 Oct 2023 12:47:19 +0100
From: Mark Brown <broonie@kernel.org>
To: Joey Gouly <joey.gouly@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, nd@arm.com,
	akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
	catalin.marinas@arm.com, dave.hansen@linux.intel.com,
	maz@kernel.org, oliver.upton@linux.dev, shuah@kernel.org,
	will@kernel.org, kvmarm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 05/20] arm64: context switch POR_EL0 register
Message-ID: <c47d888c-e6be-47df-9ad2-af0f11fd5714@sirena.org.uk>
References: <20230927140123.5283-1-joey.gouly@arm.com>
 <20230927140123.5283-6-joey.gouly@arm.com>
 <b1e43c42-111f-43e3-9e24-89ddef76fedc@sirena.org.uk>
 <20231010095423.GA2098677@e124191.cambridge.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="c1gCxq1Eu5WP02VS"
Content-Disposition: inline
In-Reply-To: <20231010095423.GA2098677@e124191.cambridge.arm.com>
X-Cookie: I feel partially hydrogenated!


--c1gCxq1Eu5WP02VS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 10, 2023 at 10:54:23AM +0100, Joey Gouly wrote:
> On Thu, Oct 05, 2023 at 03:14:50PM +0100, Mark Brown wrote:
> > On Wed, Sep 27, 2023 at 03:01:08PM +0100, Joey Gouly wrote:

> > > +	if (alternative_has_cap_unlikely(ARM64_HAS_S1POE)) {

> > Why the _unlikely here?

> The only options are alternative_has_cap_{likely,unlikely}().
> I went with unlikely as currently it is unlikely!

Oh, if you have to pick one it doesn't really matter and that seems
sensible.  Usually they're optional so outside of very hot paths they
tend to be an antipattern.

--c1gCxq1Eu5WP02VS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmUlOcYACgkQJNaLcl1U
h9CHBQf/ZXcCmrREeYk6HjwOAXBpILDhJEYF552Me/bljo1xHTcfrJ29itnqdzJd
tJO760glWJ/CT+tmsH2Td0cYKaRZENARTmvlIpF0Dn0gUkdvusyYk8MD7s+2gmx1
BaKOAAD0/WcE+4bWknMiYw7au2dFq6unT9xlXJY5ykHubP5YS/EqRrMBM+AEKpY/
tnnjr5FboCv+867dluZHV4RGf09RsTf48iGGGJZjpKmoCB1I4UKMP9PfRJ492+dS
Dy9i0DtFr+dq552w6Sk5FhUV9tsvf5RD0XNUu73vQnBDFQ9TgCkzLOwnjaC/nxh7
2OLfAXCgeMqpBYoe5PHtp6VuSE9Qiw==
=Qpeh
-----END PGP SIGNATURE-----

--c1gCxq1Eu5WP02VS--

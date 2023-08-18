Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855A1612B
	for <kvmarm@lists.linux.dev>; Fri, 18 Aug 2023 19:38:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDBE7C433C8;
	Fri, 18 Aug 2023 19:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1692387492;
	bh=01Q2xEmAO2pVJWHzK9M3MZQdGCIPPOuErEoePLDfq+0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZvLDUejgDxFNb6IhI4Y0qdql5M25cqQLtbiufVm4Gb1iXmTmAB0Vv7ahIz5a06KAb
	 PUVYYrLHaNR/SZqrZU0yrVK5FDSBVeGGfofO9+Df7X5NWY2X9XcazAltA6H9EsHtv+
	 fc4AWwR9CKunnY9EpyNqH+5BjOB9QdtB0QMaWXxuq/yd9mPtqlVE1q+rF9jr+uSXsI
	 f1NsCWGQH8w59yUVRi8q2TubicSUqChyEh/LQmmTFJ4Z4wetsknCZ6enP2KXAnB49z
	 oUn0kP6MHyAsmo5BdzSFWx5eauk1ZDTV4IrU/9IN+nMSi55OIHvkUfyBmizMa3JLC6
	 ole8zbgLwOsiA==
Date: Fri, 18 Aug 2023 20:38:02 +0100
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Arnd Bergmann <arnd@arndb.de>, Oleg Nesterov <oleg@redhat.com>,
	Eric Biederman <ebiederm@xmission.com>,
	Kees Cook <keescook@chromium.org>, Shuah Khan <shuah@kernel.org>,
	"Rick P. Edgecombe" <rick.p.edgecombe@intel.com>,
	Deepak Gupta <debug@rivosinc.com>, Ard Biesheuvel <ardb@kernel.org>,
	Szabolcs Nagy <Szabolcs.Nagy@arm.com>,
	"H.J. Lu" <hjl.tools@gmail.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org
Subject: Re: [PATCH v4 03/36] arm64/gcs: Document the ABI for Guarded Control
 Stacks
Message-ID: <aaea542c-929c-4c9b-8caa-ca67e0eb9c1e@sirena.org.uk>
References: <20230807-arm64-gcs-v4-0-68cfa37f9069@kernel.org>
 <20230807-arm64-gcs-v4-3-68cfa37f9069@kernel.org>
 <ZNOhjrYleGBR6Pbs@arm.com>
 <f4cec4b3-c386-4873-aa1d-90528e062f2a@sirena.org.uk>
 <ZN+qki9EaZ6f9XNi@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="LNILMu582aOVL6hM"
Content-Disposition: inline
In-Reply-To: <ZN+qki9EaZ6f9XNi@arm.com>
X-Cookie: Your aim is high and to the right.


--LNILMu582aOVL6hM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 18, 2023 at 06:29:54PM +0100, Catalin Marinas wrote:

> A related question - it may have been discussed intensively on the x86
> thread (I may read it sometime) - why not have the libc map the shadow

Your assumption that this is a single thread feels optimistic there.

> stack and pass the pointer/size to clone3()? It saves us from having to
> guess what the right size we'd need. struct clone_args is extensible.

I can't recall or locate the specific reasoning there right now, perhaps
Rick or someone else can?  I'd guess there would be compat concerns for
things that don't go via libc which would complicate the story with
identifying and marking things as GCS/SS safe, it's going to be more
robust to just supply a GCS if the process is using it.  That said
having a default doesn't preclude us using the extensibility to allow
userspace directly to control the GCS size, I would certainly be in
favour of adding support for that.

> (I plan to get back next week to this series, I'll need to read a bit
> more on the spec)

I've been making changes, mostly in response to your feedback, so there
should be a new version on Monday even if not everything is addressed
yet.

--LNILMu582aOVL6hM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmTfyJkACgkQJNaLcl1U
h9Cw3Af8Cnyy0Sa1PU1lq3c1HV/d6eNcVzOoN4kECuID3B/GKxWng90W0Z7wR75z
Wl9H0WZxlDkqd/voFGHAJTEtlcEZMg6xNByq8Rhq2jw6R2EX3O8P6+Uqumjb3UQ8
wb+PJyloj3BhXcQPiMH8vFHAs6b81DyPYo9NtaCLsYbtZv4MwGjgJKRrAl8+O2ct
n/1P1Hpp/XUeTZUZvyWxrBdDUD7nLq9mQe2/+h6NxTtchrNTb98Kvgk7JrRefjrB
7kehDj9XiBJt5vVkoSO+e5aVln7wgwWor3KsjviaeNzyXglWrx+VBIc8OT6FMiJw
VIA6Wrc8ikvi1fZ/oooK9TnU+p5chw==
=RgY5
-----END PGP SIGNATURE-----

--LNILMu582aOVL6hM--

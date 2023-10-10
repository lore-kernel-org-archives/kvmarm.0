Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4290E387;
	Tue, 10 Oct 2023 17:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WwCmMnxE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF2CAC433C7;
	Tue, 10 Oct 2023 17:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1696960233;
	bh=Mo9lqyFkQXXEXAFmp24RRwmqCIlZ0kZbVyXTlYQiD34=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WwCmMnxEeWi69FrbQxpiGl0f2JnQCje5HKRtCzMAX4eAONn5k1wVlicDh/3LWVK3I
	 OvI5XbhukfiUNJEyyenK/0l+drjWmEldavMl93Uae15ux1aD+9Ew/41UQvZl11+N7A
	 XMvmXniMqzC9OKjwwXM1HRsoyfXH5420mqNf/ePLw7Axma4yCBPRr51FpcmUlqCUjZ
	 Y9zC4V5rCx7bcmF2chkrIf/24laI2ZQ40euckGLDM/zYQt4AUHzraLSOaL9iJRzEMj
	 YJEaF2RR3rGWbKJYzzAslkNfUmfoIWo6X1to4c6qMvOy818USfW1jjbOZ/9yRrI2wp
	 lz5i2ytrjrOUg==
Date: Tue, 10 Oct 2023 18:50:25 +0100
From: Mark Brown <broonie@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
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
Subject: Re: [PATCH v2 1/5] tools headers arm64: Copy sysreg-defs generation
 from kernel source
Message-ID: <b80e1d8c-0632-4678-b901-fca04e54702a@sirena.org.uk>
References: <20231010011023.2497088-1-oliver.upton@linux.dev>
 <20231010011023.2497088-2-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="OfKkgm1QQ5YBS8gp"
Content-Disposition: inline
In-Reply-To: <20231010011023.2497088-2-oliver.upton@linux.dev>
X-Cookie: I feel partially hydrogenated!


--OfKkgm1QQ5YBS8gp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 10, 2023 at 01:10:18AM +0000, Oliver Upton wrote:
> The system register definitions are now generated with a script over in
> the kernel sources. Pull a copy into tools in anticipation of updating
> dependent header files and add a common makefile for generating the
> header.

Reviewed-by: Mark Brown <broonie@kernel.org>

--OfKkgm1QQ5YBS8gp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmUljuAACgkQJNaLcl1U
h9Ayjwf/Sf7xWekjbJb0Igp7EednDFE2qisnUaz9s0smFr87OX1Wnf2JwTZMyPKs
e/Y29fY4jVLbPswcu9Hl9MaFaf7jezEpm+hXcTxtH7VHPuYn/iZ5KAaraUIB7rrQ
Ao7JxyzRV4A8db0YUX9YL+2WdejLPccCemxGV9uDrY1KlL2G30UW/8NceHXdxZQV
yFfdYIjO+QPqjIo29jmqAi8CCzrPqS7lLCG3wstSJbOI2gFCrvmip5QyC0jjIPjq
9WK8IxjwHo8CdKiE7pvb2EfWv2UJkj9Y0ePtLPnFDeJIf3lKNpqS8hvRayuplbiW
GKa6LgmnOJso7nRD7H9u+GQ1nD9tQA==
=H8a+
-----END PGP SIGNATURE-----

--OfKkgm1QQ5YBS8gp--

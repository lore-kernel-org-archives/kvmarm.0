Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E1DD18639;
	Tue, 10 Oct 2023 17:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nhVR5y3I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 012F1C433C8;
	Tue, 10 Oct 2023 17:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1696960396;
	bh=cx2JxC0iURoRrWYffKAIdyccngOQUSODrrfk6c46CX0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nhVR5y3ImuE6z+RPfhVgYEQnhivVmAi97QFivStdWin4b8hzgp9FcFx0Qiv7k5Wm2
	 tnkTOqWE/sQiYNH8Pxe678vlCddD4B44/Q9wvG2r53eJtg23BqWf7sCgqlwkfGBLhP
	 E/gSvEFy/mgt7p7kLzsB2X/PNIF0Z+Bk0xsdkowb9FVeab53gA40sHtoTmWeMG8Z3A
	 Otc6jznPjdLktcWeP5xM/lQm1lKlyUQDbcyu51BxO9OT3SwK8eCfaSHIbqIknbHgcF
	 CtRDcEKjk1nCMCJP5IpMUuYlql+TSlLv5dKUDqj3zS6NM6q2HlrFltDNBOCLxaYFaA
	 XUNAw21CgYUlw==
Date: Tue, 10 Oct 2023 18:53:08 +0100
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
Subject: Re: [PATCH v2 3/5] KVM: selftests: Generate sysreg-defs.h and add to
 include path
Message-ID: <cc827136-c62f-4460-a49e-94d1b42c1f1b@sirena.org.uk>
References: <20231010011023.2497088-1-oliver.upton@linux.dev>
 <20231010011023.2497088-4-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="zcteXYz5fZJBP43J"
Content-Disposition: inline
In-Reply-To: <20231010011023.2497088-4-oliver.upton@linux.dev>
X-Cookie: I feel partially hydrogenated!


--zcteXYz5fZJBP43J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 10, 2023 at 01:10:20AM +0000, Oliver Upton wrote:

> Start generating sysreg-defs.h for arm64 builds in anticipation of
> updating sysreg.h to a version that depends on it.

Reviewed-by: Mark Brown <broonie@kernel.org>

> +ifeq ($(ARCH),arm64)
> +arm64_tools_dir := $(top_srcdir)/tools/arch/arm64/tools/
> +GEN_HDRS := $(top_srcdir)/tools/arch/arm64/include/generated/
> +CFLAGS += -I$(GEN_HDRS)

We might want to hoist this up to the top level lib.mk at some point if
other kselftests want it too but let's not worry about it until it's a
practical issue.

--zcteXYz5fZJBP43J
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmUlj4QACgkQJNaLcl1U
h9CG2wf+LXRRosmuRsHr2KwWjh2URdt60VoRwaDmXhh7/pGe09afffuBz2c6/3So
So6ZdTfUue2ois6c+GACxKsjhcBOYxaNEkXubiv0KrqCNHsALoxTjB6uhD+3+Nuo
9Xz8ieecM9loqu7AYV+69udmy7bIKyt+aDm6bRtL0OoixTbAuH6qPzfOv1cV2AoK
ESB9tqrPI1MnK+I5O9peYaBvEevsB1CnI47LU4Mjb9679mN+1I0WeT4cMLmwHN8b
BWry5Nw7cQpiYosGLCvw3ZBbeBywPcYHc60h/O7DgJ8Ti53tTWsB/ndx1cxvlY/u
DSOo/pPUSSEO5bTag4/mlztczNALwA==
=0wtO
-----END PGP SIGNATURE-----

--zcteXYz5fZJBP43J--

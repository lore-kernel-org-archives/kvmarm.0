Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E0B20EA
	for <kvmarm@lists.linux.dev>; Tue,  1 Aug 2023 15:10:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8ABAC433C7;
	Tue,  1 Aug 2023 15:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1690902607;
	bh=+bBPLGmDmXfC/yfM3zDVF6K5Ga/agNFu5ARhnA02LuA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r8zuzbiIsBm8TplmUwNtJnkj0WqQ7Bj07Nu9yp5ar/EYSV4LQQ3uL73ELCG1L41jq
	 YvuaYQlYhxf9lYlvrNjTqqiK+hh/mmVXlCFhYNKELooEaDF+I16iw9dkxuoVH8Tf4r
	 MMzAnPUycWbbea6niD+2vJ7S6VYgMcnxfQ/W8n2WzYs3ch5uSe4487LN6555t9Fsr1
	 MEStdbDlfoeEftOw+xyV2O2Pyy2neIm2BVU9icTY0M0HKHFlx8zXeaGqKT88HFeDBP
	 24CXRV2GJ39ZT5XdVsrhKrH4rhJNw34F9/DVHpaPG+sd+VlTEmdea7RgrgWKh2lT9O
	 L985DdCd9UJCA==
Date: Tue, 1 Aug 2023 16:09:58 +0100
From: Mark Brown <broonie@kernel.org>
To: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
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
Subject: Re: [PATCH v3 00/36] arm64/gcs: Provide support for GCS in userspace
Message-ID: <09b7a94d-cc88-4372-85de-52db26bc2daf@sirena.org.uk>
References: <20230731-arm64-gcs-v3-0-cddf9f980d98@kernel.org>
 <20230801141319.GC26253@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="eVo2yRFuK2CxHWEO"
Content-Disposition: inline
In-Reply-To: <20230801141319.GC26253@willie-the-truck>
X-Cookie: I thought YOU silenced the guard!


--eVo2yRFuK2CxHWEO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 01, 2023 at 03:13:20PM +0100, Will Deacon wrote:
> On Mon, Jul 31, 2023 at 02:43:09PM +0100, Mark Brown wrote:

> > The arm64 Guarded Control Stack (GCS) feature provides support for
> > hardware protected stacks of return addresses, intended to provide
> > hardening against return oriented programming (ROP) attacks and to make
> > it easier to gather call stacks for applications such as profiling.

> Why is this better than Clang's software shadow stack implementation? It
> would be nice to see some justification behind adding all this, rather
> than it being an architectural tick-box exercise.

Mainly that it's hardware enforced (as the quoted paragraph says).  This
makes it harder to attack, and hopefully it's also a bit faster (how
measurable that might be will be an open question, but even NOPs in
function entry/exit tend to get noticed).

--eVo2yRFuK2CxHWEO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmTJIEYACgkQJNaLcl1U
h9BQawf/f0SGHhLVQUgdnRJbAN6lBuDUQfirqOPQbGb1BDJkA5bBH3gggqgDiUP9
iuDR87qdT9VDbUW0rgSKaYDAizuTvWthjfPv3Y0JOAgM9fmGmDmyldhVOSrmbRQF
hW3jgZbWRG0UK44PpWKLX2z13fGx9xVitteScPpIhF9r2o8kmq3SoYO7a681hQLI
usvrKaEpMYgeGeSm+2qlQj5sQnVNNrRD3u1BLbOuu6uRfWWtoUS+cFxUUUMNcmbi
1ZrrHuAy4ZanoowjW4HLjzhtQDVSPleqsZGfnChKMuZhXPqpBl74qWAMs8x9bq/F
iC0yz6XbrIQqfBkmNljqf0Kj03fpLw==
=2KV+
-----END PGP SIGNATURE-----

--eVo2yRFuK2CxHWEO--

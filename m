Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4240222EF0
	for <kvmarm@lists.linux.dev>; Tue,  1 Aug 2023 18:03:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA578C433C7;
	Tue,  1 Aug 2023 18:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1690913020;
	bh=t4H5U4PdS9V7b/INAz2Uy/vEVIT0Xt3TQ516E4LoedE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eb+N0V+12cPD0i8TS0jZxiFvWkwxmipgCkdOFw6ouNtBI/NQVs2BFc7sHUmrpwyCh
	 VuoPO7d74PzyBkkFiDMg3YcFzKCgYOEr01eQHqzHDI9cESZlowMv4HcxuyUscedv6w
	 S1CAHXieY6gOG3NZLDdYRyuIxU6uHN5a1douIJAOmXNjepUt5/KdUwH1d/CL2758rE
	 dQeE/68pY2slNKM6bss4odlurVY3vXKs4+gbUXXzYCpz4QGJBcUcjx9ChA26G6Tgm3
	 MNL8f8jAH07J0XewHxoZ5jsLgMq+M+ewSxv/p30AaJ5aQACGjnfruGfm5XA0k+CruF
	 cD3DmFo0iCa3g==
Date: Tue, 1 Aug 2023 19:03:31 +0100
From: Mark Brown <broonie@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"corbet@lwn.net" <corbet@lwn.net>,
	"ardb@kernel.org" <ardb@kernel.org>,
	"keescook@chromium.org" <keescook@chromium.org>,
	"Szabolcs.Nagy@arm.com" <Szabolcs.Nagy@arm.com>,
	"shuah@kernel.org" <shuah@kernel.org>,
	"maz@kernel.org" <maz@kernel.org>,
	"james.morse@arm.com" <james.morse@arm.com>,
	"debug@rivosinc.com" <debug@rivosinc.com>,
	"aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"hjl.tools@gmail.com" <hjl.tools@gmail.com>,
	"paul.walmsley@sifive.com" <paul.walmsley@sifive.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"oleg@redhat.com" <oleg@redhat.com>,
	"arnd@arndb.de" <arnd@arndb.de>,
	"ebiederm@xmission.com" <ebiederm@xmission.com>,
	"will@kernel.org" <will@kernel.org>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
	"linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
	"palmer@dabbelt.com" <palmer@dabbelt.com>
Subject: Re: [PATCH v3 21/36] arm64/mm: Implement map_shadow_stack()
Message-ID: <1237441e-3e1a-4682-b3bf-face931640d3@sirena.org.uk>
References: <20230731-arm64-gcs-v3-0-cddf9f980d98@kernel.org>
 <20230731-arm64-gcs-v3-21-cddf9f980d98@kernel.org>
 <5461c56cf4896f18bddaa66c3beec7b909fc8fb9.camel@intel.com>
 <0a6c90d6-f790-4036-a364-d4761fdd0e95@sirena.org.uk>
 <e827138f9d8800e3db158831bca88d1ea8b559af.camel@intel.com>
 <21d7e814-8608-40ce-b5d3-401f2110ad91@sirena.org.uk>
 <a9ea33d31aad0c45eab41b0dcbd4913d863cc930.camel@intel.com>
 <20230801172814.GD2607694@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="p8glKsiXtjodSLAk"
Content-Disposition: inline
In-Reply-To: <20230801172814.GD2607694@kernel.org>
X-Cookie: I thought YOU silenced the guard!


--p8glKsiXtjodSLAk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 01, 2023 at 08:28:14PM +0300, Mike Rapoport wrote:
> On Tue, Aug 01, 2023 at 05:07:00PM +0000, Edgecombe, Rick P wrote:

> > So the question is not what mode should arm support, but should we have
> > the flags match between x86 and ARM?

> What if the flag will be called, say, SHADOW_STACK_DEFAULT_INIT?
> Then each arch can push whatever it likes to and from the userspace
> perspective the shadow stack will have some basic init state, no matter
> what architecture it is.

x86 might have some fun with that and the existing userspace binaries...

--p8glKsiXtjodSLAk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmTJSPIACgkQJNaLcl1U
h9BcMwf+KLcNdiJZ3DEJDS8jRNNMVfxtKYOXlc4QIY6Iix9aZ5E6QB8ZJoOmkK4Y
qzBMySqHh+SYZsz1IZrt/AhsMcuw1HiwbzI+Y53c+2QIMGd+u5Zfc+mSWY9chJwB
DCahxNQc58D+byBBjeLqKGO4v+/3LNP/Nd/EaTGd0zUHqlAS7oR6akGoHXOJy7or
5ZdHWcz7zRa3UazK6OiMaZYx8SifMmktj3HWTWgAapS+8ChVCEGkfSGgb4gvY80w
zz2JPXJH2eXtVtUQGw4kzcc8pSO6kV/PPQPKeNLuA5py1yTRZrGGF4O8r7xNmr6r
Qlx6pESKFYL7k0n9AKbLsqetNG4l7w==
=b0mD
-----END PGP SIGNATURE-----

--p8glKsiXtjodSLAk--

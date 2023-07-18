Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D98168BC
	for <kvmarm@lists.linux.dev>; Tue, 18 Jul 2023 19:10:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE09C433C8;
	Tue, 18 Jul 2023 19:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1689707445;
	bh=YYl/EUj6DCRSCQey6kEPZ2T5dVhRW3N46kZgt3rw2LU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CPOMIHmHcysn6e7Ezp7G9Lvt5eZGNIxiZV8UrLxoyk03fhbOjyFIFDPEDxQVjGxYr
	 0IJDGgSBCcj1y3UJKnXlohYlZo2TZR55ziCWM+86tX1h476ymSNvomBxYATFGDiKD3
	 kM4DP+Uy+Rbt/rr9VbChoK4eYmVmmf/OH1LeGVL0gPDFxxcExeeUqUIKfTbdHwmWwj
	 66xboAw32/YLlqeRbYTLZJqR8hZxQYweZH3uYGuQVY/W6gV1++qmVkfgSNyFT5rPDJ
	 e0ivgfAmet3+KXZ29mn3Tuj5p6aWr2wpx7JISQCOXZJ4RmRChoWXmtAXKlBm/sdulP
	 kTlli0NniP8Eg==
Date: Tue, 18 Jul 2023 20:10:35 +0100
From: Mark Brown <broonie@kernel.org>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "corbet@lwn.net" <corbet@lwn.net>, "ardb@kernel.org" <ardb@kernel.org>,
	"maz@kernel.org" <maz@kernel.org>,
	"shuah@kernel.org" <shuah@kernel.org>,
	"Szabolcs.Nagy@arm.com" <Szabolcs.Nagy@arm.com>,
	"keescook@chromium.org" <keescook@chromium.org>,
	"james.morse@arm.com" <james.morse@arm.com>,
	"debug@rivosinc.com" <debug@rivosinc.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"oleg@redhat.com" <oleg@redhat.com>,
	"arnd@arndb.de" <arnd@arndb.de>,
	"ebiederm@xmission.com" <ebiederm@xmission.com>,
	"will@kernel.org" <will@kernel.org>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	"hjl.tools@gmail.com" <hjl.tools@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"paul.walmsley@sifive.com" <paul.walmsley@sifive.com>,
	"aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
	"palmer@dabbelt.com" <palmer@dabbelt.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 02/35] prctl: Add flag for shadow stack writeability and
 push/pop
Message-ID: <19911588-f74d-4a7a-858c-2994c8614463@sirena.org.uk>
References: <20230716-arm64-gcs-v1-0-bf567f93bba6@kernel.org>
 <20230716-arm64-gcs-v1-2-bf567f93bba6@kernel.org>
 <a236d8bb1593035252f7094b6461e4d2c5b432a1.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="iAfYGwbU4kDAge8S"
Content-Disposition: inline
In-Reply-To: <a236d8bb1593035252f7094b6461e4d2c5b432a1.camel@intel.com>
X-Cookie: Nothing happens.


--iAfYGwbU4kDAge8S
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 18, 2023 at 05:47:32PM +0000, Edgecombe, Rick P wrote:
> On Sun, 2023-07-16 at 22:50 +0100, Mark Brown wrote:

> > On arm64 the kernel can separately control if userspace is able to
> > pop
> > and push values directly onto the shadow stack via GCS push and pop
> > instructions, supporting many scenarios where userspace needs to
> > write
> > to the stack with less security exposure than full write access.=A0 Add
> > a
> > flag to allow this to be selected when changing the shadow stack
> > status.

> Is this correct? I thought Szabolcs was saying pop was always
> supported, but push was optional.

It's not, I wrote this right after looking at hypervisor controls which
do control push and pop.

--iAfYGwbU4kDAge8S
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmS246sACgkQJNaLcl1U
h9CH3Af9Gc0ROtEwiO2hraLxRf8RP7E57Zl493uWzd9vEx2utPcr5meeChS7qWAk
zNoD8IB/4WfafwXv6xjwP5d1PnERWQMij8YDHh3/HPUskRQQJoqb2i0rdSrne/n7
PEhrLVeF69IYVhVhpnSrOQqdGD0P8iSmaC9Z23grrFoUC/l0uRGqX5DaafWRwhMt
2dDXduZC/3AmH6m+s05fouTSJCmAgTgBWrSyKpIvL6/Gle5/GHZMwOBoNEIFwnxD
DhOyjAeycXa5+EfcJY4tSlXiZmvs9SEz1NdYRQnBDxs7s1WBf0XMjO+IRJIj2HlC
vE24/LaeVmr9BnVOuylmqCUJInN5Jw==
=UfKG
-----END PGP SIGNATURE-----

--iAfYGwbU4kDAge8S--

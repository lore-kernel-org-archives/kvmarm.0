From: Mark Brown <broonie@kernel.org>
Subject: Re: next-20160222 build: 5 failures 9 warnings (next-20160222)
Date: Mon, 22 Feb 2016 19:08:32 +0900
Message-ID: <20160222100832.GX18327@sirena.org.uk>
References: <E1aXlz4-000486-Pb@optimist>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="QgTrJPeCZfhZbFCN"
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <E1aXlz4-000486-Pb@optimist>
Sender: linux-next-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kernel-build-reports@lists.linaro.org, linaro-kernel@lists.linaro.org, linux-next@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu


--QgTrJPeCZfhZbFCN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 22, 2016 at 08:36:46AM +0000, Build bot for Mark Brown wrote:

Today's -next fails to build on arm64 due to:

> 	arm64-allnoconfig
> ../arch/arm64/include/asm/kvm_host.h:338:2: error: implicit declaration o=
f function 'kvm_call_hyp' [-Werror=3Dimplicit-function-declaration]
>=20
> 	arm64-allmodconfig
> ../arch/arm64/include/asm/kvm_host.h:338:2: error: implicit declaration o=
f function 'kvm_call_hyp' [-Werror=3Dimplicit-function-declaration]

> 	arm64-defconfig
> ../arch/arm64/include/asm/kvm_host.h:338:2: error: implicit declaration o=
f function 'kvm_call_hyp' [-Werror=3Dimplicit-function-declaration]

triggered by the merge of the kvm-arm tree with -next today, it looks
like changes in that tree and arm64 aren't playing nicely with each
other (bisect came down to the merge and visual inspection of the
changes didn't immediately show anything else though the issue is
obvious in the code).

--QgTrJPeCZfhZbFCN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJWyt4eAAoJECTWi3JdVIfQXtsH/2EhI2j6fqe7HIFokVg9CAK/
mDN7wt30fsQU8yGyWwzoEH4KJ0Ok59Nuob5Hmd8jsuGcrP8kAVI1fguJnpaTIVOm
bgZ3GDFSsOti5YGkEIrYABOXK218FoDErIs6MMJgbr7Wq4RWLAtjLuBwLV1dgwvG
e218bXNfW2vdVGodYbY+WUmlgDigNJAKh8HtwsyVphTURkCko4PHAOrMZJvFYrlU
cYrEJom4H0+HmFhocZ+yvKUAcf23Lbs1+jk2uWSWHKfRyxb6Rhye0jGkRbGHN76o
PKMeXfy9TkNg7kcITJDTL64tAURjdL1LSskjiDPBbMDwdmTWWZVIySstfWmwbu0=
=wY1O
-----END PGP SIGNATURE-----

--QgTrJPeCZfhZbFCN--

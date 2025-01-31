Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78072653
	for <kvmarm@lists.linux.dev>; Fri, 31 Jan 2025 00:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738282948; cv=none; b=jlYSpWCdrFEegB1u4ZOLIQESH67nZcUrZyciQ2K7soJXc7g39k7rdoEj2NK5pCgCqnWhxgz3+JbZpcn4nLGrglN57iSXKvHdj0Es6NNnz/eIwo3rdt/3K4lf2paCdGmdqtbYucUkjl46iwUdDd8juLNRBJn89FprHuBySXGGUkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738282948; c=relaxed/simple;
	bh=B9z+xxJeLVoOHtTr6ujHKfAxUclGlQMau/PbE1mKltg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tW9Ja2iwXvakYhyM9RocoVXVzcxYYnvB0QgSGFzwYGpWH8DK33EpmciD9L7LF1zGIq4B5joncewC8UBXNAh/itKjZ/vZ1XVLOTFRuxa8RP/BRFHrnYjUM+IXHDDl98SKGIeR+v6kVm5be3uk5FHRhawHdMDrFizbocYdYZd05ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sBqtLRyX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sBqtLRyX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE66EC4CED2;
	Fri, 31 Jan 2025 00:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738282947;
	bh=B9z+xxJeLVoOHtTr6ujHKfAxUclGlQMau/PbE1mKltg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sBqtLRyXU5BkA0uXKmZUZMr2PCHvCgi+8PeJjtJ8pe8AVBR1b3HOLixJ2fX28g9N1
	 qgh6BdQ2jnsHJwCzT7McxS2gu8TWeJVn4W54XJi7eWHDELfFcD420VX+XwOiF3h4gx
	 tAk01yU4yAUp0o0izuaLNZT3PSzlOXFzkyDFCsN9M5xakZvBwgfAJHcbTBCJ1ce0vL
	 RBIclGDcG5wax/ZTBie9YDY4Q3QCBoaPb79Kdgy6D9kCOWEPuvoQTd3BUdwTAiwMwm
	 /xvxj8Rw/bG4G6PnJTAIQ0Ie2zlDRQvlY0EHCt8lF0mHzJ5lgJomk4GvJktmzvY42b
	 p2/ITuAyQpU0A==
Date: Fri, 31 Jan 2025 00:22:22 +0000
From: Mark Brown <broonie@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	James Clark <james.clark@linaro.org>,
	Aishwarya TCV <Aishwarya.TCV@arm.com>
Subject: Re: [PATCH v4 11/19] KVM: arm64: Use debug_owner to track if debug
 regs need save/restore
Message-ID: <5f62740f-a065-42d9-9f56-8fb648b9c63f@sirena.org.uk>
References: <20241219224116.3941496-1-oliver.upton@linux.dev>
 <20241219224116.3941496-12-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Y2aSjnWh/Ru001QM"
Content-Disposition: inline
In-Reply-To: <20241219224116.3941496-12-oliver.upton@linux.dev>
X-Cookie: Debug is human, de-fix divine.


--Y2aSjnWh/Ru001QM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 19, 2024 at 02:41:08PM -0800, Oliver Upton wrote:

> Use the debug owner to determine if the debug regs are in use instead of
> keeping around the DEBUG_DIRTY flag. Debug registers are now
> saved/restored after the first trap, regardless of whether it was a read
> or a write. This also shifts the point at which KVM becomes lazy to
> vcpu_put() rather than the next exception taken from the guest.
>=20
> Tested-by: James Clark <james.clark@linaro.org>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

We've started seeing issues on TX2 with the KVM debug-exceptions
kselftest in pKVM boots:

# selftests: kvm: debug-exceptions
# Random seed: 0x6b8b4567
# =3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
#   arm64/debug-exceptions.c:368: ss_idx < 4
#   pid=3D2828 tid=3D2828 errno=3D4 - Interrupted system call
# sh: 1: addr2line: not found
#   Expected index < 4, got '4'
not ok 3 selftests: kvm: debug-exceptions # exit=3D254

The same test runs fine booting the same build on the same hardware in
VHE mode.  Bisection points to this commit, I've not done any analysis
beyond that beyond a brief check that things look plausibly relevant:

git bisect start
# status: waiting for both good and bad commits
# bad: [a13f6e0f405ed0d3bcfd37c692c7d7fa3c052154] Add linux-next specific f=
iles for 20250130
git bisect bad a13f6e0f405ed0d3bcfd37c692c7d7fa3c052154
# status: waiting for good commit(s), bad commit known
# bad: [d052e062c5a1186da8897bdab185688b9b13759a] Merge branch 'for-linux-n=
ext-fixes' of https://gitlab.freedesktop.org/drm/misc/kernel.git
git bisect bad d052e062c5a1186da8897bdab185688b9b13759a
# status: waiting for good commit(s), bad commit known
# bad: [72deda0abee6e705ae71a93f69f55e33be5bca5c] Merge tag 'soundwire-6.14=
-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/vkoul/soundwire
git bisect bad 72deda0abee6e705ae71a93f69f55e33be5bca5c
# status: waiting for good commit(s), bad commit known
# good: [adc218676eef25575469234709c2d87185ca223a] Linux 6.12
git bisect good adc218676eef25575469234709c2d87185ca223a
# good: [04b43ea325d21c4c98e831383a1b7d540721898a] Merge tag 'ubifs-for-lin=
us-6.13-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/rw/ubifs
git bisect good 04b43ea325d21c4c98e831383a1b7d540721898a
# good: [0ad9617c78acbc71373fb341a6f75d4012b01d69] Merge tag 'net-next-6.14=
' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next
git bisect good 0ad9617c78acbc71373fb341a6f75d4012b01d69
# good: [f10203927097ff9e5a251f170038fefa38e274b7] Merge tag 'soc-dt-6.14' =
of git://git.kernel.org/pub/scm/linux/kernel/git/soc/soc
git bisect good f10203927097ff9e5a251f170038fefa38e274b7
# good: [9c5968db9e625019a0ee5226c7eebef5519d366a] Merge tag 'mm-stable-202=
5-01-26-14-59' of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
git bisect good 9c5968db9e625019a0ee5226c7eebef5519d366a
# good: [13845bdc869f136f92ad3d40ea09b867bb4ce467] Merge tag 'char-misc-6.1=
4-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc
git bisect good 13845bdc869f136f92ad3d40ea09b867bb4ce467
# bad: [58f504efcda54a9079a38203acc088c3354aaa60] Merge tag 'tty-6.14-rc1' =
of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty
git bisect bad 58f504efcda54a9079a38203acc088c3354aaa60
# good: [a37eea94f775132866ecdd466fd88027d7125515] Merge tag 'sparc-for-6.1=
4-tag1' of git://git.kernel.org/pub/scm/linux/kernel/git/alarsson/linux-spa=
rc
git bisect good a37eea94f775132866ecdd466fd88027d7125515
# bad: [5e68d2eeac70978a06406c5b156815ceb00437f9] Merge branch kvm-arm64/pk=
vm-memshare-declutter into kvmarm-master/next
git bisect bad 5e68d2eeac70978a06406c5b156815ceb00437f9
# bad: [d0670128d42fa170bf8ba878cd23504c5c5cccc7] Merge branch kvm-arm64/pk=
vm-np-guest into kvmarm-master/next
git bisect bad d0670128d42fa170bf8ba878cd23504c5c5cccc7
# bad: [c4a6ed85455979ef3fbadc2f1bdf18734b0ecea6] KVM: arm64: Promote guest=
 ownership for DBGxVR/DBGxCR reads
git bisect bad c4a6ed85455979ef3fbadc2f1bdf18734b0ecea6
# good: [3b7780945cc8494793040ab0a9805b77b7826abb] KVM: arm64: Remove debug=
 tracepoints
git bisect good 3b7780945cc8494793040ab0a9805b77b7826abb
# bad: [4ad3a0b87f2ec4714fdfa6bd5de57b4c30e15753] KVM: arm64: Don't hijack =
guest context MDSCR_EL1
git bisect bad 4ad3a0b87f2ec4714fdfa6bd5de57b4c30e15753
# bad: [beb470d96cec8dd8f4e05b2135c74d828f7b114b] KVM: arm64: Use debug_own=
er to track if debug regs need save/restore
git bisect bad beb470d96cec8dd8f4e05b2135c74d828f7b114b
# good: [803602b0d94168bd25f5ff6eafdfd9388a6dd2ec] KVM: arm64: Remove vesti=
ges of debug_ptr
git bisect good 803602b0d94168bd25f5ff6eafdfd9388a6dd2ec
# first bad commit: [beb470d96cec8dd8f4e05b2135c74d828f7b114b] KVM: arm64: =
Use debug_owner to track if debug regs need save/restore

--Y2aSjnWh/Ru001QM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmecF74ACgkQJNaLcl1U
h9AqZwf+JtdWAsi/pHrTNN6KZ/5j6YAEqLfCpU83sJRRXGjOBl7bjueDw5XdxurP
+Zz5o5TSlkKZP9DnxzrK7SPQe2HpFH0paTyjrwEJksKrOhRnHfBa3n3iEqwg2hbh
hn0CJGzfRp0YB/+QRv0yxTF3jYl8sUSmDQVTVxTtBOvSgHhlN/H9FRg9qgg9Tv8j
ylZRfi3ik+HV9KB0jaSxBREmIBLdduQqhEYlFHaM/j54lcnp9R5qG9Hxs8x3w5AF
xuC2xn+p8npOByoNyFLuUCio6eTdCXEMKOpQJeJHv6SLSGAHM8FiugnIVuSQcS2G
l3oHU5yQu+B5Hlqn7c95uZFrOFBgPg==
=DQZ7
-----END PGP SIGNATURE-----

--Y2aSjnWh/Ru001QM--

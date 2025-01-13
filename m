Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2921F1FBBDE;
	Mon, 13 Jan 2025 15:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736780849; cv=none; b=f4tJSeVrOkixXyTsMSCNraDfzqGbVTpmSOzEdi+67WO8XTmu2J9k36oOmnXIXZ7dda4Sk22JYk+/WloaqP5j/D21hT98bPdEc9fGlwdfHVV7E/m2I10Z+CaRetG5D1LM3q+lifxSZcH158anSUlIxvkOHHNkZeWN1/Zmq1O07WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736780849; c=relaxed/simple;
	bh=oi6ab4XbpzTbc1+7t7QB9hXM8i6N02vrJ4FXa3pV+hk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=utOaPk/bv2n/hP9PgPljCtR0pGpQHAULPWApjxOqrSbie2h84hCVOyPHzZae46N1zPtgf+8sU/oiYmg63xuw5dULr+1n00Iwobx+/lffrn2QNiYNIfv1ckxevzaDSEtbA04bnfwHsnxYWL4/DXde/RM8ZT6xmiuZ9sN0UzoKNWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EzyQJyi9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EzyQJyi9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7123C4CED6;
	Mon, 13 Jan 2025 15:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736780848;
	bh=oi6ab4XbpzTbc1+7t7QB9hXM8i6N02vrJ4FXa3pV+hk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EzyQJyi9R/9hVcyvFqkltzhelPri5SRJlX5xK/GsdadHsGHy6z6r+wcQUsDeH/BHL
	 4pcIYDHSJqxLxsTeaj8GXbDxU2m1zcxj71cqt0xQ13xFueay0+PH7rWdBi2bgLEccE
	 XJkXsiVza9TkZs0C6ibyIYWdHZ6H5l2ayPHEoE5+/1VlbbqVINM2rwCnvPTX/r8fOE
	 oEwtZHKWjcDmYxEJj5yN+YmNrmND1Nip98WxsBQeoREkKkT8x1yQGU+iNIDbUrGlc1
	 WMFX0z9ZFKPpyv3G3PWr+cdrqoXmVGyoyh3NMhzV02OMzbwRhFSCSIwD1U6WVERwaB
	 mWZAbuvY3KbGA==
Date: Mon, 13 Jan 2025 15:07:21 +0000
From: Mark Brown <broonie@kernel.org>
To: James Clark <james.clark@linaro.org>
Cc: maz@kernel.org, kvmarm@lists.linux.dev, oliver.upton@linux.dev,
	suzuki.poulose@arm.com, coresight@lists.linaro.org,
	James Clark <james.clark@arm.com>, Joey Gouly <joey.gouly@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mike Leach <mike.leach@linaro.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	James Morse <james.morse@arm.com>, Shiqi Liu <shiqiliu@hust.edu.cn>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Aishwarya TCV <Aishwarya.TCV@arm.com>
Subject: Re: [PATCH v9 2/7] tools: arm64: Update sysreg.h header files
Message-ID: <1dad2a07-6aa2-4ddb-a337-ca3bba560f92@sirena.org.uk>
References: <20250106142446.628923-1-james.clark@linaro.org>
 <20250106142446.628923-3-james.clark@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="whoHAOHtY/l4dkaU"
Content-Disposition: inline
In-Reply-To: <20250106142446.628923-3-james.clark@linaro.org>
X-Cookie: Marriage is the sole cause of divorce.


--whoHAOHtY/l4dkaU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 06, 2025 at 02:24:37PM +0000, James Clark wrote:
> From: James Clark <james.clark@arm.com>
>=20
> Created with the following:
>=20
>   cp include/linux/kasan-tags.h tools/include/linux/
>   cp arch/arm64/include/asm/sysreg.h tools/arch/arm64/include/asm/
>=20
> Update the tools copy of sysreg.h so that the next commit to add a new
> register doesn't have unrelated changes in it. Because the new version
> of sysreg.h includes kasan-tags.h, that file also now needs to be copied
> into tools.

This breaks the build of the KVM selftests:

aarch64/aarch32_id_regs.c:150:16: error: use of undeclared identifier 'ID_A=
A64PFR0_EL1_ELx_64BIT_ONLY'
  150 |         return el0 =3D=3D ID_AA64PFR0_EL1_ELx_64BIT_ONLY;
      |                       ^
1 warning and 1 error generated.

since it's pulled over the changes in 056600ff7330 ("arm64/cpufeature:
Replace custom macros with fields from ID_AA64PFR0_EL1") but not updated
the test to reflect this.

--whoHAOHtY/l4dkaU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmeFLCkACgkQJNaLcl1U
h9B6Qwf/QPeV8LvvKgGAErZB3th7rCS0P+WFRYom7XPEzXTvxrJkMpfproE/YfIe
yb8cRX+Wm65xgxozRV7WfJBq19dyU+TirkCiY4DFTF7uuOHr61tbkDzRP+/Y4VnT
HM/92xixwLioSy4xt6byM8GbaPzDi5uNS841VPbG8hzayntBbt17TgsPq7KAzNCh
F2v4Mxr7OoQlL7xLa6C47AOSvb3tekvB3Yy22IKm2IK+TBSotrwDrxnmH8iNtwUv
PsUYYM0iQr6RixcpqymDN+fZ+VGXZ+jR8/vCBPv9KWqSkLUnj9Dtu/Hw45oaqsAT
HDflGT7KLQF8JB/nIGGEeRsIUSkK9g==
=01JN
-----END PGP SIGNATURE-----

--whoHAOHtY/l4dkaU--

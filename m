Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473B13F9278;
	Thu,  9 Jul 2026 11:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783596983; cv=none; b=AOOVUw4Q/loNIbakzNHCJTosIXki9/k57f9Zxprs0nmFS3cAweUhqreP2nT7a0pAS87r2RWbsK4/LSmrIHa/xBZxDcta2qGSGq+CpBeZRsWd9t1BKzsQUFu9ex9xH2z1xsb3jZpeau3TPjhr0r4g+bth2vRkT4aRKKro0HM2Wb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783596983; c=relaxed/simple;
	bh=s6yCP+j+CSpKEx2S1kHiRs2sZEdka39+3G9nvjTPyP0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S7qZJy3/1MtUXVS5fc7o6fjnrAW5TmhNTU2UcwGpW0HaJwcGEF0FaZuuyB3gGKVs4HPWGi8Ncxxra+G110Y8tTuPkvtB4ack91A9WBX9TS+nkX+CU+By2xd+dW29SbRvDcviH/upN+kwWh/J0xnNCjguAe7Jfne5Iy4JW8wdgfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kh7SD9AJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kh7SD9AJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F96B1F00A3A;
	Thu,  9 Jul 2026 11:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783596982;
	bh=U8kqjUvW4uoDK1/F36IchB4nsoc7z+3Xsi7IlngIQAA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Kh7SD9AJfxKGWnaL668g2yVHds3VxPUHmbadri6DA6nvT1HEAKg3INmtGoDrS3uZG
	 0+bS2Duy3EG8Fe/hLKAWHFS1MoAOdlmEnNjjX4P267iK9gEtdZDl7jliet+1iZK4Iz
	 ntjxv4gMRv7XaiYO/4GKvZKxuCRwQOdtIKIEL5CFkkZleHj+2sTIMuA9TDtb6S1uqp
	 EJdgqX3gunp1DqYJsxbFGnwcJ+OipXK768VPDMEDE32KlhRHHJ+3nEZ9HNY7qtduK9
	 lDynLuc8QvqEssqmCIgiysqzJS+rDZ03fHa17v9A+SlPriDZ6sFXGozW1vT5ark5NL
	 5asjUeDov4ajw==
Date: Thu, 9 Jul 2026 12:36:14 +0100
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>,
	Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ben Horgan <ben.horgan@arm.com>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Eric Auger <eric.auger@redhat.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, tools@kernel.org
Subject: Re: [PATCH v11 00/29] KVM: arm64: Implement support for SME
Message-ID: <4b2fb0ef-4d3e-4a1f-8d33-177bb4af2005@sirena.org.uk>
References: <20260709-kvm-arm64-sme-v11-0-32799f66db9d@kernel.org>
 <CA+EHjTyAxBx4jhGq-Gme5hPi1ZyDAkL2CP_U22ykkQemD1dUhg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="xXD2CewWwbORdhWs"
Content-Disposition: inline
In-Reply-To: <CA+EHjTyAxBx4jhGq-Gme5hPi1ZyDAkL2CP_U22ykkQemD1dUhg@mail.gmail.com>
X-Cookie: MS-DOS must die!


--xXD2CewWwbORdhWs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 09, 2026 at 11:26:41AM +0100, Fuad Tabba wrote:
> > base-commit: 4c45e14df2f4e77982ad70d6d8e3fe750edd4c37

> I think this SHA is local to your tree. I can't locate it, and neither
> could Sashiko [1, 2]. For a series this big and complex, it would be
> good to get Sashiko to review it. Could you please fix that?

That is the v7.2-rc2 tag, copying in Konstantin since this probably
wants fixing in b4 and Roman for sashiko since this might bite others.
I told b4 the code was based on v7.2-rc2 (which it is) by specifiying it
as "v7.2-rc2" in --edit-deps and it's translated that into the git
object hash for the tag and dropped that in there rather than the hash
of the commit that was signed.

Probably if b4 is going to resolve deps into hashes it should make sure
to resolve them into a commit object in case users aren't pulling tags
(which I'm guessing is what's affected both Sashiko and you here).
Either that or just keep the text (which would make it more obvious
what's happened but doesn't actually fix anything if it's automation
that's impacted).

Unless someone objects I'll resend with the dependency specified as the
commit object for Sashiko's benefit :/

FWIW:

$ git show 4c45e14df2f4e77982ad70d6d8e3fe750edd4c37=20
tag v7.2-rc2
Tagger: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun Jul 5 14:44:06 2026 -1000

Linux 7.2-rc2
-----BEGIN PGP SIGNATURE-----

iQFSBAABCgA8FiEEq68RxlopcLEwq+PEeb4+QwBBGIYFAmpK+lYeHHRvcnZhbGRz
QGxpbnV4LWZvdW5kYXRpb24ub3JnAAoJEHm+PkMAQRiGsv8H/Rn7Hr3Hp8t6au8B
xQueZThJWjqQ4v8pyLnXF6OomKiDR24OTXMCrFgDkcmZ7RK2ALqowI3tQVwLUTuI
yUN0qL2z2y+LyTcO0CYf3Lple8KlgLAXYMsv7pGLsOvhS7BW2jW97/bcbpUNxoHb
eghxqbIEnyRImUbbyg+nW7VVk65RKdPUNkBPXfQ2NMVwe+SDE5Rl+NXNVqDNjGad
soDTUBrD9yXkWX+4s0myleE62UzzH5nYgGPQeQgYmzWgq7LybH6WBlbQK9D7ODJR
Cw3LCq1hwZZ2w04Yx+XwMHquGJYHW8L2pj77h95uhzksz8buKnM0AGwBCTC6RMoi
AyUQvdc=3D
=3DJUWl
-----END PGP SIGNATURE-----

commit 8cdeaa50eae8dad34885515f62559ee83e7e8dda=20
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun Jul 5 14:44:06 2026 -1000

    Linux 7.2-rc2

diff --git a/Makefile b/Makefile
index b9c5792c79e0..b4035d3cef26 100644
--- a/Makefile
+++ b/Makefile
@@ -2,7 +2,7 @@
 VERSION =3D 7
 PATCHLEVEL =3D 2
 SUBLEVEL =3D 0
-EXTRAVERSION =3D -rc1
+EXTRAVERSION =3D -rc2
 NAME =3D Baby Opossum Posse
=20
 # *DOCUMENTATION*

--xXD2CewWwbORdhWs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmpPh64ACgkQJNaLcl1U
h9C1Wwf/UT/h3LJlUaPMvXwgEDzODT9p1bkNG4mvuCnR+0OqxswhBk5Izdznt3QR
/OfTcvf6+B3c3DAy1KtIPN7oyva2qvRyTL37aLRGt1jNybf4SW716qkCMTAvQGez
XrEICAKRVpw8/wj39nxPmbHwnx/OTFeGQUnakOoHiG4Ujh3Lb5cR9NXdBXxRi489
yq/wuVvxR4GnsX6fpJDIEEB109AYhiyX121wC/tlmozkjZqQOh4KJFL9WRYfjVPn
egfvJBOXvr8JRypwpdxTN7EXBDadmzEqSz5kVerbpGFDdN3Oxj7Q9HkX/ZaJqN+5
68n9512IoFxOucBJvACLfazMW2rkWw==
=EeUH
-----END PGP SIGNATURE-----

--xXD2CewWwbORdhWs--

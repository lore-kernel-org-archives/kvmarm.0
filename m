Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677643B14D3;
	Thu,  9 Jul 2026 12:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783599711; cv=none; b=kuzfY4AdzPm88SGGG0JiTQEEfWlnbeVe5KGazKBvA6tRMSR4dtDLXDfSZW0m08c+WHQiCCewGK5FfFAc5CbU34Br0HTMqrPBYGy8mwgqPFZGc01JOtL6AuohuuKmkMbyQsnoGu8xsCiJzVnvifiJDscmYIEXxmrdAMmkZh7CNPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783599711; c=relaxed/simple;
	bh=je+/HG0EMtJs/loHSe9xZu5retxVO446cgavJsDZxa4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Uv9D2UcvA+rw4BpX22rNKRQsT3Qy3zLpQk8nCWFcUWbAJOlYz5WPio0XVd5lVMjswJyTVilwkoV8MuFBH0+KtkJKQU8koQk944ihRS7ZtXsChAS9sySinm4wTQ48Lt3n8h/Aegecgwv5fOQjNDp8fbrlLCbEybUldt2QMRDVHrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ejE2Et99; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ejE2Et99"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 197831F000E9;
	Thu,  9 Jul 2026 12:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783599710;
	bh=LuOciaS8DK8jmb2CFQM4/jZaaLCATTx50eQ2Thwjxio=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ejE2Et99WozJ1ypz+xTfglTg5W4D821r3YBkSWZ69VfT/DXUVQDgsyOw2BKsE5Rus
	 n5UQr2tQffCuQ+eTIMbnAhij7IZKyiJDuQ3EjdGG1tJVzTdwUqLrELSFHkS8pQqxsA
	 hlEspvq+80/eU+Gj45dsw0kymVVmclO6yyDyVAdylITZ6ebavOl8agRveBg1in94XG
	 Us/hNWSBeZUmgejcm52jNyPqjdI2sacuRoPucQqiAAeFH820A8aiLPNxMeIvRI0m57
	 TumZ6eFD9Ldh/KW5/ZRTF6fxvikmcBe9pvzdWBw7P4MW1GRSGQcmLSCYYjKPEHwWym
	 qupaWM2bLQdzQ==
Date: Thu, 9 Jul 2026 13:21:43 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Fuad Tabba <tabba@google.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ben Horgan <ben.horgan@arm.com>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v11 00/29] KVM: arm64: Implement support for SME
Message-ID: <ac8c0aa6-d84d-4fd4-9059-ea79adc337a1@sirena.org.uk>
References: <20260709-kvm-arm64-sme-v11-0-32799f66db9d@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="lvkuTVR/BvRRX0hU"
Content-Disposition: inline
In-Reply-To: <20260709-kvm-arm64-sme-v11-0-32799f66db9d@kernel.org>
X-Cookie: MS-DOS must die!


--lvkuTVR/BvRRX0hU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 09, 2026 at 01:51:37AM +0100, Mark Brown wrote:
> [ Note: I've spoken with both Mark Rutland and James Morse both of whom
>   might potentially have some overlapping changes, they've both agreed
>   that they'll deal with any rebasing if it's a question of this getting
>   in or something else. ]

Main testing for this was, in addition to a lot of not particularly
relevant coverage, running the KVM and arm64 selftests and KVM unit
tests.  I also ran the arm64 selftests (particularly fp-stress) in
guests while running fp-stress in continuous mode on the host.  Testing
was done for each of nVHE, VHE, protected mode and nested mode.

--lvkuTVR/BvRRX0hU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmpPklYACgkQJNaLcl1U
h9B0qAf+LBdXTQ7AYWPPO2VCenkHI7Mk3Ar2J3NEDvdagbuxAigD9tRaRejVQbv6
X+hE5pP2Ij0vPRnhodiUla8xiKplqUKX9qF8UKOi3K1USJMLnOC4FKyukI4seelo
/OMB3xjuTCcOhkffh0zUSv+6ssNVUQa9F0eGoXaDCBB0Z+Y5ut+96O3TB6o9CY2P
PYeZeycw0bLZvYzuOYXwRej52aiR/J4asZV5i8OOWTTEMEJIXB2PaVWTBnhMiEDR
VEGyfz/uIdg1RJv5lcChLnlP38Ai0leGL9Gh+bSo672GA8KEUdycqNrTpQuCV2j8
MSqXDTT5NYsRGwpA29E9JKTBqQ+46w==
=Cpl8
-----END PGP SIGNATURE-----

--lvkuTVR/BvRRX0hU--

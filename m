Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E0A3F482A;
	Mon, 13 Jul 2026 12:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783944457; cv=none; b=LHOgFLcuqBnDsVPV/A9z8Qb7P1PNRja87b2I3iiO81LLqb48qgEr825lX8Jx7RtpqsvvF5vggZspm7tyuxwH45050DcRXakR8gwzjINESMBYgXFJFr/bd2eNJodSRvoxcYxQA/vD1Hjuvz9OS+ABTNJoLC9cNzxo/ewmTVbPSLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783944457; c=relaxed/simple;
	bh=7jDZSD0ZXBMKU0DnAOHmPPwvUaOFC7qe+/DOFXEBCrM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WbKdtb6zWVOpvitJARAQ5mb0/nDJquvkPXCJYDitJ2CeG4wu01Uih8D0B3++/dGwItnJTzK+c6uui7UVqVQ9ljyzw3hD4nerSGJHVwnLg23BVmH8x4LvY4+pyUwIIOnn2HOZPb4qTxhG0QV42eoGrNGtPJgvKFb19C3UU5rNnTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BpA+61ub; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BpA+61ub"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF2191F00A3A;
	Mon, 13 Jul 2026 12:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783944455;
	bh=7jDZSD0ZXBMKU0DnAOHmPPwvUaOFC7qe+/DOFXEBCrM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BpA+61ubk0J051AHcwHvcJDrGcIq7CrWdik61tyJi8gKjWK/Bh6rOoauz4nnoATP9
	 z9B7lFZLzJDrHlyAzSokl43P2diwlF4AwhbABdmReNTjUMnKd3YKN2oGjFTDCS0boM
	 z0MNQ52CSqHNk3Tr2wOwfuQ+QcTTesZW3Ksc0KM/lPg00H8Olnz7IF/j3Xud1wfUAc
	 vgKXYEMmk2C1/RznpAzIjCIb8xHtq1ACvc2WEEJKd+k2G/XgS3DENa2uT6HvvpArcA
	 ZMPqyJRjF7xI/aIAcegBvA9wwIEhREtkzqapyHKncikPXnkwI86yBPj2yiyibNP1ok
	 SffBMTrce85bQ==
Date: Mon, 13 Jul 2026 13:07:29 +0100
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
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
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v12 00/29] KVM: arm64: Implement support for SME
Message-ID: <2b521e6d-be72-4d6f-b9f2-87b4d1175803@sirena.org.uk>
References: <20260709-kvm-arm64-sme-v12-0-d0301d79ef58@kernel.org>
 <CA+EHjTw4uz9UjezNdHynMV38P0jORwfcxSSv834nQ8Q1JqW0Jg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="/XZSrZTLgS9atLBV"
Content-Disposition: inline
In-Reply-To: <CA+EHjTw4uz9UjezNdHynMV38P0jORwfcxSSv834nQ8Q1JqW0Jg@mail.gmail.com>
X-Cookie: Courage is grace under pressure.


--/XZSrZTLgS9atLBV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jul 12, 2026 at 03:03:59PM +0100, Fuad Tabba wrote:

> Unrelated: on the get-reg-list restructuring you mention deferring to
> a separate series: since ZA, ZT0 and SME_VLS are the
> migration-critical SME state, it'd be good if that series also covered
> a save/restore round-trip for them, not just get-reg-list enumeration.

Yes, better testing for the register interface in general would be good.

--/XZSrZTLgS9atLBV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmpU1QAACgkQJNaLcl1U
h9DypAf/W0SOgAJEKLIa3gvYV64Dx0urVRKR0KeM2AmELN/5bT9A/YfIHa92+vNh
LfoAgKaikhNdRjiuGg+BQF7lBPZLLXEvXtZMY8MC1oYyioWaiFvyb/xwvcby6LNP
RoTvjFB1ONxEfKsdrMhJvWbBJKu5AUc+9LRVSqzdQ5A0RfpKIneMV6kyjSVi2Io4
1wyPtODfqjf4qCSnqAODl2i/YGv+yROouYCFA24iCMJ9sVpc0UwBHAQb3AFfIWlm
ETQgCJpqueXMCMJNTXqUqMc1natNGA81jOPIg7CB3a3fxCRb4HxwOf5P8JrUmPWo
1VvaTIAG01p4n0S8IKjjG34RHqBxkQ==
=cZj9
-----END PGP SIGNATURE-----

--/XZSrZTLgS9atLBV--

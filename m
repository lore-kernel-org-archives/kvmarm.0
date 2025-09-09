Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638A731B82C;
	Tue,  9 Sep 2025 11:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757416956; cv=none; b=ttJXtDLz5KyXAX9UcpD+DMn8mgqZMZFLdSZnxtHPhoMF/9j7SKJMRV9MNTeuhu6EP0c33a7d6gin0AFYOWfGAKhH64SsL5sIvtF19MMHgocClKfd8zijzFZ55+ZnM7VMYIX/jnIokffI8dDRgPvHx6E8tTVN7g7dwPWspCj4nGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757416956; c=relaxed/simple;
	bh=1MZh7woJ0rdN+tehZ1cFMkjdvxHB0uNLIFNJTJya+Tc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FVuKHd+BcnQuDg9TBB14cOFwWUSGcxXca1hCrOcUtWa5OG7O6O8ly7yKeRldjKkVBAxr0FXZNDcf72cAtOsJfFw4+3DPv46wpjxaKRm/VJnRa5D4VjQDkXWnSruRutDpNHvEl7qCF+l8uFFZxzPb8Qstp4gprJsSs8oIRbGAH7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FXF4Z007; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FXF4Z007"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F198C4CEF4;
	Tue,  9 Sep 2025 11:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757416955;
	bh=1MZh7woJ0rdN+tehZ1cFMkjdvxHB0uNLIFNJTJya+Tc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FXF4Z007FLjA3PVwAxJmU9bqNx7BTsubwzEimaX0SKeey3p34WQH9oqMrIyPA7exS
	 KlxpQpZqkRoAmwZj0/l0YTnGYBCDW1tuRlQW1Xxy83P04gILlCMTFPxZ8g//PCk1X5
	 uGoZCoIhsX3br6j/HyxAU+5J9ga6VSFGHiB6A/47uYcZVO96HrMu8szveOsbnzvFPD
	 q3FYxMirHIj+IZdOZsa2fq3l59hyMsDVjBFQXX/I7JMemeKgk9uI/XVxu7Cm+jC9tm
	 ZAvzDPu8xyf6y7M7doo4+nwRbFGRDNHhMsxny8R+jlXRvBB0xKqrO8g1wz7FuRo9s8
	 cf3YaKczAVuAg==
Date: Tue, 9 Sep 2025 12:22:31 +0100
From: Mark Brown <broonie@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V4 1/2] arm64/sysreg: Update TCR_EL1 register
Message-ID: <4f0ace4d-3398-4b5e-a85c-a30cd3f122b4@sirena.org.uk>
References: <20250907123000.414181-1-anshuman.khandual@arm.com>
 <20250907123000.414181-2-anshuman.khandual@arm.com>
 <a195095c-8ebd-4d74-959b-7b407d416a1f@sirena.org.uk>
 <bfe55fd9-e00f-44a8-bf4f-0b0a6cfc16bb@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="I0KRvPxGGLsT2cj1"
Content-Disposition: inline
In-Reply-To: <bfe55fd9-e00f-44a8-bf4f-0b0a6cfc16bb@arm.com>
X-Cookie: Ma Bell is a mean mother!


--I0KRvPxGGLsT2cj1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 09, 2025 at 09:20:26AM +0530, Anshuman Khandual wrote:
> On 08/09/25 7:28 PM, Mark Brown wrote:

> > I guess the cleanup of the redundant definition could've been a separate
> > patch but it's not super important.

> Dropping SYS_TCR_EL1 definition from header (asm/sysreg.h)
> into a separate patch ?

> #define SYS_TCR_EL1 	sys_reg(3, 0, 2, 0, 2)

Yes.

--I0KRvPxGGLsT2cj1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmjADfYACgkQJNaLcl1U
h9D6Pwf8DT22bvBoI7SpN2eLMz5LCdZMEh25CjOW2LNAP5BIWVDEDFZGaP3M/ADa
XnUO06bqloVs2fljkorHAHDxZM/ohqoYJgQ+rbQIcqrpRWO/+59qEpqCuYQZYCKF
+Z/7HWTMlblQVeoAzxGR4DP+JAgKkH1KF3p4ryJjRzbTka7mBkUGQtFhsgVCITMy
q0/1PdZGjiVHa1AU4QNtVqpTqIIWlPWYf8ukhk6mTza46Y99eiQS5wqtEGLujW7v
IfvMwmnrBBwuBCBXnzC5FBjPlzFCjfemdqIqgsQ2CFJ5BpItRA8MOqrLfE0w72qe
EUrjJOEAS7L4SeeicUhCG6dFN8LSCw==
=Bqax
-----END PGP SIGNATURE-----

--I0KRvPxGGLsT2cj1--

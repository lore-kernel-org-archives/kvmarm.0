Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2698B3806C2;
	Thu, 23 Apr 2026 18:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776969306; cv=none; b=IIiWjKOMQjY0xzDJ3XTNBt1FenFG0+f6/dGNwgGVmBp+Vua2esxUrnn5FcrkLzXl/G0/mKeSnetQpYiLQKupF7wM42M++ubf7BrOjG/6oog92T/Lyp2oPzAaQ3eWRRwQw8xEJY8RdLP+2evSp5LgAwDT84nQvBc02s0vpEPuQYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776969306; c=relaxed/simple;
	bh=sO4srb2VfWYzH/iq+j6SCQoI0NwsiN5Eg5HwtcphrfQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CIBbHqZQArtl3jbqh2GcCTcYRm15Jbrlg8bve7prlEGGIGI58G/CPMilCmm90qTpm+wgMga547ryS9IX4DkGovhW5fU1ALY+rdB6BWzQe47GVcSx5TBAD88vskMptr5S6GQTNGEbj7yvmw05nt6qxO6nNhfEInoTd2jBfc8vjSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q2EH6I2M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q2EH6I2M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCC00C2BCAF;
	Thu, 23 Apr 2026 18:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776969305;
	bh=sO4srb2VfWYzH/iq+j6SCQoI0NwsiN5Eg5HwtcphrfQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q2EH6I2MU46cVNjfe6mgYcU7k7iQyidgG9KJuR9tJBz7RCfmDe2J5CRM+KDrAFgvK
	 NxDIDqjdOXMsj/3tuPRYOcA5QDh9eWQSJjWoIyRyNPyS0v+U/AWcEWh28tFbNdldBs
	 HSHQLkcsEwAPvVfjflnroQhaQI0W/00kHGCsLUje3ZDcxE/MoVpfBw3/0KU07SoqXe
	 kQWBx6r2EeE/gky/lZSq+zv9H0Ur/vs+zdXJzz/C34AhxoqJgVUKgYh6aIVqAiX1r/
	 hU6yfsDAXeW2OW4TxkPvKsRavpCFcqJfH+VNtDnnWAe+VOoEGufMwDG6W9rH3eYtJ4
	 H4NSzgkiNvi9w==
Date: Thu, 23 Apr 2026 19:34:59 +0100
From: Mark Brown <broonie@kernel.org>
To: Jean-Philippe Brucker <jpb@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>,
	Fuad Tabba <tabba@google.com>, Mark Rutland <mark.rutland@arm.com>,
	Ben Horgan <ben.horgan@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v10 14/30] KVM: arm64: Implement SME vector length
 configuration
Message-ID: <3d9e19c7-2e56-43cb-bcea-53d305c35baf@sirena.org.uk>
References: <20260306-kvm-arm64-sme-v10-0-43f7683a0fb7@kernel.org>
 <20260306-kvm-arm64-sme-v10-14-43f7683a0fb7@kernel.org>
 <20260318175317.GL2390801@myrica>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="fhbhbXVDBdOem/hg"
Content-Disposition: inline
In-Reply-To: <20260318175317.GL2390801@myrica>
X-Cookie: I'm hungry, time to eat lunch.


--fhbhbXVDBdOem/hg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 18, 2026 at 05:53:17PM +0000, Jean-Philippe Brucker wrote:
> On Fri, Mar 06, 2026 at 05:01:06PM +0000, Mark Brown wrote:

> > +/* Current for the hypervisor */

> Not sure what this means, isn't it also current for the guest?

If it has multiple VLs available then the guest may select between them,
including choosing one smaller than what is configured in the hypervisor
- for example a guest running at EL1 can set a lower VL in ZCR_EL1 or
SMCR_EL1 than is configured in the corresponding EL2 register.  This has
been something that has frequently needed clarification.

--fhbhbXVDBdOem/hg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnqZlIACgkQJNaLcl1U
h9ATfwf/QhCSHLUmuQXd95wc/Z+Kj+6TXzijHxGpEyfpplwzdDt8nNHkGlM17bQY
jEgvX0Ei5B5X3iJx03W1fZO7dT94He6vQelfDPipVZbVEpd6IEUmDj2XxHW4lE9D
+duYNIz3P8RgHuE29tagB4PeF5PUPrLEX04QeEkS61Y1dk047LBjyF06ykyh/7xg
NrJNKO9QxJF3GTLkDHjeMBBT98mtHS5UOjX21qo74Hn5V/VXLs7Ud6HhMeJQwO5K
MpDbtR4xv5IQRgz8Pqh9t0XtUM0a//15LizuqPsUDKV79VxWPtSV7mPDFY0F5O5+
Xgv2T1qQUfg9TgDhQh2oD4IG3nNmPg==
=tX7F
-----END PGP SIGNATURE-----

--fhbhbXVDBdOem/hg--

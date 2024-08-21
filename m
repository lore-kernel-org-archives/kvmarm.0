Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D67B9189908;
	Wed, 21 Aug 2024 14:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724248919; cv=none; b=YNMTDehcG/KRuiG3zENggK3bo1sTUqLfHFV9BmGFh3Bc5SJGmws9zmXnKgeNsmMgqUA/MEy4FGNKy+yzQT3SXF//S3lG4Qg0uLgoKJmo+hpTQ0abPhcwwiRdDZ6s2o9ICDv6lTFLVU2AtGSHXZ/LFQ5JaK8m3eHhs7AzspTUwAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724248919; c=relaxed/simple;
	bh=TSQq0EVAtGjH5NhID0gQrYHTEIaD+iAJdkMniNe2Szo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M6YMvDkYf2Z31UwtChfDB/fQ9RIZVIQP6IcWwMCyjtvldbBo07YaBdNe8C+WLvV/kM1m2vrXs37PfQNIgjx7bl4kuQYtXHuTf0oYUlNeK8PqOkFUn4dq9O6Q38bKGCWHsW5ooovdwuoA8tNSECgsxPm1tlC2TuW2Cjq3zWWoniM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z/6OAFbJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z/6OAFbJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FBEDC32781;
	Wed, 21 Aug 2024 14:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724248919;
	bh=TSQq0EVAtGjH5NhID0gQrYHTEIaD+iAJdkMniNe2Szo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z/6OAFbJQCUGh5S1Es73hWNG1Vuyy1VklYeM1qbQ7lxmCTHozDwsKvp6Ik1kSXk4c
	 rLnaXn0rCSYstWdS34M3+25AOfH5JZFtmbsdL+jrw3z0hSwkOR/8avKnYB7DuQ2zaA
	 aLw8otwMMWFuV7ky/z58uEw4bsX/akwg1sDjpllC2BJe9WbQYubb9zOYn/eEYhY2ES
	 79KJf4p6Qt6YCyExk3/xYFI7WhJUU5QOzXoKPY28re3qB19AiSEY4N7w8Uf58N1uXw
	 O8p1dD4XjSSYLW92xMh1FJesHEUb1bpF6P++0EEHLs3ktGfNivUOuoP9mU/YGpPZay
	 Unjz5ZHXl7h1Q==
Date: Wed, 21 Aug 2024 15:01:54 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] KVM: arm64: Control visibility of S1PIE related
 sysregs to userspace
Message-ID: <e123ee24-2a0c-4ab3-8dc3-2906bf96f38d@sirena.org.uk>
References: <20240821-kvm-arm64-hide-pie-regs-v1-0-08cb3c79cb57@kernel.org>
 <86ed6ixa32.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="UP7bA8IgNOlNffa6"
Content-Disposition: inline
In-Reply-To: <86ed6ixa32.wl-maz@kernel.org>
X-Cookie: You are false data.


--UP7bA8IgNOlNffa6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 21, 2024 at 02:46:25PM +0100, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > Mark Brown (2):
> >       KVM: arm64: Hide TCR2_EL1 from userspace when disabled for guests
> >       KVM: arm64: Hide S1PIE registers from userspace when disabled for guests

> If you are going to do this, please add it on top of [1], and handle
> the corresponding EL2 registers.

OK.  To confirm, this is a desirable change?

--UP7bA8IgNOlNffa6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmbF81EACgkQJNaLcl1U
h9AC4Qf/fb8vQuL8IeyRSdcAbuelSljj2PK68B6ehWZHKRzK03R6+ldXXvR8JMvj
bo7UxOOA5hEVJc7j9kSnS3RK0CJFcF65hNdjvAGfk64DKWvr+bZf3cGRNpwcAlDq
mQsXadp78KYuZKdAXz0Hz+YJKnnxYf+0n/HGAJTNNOOnao+pGwutFRMc3KMSvF+F
LMIeqFWZof84FSFfkU/AGJH7nk3cgANrH+y3Tx+Lz/mN7Vl5kPIOU1/SpKei+UM2
VHTq6K5/NHarNLHa5T/cNfT3VWcEuLnCw+dUPI5T2OWqNEPNzu3EVrxoka3jCx6l
ezp+gqn9oFJuNnDtIfbiaP8meEZ75A==
=Rrr8
-----END PGP SIGNATURE-----

--UP7bA8IgNOlNffa6--

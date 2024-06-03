Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752F6130E40
	for <kvmarm@lists.linux.dev>; Mon,  3 Jun 2024 15:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717429434; cv=none; b=Mk1Rb6ZOtiraVs7qiQtmUzSbwFaeQ+VoFnIXWVtQ4lOAlUjPJfT83IzRHIkk2/v9c4ZIYLzpIPQ/7mNmxYDj9gj6H514W6mfuk8C8lrqPE1D5jCkcL3B+u6UQ3/HSyOzNUUE2g+T2aoEjnPmHuSDCZgYPy6or4+fgG+3yU8pnsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717429434; c=relaxed/simple;
	bh=OXG0DxodrsVoUQ85hREj/cOzXgtz4NhwHjGKCSA1GqY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LTCIkXgrxEwUqh39BydyjGLu9mCI0wlZ52qTmVDnSQMxxIxBnbntvbPd6On7yM+Lyk2UKITZoABFNkgjkPe/EbZL+ZmgIaUM0iUXbgAN0e9OMEvwUekt1tSnsqjVxV8CTtOUPz/ZmwpNJNgRB+HMdp0fq9/BgLAv6CXQVlYzzdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dn7eIdLA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dn7eIdLA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D9CEC2BD10;
	Mon,  3 Jun 2024 15:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717429433;
	bh=OXG0DxodrsVoUQ85hREj/cOzXgtz4NhwHjGKCSA1GqY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dn7eIdLAGxBioez56/tyGUZL4zNQbi0QNbDYT/MGfLDeCd0eDwNx8TeZWZESPwme9
	 0tfPtS4G9/FIarrh1+tkxFl1vucMrW52M32GWGQeDWNppaKJlwKbUAhFbbMJNDCFoE
	 3MclKreoRyo9EpU81Ywhvw2VR/MvtF5jgapoCkvT0gT2Ce74c1qI+rwSGahA3Tcmaq
	 yp46nFOmUNIhf7el/XAnZY1X3BA+seDCGNFhZgCulkoSPNb3CfOVZxPv6rH2bljLmT
	 htQv7W5W2Ex1jYH8uNsZcmb6KcAnvRjS5jmiupLvUG2Z989OtaU1x1OEJqYEVmrtoA
	 UEEMO7/a/jdwg==
Date: Mon, 3 Jun 2024 16:43:47 +0100
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, will@kernel.org, qperret@google.com,
	seanjc@google.com, alexandru.elisei@arm.com,
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	mark.rutland@arm.com, joey.gouly@arm.com, rananta@google.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH v4 7/9] KVM: arm64: Consolidate initializing the host
 data's fpsimd_state/sve in pKVM
Message-ID: <60a788a7-aad7-4541-a1af-f9c7461f1880@sirena.org.uk>
References: <20240603122852.3923848-1-tabba@google.com>
 <20240603122852.3923848-8-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="nQUmR4ecQ1CswPA6"
Content-Disposition: inline
In-Reply-To: <20240603122852.3923848-8-tabba@google.com>
X-Cookie: Don't let your status become too quo!


--nQUmR4ecQ1CswPA6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 03, 2024 at 01:28:49PM +0100, Fuad Tabba wrote:
> Now that we have introduced finalize_init_hyp_mode(), lets
> consolidate the initializing of the host_data fpsimd_state and
> sve state.

Reviewed-by: Mark Brown <broonie@kernel.org>

--nQUmR4ecQ1CswPA6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZd5LIACgkQJNaLcl1U
h9CwIgf/YlBUNNGvMuO0ZDJaUjKRsgtRCqFLNsuEXk36gblSH2VdIZHI+ME4tcbc
nlAQ/hV6MJVUQvsAQVyS0oyLd84fG2dnx0+2tg0YC3qHjAegq3yZ2jxAVGItEdDi
qzybEg8gInRz4NZ3BrhFfT8l7JMwd49fhMVdXH6aseMTOaFQkljnWxYHccyku8NI
9TWlf1LYvO5NDyAvJjbjGGcy2WrN29yI2sHK6jBLyzi2AobCAksoZBSvrlpT4vUu
jGgBi64Jsdgx/f50EZOlecKEiAqhBcORKZAMUr1rC5/azmDVEpJc5NEetpYvM80l
tCBPrIwI8XJLhR27agCpevePXdq7Pg==
=wCW1
-----END PGP SIGNATURE-----

--nQUmR4ecQ1CswPA6--

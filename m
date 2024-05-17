Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 025A71FC8
	for <kvmarm@lists.linux.dev>; Fri, 17 May 2024 18:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715969949; cv=none; b=F7Eh5Hs2SyLoQr19gWgYEpqX+g4K7CkpdAxQfPYO5+ije2jE0qwiESA7+feAiHSjigkcYX38iV86LfCuOqpUhzrkDKMTDgN3Wn81uj2sKIHh2vADZ8Z9TfdjHrOvq8GeQY/ShV9rKoMVF5DMpPkAQ032GOwj7r2Tc25qoNXECTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715969949; c=relaxed/simple;
	bh=Va5nImH5Vr1qpObV4jf6LjfCqdoE07qnSS4ckMFN9ss=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SQVIFnAM3vCDBwSbzGF/JFkOgPRNANpge2KF8iQKfpgBeWsPaU1Tj/brlcb8jPlU2w5ky8dvJjMNdN79V+PNzXw3sQAvHBcqYbF9SxnFIMHiRaXE4zkUBBaR23qR7pIn7uzyUIBnApAg9c7H0R2xCD09gYzfPflXDqni3/eQ89Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mVvwzdsd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mVvwzdsd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 177CDC2BD10;
	Fri, 17 May 2024 18:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715969948;
	bh=Va5nImH5Vr1qpObV4jf6LjfCqdoE07qnSS4ckMFN9ss=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mVvwzdsdY+ZBeo07cNdUW7e49qcug1oBSY19ok0cDYc49ZppljhN3G2PMrtwZE/CN
	 d5fZ/LHqVhN0gSTU9ib9yblv/gpIyesTRqnlbA9c69tpiXOcfU9g2HYdMm4ROMos42
	 ydtRpAKgB46UXfv1edB862umtn1BvFat9v089OEW643RLYpfW0RnQfGVxsz9sIBs/y
	 Fx94tDFuy6u3Aek/9G2ab2IydZcqPGiEkff2BzId1GIxR9GGdBI1tFN3L+Gy+PAzpX
	 /Zqkg8sQ6YSmWNStzEye0gOS70yehGYf5eXb4GhQCQ7NMKgpGvAwf8t/jf74gTlNgh
	 WjjfjBcBZVmlg==
Date: Fri, 17 May 2024 19:19:00 +0100
From: Mark Brown <broonie@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Fuad Tabba <tabba@google.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	will@kernel.org, qperret@google.com, seanjc@google.com,
	alexandru.elisei@arm.com, catalin.marinas@arm.com,
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com,
	mark.rutland@arm.com, joey.gouly@arm.com, rananta@google.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH v1 0/7] KVM: arm64: Fix handling of host fpsimd/sve state
 in protected mode
Message-ID: <b73372b3-e032-4afd-a7cd-e08a687b1d3f@sirena.org.uk>
References: <20240517131814.719933-1-tabba@google.com>
 <ZkeUTix0Ojn5eHKP@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Ith3iiQIRw9HfiCb"
Content-Disposition: inline
In-Reply-To: <ZkeUTix0Ojn5eHKP@linux.dev>
X-Cookie: Function reject.


--Ith3iiQIRw9HfiCb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 17, 2024 at 05:30:54PM +0000, Oliver Upton wrote:

> Hmm... Is there any reason why we need to be concerned about preserving
> host SVE state?

> The syscall ABI has it that only the first 128 bits of the vector
> registers are preserved by the kernel, and I see no reason why we
> couldn't apply a similar restriction to KVM_RUN HVCs into EL2. We'd need
> to eagerly flush the vector registers on entry to avoid disclosing guest
> usage of SVE.

> What you have is certainly correct, I just wonder if we're going out of
> our way to save/restore 0's for larger VLs.

Not just larger VLs, there's also the P registers even for 128 bit SVE.

I think it'd be sensible to discard.  A big part of why the host ABI is
like that is that the AAPCS makes the SVE specific state caller
preserved on function calls, with syscalls mirroring that.  This means
that even if the kernel is using FP the HVC would need to be inline in a
function using SVE in order to get any state that needs to be preserved
in there, or there'd need to be some other non-AAPCS thing going on.  We
already ensure that any EL0 state is saved prior to trying to run a VM,
I've not checked the interaction with pKVM here but if there's any
issues I'd hope it's not too difficult to close them.

--Ith3iiQIRw9HfiCb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZHn5MACgkQJNaLcl1U
h9CGKAf+OPS4JOc51HDoIcvaDYyFyyiutlr68LOUfBz/WJEZHzKPDeIELLJu5YgX
zP+K4k5KqnbMYbOWvoBLC9AkjiEXYEKZBtGxg92l3XkSHB0ZSIgA+vMeLOCnkNix
Qssmmgd0MbLtdnBjaIhUr+PVlWTuVzYtdGWkqR/3tKgQboxY5iJdY3+wv30Ndp/2
t5DwoE7QkPrOJ1YvHYu+E+a+csl/6UufY8fpKrlGKn1f0nf8B4u+u4/8uCNeZOLJ
wtwnvQCRKLSXhMOzSdh9AHSTno73jvtsKeRQb02XJQGqXAh0CiropKhwyZHtLDb+
5I/FsObXSD2jglG78VKeVVRA1QzEQw==
=//Cq
-----END PGP SIGNATURE-----

--Ith3iiQIRw9HfiCb--

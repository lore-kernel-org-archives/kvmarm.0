Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22693ED5A7;
	Fri,  6 Mar 2026 17:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772816933; cv=none; b=pfKMfp+4IYib1CnIGgVh8Ru/82f8mdEFRvabn1Rw3JrhwPAmyqsHNoSXEuv51r99ApBzZTBK8R9/hNHvfiRaBr7yuKs5K8BHSNJ/nSs1fIjgsfuNoXb4pgOb5OewyMwJ47KAQ4E6DqIQX9l109Tu/2ngg2vFMBOqbgeDAsRIx6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772816933; c=relaxed/simple;
	bh=TDFTh7YVO4kn+0E0wS0GDUsWeU0kWry6Q+J9Kpv0oXE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UDyF4q+yZZKCq+PUfNdD04qLNH452rle4q1x14hClasxZD9TpTwn0vlRmf1G0vCvzG3zhqDrNwKa1XUYZCzoRD7UqNmwFjybywVfdzJPkQe3VQRwa16x/Xf0NOw1oW8bwl7IXSbYsPsfA9bKDnjMAvjEI5MqTgslEbaRhakLK8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DyKrolLd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DyKrolLd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D0DEC4CEF7;
	Fri,  6 Mar 2026 17:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772816933;
	bh=TDFTh7YVO4kn+0E0wS0GDUsWeU0kWry6Q+J9Kpv0oXE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DyKrolLdqXUStW84WIm2omddYdbUXF+hGZtK802uuQypZj1wK/EQXcD6t3YN99hvd
	 wjQuiJ1h0mQajkmgMTAycWV/OYevREL7m7TewO+3Aw7mb7QAPC7xSDQr9vjHyoAhXm
	 dtHZ9YZ56LQf/Xy0j5LkYgFHhUVwzLBMN3+UvCUZpo1iFnAe9Eh2SHiiBnH+goT3R8
	 mVU24ant/W0ho0G+f1Q8chjXCYsXdmbgmGsj8rUHYLrvr9dFWuhQfBWL6yIDjvUIjR
	 3ZQ+oNTbXT+ZbXeAiqWvGFXq0v5Sz4SobWdEfxLoFD3vLlmQ7qes11wXgJMWIxWoRY
	 m0DkJUN9Q2WvA==
Date: Fri, 6 Mar 2026 17:08:46 +0000
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ben Horgan <ben.horgan@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v9 00/30] KVM: arm64: Implement support for SME
Message-ID: <db2acbaa-704f-42f3-9fa8-aedd769f03e6@sirena.org.uk>
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org>
 <CA+EHjTxOKDZ+gc9Ru=HpcRb8O-AvRm9UJaWM1fZeoqSz0bLK=g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ZcTNpR9PUgKwPiHw"
Content-Disposition: inline
In-Reply-To: <CA+EHjTxOKDZ+gc9Ru=HpcRb8O-AvRm9UJaWM1fZeoqSz0bLK=g@mail.gmail.com>
X-Cookie: A nuclear war can ruin your whole day.


--ZcTNpR9PUgKwPiHw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 13, 2026 at 02:58:37PM +0000, Fuad Tabba wrote:

> Looking at copy_sve_reg_indices(), there's a special case for
> KVM_REG_ARM64_SVE_VLS, which forces it to appear before the other SVE
> registers. So I wonder if we need to do something at the level of
> kvm_arm_copy_reg_indices(), or do some sort of post-processing to the
> list, to avoid this problem.

I did look at this, however I didn't see anything that seemed tasetful
to implement and as I look at it more I'm not sure any naive VMM is
going to have a good time with this ABI, the fact that registers can get
hotplugged depending on the current mode creates all kinds of fun.  I
left things alone for now, I'll take another look and see if I come up
with better ideas.

--ZcTNpR9PUgKwPiHw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEyBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmmrCh0ACgkQJNaLcl1U
h9Dn8Qf42GYB6VRVYWWy74gXH5yYwfw/Dpc+vc4pcS+Zlnn3oXmF2ou3o843wN81
+yjHL5yhHYBPUskqw6skN6Cw6rRlIHcN/ETVWdhwxAQzYpwNb2RFFJsO6uRQfIrH
o9Iwp8jI0A+QdVTo63Aek8dSpgYjQ9q+6ZKBktHL2HxZcfJ1kLYr9FLuBiR2SWJF
VTTBBywafr8rIXGJAuNJjUynKVczfgUioBByqZy7IvbNX1ddjGXlW41a9ua4IkpG
64kQ5vTKOR9g9XfIOJKEJE0edOqYSFRo55vCVbYUIN/uvNUuot9RP3OfkXsXk9qJ
7KyDFAU8Cb8fWNfplV7oyEtVjMG8
=avJ6
-----END PGP SIGNATURE-----

--ZcTNpR9PUgKwPiHw--

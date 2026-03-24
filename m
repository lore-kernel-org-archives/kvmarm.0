Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA551185B48
	for <kvmarm@lists.linux.dev>; Tue, 24 Mar 2026 02:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774318486; cv=none; b=WOcKJJmX31ocqhxPWS3MHEXGAqnHfCv7PWAL8ApgDjbMiOWVuYEOPlpipgZtNuZdTTwCtZIeZKvlkc4KcZZ3w3CyYd0tyLUeagpzNQq5NsNXgQiwby6Efh6eDpOrLGkbcY9uLT0xN3maWm6bFdwsa0Zx/asW9D7tVRFqr3f5qrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774318486; c=relaxed/simple;
	bh=TO2RzNGl3QaEmDTI2VDfAcOvLdhOrGE8ero57x/6NBU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VrM13fuhqGAr/wuxtaJbQ9KT4K1NofVWjW5srGsbta4Zft3rw0DTxI1C5VNCijw7k4p19T3vP6/E17iere/FHS421zMA8L5HnjFEmSQ3cfTo5PmiqGJhijKfpiR4D1A/wySeUUWx3V0g4EGfmB2qQyqtoszgXBijWsWM73RwWmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eTek9b8C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eTek9b8C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E374C4CEF7;
	Tue, 24 Mar 2026 02:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774318485;
	bh=TO2RzNGl3QaEmDTI2VDfAcOvLdhOrGE8ero57x/6NBU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eTek9b8CkkhrzvSimQb+Reep8rVSxPw5Og9X7W1B96JNpCSbpPdnsHl307dm0kxFS
	 8RTR2+TR32GuCCo63iMbGEvnNTOfUT1rED4pvLMc6OnP/jDG5AlZLu7CbSy3YOl62A
	 B46kxQ6R0pRyDubvl5y/JEhA88DEUAxIG7SjQsQoHlbpYZh2fIE1BDhtwyusldXUw3
	 xniGdIkcqhqqVxPyryWJhbhZS6bVCg2NO/F/aDGzlbw5RZEMNXoS4Ow9OZiO7/de9J
	 X1tf4yCO3MUwYmWvNzjomaPsb3/9mUT6SbIvlEBTH0sbsraNJJAXdf45+QB05Rsrkr
	 Mm3EipOy5DD9A==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id 096101AC52D3; Tue, 24 Mar 2026 02:14:42 +0000 (GMT)
Date: Tue, 24 Mar 2026 02:14:42 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: set_id_regs: Allow GICv3 support to be set
 at runtime
Message-ID: <acHzkoowEHXZ5BJv@sirena.co.uk>
References: <20260323174642.3183075-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="kvTKe6LgctCn4IwY"
Content-Disposition: inline
In-Reply-To: <20260323174642.3183075-1-maz@kernel.org>
X-Cookie: Identify your visitor.


--kvTKe6LgctCn4IwY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 23, 2026 at 05:46:42PM +0000, Marc Zyngier wrote:

> set_id_regs creates a GIC3 guest when possible, and then proceeds
> to write the ID registers as if they were not affected by the presence
> of a GIC. As it turns out, ID_AA64PFR1_EL1 is the proof of the
> contrary.

Thanks, this fixes the issues I was seeing in -next:

Tested-by: Mark Brown <broonie@kernel.org>

--kvTKe6LgctCn4IwY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEyBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnB85IACgkQJNaLcl1U
h9CCowf4yEm4L6SEBrzHzfDEPo9zYZqteeOj1r7q+vba6HHLd3YAtNDdsghS8r2A
8ByiqvccyeAcNpQsyESaNL2S85Qfqbx1KvT3rfzOAJBdAvOrobFrOfokpTkpT5oi
fa6236lfJvFSNA24Os69/yqWmUiCNY9zuvEtmMxt715t6qE6x89QU5X2spvqFz/g
pfXMb+CZ5wDrSCogJ2PJqOYaRKca1MlbqRaKPaivgfykCQ8XyXdBpHQgu7Uk5tWn
smq0Go6mkdJvqW8JEH83LDB04EaEyB8rGJzYV+wLdt/W9uGn8AnP80jhGeTvC2ck
WnEAHwf+gph6u6i0VWm1/rg+6otU
=PO86
-----END PGP SIGNATURE-----

--kvTKe6LgctCn4IwY--

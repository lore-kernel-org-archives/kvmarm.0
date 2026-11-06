Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793989120;
	b=cki+4cGgbYPCLyemzG/MlWrCCVAVBF0jrLhbNW934me9NpuhdgWqor/f/f3ZD1xpvqaY
	 fyn2maTVgkFErcsyOkaEe8Q6z+OibRcoIP4OJrRAD8M53KEI5hB6PD0N4R+6D6bqpqUYu
	 QK9H0xCNeh6VnvNGxHZNByFaLziAR/oski/IuoLR110GweM8j7WcEha0CEFDBn7T/vixT
	 XS1jqHZa1bc/Rle/gpPfWtxizy/9u6U3fIe5XtUO71vhiEtW88OaEbZMU1AFHWHBJbc3x
	 21x/jdxWMdHil/ONEHsKZvY/ZDT2a9wZy9vIBfVHV37xlJoi3phguhcKvqvQcj672cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793989120;
	h=Received:DKIM-Signature:Received:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
	 X-Cookie;
	bh=czG6b98iqgdh50bkB3r4VwmRbtML+O/0o7qS74T1MBY=;
	b=Zk1LNDZxkpEF08Yi/6vRNQtLfSq9ZRAsc6eIoARhREqlIzcY9Ne8tb2cEn5w1sUzjU6N
	 pIAk9gick15vTuHDkXNGdt4urEN29s9ZOi2HJQmxftfKkz1DZNSTpI4PhsMmYw6nmxNjh
	 3VsIFCRGRm8OjRl2Vm6sHOAKcJZmLw14aPRSt5bhETuhJ/QpyQVDghe1a73yAlDx/Uqvd
	 bnxse5nhPW79EEiasRhAyL5F0TT3ND514TMcE2qKlko979F8H+IcR0qXPXuQm+19hHLmc
	 QL0OtJZ9LYJu5/TnQSoFmqiX1zJs4qPgEUk8/bqrjsmtKzOg0g86TOSUiOM0Bb/OAjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JPfw6MVV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35F3606A326
	for <kvmarm@lists.linux.dev>; Fri,  6 Nov 2026 18:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JPfw6MVV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 771C21F0089F;
	Fri,  6 Nov 2026 18:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793989119;
	bh=czG6b98iqgdh50bkB3r4VwmRbtML+O/0o7qS74T1MBY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JPfw6MVVAOAP0lLEmqoeaXYQVRNNtzGxo/vXiZELnkyIxDapradxOf/LAFU92aUe/
	 pXgryMx/2cr7HPubbqA9m+djaZaiY2/2WjgrRtswsmiW6ZTTG5yDEhYUzEz0wormjP
	 MtxtLvRlbQpi+Vbepn78QCMp92FxkugCS30lFNzLZowLc2fXxgGatpT9t6FYOL7Lsn
	 xZ3mUcIVLhNq4obRtFEGoHbSk3fw7R2+ipAN7xBDbRRpETG8WaNwWJeQDVw+GLTU7w
	 ksU+u0HwROqdHJ/7q1h52SarTkHMikN5a19xTZ+ciQ2obikmg9YQv2XpKwpjfoJBm7
	 fxZ9V8wD7tLbg==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id 9E2451AC5995; Fri, 06 Nov 2026 18:18:36 +0000 (GMT)
Date: Fri, 6 Nov 2026 18:18:36 +0000
From: Mark Brown <broonie@kernel.org>
To: Oliver Upton <oupton@kernel.org>
Cc: Wei-Lin Chang <weilin.chang@arm.com>, kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>, Aishwarya.TCV@arm.com
Subject: Re: [PATCH v3 4/5] KVM: arm64: Convert TCR_EL2 to config-driven
 sanitisation
Message-ID: <au4Z_BWMOvV3iQeg@sirena.co.uk>
References: <20261029223732.103785-1-oupton@kernel.org>
 <20261029223732.103785-5-oupton@kernel.org>
 <5e8a61c2-24ff-46a1-819f-94fcd91c9688@sirena.org.uk>
 <3pof5ftjdhngkbwn3ixnlynryabl67gfhwrfr54xnizo3iytwi@cicn7hku5i74>
 <au4SKGsAAdsPm9SD@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="p4rBQ+x/eScul9AO"
Content-Disposition: inline
In-Reply-To: <au4SKGsAAdsPm9SD@kernel.org>
X-Cookie: Victory or defeat!


--p4rBQ+x/eScul9AO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 06, 2026 at 09:45:12AM -0800, Oliver Upton wrote:

> Thanks for reporting this Mark. Next time can you also include the QEMU
> command line that reproduces the issue?

It, and links to the rootfs and test binaries used in the tests and a
print of the qemu version, are in the logs that I link to when I send
things.

--p4rBQ+x/eScul9AO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQReagvpf3TrrA7BoYYv73Ows9A4iQUCau4Z/AAKCRAv73Ows9A4
iUZPAP9hmvSyGHV+kk/BRDxnkQjuVO4BNg9X+jKj5Uga4keg8AEAk29aCNMchRY4
ZZcKZ1PWfEexcdsOb18CGva2Vb27MQA=
=R2lw
-----END PGP SIGNATURE-----

--p4rBQ+x/eScul9AO--

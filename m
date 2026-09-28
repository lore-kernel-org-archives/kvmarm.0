Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C2C2DC765;
	Mon, 28 Sep 2026 16:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790613123; cv=none; b=YQDW9vTpLwPSHEWhRwMIUjrFhsLcBh8ZeEVNy4WrviSWS3+jvBKPuJfBrpAhxcZAjTuwq2SnMBDVVRDlYEa2hXhrQSe1pEb9D2lhyrO0ikcsnJu3cyDD3KgiJQxcDkSpEstlJN4XP3Ajda2EZ7H4tLHcPbR7qSJgZkmmTF+4RdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790613123; c=relaxed/simple;
	bh=LSSkPt0tyd7BePBQ11bLsPWDs6ALcf5DvYsfQdZG8n4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t9Ck1dSRxFqej1UXacpLKTTt8ZajjeAmgb+0qe4jjL123YsyCLffLlz468GuiN9eqRBs7iRT24MT1q/miWYFLTXDEC4qYMaEf00+p6HxFzRc61h5ZtmBewanRyJWTrKStVDOh4SE/6NlFW8XzL0clI3KPGwwn4kEVPNAYxdRYzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LpNXrGFn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LpNXrGFn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 606F91F000FF;
	Mon, 28 Sep 2026 16:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790613122;
	bh=LSSkPt0tyd7BePBQ11bLsPWDs6ALcf5DvYsfQdZG8n4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LpNXrGFnb9HaIuC8KX+e1iSYACFonoGQ0XWZS0Jcu7fAbYY/0JFYUISitpzMeAumN
	 kzlUFfKyoXMMm0pixrV6hJcU7BE4QZk88lJ+QiX+FPnePwDm5fyD67vn5zX22lAGqS
	 Pj30lD989kxJg3QZwidBzL+PiG5Az2MOsktAxVPi1HH+yaMKJLUx67ebxL2/EbhTqd
	 JttFmrpIeh7P9efWcxk0tcq4ct1PhGu7NgzjeVhiTd3ARNba+ataEd+qF1oX6paRtF
	 nbbrjoVuFG01AlYzLZdhQoC1UmsZ3nBcZMlhpwF9hGP/bmi+ViviPcEInsV/nT2j8Q
	 3CL+lz7I9f2MQ==
Date: Mon, 28 Sep 2026 17:31:56 +0100
From: Mark Brown <broonie@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>,
	Peter Maydell <peter.maydell@linaro.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] KVM: arm64: selftests: Check ID regs are
 immutable after a failed run
Message-ID: <83a389d3-6328-4762-a96f-46f9f7145b0e@sirena.org.uk>
References: <20260901-kvm-arm64-idreg-final-v3-0-a0ffa06fa872@kernel.org>
 <20260901-kvm-arm64-idreg-final-v3-3-a0ffa06fa872@kernel.org>
 <arp7mig_PrD9Jbc7@gremlin>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="AAMnBzaO3gKbG6DA"
Content-Disposition: inline
In-Reply-To: <arp7mig_PrD9Jbc7@gremlin>
X-Cookie: All is fear in love and war.


--AAMnBzaO3gKbG6DA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 28, 2026 at 03:46:51PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Tue, Sep 01, 2026 at 07:18:50PM +0100, Mark Brown wrote:
> > From: Fuad Tabba <fuad.tabba@linux.dev>

> > Assisted-by: Antigravity:gemini-3.1-pro

> NIT: we changed the rules for the Assisted-by tag, it only needs to be
> 'Assisted-by: LLM' now. Not a huge big deal but FYI :>)

> https://docs.kernel.org/process/coding-assistants.html

That's Fuad's tag not mine, I've just picked up his change verbatim.

--AAMnBzaO3gKbG6DA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmq6lnwACgkQJNaLcl1U
h9BSHgf/dsZOGOdrRnI26oAZQKyMEaKtzUE+S6oc46T6NARbYeekbnDVX+NeLJr3
hKjGjgbwagGXC7mYmPcOvunoatLjeFrgga/aOwpJqB5gucMNB8O5nQtyx6OWrKH4
Zoom+ewSdp5kuH+pVTu7IGFQQmFNbeHI3hD7SFxwInLViJaRP0NGOF/N+Rg1XhAL
jdvpj10jddzOQ3gBHqTktod5VGImbBz2VNxcSW0EAGQ3bhQS+vm/DNmkxDksnswS
m/Brc/kZfm1Q/UlxXODXX9fu00f98IoxU4YXCwTcmukOUc15gI+xK6JD4+XZ5UCZ
6NpGPSsLPeWNUOcBDeV6n3fWCYmiQQ==
=Y4zb
-----END PGP SIGNATURE-----

--AAMnBzaO3gKbG6DA--

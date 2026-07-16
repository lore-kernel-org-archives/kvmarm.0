Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2686400DE8;
	Thu, 16 Jul 2026 15:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784215691; cv=none; b=L1R+gQqKjDYFqgODq+RRwuQlTi//4ZTphQhfFblJi2gP0YmiQnSnhjkqEqsrZTgKruJV8VyD9klm8imDBSsITSrWEPVIvQoGTYSpZQD+dKHq2XAB1kPPizdZZLkhFty1vqBWpmkjAXm6UlPxndijLPYUdv1wU+EzFoQ+WkjrKwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784215691; c=relaxed/simple;
	bh=hsDRfma56w206p8//l5E5r8hf0aTgPp91AYKBXlklaA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tm4do6gZarqBx89tI8Jm2Giwks/4BFQ5SzFCuaztLyAh5KrEUy0T3acyI0XbU4sx/5USkhlCTlk/Ba8Eu5ZmZ0AzhZKVatAIZuMFmOYmcknpOW75+Vuy7d8oCS1ghwX9EPll1LTedS9vPvCsDVWS5VkYgIZX25AWe5GGb7rbQ5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DSjOcuzd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DSjOcuzd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 243E01F00A3A;
	Thu, 16 Jul 2026 15:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784215689;
	bh=oaIf2bJqWuKl6xlqqkPnkkfbrbDLiH3vk192GmIwHZk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DSjOcuzd0iLGxdIes4vVV48dc4V0xwUGKeQz/5Xho6MHAQsIujpe+BdnwPw0wg0+U
	 kWn78oND/Nsyb65Ui+FTYIxM21ZVE43nzaOmR/4/FweSh5R46+jozUFTMk/oL1ydAb
	 CMvoOwXNblYtgrjwlIPoNL9RBSOsH8r4OUI+XhSIcjVLJ1PHC2YGWYSDMK+yufe6bB
	 KJPe5uyJWBiwSGKikLPe/hBOjcKysvFYtcoYGIh3j7SQ2QuAGDX6axU1hn1qNqWWhk
	 JA5jOhLn61lR6HAAU2byHYkiPbBtgcsbjOnAzsWuNBZkk7d+b99KGn275vXpLWebDq
	 a1DHcX04mcdbA==
Date: Thu, 16 Jul 2026 16:28:02 +0100
From: Mark Brown <broonie@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>,
	Fuad Tabba <tabba@google.com>, Ben Horgan <ben.horgan@arm.com>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v12 02/29] arm64/fpsimd: Update FA64 and ZT0 enables when
 loading SME state
Message-ID: <15a9ae14-395d-472a-a5be-9e46524fb493@sirena.org.uk>
References: <20260709-kvm-arm64-sme-v12-0-d0301d79ef58@kernel.org>
 <20260709-kvm-arm64-sme-v12-2-d0301d79ef58@kernel.org>
 <ali39DG6qie7XTuD@J2N7QTR9R3.cambridge.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="xV6YaOAEqkneq9ee"
Content-Disposition: inline
In-Reply-To: <ali39DG6qie7XTuD@J2N7QTR9R3.cambridge.arm.com>
X-Cookie: The more the merrier.


--xV6YaOAEqkneq9ee
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 16, 2026 at 11:52:36AM +0100, Mark Rutland wrote:

> >  		if (test_thread_flag(TIF_SME)) {
> > -			unsigned long vq = sve_vq_from_vl(sme_vl);
> > -			sysreg_clear_set_s(SYS_SMCR_EL1, SMCR_ELx_LEN, vq - 1);
> > +			sysreg_cond_update_s(SYS_SMCR_EL1, task_smcr(current));
> > +			isb();
> >  		}

> What's the ISB for? That mysteriously appeared in v11 without
> explanation. It wasn't in the original code, prior versions of the
> series, or my suggested rework with the task_smcr() helper.

> I don't believe it's necessary to add an ISB here.

I can't remember or figure it out, I'll delete.

--xV6YaOAEqkneq9ee
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmpY+IEACgkQJNaLcl1U
h9C7Iwf/YuGnlCXvhBlz9BWXCUqYqn9u51Mi2A5/kXGFOEGaMF0Uu9MGkvq2Jk8F
EOseSkFIRcD7GiH3vDa2USAS+1NLt+TPjQy2gRSMD62MCXm8N7BJY5LioojxX7Rz
Ta0iqU+mWhVRuJxJ82JAWagl6zKf47yda6x+5tFDegJFU+5bUTTPcagYyWtDvfgt
sEVPNBjbQBZdC4QdbkH7/6gw23LCPuaMWqZlOP5UHuFn83ZwvAKy6/PxzpMs2y4p
4+4qFfGT6oanft1qW1XJ9TfgyqAjrQ1Ug6KUpdVpktBfyigwcw2MFWxdUzLmSLKG
LbYJk26LLkkGxmTPXVFVEAKBHv2b+Q==
=/cAU
-----END PGP SIGNATURE-----

--xV6YaOAEqkneq9ee--

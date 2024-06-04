Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9AD146A7B;
	Tue,  4 Jun 2024 13:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717507792; cv=none; b=I6BQHs3/f7bekMoZCCbcy5GN0/VqNf0zXK0jJdD0TijMDjVpfq4mQgi7xX5NqBMf+FcKG/F3V7oAjh0zKKex3FrWzeDv+9KgwJEmYshBcR/m0OxuSv9zx1VfZa17NDEUgptNHgTTEmphyfX3QuZguhs4zXsa4i957XKZTvYa8zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717507792; c=relaxed/simple;
	bh=kWuUiBdpKjrsYecHnVEphiWORJ/qDun3q6DFFXNPjd0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TRPIQKQGjy/f8vCimU2VZ7RejCuowRZRKp+iF/5guxp8mE6zceectjwBvDSPNw5yiwPnV1uDLYF52iMMJEQO8i1kRw3kuarITfZnGL52zzzvLwx6CoYjIBUjp4TNQoLY+2d238v4vqrTv0tPQEYz+INK/FgZQ/HUmBH41gCXJOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nagjyk6R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nagjyk6R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE0D6C2BBFC;
	Tue,  4 Jun 2024 13:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717507792;
	bh=kWuUiBdpKjrsYecHnVEphiWORJ/qDun3q6DFFXNPjd0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Nagjyk6Rht8Nm8CXtzbcn9K3Bg8znS5b2z5cHpwGFaOPtrmHPT98FDQxVhbDyLaCi
	 uhUQXoEoJ6qGRWcWikbSr/bMCUtzhvuLW1JOYnIJv9TubetjRujzFfoa30XT9VsyIt
	 fHA2R6YYiWvOLAQviiapfSkhY2MBEBPpUU3J1JfQiWKdckYoEQQoqNcc71j1a+Embz
	 xHf8jmpJbqg9VWkX/WoY/wrg05/7T+T9gj9/jmdUkRgyCSHKWAOFAQEkZXrzLUTZDw
	 IWi0PeH9KDF5Y6egJsYcKU4+yGnjzobrOn9MVbv4Iv7xTJ5RAvTtab/X9VGUvXiQQy
	 8aUUjqqWRYcZw==
Date: Tue, 4 Jun 2024 14:29:41 +0100
From: Mark Brown <broonie@kernel.org>
To: "Liao, Chang" <liaochang1@huawei.com>
Cc: Mark Rutland <mark.rutland@arm.com>, catalin.marinas@arm.com,
	will@kernel.org, maz@kernel.org, oliver.upton@linux.dev,
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	tglx@linutronix.de, ardb@kernel.org, anshuman.khandual@arm.com,
	miguel.luis@oracle.com, joey.gouly@arm.com, ryan.roberts@arm.com,
	jeremy.linton@arm.com, ericchancf@google.com,
	kristina.martsenko@arm.com, robh@kernel.org,
	scott@os.amperecomputing.com, songshuaishuai@tinylab.org,
	shijie@os.amperecomputing.com, akpm@linux-foundation.org,
	bhe@redhat.com, horms@kernel.org, mhiramat@kernel.org,
	rmk+kernel@armlinux.org.uk, shahuang@redhat.com,
	takakura@valinux.co.jp, dianders@chromium.org, swboyd@chromium.org,
	sumit.garg@linaro.org, frederic@kernel.org, reijiw@google.com,
	akihiko.odaki@daynix.com, ruanjinjie@huawei.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 1/8] arm64/sysreg: Add definitions for immediate
 versions of MSR ALLINT
Message-ID: <9868a5ac-ae23-4481-afe6-ba3cd8dbfa47@sirena.org.uk>
References: <20240415064758.3250209-1-liaochang1@huawei.com>
 <20240415064758.3250209-2-liaochang1@huawei.com>
 <ZjUKMWPknEhLYoK8@FVFF77S0Q05N>
 <Zjjz-tzLRC2nH51A@finisterre.sirena.org.uk>
 <cde4d448-dc9d-eaad-4a2d-a6d34bda4449@huawei.com>
 <ZjpALOdSgu-qhshR@finisterre.sirena.org.uk>
 <e632a9ed-7659-9336-6e7f-a43c4759a7a3@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="kZyx21bZX9W6NfCv"
Content-Disposition: inline
In-Reply-To: <e632a9ed-7659-9336-6e7f-a43c4759a7a3@huawei.com>
X-Cookie: Is it clean in other dimensions?


--kZyx21bZX9W6NfCv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 03, 2024 at 11:26:39AM +0800, Liao, Chang wrote:

> Mark, Is your concern is that the series of pstate related macro name in
> sysregs.h are lack of self-explanatory nature, which make it diffuclt to
> understand their functionality and purpose? If so, I daft some alternative
> macro names in the code below, looking forward to your feedback, or if you
> have any proposal for making these helpers discoverable.

...

> -#define SET_PSTATE(x, r)               __emit_inst(0xd500401f | PSTATE_ ## r | ((!!x) << PSTATE_Imm_shift))
> +#define MSR_PSTATE_ENCODE(x, r)                __emit_inst(0xd500401f | PSTATE_ ## r | ((!!x) << PSTATE_Imm_shift))

Possibly, yes?  TBH I was thinking of a comment but that does have "MSR"
in it so might come up in greps.  Not sure what others would prefer.

--kZyx21bZX9W6NfCv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZfFsUACgkQJNaLcl1U
h9DBTAf/QbAdz0gZPoB6cZv3uCTSDvYO1cYiTX9u5Ejd4CgUJCcfU6JhTZi9lL01
Vrn3Nd5SlPmKVrPWMb6HMbvC/GNW6Nc0gE196nDRdaMz6o29RD0B5j+BPWiQ99Ia
MEXAs+lQD/nbf9JhLqto1ANTrc0Mf8gfWmFTt/MzoKJ7Ourujm6X//Tc8VxH3sdU
nNEPqG9/rA0b+pjIrmAFmdglZyrsr6z79A7gYvBsaf525R95FiFOv8xh3uAHNpKj
37MUhZ7YmJXCe/Ljy+MEUcrO/8+uljx7PWtBuROurQLnitvVF5eTLzunON9mkhmx
IEOifj6i0UEzDv2QKT948bHcgn+kNA==
=aRgu
-----END PGP SIGNATURE-----

--kZyx21bZX9W6NfCv--

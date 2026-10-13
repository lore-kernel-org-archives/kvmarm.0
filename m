Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309943EFFA6;
	Tue, 13 Oct 2026 13:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791899405; cv=none; b=OMs1C2f1xvrpYebRj0vfFT+dmq1XA1G99LtJUJ+jcuUafUWMdmLbOL2kIAEiajsEE/MZNRb8ITvVUZW8PnNdGEDtFz9LlWnpTFqA2CHoC+7KXZHdRwi9MLduTHQyn40lO1+iyiRz6fERgD9nDKXzUC78Cenn+SmSIOC1qi54zak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791899405; c=relaxed/simple;
	bh=TXfMXr3ofUOe3VvzGuzi9UAal6HoM1qfiOVecqu93hE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V9TeVzGXu5l86Ojrvi0mFsaNBf5JEbQeOG0XDCAe+ly0diO/T0qUueBpVzopVsDwdFiMNvyajAkl8fb+CsvCV4+5yTLj7iB2KWcADCkwFcLKRwRYA/UdHhddrx7hR6DVIgtfoK4XH7oBLU2sp8UpRhQWfdO1ZUVwV9Jw89lCg6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cXdrPtbT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cXdrPtbT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 224811F00893;
	Tue, 13 Oct 2026 13:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791899404;
	bh=TXfMXr3ofUOe3VvzGuzi9UAal6HoM1qfiOVecqu93hE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cXdrPtbTeruVvXdwz1f7Ja2lJmGRQUiieTfUMe7Azf/gdRWuFqjDqSv6uxfZ0K9pz
	 1FnoqtugJTqdyCtB9LMtNPBjJMFhmbYg6jrYT0biaip/jCV98PT6iMlYx3INF7KW19
	 kh2RojDpTusZitvbuDYwQOXEgh02sjBcdPmOlqnlfn0r9A4+F14R1dG0JBGPNHaS+V
	 yxcF6yg6g33y/iW5b8JtO58L2xgX83jgB2z6Kpxtjh6+rFCjzUgOv1CNuoh+WzIT4j
	 37fl4KgCRkNpfcg70U5FngeOPXPM8bN/TgSKXJbxU5Hfg32+yvTiXrUuNfGzyCK/0q
	 YMrG9aks7K7MQ==
Date: Tue, 13 Oct 2026 14:49:58 +0100
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>, Fuad Tabba <tabba@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] arm64: sysreg: Fix three incorrect enum values
Message-ID: <92e5b67e-f6cc-4b33-90e3-cf884ec22452@sirena.org.uk>
References: <20261013130247.4135515-1-fuad.tabba@linux.dev>
 <20261013130247.4135515-2-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Rq/wb53K3Hf7A56N"
Content-Disposition: inline
In-Reply-To: <20261013130247.4135515-2-fuad.tabba@linux.dev>
X-Cookie: Some equipment shown is optional.


--Rq/wb53K3Hf7A56N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 13, 2026 at 02:02:44PM +0100, Fuad Tabba wrote:
> Three enum values in the sysreg file don't match DDI0601 2026-09.
> Outer Shareable in VTCR_EL2.SH0 is 0b10, not 0b01, as TCR_EL1.SH0 in
> the same file already has it. Thumb-2 in ID_PFR0_EL1.State1 is 0b0011,
> not 0b0010, and the M-profile model in ID_PFR1_EL1.MProgMod is 0b0010,
> not 0b0001. The spec lists all three old values as reserved.

Reviewed-by: Mark Brown <broonie@kernel.org>

--Rq/wb53K3Hf7A56N
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmrONwUACgkQJNaLcl1U
h9BuKwgAgS56Wi0nmWiVjRhDGQik+UBXmwru+1ZVErRWBA9lQxoSI4vVjJJs1JeT
dCPPFb+FaOgp61UZnGzrhcKdSThI8CarEFoDCFyN4kGrD885duYRfClVEyQvQsCc
qccF1GGfUb/TFH4N53KsTKfP0IPt1YfhCrDMH9AzC9g5wsLXIUT792aTohpj+Drp
gP6gHbFgrxTpJl2VMsJuPxmfaeBCfe3vuHTykr4osWoMLNvGMmznXgTSHQMCKkd0
+nhFO1tBKzuJzR69gJGSHuhFwnOvMS2nGT3gj5CV22avixVSQeHQiIe4hUzLzdnH
eVXFOXiatDUXebtvulL35tcX9yX5zA==
=9+f6
-----END PGP SIGNATURE-----

--Rq/wb53K3Hf7A56N--

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4229D1519B4;
	Sun,  3 May 2026 01:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777770120; cv=none; b=UxkqAeFhcjp6w8v9vdKyafmk540d1sxHGpJef/eUZuHVaNJbqs0eQX2osaMlS8Jv7a5piawOotb7FvTcbabajxANvt4pHcIR2S/rVj0CcQkzf4kprbkl+rKM/VfFBcSPIle1R9eU85Eo1lpc70Ja/XkD4OJDndSuzmfMF3dY1c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777770120; c=relaxed/simple;
	bh=BejErdLjcloUq8b5PniyViDnyXSa8nSLqZwJTPcujYs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fHE5byNamjYHH+W3hEILi4ShwWKo6710osFrZHMmfSUuXjckUaqVSOEcuz3TYg8eQrV5HBBD4B2vQB0Pj66Vky/bQQtyFkNMOL8y0DXKrwm9PCDRKkNXmZod5IT0/qRLIDdMpIFwrXrZAyHrRhqs3iXwxjWdOC6olbi3guQYa7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pDysEjuQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pDysEjuQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD9B7C19425;
	Sun,  3 May 2026 01:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777770120;
	bh=BejErdLjcloUq8b5PniyViDnyXSa8nSLqZwJTPcujYs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pDysEjuQPcQ7jBSc1PFLCXCQ7pK5ItVVQyrqU8Gyl4viLnzTzP2w4VpjqCHLJKBOz
	 usCZwjN9TDEfMj+cYa/33gOuSAt5nfamthqjp2AwRw35TvA18BnbXfGLYy1SIVi+Ku
	 VpWJwmybN+1cdODsbyvSrF+RnXTLNgYjfKVg/rwFv0jz8VagDW4WlBsPMrVvnUQOsk
	 x0UORuIs/mzc+UZ23N9WOgWRhQIL1pEqmyqwfrplHpTqh2Tj2KvS7aUgLuEY24jKBA
	 6CeeawTTgroCGO+uJyDnpedMO+hrK0I2xks0sYaSGBYzPCGs8qi6e2RJLzNqaeVHvk
	 dbgY9KLTOb/dQ==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id 45A1E1AC5865; Sun, 03 May 2026 02:01:57 +0100 (BST)
Date: Sun, 3 May 2026 10:01:57 +0900
From: Mark Brown <broonie@kernel.org>
To: Leonardo Bras <leo.bras@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>, Saket Dumbre <saket.dumbre@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Chengwen Feng <fengchengwen@huawei.com>,
	Jonathan Cameron <jic23@kernel.org>, Kees Cook <kees@kernel.org>,
	=?utf-8?Q?Miko=C5=82aj?= Lenczewski <miko.lenczewski@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	Thomas Huth <thuth@redhat.com>,
	mrigendrachaubey <mrigendra.chaubey@gmail.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	James Clark <james.clark@linaro.org>,
	Ard Biesheuvel <ardb@kernel.org>, Fuad Tabba <tabba@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Tian Zheng <zhengtian10@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-acpi@vger.kernel.org, acpica-devel@lists.linux.dev,
	kvm@vger.kernel.org
Subject: Re: [PATCH v1 04/12] arm64/sysreg: Add HACDBS consumer and base
 registers
Message-ID: <afaehWCHVIN7EXNB@sirena.co.uk>
References: <20260430111424.3479613-2-leo.bras@arm.com>
 <20260430111424.3479613-6-leo.bras@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="WmuCcD5bxYsJvAXW"
Content-Disposition: inline
In-Reply-To: <20260430111424.3479613-6-leo.bras@arm.com>
X-Cookie: 667:


--WmuCcD5bxYsJvAXW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 30, 2026 at 12:14:08PM +0100, Leonardo Bras wrote:
> They will be used on a later commit to make use of the FEAT_HACDBS
> mechanism if available.

Checked against DDI0601 2026-03:

Reviewed-by: Mark Brown <broonie@kernel.org>

--WmuCcD5bxYsJvAXW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmn2noQACgkQJNaLcl1U
h9CXzwf/ddnlYC9NFIeWjihBxou3oH5yLLC0aEWsSsEpn4ePUND6BEnFEbPaP+E0
wbcFjU2eas3oIrx14W0iSIIkalM+8iam+DOyMFcNK22DZotaxwdHuqn1HmsicWN+
bTSDBTOc0jl0nawI+0FSS00Efpiubnsd1b2vM75E8/nkDujvazEz94P55PRYoR+f
DSl56OJoOQYDtJOcEGr7TFlY1T/nTMZ9nVO0+i1GCXNeWvSkm0driq2SxrwV6p6a
s/THx+XOJC9gXNK9yIFDNRUObRZrSA04vIQQiVyi/hR3HZpCs2a3/9+1Axo8qQAh
MuE6Mv9pzZeGJkoowjc8UJYs95E4aw==
=vdry
-----END PGP SIGNATURE-----

--WmuCcD5bxYsJvAXW--

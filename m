Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14FDCEA1
	for <kvmarm@lists.linux.dev>; Sun, 16 Jul 2023 14:47:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 317D2C433C8;
	Sun, 16 Jul 2023 14:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1689518822;
	bh=+hMc8ugrHp7fI+hA/2OaOqqA+y+u59MhmMd8vbe9uSo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PRLX0MvXM11367/fx47JuqB+VTB0iZWs91XImy5sLmzU/K276YH21QIzw/S1R9qRd
	 GMWey0DaEvGc7GL9txdqpeYxDrWcHj0ZtW1niHwgtrDll3hvtlqns2PhZuXi0DTEoG
	 Lf5NGeTEQdPYVftB+j9JbBkA0kOYPK50rzJTrDePJuEIoeOi/AtR+/hjb7XiwX2d9Q
	 PjySV9sEFTuZ6UFM9m8CfV0XCvS0cwmOM6Am6DCJNChgnd4ZdSH0F0zuQ1uudKorOt
	 qay/fX3ho6vecF+NMm55ero6VChskFQPPpJEp+C11BZmpiUSJ4DvCsX9Uya1+mrUcy
	 NHC5IsUYCOTQg==
Date: Sun, 16 Jul 2023 15:46:56 +0100
From: Mark Brown <broonie@kernel.org>
To: Zenghui Yu <zenghui.yu@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v5 1/2] arm64: Add feature detection for fine grained
 traps
Message-ID: <e59cbfb3-55c7-4d86-8e21-56c4d65df56c@sirena.org.uk>
References: <20230712-kvm-arm64-fgt-v5-0-dae3ec236288@kernel.org>
 <20230712-kvm-arm64-fgt-v5-1-dae3ec236288@kernel.org>
 <d5d26d8e-e1ba-b6a2-0643-f3a6c2c667d4@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="0Lj+zT2ndiSVSVK+"
Content-Disposition: inline
In-Reply-To: <d5d26d8e-e1ba-b6a2-0643-f3a6c2c667d4@linux.dev>
X-Cookie: falsie salesman, n:


--0Lj+zT2ndiSVSVK+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jul 16, 2023 at 10:44:01PM +0800, Zenghui Yu wrote:
> On 2023/7/12 20:50, Mark Brown wrote:

> > +	{
> > +		.desc = "Fine Grained Traps",
> > +		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
> > +		.capability = ARM64_HAS_FGT,
> > +		.sys_reg = SYS_ID_AA64MMFR0_EL1,
> > +		.sign = FTR_UNSIGNED,
> > +		.field_pos = ID_AA64MMFR0_EL1_FGT_SHIFT,
> > +		.field_width = 4,
> > +		.min_field_value = 1,
> > +		.matches = has_cpuid_feature,
> > +	},

> Any reason not to use the ARM64_CPUID_FIELDS() helper?

It should - the original was sent out before that was merged.

--0Lj+zT2ndiSVSVK+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmS0AuAACgkQJNaLcl1U
h9AK3gf/SoLclx9BRy719PTd+f80uC8OHt/QzGEOVZ5QvGUVYw1TZxPJEgJpKmy+
RSet6eQDIUPFOTUP77304ygiNA5NBqRAoGOZy7loIcrvE/JLy14YrM24TBPZ+av+
faSivzEX3EMqSXvJP1NKcmch/022GeKah5Y5k35o2szPtSiiBzJG7SwGkYPUO9Ns
GuKTBJmxkjOxpotzk+TwOWiVck3NwG5L+0f6WmTUzmjp0Vs8yzE24R/3fyoZojHu
210/yBxoPZiGsCGPdxumYk26SguAX0sPS4NIrgijtQzBUvtr/chdGy+M4Smsebzk
2129TorBVtUW3gIM8gRyjr5nNfQKvA==
=ceAO
-----END PGP SIGNATURE-----

--0Lj+zT2ndiSVSVK+--

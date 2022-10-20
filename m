Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA25115D0
	for <kvmarm@lists.linux.dev>; Thu, 20 Oct 2022 14:33:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA8E6C433D6;
	Thu, 20 Oct 2022 14:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1666276427;
	bh=FaeuPMUHhNdQ1un6IB5cPZDWQfSVNpn50XrmvqcBfDw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=butNE0E3dApCwaoRTHIlqK9ITMhgzR7ZUe+MsoLn8uT7/c6LhoBOaxgAFYY/P/Ymq
	 dGVUw50NJC/IJAmWiq7ap+++fHy/puTkKmI9cmEzhQeh28vbOGkJummh70lLBAJbk8
	 7UOd7a1VlAbtSrg5+x5L76WVOMmjIyf7YQc57mTkSs3D2pUoKFC12SibW/YzziTBJj
	 mD5dUHYD3NOPkWczFb5pwGqAdlF1X4hx+qW/CSwLDPsRGf9r6PrzF1mOe/ja0STLRU
	 VNsiLEjS8Oss+IkCJlL6tx6TxTSswYI4AlamDLdIGUs+x8UkVVkJznD7iLOUNCtBUk
	 v9kpsctpHUd/Q==
Date: Thu, 20 Oct 2022 15:33:40 +0100
From: Mark Brown <broonie@kernel.org>
To: Rob Herring <robh@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>, James Morse <james.morse@arm.com>,
	Ingo Molnar <mingo@redhat.com>, Mark Rutland <mark.rutland@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Oliver Upton <oliver.upton@linux.dev>, Jiri Olsa <jolsa@kernel.org>,
	kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/7] arm64/sysreg: Convert SPE registers to automatic
 generation
Message-ID: <Y1FcRNhFpZxZ7AMx@sirena.org.uk>
References: <20220825-arm-spe-v8-7-v2-0-e37322d68ac0@kernel.org>
 <20220825-arm-spe-v8-7-v2-3-e37322d68ac0@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="VOl7BrjAsP2F3VXr"
Content-Disposition: inline
In-Reply-To: <20220825-arm-spe-v8-7-v2-3-e37322d68ac0@kernel.org>
X-Cookie: Today is what happened to yesterday.
Message-ID: <20221020143340.iDTJBQaAnU80HaF9yC8_uB8aXGZbs0bMFaYpPN8y9QM@z>


--VOl7BrjAsP2F3VXr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 19, 2022 at 02:11:26PM -0500, Rob Herring wrote:
> Convert all the SPE register defines to automatic generation. No
> functional changes.
>=20
> New registers and fields for SPEv1.2 are added with the conversion.
>=20
> Some of the PMBSR MSS field defines are kept as the automatic generation
> has no way to create multiple names for the same register bits. The
> meaning of the MSS field depends on other bits.

A few small things below from checking against DDI0487I.a, nothing
major:

> +Sysreg	PMSCR_EL1	3	0	9	9	0
> +Res0	63:8
> +Field	7:6	PCT

Given the potential multiple meanings depending on both integration and
runtime configuration representing this as a field seems sensible.

> +Sysreg	PMSNEVFR_EL1	3	0	9	9	1
> +Field	63:0	E
> +EndSysreg

While this does look rather different to the spec it does appear to be a
sensible interpretation - the intent is clearly to have a mask of
feature bits.

> +Sysreg	PMSIDR_EL1	3	0	9	9	7

> +Field	23:20	FORMAT
> +Field	19:16	COUNTSIZE
> +Field	15:12	MAXSIZE
> +Field	11:8	INTERVAL

These should really be enums.

> +Sysreg	PMBLIMITR_EL1	3	0	9	10	0
> +Enum	2:1	FM
> +	0b0000	STOP_IRQ
> +EndEnum

DDI0487I.a also defines

	0b01	DISCARD

=66rom FEAT_SPEv1p2.  Also this is a two bit field so 0b00 would be a bit
better.

> +Sysreg	PMBSR_EL1	3	0	9	10	3
> +Res0	63:32
> +Enum	31:26	EC
> +	0b000000	BUF
> +	0b100100	FAULT_S1
> +	0b100101	FAULT_S2
> +EndEnum

DDI0487I.a also has

	0b011110	FAULT_GPC
	0b011111	IMP_DEF

(the former from FEAT_RME).

> +Sysreg	PMBIDR_EL1	3	0	9	10	7
> +Res0	63:12
> +Field	11:8	EA

This looks like it should be described as an enum.

> +Field	3:0	ALIGN

This could potentially also be an enum.

> +Sysreg	PMSCR_EL2	3	4	9	9	0
> +Res0	63:8
> +Field	7:6	PCT

This lookslike it should be an enum.

--VOl7BrjAsP2F3VXr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmNRXEMACgkQJNaLcl1U
h9BxoAf/WoPWB2G/B9tOuYVL94BuR2DecQwcEGhVK7tOMRJ27Vo4dCUdnfTloTZz
Jj0O/V6pHcc1kxMopuhhYRDYTW/kcub+dw2Rdj1T+Nv/OSMB2nISyK26sdYHa61+
Rx7OT3fRDFmaAcJ04jma1wlwlBa3Busy60PGtTbT9CdWrYLUZo3AVeJkb7Mtacgo
/XHM616UHZ8emOWdatKMQkYmTs0X9mNJ48cyOBrItDpbERep49qB8pDlxAfcSaYT
oHICs5H0KJ66c/yRWC02LOFBIJBWmmmce6qLyqcNynxPbW5XSYV6k50wZXaIE0H/
U6qk5ya1kaFNQ4WUN70owOOlw/nQ3g==
=JWVG
-----END PGP SIGNATURE-----

--VOl7BrjAsP2F3VXr--

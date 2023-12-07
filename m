Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 898DA481B9
	for <kvmarm@lists.linux.dev>; Thu,  7 Dec 2023 16:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OOPXxRHN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5111CC433C8;
	Thu,  7 Dec 2023 16:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701968263;
	bh=tJNJ442NYEqUlW1Yb/RcqJnSr8ERST99nShhoBfnL9c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OOPXxRHNNdbbhvStJS+fAomKxUb6p0EN/1p4Tr1iNt2Xt8e+MuqeNVunB6cZtJshh
	 p11UyEeICPXJ7t1+1fyiiWP6ALdv4D0AY1Ov0QoutLBWimow3N9GLPRsv1K9fJwZf+
	 MHe+dbpzUme6nAM5+XIfWUFJEQNOwhE0cvtIMr1KushJqW0lM5vru8p3gbr5Ds0VM4
	 fC8R8sPV/prfu8hhSwUtWyL8lCBTidR9YR3TMVKDBbfbbXxcNh7zLqKRpDKvwhGWb1
	 +O+O6FjF4+Ti0RZ+XecD4TMRIRTZ8jiOMNYQjTenfiWlqhc1IXgamu9YJVsZVKEVME
	 AS5ec06EyCTcA==
Date: Thu, 7 Dec 2023 16:57:37 +0000
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev,
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, eric.auger@redhat.com,
	jingzhangos@google.com, joey.gouly@arm.com,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 01/12] KVM: Add missing HCRX_EL2 field definitions
Message-ID: <7c85421b-5dfd-4931-bb14-aa2416e54b58@sirena.org.uk>
References: <20231206100503.564090-1-tabba@google.com>
 <20231206100503.564090-2-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="8BsBSiQW/015/hO4"
Content-Disposition: inline
In-Reply-To: <20231206100503.564090-2-tabba@google.com>
X-Cookie: No purchase necessary.


--8BsBSiQW/015/hO4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 06, 2023 at 10:04:51AM +0000, Fuad Tabba wrote:
> Add the latest field definitions to HCRX_EL2 from the 2023-09 Arm
> Architecture System Registers xml specification [*].
>=20
> These fields aren't used yet. This is done mainly to get the
> correct generated value for the register's RES0 mask.

> ---
>  arch/arm64/tools/sysreg | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

This isn't a KVM specific patch, this is an arch patch - I'd have
expected a subject line "arm64/sysreg:" or something...

>  Sysreg	HCRX_EL2	3	4	1	2	2
> -Res0	63:23
> +Res0	63:25
> +Field	24	PACMEn
> +Field	23	EnFPM
>  Field	22	GCSEn
>  Field	21	EnIDCP128
>  Field	20	EnSDERR

This is the same as my equivalent patch in the 2023 dpISA series:

   https://lore.kernel.org/linux-arm-kernel/20231205-arm64-2023-dpisa-v3-7-=
dbcbcd867a7f@kernel.org/

Reviewed-by: Mark Brown <broonie@kernel.org>

(that series does make use of EnFPM).  Given the likelyhood of overlaps
like this I really think we should be merging these sysreg updates even
if the serieses that depend on them are still in flight, it doesn't make
sense for multiple people to end up doing the typing.

--8BsBSiQW/015/hO4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmVx+YAACgkQJNaLcl1U
h9BdIgf+MI89mbIT7ZhiIWIh+7vo+t+Gc1ShSs23wKnNcUvEKyH7MU5nEcn6r0S2
YVXGn2TqQ7GU5xp6u3jPOu1BprOMePmaxJxw/vf4fJyk+9k54eZPpsNZuHV01Zkh
9GZDpxmU1EW6DqZonDooc0GmOTH8jQ/+haWF+0CO1p0NexMyC2YS36sFNvPRupBV
vuJRZdSzQYmE5XqtyzznHTU3z6HOQB1o46wK5F/lbxL8zs6nLs62qKVYBLWmoFHt
hZnjMiWmD0OuCAXAzeq9xuTY6ipquLPgvgXEPxUA5HABh5puczoPnsqMK0+xZvvv
qGDHw7YBSKfBIslmUiLR6CBX2xN+FA==
=z///
-----END PGP SIGNATURE-----

--8BsBSiQW/015/hO4--

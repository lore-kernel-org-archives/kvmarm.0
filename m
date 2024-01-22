Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1230148CE9
	for <kvmarm@lists.linux.dev>; Mon, 22 Jan 2024 21:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705958982; cv=none; b=mXJTBvDXDG7jxknivpgipQsNIv5H5ClK3FePl7Q20RuUI2v43fqAbtpXvUmXv7u9AY5r2ieQfdnu/mR7ZZFKOkTFSJHlvHkvArCmr/yfiP3HPGuvw7x83aQuKYlQqaBn3/MLqnEMcsY+xfboz6XGont3eMDad4UOp58Ue2TZ4uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705958982; c=relaxed/simple;
	bh=WFleTVHI15wq54UDGMl0AQCcsbvuKvyQUVYiML8KPV0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qww28EBzc2rD8PGkFhxNa8VyJylWnv4eoUSf51HtVH8O58KpS9REtckB6XyhJS+TfS1Om7x6/ZmryXtH1HMWVnUGdKIHGZlwYjW/bQdJ4bbVQfuOktfuR4bK9wRPE8sccr6SAbqcndykl+epk4XtMeiGwCzvDpjOJ4xRDRejG0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L+eAgXUY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L+eAgXUY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73731C43390;
	Mon, 22 Jan 2024 21:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705958981;
	bh=WFleTVHI15wq54UDGMl0AQCcsbvuKvyQUVYiML8KPV0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=L+eAgXUYpO2fLug6kc/A5TKSyNlbcnTJkhbbxURzXez1GDPybopLkJ6Azo0Sl8UIM
	 WOD4fSLSF18d1pVZkQtQkZR6zOT1kYlrDwgLJNORZV990yQRURK1jmJG9TbaUNCCEi
	 GQpCjnJs6zVDPSftvv75ByOCL4d5bUBWl/p0BQDeMem3RipBkwEd+k3BJKlLmVVjS9
	 fAiQU2S66i0LNtKdLsevwTk6iWdsCFXpa+qGViofdzfqlNLI8RQ26CQyRlGN46dB8K
	 057uqml+PPyLzP9l/BmTQXV2H9ycPHZV3N+NgexU2YdqnL1w0MtEpu6rWqQeusK4/Y
	 3CFqrYgOr0GZQ==
Date: Mon, 22 Jan 2024 21:29:36 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>
Subject: Re: [PATCH 01/25] arm64: sysreg: Add missing ID_AA64ISAR[13]_EL1
 fields and variants
Message-ID: <0146c7fa-f7e6-45e8-8f02-bec677f84397@sirena.org.uk>
References: <20240122201852.262057-1-maz@kernel.org>
 <20240122201852.262057-2-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="hTPQOzYPOX8FaDXg"
Content-Disposition: inline
In-Reply-To: <20240122201852.262057-2-maz@kernel.org>
X-Cookie: Nice guys don't finish nice.


--hTPQOzYPOX8FaDXg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 22, 2024 at 08:18:28PM +0000, Marc Zyngier wrote:

> Despite having the control bits for FEAT_SPECRES and FEAT_PACM,
> the ID registers fields are either incomplete or missing.

In general the registers tend to get updated register by register so
it's not 100% surprising to get partial definition of features, though
more usually it's the ID register that's there.

> Fix it.

Checking against DDI0601 2023-12 the additions here look correct with
the proviso below, I didn't audit for other missing defintions in the
two affected registers (ID_AA64ISAR[13]_EL1).

Reviewed-by: Mark Brown <broonie@kernel.org>

> ---
>  arch/arm64/tools/sysreg | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index fa3fe0856880..53daaaef46cb 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -1366,6 +1366,7 @@ EndEnum
>  UnsignedEnum	43:40	SPECRES
>  	0b0000	NI
>  	0b0001	IMP
> +	0b0010	COSP_RCTX

This is OK in itself but there's also a copy of this in ID_ISAR6_EL1
which needs updating too (and presumably ought to be considered by the
hypervisor, I didn't look at anything else yet).

--hTPQOzYPOX8FaDXg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmWu3j8ACgkQJNaLcl1U
h9BkVAf/UuDuQ513O7Jd0sdc++i6nrlbAsPKy/PuC4O8+u9QSLKocEir/AzOrJj+
cQzFbaujwW8xivWIvWN7g4sivgjoaPQb1LpJ54uoKM7sO0XUSQlkBhzFchzYyt2N
jyC4kt5Kc6mR0eX/ZTXMmE9O4kdrqxBEEuTYlntKYVb09Hu4z5Z15o9x3puspOz6
NNAlHQb0yvjCYjwCx+Q2UvGL+Lbv4sLDR8Owmwbg3rXd9howcOj7J6FJko15C3pc
IGoNZnv/LSz7LhxjtI33GlV4TWK/ZAKWCHN4FdHKpzHt8Zh9TmMcf7VbgQDt2QYz
t4W4In9pSeNZn+UZgBri6s5h9nbkyQ==
=p08F
-----END PGP SIGNATURE-----

--hTPQOzYPOX8FaDXg--

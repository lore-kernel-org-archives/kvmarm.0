Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A838495EC
	for <kvmarm@lists.linux.dev>; Thu,  7 Dec 2023 17:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u3eRBKYV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0931DC433C7;
	Thu,  7 Dec 2023 17:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701970104;
	bh=jkgPZVbGYpUROvGphge7PukRKwsZcxGxGuI1xL4jMrI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=u3eRBKYVZUjqR0ZnfHj7EhL5GbFKxK/jDFukbI5+mW7PudU4e8sTO16fVGlPkAAjc
	 7ytUCwpT6ZNIGpPW560h7970lMT491a6VMK8VnRjSn4cRdLeClv6uPhkHKMVqEhwhG
	 NrdX8QiB8qA0fwlCgiU3B0c31/ijUpeiav/EXIALi14JYEfIRMhMmQeKxZaoFv3VNP
	 xI1iCOxtEAUEh7H9wjSxad2UMzjMo2wcydmKjlPcA4P9ln3Z7KY8SXqStIHBjiRv5D
	 StjIZVX2u2sAorreSsYfsu0mX74fPYThXustTvWrMXN86Wqi2JmwDw21iCFq6RYTSL
	 7PmNa+arcawNA==
Date: Thu, 7 Dec 2023 17:28:18 +0000
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev,
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, eric.auger@redhat.com,
	jingzhangos@google.com, joey.gouly@arm.com,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 05/12] KVM: arm64: Handle HAFGRTR_EL2 trapping in
 nested virt
Message-ID: <006ec2b0-6263-4e86-8641-d81c01a91c8e@sirena.org.uk>
References: <20231206100503.564090-1-tabba@google.com>
 <20231206100503.564090-6-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="AMd9aHGiv/jzGOb9"
Content-Disposition: inline
In-Reply-To: <20231206100503.564090-6-tabba@google.com>
X-Cookie: No purchase necessary.


--AMd9aHGiv/jzGOb9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 06, 2023 at 10:04:55AM +0000, Fuad Tabba wrote:

> Add the encodings to fine grain trapping fields for HAFGRTR_EL2
> and add the associated handling code in nested virt. Based on
> the 2023-09 Arm Architecture System Registers xml
> specification [*]. Add the missing field definitions as well,
> both to generate the correct RES0 mask and to be able to toggle
> their FGT bits.

> Also add the code for handling FGT trapping, reading of the
> register, to nested virt.

> [*] https://developer.arm.com/downloads/-/exploration-tools

DDI0601.

> +Sysreg HAFGRTR_EL2	3	4	3	1	6
> +Res0	63:50
> +Field	49	AMEVTYPER115_EL0
> +Field	48	AMEVCNTR115_EL0
> +Field	47	AMEVTYPER114_EL0
> +Field	46	AMEVCNTR114_EL0
> +Field	45	AMEVTYPER113_EL0
> +Field	44	AMEVCNTR113_EL0
> +Field	43	AMEVTYPER112_EL0
> +Field	42	AMEVCNTR112_EL0
> +Field	41	AMEVTYPER111_EL0
> +Field	40	AMEVCNTR111_EL0
> +Field	39	AMEVTYPER110_EL0
> +Field	38	AMEVCNTR110_EL0
> +Field	37	AMEVTYPER19_EL0
> +Field	36	AMEVCNTR19_EL0
> +Field	35	AMEVTYPER18_EL0
> +Field	34	AMEVCNTR18_EL0
> +Field	33	AMEVTYPER17_EL0
> +Field	32	AMEVCNTR17_EL0
> +Field	31	AMEVTYPER16_EL0
> +Field	30	AMEVCNTR16_EL0
> +Field	29	AMEVTYPER15_EL0
> +Field	28	AMEVCNTR15_EL0
> +Field	27	AMEVTYPER14_EL0
> +Field	26	AMEVCNTR14_EL0
> +Field	25	AMEVTYPER13_EL0
> +Field	24	AMEVCNTR13_EL0
> +Field	23	AMEVTYPER12_EL0
> +Field	22	AMEVCNTR12_EL0
> +Field	21	AMEVTYPER11_EL0
> +Field	20	AMEVCNTR11_EL0
> +Field	19	AMEVTYPER10_EL0
> +Field	18	AMEVCNTR10_EL0
> +Field	17	AMCNTEN1
> +Res0	16:5
> +Field	4	AMEVCNTR03_EL0
> +Field	3	AMEVCNTR02_EL0
> +Field	2	AMEVCNTR01_EL0
> +Field	1	AMEVCNTR00_EL0
> +Field	0	AMCNTEN0
> +EndSysreg
> +

Oh, we actually have the register fully encoded since we needed the
fields.  Given this why did we need the manual encoding in the previous
patch?  In any case this looks good according to DDI0601 2023-09:

Reviewed-by: Mark Brown <broonie@kernel.org>

--AMd9aHGiv/jzGOb9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmVyALIACgkQJNaLcl1U
h9ADPAf9FeuqXUliARdZHy1V31rfSH9oIfYDVBtlx/XTcrcdKsHKFm35SRy/2nDW
3Ct6VBgVyzziVWfROvP67bsOtpHsVPVKLKRVs3wXn/+do8eSFe03XWyqjAT0fTxF
UZVwrkFyihnj4rqXEvITcWBz5nS62PMwMaUVU9MSps2Btr05kiHYrs6GZpByq08o
mfk7Zuj6n0rFqkOBpZ0Bl4g41I+HI6GlQJEorch8cqs31XPnzpzLTP/GYyydqG4U
77PrRdMj6TGyyMYuuEP3xKTh9BEgR76yNYXqCl/VL+9uGCEDrQTJYmysKwtxwAMt
zz6AW2hZBDhq3h3oJfI44f0bzlvASg==
=cuKo
-----END PGP SIGNATURE-----

--AMd9aHGiv/jzGOb9--

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6815630EF86;
	Mon,  7 Sep 2026 10:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788776087; cv=none; b=XoDMO22XyfizebwlAdFN1t5PlotRE+TvJmGFBiZz31YhwpB25tbLvzgen3ugkNFLx4xJeLjNfOUjKgvueEi8GVyXnC/BXxSFKY3twbfSPUavE0FPQZW2BVd8stv0RbshCbihXoNxCDvsUQW/rL8ZRreX/mTdbwNyEkSVszsHztM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788776087; c=relaxed/simple;
	bh=alPNpabbOnB37h6nC1cs6jjEMFraQwNKa430EfuN7Wc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ofYuGM4cVxOjB8zkwMCzM3H8WSXjTrsFrrvpoEnc6oUxwGnjoeJ02qoB7nXNAfFEEyA5BeoykmO2Oq7FKCWIktGlOONrcfAjNJeRxtmGGm+68jvBw+jNAsHFoql6OqSoUQTJJKJK26y/os+Ryop8pCI3lMjjsHngO7mn6JW1Io4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L7sAG9GI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L7sAG9GI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA321F00A3A;
	Mon,  7 Sep 2026 10:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788776086;
	bh=HMZ7+XOUJoEg4tdieoBk9owPXOkII+E58FEh5Zuv0Ws=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=L7sAG9GInez+FbdPrTp3Js+lWe7BxeVwgnKnv/WjbUaCYbsWmGFOXMXhURa90D7hQ
	 ZvnkCAUtqr+UcgMqjfjQu444xKCeR6IeiDHbVSWObxcoB/Kd2oGcnuKn+Guzw5/gSu
	 QZxckv1vMf5EZP3AYrd6soBDSLFogQaMh+8l7O6zXxcdjqdoAs9T+SQd5mIZpjbVec
	 cRQ/oSXp7bcpdEqHGOJtBiic6ZrkoIa1rD2E3UGlbxpFPFPWx8PdE3JIDhigmRXZ7B
	 pxrrKZ/ooGE0lFQyM6GFPt/ye5Zr5sRYwCFF2JqDkvZJT9K3NztO7xxtR4nXSBCz9n
	 L1Ejw9yzfDDpA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v17 3/7] firmware: arm_rmm: Configure the RMM with the
 host's page size
Reply-To: sashiko-reviews@lists.linux.dev
To: "Suzuki K Poulose" <suzuki.poulose@arm.com>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260907095942.1140734-4-suzuki.poulose@arm.com>
References: <20260907095942.1140734-1-suzuki.poulose@arm.com>
 <20260907095942.1140734-4-suzuki.poulose@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 10:14:45 +0000
Message-Id: <20260907101446.1DA321F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] The SMC call leaves parameters X2-X7 uninitialized, violating the =
RMM's RES0 requirement.
- [High] The `struct rmm_config` fields are populated using native endianne=
ss, which breaks on Big Endian kernels.
--

commit 1741e17729c2ff5e23bc8bfb00cc50a61f38ebb7
Author: Steven Price <steven.price@arm.com>
firmware: arm_rmm: Configure the RMM with the host's page size

This commit adds support to configure the RMM's granule size to match the
host's page size during kernel initialization. It reads the feature
registers to ensure the requested page size is supported and sends the
configuration to the RMM via an SMC call.

> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rm=
i.c
> index 008a783407b4e..76f91c145e1fd 100644
> --- a/drivers/firmware/arm_rmm/rmi.c
> +++ b/drivers/firmware/arm_rmm/rmi.c
> @@ -77,6 +77,60 @@ static int rmi_read_features(void)
>  	return 0;
>  }
> =20
> +static int rmi_configure(void)
> +{
> +	unsigned long granule_feature;
> +	unsigned long granule_size;
> +	int ret =3D 0;
> +	struct rmm_config *config;
> +
> +	switch (PAGE_SIZE) {
[ ... ]
> +
> +	config =3D (struct rmm_config *)get_zeroed_page(GFP_KERNEL);
> +	if (!config)
> +		return -ENOMEM;
> +
> +	config->rmi_granule_size =3D granule_size;
> +
> +	/*
> +	 * For now we set the tracking_region_size to 0 which is the only option
> +	 * for 4KB PAGE_SIZE (1GB for 4KB PAGE_SIZE, 32MB/512MB for 16KB/64KB).
> +	 * TODO: Support other tracking sizes via Kconfig option for other
> +	 * PAGE_SIZES
> +	 */
> +	config->tracking_region_size =3D 0;

[Severity: High]
Does this code handle endianness correctly?

The struct rmm_config fields are populated using native u64 assignments.
On an ARM64 kernel compiled with CONFIG_CPU_BIG_ENDIAN=3Dy, this writes
big-endian bytes into the shared memory. The RMM, which runs in little-endi=
an
at EL2, will misinterpret these fields.

Will this cause the RMM firmware to read invalid configuration values (like=
 a
byte-swapped granule size) and fail to configure, breaking RMI support on B=
ig
Endian systems?

> +
> +	ret =3D rmi_rmm_config_set(virt_to_phys(config));
> +	if (ret) {
> +		pr_err("RMM config set failed\n");
> +		ret =3D -EINVAL;
> +	}
> +
> +	free_page((unsigned long)config);
> +	return ret;
> +}
[ ... ]
> diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi-cmds.h
> index 2fb1f7f86d71e..9aa27697e2377 100644
> --- a/include/linux/arm-rmi-cmds.h
> +++ b/include/linux/arm-rmi-cmds.h
> @@ -12,6 +12,23 @@
> =20
>  unsigned long rmi_feat_reg(unsigned long id);
> =20
> +/**
> + * rmi_rmm_config_set() - Configure the RMM
> + * @cfg_ptr: PA of a struct rmm_config
> + *
> + * Sets configuration options on the RMM.
> + *
> + * Return: RMI return code
> + */
> +static inline int rmi_rmm_config_set(unsigned long cfg_ptr)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_RMM_CONFIG_SET, cfg_ptr, &res);

[Severity: High]
Does this SMC call leave parameters x2 through x7 uninitialized?

The arm_smccc_1_1_invoke macro only generates inline assembly constraints
for the explicitly provided arguments. It does not zero-pad omitted argumen=
ts,
leaving registers x2 through x7 with whatever was previously in them.

Since the RMM firmware expects unused SMC parameters to be zero (RES0),
could passing uninitialized values cause the RMM to reject the command
with an INVALID_PARAMETER error and sporadically break RMM initialization?

> +
> +	return res.a0;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907095942.1140=
734-1-suzuki.poulose@arm.com?part=3D3

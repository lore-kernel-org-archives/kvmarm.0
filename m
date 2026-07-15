Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA476480971;
	Wed, 15 Jul 2026 15:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784128732; cv=none; b=NaC+mMGsDMKyvHSkp3C6ie9wJKtFl3jA1ZVEyDiG23CRpW7VopEvfP8TrQ7nKHKpi5ifKDshr5e2zxwxAijzBeZ6AGFFRGhpTgchD1xw7EszlvYG2ffpT2nJ5cc5pHLtKVG3syCnXAZaW/SRE0xiUAe6S8S7XGfQwibysjNk5VI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784128732; c=relaxed/simple;
	bh=7hf5JVDwb+6R367XfuWZtA/gXynUN3Xdrrw4KMRxIQ8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=qgAbEBT9mU28/dhpCfJUvYCfRe2qKE7d+ycRZaODf8MWwqQFSOhEmJ96RWn9nZXjmrpTf40bh18NbkOZhF4cmOlwvbCGoCLgAnjLYK/ixbEJAuFlxaYK5abfOZDR93v40rITIyO6nE4/Cp2LYmOyalDOTy84NpNDmLgWe8TkcGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GZaZJUr6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GZaZJUr6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CFC11F00A3D;
	Wed, 15 Jul 2026 15:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784128729;
	bh=VKifGp3mPQX2/U48u5MKY8fdmpIO/6UZ7MVCWzIkzGU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GZaZJUr6QhVgXHdIC49D9S2DBSKIZKW/iEhhLqevdyCDFmid35uwns/pcQBLswRZL
	 TONqZnv+uTtykLsI+TWwG/awotD7oRYZ/DfZ+9qx4e9nc09L9BatjZ+tHrHgaC/GAU
	 X4mu+CPl36rxcf33AluPsCAMZTEAvh80jVszKRiCcIzEQn3ZhC4XwNSxyLx0rEsWUF
	 /tdA/SNsmTK4LQwzoMc3tuvH+VZkCzOe14WQe0CZUj/eGhJdErNdgiK0l4VgHil+s5
	 k3zfR6azI8yXcYGkpKFABr1kiAslhQ0mKCtZ8Ouf0kvSlgRoLc6mSFtjChi89yffU/
	 mqMqgGulwP+1g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/6] firmware: arm_rmm: Configure the RMM with the
 host's page size
Reply-To: sashiko-reviews@lists.linux.dev
To: "Steven Price" <steven.price@arm.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260715142739.80398-5-steven.price@arm.com>
References: <20260715142739.80398-1-steven.price@arm.com>
 <20260715142739.80398-5-steven.price@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 15 Jul 2026 15:18:49 +0000
Message-Id: <20260715151849.4CFC11F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Missing validation of RMM granule size against cached feature re=
gisters.
--

--- Patch [4]: [PATCH 4/6] firmware: arm_rmm: Configure the RMM with the ho=
st's page size ---
commit db91734b5b3e860f7a56847c4c9ab7f969eaf312
Author: Steven Price <steven.price@arm.com>

firmware: arm_rmm: Configure the RMM with the host's page size

This commit introduces a function to configure the RMM's granule size to ma=
tch
the host's page size. It allocates a configuration page, populates the
rmi_granule_size according to PAGE_SIZE, and calls rmi_rmm_config_set() to
apply the settings.

> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rm=
i.c
> index c4850976544ff..e7ab4a7df3ca8 100644
> --- a/drivers/firmware/arm_rmm/rmi.c
> +++ b/drivers/firmware/arm_rmm/rmi.c
[ ... ]
> @@ -76,6 +76,45 @@ static int rmi_read_features(void)
>  	return 0;
>  }
> =20
> +static int rmi_configure(void)
> +{
> +	unsigned long ret;
> +	struct rmm_config *config __free(free_page) =3D (struct rmm_config *)ge=
t_zeroed_page(GFP_KERNEL);
> +
> +	if (!config)
> +		return -ENOMEM;
> +
> +	switch (PAGE_SIZE) {

[Severity: Medium]
The commit message states "Check the feature registers and configure the
RMM so that it matches the host's page size."

Does rmi_configure() actually verify the host's PAGE_SIZE against the
cached RMM feature registers before proceeding?

It appears to unconditionally assign the configuration based on PAGE_SIZE.
If the RMM does not support the host's page size, the driver will blindly
send an unsupported configuration to the RMM firmware.

Should there be a validation check here using the features read in
rmi_read_features() before configuring the granule size?

> +	case SZ_4K:
> +		config->rmi_granule_size =3D RMI_GRANULE_SIZE_4KB;
> +		break;
> +	case SZ_16K:
> +		config->rmi_granule_size =3D RMI_GRANULE_SIZE_16KB;
> +		break;
> +	case SZ_64K:
> +		config->rmi_granule_size =3D RMI_GRANULE_SIZE_64KB;
> +		break;
> +	default:
> +		BUILD_BUG();
> +	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260715142739.8039=
8-1-steven.price@arm.com?part=3D4

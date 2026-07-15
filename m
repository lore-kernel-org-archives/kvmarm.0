Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC1C48AE0B;
	Wed, 15 Jul 2026 15:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784130461; cv=none; b=FvdjLr+qQYUbMv4gXxOw2h5rhvaUOyQsq1HjUDcmNGvp5Ij3z9AJkPJPgGxA0lnIUonz8cUmF2BXQjCXkK/pF5DbXKNM20KVKNFPUAEcj8D26JEcSHXkhGJwkt+LPSSXWPBVOxR7U201gwk4eelZaWdbeiH7KWE1ZltUtIsWK1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784130461; c=relaxed/simple;
	bh=4P83OzG3AyQgRZU7OEZMrIZ7uohx98oJsLXoORIfqPc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=YVhnjvAoX3I78pHonM4Dt/HBj+mT6nJexbl88Jm9ruJxArro+waGZ/Qzj6XXDaXtsiOAZajFOx3ywhM7hXTtGPYKsHblp4lSdAOKxmFy+9UKqRFXl2bKg2+b/BeG57LpDMTXV5q8/bQbrP7SiTXlEuh25Tf0zZz6hEgVuw5TcRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CMXNappe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CMXNappe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5339F1F000E9;
	Wed, 15 Jul 2026 15:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784130458;
	bh=00ED2YjjgsCNjh6jxMBovgAPsH8/TGckwVI8Yw64tko=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CMXNappesV0A2eA6lqAL363rkMFBQVUXiHRyqYxVflY/wusuQ0PqnjBbrkn6S7U0w
	 iWzgvCrbbR9CRHngxIIWpaWt+EESDGkgqWpkj0D3HxmOxyNpW6BVmyIMc7EO+Pa5Fs
	 xMqlI2t/B0qYM88tLGLNot/Ts4nFDO+dKeGG1FdziJ43pM9g0mEqVZ2A9QimIAzKvr
	 ica/pac+IuoLNbenH4YNJEsqOZrQ6afo/brbiqXlUOJrTNury3rloUFNrgAl3SdLUd
	 CSca0cxJaNmYPnsGnr5uFNWTwKWpDBmf25OhBua+19cC0QFpufeVMehj23V1IaOQT3
	 /SXz/j5l+Yrzg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6/6] firmware: arm_rmm: Ensure the RMM has GPT entries
 for memory
Reply-To: sashiko-reviews@lists.linux.dev
To: "Steven Price" <steven.price@arm.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260715142739.80398-7-steven.price@arm.com>
References: <20260715142739.80398-1-steven.price@arm.com>
 <20260715142739.80398-7-steven.price@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 15 Jul 2026 15:47:37 +0000
Message-Id: <20260715154738.5339F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Medium] Host-side memory allocation failures are incorrectly parsed as R=
MI firmware errors.
- [Low] Empty or sub-page memblock regions are expanded into 1GB GPT alloca=
tions.
- [Low] Missing trailing newline in success message.
--

--- Patch [6]: [PATCH 6/6] firmware: arm_rmm: Ensure the RMM has GPT entrie=
s for memory ---
commit dfe33cca468028175b080bbcfc671eba1604716c
Author: Steven Price <steven.price@arm.com>

firmware: arm_rmm: Ensure the RMM has GPT entries for memory
   =20
This commit configures RMM memory tracking to ensure DRAM regions are=20
tracked at FINE granularity. It statically allocates tracking granules and=
=20
creates Level 1 GPT tables for these regions when needed.

> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rm=
i.c
> index 6a9f61760fd77..d0c083bdf251f 100644
> --- a/drivers/firmware/arm_rmm/rmi.c
> +++ b/drivers/firmware/arm_rmm/rmi.c

[ ... ]

> @@ -604,6 +606,89 @@ static int rmi_configure(void)
>  	return 0;
>  }
> =20
> +/*
> + * Make sure the area is tracked by RMM at FINE granularity.
> + * We do not support changing the tracking yet.
> + */

[ ... ]

> +static int rmi_create_gpts(phys_addr_t start, phys_addr_t end)
> +{
> +	struct rmi_sro_state *sro;
> +	unsigned long l0gpt_sz;
> +
> +	sro =3D kmalloc_obj(*sro, GFP_KERNEL);
> +	if (!sro)
> +		return -ENOMEM;
> +
> +	l0gpt_sz =3D 1UL << (30 + FIELD_GET(RMI_FEATURE_REGISTER_1_L0GPTSZ,
> +					  rmi_feat_reg(1)));
> +	start =3D ALIGN_DOWN(start, l0gpt_sz);
> +	end =3D ALIGN(end, l0gpt_sz);

[Severity: Low]
If a memblock region is smaller than a page or misaligned, is it possible
for the initial start physical address to be greater than or equal to end?

If so, applying ALIGN_DOWN() to start and ALIGN() to end could force=20
start < end to evaluate to true for an originally empty region. Could this
cause the loop to inadvertently execute and allocate an L1 GPT table for a
1GB block that contains no full pages?

> +
> +	while (start < end) {
> +		int ret =3D rmi_gpt_l1_create(start, sro, GFP_KERNEL);
> +
> +		/*
> +		 * Make sure the L1 GPT tables are created for the region.
> +		 * RMI_ERROR_GPT indicates the L1 table already exists.
> +		 */
> +		if (ret !=3D RMI_SUCCESS && RMI_RETURN_STATUS(ret) !=3D RMI_ERROR_GPT)=
 {

[Severity: Medium]
Since rmi_gpt_l1_create() can return a standard negative POSIX error code
like -ENOMEM from a host page allocation failure, does passing it to
RMI_RETURN_STATUS(ret) misinterpret the error?

For -ENOMEM (-12), the macro extracts the lower bits (244), which won't
match RMI_ERROR_GPT. Could this result in printing a misleading "GPT Level1
table missing" error when the real issue is an out-of-memory condition in
the host kernel?

> +			pr_err("GPT Level1 table missing for %llx\n", start);
> +			kfree(sro);
> +			return -ENOMEM;
> +		}
> +		start +=3D l0gpt_sz;
> +	}
> +
> +	kfree(sro);
> +	return 0;
> +}

[ ... ]

> @@ -621,6 +706,13 @@ static int __init arm64_init_rmi(void)
>  	if (ret)
>  		return ret;
> =20
> +	ret =3D rmi_init_metadata();
> +	if (ret)
> +		return ret;
> +
> +	arm64_rmi_is_available =3D true;
> +	pr_info("RMI configured");

[Severity: Low]
This isn't a bug, but should this include a trailing newline ("\n") to=20
prevent subsequent kernel logs from being appended to the same line?

> +
>  	return 0;
>  }
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260715142739.8039=
8-1-steven.price@arm.com?part=3D6

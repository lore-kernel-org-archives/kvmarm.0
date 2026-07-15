Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A3D42BC58;
	Wed, 15 Jul 2026 15:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784128017; cv=none; b=jNriJo1O/LfSOwwzthpGHsWcHmizie2lCsPB4IWw0k8QgUbI9vHMhVxrQ1HQwhpttErq21VAajghmDNbBBn+UxK9H/0YFcMriEfdgZ7mO92Q5GKpXFC2HAa45OWpfR9J1PPM8twOLcKzq7hBtzlA5zsTPceglaZk8Q0J+bw1pnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784128017; c=relaxed/simple;
	bh=TUZGVsbgQlqpPNw19QmZ4TpzXd38zHRHXwauyCE/oz4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=WIbLa7ZqI+JWKvr6SJRdh+7Bz0P5prOLI8/QWJ7tcoyHiBKpNTKHnE+Tvh7zYccqeoRlGpUt8n48/Vskvjd4mrosZ5VMUo4CG29a/ygHUcrhQ+AfNNahZOhw7g6SSaqkr8S2MVt01sUMzaqtBeXMjCRGJ9pQghagpMs760bZp28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MQwrA61Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MQwrA61Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D0A61F00A3A;
	Wed, 15 Jul 2026 15:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784128016;
	bh=8gNRNQSW6vsktM1lbk7lGhKHurw9QaFYDhPaWxlP0Cc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MQwrA61Ykf0ssG5unhBw8veYKROdA1mQdlXY+yx9U6WOajRyL7xTsVfub5kEaP+eW
	 /eals2r8UCuZjDKMGKKgfdyF3NuXFCpGofNIi4ZqzP4cXiBj8sMxnmZVBevTKBUYOJ
	 J7rJwEnFCsxPP2RvfW3rSaNQRK+NN6BcDpmAvexlldJIXcoaSJfVyvXBpJduZ6YPlG
	 9NJspzKdHkoeiUwFQK+6rztLz8C+nd5zi6KUjyO4yCj35H4uATihIZrvNinHokfO4R
	 QkSNurk+G36Ec30P7HrIhb4qH4WnDZfTKwD0CRHM+G8od7DThAbXRw/+wULqlhIwpI
	 zhgfZXrc5kS3A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/6] firmware: arm_rmm: Check for RMI support at init
Reply-To: sashiko-reviews@lists.linux.dev
To: "Steven Price" <steven.price@arm.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260715142739.80398-4-steven.price@arm.com>
References: <20260715142739.80398-1-steven.price@arm.com>
 <20260715142739.80398-4-steven.price@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 15 Jul 2026 15:06:55 +0000
Message-Id: <20260715150656.4D0A61F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] The function `is_rmi_available()` is declared in the header but its=
 implementation is missing.
--

--- Patch [3]: [PATCH 3/6] firmware: arm_rmm: Check for RMI support at init=
 ---
commit 422535e6880c00ddffdc5f970e459e2cf571e957
Author: Steven Price <steven.price@arm.com>

firmware: arm_rmm: Check for RMI support at init

Query the RMI version number and check if it is a compatible version.
The first two feature registers are read and exposed for future code to
use.

> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rm=
i.c
> new file mode 100644
> index 0000000000000..c4850976544ff
> --- /dev/null
> +++ b/drivers/firmware/arm_rmm/rmi.c

[ ... ]

> +static int __init arm64_init_rmi(void)
> +{
> +	int ret;
> +
> +	/* Continue without realm support if we can't agree on a version */
> +	ret =3D rmi_check_version();
> +	if (ret)
> +		return ret;
> +
> +	ret =3D rmi_read_features();
> +	if (ret)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +/*
> + * Note arm64_init_rmi() must be called before kvm_init_rmi() otherwise =
KVM
> + * will not support realm guests. subsys_initcall() is called before
> + * module_init() (used for KVM) so this is OK.
> + */
> +subsys_initcall(arm64_init_rmi);

[Severity: Low]
Is the implementation of is_rmi_available() missing here?

It is declared for external callers in include/linux/arm-rmi-cmds.h:

bool is_rmi_available(void);

However, the corresponding definition appears to be missing from
drivers/firmware/arm_rmm/rmi.c, which could lead to link-time undefined
reference errors when another subsystem attempts to use it.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260715142739.8039=
8-1-steven.price@arm.com?part=3D3

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B56456DF3;
	Mon,  7 Sep 2026 10:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788776262; cv=none; b=gf7vqNu3CwCLSoxDfgk6vDbZjHO82306JdLUq0ozFboiXIYE3QNzKEZwXaDL8JCcRvQvHr4kgMhnq3woyRW5loZFj+FE6PwrMSUOHHHtDkLPzzwPrcHFnV6vr/b1uEeS3d8vCRrMMO2biD6HD+/pT/X6FN1YWq1u5jDago5SKRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788776262; c=relaxed/simple;
	bh=42Rg7ViOfbYf+s905e2DzYbCDf3NmZg9ibc3fFkQGMo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JB+ll9ckvP+nR1KI5/8mww/9BW6Hu7KXsl7H0Yk1vfflLOQHSBdMH31TgjGYJoYe8UEetxUGNbuIKKNlDLRKYX4LmyoHb3MW3Q9AuYrV7+C4G/bd04dhsndeH8sEJLCAtN4kHqh2+UhN25JdamVjCxko83y5PObo2YblV7kNKqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=chANldWt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="chANldWt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 856E11F00A3A;
	Mon,  7 Sep 2026 10:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788776257;
	bh=1eDmgaL64aZNhjgY+oa0RV5ZbWl3LEZCRwly5ZERuYc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=chANldWtFUeraLfDSNgsqkUytU7uChUYpUWyKYA078IQkOLWzdkTUUA/b4r1Y6Ax4
	 7x/CEm+YidDXkVdD6+3Ko2txpO5/q5jDaky+AgMuTz+7UzU12BX2m0czvBbj+UhHYp
	 1PD+Tf2DWsCv48AxFhA+9KLPtoWCSzR9SPVWQ4lwYip2qqv2l7GrEkD+18x5lPjKHU
	 CjhdgtrLGQTGcZ8f5CKQXpsZSBaqIQwQ2gF6eX3+fKLb/ClF61rQ72q7hGMkpGUl7m
	 pYQjtIQVRXSBGBeSqXbEAYWgXZFQrwz3FgIrCHJSRNO5m6tasAXHsaDQ6FnkMQCS9d
	 BpmuoHJvoK+6g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v17 5/7] firmware: arm_rmm: Activate the RMM
Reply-To: sashiko-reviews@lists.linux.dev
To: "Suzuki K Poulose" <suzuki.poulose@arm.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260907095942.1140734-6-suzuki.poulose@arm.com>
References: <20260907095942.1140734-1-suzuki.poulose@arm.com>
 <20260907095942.1140734-6-suzuki.poulose@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 10:17:37 +0000
Message-Id: <20260907101737.856E11F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The macro `rmi_sro_memxfer_cmd` uses a large compound literal to=
 initialize the SRO state, forcing the compiler to allocate a ~2.2KB tempor=
ary object on the stack.
--

commit c773f8f03d602782404ec2f0103977a8f86f3b3e
Author: Steven Price <steven.price@arm.com>

firmware: arm_rmm: Activate the RMM

Activate the RMM after the basic configuration. This is a memory transferri=
ng,
stateful operation.

> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rm=
i.c
> index 42c973c3a98bb..d969c8738efde 100644
> --- a/drivers/firmware/arm_rmm/rmi.c
> +++ b/drivers/firmware/arm_rmm/rmi.c
[ ... ]
> @@ -656,7 +657,19 @@ static int __init arm64_init_rmi(void)
>  	if (ret)
>  		return ret;
> =20
> -	return 0;
> +	/* Activate the RMM */
> +	sro =3D kmalloc_obj(*sro);
> +	if (!sro)
> +		return -ENOMEM;
> +
> +	ret =3D rmi_rmm_activate(sro);

[Severity: Medium]
Does expanding rmi_rmm_activate() here cause stack frame bloat in
arm64_init_rmi()?

Looking at include/linux/arm-rmi-cmds.h, rmi_rmm_activate() calls the
rmi_sro_memxfer_cmd() macro, which evaluates a large compound literal:

*__sro =3D (struct rmi_sro_state){ .regs =3D {__VA_ARGS__} };

This forces the compiler to allocate a ~2.2KB temporary object on the stack
before copying it to the heap object, which defeats the purpose of the
explicit heap allocation above. Does this risk exceeding the typical
CONFIG_FRAME_WARN threshold of 2048 bytes on arm64 and lead to build
warnings?

> +	if (ret) {
> +		pr_err("RMM activate failed\n");
> +		ret =3D ret < 0 ? ret : -ENXIO;
> +	}
> +
> +	kfree(sro);
> +	return ret;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907095942.1140=
734-1-suzuki.poulose@arm.com?part=3D5

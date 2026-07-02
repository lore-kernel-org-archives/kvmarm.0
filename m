Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1293432572F;
	Thu,  2 Jul 2026 16:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009169; cv=none; b=NTLLzKiG0i9oOBCNIljKWYLd/QI2gma7MAmVKFlpyZtCNiTKr31yZmbzPWglwxN1LRp6KEtWF/XwdpJSc8O65D5a0jGbK9fOfCYtYTA+iLIlwi5rI0uIiUeL0qF1Q0Fet2GC3GRTYL1HzqevsL2Fc/dO1yLm9MHqYwRVvLajs88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009169; c=relaxed/simple;
	bh=/euvIhvriR7yzUi662FQHtfgzCK17loisrtjnv3fWRY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=TVTPbha40gsATKFnlA3NReHYuWbVtt4urJ/Lw8vfTPmtomaPTHOVwmsdWzmf+i/NImkvV4PudW30dSB1mrHX3oSpj9bo/VLAhnAmuNH4c54yp4Qu5UCZuH4ao34t8ligSaedAmiVT2VZ9xq7BEKi0SHNGk+QeT7mF9jSVlI3XK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MJi/Uwpy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MJi/Uwpy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C9F1F000E9;
	Thu,  2 Jul 2026 16:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783009168;
	bh=DCZz739UG0Ur/22yIUW0Dl+ZwueAnO0GnuYk5v2XS/g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MJi/UwpyJV5I6fbUyauOe4rx+Czbx0w0ecWzfJKhLBXGxvVJ4SCzKz8QVisc1lofx
	 vE8+sVv0Hx1jsslOfliQRLz+P5BJ0JetYoFbBOdLWSOtd9DnmDcb7WMTbzT4ZHW99u
	 xfOwpnQql/NT5sNqu+yJ28stigX7n/jLk/Jf8kC+jjuyw0EpRiNBKoHnoawAydHth8
	 h9Y9cZByOmjphJ6MZpaY08yVr8cC5xqsUvsk4CipTl+yqQ5kv9PWlJ1IVlr6hJYfVt
	 AwyGJyd0rR6teLIdp35JH23Z95qYz6lz/DP6pB8/cUdr0mwTdIUAYL06Xxk/f8vLiC
	 e7zMYBZed0GLQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 01/28] arm64: sysreg: Emit RESx/UNKN values for Mapping
 definitions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260702160248.1377250-2-maz@kernel.org>
References: <20260702160248.1377250-1-maz@kernel.org>
 <20260702160248.1377250-2-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 02 Jul 2026 16:19:27 +0000
Message-Id: <20260702161927.B3C9F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Invalid `_RESx` macros generated for `Mapping` aliases when the tar=
get uses `Fields`.
--

commit ba830a7cd4d5bdb5ba927754ed4d1c4e3a0b4f1c
Author: Marc Zyngier <maz@kernel.org>

arm64: sysreg: Emit RESx/UNKN values for Mapping definitions

The sysreg script uses the Mapping qualifier to indicate an encoding is a
mapping to a particular register, but macro generation for RESx classes was
previously skipped. This patch relaxes that rule to emit RESx and UNKN
values for Mapping qualifiers.

> diff --git a/arch/arm64/tools/gen-sysreg.awk b/arch/arm64/tools/gen-sysre=
g.awk
> index 86860ab672dc7..d7f7ceb768fe5 100755
> --- a/arch/arm64/tools/gen-sysreg.awk
> +++ b/arch/arm64/tools/gen-sysreg.awk

[ ... ]

> @@ -239,9 +239,15 @@ $1 =3D=3D "EndSysreg" && block_current() =3D=3D "Sys=
reg" {
>  	print ""
> =20
>  	next_bit =3D -1
> -	res0 =3D null
> -	res1 =3D null
> -	unkn =3D null
> +	if ($1 =3D=3D "Mapping") {
> +		res0 =3D $2 "_RES0"
> +		res1 =3D $2 "_RES1"
> +		unkn =3D $2 "_UNKN"

[Severity: Low]
Does this logic generate invalid macros if the target register uses the
"Fields" directive?

If the target register itself delegates its fields using the "Fields"
directive (e.g., ZCR_EL1 using "Fields ZCR_ELx"), the script explicitly
suppresses generation of the target register's _RESx macros (setting them to
null).

As a result, would newly emitted alias macros (such as ZCR_EL12_RES0)
reference undeclared identifiers (like ZCR_EL1_RES0)? Could this cause
build failures if these mapping macros are later consumed by C code?

> +	} else {
> +		res0 =3D null
> +		res1 =3D null
> +		unkn =3D null
> +	}
> =20
>  	next
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260702160248.1377=
250-1-maz@kernel.org?part=3D1

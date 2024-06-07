Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com [209.85.222.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFC91B64E
	for <kvmarm@lists.linux.dev>; Fri,  7 Jun 2024 07:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717745647; cv=none; b=g0YXSJ1FkTYZhxbpHYezYBY3ZOr2v7lxMKC9VWZnaQ40Eer55HDHY4G/AvHC9aJR7x738vzP9BP45Cau6M5URf6WsSKhMe9YerD3GXI9Ahl0Lm0csGEf5dY5kTxtMcEVlc7kgIS8F49fCjzu4RyDyBNfKiOPBqQE/6oJ893IJpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717745647; c=relaxed/simple;
	bh=vYYXsEBTb0bzmGXVrvmnqmApDuO+F9CPi3HsvreDUD0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QEJtgAQxN25RMLCRlKoNEFpxisAqWyU3CeS+NRlOcVN0O12PFbmyeEzXzJ4w2/Q/vRdPugjGvYlJQZYoI60/MSCh29Rnr6mdqJ2Jg7O+DOITPhfe2qSn1qqFO5Oc+z0RDUxRjd9Bak94MCHZXDRVGF5Nk8ymnpwFr7pJzeWj8r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P1sWu3yI; arc=none smtp.client-ip=209.85.222.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P1sWu3yI"
Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-80b13c93a0eso924906241.0
        for <kvmarm@lists.linux.dev>; Fri, 07 Jun 2024 00:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717745645; x=1718350445; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TyL/tEXv9q+vrjmq0MkI7TdwwhxQ4pIHED6hCiXm55I=;
        b=P1sWu3yI31DPt892RRi6E7n77PSuJtPNDriMRJixgaBVNL1YMoZD3m8WF1kiAAUC/3
         K9jgh/rsBD+/n5Fvecg9gxSTL+QJJcmVnErUt3e1UTEhWmIg/Bf29VJhdKLJHPS03JVS
         +C4vWeVofrD3ewIbfAZPuVjxEdbPdtgkXwL44REPM9wgafwU3n4itpdGLGfz1JcANlVt
         fNN/VexUIC7CHs1OR6RQKeG3p70XNJcoFRr+PS1CNvXPQmmS7YBRf67SyuG5QGhOvgE7
         kBm1ZlZgcB7PV2MXWudqvKWxUhVY/RlWrfs9R4MoD6irYPJgE++GZ475UBLP3hjj1wL8
         RDaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717745645; x=1718350445;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TyL/tEXv9q+vrjmq0MkI7TdwwhxQ4pIHED6hCiXm55I=;
        b=bl8AIjR3ItVAUBCS/86FePajIr/xUeccrchvTHPhKJeZt7OsDC+cl45tEiqSL79WfK
         YPWwiecvuUuhqR6o7kIl8Ou5KZ/STKA4Jw19Don/Ksn8llg7K0Xg5BwadFR3ALVeI5OY
         Ux5C/iY1lKdPTUhOfNJmMEcsdPWVe2t76LYqOakjdlp1smD9FDkJo7h5P2kD6qeB1q/3
         QOUO3HzAWVqM3PJ/9sklhvXjPjn5u2qR2y3K+S3vhbuoA+NDtmYuQ/wgK3veYSvWLXIl
         xMMmCAg7C96rHQeiOVBgCFsS5cupjgUGjcJaYeVgyU7983JlTnV1dOBzMasBBuATbH54
         1nNg==
X-Forwarded-Encrypted: i=1; AJvYcCUVyeMQ3ZTPxdPRHHDuPmr6t2LHq1eTtwcVPIIDfh+5jomU4ub5gObcPeEzrgd7iiP/2xLncDCNCPmnG1dJ19Eu3Xr5+BVE
X-Gm-Message-State: AOJu0Yyu4xS5CCzOe4CsRcmSHZUd/MrUUodQFgLZZ12wiRrRMhLUDCpJ
	yiljVduVdPZ+tOKNX9k99vEAvG0LUHQpoZ/oczgJC9PsNJqwgZrT0ytLhYfxbz7jf3lJui/u1ZL
	XAwRqUnaH/HS8xsB415uZ4hFGJAF6pbx214zO
X-Google-Smtp-Source: AGHT+IHaeNJ1MuvAGR+aV7KvBD3fVvaoUgs7b6DZps3nGdlcGBq99EDHwsn/36ZgdH683W6QJ5rrHAkUVbBp7XVOcDg=
X-Received: by 2002:a67:f34f:0:b0:48b:c32e:2185 with SMTP id
 ada2fe7eead31-48c17159270mr5112575137.9.1717745644465; Fri, 07 Jun 2024
 00:34:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240606-kvm-arm64-fix-pkvm-sve-vl-v2-0-c88f4eb4b14b@kernel.org> <20240606-kvm-arm64-fix-pkvm-sve-vl-v2-2-c88f4eb4b14b@kernel.org>
In-Reply-To: <20240606-kvm-arm64-fix-pkvm-sve-vl-v2-2-c88f4eb4b14b@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 7 Jun 2024 08:33:27 +0100
Message-ID: <CA+EHjTwBRaCnzPfwdccHGGqsq9hGB5J1tA2aMcJyuRL8yYRZ0Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] arm64/fpsimd: Discover maximum vector length
 implemented by any CPU
To: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Thu, Jun 6, 2024 at 4:32=E2=80=AFPM Mark Brown <broonie@kernel.org> wrot=
e:
>
> When discovering the vector lengths for SVE and SME we do not currently
> record the maximum VL supported on any individual CPU.  This is expected
> to be the same for all CPUs but the architecture allows asymmetry, if we
> do encounter an asymmetric system then some CPUs may support VLs higher
> than the maximum Linux will use.  Since the pKVM hypervisor needs to
> support saving and restoring anything the host can physically set it
> needs to know the maximum value any CPU could have, add support for
> enumerating it and validation for late CPUs.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/include/asm/fpsimd.h | 13 +++++++++++++
>  arch/arm64/kernel/fpsimd.c      | 26 +++++++++++++++++++++++++-
>  2 files changed, 38 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fps=
imd.h
> index 51c21265b4fa..cd19713c9deb 100644
> --- a/arch/arm64/include/asm/fpsimd.h
> +++ b/arch/arm64/include/asm/fpsimd.h
> @@ -188,6 +188,9 @@ struct vl_info {
>         int max_vl;
>         int max_virtualisable_vl;
>
> +       /* Maximum vector length observed on any CPU */
> +       int max_cpu_vl;
> +
>         /*
>          * Set of available vector lengths,
>          * where length vq encoded as bit __vq_to_bit(vq):
> @@ -278,6 +281,11 @@ static inline int vec_max_virtualisable_vl(enum vec_=
type type)
>         return vl_info[type].max_virtualisable_vl;
>  }
>
> +static inline int vec_max_cpu_vl(enum vec_type type)
> +{
> +       return vl_info[type].max_cpu_vl;
> +}
> +
>  static inline int sve_max_vl(void)
>  {
>         return vec_max_vl(ARM64_VEC_SVE);
> @@ -288,6 +296,11 @@ static inline int sve_max_virtualisable_vl(void)
>         return vec_max_virtualisable_vl(ARM64_VEC_SVE);
>  }
>
> +static inline int sve_max_cpu_vl(void)
> +{
> +       return vec_max_cpu_vl(ARM64_VEC_SVE);
> +}
> +
>  /* Ensure vq >=3D SVE_VQ_MIN && vq <=3D SVE_VQ_MAX before calling this f=
unction */
>  static inline bool vq_available(enum vec_type type, unsigned int vq)
>  {
> diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> index 22542fb81812..ee6fb8c4b16d 100644
> --- a/arch/arm64/kernel/fpsimd.c
> +++ b/arch/arm64/kernel/fpsimd.c
> @@ -129,6 +129,7 @@ __ro_after_init struct vl_info vl_info[ARM64_VEC_MAX]=
 =3D {
>                 .min_vl                 =3D SVE_VL_MIN,
>                 .max_vl                 =3D SVE_VL_MIN,
>                 .max_virtualisable_vl   =3D SVE_VL_MIN,
> +               .max_cpu_vl             =3D SVE_VL_MIN,
>         },
>  #endif
>  #ifdef CONFIG_ARM64_SME
> @@ -1041,8 +1042,13 @@ static void vec_probe_vqs(struct vl_info *info,
>  void __init vec_init_vq_map(enum vec_type type)
>  {
>         struct vl_info *info =3D &vl_info[type];
> +       unsigned long b;
> +
>         vec_probe_vqs(info, info->vq_map);
>         bitmap_copy(info->vq_partial_map, info->vq_map, SVE_VQ_MAX);
> +
> +       b =3D find_first_bit(info->vq_map, SVE_VQ_MAX);
> +       info->max_cpu_vl =3D __bit_to_vl(b);
>  }
>
>  /*
> @@ -1054,11 +1060,16 @@ void vec_update_vq_map(enum vec_type type)
>  {
>         struct vl_info *info =3D &vl_info[type];
>         DECLARE_BITMAP(tmp_map, SVE_VQ_MAX);
> +       unsigned long b;
>
>         vec_probe_vqs(info, tmp_map);
>         bitmap_and(info->vq_map, info->vq_map, tmp_map, SVE_VQ_MAX);
>         bitmap_or(info->vq_partial_map, info->vq_partial_map, tmp_map,
>                   SVE_VQ_MAX);
> +
> +       b =3D find_first_bit(tmp_map, SVE_VQ_MAX);
> +       if (__bit_to_vl(b) > info->max_cpu_vl)
> +               info->max_cpu_vl =3D __bit_to_vl(b);
>  }
>
>  /*
> @@ -1069,10 +1080,23 @@ int vec_verify_vq_map(enum vec_type type)
>  {
>         struct vl_info *info =3D &vl_info[type];
>         DECLARE_BITMAP(tmp_map, SVE_VQ_MAX);
> -       unsigned long b;
> +       unsigned long b, max_vl;
>
>         vec_probe_vqs(info, tmp_map);
>
> +       /*
> +        * Currently the maximum VL is only used for pKVM which
> +        * doesn't allow late CPUs but we don't expect asymmetry and
> +        * if we encounter any then future users will need handling so
> +        * warn if we see anything.
> +        */
> +       max_vl =3D __bit_to_vl(find_first_bit(tmp_map, SVE_VQ_MAX));
> +       if (max_vl > info->max_cpu_vl) {
> +               pr_warn("%s: cpu%d: increases maximum VL to %u\n",

This should be %lu since it's an unsigned long. Otherwise it doesn't
build (clang).

Cheers,
/fuad

> +                       info->name, smp_processor_id(), max_vl);
> +               info->max_cpu_vl =3D max_vl;
> +       }
> +
>         bitmap_complement(tmp_map, tmp_map, SVE_VQ_MAX);
>         if (bitmap_intersects(tmp_map, info->vq_map, SVE_VQ_MAX)) {
>                 pr_warn("%s: cpu%d: Required vector length(s) missing\n",
>
> --
> 2.39.2
>

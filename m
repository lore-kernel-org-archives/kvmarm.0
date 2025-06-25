Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6DD027E059
	for <kvmarm@lists.linux.dev>; Wed, 25 Jun 2025 10:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750846471; cv=none; b=ZYaNkQzjwetZYt7EgeDMNqRzL8GU3sSmMli4RSlOTkolvRPT/lCtF34fuSA2Sbm/cgLXdTHLRzUuWmlJnRkJh7GSMGLcyzfoWxQwOcHqiSyTiM4rWkZZH93o1x4Hu4mUOhu8M1Tq1id1FO2N7xyYvzemUslZlOC3oS4mEPpowiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750846471; c=relaxed/simple;
	bh=Z6ttgkt2ZLAVD2+Rc1hUOiBz5Jxrr7nBEEcPUbxS2h4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IYywW3fh740bjQG/u1fR4/9yDGIhBdcldK1d9MXdV7yDI51qsiesd7EghiLVSVcyFWAV2nltDq3yvDW5DPMXap4P9t65IyucXUFF8rMHC5ZzYBcIrKorwoB/wkcPoSHtR+DMTbmeM2E5es3yeybJK1yevzbu4vswE4mbVbB+DGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=x1hQyWfa; arc=none smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="x1hQyWfa"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-70e3c6b88dbso10759507b3.0
        for <kvmarm@lists.linux.dev>; Wed, 25 Jun 2025 03:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750846468; x=1751451268; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WHpZf1BrPFAlqXFuHdOtTQ7ioXief2ue4zEdYR2QIM4=;
        b=x1hQyWfa13Fco/EfhjXI+dKiDDH01JdR77uWGj8lrs1pz99X3jjt5p+OU/AHqcBYFn
         iixNk6klJskPEdFuvP0gwz/jmNy+7oTfLDtdgLd9WpVIuCwNEKpKW6b5CaJWYZ7JXMU6
         wnq9OiOEzsaJiI4pXZt1GqLaKtCpWCYTZTHiWJ/2yZ8lRkBT46TLCzbu3/9ANEKqGZau
         XycKMcm1MhG8im4zvkUCutUfwmxnssGDcUHGn388XWGxtX5ewKSkzGq74WX+oOgPQG1+
         l8UDpm1CxDBs9TqxLYCNg8Hq/xTS2esuOaCAxLBVBGjn55x6cfxvGnDWxZuxthXqYUCQ
         XUrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750846468; x=1751451268;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WHpZf1BrPFAlqXFuHdOtTQ7ioXief2ue4zEdYR2QIM4=;
        b=d4CiSpE5VXfIy/2NxaQyJfnjbasHvfiLaLLHaiVaefDctAg7Og2kzCz3qq/PV5MGb5
         WVhLAb74Gydfw/mgAbjq8jspn7pbysHPLhd1yWVNqKKpRV5F1HRpLKO+cISQkWUWKFvH
         x3S3XhG/3I/62wyDY7q6oZOIzNq0Slcf5sa85E19kXZme9p7Xn08kPSCNPcjRBNgXjkQ
         gC/AHFo5I7ip0mMZSuHQ3GRsar+M/34Vz6mXgy1jstexGqguNMwGQNrTBpdJgMUJF6h7
         ZDxPsYERug+ZYU8eCwBUtBV5Yt2GyTlhBERyTB0i7bi+/+oG9Bi9uIB4V4vHbaVYDkhK
         X2GA==
X-Forwarded-Encrypted: i=1; AJvYcCWRNoZt2HkNcXKEATZrUXqsGNRvVxopP/QZTy7WsngYLddrU2Ct93HWOXdjtZrdEONL674OHlY=@lists.linux.dev
X-Gm-Message-State: AOJu0YwB3w1AaVIvw/NC+rLPfxxmHeUwrF995l7N9goyVeP/dIwwuaSN
	b2B8qTnttcfY8T2pRyISNaGI4qRTMzSNv/lgBFabctDySnEjlIPTUuWqNbMfrJq8dJRB7xmIEnw
	Pk3IwlCpoNFUxL1ZqNGQRQ8CN8nRLz7gY9XdDXeCGWA==
X-Gm-Gg: ASbGncvfub1bs5qLOS+g9Giu+dsHiNvsz6wb87N5qo/JruI+ewMw60sbSvvH3+ug54N
	E2LhOUHjnW9ye3IZl7d1MLO+Fnx8TWWxj4vtKXm5Bvrq3gsaPEMHHhZCOAPbtiZEXazuRUp39hd
	GnMZ45Za6ndAl1GgruJQUjeQMM6Flf2xVCfLJMBTaRuTZ7
X-Google-Smtp-Source: AGHT+IE1SVnC+PVyHxDE/ir8P+FbDaCZU32E1YBr9BGc5xKyUSgOrtzXwikzEk8hRx34R5EMJ5iKsQAo35GChbuPeag=
X-Received: by 2002:a05:690c:3682:b0:6fb:1c5a:80ea with SMTP id
 00721157ae682-71406dd8d3dmr34791687b3.32.1750846468296; Wed, 25 Jun 2025
 03:14:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250617153931.1330449-1-cohuck@redhat.com> <05e903b3-02bf-4c04-ac2b-cdec0b45fe3f@redhat.com>
In-Reply-To: <05e903b3-02bf-4c04-ac2b-cdec0b45fe3f@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Wed, 25 Jun 2025 11:14:17 +0100
X-Gm-Features: AX0GCFvttrY59WLT4gA3ZgqOqf9rMqxv_AGCgjo_0gmHPt678YKqjDvK8cpzp6o
Message-ID: <CAFEAcA95vCKpk1wXQh49xAWnqY=JZnKdr8NEQuYaRJr=jrKWyA@mail.gmail.com>
Subject: Re: [PATCH v8 00/14] arm: rework id register storage
To: eric.auger@redhat.com
Cc: Cornelia Huck <cohuck@redhat.com>, eric.auger.pro@gmail.com, qemu-devel@nongnu.org, 
	qemu-arm@nongnu.org, kvmarm@lists.linux.dev, richard.henderson@linaro.org, 
	alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev, 
	sebott@redhat.com, shameerali.kolothum.thodi@huawei.com, armbru@redhat.com, 
	berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com, 
	agraf@csgraf.de, shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org, 
	pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"

On Wed, 25 Jun 2025 at 10:10, Eric Auger <eric.auger@redhat.com> wrote:
> However there are other checkpatch errors besides the one you reported, in
> 52873a54ad arm/cpu: Store aa64isar0/aa64zfr0 into the idregs arrays
> ERROR: line over 90 characters
> #388: FILE: target/arm/kvm.c:225:
> +    return ARM64_SYS_REG((sysreg & CP_REG_ARM64_SYSREG_OP0_MASK) >>
> CP_REG_ARM64_SYSREG_OP0_SHIFT,
>
> ERROR: line over 90 characters
> #389: FILE: target/arm/kvm.c:226:
> +                         (sysreg & CP_REG_ARM64_SYSREG_OP1_MASK) >>
> CP_REG_ARM64_SYSREG_OP1_SHIFT,
>
> ERROR: line over 90 characters
> #390: FILE: target/arm/kvm.c:227:
> +                         (sysreg & CP_REG_ARM64_SYSREG_CRN_MASK) >>
> CP_REG_ARM64_SYSREG_CRN_SHIFT,
>
> ERROR: line over 90 characters
> #391: FILE: target/arm/kvm.c:228:
> +                         (sysreg & CP_REG_ARM64_SYSREG_CRM_MASK) >>
> CP_REG_ARM64_SYSREG_CRM_SHIFT,
>
> ERROR: line over 90 characters
> #392: FILE: target/arm/kvm.c:229:
> +                         (sysreg & CP_REG_ARM64_SYSREG_OP2_MASK) >>
> CP_REG_ARM64_SYSREG_OP2_SHIFT);
>
> WARNING: line over 80 characters
> #396: FILE: target/arm/kvm.c:233:
> +static int get_host_cpu_reg(int fd, ARMHostCPUFeatures *ahcf,
> ARMIDRegisterIdx index)

The last one of those is probably easily fixed, but note the general
remark in style.rst that it's better to have an overlong line than
one with an awkward and unreadable wrapping. (We ought to fix
checkpatch and style.rst to agree on whether to warn or error and
whether that should be at 90 chars or 100 chars, but that would require
reopening an old style argument and it's too much effort.)

> 5f15ebdf3f arm/cpu: Add sysreg definitions in cpu-sysregs.h
> ERROR: Macros with complex values should be enclosed in parenthesis
> #56: FILE: target/arm/cpu-sysregs.h:21:
> +#define DEF(NAME, OP0, OP1, CRN, CRM, OP2) NAME##_IDX,
>
> ERROR: Macros with complex values should be enclosed in parenthesis
> #64: FILE: target/arm/cpu-sysregs.h:29:
> +#define DEF(NAME, OP0, OP1, CRN, CRM, OP2) \
> +    SYS_##NAME = ENCODE_ID_REG(OP0, OP1, CRN, CRM, OP2),
>
> ERROR: Macros with complex values should be enclosed in parenthesis
> #203: FILE: target/arm/cpu64.c:40:
> +#define DEF(NAME, OP0, OP1, CRN, CRM, OP2)      \
> +    [NAME##_IDX] = SYS_##NAME,

This is checkpatch not being able to cope with more complex
uses of the preprocessor; the warning only makes sense for
"acts like a function" macros.

-- PMM

Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D293D5232
	for <kvmarm@lists.linux.dev>; Mon,  2 Mar 2026 13:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772456798; cv=pass; b=tu77h/LcUw5ICCiUVRw/Rzkeop3ZTL4qTgZORl0Z0Jha2mCPfIb8C3xZBNtH6ZnKv4T/y5yiGLatwMMV9wJ88ObzZGsafVvW4C/1CXYKHV1sXGF4N5cATReI50AxetED6XGoeZ2Esj2nnzGIg/NT/KWIW+WFjVgH6+s1jUqkg0U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772456798; c=relaxed/simple;
	bh=amiZ97ccZ6iURQAbZcP7QmfUvqVbUFW2PWs9GewNyKY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JMeXDyppbhrSpZU9qMKn3mWZpcILVHTFvPntHd/Pm7djO9lfT1JAhGcGq/KMvHnSRSySZi/a+yua2X647vyuo17n3nTmmKDJ5IrkfJw9QonfEEC2m1HT467PYrD8Fx9aGV/dV1SwStBney9pWFDOBg4EuPj+218bRfFq5mddx8g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=O2fPkvrG; arc=pass smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O2fPkvrG"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-5033b64256dso987911cf.0
        for <kvmarm@lists.linux.dev>; Mon, 02 Mar 2026 05:06:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772456796; cv=none;
        d=google.com; s=arc-20240605;
        b=AwtvAjcuPie0mvjQdJLCenEU22/YnHjzvOZGVpPHnCTzNTxCZvFnjQkaqbzIfd8gZd
         aAL99YoevGhcisO6PR55nDCKocj0brmNGdeOyDt75YeOMwgyCvc8dNXfJnAmTk/FdhuL
         ZouHYtUw0WdeLvON+8X4jhkmKHaqSV42YOBHT5Kb7XiartLw9kv+Dseo9fFLQq+iY+fp
         7o43EGIrpNYEoBeRpm2/j+gnhJqLlWa1QQv5dJfdpxipGoCAhcRgfc9L3Sx+emQ/kyFq
         W0S9oVaxSWbPoue5XCw40exErx+QT6qcFJEfRurcK0uyi3y3Nw36wQk71g/LAxCbm9vy
         wNww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=fOLqAucbTxyFo2M2jPSZSgGxwMASNxx4SIjrfDPlm+Q=;
        fh=XwC0FmJpYQYgBlCBwDY6SGc3n1QpF/bGw2hmg7cWPHI=;
        b=gMvUWZcvV5/o4o+tfASuutj3qQinA+34MB/DeH48IZAFyX0KvSXo5+Ceb03gHGw/83
         cg2mbrMV8Vkbwvu6TTtbT8v9HWJPgcFmHruVaKhmMGq6b3dE/2MZaUNG4dwFRqw0kysh
         Km8UBZ5LCJPpWKSqw0rrmcOSmqVb7Fy4Fgm02AAPHTa2PMFgQGR/s1vP7mk36Q5Y6fdo
         26STRNJ06MBg1bgjuQWB53NgNZY6ORvZZq8AwmSVuy2JWTskDCEQrD25jYfOn+zfOqFD
         VdZaOr0txkbmjlXF4NZE027FBKR3LbNxBg1vmvF8sBW5MjzbYhVjy0DW6UHbkp3UEgTH
         lq7A==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772456796; x=1773061596; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fOLqAucbTxyFo2M2jPSZSgGxwMASNxx4SIjrfDPlm+Q=;
        b=O2fPkvrGiZwpzNv+Z2P0RuSvpTOzrZdoq2O9rqszXK1Yvk8ht+F/8BGWb84ISfX4cp
         KVwoqScDIby8umIg+aGcN8LHfjnUNKz3Gfb0s3ZF8GPJVt7EGRfZCefbBi8Z+VtJbSDp
         qjSq3V3Twa0j58NfxQVP+qjFXgzDvKS4BadoGujqcCPRI8vj+5O3wDYlmMqyb3ON8Z2b
         FpJLfNMn1qg/Xi6bTsAwtEqhsIy2s1KnbufgoF7YCIacOmKPq/pFEEdXVXgbQvndvw7T
         ex8cZhZtiPqKvqGKs3swkVOmJbuADys59stlKHdq2uqZDBCslnydofCj29tSPI87hUbh
         WfXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772456796; x=1773061596;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fOLqAucbTxyFo2M2jPSZSgGxwMASNxx4SIjrfDPlm+Q=;
        b=woO9FlKk45cfY/s2hCRA5zRb37GRzgArb8EDev4OU+d7hjxoM9npURLz570gJVSmxU
         zKKjFlhR6fc8Lz2nx4IHSQsIeyWTqe8eKG2jJqaS8nrW/Q9+2MRo6SGybBwpIVX85+eu
         tiu5pnCjcQRdmNH10lcCI+IxVnh4FuAd2G0xMKHY5rFrmt8sBBvvqjixF5Tt80FoUZ8k
         7i40DLB4qzrvSWRLY8ZmbJIn9hO6cwOl690UiV35uOuOnhrG1Cs9MSaG6zM1NCibM+zX
         Y8qqzNEUmqtRLcrDVK6tSk5edF24wAc9Fcme8PCJviklL+8IkmSYj2GsQxhpzn8Mf8op
         E/Xg==
X-Forwarded-Encrypted: i=1; AJvYcCWo50jRy5/sgYyLsPqJg8b0udndUertRJ2GwpcCcDvThDnwUDGtQOr5pdmqkeCYzSo8/GQYRmQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxliSvjWP27Lcrd0JwySJpi5jDUJowUIh0a2CiTqaxJ9nFYZNSv
	CY0exosMduP05v+iJwy27Uk4GX3hk0c7Nu85+BadOCSZhkgCWpvSHBdllO7M6LMqFAm77N1GbE/
	u4YGoDuj/8kdsP/kJJuBx5OJj7xMMygrcq1wESYL0
X-Gm-Gg: ATEYQzyocaTkWc6E1yh3WVqYEbd8pKtcbxT0h2tAKPsn1EtgbEpVh3wF7ChbKRTUtiB
	eHPft4B1dUvVTPOSBWd51xgEdSCyTmJZ7o3CKTr3+u8iBWMgfvofIQBy+vtvKMth4iGVn6TtJYu
	Ymk+8dIJmWEscINzziYEpD2W7ZD6iYyiKEHHf2bxdOBnwi9gZpbWUgCTBiXj0sI3VpnoHBzFMBW
	L+5fbECM8Z6TNUgqwokKa4tHg2MgYa49ODi1Ape5a1F0j6aXUST84LN8vM+lq3QaY7msAXLY1KW
	GiNgdaPr
X-Received: by 2002:ac8:5995:0:b0:4ff:cb72:7c03 with SMTP id
 d75a77b69052e-507617532dcmr20454061cf.3.1772456794178; Mon, 02 Mar 2026
 05:06:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260302115653.1517326-1-maz@kernel.org> <20260302115653.1517326-2-maz@kernel.org>
In-Reply-To: <20260302115653.1517326-2-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 2 Mar 2026 13:05:56 +0000
X-Gm-Features: AaiRm51GlBX_MdTsrU5yy6eWmhXvo8Y7KaIHzBtRUyZRbvOgDA3XLnU851PASag
Message-ID: <CA+EHjTwYhdjfmZxyW4yjfOaokNdVGkHB1h6Qb9O-4D_3f1a-Jw@mail.gmail.com>
Subject: Re: [PATCH v2 01/11] arm64: Skip update of an idreg field affected by
 an override
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Mon, 2 Mar 2026 at 11:57, Marc Zyngier <maz@kernel.org> wrote:
>
> When computing the new value od an idreg that contains a field

nit: od->of

> affected by an override, do not update that particular field.
>
> The value computed at init-time must be kept as-is, as that's
> what the user has asked for, for better or worse.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


> ---
>  arch/arm64/kernel/cpufeature.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index c31f8e17732a3..28fc77443ccd3 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -1224,6 +1224,13 @@ static void update_cpu_ftr_reg(struct arm64_ftr_reg *reg, u64 new)
>                 s64 ftr_cur = arm64_ftr_value(ftrp, reg->sys_val);
>                 s64 ftr_new = arm64_ftr_value(ftrp, new);
>
> +               /*
> +                * Don't alter the initial value that has been forced
> +                * by an override.
> +                */
> +               if ((reg->override->mask & arm64_ftr_mask(ftrp)) == arm64_ftr_mask(ftrp))
> +                       continue;
> +
>                 if (ftr_cur == ftr_new)
>                         continue;
>                 /* Find a safe value */
> --
> 2.47.3
>

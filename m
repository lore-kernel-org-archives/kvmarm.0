Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EF95350A33
	for <kvmarm@lists.linux.dev>; Wed, 25 Mar 2026 19:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774466940; cv=pass; b=I1Keqik1n2mwmgA6oz8D3CCZEbqQciAcs/1zEArL7rI9p2ZR37ujOpowgEPYMibMSrqf7ATnTL457sqZqvZr8OZKQtN14mHmX6qo9i4Aipr8oJqogjg2wQxOtNn1Fi6Zvxj3RcujVV3EQUGZ8l8sB9aJZ8N1f3AokI5SJi3y15Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774466940; c=relaxed/simple;
	bh=slGNRJCW2sBMnGtEIEHab3BqrRviXUbAIQS2y5kzS/E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WLKTbQAMn9YCpiDrRFEZhwQa2mkDbmA2H8O8ybMZB9uZp3dGLrqc1VKonhlHshYsdFaaN5QKzmU9Gq0YWLPnRKqkRtXA8wTqtdY63/bYIvsUM7woCV4dcHw4xzWDTa6v+4uRoZ+tNyWwI8Rms0SQ60C8EEUtnJ0KWWTb6ugx6NE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CqFlbH98; arc=pass smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CqFlbH98"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-509069a7a7fso125211cf.0
        for <kvmarm@lists.linux.dev>; Wed, 25 Mar 2026 12:28:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774466938; cv=none;
        d=google.com; s=arc-20240605;
        b=TGJVvtRaIEduvDQOFIgXdS7KeHcB+xc822GyReB5GbHtEn62ZIb/rQ5Xj3SoPQZ3YS
         j4xuG34hU8L5jXUy9h3aa6omu0+fkjbRbnQIUOGhquIvKqpgWXUeUJGXcJ7cvdHqWdgW
         qLjLcvn+IeIVh6U31tiYUFfAWy1b/Gi+9IJUgYaMHMo91/tg3sXPt11HL5K89PBluqpg
         ZolrkRXJYjIfkYtrNHreNcunqM2/xIMYMVFtTrYsVxn2KQiE75gYr+HcQMQRf8z+MAI8
         elsrt/jRExzJP3h64U7A7603SdiXxiXPg6Pwtky/uD8XFLFer2h4Sw5bjWFzNRZ+CAII
         kg7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=s/ZpfjFSEtOGSyy/5cgdUOaGwEfcRMUMn1EzqJ+4g4M=;
        fh=WXifrakrhHpMKuV+YM1LZ/K83mZPglPFmcpcPxsJbCI=;
        b=DBRNP0tzIBc3Mp+MDy/PUW0XUBAAGm0oDtRTqPCI49dO19lF7PuMVog7jHiXaddpNS
         fuAc2+nEKhHLkSXyj3k/bvkOrXgbJ1fr064isv9mdd/lCHis8rUlhsnLQ3eES0sHKRRZ
         VjSteEJST7G1NhaWbQY8oM0tcnyQ4hjEw40pGWX/Er8++UAD5fBuCQ0zBZ1RPfwPIo7r
         VEgv+6QOx42XpXq51zrbM1Ft9tumh0AdVcR5zbIWypdufezKi2xIIWGVaRUursf//Dt1
         BgD1R2hCi3pRJkTGNcucI7cAJmKaddk70zojofRhEScs5+Nq/IAoRS3SHvpF1FT8GWSa
         XIhQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774466938; x=1775071738; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=s/ZpfjFSEtOGSyy/5cgdUOaGwEfcRMUMn1EzqJ+4g4M=;
        b=CqFlbH98S/yh5iF3mKIxtFEJdWNW93yDyA/WroI8IJKEFD0+/RX+9bDmku3LkCsDc9
         08RfDeuoz14g5dCBfOV9gB0rclWZ2USmsYXpnt2KSghKfGXYRVrrqmga8V77bZGU60Ev
         gGq3nQLXquXb/f6zCP8jvCXKunGXjHONdG0jULXcTBdoMbLU5rPIlUdQwu2O/OxrIyLL
         u+UQU+jUu1D2zZM196RS7kJiT3BUxRBXj9aqMbQpwUdfNxMc0DsVrXQgPNXale3cQR0J
         CRY3sGOVwdNGdCGJj626CP4oC592vKTHgUaCDJf0GUqjZRKZSKV9oVLpWqICFYtJs593
         sVVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774466938; x=1775071738;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s/ZpfjFSEtOGSyy/5cgdUOaGwEfcRMUMn1EzqJ+4g4M=;
        b=rsuQXUYOvrKfDTuTlyU9E3+1TU9NcAeNtOOAZyB6kQK1PfkepXZXk3YB+YFdKql+2v
         6Z9nSS5e8PSA3jqPw0YIoENIO60pkdRsEPRoHkfzLnCIngZjYC/G2Q0sCkWEMYUxynRs
         5wWJEhldCtJ9etCY4x99c/SFjPq3YL+lO5w1P1sqgIgjv57FuLgqZLcHL4uxhifqsj4p
         mr9MeWi9PHeQJVPlL2ZaBDCZR31DHpG+UgmxS5WpEfejAiHCVIvGmL8A49SBXF0rIwmz
         9stolAN+r8ESRIHGBjOG5UkCoBRKy6sdQPkiQWcZLALJNJoujpKaj27QTGh2uZl74gF9
         lRhQ==
X-Gm-Message-State: AOJu0Yzcz/yTA6vZppJIECRnogaaeBY8BVPu5CX9fgB40VHgDF8oi31W
	h0uI471jrTTWyg/vwb6HovUD5URHBDKxEe3Mxb+qNiMN94NCXQm5BxilHV5ZjSeN2GEnpahWV8A
	JCVfnAZbfcYlMjEvwLUNGn7gWkuu/NtyTi63RG3sw
X-Gm-Gg: ATEYQzzOUM4akulMjMQDrT/RGm+P1cYLZCF2qMJ/dRfQdUknOeXgMm4MFdHDyTDmTm6
	+oa1sAOuU9VgI9veA4c49byNjasw3HE6Yu8ewCcqRpOdp0TcwK4hRi9s8LpPIhRIPTdjEytt6zQ
	eg8cRchXHHdKfMA7AfYF2Q5Nzy0WQorrN9CEwwSaLxZlwKdJIdCEQ+2j6iTCI5tz+fZLaU+VcXJ
	jXlwRyjsYfnSzE1UWZTWMyRj3XGFzgBPBFp0SzjFjwUvdVRvmZgqHU+3BU1P21nm+Tcy11Or5iE
	XpJ6q0GX
X-Received: by 2002:a05:622a:55:b0:509:1c2c:866 with SMTP id
 d75a77b69052e-50b93c22503mr1073641cf.11.1774466938020; Wed, 25 Mar 2026
 12:28:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260227212136.7660-1-will@kernel.org> <20260227212136.7660-4-will@kernel.org>
In-Reply-To: <20260227212136.7660-4-will@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 25 Mar 2026 19:28:21 +0000
X-Gm-Features: AQROBzAoYjX8VM9IBDnHSEJaOijoJGyXHH9NyF0-ya0xncOBIQZ1Q9YEpttcKXU
Message-ID: <CA+EHjTyYJVqoa332LbzZ49i-C4-DhiSziqd_gqY22qnDmkyV0g@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] KVM: arm64: Don't pass host_debug_state to BRBE
 world-switch routines
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, mark.rutland@arm.com, 
	linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, James Clark <james.clark@linaro.org>, Leo Yan <leo.yan@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Yabin Cui <yabinc@google.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, 27 Feb 2026 at 21:22, Will Deacon <will@kernel.org> wrote:
>
> Now that the SPE and BRBE nVHE world-switch routines operate on the
> host_debug_state directly, tweak the BRBE code to do the same for
> consistency.
>
> This is purely cosmetic.
>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Oliver Upton <oupton@kernel.org>
> Cc: James Clark <james.clark@linaro.org>
> Cc: Leo Yan <leo.yan@arm.com>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: Fuad Tabba <tabba@google.com>
> Cc: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Will Deacon <will@kernel.org>

Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  arch/arm64/kvm/hyp/nvhe/debug-sr.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
> index 75158a9cd06a..06ae122a7761 100644
> --- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
> +++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
> @@ -158,9 +158,9 @@ static void __trace_switch_to_host(void)
>                           *host_data_ptr(host_debug_state.trfcr_el1));
>  }
>
> -static void __debug_save_brbe(u64 *brbcr_el1)
> +static void __debug_save_brbe(void)
>  {
> -       *brbcr_el1 = 0;
> +       u64 *brbcr_el1 = host_data_ptr(host_debug_state.brbcr_el1);
>
>         /* Check if the BRBE is enabled */
>         if (!(read_sysreg_el1(SYS_BRBCR) & (BRBCR_ELx_E0BRE | BRBCR_ELx_ExBRE)))
> @@ -175,8 +175,10 @@ static void __debug_save_brbe(u64 *brbcr_el1)
>         write_sysreg_el1(0, SYS_BRBCR);
>  }
>
> -static void __debug_restore_brbe(u64 brbcr_el1)
> +static void __debug_restore_brbe(void)
>  {
> +       u64 brbcr_el1 = *host_data_ptr(host_debug_state.brbcr_el1);
> +
>         if (!brbcr_el1)
>                 return;
>
> @@ -192,7 +194,7 @@ void __debug_save_host_buffers_nvhe(struct kvm_vcpu *vcpu)
>
>         /* Disable BRBE branch records */
>         if (host_data_test_flag(HAS_BRBE))
> -               __debug_save_brbe(host_data_ptr(host_debug_state.brbcr_el1));
> +               __debug_save_brbe();
>
>         if (__trace_needs_switch())
>                 __trace_switch_to_guest();
> @@ -208,7 +210,7 @@ void __debug_restore_host_buffers_nvhe(struct kvm_vcpu *vcpu)
>         if (host_data_test_flag(HAS_SPE))
>                 __debug_restore_spe();
>         if (host_data_test_flag(HAS_BRBE))
> -               __debug_restore_brbe(*host_data_ptr(host_debug_state.brbcr_el1));
> +               __debug_restore_brbe();
>         if (__trace_needs_switch())
>                 __trace_switch_to_host();
>  }
> --
> 2.53.0.473.g4a7958ca14-goog
>

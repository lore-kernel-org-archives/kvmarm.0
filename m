Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87CF2221540
	for <kvmarm@lists.linux.dev>; Tue, 27 Jan 2026 18:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769537392; cv=pass; b=IyX1l1fQDgCIr8jXR/po0WMrJtdbCOM8B3+iXtRrxgHQM3TX8sXgPUfR/n31MRoa32xwcRq5+/lGEZ46FloFpa0X7QjNCkkWMzWrOk657QBKxJuF5i3m8CwpajNDsUpGOUnydSJw4WT0ZLjZ2zK5tXrcdG4+qhP1j9yPr0wH5kA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769537392; c=relaxed/simple;
	bh=QhsDz6emSteQN6HE837EJTl9yLXUpogqzdkgXhKPUOc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hgYy8GhHwfc29QbrDc3KK2N1IaUAjk3FGeO0oFeP7WyFWJI2T5+Rrn+dS2k22CF1YpWPoMIUv2e2OBhbe2OnKFGNHaHwIzuEA6S068a17/Ugfq8EJ8Fs8lY7hp28r4h6dbpa+Q5pqtgrYJoehHRggiaJLe4xhVCbGSb+z8Y5KtE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gIFxW7/N; arc=pass smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gIFxW7/N"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-501511aa012so28391cf.0
        for <kvmarm@lists.linux.dev>; Tue, 27 Jan 2026 10:09:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769537390; cv=none;
        d=google.com; s=arc-20240605;
        b=jtZB0bDUBPQbWURP9ClvU5R6ijJw2HZe6h0vrcHSmtFagduYLj/ZJPgH6BjXoAz130
         epwlh6bkgS5ixvbP9R+OS2H8O4GnI1Tm81Km1LySyL7bbn6EviPVEVHW+8HfkYvkg0Ej
         SZs4LqdZajI3ldHp5ontcJ7Ak998//TiNw/Rdo7j3inSki5dK4JJcZn62DzXLpczfVhW
         Tl9lRVkm6fSsHJcLPonbh7Zh6kaDdBVzsyTOEV6G6eio3Wms5bw36l1C5zCobIPlufAC
         1V5iwYqPuedwP75TtL47NvH6/OaoEZHaja5EVXx/zjlp9TJ25XQevM+KAceVQ8zuwe8N
         WRrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=A/fdw3HSB7m2kNlxcxEsVX9/NQhTkjGaXcMCpnvtKt0=;
        fh=cKTbDbQYTc+pleUDsHasQv4LjIooAs3OE4CRw2/lzRk=;
        b=aJK6gbNg8M9ktdMVRWWHcg02YT+wHB5547YLRTGXDBiebaTTr9amQ0D7pz25rh6yUG
         YnmNwA1SQRzU3QABxpeGpYD7VnGTizdelr6jzXA0T/kTKyMQqCDYVRFakgn0nSg04QHs
         JPfxbwVaAdqA6AsF9J0XBOnXRW9Hd3DaGr8xl/VCGNY1LkBUZC/zaiYOHmvc4RIDGzYo
         ZYMflulNur8f/LUG3h7cE3ItSrS9xShdvHPWDRVTiuKYbhsNjLvFLCgICdqDZoFxdw3D
         JYYNRzZQsqvf3kXVTUC6E0WJRxcbbzr/lM6uVEYuu4FG/IHEswsXe/u0wCL+4FzpE53K
         1CVw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769537390; x=1770142190; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=A/fdw3HSB7m2kNlxcxEsVX9/NQhTkjGaXcMCpnvtKt0=;
        b=gIFxW7/NOrC7atAmkEijVgMjh/O0TT/b+uMVLqpu/HCC60vXAGG4c9j/dm8IN4cqT/
         4p8bGMUNP52xX2dR1+Xe+P6IXePHfixoIyIalgZkJ7ZbJxF1MndCDJEgpBPUz/6GfWb8
         97cIoKRFi2PNX34NCgwgI1a/FBzA0UnV/+VToZzTsZ5GxvHBea0VCh9tRPKNTj/8aeKJ
         2smTAoLZhx82UoOs4TOl9DTZuHAOk3Q8LzGs88GRoD03Ys860ePnCcn3dlvybXajUzNF
         341sFxDV9wzS6QTYYDUKqXyt5XlgxQkWM//HuuCmdHerBFY9V1gWof4T0/HAyA8wdly0
         HzBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769537390; x=1770142190;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A/fdw3HSB7m2kNlxcxEsVX9/NQhTkjGaXcMCpnvtKt0=;
        b=t4yldf+TJ10gYVPq5Y79pjjcJhk0Vx2qFU6zO0nCxJUQaBsxJVid5llqBHxJIy9Ozf
         YGLNQJrud8PNj5/KC0cYj9+bCV4if0nYWPvdHD0O3rW1uav3WtXKuyJfVyU5AGuz+FnJ
         M7rkc7GDUl+KE3Fvy+rlXuBvP4nZYuEgk1hUamBbjGkppL8Wku9tQOZTllJLc3Wvbnky
         wLcKPTCuy/pyF1HfDbOkC/FYecV/3mTvS4MlbwiREwKD7FPPksUTgXM1P2/p/0DVIWQy
         ogJcDVE7arWdsg+uwxC4tYxDd0oFmC3FPR93UDEI1UYm7OzIaT3OKE0yGyuZuIOqPhCM
         5PEg==
X-Gm-Message-State: AOJu0Yw7JqmKRwANWerEoX7Duv4t/VwsYPf6YNXGrV/dFYdAd8PtLITl
	D50S+Pf1tJol+AVUh3z97qNHH9swv7ABguOCGw8necGuEooaJl/llF5UDA7zRU2Zlua4zInffE3
	uG7DGkK8k07eNMhIqkwpI78NZuS290YxBjv9B18qF
X-Gm-Gg: AZuq6aIOOwx34n/Ft68ytsqUAWlwWPZn/U7eTlFTFVlpF5V8i2yH8m60Gw18VFcHIW5
	w57Tv7KYv2+DBWBrit5uG4o8p80hxYJuDhY8jZHPN4xmp17n7JTAt2N63TG6Hu0HCScmNga3qT8
	WVGwfb9x0iID5N7rhS5kHgybQPM7QArXmsj0p585FwTk1x5mClxZGp42EYA4cNOUE3kPIETNUGr
	59vL4LTq1HkFCGqg3TfMfKVoiBaXFjk137tL4C3o1cohcZBL/I4x16z856XqjmbopbjxALK
X-Received: by 2002:ac8:7d55:0:b0:4ed:8103:8c37 with SMTP id
 d75a77b69052e-5032f4c7f16mr11147521cf.12.1769537389984; Tue, 27 Jan 2026
 10:09:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260126121655.1641736-1-maz@kernel.org> <20260126121655.1641736-10-maz@kernel.org>
In-Reply-To: <20260126121655.1641736-10-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 27 Jan 2026 18:09:13 +0000
X-Gm-Features: AZwV_QheZWlu-Uzsp1OFbCkpBH6_EN7Esc-S0xm2N0aOTBYMl0RK4FXDHy6Zuj0
Message-ID: <CA+EHjTyQdLO3pk2yqDDptXemRSFJmt674P_H2-VtWC967o-c3g@mail.gmail.com>
Subject: Re: [PATCH 09/20] KVM: arm64: Convert HCR_EL2.RW to AS_RES1
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 26 Jan 2026 at 12:17, Marc Zyngier <maz@kernel.org> wrote:
>
> Now that we have the AS_RES1 constraint, it becomes trivial to express
> the HCR_EL2.RW behaviour.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  arch/arm64/kvm/config.c | 15 +--------------
>  1 file changed, 1 insertion(+), 14 deletions(-)
>
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index 68ed5af2b4d53..39487182057a3 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -389,19 +389,6 @@ static bool feat_vmid16(struct kvm *kvm)
>         return kvm_has_feat_enum(kvm, ID_AA64MMFR1_EL1, VMIDBits, 16);
>  }
>
> -static bool compute_hcr_rw(struct kvm *kvm, u64 *bits)
> -{
> -       /* This is purely academic: AArch32 and NV are mutually exclusive */
> -       if (bits) {
> -               if (kvm_has_feat(kvm, FEAT_AA32EL1))
> -                       *bits &= ~HCR_EL2_RW;
> -               else
> -                       *bits |= HCR_EL2_RW;
> -       }
> -
> -       return true;
> -}
> -
>  static bool compute_hcr_e2h(struct kvm *kvm, u64 *bits)
>  {
>         if (bits) {
> @@ -967,7 +954,7 @@ static const DECLARE_FEAT_MAP(hcrx_desc, __HCRX_EL2,
>
>  static const struct reg_bits_to_feat_map hcr_feat_map[] = {
>         NEEDS_FEAT(HCR_EL2_TID0, FEAT_AA32EL0),
> -       NEEDS_FEAT_FIXED(HCR_EL2_RW, compute_hcr_rw),
> +       NEEDS_FEAT_FLAG(HCR_EL2_RW, AS_RES1, FEAT_AA32EL1),
>         NEEDS_FEAT(HCR_EL2_HCD, not_feat_aa64el3),
>         NEEDS_FEAT(HCR_EL2_AMO          |
>                    HCR_EL2_BSU          |
> --
> 2.47.3
>

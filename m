Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19364430B80
	for <kvmarm@lists.linux.dev>; Mon,  2 Mar 2026 15:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772464523; cv=pass; b=uGy3NWpR9ih+a2zImW7QDBRPsR12VanEJe9IrK63eFiJY43q9gf7ihPU1TS5FGaEovJDjIcEipQrmKYjx8iqCMMJfqdW20ylmY/MNi7HW+3BEQftMmboD0cHsaEF3CVv3yxUVZrWk3/Kzqy71F7IcVS2LOHeAyhXf1mAj1Hr2aQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772464523; c=relaxed/simple;
	bh=zeTY1NdsVGYIT2vQ8NBlQAWWArF7FJ4q8Bx3XfXzfic=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ISzvSjfmsCm5KvRNUrCmjJZGf2oyt4ceENGHRB7Dqk7GmzGzBuy+PyN8NrkrO58yW+eIzKMUPjRmLbQNjOIHlzXiplh+pg6Ff2WKL8CzcXaFHV2SjUQBW1qc1uSczLXD4boo8mrxiOstayaHgqE9jqKDmgtBpxhXY4P4/bPxDKk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MFIH8RhF; arc=pass smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MFIH8RhF"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-5033b64256dso1052121cf.0
        for <kvmarm@lists.linux.dev>; Mon, 02 Mar 2026 07:15:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772464521; cv=none;
        d=google.com; s=arc-20240605;
        b=NykqYiNQqkDfQcQuuM2ttGtgDO/cctUUEOdx5bcxjIVtGoTHZf+UHqbgxsb+Xqsn4P
         z5cz6otuKWot6fKJ1e2Z5iCAWzkx62T0yT0jUTNzbhwFNycWQ8pEr+mJQoTskUKN8OxJ
         sj9DNoII0dz4WOJGXIdh/uDbpkzyad7dqZKAMurXsB+fetuNvM5kxRG6nDXZH51+jQpt
         xQRCo8Opkg6Q+XTfUww4ELbpM87SRS7y9Lp24bUDrjXCm0b22ZiwmWeqQCSCC1Q39Hjj
         ALuKnfbKMemRh1DIM9LKUXu6K1byIvlMD2CESi/feIMKzTQ4MDaqBvi0GNwIR/fWq0wl
         jnew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=XLhMi12c9hilSx0fJ9MNNmOkG5ZaJ8A8J3vzxrBi+l8=;
        fh=msM4GJ8GVq02FkV37u7Pte8TO9+owyvbTqmnmF+rfwE=;
        b=Rkp3XUxC4XiJUHPWL4IeNl1sV2kUIkebfyUF168SWIgwAwbIck6tHljCAOIyPK2o58
         TJ85IkuTemBZ/XOy3p0c68kvPDpu9DfRM3Q7Bhhuqk2SpnXkq+IW6pm51ou9WYSejcFn
         95s/ohqh3ErpuxVCYaqbzrKD2EHGZeCYVqDUGQJyJCE2Za5mdVQpXLIjMBJ4Lu9Lfnn1
         U+AadtqP2SK3ditYOte31Sl4gpFMoEjS3e3jJb92nlVXqhXeeUCsEk69shaFWq/BhR1E
         OxOVKSU6lc7B8lOZjkpyC+Z1mWrZtXglp64M04yZ+eZYYfYuHJqgJ4+m+xSRbu0syjf3
         SYlg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772464521; x=1773069321; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XLhMi12c9hilSx0fJ9MNNmOkG5ZaJ8A8J3vzxrBi+l8=;
        b=MFIH8RhF5reyghCGqLcs+nt6TAC26KlGdFAbEC84h+QsSTsNAN+qgBCxHmt/Ey8YgB
         JWgPN7XPWQwAqxsr+8qUejGKbkMPsJXE7j4xc2QfH4aK8dBm2bH6rNkfcbagtnqjqNmB
         vDELprlpSWLndm+Jc0wvnBWjCKGbUJLwxb+7JmO2gmEgszE0drYelGybQ+au3lhdJyAd
         8CykMezxtklh1HBp9ofkdtsVc/HP+oMzqOdjHrm0gBXyudS+sJGBLlIOT0BlfNuPBUBm
         gj/uvgADplksbpN1MgNihOxcRxFlmqWhaWyT4sX6Gay+fXd2OmUs0JV6QRH7T+ATiCqc
         4F+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772464521; x=1773069321;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XLhMi12c9hilSx0fJ9MNNmOkG5ZaJ8A8J3vzxrBi+l8=;
        b=Es86kHMNOCX1m2yg2KVwP1QiJLfda89YE4NQadP2SsSKyBhALmOxTEwQN07hF4zfTh
         EDuGhTKQQb6LkCYdBZyI4EBQZy17u7gqM45IxFd2WIGiLxWKV5dHhy4uFm7vo4scgkCa
         GQRuW09LzKrDIPSM2O3m9h+oXeJ9WLXs/FE8vFK5YzRYmO47o2koLyBiZe9zfq+3Avfz
         u8No7izpvwUc2zl53M3OyzzJWC3aG+0c9gCMX7hpn4RloiyBxI8ShbMfBtKy+Jo8fHvA
         RGBdEbfVDARz4x5bOnyMTzbGvk0fHZWfTWKjiaJauNilsiJxs2w7DHhEOJa1gdu2zRYp
         +96g==
X-Forwarded-Encrypted: i=1; AJvYcCUNXESaaWtjtrglkAYzgZnaF1pwiNgTH1MWnWvztDGNQ6YO7BPtPZo9SNgeDu707Ai5aBdpStI=@lists.linux.dev
X-Gm-Message-State: AOJu0YyKy5/7v/UyHslCoygLFh64nFjJXo+HMclU5TN1S1Etk03eHQBM
	BpYqpvuBmmdVY4UyP5xc1r6HWSjFgyHmTOHkripBPLMKYhLB0EDj95jUuJKOCcgGY78FjqyY5Bp
	LsZBDL5AM3GcMTauzz4xDntwyw5MElQTC6IyHQnYM
X-Gm-Gg: ATEYQzzb5c8rfCAoF29pJnU1s0nd21lBvgH/FgaAQg5uT93UpqXYT3goCE788OKVXa0
	AzNbWLwh/4+xzVgWJyvT0UW+wM8sXRvPfIinyK+Wp4ykYLyq5Oz9zBnUNTBN4fst6JWHJL/i4Lo
	BMRPWK0G/eBTZqBfELYhnBqgevqg5Yq6IOIaTFWAofrevYhfJg3Frm3P5UOgUCdWh2RFb0id6W4
	C2yEbrONUiMrw3u5lMd5y0VAVcZ5AeCtfw25BN6a1V/vUOSsLPnG/oufRazA9OYDESz2MpsRd78
	kUaOMg5o
X-Received: by 2002:ac8:5995:0:b0:4ff:cb72:7c03 with SMTP id
 d75a77b69052e-507617532dcmr21739891cf.3.1772464518402; Mon, 02 Mar 2026
 07:15:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260302115653.1517326-1-maz@kernel.org> <20260302115653.1517326-9-maz@kernel.org>
In-Reply-To: <20260302115653.1517326-9-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 2 Mar 2026 15:14:41 +0000
X-Gm-Features: AaiRm53AeNzBUqCcvwVmtTfW3IVhaSW812eJdmucfptOpXaPRrJTjtj_9ytMZMk
Message-ID: <CA+EHjTzhciLDu145E+iCLr+ej9Xi9etkk2uigpBgpHH5NBE6rQ@mail.gmail.com>
Subject: Re: [PATCH v2 08/11] arm64: Convert CONFIG_ARM64_MTE to FTR_CONFIG()
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
> While CONFIG_ARM64_MTE=n prevents userspace from using MTE,
> the sanitised ID registers still advertise the feature.
>
> Make it clear that nothing in the kernel should rely on this by
> marking the feature as hidden for all when CONFIG_ARM64_MTE=n.
>
> This is functionnaly equivalent to using arm64.nomte on the kernel
> command-line.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kernel/cpufeature.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index ab0a7d72608d4..a56d242fe1489 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -315,7 +315,7 @@ static const struct arm64_ftr_bits ftr_id_aa64pfr1[] = {
>                        FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR1_EL1_SME_SHIFT, 4, 0),
>         ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR1_EL1_MPAM_frac_SHIFT, 4, 0),
>         ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR1_EL1_RAS_frac_SHIFT, 4, 0),
> -       ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_MTE),
> +       ARM64_FTR_BITS(FTR_CONFIG(CONFIG_ARM64_MTE, VISIBLE, ALL_HIDDEN),
>                        FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR1_EL1_MTE_SHIFT, 4, ID_AA64PFR1_EL1_MTE_NI),
>         ARM64_FTR_BITS(FTR_VISIBLE, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR1_EL1_SSBS_SHIFT, 4, ID_AA64PFR1_EL1_SSBS_NI),
>         ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_BTI),

Although it wouldn't really be for the scope of this patch, but what
about gating the other MTE fields? e.g., MTE_frac here,
ID_AA64PFR2_EL1.MTEFAR and MTESTOREONLY?

Cheers,
/fuad

> --
> 2.47.3
>
>

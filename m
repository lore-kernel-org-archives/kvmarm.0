Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E1A2233A
	for <kvmarm@lists.linux.dev>; Sun, 22 Mar 2026 15:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774194990; cv=pass; b=FFawnPmq5lXG5x0qYDcC6sXQ+WcdBUfzAH4rJu4I7SAfh++tIc5UNwJGOyMdLZsdNeUqm4Al0xhsWTUh7wet4RY/YZwNH0PTdLhk2uxErtOuXHrvMkEjYmLn9W1HDq1ldybdF5ZjYfYTSr/bXvPH6O2Qmx95FenSYz4X7k9oDHY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774194990; c=relaxed/simple;
	bh=OdDWWcazLt63r6yW7wQKXXNFVZ6zq9YIXeJTMK8dH9c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fE55onprvcPMgu6WBR04vNG5puajhSo64fGQ9WYASp0qog6YKsaaCQVokEHrRztl5HSxMWqurbG7t6q/P/lsbq/e32EBNQg/CFqECMMquBHY5Q/6IaAtcYMXdmVSP27hR2udxu6T/taLnbEQNyoI1XLoyrIbaXmO+4tXXpykOKM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DEsLBWYM; arc=pass smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DEsLBWYM"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-50b30d61be6so934391cf.0
        for <kvmarm@lists.linux.dev>; Sun, 22 Mar 2026 08:56:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774194987; cv=none;
        d=google.com; s=arc-20240605;
        b=DyRLWQ+U+e8kku9OV1SHu82lR+ZSWhtcD9TNsF1/gHt1NqXlJgVig6nxCjUahVPWKx
         g85A4Z7FDsAjntS2xdhvDWP9pAbtV/gXckJXQrjwlzsVk+AOo12wL9nmgeaYxlDfxkey
         iZV8e+knwBQhgyjIVtLx/u2f3MzseESwv8oLrfHFIX265lixD+L3i2Pjj2QkTupzIz86
         qVX5uJoU7qDcGvLpmAKWK72b/N1Uy9s883lkeRa2hJgebtN/4pg1wFBMCuZThjcfk/E6
         4H3ziefw4L19+E0Ei17Q5eLN+PdOOiPs5twUsj1o/IgGelRInRCZ1vco9QHlckcSYNWZ
         Vhmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=FwMDzF2o2m81/v5dw831E3CHWbmSuwWgk63PblsZ1BE=;
        fh=br/O7ad/Dpl82iqHQ050DMUcdTbv2XuF8/c9+X0NSgk=;
        b=UetaVKYxXfPgncplNtiIWtmWO+2dS7hiOjUS2+GgUkBH38QfrD7N6Gta1EhKiWEkNC
         gxkXSjdpaH3ZyUdPIU9/2agL6LSJV9VoF1uj7ElbKjvfU2aCWOnU3yTlDIiUqHVulGBY
         jQoNGrl7UZ98I4hkgnJMcw4DBh9uMO80jQHB2fW0AB4a0Vwq1IXHGTQw+kTfaWTifGok
         HQBJuMASj/ZywJBEfJTkllmr88wtReRSpMINJd8tqqKsxF5LLgZOqq3SYhHPWkVFuFL7
         nJmxGSGDKSrdD32C78Wqh2snLajwlTTCSWIuyGW8CfCL2xtSuQUSg18Vqo1QuWQ2ezpb
         abzQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774194987; x=1774799787; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FwMDzF2o2m81/v5dw831E3CHWbmSuwWgk63PblsZ1BE=;
        b=DEsLBWYMxPto9zLEd9lrGIWerVZ6A10VbP/U1fwAJgSyTVMl8QqmNBk+DANJjRdDt6
         Zr+JyWxVOwkP3/q47eR89KinUGxFez65gxi/0Ro4AYVxOjUVc8xUkEvqRE695NXC9EQs
         UfkH0JjPvZkJrV4JMJHBpCmOYatgr5zzV8krIniSuJns3XzQIOz43DpGEzCVyv1HJG+Y
         fDtb8xGV0a9K7lKMDp2LX00KlxytcAlNPVbwWL8v+cbcuHbQSIv8Wcuc+vgaYhNwoQ8m
         rVw2dnGaW9UInK+MEhlI5C5mKaVe8OLK7jlPjsyj++cCXofn5pvcH1Fcviz+Fd5eMK4d
         RlAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774194987; x=1774799787;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FwMDzF2o2m81/v5dw831E3CHWbmSuwWgk63PblsZ1BE=;
        b=azJRVfT8tOUufCVReyVYwMDXx+Kytxk5r4K53Ol3LVDqm7wBkbDKENFii3MCXaVGLI
         a8oKiKtNoy1v4UQDZIlDdDx+mWkbbfAMjSdwEQ4pE2PaXCJF34jg5IEBnGSSjUhzmio3
         sF5h7fGuW+nHALgRT02LFmCiRYMuDKhfdiYRhJ8+COTB8byCWtq93yn9cEmoqZ4NU4k7
         B33nvcEm90tdYWoiNEJK7n7im4hCiBODlcoLgnbohUznw+qorCehfDT9eF7bDGcC5ozY
         55Q217BDi+6GvDgwkTv6On7C1GHr/DGbTZLDfx8n+kfmZumVMQTsLYKUc/sxPmGcUSl8
         kTgA==
X-Gm-Message-State: AOJu0YxtEkDMDGH7ALKKpYuHJtesB+RiL+Kd9xvKuh52Mliw/wNkaQYY
	6TuqvZw2oYWgcWQIJymMPWQxyfDw22eJXYRyk5K2wxdeu6LNr6Xf/AfUblsrH3jTfv4ytUj0dl0
	1GiTSAxLBo9Lla8wqwBWKKlO2b0WpF/RonheDpNEy
X-Gm-Gg: ATEYQzxBK2PrJ9KcZcHV0VIo6jF/chiTXWdJh23VP/6YfeMiznRTk5Qc83oQmyJqyO7
	K/TSLS1b3JWiCL+xYVTdrrjr50bev4cKNJTunZHy3j/JAnMdDhZRBqi9pzYDtuX1FY1wnmHoYH5
	GhReyqKr9lprgzFvmRkwwdfOeN4JpfRX4z2G0R+7o/nIDlDSRSxTzDsQfxVAwS5XmjpPrlIdsXK
	ixod95ByyGivXQ7vh/OPbwl72QmjdDWLZn/4oftwLTRXybL/xJ1f2TVd/nzckyxZ077sFNc2F+Z
	LpCfTUWK
X-Received: by 2002:a05:622a:5597:b0:509:123c:f317 with SMTP id
 d75a77b69052e-50b46a6754emr18967271cf.0.1774194987102; Sun, 22 Mar 2026
 08:56:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260321212419.2803972-1-maz@kernel.org> <20260321212419.2803972-6-maz@kernel.org>
In-Reply-To: <20260321212419.2803972-6-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Sun, 22 Mar 2026 15:55:50 +0000
X-Gm-Features: AQROBzB171gbCFjgkSVfN6aZYQOGmgdPg7i9k7vMUHnCAcyMTiTZr6INNRnWzgs
Message-ID: <CA+EHjTyRjYBn5UZyz79m4ULV4iW_FLZu7z1LaRwx9FdAQcbKhw@mail.gmail.com>
Subject: Re: [PATCH 5/5] KVM: arm64: Remove extra ISBs when using msr_hcr_el2
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Mostafa Saleh <smostafa@google.com>, Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"

On Sat, 21 Mar 2026 at 21:24, Marc Zyngier <maz@kernel.org> wrote:
>
> The msr_hcr_el2 macro is slightly awkward, as it provides an ISB
> when CONFIG_AMPERE_ERRATUM_AC04_CPU_23 is present, and none
> otherwise. Note that this this option is 'default y', meaning that
> it is likely to be selected.
>
> Most instances of msr_hcr_el2 are also immediately followed by an ISB,
> meaning that in most cases, you end-up with two back-to-back ISBs.
> This isn't a big deal, but once you have seen that, you can't unsee it.
>
> Rework the msr_hcr_el2 macro to always provide the ISB, and drop
> the superfluous ISBs everywhere else.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  arch/arm64/include/asm/el2_setup.h | 2 --
>  arch/arm64/include/asm/sysreg.h    | 6 ++----
>  arch/arm64/kernel/hyp-stub.S       | 1 -
>  arch/arm64/kvm/hyp/nvhe/host.S     | 1 -
>  4 files changed, 2 insertions(+), 8 deletions(-)
>
> diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
> index 85f4c1615472d..3e58d6264581e 100644
> --- a/arch/arm64/include/asm/el2_setup.h
> +++ b/arch/arm64/include/asm/el2_setup.h
> @@ -50,7 +50,6 @@
>          * effectively VHE-only or not.
>          */
>         msr_hcr_el2 x0          // Setup HCR_EL2 as nVHE
> -       isb
>         mov     x1, #1          // Write something to FAR_EL1
>         msr     far_el1, x1
>         isb
> @@ -64,7 +63,6 @@
>  .LnE2H0_\@:
>         orr     x0, x0, #HCR_E2H
>         msr_hcr_el2 x0
> -       isb
>  .LnVHE_\@:
>  .endm
>
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index f4436ecc630cd..ca66b8017fa87 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -1114,11 +1114,9 @@
>         .macro  msr_hcr_el2, reg
>  #if IS_ENABLED(CONFIG_AMPERE_ERRATUM_AC04_CPU_23)
>         dsb     nsh
> -       msr     hcr_el2, \reg
> -       isb
> -#else
> -       msr     hcr_el2, \reg
>  #endif
> +       msr     hcr_el2, \reg
> +       isb                     // Required by AMPERE_ERRATUM_AC04_CPU_23
>         .endm
>  #else
>
> diff --git a/arch/arm64/kernel/hyp-stub.S b/arch/arm64/kernel/hyp-stub.S
> index 085bc9972f6bb..634ddc9042444 100644
> --- a/arch/arm64/kernel/hyp-stub.S
> +++ b/arch/arm64/kernel/hyp-stub.S
> @@ -103,7 +103,6 @@ SYM_CODE_START_LOCAL(__finalise_el2)
>         // Engage the VHE magic!
>         mov_q   x0, HCR_HOST_VHE_FLAGS
>         msr_hcr_el2 x0
> -       isb
>
>         // Use the EL1 allocated stack, per-cpu offset
>         mrs     x0, sp_el1
> diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
> index 465f6f1dd6414..ff10cafa0ca81 100644
> --- a/arch/arm64/kvm/hyp/nvhe/host.S
> +++ b/arch/arm64/kvm/hyp/nvhe/host.S
> @@ -125,7 +125,6 @@ SYM_FUNC_START(__hyp_do_panic)
>         mrs     x0, hcr_el2
>         bic     x0, x0, #HCR_VM
>         msr_hcr_el2 x0
> -       isb
>         tlbi    vmalls12e1
>         dsb     nsh
>  #endif
> --
> 2.47.3
>

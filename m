Return-Path: <SRS0=5TFS=PB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8825C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 13 Oct 2021 05:11:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4ABCE60FDA
	for <kvmarm@archiver.kernel.org>; Wed, 13 Oct 2021 05:11:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4ABCE60FDA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B11794B0F7;
	Wed, 13 Oct 2021 01:11:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id p3pMMm0VubCR; Wed, 13 Oct 2021 01:11:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A06A4B0BE;
	Wed, 13 Oct 2021 01:11:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 067754B08F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 01:11:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1Be85a5eKUWf for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Oct 2021 01:11:05 -0400 (EDT)
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com
 [209.85.214.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B79A440762
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 01:11:05 -0400 (EDT)
Received: by mail-pl1-f181.google.com with SMTP id n11so998631plf.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Oct 2021 22:11:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=P8gf7IINw+jRwIt3X6fN4SZBz4OTW9W5HW6/ZYA0ZrQ=;
 b=OJnnPOpYu7eJYXwdgr0zRBsIp/7JCoJdWnLex1e+Nc59Ox3JrNo/ipy44NWbdZ1Wij
 cYg9Oe3IdKwjLZ3ccjWj/lfARUHUDGXHYczC1qcS8GhYxeGqNfAmOiqjRGIpNbWEKXa2
 Qi9tEO86QIO9mq7K47Docwc+8w/vFa49WJ0i3X1YPZ8DwOrxIaJOvQhs4oTCjIw7XhMs
 85rNypB1vqioXE/4YRebipGjt4G4OJKFB3ozkhVDBnROsdS2D888AzkaK6wai/y9wcPK
 fKZlh7cJKDfsqEQisJ01cAjq66cHlSWqDJ4/mRmAC2HTJLmfX15DM2CV03Md2tO4vBCx
 h8Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=P8gf7IINw+jRwIt3X6fN4SZBz4OTW9W5HW6/ZYA0ZrQ=;
 b=gqnudC1eEmVILNIh2CF5gz7wK95IlDZhs+lwHLtH5l4cUiNpnOiDAbQiNh2QN/uq2S
 MCfO1MvkvTATPCZTy1KNGTTibeDp+nygySYvocJEIqnehq/ph414Eo4ZCucESf7yIMtU
 6tC4sW2L4OIA4GqT7ULcmQdcntQpW3S2v5+tre2nmzahw9KOSXO5+07vzCXDS3VOYShd
 k4swbLsFvA2FTapdnQKlH7gPSaHM4VBlJXtQIfZV0iaYM+squhdMIUreZbHXyQXk6i6d
 PYbNnB6aw488DtxkC9GVlgsj+sbsDR1xRc5ovJ8zXmxHhPJjcjaHJev6tDJVZGQwktHt
 imhQ==
X-Gm-Message-State: AOAM532P/U55SMifC8jN7nhy4mLzwJzcbEFffmleCygoFkos+NG+sbHu
 sM5YRClWK/88IDQbYKl4HFz6z2e5m4cCNA4lY/djIw==
X-Google-Smtp-Source: ABdhPJzuE5GfZRyptpvG0d49NR7yBY6nXSth0Pf0CO5A5fn5OISFtomB4UlZSF8y0nx09KKkz3b+VnV54dmuG26Efq8=
X-Received: by 2002:a17:902:c402:b0:13f:1c07:5a25 with SMTP id
 k2-20020a170902c40200b0013f1c075a25mr24520082plk.38.1634101864597; Tue, 12
 Oct 2021 22:11:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210916181510.963449-1-oupton@google.com>
 <20210916181510.963449-6-oupton@google.com>
In-Reply-To: <20210916181510.963449-6-oupton@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Tue, 12 Oct 2021 22:10:48 -0700
Message-ID: <CAAeT=Fwuy2TT75KmBMgHXkxt++BAc30EUaybkU_V-zix+2Q9zw@mail.gmail.com>
Subject: Re: [PATCH v8 5/8] arm64: cpufeature: Enumerate support for FEAT_ECV
 >= 0x2
To: Oliver Upton <oupton@google.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, Marc Zyngier <maz@kernel.org>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Thu, Sep 16, 2021 at 11:15 AM Oliver Upton <oupton@google.com> wrote:
>
> Introduce a new cpucap to indicate if the system supports full enhanced
> counter virtualization (i.e. ID_AA64MMFR0_EL1.ECV>=0x2).
>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/include/asm/sysreg.h |  1 +
>  arch/arm64/kernel/cpufeature.c  | 10 ++++++++++
>  arch/arm64/tools/cpucaps        |  1 +
>  3 files changed, 12 insertions(+)
>
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index b268082d67ed..3fa6b091384d 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -849,6 +849,7 @@
>  #define ID_AA64MMFR0_ASID_8            0x0
>  #define ID_AA64MMFR0_ASID_16           0x2
>
> +#define ID_AA64MMFR0_ECV_PHYS          0x2
>  #define ID_AA64MMFR0_TGRAN4_NI                 0xf
>  #define ID_AA64MMFR0_TGRAN4_SUPPORTED_MIN      0x0
>  #define ID_AA64MMFR0_TGRAN4_SUPPORTED_MAX      0x7
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index f8a3067d10c6..2f5042bb107c 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -2328,6 +2328,16 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
>                 .matches = has_cpuid_feature,
>                 .min_field_value = 1,
>         },
> +       {
> +               .desc = "Enhanced Counter Virtualization (Physical)",
> +               .capability = ARM64_HAS_ECV2,
> +               .type = ARM64_CPUCAP_SYSTEM_FEATURE,
> +               .sys_reg = SYS_ID_AA64MMFR0_EL1,
> +               .sign = FTR_UNSIGNED,
> +               .field_pos = ID_AA64MMFR0_ECV_SHIFT,
> +               .matches = has_cpuid_feature,
> +               .min_field_value = ID_AA64MMFR0_ECV_PHYS,
> +       },
>         {},
>  };
>
> diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
> index 49305c2e6dfd..f73a30d5fb1c 100644
> --- a/arch/arm64/tools/cpucaps
> +++ b/arch/arm64/tools/cpucaps
> @@ -18,6 +18,7 @@ HAS_CRC32
>  HAS_DCPODP
>  HAS_DCPOP
>  HAS_E0PD
> +HAS_ECV2
>  HAS_EPAN
>  HAS_GENERIC_AUTH
>  HAS_GENERIC_AUTH_ARCH
> --

Reviewed-by: Reiji Watanabe <reijiw@google.com>

Personally, I would prefer a more descriptive name (e.g. ECV_PHYS)
rather than ECV2 though.

Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

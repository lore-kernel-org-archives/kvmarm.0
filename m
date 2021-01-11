Return-Path: <SRS0=NVHA=GO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 645FCC433E0
	for <kvmarm@archiver.kernel.org>; Mon, 11 Jan 2021 16:44:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9F077223C8
	for <kvmarm@archiver.kernel.org>; Mon, 11 Jan 2021 16:44:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9F077223C8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D9C954B2D9;
	Mon, 11 Jan 2021 11:44:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BkOGGkU7PAzv; Mon, 11 Jan 2021 11:44:25 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B14DE4B263;
	Mon, 11 Jan 2021 11:44:25 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 00D694A524
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Jan 2021 09:45:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J1m6G9-+Rtqx for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Jan 2021 09:45:24 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 105C24B2AA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Jan 2021 09:45:24 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id C19C2229CA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Jan 2021 14:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1610376322;
 bh=l6ToqVwqm3E7ql9O4XRtENEPRhqlUUCrKobd4xM3lgg=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=uZZApSfe3FBkwQ18jphBQE5TJf9VCYIcQg1oER0tBBAyxp29dxOxPD2ljGcZiwXvb
 QisYFN8GIZkXjZMiKHlRGvFQQJEjYRAFn9JDenRW8Kwcn0XE4cuPc1xasD9RFWdLCZ
 rEpzO7GRrDHPDyIkZ0TND+BTEwx39IlCN3wmZ0sBzwV6F6nqbwkA/ovLdCtGuozEBd
 dlmaNpQSDPgkq96V2JO3lBcHV8CdHNP8D18tz6LrkF7L9V56DMhVZ4yCokdo/G1F6Z
 L2/aA4Hu1SWwVage5ZwkLSzXgMq1OdlaUENqFCM4kKga+DZFq3vfMk2Sdtgb2FqlBH
 xzP5UFzB1v3uQ==
Received: by mail-qv1-f45.google.com with SMTP id p5so7484504qvs.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Jan 2021 06:45:22 -0800 (PST)
X-Gm-Message-State: AOAM533v7bO/an3qnF/8gbQ9n3Kr2J3Eq1xQZmE6k2e896jibmjx/C15
 SAFD06AxpIgMJuj2uuZwqvymTTJgNRlYT9psmA==
X-Google-Smtp-Source: ABdhPJymgMsMHFwjNXskq64kJCyaSLMJ3Do+hKilu0I/FvQeFX2WQUWySyGObrImhXuZnCRNVT6HEOiCX2LEoJH6Aqs=
X-Received: by 2002:a0c:fe47:: with SMTP id u7mr13111qvs.4.1610376321947; Mon,
 11 Jan 2021 06:45:21 -0800 (PST)
MIME-Version: 1.0
References: <20210108121524.656872-1-qperret@google.com>
 <20210108121524.656872-16-qperret@google.com>
In-Reply-To: <20210108121524.656872-16-qperret@google.com>
From: Rob Herring <robh+dt@kernel.org>
Date: Mon, 11 Jan 2021 08:45:10 -0600
X-Gmail-Original-Message-ID: <CAL_JsqLmzFWmTc=6JSRMofSEVRx9GCrwGxEsYog9dC16EMGdvQ@mail.gmail.com>
Message-ID: <CAL_JsqLmzFWmTc=6JSRMofSEVRx9GCrwGxEsYog9dC16EMGdvQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 15/26] of/fdt: Introduce
 early_init_dt_add_memory_hyp()
To: Quentin Perret <qperret@google.com>
X-Mailman-Approved-At: Mon, 11 Jan 2021 11:44:23 -0500
Cc: devicetree@vger.kernel.org, Android Kernel Team <kernel-team@android.com>,
 Frank Rowand <frowand.list@gmail.com>, android-kvm@google.com,
 Catalin Marinas <catalin.marinas@arm.com>, Fuad Tabba <tabba@google.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>
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

On Fri, Jan 8, 2021 at 6:16 AM Quentin Perret <qperret@google.com> wrote:
>
> Introduce early_init_dt_add_memory_hyp() to allow KVM to conserve a copy
> of the memory regions parsed from DT. This will be needed in the context
> of the protected nVHE feature of KVM/arm64 where the code running at EL2
> will be cleanly separated from the host kernel during boot, and will
> need its own representation of memory.

What happened to doing this with memblock?

> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  drivers/of/fdt.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
> index 4602e467ca8b..af2b5a09c5b4 100644
> --- a/drivers/of/fdt.c
> +++ b/drivers/of/fdt.c
> @@ -1099,6 +1099,10 @@ int __init early_init_dt_scan_chosen(unsigned long node, const char *uname,
>  #define MAX_MEMBLOCK_ADDR      ((phys_addr_t)~0)
>  #endif
>
> +void __init __weak early_init_dt_add_memory_hyp(u64 base, u64 size)
> +{
> +}
> +
>  void __init __weak early_init_dt_add_memory_arch(u64 base, u64 size)
>  {
>         const u64 phys_offset = MIN_MEMBLOCK_ADDR;
> @@ -1139,6 +1143,7 @@ void __init __weak early_init_dt_add_memory_arch(u64 base, u64 size)
>                 base = phys_offset;
>         }
>         memblock_add(base, size);
> +       early_init_dt_add_memory_hyp(base, size);
>  }
>
>  int __init __weak early_init_dt_mark_hotplug_memory_arch(u64 base, u64 size)
> --
> 2.30.0.284.gd98b1dd5eaa7-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

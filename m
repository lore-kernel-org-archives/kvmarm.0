Return-Path: <SRS0=E7bu=XG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9361C4740A
	for <kvmarm@archiver.kernel.org>; Wed, 11 Sep 2019 04:27:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4A43F21A4C
	for <kvmarm@archiver.kernel.org>; Wed, 11 Sep 2019 04:27:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="Hs+rUzHv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4A43F21A4C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=socionext.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A7F384A5F0;
	Wed, 11 Sep 2019 00:27:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@nifty.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fUG04VdQ8Pn3; Wed, 11 Sep 2019 00:27:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 81F1C4A5E5;
	Wed, 11 Sep 2019 00:27:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 428384A529
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Sep 2019 00:27:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SGaNKHPNJjyw for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Sep 2019 00:27:41 -0400 (EDT)
Received: from conssluserg-06.nifty.com (conssluserg-06.nifty.com
 [210.131.2.91])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3B0F94A500
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Sep 2019 00:27:41 -0400 (EDT)
Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com
 [209.85.221.171]) (authenticated)
 by conssluserg-06.nifty.com with ESMTP id x8B4RYcV023396
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Sep 2019 13:27:35 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-06.nifty.com x8B4RYcV023396
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
 s=dec2015msa; t=1568176055;
 bh=2bJShX4Ff3PHK48gMEQzP3cEPpqbzfOY7VjrtVo5UdE=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=Hs+rUzHvcvyixmd4WHBymTPg9eM8TpjwUJ4vFyDVkUagWGjFfo6xJO3TNLLOECcA2
 8TH0W6loMI2+LzBH7C605ynFFMC2F2gI45BKaNhtOz/7LWgN539M79Ztbbz5plvDXf
 DbnWn24NDIR08VdXE8cd5pIKq6i+vo3K+UtJf2lyAwYHMJBKywvf9pwVhdzzp55reQ
 rv9WMwPpA4rIDguE1ZVDSINae+++fzo7xyd27gWzOy567gshnqNw2YNmRs7n5HUplr
 H1XLV9mI+WxV2Y6wMgheXjKbwJJZ9PP9Y2XfP8D+mw2ltPYiB6MuZBH5ozMyqMPTLa
 G4cuVSLNech7w==
X-Nifty-SrcIP: [209.85.221.171]
Received: by mail-vk1-f171.google.com with SMTP id b25so4066096vkk.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Sep 2019 21:27:35 -0700 (PDT)
X-Gm-Message-State: APjAAAWWSEfXhLF0le3mwj6Z11ovfgPePeIf2r8y37X90q0rYAioLl4I
 4u92WPVFU8b1kcFmdgOVdvoXwEsO9GbOnmJvO5E=
X-Google-Smtp-Source: APXvYqxcC7v9qXKkiFdYOioajynW6ENkts6eVJhzv73g0b3GlVu6ohGHdS3vnp8EInycfekShhmHhrgynXloMMplkJc=
X-Received: by 2002:a1f:2343:: with SMTP id j64mr12520866vkj.84.1568176054022; 
 Tue, 10 Sep 2019 21:27:34 -0700 (PDT)
MIME-Version: 1.0
References: <1568169216-12632-1-git-send-email-yuzenghui@huawei.com>
 <1568169216-12632-2-git-send-email-yuzenghui@huawei.com>
In-Reply-To: <1568169216-12632-2-git-send-email-yuzenghui@huawei.com>
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Date: Wed, 11 Sep 2019 13:26:58 +0900
X-Gmail-Original-Message-ID: <CAK7LNARPo6VgzXn5kfrL7MWRtBoNf83yCM0r8jZ0iURU_to_BA@mail.gmail.com>
Message-ID: <CAK7LNARPo6VgzXn5kfrL7MWRtBoNf83yCM0r8jZ0iURU_to_BA@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: arm/arm64: vgic: Use the appropriate
 TRACE_INCLUDE_PATH
To: Zenghui Yu <yuzenghui@huawei.com>
Cc: maz@kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
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

On Wed, Sep 11, 2019 at 11:35 AM Zenghui Yu <yuzenghui@huawei.com> wrote:
>
> Commit 49dfe94fe5ad ("KVM: arm/arm64: Fix TRACE_INCLUDE_PATH") fixes
> TRACE_INCLUDE_PATH to the correct relative path to the define_trace.h
> and explains why did the old one work.
>
> The same fix should be applied to virt/kvm/arm/vgic/trace.h.
>
> Cc: Masahiro Yamada <yamada.masahiro@socionext.com>

Please feel free to replace the Cc: with my:

Reviewed-by: Masahiro Yamada <yamada.masahiro@socionext.com>


Thanks.


> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
> ---
>  virt/kvm/arm/vgic/trace.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/virt/kvm/arm/vgic/trace.h b/virt/kvm/arm/vgic/trace.h
> index 55fed77a9f73..4fd4f6db181b 100644
> --- a/virt/kvm/arm/vgic/trace.h
> +++ b/virt/kvm/arm/vgic/trace.h
> @@ -30,7 +30,7 @@ TRACE_EVENT(vgic_update_irq_pending,
>  #endif /* _TRACE_VGIC_H */
>
>  #undef TRACE_INCLUDE_PATH
> -#define TRACE_INCLUDE_PATH ../../../virt/kvm/arm/vgic
> +#define TRACE_INCLUDE_PATH ../../virt/kvm/arm/vgic
>  #undef TRACE_INCLUDE_FILE
>  #define TRACE_INCLUDE_FILE trace
>
> --
> 2.19.1
>
>


-- 
Best Regards
Masahiro Yamada
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

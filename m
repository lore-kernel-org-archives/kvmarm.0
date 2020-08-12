Return-Path: <SRS0=ktB0=BW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B401C433E0
	for <kvmarm@archiver.kernel.org>; Wed, 12 Aug 2020 15:15:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C08CC20756
	for <kvmarm@archiver.kernel.org>; Wed, 12 Aug 2020 15:15:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ji3ujXG4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C08CC20756
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BE254B936;
	Wed, 12 Aug 2020 11:15:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id u0cPXDQSnh92; Wed, 12 Aug 2020 11:15:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E4834B93E;
	Wed, 12 Aug 2020 11:15:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 29A034B881
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Aug 2020 10:14:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3W8SyQ-Uthct for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 Aug 2020 10:14:31 -0400 (EDT)
Received: from mail-io1-f67.google.com (mail-io1-f67.google.com
 [209.85.166.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0C2A44B7D0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Aug 2020 10:14:31 -0400 (EDT)
Received: by mail-io1-f67.google.com with SMTP id t15so2739013iob.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Aug 2020 07:14:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=6ZQJCz6ZARealcaqV3Vtg82OvzrrRkBSR1fKybIKT2g=;
 b=Ji3ujXG4T/iF/h/G7kfHNwvF3on8deZsG8L2/3acg8S3usLxgwLobDImrnDC3cpd6b
 iELe/6zOoibVZtn5AGCT5H9FGZu5hkCKGjXz3IRbD54a2l1jIefc45WbXmk5ZdetH5vl
 rlP9RXagMtIAydEkujxSrHGWO9Y9JrLbrnjD3OuC1b1O3vTQ+tRK3theMG9F5B4x9dwh
 abY68cQ68kVvw+pzczUZbyepndT3pzJlLJAZQvm3H6FNdjP/MLZaHenQnawy9u38TzQx
 pHff551BSXl7zvqoS/MUlNDy0AU2uC1JtMpYfLJ2pRGGTlc+jsbiUDY6V0n1LblHvvpj
 6IDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=6ZQJCz6ZARealcaqV3Vtg82OvzrrRkBSR1fKybIKT2g=;
 b=gcY85Ey9ycTBpqA46mvFE5FFnhq2Rn2CtHAI7HaAeq1Lf97H74sicufHqoAF9PL5fq
 krbDJrKXMuUHoPVc3FZh/9+uo9/r3WRwL1ZAHQc6mHbrbnI0+IPuNbxBeUpHkYcAkhu5
 IFmyYfiUE1jOvi1hY0obhaRCgNcTGNHZ3i73fAgl7ja46vx+tYIWEbQ0wyXx9Ib9drLG
 Yo4R6MsFfK7dop7FPHH1+e8Ysexvraz/QWfGz1q80KPvsdR2S7mfzKvDNfGRys9ebPDv
 uDWSoK7l1lRsgiwh4SBFmLb/pkRJ8nBt+ETqcpfXpYXd3JvsXMIfEZVUzRMKo+69nEZp
 VTAQ==
X-Gm-Message-State: AOAM531dezx4jTJveGLlYatP6Zxj2UzlOFOlKO1ncSGdmehIQXDw2sLI
 zg2gikZzlJjIRZm8VU7UHxGQwUsV8yBqD9AhgZCYDqg=
X-Google-Smtp-Source: ABdhPJzdzjga7OjknlcUJhDPPCoe83EeaXoUFKDNZsEcPu737G9o632u8ssm/kigIdFRHnxySCbwcHHgvlZH9m4x96s=
X-Received: by 2002:a02:c789:: with SMTP id n9mr31311563jao.40.1597241669954; 
 Wed, 12 Aug 2020 07:14:29 -0700 (PDT)
MIME-Version: 1.0
References: <1597241133-3630-1-git-send-email-kernelfans@gmail.com>
In-Reply-To: <1597241133-3630-1-git-send-email-kernelfans@gmail.com>
From: Pingfan Liu <kernelfans@gmail.com>
Date: Wed, 12 Aug 2020 22:14:17 +0800
Message-ID: <CAFgQCTuaQpePYJx1WA48QdsW62dT_s=dF8zrWXboV-pN0tyNqg@mail.gmail.com>
Subject: Re: [PATCH] arm(64)/kvm: improve the documentation about HVC calls
To: kvmarm@lists.cs.columbia.edu
X-Mailman-Approved-At: Wed, 12 Aug 2020 11:15:16 -0400
Cc: linux-doc@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Russell King <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org
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

This issue is detected by Morse
(https://lore.kernel.org/linux-arm-kernel/9b0da257-785b-90ba-de3c-b9ee9ccdeeba@arm.com/)
during the discussion for my patch.

I am not quite sure about the arm, but based on the note at the head
of arm/kernel/head.S, things should go that way. If any mistake,
please correct me.

Thanks,
Pingfan

On Wed, Aug 12, 2020 at 10:05 PM Pingfan Liu <kernelfans@gmail.com> wrote:
>
> Both arm and arm64 kernel entry point have the following prerequisite:
>   MMU = off, D-cache = off, I-cache = dont care.
>
> HVC_SOFT_RESTART call should meet this prerequisite before jumping to the
> new kernel.
>
> Furthermore, on arm64, el2_setup doesn't set I+C bits and keeps EL2 MMU
> off, and KVM resets them when its unload. These are achieved by
> HVC_RESET_VECTORS call.
>
> Improve the document.
>
> Signed-off-by: Pingfan Liu <kernelfans@gmail.com>
> Cc: James Morse <james.morse@arm.com>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Julien Thierry <julien.thierry.kdev@gmail.com>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: linux-doc@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> To: kvmarm@lists.cs.columbia.edu
> ---
>  Documentation/virt/kvm/arm/hyp-abi.rst | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/virt/kvm/arm/hyp-abi.rst b/Documentation/virt/kvm/arm/hyp-abi.rst
> index d9eba93..a95bc30 100644
> --- a/Documentation/virt/kvm/arm/hyp-abi.rst
> +++ b/Documentation/virt/kvm/arm/hyp-abi.rst
> @@ -40,9 +40,9 @@ these functions (see arch/arm{,64}/include/asm/virt.h):
>
>  * ::
>
> -    r0/x0 = HVC_RESET_VECTORS
> +    x0 = HVC_RESET_VECTORS (arm64 only)
>
> -  Turn HYP/EL2 MMU off, and reset HVBAR/VBAR_EL2 to the initials
> +  Disable HYP/EL2 MMU and D-cache, and reset HVBAR/VBAR_EL2 to the initials
>    stubs' exception vector value. This effectively disables an existing
>    hypervisor.
>
> @@ -54,7 +54,7 @@ these functions (see arch/arm{,64}/include/asm/virt.h):
>      x3 = x1's value when entering the next payload (arm64)
>      x4 = x2's value when entering the next payload (arm64)
>
> -  Mask all exceptions, disable the MMU, move the arguments into place
> +  Mask all exceptions, disable the MMU and D-cache, move the arguments into place
>    (arm64 only), and jump to the restart address while at HYP/EL2. This
>    hypercall is not expected to return to its caller.
>
> --
> 2.7.5
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

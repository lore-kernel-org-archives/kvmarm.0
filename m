Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CDA5C43334
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jul 2022 09:08:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 960A74D40B;
	Mon, 18 Jul 2022 05:08:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JcvMtfJwKaMI; Mon, 18 Jul 2022 05:08:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 58AAF4D405;
	Mon, 18 Jul 2022 05:08:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F090C4D39F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 05:08:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZZVmqnlS+UQx for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jul 2022 05:08:46 -0400 (EDT)
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com
 [209.85.210.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E8E654D39D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 05:08:45 -0400 (EDT)
Received: by mail-ot1-f51.google.com with SMTP id
 r22-20020a056830419600b0061c6edc5dcfso8688428otu.12
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 02:08:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=gyN4R4wxoBxOYspFa5dE/mkU9oa9JodtT8mt47nKD20=;
 b=ASu0WTSHFZTnJxmWsucJT2xg3U3pJ9JDjAT++73osXtDgaNaPEkLXxKn9fjFQcesZj
 yuq/KorlL6gF9V0/pWqQYG22JPWrtGnBN2d5mSNRUcFLAbQGia5AUKLBQZcUQTUEe+8f
 /rgjgMTabag6/QWzBowTZNAEZZ25J1dA5junzkGMbt9uzzpKZYyAVrQpF4VwEeJWXRqv
 qRUzxeOE1sPEh49iMO/ukNr+EJegIACLVSWu5WgBqAV0C4gP+hn21xpL5D4S0Wq1n+bc
 PkjrHpQGP1LL7SAVgne+3TtKgXudqRHaX00bbazPD6Iy/45iHIVZfSAbvz6Ij3gi00MZ
 MViQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=gyN4R4wxoBxOYspFa5dE/mkU9oa9JodtT8mt47nKD20=;
 b=vRsS9gMJVMMM03Wgfo5pFhS2zTE6zfvVPavukzIhRQIS7GOvs29JFogK52sAswCCBZ
 0C4iddgep5KGLna8eKTzog7+J9bKoVmmmohrv3FDS9LSWe8pMDXDfCpW1Y01V801ASBN
 NLANOlzNqZIIl14z7Em+nHMrNdKPHiw84A8VWeaeLc+GoR9Giu4AdKOzaLdxPfqCVnCO
 d4JUaJwit1VLZnWZghbk1Y8+3RsUj3RwlEKcNfcHlBZVPM79TD8PWBa0sFirUFe2UtlU
 /lV3th804DwIUA4uLGfn15cJrbCuJeiuIyf5X0er1QCznuPhE4ppSpUIyU8iLoWDol9J
 QD2w==
X-Gm-Message-State: AJIora+I09x63oPGigqnTxJy1WoKq7AoCsdKT+xYkgDckGuVdw1ezXT1
 nTyrjNl6BLxxYaxZGL1gv2q6FpCm1tdhTdrx+VpseA==
X-Google-Smtp-Source: AGRyM1trl6Ac86+5L4VHnfQf/LcT7deUAzD+vON1lIJfOtePo+yI0pY7we08AjsL5W7qoPc56zZ6NTGNdM9naMbHcpg=
X-Received: by 2002:a05:6830:108a:b0:61c:9fb5:6784 with SMTP id
 y10-20020a056830108a00b0061c9fb56784mr1754550oto.299.1658135325046; Mon, 18
 Jul 2022 02:08:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220715235824.2549012-1-kaleshsingh@google.com>
In-Reply-To: <20220715235824.2549012-1-kaleshsingh@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 18 Jul 2022 10:08:08 +0100
Message-ID: <CA+EHjTxXX_d8M9VGCBokoKCCuvOoR_1u4JrSNKPTdN3qp9bQog@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Fix hypervisor address symbolization
To: Kalesh Singh <kaleshsingh@google.com>
Cc: android-mm@google.com, kernel-team@android.com, maz@kernel.org,
 linux-kernel@vger.kernel.org, madvenka@linux.microsoft.com, broonie@kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Hi Kalesh,

On Sat, Jul 16, 2022 at 12:58 AM Kalesh Singh <kaleshsingh@google.com> wrote:
>
> With CONFIG_RANDOMIZE_BASE=y vmlinux addresses will resolve correctly
> from kallsyms. Fix this by adding the KASLR offset before printing the
> symbols.
>
> Based on arm64 for-next/stacktrace.
>
> Fixes: 6ccf9cb557bd ("KVM: arm64: Symbolize the nVHE HYP addresses")
> Reported-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> ---

Even with this patch applied I still don't get symbolization unless I
disable randomization, either by setting CONFIG_RANDOMIZE_BASE=n or
pass nokaslr as a kernel parameter. I tried both and in either case it
works.

Thanks,
/fuad


>  arch/arm64/kvm/handle_exit.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index f66c0142b335..e43926ef2bc2 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -347,10 +347,10 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
>                         kvm_err("nVHE hyp BUG at: %s:%u!\n", file, line);
>                 else
>                         kvm_err("nVHE hyp BUG at: [<%016llx>] %pB!\n", panic_addr,
> -                                       (void *)panic_addr);
> +                                       (void *)(panic_addr + kaslr_offset()));
>         } else {
>                 kvm_err("nVHE hyp panic at: [<%016llx>] %pB!\n", panic_addr,
> -                               (void *)panic_addr);
> +                               (void *)(panic_addr + kaslr_offset()));
>         }
>
>         /*
>
> base-commit: 82a592c13b0aeff94d84d54183dae0b26384c95f
> --
> 2.37.0.170.g444d1eabd0-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

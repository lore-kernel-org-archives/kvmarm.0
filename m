Return-Path: <SRS0=VMV7=EY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBDC6C63777
	for <kvmarm@archiver.kernel.org>; Wed, 18 Nov 2020 10:39:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2BBF420782
	for <kvmarm@archiver.kernel.org>; Wed, 18 Nov 2020 10:39:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="uzOYWmAF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2BBF420782
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E64A4B5AD;
	Wed, 18 Nov 2020 05:39:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id t3QQVNomoDuW; Wed, 18 Nov 2020 05:39:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FD2F4B79D;
	Wed, 18 Nov 2020 05:39:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 49FF44B759
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 14:45:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qjXSIBLi+5JL for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Nov 2020 14:45:07 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2AC974B6A7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 14:45:07 -0500 (EST)
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com
 [209.85.210.52])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id E3FB32465E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 19:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1605642306;
 bh=qNozKMsilVGHcKuDFqYgNc1oR4jJ69WTtekuHemKsA4=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=uzOYWmAFsp5u8A1goye7laB+uln8gqXV99XauIwSEYwYTGXnrkndJ1sdA0QPbsHW/
 uXFPVcvnzkLe+GYCOMvNnDStRP9jwZYNOFkt+AwKP1ltA3sG4bxugT2gpWZQD9Krqq
 7zwau8mE4xSeZENQKfIlP12S23rRKNZejLI/7ECQ=
Received: by mail-ot1-f52.google.com with SMTP id k3so20597653otp.12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 11:45:05 -0800 (PST)
X-Gm-Message-State: AOAM530T4gU9PzjpcbL0pTGcVW8lAbbkX4/doKQjMPC5tgOeeAtR2taR
 kuSQJv2Lze5Me0ELbrByImw+a1Qpuq5lO4Xw7A==
X-Google-Smtp-Source: ABdhPJw7Y8/Ws5bUvi26+LLUZzk81vYwcXh6i4hVHe44wC1JXmPPzqpT+2F4tA2/k2KaDRk1Kh11f9DUxexOONIhShQ=
X-Received: by 2002:a05:6830:2259:: with SMTP id
 t25mr4284277otd.192.1605642305060; 
 Tue, 17 Nov 2020 11:45:05 -0800 (PST)
MIME-Version: 1.0
References: <20201117181607.1761516-1-qperret@google.com>
 <20201117181607.1761516-16-qperret@google.com>
In-Reply-To: <20201117181607.1761516-16-qperret@google.com>
From: Rob Herring <robh+dt@kernel.org>
Date: Tue, 17 Nov 2020 13:44:53 -0600
X-Gmail-Original-Message-ID: <CAL_Jsq+xAy9+HjH6vqfmaAEKBe9MMm+wWvUtiz5dFnHmMneqNw@mail.gmail.com>
Message-ID: <CAL_Jsq+xAy9+HjH6vqfmaAEKBe9MMm+wWvUtiz5dFnHmMneqNw@mail.gmail.com>
Subject: Re: [RFC PATCH 15/27] of/fdt: Introduce early_init_dt_add_memory_hyp()
To: Quentin Perret <qperret@google.com>
X-Mailman-Approved-At: Wed, 18 Nov 2020 05:39:23 -0500
Cc: "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE"
 <devicetree@vger.kernel.org>, Android Kernel Team <kernel-team@android.com>,
 Frank Rowand <frowand.list@gmail.com>, android-kvm@google.com,
 Catalin Marinas <catalin.marinas@arm.com>,
 open list <linux-kernel@vger.kernel.org>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>,
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

On Tue, Nov 17, 2020 at 12:16 PM Quentin Perret <qperret@google.com> wrote:
>
> Introduce early_init_dt_add_memory_hyp() to allow KVM to conserve a copy
> of the memory regions parsed from DT. This will be needed in the context
> of the protected nVHE feature of KVM/arm64 where the code running at EL2
> will be cleanly separated from the host kernel during boot, and will
> need its own representation of memory.
>
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

Can this be done right after we add all the memblocks using the
memblock API? I thought EFI would also need to be handled, but looks
like it just calls early_init_dt_add_memory_arch(). That's odd
especially for ACPI systems...

I don't really like putting what looks like an arm64 only hook here,
but then I don't want an arm64 version of
early_init_dt_add_memory_arch() either. We're almost to the point of
getting rid of the arch specific ones. But I don't have a better
suggestion currently.

Rob
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <SRS0=ZMJ6=GP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B029C433DB
	for <kvmarm@archiver.kernel.org>; Tue, 12 Jan 2021 18:34:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E58142311D
	for <kvmarm@archiver.kernel.org>; Tue, 12 Jan 2021 18:34:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E58142311D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A7C24B121;
	Tue, 12 Jan 2021 13:34:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vUswsAU++mqw; Tue, 12 Jan 2021 13:34:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5248C4B20C;
	Tue, 12 Jan 2021 13:34:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 644284B184
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jan 2021 09:11:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1-q0U8iWgg8l for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Jan 2021 09:11:01 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3AD2D4B139
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jan 2021 09:11:01 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id B79672311E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jan 2021 14:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1610460660;
 bh=ENjvy0Q+qTvAHdvM+Qmza6RORATL3UTnpgk5t6Fv8PI=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=mphXnHHH/En5/hD5AimJ8saRejozTzE62sfESXc7Y2zl3e1De2wZO1IfoMwXpCkFY
 De5L2nsnW3OXvxQdhWQiCnf39axqCTxl2sAyVR1XemnW6F2q4XY+FMm0HON9Mrlc+p
 MMognZH2hB6+nF76s6yHRfk3sGjc+wdF3VlsXGF4G7535aJpjSDzwLAdQnXmEoITg3
 +G9VPlEZBR9TbFJqySq6K24M8jj8wDCg058Ke8iUgtXaeZQzbFguFImH3kChDwPsEE
 GwpZ3+juOsZbsVJV/PKK49oESCsOP8aBsjKL3peEvgSbTcz1+Nv1KANaZ0Yuo4Qsod
 am+Nkrsc5HimA==
Received: by mail-ej1-f44.google.com with SMTP id n26so3703044eju.6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jan 2021 06:10:59 -0800 (PST)
X-Gm-Message-State: AOAM53074B7Gtij0GLTG82BdemYG31tXdosrDleM8fkCvMWtKMML9BNN
 0obWffsnO0NznonggG33i12Z6seqsIAe0MlgCQ==
X-Google-Smtp-Source: ABdhPJx6WBuO0b55qgrKmXulVdShGTlUCuYQZf9Q+loZi3a9rgL14J1g8duqmSuDSOBd2TTPv+EqXRc4W6wxFsUnUP4=
X-Received: by 2002:a17:906:d784:: with SMTP id
 pj4mr3277745ejb.360.1610460658215; 
 Tue, 12 Jan 2021 06:10:58 -0800 (PST)
MIME-Version: 1.0
References: <20210108121524.656872-1-qperret@google.com>
 <20210108121524.656872-16-qperret@google.com>
 <CAL_JsqLmzFWmTc=6JSRMofSEVRx9GCrwGxEsYog9dC16EMGdvQ@mail.gmail.com>
 <X/1xN2UxiUxkzAiN@google.com>
In-Reply-To: <X/1xN2UxiUxkzAiN@google.com>
From: Rob Herring <robh+dt@kernel.org>
Date: Tue, 12 Jan 2021 08:10:47 -0600
X-Gmail-Original-Message-ID: <CAL_Jsq+5d+Ox_-m_Rd83R9xoZb6e2cxCNfbL8YPzKdwj=y0M8Q@mail.gmail.com>
Message-ID: <CAL_Jsq+5d+Ox_-m_Rd83R9xoZb6e2cxCNfbL8YPzKdwj=y0M8Q@mail.gmail.com>
Subject: Re: [RFC PATCH v2 15/26] of/fdt: Introduce
 early_init_dt_add_memory_hyp()
To: Quentin Perret <qperret@google.com>
X-Mailman-Approved-At: Tue, 12 Jan 2021 13:34:20 -0500
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

On Tue, Jan 12, 2021 at 3:51 AM Quentin Perret <qperret@google.com> wrote:
>
> On Monday 11 Jan 2021 at 08:45:10 (-0600), Rob Herring wrote:
> > On Fri, Jan 8, 2021 at 6:16 AM Quentin Perret <qperret@google.com> wrote:
> > >
> > > Introduce early_init_dt_add_memory_hyp() to allow KVM to conserve a copy
> > > of the memory regions parsed from DT. This will be needed in the context
> > > of the protected nVHE feature of KVM/arm64 where the code running at EL2
> > > will be cleanly separated from the host kernel during boot, and will
> > > need its own representation of memory.
> >
> > What happened to doing this with memblock?
>
> I gave it a go, but as mentioned in v1, I ran into issues for nomap
> regions. I want the hypervisor to know about these memory regions (it's
> possible some of those will be given to protected guests for instance)
> but these seem to be entirely removed from the memblocks when using DT:
>
> https://elixir.bootlin.com/linux/latest/source/drivers/of/fdt.c#L1153
>
> EFI appears to do things differently, though, as it 'just' uses
> memblock_mark_nomap() instead of actively removing the memblock. And that
> means I could actually use the memblock API for EFI, but I'd rather
> have a common solution. I tried to understand why things are done
> differently but couldn't find an answer and kept things simple and
> working for now.
>
> Is there a good reason for not using memblock_mark_nomap() with DT? If
> not, I'm happy to try that.

There were 2 patches to do that, but it never got resolved. See here[1].

Rob

[1] https://lore.kernel.org/linux-devicetree/?q=s%3Ano-map
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

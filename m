Return-Path: <SRS0=VYoy=N6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2006C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  8 Sep 2021 01:21:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 08AAB6113E
	for <kvmarm@archiver.kernel.org>; Wed,  8 Sep 2021 01:21:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 08AAB6113E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C8FE4B0D6;
	Tue,  7 Sep 2021 21:21:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MOhxcneRueye; Tue,  7 Sep 2021 21:21:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 847BF4B099;
	Tue,  7 Sep 2021 21:21:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 140144B099
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Sep 2021 21:21:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MBc38wMhpH6U for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Sep 2021 21:21:54 -0400 (EDT)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com
 [209.85.208.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 016EF4A3A5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Sep 2021 21:21:53 -0400 (EDT)
Received: by mail-lj1-f179.google.com with SMTP id s3so652866ljp.11
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Sep 2021 18:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=KeNC+xKtdDu6RTTBHmLc6/GMNcuVkbNM9xz7wbPcFt0=;
 b=C6PQPdgaqWvNpRQJzk5mjGikGCmfGfZG6rs53tEoPAr3c11GXY1RIpPL0qf6HG9P/q
 buUN59vo7ouy1QSmlby8yYm1wVmLwMwpc1iVPBhRRbnPvV0yJw5yxAIE+y3FaQUUj6m6
 jtnD2rlG0gohDBQoliNzFByxIk8SASTAWndDbDhzyqVcVMaVS1fcQEeSrQQ+On5tk+t7
 TFzlKpyVYDZg+krdIr/p9gjuQ56GYB8DyajIIcfPrdBMQhQaM7srg46y+/qN5qzhBxLW
 l3X5zWdH3fOA4/uIid1YC0k13YVW7Ce5EwvKIDLzcGWvocmo7GGtO4/R2Nqi2DAYHUn8
 PfIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=KeNC+xKtdDu6RTTBHmLc6/GMNcuVkbNM9xz7wbPcFt0=;
 b=CEniNHT92FrqniDjz6Ye8bQ/u31PFWsCIi3bIlMmOlCyGUrFPsMPCyNM4qnyxVD0J+
 BsBCp3NIwZ/3+4xfDAj+jbTZtPWJ/Ha9S++6G0CoJyUsaTAij1w5SH1gyCOsju1/pk8+
 vXeEg3vIeCbFO0Gmsc8HYFT6XCfdlItQpAmRDJnODrXLHSbYSKudBVOiRoHS0egYz6g9
 6QZk68u+yS4IbwTLsQ914O1B6HRITxTqh1RMJ57b3cyikzwcOi6NV22Agjl0aGdwnND3
 Nauk4tmHDMGwiZk+bWyfBGjJ05QNRNEkJrBGVqv++TL5XJP7bvXn3w0BgxCFenWWIksQ
 1dvQ==
X-Gm-Message-State: AOAM5305V2ipCCiAudt/MmRDWaB+s7VbRdaCXPLQp2Fi17d5t5sY42ms
 gyy5NPviqdUlMXXflUJK+xwp/P711yFrBfr/fmFfEw==
X-Google-Smtp-Source: ABdhPJxmk5JpnPt/l3GLD8X4Z8zmvHTEhjebR5aPXNGM2ng2gIkRYC0aVcx89Tzi5a7HpVOXBJqnUniHbq1Mb2Oqxyc=
X-Received: by 2002:a2e:a0c8:: with SMTP id f8mr790291ljm.170.1631064112393;
 Tue, 07 Sep 2021 18:21:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210907123112.10232-1-justin.he@arm.com>
 <20210907123112.10232-2-justin.he@arm.com>
In-Reply-To: <20210907123112.10232-2-justin.he@arm.com>
From: Oliver Upton <oupton@google.com>
Date: Tue, 7 Sep 2021 20:21:40 -0500
Message-ID: <CAOQ_QshwO2AtzKTNZJ1FXWTuvdvnxnLQxej1UpLAqVrJC_oCgw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] KVM: arm64: vgic: Add memcg accounting to vgic
 allocations
To: Jia He <justin.he@arm.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>,
 Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Kees Cook <keescook@chromium.org>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 Liu Shixin <liushixin2@huawei.com>, Sami Tolvanen <samitolvanen@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Xiaoming Ni <nixiaoming@huawei.com>,
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

On Tue, Sep 7, 2021 at 7:33 AM Jia He <justin.he@arm.com> wrote:
>
> Inspired by commit 254272ce6505 ("kvm: x86: Add memcg accounting to KVM
> allocations"), it would be better to make arm64 vgic consistent with
> common kvm codes.
>
> The memory allocations of VM scope should be charged into VM process
> cgroup, hence change GFP_KERNEL to GFP_KERNEL_ACCOUNT.
>
> There remain a few cases since these allocations are global, not in VM
> scope.
>
> Signed-off-by: Jia He <justin.he@arm.com>
> ---
>  arch/arm64/kvm/vgic/vgic-init.c    |  2 +-
>  arch/arm64/kvm/vgic/vgic-irqfd.c   |  2 +-
>  arch/arm64/kvm/vgic/vgic-its.c     | 14 +++++++-------
>  arch/arm64/kvm/vgic/vgic-mmio-v3.c |  2 +-
>  arch/arm64/kvm/vgic/vgic-v4.c      |  2 +-
>  5 files changed, 11 insertions(+), 11 deletions(-)
>

Reviewed-by: Oliver Upton <oupton@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

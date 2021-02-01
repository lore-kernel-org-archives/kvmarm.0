Return-Path: <SRS0=CHPd=HD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A3D3C433DB
	for <kvmarm@archiver.kernel.org>; Mon,  1 Feb 2021 15:01:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7076664EA4
	for <kvmarm@archiver.kernel.org>; Mon,  1 Feb 2021 15:01:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7076664EA4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B2E1F4B3A8;
	Mon,  1 Feb 2021 10:01:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AxIeI-uUID9M; Mon,  1 Feb 2021 10:01:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BE1B4B3A9;
	Mon,  1 Feb 2021 10:01:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 39ECB4B3A5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Feb 2021 10:01:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jMffO-mEmnjy for <kvmarm@lists.cs.columbia.edu>;
 Mon,  1 Feb 2021 10:01:18 -0500 (EST)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com
 [209.85.208.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0F9D34B2D5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Feb 2021 10:01:18 -0500 (EST)
Received: by mail-ed1-f44.google.com with SMTP id d2so19235800edz.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 01 Feb 2021 07:01:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=hZ3xD2/2lcYcAhtu708AbjR6mIFxqFO7i7RlxJAZ5ZU=;
 b=vgNYmiNTNpQzx2jV86jycjLWMXZ6nJ4tSwFTGE5x9SuV+VLEyH6rZomNo5oqBVo48Z
 DsUNK+cQyv8QkSJJyXCZV4tv7cR0lGYCjwpm+TwjNSzGMAIRQxs9GEmw8ufWoEShxBYa
 GurBr5HHFFkdq90UWzoaiYGIUkN3QyDzID/0qAL8SuJUtIPCsK6PqLwuBRW7lZ+fqOpE
 JjjRgi3SE94pzzb3u1PKCrV1lkLEtli/cajzD6YV9W7lzHADaLkPi5/ewt2oaZw4uKdu
 tgk1m8Lrv1Qvlu+q7sAxQ2juiqAdpdQe2746+17+ZmPEo8rXHJ5J2rZ6cKbFzR+uOsZh
 Rltg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=hZ3xD2/2lcYcAhtu708AbjR6mIFxqFO7i7RlxJAZ5ZU=;
 b=KCq2m1arlpd6udmRKQ5MrpRBLd+654OeHtKclONexviULeorWFOjzefHPARkvQTCeV
 pjWSqbV5g1+Pd2tphV41bKATM3Hz/tP8TgCQ1tNHVXSxU8xGqnBAylpAkqH6kdFWH1UI
 hOJ40JiG4YhHlYI8SDXJ6S5Zw/H8q08RPFsJvlc3EOMZFv9JuhMXU/M94mmxLAosTOZR
 DUN3ZXJbFQPF+4ZICJU9vT/h8Dm42uXF3s/MfTSMgvXpNH/vjBVwhL5ATkX7DP59susv
 czYtZaYXneMwyC5wA8n/c3yLlubgDPf8UHz9fxyd1/ExgFq6g2GolzMRonn7yITnczf7
 5n+w==
X-Gm-Message-State: AOAM531qnwQ6rF+vdZt3acvfWl9O2E/ltpnXW1PjoEJBBtzLVSp3u7do
 k49ix9k3Wb+JnzXmvnQwswvjfNL7ugukS/91Q9DTww==
X-Google-Smtp-Source: ABdhPJyUKDJgotj2iV/EZDBBDNQh6SKgJOObpqGbdfNKm6jwpeZr7z46WvIqVVcQo2wc5dGjzyguHOPwSCGKOdVqhQ8=
X-Received: by 2002:a05:6402:26c9:: with SMTP id
 x9mr19192479edd.365.1612191676837; 
 Mon, 01 Feb 2021 07:01:16 -0800 (PST)
MIME-Version: 1.0
References: <CA+G9fYvzh5GEssPJHM=r2TVUKOhsFJ8jqrY+pP4t7+jF8ctz9A@mail.gmail.com>
 <5f072f84c7c9b03ded810e56687935b2@kernel.org>
In-Reply-To: <5f072f84c7c9b03ded810e56687935b2@kernel.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Mon, 1 Feb 2021 20:31:05 +0530
Message-ID: <CA+G9fYs4u=E+jMxTds8A-gYWchC4OSdx26cCw7079+w3_bUiZQ@mail.gmail.com>
Subject: Re: arm64: gen-hyprel.c:40:10: fatal error: generated/autoconf.h: No
 such file or directory
To: Marc Zyngier <maz@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
 kvm list <kvm@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 open list <linux-kernel@vger.kernel.org>, lkft-triage@lists.linaro.org,
 Linux-Next Mailing List <linux-next@vger.kernel.org>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Linux ARM <linux-arm-kernel@lists.infradead.org>
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

On Mon, 1 Feb 2021 at 19:15, Marc Zyngier <maz@kernel.org> wrote:
>
> On 2021-02-01 13:38, Naresh Kamboju wrote:
> > Linux next 20210201 tag arm64 builds failed.
> > kernel config attached to this email.
> >
> > BAD:    next-20210201
> > GOOD: next-20210129
> >
> > make --silent --keep-going --jobs=8
> > O=/home/tuxbuild/.cache/tuxmake/builds/1/tmp ARCH=arm64
> > CROSS_COMPILE=aarch64-linux-gnu- 'CC=sccache aarch64-linux-gnu-gcc'
> > 'HOSTCC=sccache gcc'
> > arch/arm64/kvm/hyp/nvhe/gen-hyprel.c:40:10: fatal error:
> > generated/autoconf.h: No such file or directory
> >    40 | #include <generated/autoconf.h>
> >       |          ^~~~~~~~~~~~~~~~~~~~~~
> > compilation terminated.
> >
> > Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
>
> Could you please check with the fix suggested at [1]?

Here is the change I have applied and the arm64 builds successful now.

diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 09d04dd50eb8..ed10fcf1b345 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -7,7 +7,7 @@ asflags-y := -D__KVM_NVHE_HYPERVISOR__
 ccflags-y := -D__KVM_NVHE_HYPERVISOR__

 hostprogs := gen-hyprel
-HOST_EXTRACFLAGS += -I$(srctree)/include
+HOST_EXTRACFLAGS += -I$(objtree)/include

 obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
         hyp-main.o hyp-smp.o psci-relay.o


> [1] https://lore.kernel.org/r/20210201104251.5foc64qq3ewgnhuz@google.com


- Naresh
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

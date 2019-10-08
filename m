Return-Path: <SRS0=tYEe=YB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E2CFC10F14
	for <kvmarm@archiver.kernel.org>; Tue,  8 Oct 2019 09:33:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9C9CF206BB
	for <kvmarm@archiver.kernel.org>; Tue,  8 Oct 2019 09:33:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BkRMuuut"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9C9CF206BB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 064964A90F;
	Tue,  8 Oct 2019 05:33:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9Z3Ji7Rx+h70; Tue,  8 Oct 2019 05:33:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E70EA4A862;
	Tue,  8 Oct 2019 05:33:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BAA84A8FC
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Oct 2019 04:47:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0eswweT7iNgi for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Oct 2019 04:47:18 -0400 (EDT)
Received: from mail-lj1-f196.google.com (mail-lj1-f196.google.com
 [209.85.208.196])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 705E04A8F2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Oct 2019 04:47:18 -0400 (EDT)
Received: by mail-lj1-f196.google.com with SMTP id y23so16608796lje.9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Oct 2019 01:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=l8gpydJYA0YDgp2JmqFlI7k3M5woSWANVYThPnzBSyg=;
 b=BkRMuuut74Tg4ql3czpGBiGETKQ47t0yfFGj9qUtoNECtFLrPq7patqxRQTIKUPosJ
 e5ij5XG6gLCR9aH2tMBlyg4nicWRgSUUeguPdBLCGj5e+fmO4WBOWHqbIrjN23GcV9X+
 9UiM5zuZ8kUOjmbmakyLfk3DNm7gDqehMEcBVhaBie4GaVJqRz5rpcUAluJLllJOF3Mf
 +y7BzcB/eQ1ZrGH8gN2u8Rxxi+fzSaghOC5xViRMArZNRSxn2csNz/W1bUfwb6lH8tnt
 yTgKoyASrJ8JwI3YQxZpWYMIBXyHXAIoXg2BD9qf9M9BjKJeDzu0rw7W+YgoKaSJzGqP
 eNYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=l8gpydJYA0YDgp2JmqFlI7k3M5woSWANVYThPnzBSyg=;
 b=EY9UWQL58xx4b+8Yk9u5ebd8r1jaTeZ6J1hT53Bf3fEV1cNXDjl+SjXsDG9Mtcub/I
 l7BveAhJzpDkP5te0AWJBamSjmjrLOoK5GYT7ymuwhn+aQhi7u6oCQHDKavGVcYA+pLi
 qCS0acxNgyXLULFmLyTzKXlKa7GiOTI9WMfgrLK+UKuF964DU+FbNnZcFMm28uM06ZOg
 dys/5gcqDF3xqD4NEO/TO4fqBVPp/6grE5nSoXyB0DpJhz3xAvfnAg49tzOfmVpmkp/l
 xgpnmrtRVYagIHKGdSJ8srrehEwdit86keXaFdRbbBgSrC6OfiGyklVvszZ2/t4A5Pfj
 rhoA==
X-Gm-Message-State: APjAAAVfGzEhQiAP47otr/CjvvlnEZFm3nq6frAie45SfVV8yheS1Tpv
 dF6+m83w+7d0Z0Lsrq6qPeUAwfcxxhDQzzluRt98nA==
X-Google-Smtp-Source: APXvYqxbNM71HM7CPR6QRsIgEbU3UU9U/CSiMXaA2SIbIfrQl+rWLBRuuYXoBIaSEvilchXKRH21ww7tus0XXj0qkXw=
X-Received: by 2002:a2e:63da:: with SMTP id s87mr20899729lje.79.1570524436968; 
 Tue, 08 Oct 2019 01:47:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190617221134.9930-1-f.fainelli@gmail.com>
 <CACRpkdbqW2kJNdPi6JPupaHA_qRTWG-MsUxeCz0c38MRujOSSA@mail.gmail.com>
 <0ba50ae2-be09-f633-ab1f-860e8b053882@broadcom.com>
 <CAK8P3a2QBQrBU+bBBL20kR+qJfmspCNjiw05jHTa-q6EDfodMg@mail.gmail.com>
 <fbdc3788-3a24-2885-b61b-8480e8464a51@gmail.com>
 <CAK8P3a1E_1=_+eJXvcFMLd=a=YW_WGwjm3nzRZV7SzzZqovzRw@mail.gmail.com>
In-Reply-To: <CAK8P3a1E_1=_+eJXvcFMLd=a=YW_WGwjm3nzRZV7SzzZqovzRw@mail.gmail.com>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Tue, 8 Oct 2019 10:47:05 +0200
Message-ID: <CACRpkdbuwn-YBYd324OsfC4efBU_1pfnyS+N=+3DmrYOEKKFJw@mail.gmail.com>
Subject: Re: [PATCH v6 0/6] KASan for arm
To: Arnd Bergmann <arnd@arndb.de>
X-Mailman-Approved-At: Tue, 08 Oct 2019 05:33:11 -0400
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>,
 Michal Hocko <mhocko@suse.com>, Catalin Marinas <catalin.marinas@arm.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 David Howells <dhowells@redhat.com>,
 Masahiro Yamada <yamada.masahiro@socionext.com>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Alexander Potapenko <glider@google.com>, kvmarm@lists.cs.columbia.edu,
 Florian Fainelli <f.fainelli@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
 Abbott Liu <liuwenliang@huawei.com>,
 Daniel Lezcano <daniel.lezcano@linaro.org>,
 Russell King <linux@armlinux.org.uk>, kasan-dev <kasan-dev@googlegroups.com>,
 bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
 Dmitry Vyukov <dvyukov@google.com>, Geert Uytterhoeven <geert@linux-m68k.org>,
 Kees Cook <keescook@chromium.org>, Marc Zyngier <marc.zyngier@arm.com>,
 Andre Przywara <andre.przywara@arm.com>, philip@cog.systems,
 Jinbum Park <jinb.park7@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>,
 Nicolas Pitre <nico@fluxnic.net>, Greg KH <gregkh@linuxfoundation.org>,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>,
 Linux Doc Mailing List <linux-doc@vger.kernel.org>,
 Rob Landley <rob@landley.net>, Philippe Ombredanne <pombredanne@nexb.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Thomas Garnier <thgarnie@google.com>,
 "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
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

On Tue, Oct 8, 2019 at 12:10 AM Arnd Bergmann <arnd@arndb.de> wrote:
> On Mon, Oct 7, 2019 at 11:35 PM Florian Fainelli <f.fainelli@gmail.com> wrote:

> > > 053555034bdf kasan: disable CONFIG_KASAN_STACK with clang on arm32
> >
> > This one I did not take based on Linus' feedback that is breaks booting
> > on his RealView board.
>
> That likely means that there is still a bigger problem somewhere.

I will try to look into it. I got pretty puzzled by this, it makes no sense.

One possible problem is that some of the test chips on the RealViews
are not that stable, especially with caches. The plan is to test in QEMU
and hardware in parallel.

Yours,
Linus Walleij
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

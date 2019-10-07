Return-Path: <SRS0=MuL5=YA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26FA9C47404
	for <kvmarm@archiver.kernel.org>; Mon,  7 Oct 2019 22:10:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AA1AF20867
	for <kvmarm@archiver.kernel.org>; Mon,  7 Oct 2019 22:10:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AA1AF20867
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arndb.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 605444A896;
	Mon,  7 Oct 2019 18:10:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2rZcFnRgS8iO; Mon,  7 Oct 2019 18:10:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 598C44A8A1;
	Mon,  7 Oct 2019 18:10:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0AAC14A897
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Oct 2019 18:10:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RcL3P7vYbB00 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Oct 2019 18:10:24 -0400 (EDT)
Received: from mail-qt1-f195.google.com (mail-qt1-f195.google.com
 [209.85.160.195])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D55DA4A830
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Oct 2019 18:10:24 -0400 (EDT)
Received: by mail-qt1-f195.google.com with SMTP id o12so21684187qtf.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Oct 2019 15:10:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Ejfq0Mc5y2dQchNRlWvp8Diy33ha1r0LaAd27i+X0Y8=;
 b=oxVjFtKjUUYQxxZ67Z7qVnlRLx6M5PqEBT8IKD44ZxGA7kipEcqWWFmGLh5yDIFknA
 oPw/KF8sfN+72sCSK78+FvVr8SbzQzldL1WJYGl0K7lsGtK0+4hdwFdmbcVM1C14UStW
 /3nKILtSOkdTewvkjpcr4sSZAvLXbvqALfYe30ZYQFq+l81EFJQJaISl+TTUchlr93Ia
 j8YPlv5S/QShaVoD68qOn6S6gcnUcmE5kcUkJjTavLPc9g0D+X27EqpgwFi7Jeyq3DQJ
 yaqbKfIAeMg+zNRNlyuesnXNp+N9pB53LMlaMWtzg3QnjpLIFwPTXkG2xSOVN9Pcmaqs
 o15Q==
X-Gm-Message-State: APjAAAUzuXDSfoMCNkn5uSnxMCUNsQsruAom0lqZWQf32CYl+u+t4mrh
 eRNPfcXnCQc45vmwYNBJ+RHsH3V2BNpLxv4MK4g=
X-Google-Smtp-Source: APXvYqzPRJFxFYuWxT4+ZfBG+w2vGH6NTchROSOQUcdmM5fCIL2BX1QvKN3iJG9HKm+wYCbZZdFHqvljXGP+vRDWt10=
X-Received: by 2002:ac8:342a:: with SMTP id u39mr32462138qtb.7.1570486224339; 
 Mon, 07 Oct 2019 15:10:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190617221134.9930-1-f.fainelli@gmail.com>
 <CACRpkdbqW2kJNdPi6JPupaHA_qRTWG-MsUxeCz0c38MRujOSSA@mail.gmail.com>
 <0ba50ae2-be09-f633-ab1f-860e8b053882@broadcom.com>
 <CAK8P3a2QBQrBU+bBBL20kR+qJfmspCNjiw05jHTa-q6EDfodMg@mail.gmail.com>
 <fbdc3788-3a24-2885-b61b-8480e8464a51@gmail.com>
In-Reply-To: <fbdc3788-3a24-2885-b61b-8480e8464a51@gmail.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 8 Oct 2019 00:10:08 +0200
Message-ID: <CAK8P3a1E_1=_+eJXvcFMLd=a=YW_WGwjm3nzRZV7SzzZqovzRw@mail.gmail.com>
Subject: Re: [PATCH v6 0/6] KASan for arm
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>,
 Michal Hocko <mhocko@suse.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Linus Walleij <linus.walleij@linaro.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 David Howells <dhowells@redhat.com>,
 Masahiro Yamada <yamada.masahiro@socionext.com>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Alexander Potapenko <glider@google.com>, kvmarm@lists.cs.columbia.edu,
 Jonathan Corbet <corbet@lwn.net>, Abbott Liu <liuwenliang@huawei.com>,
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

On Mon, Oct 7, 2019 at 11:35 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> On 7/18/19 12:51 AM, Arnd Bergmann wrote:
> > On Thu, Jul 11, 2019 at 7:00 PM Florian Fainelli
> > <florian.fainelli@broadcom.com> wrote:
> >> On 7/2/19 2:06 PM, Linus Walleij wrote:
> >
> >>
> >> Great, thanks a lot for taking a look. FYI, I will be on holiday from
> >> July 19th till August 12th, if you think you have more feedback between
> >> now and then, I can try to pick it up and submit a v7 with that feedback
> >> addressed, or it will happen when I return, or you can pick it up if you
> >> refer, all options are possible!
> >>
> >> @Arnd, should we squash your patches in as well?
> >
> > Yes, please do. I don't remember if I sent you all of them already,
> > here is the list of patches that I have applied locally on top of your
> > series to get a clean randconfig build:
> >
> > 123c3262f872 KASAN: push back KASAN_STACK to clang-10
>
> This one seems to have received some feedback, not sure if it was
> addressed or not in a subsequent patch?

ebb6d35a74ce ("kasan: remove clang version check for KASAN_STACK")

got applied, it seems clang will remain broken with KASAN_STACK
for a while.

> > 053555034bdf kasan: disable CONFIG_KASAN_STACK with clang on arm32
>
> This one I did not take based on Linus' feedback that is breaks booting
> on his RealView board.

That likely means that there is still a bigger problem somewhere.

      Arnd
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

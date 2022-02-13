Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D56E5C433EF
	for <kvmarm@archiver.kernel.org>; Sun, 13 Feb 2022 18:36:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DD2449F2C;
	Sun, 13 Feb 2022 13:36:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qtCfzOJPoi+5; Sun, 13 Feb 2022 13:36:04 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EBF149E48;
	Sun, 13 Feb 2022 13:36:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 754CD40B64
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Feb 2022 06:38:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DYXIb5nykFyj for <kvmarm@lists.cs.columbia.edu>;
 Sun, 13 Feb 2022 06:38:40 -0500 (EST)
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com
 [209.85.210.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 26EDD408F4
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Feb 2022 06:38:40 -0500 (EST)
Received: by mail-ot1-f46.google.com with SMTP id
 x52-20020a05683040b400b0059ea92202daso9669465ott.7
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Feb 2022 03:38:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=sGy6+YA6Lv8KVw+rOUVLJDd2D7buJACZzak81xW9KKo=;
 b=p/fgOu3m900W/rw158RPGAl6q68tw63j/bzw1f/cElxOhFtNagDXCfqf5yGAvCD/Er
 R924kwWh95t8Dt3g3bXZ2OnDjcqE6gGHX2Re27mI77ucAt7GFpgEYglSiC0x7bzFqIlq
 wLU9nYAaZKjhFFUSQjVu0yAh79wj/2PzSrlRNjAwDDjhQf+C/tACUFw2VNMoiuoR6zOl
 mndvyTT2p8UwdJWf12IxfDeh87ZtUtLMMKhgtR3N1IHN3OQXM25WoJxMoDnLPZ8anfr0
 mzS737LkIxHlxHcUwMcHBGCLib8iVo3F5TOVjYCY/TMEfDsAw2IrAemK0coc62Lt4+IC
 VyPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=sGy6+YA6Lv8KVw+rOUVLJDd2D7buJACZzak81xW9KKo=;
 b=hVDlV+SDnacU3hz+C0A8yuC2AF8bnfMKh3uiZf/y33z9+E1SND9Z1N1szrgSF4ZCbV
 GbZn9EbRyb0Wk4Dq/r+TQxFwBtvjTflQF2Kex/BHceLyHUQrXQp1CcRy5NNdHu3sSHPL
 dGwQZLiF0xmYfDbeoijrRBwe9bGmZ8TVmbxVgZYD7HHrn9+DQSjDra/1y2lHNAbZtQPh
 ZRvoVJ2COBIPkJg6XShWvHCtzhBPz1yQhh2DfF5mtGjuoxhQmKb7IC3GwGWVOmRpuVTy
 dN9NLrwXeFmTRvQ/D2yQweVqAgve6mwC72ZTdrghYquEt4I42LKiHhJvzJso9AP8U7uh
 I+oQ==
X-Gm-Message-State: AOAM530ITpiFoYROMyLTDKuUXmJcktmPLBwxQS44SgpUV9wZfl9H7Cxy
 /WTt3qGKUlxgEsL6QmlfG/E9KFv7/zok3N8F0pI=
X-Google-Smtp-Source: ABdhPJy9wQzjQ3nZFfJ26JTm2zWAhExrPxP3STsy2GXOuB4wb6fVRTBG0UIZjTS5ZkLfuJEsp+7rGu9LO5N8VYolfDE=
X-Received: by 2002:a9d:7cce:: with SMTP id r14mr2532351otn.235.1644752319499; 
 Sun, 13 Feb 2022 03:38:39 -0800 (PST)
MIME-Version: 1.0
References: <20220120123630.267975-1-peter.maydell@linaro.org>
 <20220120123630.267975-19-peter.maydell@linaro.org>
 <3f4f5e98-fcb8-bf4d-e464-6ad365af92f8@gmail.com>
 <87iltjxdz6.wl-maz@kernel.org>
 <CAFEAcA9yR4=PNCGJk6iMEq0EHejwwt-gQJfvByEk-EN6ER5o_g@mail.gmail.com>
In-Reply-To: <CAFEAcA9yR4=PNCGJk6iMEq0EHejwwt-gQJfvByEk-EN6ER5o_g@mail.gmail.com>
From: Akihiko Odaki <akihiko.odaki@gmail.com>
Date: Sun, 13 Feb 2022 20:38:28 +0900
Message-ID: <CAMVc7JWUm7v6gt48TP+ugzEeHwo6FA66TeE3h3fqyHmHsShoig@mail.gmail.com>
Subject: Re: [PULL 18/38] hw/arm/virt: Honor highmem setting when computing
 the memory map
To: Peter Maydell <peter.maydell@linaro.org>
X-Mailman-Approved-At: Sun, 13 Feb 2022 13:36:01 -0500
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 qemu Developers <qemu-devel@nongnu.org>, Alexander Graf <agraf@csgraf.de>,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

On Sun, Feb 13, 2022 at 7:46 PM Peter Maydell <peter.maydell@linaro.org> wrote:
>
> On Sun, 13 Feb 2022 at 10:22, Marc Zyngier <maz@kernel.org> wrote:
> >
> > [+ Alex for HVF]
> >
> > On Sun, 13 Feb 2022 05:05:33 +0000,
> > Akihiko Odaki <akihiko.odaki@gmail.com> wrote:
> > > Hi,
> > > This breaks in a case where highmem is disabled but can have more than
> > > 4 GiB of RAM. M1 (Apple Silicon) actually can have 36-bit PA with HVF,
> > > which is not enough for highmem MMIO but is enough to contain 32 GiB
> > > of RAM.
> >
> > Funny. The whole point of this series is to make it all work correctly
> > on M1.
> >
> > > Where the magic number of 4 GiB / 32-bit came from?
> >
> > Not exactly a magic number. From QEMU's docs/system/arm/virt.rst:
> >
> > <quote>
> > highmem
> >   Set ``on``/``off`` to enable/disable placing devices and RAM in physical
> >   address space above 32 bits. The default is ``on`` for machine types
> >   later than ``virt-2.12``.
> > </quote>
> >
> > TL;DR: Removing the bogus 'highmem=off' option from your command-line
> > should get you going with large memory spaces, up to the IPA limit.
>
> Yep. I've tested this with hvf, and we now correctly:
>  * refuse to put RAM above 32-bits if you asked for a 32-bit
>    IPA space with highmem=off
>  * use the full 36-bit address space if you don't say highmem=off
>    on an M1
>
> Note that there is a macos bug where if you don't say highmem=off
> on an M1 Pro then you'll get a macos kernel panic. M1 non-Pro is fine.
>
> thanks
> -- PMM

I found that it actually gets the available PA bit of the emulated CPU
when highmem=on. I used "cortex-a72", which can have more than 36
bits. I just simply switched to "host"; hvf didn't support "host" when
I set up my VM but now it does.
Thanks for your prompt replies.

Regards,
Akihiko Odaki
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

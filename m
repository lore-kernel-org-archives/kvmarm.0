Return-Path: <SRS0=Em7b=4W=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B897C3F2D1
	for <kvmarm@archiver.kernel.org>; Thu,  5 Mar 2020 08:44:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B02592146E
	for <kvmarm@archiver.kernel.org>; Thu,  5 Mar 2020 08:44:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="M2RHZfPP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B02592146E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 10B4C4A541;
	Thu,  5 Mar 2020 03:44:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id esWb5WxETH8c; Thu,  5 Mar 2020 03:44:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CE2A4AE9F;
	Thu,  5 Mar 2020 03:44:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B95154AE9F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Mar 2020 03:44:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DUEGLv-s172k for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Mar 2020 03:44:00 -0500 (EST)
Received: from mail-lj1-f195.google.com (mail-lj1-f195.google.com
 [209.85.208.195])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8AAE14A541
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Mar 2020 03:44:00 -0500 (EST)
Received: by mail-lj1-f195.google.com with SMTP id a12so5126167ljj.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 05 Mar 2020 00:44:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=fbdyI132YwoclqRAqQFcdVx80Hpq+rOO83F3M2/coUY=;
 b=M2RHZfPPLjF7FpMQLcCbqr8EN9g6Ic3+vH8uz+umLS+RFof6hkjjSGWTRM6jNNndox
 k6DtkldAR/CFy6cPpqVUsaG5ysOvTdmV7xhr9qA9AOwkMQXVfMLnhkq0azy7efyPI+aS
 4qvbMDOoeAen2vmmUdCuD6AsTPljasQC9vX32+eqQCBMytLYsMIKUzY+wwBi6asEtwH2
 xVmjHtapMbyBHpM3bGAW48hfzKoqNSC7wyVR6U/+RZMWp9vtaHXNEHufluU0DVURs3tI
 W+N/AWsbjr/pRCMw/XP/p0QATrMAgRglWks0u8wK+Dm4YFWcWgccy753zPXixcUkMkKf
 kfcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=fbdyI132YwoclqRAqQFcdVx80Hpq+rOO83F3M2/coUY=;
 b=XFQF7mZf4AL+4uj7Lmxn4CpOhrR2o6CEBzfk0KAWmXeKO9z586pzqkbabQ4aDcPTUT
 aTmShViMFK2RQPnYcQv0g1EifuNtMvHdSIKCZpwpOLE3InW1MyH7IJnJSwjrwNfg7ZZi
 5QeK5gpqvYxNbvicbVnd9QYg2CJXLoXi0pL/DHj5iBZBRn0+qFHZgMVcBdcpW0Z5721t
 1p22lZuow3EeYtEe9vT3pK9sVS/bpurgDxpz/5wSgeAJXC09bD9EU2y8Uw0FfIi7fmCj
 RNdR48JqX1ITYVT7lBo4aMRGxY1lzJQ0lh7DeGjdD1ShTUkO58JvQdwtQlcyIXCTIKUR
 Tpfg==
X-Gm-Message-State: ANhLgQ07aSSDu3AKZyvrPV2AIF1aZ+gMzr73NFpsb31iANiaEOyw6886
 JhlGcWCUesqiSSewy/fWHS8mBzlFRT2SYDTUwwwh1w==
X-Google-Smtp-Source: ADFU+vvRFk8g3wXnA/A8ma/dUQb4x8dS4Zxl9FCH95G0Ve3S38UAd/rE7NSBOFGF0YuUMSSw1xX1W7Ho7mX9olGU4y8=
X-Received: by 2002:a05:651c:2049:: with SMTP id
 t9mr4675395ljo.39.1583397839207; 
 Thu, 05 Mar 2020 00:43:59 -0800 (PST)
MIME-Version: 1.0
References: <20190617221134.9930-1-f.fainelli@gmail.com>
 <20191114181243.q37rxoo3seds6oxy@pengutronix.de>
 <7322163f-e08e-a6b7-b143-e9d59917ee5b@gmail.com>
 <20191115070842.2x7psp243nfo76co@pengutronix.de>
 <20191115114416.ba6lmwb7q4gmepzc@pengutronix.de>
 <60bda4a9-f4f8-3641-2612-17fab3173b29@gmail.com>
 <CACRpkdYJR3gQCb4WXwF4tGzk+tT7jMcV9=nDK0PFkeh+0G11bA@mail.gmail.com>
 <2639dfb0-9e48-cc0f-27e5-34308f790293@gmail.com>
In-Reply-To: <2639dfb0-9e48-cc0f-27e5-34308f790293@gmail.com>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Thu, 5 Mar 2020 09:43:48 +0100
Message-ID: <CACRpkdZ8JA=DXOxzYwyvBxCMd2Q5uzLTn87AVK7wdrxHFo5ydQ@mail.gmail.com>
Subject: Re: [PATCH v6 0/6] KASan for arm
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>,
 Michal Hocko <mhocko@suse.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Marco Felsch <m.felsch@pengutronix.de>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 David Howells <dhowells@redhat.com>,
 Masahiro Yamada <yamada.masahiro@socionext.com>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Alexander Potapenko <glider@google.com>, kvmarm@lists.cs.columbia.edu,
 Rob Landley <rob@landley.net>, Jonathan Corbet <corbet@lwn.net>,
 Abbott Liu <liuwenliang@huawei.com>,
 Daniel Lezcano <daniel.lezcano@linaro.org>,
 Russell King <linux@armlinux.org.uk>, kasan-dev <kasan-dev@googlegroups.com>,
 bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>,
 Geert Uytterhoeven <geert@linux-m68k.org>, Kees Cook <keescook@chromium.org>,
 Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <marc.zyngier@arm.com>,
 Andre Przywara <andre.przywara@arm.com>, philip@cog.systems,
 Jinbum Park <jinb.park7@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
 Dmitry Vyukov <dvyukov@google.com>, Nicolas Pitre <nico@fluxnic.net>,
 Greg KH <gregkh@linuxfoundation.org>,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>,
 Linux Doc Mailing List <linux-doc@vger.kernel.org>,
 Sascha Hauer <kernel@pengutronix.de>,
 Philippe Ombredanne <pombredanne@nexb.com>,
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

Hi Florian,

On Fri, Jan 17, 2020 at 8:55 PM Florian Fainelli <f.fainelli@gmail.com> wrote:

> Let me submit and rebase v7 get the auto builders some days to see if it
> exposes a new build issue and then we toss it to RMK's patch tracker and
> fix bugs from there?

Sorry for hammering, can we get some initial patches going into
Russell's patch tracker here? I can sign them off and put them in
if you don't have time.

Thanks,
Linus Walleij
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <SRS0=Em7b=4W=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B897AC3F2D7
	for <kvmarm@archiver.kernel.org>; Thu,  5 Mar 2020 12:17:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 489E9208CD
	for <kvmarm@archiver.kernel.org>; Thu,  5 Mar 2020 12:17:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 489E9208CD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AA1994AEBB;
	Thu,  5 Mar 2020 07:17:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JcZKWxIJFORy; Thu,  5 Mar 2020 07:17:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A74E74AEBC;
	Thu,  5 Mar 2020 07:17:53 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D8954A95D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Mar 2020 04:43:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iOArfvqI4gAV for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Mar 2020 04:43:45 -0500 (EST)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de
 [85.220.165.71])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C145D4A588
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Mar 2020 04:43:45 -0500 (EST)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
 by metis.ext.pengutronix.de with esmtps
 (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <mfe@pengutronix.de>)
 id 1j9n2b-0003Jp-1c; Thu, 05 Mar 2020 10:43:41 +0100
Received: from mfe by pty.hi.pengutronix.de with local (Exim 4.89)
 (envelope-from <mfe@pengutronix.de>)
 id 1j9n2P-0007e4-2o; Thu, 05 Mar 2020 10:43:29 +0100
Date: Thu, 5 Mar 2020 10:43:29 +0100
From: Marco Felsch <m.felsch@pengutronix.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v6 0/6] KASan for arm
Message-ID: <20200305094328.sizz4vm4wamywdct@pengutronix.de>
References: <20190617221134.9930-1-f.fainelli@gmail.com>
 <20191114181243.q37rxoo3seds6oxy@pengutronix.de>
 <7322163f-e08e-a6b7-b143-e9d59917ee5b@gmail.com>
 <20191115070842.2x7psp243nfo76co@pengutronix.de>
 <20191115114416.ba6lmwb7q4gmepzc@pengutronix.de>
 <60bda4a9-f4f8-3641-2612-17fab3173b29@gmail.com>
 <CACRpkdYJR3gQCb4WXwF4tGzk+tT7jMcV9=nDK0PFkeh+0G11bA@mail.gmail.com>
 <2639dfb0-9e48-cc0f-27e5-34308f790293@gmail.com>
 <CACRpkdZ8JA=DXOxzYwyvBxCMd2Q5uzLTn87AVK7wdrxHFo5ydQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CACRpkdZ8JA=DXOxzYwyvBxCMd2Q5uzLTn87AVK7wdrxHFo5ydQ@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:40:52 up 111 days, 59 min, 138 users, load average: 0.50, 0.16, 
 0.05
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: mfe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de);
 SAEximRunCond expanded to false
X-PTX-Original-Recipient: kvmarm@lists.cs.columbia.edu
X-Mailman-Approved-At: Thu, 05 Mar 2020 07:17:52 -0500
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>,
 Michal Hocko <mhocko@suse.com>, Catalin Marinas <catalin.marinas@arm.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 David Howells <dhowells@redhat.com>,
 Masahiro Yamada <yamada.masahiro@socionext.com>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Alexander Potapenko <glider@google.com>, kvmarm@lists.cs.columbia.edu,
 Florian Fainelli <f.fainelli@gmail.com>, Rob Landley <rob@landley.net>,
 Jonathan Corbet <corbet@lwn.net>, Abbott Liu <liuwenliang@huawei.com>,
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

On 20-03-05 09:43, Linus Walleij wrote:
> Hi Florian,
> 
> On Fri, Jan 17, 2020 at 8:55 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
> 
> > Let me submit and rebase v7 get the auto builders some days to see if it
> > exposes a new build issue and then we toss it to RMK's patch tracker and
> > fix bugs from there?
> 
> Sorry for hammering, can we get some initial patches going into
> Russell's patch tracker here? I can sign them off and put them in
> if you don't have time.

I've tested the branch on several imx6 based boards with different
toolchains. Some boards booting normal and some of them are lost in
space... I didn't debugged it yet just wanted to inform you.

Regards,
  Marco

> Thanks,
> Linus Walleij
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

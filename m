Return-Path: <SRS0=MyuK=ZH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38A07C432C3
	for <kvmarm@archiver.kernel.org>; Fri, 15 Nov 2019 14:23:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B697D2072D
	for <kvmarm@archiver.kernel.org>; Fri, 15 Nov 2019 14:23:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B697D2072D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 34CFF4AEAB;
	Fri, 15 Nov 2019 09:23:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IjirpBq0Mmje; Fri, 15 Nov 2019 09:23:26 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 007124AECE;
	Fri, 15 Nov 2019 09:23:26 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A1BEB4AED6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Nov 2019 06:44:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4XYL-TYqJjN3 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Nov 2019 06:44:31 -0500 (EST)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de
 [85.220.165.71])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3FC064AED0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Nov 2019 06:44:30 -0500 (EST)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
 by metis.ext.pengutronix.de with esmtps
 (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <mfe@pengutronix.de>)
 id 1iVa1Z-0007QU-T6; Fri, 15 Nov 2019 12:44:25 +0100
Received: from mfe by pty.hi.pengutronix.de with local (Exim 4.89)
 (envelope-from <mfe@pengutronix.de>)
 id 1iVa1Q-0008K2-Ab; Fri, 15 Nov 2019 12:44:16 +0100
Date: Fri, 15 Nov 2019 12:44:16 +0100
From: Marco Felsch <m.felsch@pengutronix.de>
To: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH v6 0/6] KASan for arm
Message-ID: <20191115114416.ba6lmwb7q4gmepzc@pengutronix.de>
References: <20190617221134.9930-1-f.fainelli@gmail.com>
 <20191114181243.q37rxoo3seds6oxy@pengutronix.de>
 <7322163f-e08e-a6b7-b143-e9d59917ee5b@gmail.com>
 <20191115070842.2x7psp243nfo76co@pengutronix.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20191115070842.2x7psp243nfo76co@pengutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:28:52 up  2:47, 19 users,  load average: 0.00, 0.04, 0.03
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: mfe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de);
 SAEximRunCond expanded to false
X-PTX-Original-Recipient: kvmarm@lists.cs.columbia.edu
X-Mailman-Approved-At: Fri, 15 Nov 2019 09:23:25 -0500
Cc: alexandre.belloni@bootlin.com, mhocko@suse.com, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, dhowells@redhat.com,
 yamada.masahiro@socionext.com, ryabinin.a.a@gmail.com, glider@google.com,
 kvmarm@lists.cs.columbia.edu, rob@landley.net, corbet@lwn.net,
 liuwenliang@huawei.com, daniel.lezcano@linaro.org, linux@armlinux.org.uk,
 kasan-dev@googlegroups.com, bcm-kernel-feedback-list@broadcom.com,
 linux-arm-kernel@lists.infradead.org, geert@linux-m68k.org,
 keescook@chromium.org, arnd@arndb.de, marc.zyngier@arm.com,
 andre.przywara@arm.com, philip@cog.systems, jinb.park7@gmail.com,
 tglx@linutronix.de, dvyukov@google.com, nico@fluxnic.net,
 gregkh@linuxfoundation.org, ard.biesheuvel@linaro.org,
 linux-doc@vger.kernel.org, kernel@pengutronix.de, pombredanne@nexb.com,
 akpm@linux-foundation.org, thgarnie@google.com,
 kirill.shutemov@linux.intel.com
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

On 19-11-15 08:08, Marco Felsch wrote:
> Hi Florian,
> 
> On 19-11-14 15:01, Florian Fainelli wrote:
> > Hello Marco,
> > 
> > On 11/14/19 10:12 AM, Marco Felsch wrote:
> > > Hi Florian,
> > > 
> > > first of all, many thanks for your work on this series =) I picked your
> > > and Arnd patches to make it compilable. Now it's compiling but my imx6q
> > > board didn't boot anymore. I debugged the code and found that the branch
> > > to 'start_kernel' won't be reached
> > > 
> > > 8<------- arch/arm/kernel/head-common.S -------
> > > ....
> > > 
> > > #ifdef CONFIG_KASAN
> > >         bl      kasan_early_init
> > > #endif
> > > 	mov     lr, #0
> > > 	b       start_kernel
> > > ENDPROC(__mmap_switched)
> > > 
> > > ....
> > > 8<----------------------------------------------
> > > 
> > > Now, I found also that 'KASAN_SHADOW_OFFSET' isn't set due to missing
> > > 'CONFIG_KASAN_SHADOW_OFFSET' and so no '-fasan-shadow-offset=xxxxx' is
> > > added. Can that be the reason why my board isn't booted anymore?
> > 
> > The latest that I have is here, though not yet submitted since I needed
> > to solve one issue on a specific platform with a lot of memory:
> > 
> > https://github.com/ffainelli/linux/pull/new/kasan-v7
> 
> Thanks for that hint, I will try this series too :) I read that you
> wanna prepare a v7 but didn't found it ^^
> 
> > Can you share your branch as well? I did not pick all of Arnd's patches
> > since some appeared to be seemingly independent from KASan on ARM. This
> > is the KASAN related options that are set in my configuration:
> 
> Of course I will push it to github and inform you shortly.

Here comes the link:
https://github.com/medude/linux/tree/v5.4/topic/kasan-arm.v7

I just applied Arnds Patche which you didn't added into your v7.

> > grep KASAN build/linux-custom/.config
> > CONFIG_HAVE_ARCH_KASAN=y
> > CONFIG_CC_HAS_KASAN_GENERIC=y
> > CONFIG_KASAN=y
> > CONFIG_KASAN_GENERIC=y
> > CONFIG_KASAN_OUTLINE=y
> > # CONFIG_KASAN_INLINE is not set
> > CONFIG_KASAN_STACK=1
> > CONFIG_TEST_KASAN=m
> 
> My config is:
> 
> CONFIG_HAVE_ARCH_KASAN=y
> CONFIG_CC_HAS_KASAN_GENERIC=y
> CONFIG_KASAN=y
> CONFIG_KASAN_GENERIC=y
> CONFIG_KASAN_OUTLINE=y
> # CONFIG_KASAN_INLINE is not set
> CONFIG_KASAN_STACK=1
> # CONFIG_TEST_KASAN is not set
> 
> > are you using something different by any chance?
> 
> Unfortunately not.

With your v7 it is working on my imx6 but unfortunately I can't run my
gstreamer testcase. My CPU load goes to 100% after starting gstreamer
and nothing happens.. But the test_kasan module works =) So I decided to
check a imx6quadplus but this target did not boot.. I used another
toolchain for the imx6quadplus gcc-9 instead of gcc-8. So it seems that
something went wrong during compilation. Because you didn't changed
something within the logic.

I wonder why we must not define the CONFIG_KASAN_SHADOW_OFFSET for arm.

Regards,
  Marco

> Regards,
>   Marco
> 
> > -- 
> > Florian
> > 
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <SRS0=0dlf=US=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3704C31E49
	for <kvmarm@archiver.kernel.org>; Wed, 19 Jun 2019 11:51:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7396921479
	for <kvmarm@archiver.kernel.org>; Wed, 19 Jun 2019 11:51:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="EmwB9jSn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7396921479
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AC9E4A47A;
	Wed, 19 Jun 2019 07:51:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UtcSG3QVK7Tf; Wed, 19 Jun 2019 07:51:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 74C634A3B4;
	Wed, 19 Jun 2019 07:51:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 57C844A3B4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Jun 2019 07:51:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IZ-+-cCsb37r for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Jun 2019 07:51:17 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4C7714A369
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Jun 2019 07:51:17 -0400 (EDT)
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com
 [209.85.221.52])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 0BD402084B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Jun 2019 11:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1560945076;
 bh=I9GUMrpXQQ4kP+XRlQm8nsuNTpCDLDeTZGuUV6StNpU=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=EmwB9jSneP5zvx+aO02e5ajh7HUMAmZwr7xBYZDziZHiVUbMqpfSn8oGPrp0ASWB1
 sAvfxTB1iTWoia0261g0Sybv0xAczcIdmA2GuWCcWniP/g8jQtbG7aTs0gHCmOwBgQ
 YLpwwQIAR7bV4++qpk+nQNV5GnVE/J+aFsVTa1nU=
Received: by mail-wr1-f52.google.com with SMTP id p11so3047889wre.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Jun 2019 04:51:15 -0700 (PDT)
X-Gm-Message-State: APjAAAUdMwmLzFwgjCCkmOenmBe4A0w4yxs3vcdx8WtN5ihwWB697ame
 6ezr4n2aDKXrnCDwc+4Q6g57wszbEHsLQeUVbx4=
X-Google-Smtp-Source: APXvYqy+0U1Ub7AMCGJu+3bTvhBYfZ23ab1bs8cRs50+HW9TdRv1m5YTdwBFzYfP6I5ojcMFW3AyuYO4S1RyjAIIWQ0=
X-Received: by 2002:adf:f28a:: with SMTP id k10mr4144332wro.343.1560945074589; 
 Wed, 19 Jun 2019 04:51:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190321163623.20219-1-julien.grall@arm.com>
 <20190321163623.20219-12-julien.grall@arm.com>
 <0dfe120b-066a-2ac8-13bc-3f5a29e2caa3@arm.com>
 <CAJF2gTTXHHgDboaexdHA284y6kNZVSjLis5-Q2rDnXCxr4RSmA@mail.gmail.com>
 <c871a5ae-914f-a8bb-9474-1dcfec5d45bf@arm.com>
In-Reply-To: <c871a5ae-914f-a8bb-9474-1dcfec5d45bf@arm.com>
From: Guo Ren <guoren@kernel.org>
Date: Wed, 19 Jun 2019 19:51:03 +0800
X-Gmail-Original-Message-ID: <CAJF2gTStSR7Jmu7=HaO5Wxz=Zn8A5-RD8ktori3oKEhM9vozAA@mail.gmail.com>
Message-ID: <CAJF2gTStSR7Jmu7=HaO5Wxz=Zn8A5-RD8ktori3oKEhM9vozAA@mail.gmail.com>
Subject: Re: [PATCH RFC 11/14] arm64: Move the ASID allocator code in a
 separate file
To: Julien Grall <julien.grall@arm.com>
Cc: aou@eecs.berkeley.edu, Marc Zyngier <marc.zyngier@arm.com>,
 catalin.marinas@arm.com, Anup Patel <anup.Patel@wdc.com>, will.deacon@arm.com,
 linux-kernel@vger.kernel.org, rppt@linux.ibm.com, hch@infradead.org,
 Atish.Patra@wdc.com, Palmer Dabbelt <palmer@sifive.com>, gary@garyguo.net,
 paul.walmsley@sifive.com, linux-riscv@lists.infradead.org,
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

On Wed, Jun 19, 2019 at 4:54 PM Julien Grall <julien.grall@arm.com> wrote:
>
>
>
> On 6/19/19 9:07 AM, Guo Ren wrote:
> > Hi Julien,
>
> Hi,
>
> >
> > You forgot CCing C-SKY folks :P
>
> I wasn't aware you could be interested :).
>
> >
> > Move arm asid allocator code in a generic one is a agood idea, I've
> > made a patchset for C-SKY and test is on processing, See:
> > https://lore.kernel.org/linux-csky/1560930553-26502-1-git-send-email-guoren@kernel.org/
> >
> > If you plan to seperate it into generic one, I could co-work with you.
>
> Was the ASID allocator work out of box on C-Sky?
Almost done, but one question:
arm64 remove the code in switch_mm:
  cpumask_clear_cpu(cpu, mm_cpumask(prev));
  cpumask_set_cpu(cpu, mm_cpumask(next));

Why? Although arm64 cache operations could affect all harts with CTC
method of interconnect, I think we should
keep these code for primitive integrity in linux. Because cpu_bitmap
is in mm_struct instead of mm->context.

In current csky's patches I've also removed the codes the same as
arm64, but I'll add it back at next version.

> If so, I can easily move the code in a generic place (maybe lib/asid.c).
I think it's OK.

Best Regards
 Guo Ren
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

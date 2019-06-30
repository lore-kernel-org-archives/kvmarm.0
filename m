Return-Path: <SRS0=ia35=U5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B4F4C5B576
	for <kvmarm@archiver.kernel.org>; Sun, 30 Jun 2019 04:30:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B732A2089C
	for <kvmarm@archiver.kernel.org>; Sun, 30 Jun 2019 04:30:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="j72oOEAi"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B732A2089C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BAB44A483;
	Sun, 30 Jun 2019 00:30:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZDIBN-kDYMnN; Sun, 30 Jun 2019 00:30:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 643C44A4FA;
	Sun, 30 Jun 2019 00:30:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FE994A47E
 for <kvmarm@lists.cs.columbia.edu>; Sun, 30 Jun 2019 00:30:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xmlptOLTKLqO for <kvmarm@lists.cs.columbia.edu>;
 Sun, 30 Jun 2019 00:30:01 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D9C084A47A
 for <kvmarm@lists.cs.columbia.edu>; Sun, 30 Jun 2019 00:30:00 -0400 (EDT)
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com
 [209.85.128.50])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 90BCE217F5
 for <kvmarm@lists.cs.columbia.edu>; Sun, 30 Jun 2019 04:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1561868999;
 bh=cQSFOfkpKMob0CUu8153N6DUVyC3npdxm62i1j4VpIw=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=j72oOEAif2V94f0mwKfr5J/PRx+YFli4yICxddcq/LIiS7JQ+YKk1YGF4PSgQDKL7
 IMJd+IOSbwJSo6k5b1N04qP590P8btcmtnruiRG/EpAmzvilpIrTFErZtfqeXBnnsi
 04dlqRLB1LypljThQz/jstMx1/Gu9frEnC0Vy7yo=
Received: by mail-wm1-f50.google.com with SMTP id f17so12497748wme.2
 for <kvmarm@lists.cs.columbia.edu>; Sat, 29 Jun 2019 21:29:59 -0700 (PDT)
X-Gm-Message-State: APjAAAVvtuxjeRGc1I3X+f7Rog5YIyp+udfikmV/3o7vEU2zz7vtbO7e
 m02Q3B27FJ3O0jwP5TsEhUKZv0fVi7bKt8ctR5M=
X-Google-Smtp-Source: APXvYqykrDoGZznjGRXJXJkVCBwA9280hX7gYGYy3Dbo1kbGt1iT4Zj+H8TCZ/zglBC8rdfd2ydmBM/xQE7cDlA9Xmo=
X-Received: by 2002:a1c:6545:: with SMTP id z66mr12063849wmb.77.1561868998022; 
 Sat, 29 Jun 2019 21:29:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190321163623.20219-1-julien.grall@arm.com>
 <20190321163623.20219-12-julien.grall@arm.com>
 <0dfe120b-066a-2ac8-13bc-3f5a29e2caa3@arm.com>
 <CAJF2gTTXHHgDboaexdHA284y6kNZVSjLis5-Q2rDnXCxr4RSmA@mail.gmail.com>
 <c871a5ae-914f-a8bb-9474-1dcfec5d45bf@arm.com>
 <CAJF2gTStSR7Jmu7=HaO5Wxz=Zn8A5-RD8ktori3oKEhM9vozAA@mail.gmail.com>
 <20190621141606.GF18954@arrakis.emea.arm.com>
 <CAJF2gTTVUToRkRtxTmtWDotMGXy5YQCpL1h_2neTBuN3e6oz1w@mail.gmail.com>
 <20190624153820.GH29120@arrakis.emea.arm.com>
In-Reply-To: <20190624153820.GH29120@arrakis.emea.arm.com>
From: Guo Ren <guoren@kernel.org>
Date: Sun, 30 Jun 2019 12:29:46 +0800
X-Gmail-Original-Message-ID: <CAJF2gTRUzHUNV+nzECUp5n2L1akdy=Aovb6tSd+PNVnpasBrqw@mail.gmail.com>
Message-ID: <CAJF2gTRUzHUNV+nzECUp5n2L1akdy=Aovb6tSd+PNVnpasBrqw@mail.gmail.com>
Subject: Re: [PATCH RFC 11/14] arm64: Move the ASID allocator code in a
 separate file
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: aou@eecs.berkeley.edu, Marc Zyngier <marc.zyngier@arm.com>,
 Anup Patel <anup.Patel@wdc.com>, Will Deacon <will.deacon@arm.com>,
 linux-kernel@vger.kernel.org, rppt@linux.ibm.com, hch@infradead.org,
 Atish Patra <Atish.Patra@wdc.com>, Julien Grall <julien.grall@arm.com>,
 Palmer Dabbelt <palmer@sifive.com>, gary@garyguo.net, paul.walmsley@sifive.com,
 linux-riscv@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Hi Marinas,

Thx for the reply

On Mon, Jun 24, 2019 at 11:38 PM Catalin Marinas
<catalin.marinas@arm.com> wrote:
>
> On Mon, Jun 24, 2019 at 12:35:35AM +0800, Guo Ren wrote:
> > On Fri, Jun 21, 2019 at 10:16 PM Catalin Marinas
> > <catalin.marinas@arm.com> wrote:
> > > BTW, if you find the algorithm fairly straightforward ;), see this
> > > bug-fix which took a formal model to identify: a8ffaaa060b8 ("arm64:
> > > asid: Do not replace active_asids if already 0").
> [...]
> > Btw, Is this detected by arm's aisd allocator TLA+ model ? Or a real
> > bug report ?
>
> This specific bug was found by the TLA+ model checker (at the time we
> were actually tracking down another bug with multi-threaded CPU sharing
> the TLB, bug also confirmed by the formal model).
Could you tell me the ref-link about "another bug with multi-threaded
CPU sharing the TLB" ?

In my concept, the multi-core asid mechanism is also applicable to
multi-thread shared TLB, but it will generate redundant tlbflush. From
the software design logic, multi-threaded is treated as multi-cores
without error, but performance is not optimized. So in my RFC PATCH:
[1], I try to reduce multi-threads' tlbflush in one CPU core with the
fixed cpu ID bitmap hypothesis.

1: https://lore.kernel.org/linux-csky/CAJF2gTQ0xQtQY1t-g9FgWaxfDXppMkFooCQzTFy7+ouwUfyA6w@mail.gmail.com/T/#m2ed464d2dfb45ac6f5547fb3936adf2da456cb65
--
Best Regards
 Guo Ren

ML: https://lore.kernel.org/linux-csky/
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

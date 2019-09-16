Return-Path: <SRS0=lS5H=XL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39947C49ED7
	for <kvmarm@archiver.kernel.org>; Mon, 16 Sep 2019 18:29:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C0790206C2
	for <kvmarm@archiver.kernel.org>; Mon, 16 Sep 2019 18:29:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="SgPNHmHU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C0790206C2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sifive.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 327384A597;
	Mon, 16 Sep 2019 14:29:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@sifive.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Mz9xo8d5gL-r; Mon, 16 Sep 2019 14:29:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 802504A5BD;
	Mon, 16 Sep 2019 14:29:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 15CA94A597
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Sep 2019 14:29:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fBFLr8RuMOpM for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Sep 2019 14:29:00 -0400 (EDT)
Received: from mail-pl1-f193.google.com (mail-pl1-f193.google.com
 [209.85.214.193])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3DA1B4A588
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Sep 2019 14:29:00 -0400 (EDT)
Received: by mail-pl1-f193.google.com with SMTP id d22so270351pll.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Sep 2019 11:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sifive.com; s=google;
 h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
 :content-transfer-encoding;
 bh=Jp6I/WhdjgXBrLm8XFTV/W2CbBlPUTPrifY9W91dfHI=;
 b=SgPNHmHUI3s6Y5U+Q0BVqT7wuZAahYN9Sp7bvK/WkhmSDCYSm5A+2HKPWAwtkqtGXp
 9J3gPqcUCHFjkPsRUuU3/KOZR1hYBqyd/MNpI1ipdxi9pUvmGf4l8CrTHsTBzP2tIBQ8
 hFmy5Ft2frUue4ny34BBNvYMvx8XYRjMj04QJzEGKwueGRY2SpndnAROT9qoBFdw5EJm
 pmSgIzCOb60ekhNb5wLkLoTTOYA6xXYpqBLK5btuPldjQ2T2RWcShbymrS2g+P20jTDk
 J+EEppal95vaxj+HdoxekXNZMooOdG9AHCiBegMOADmYTE4Cj6LN4ZjAIM8hUT2YUY+H
 p7Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
 :mime-version:content-transfer-encoding;
 bh=Jp6I/WhdjgXBrLm8XFTV/W2CbBlPUTPrifY9W91dfHI=;
 b=QFQTIyHHhanqoZXt4Hdlc1QLPbyoVzcPobMwJ+g7+eJC7ZN0TOax9zXIdC6dYygZcq
 i1JeqW83KRIIbz7y0Yde6Fv19+yfTBYm3+nCooZxp9ybUMt+qTTV5iSyIdDeWi0sfxlE
 o46cbtmRJ5mYnee3QB72mZsS05JTbaRFhZv+4V42D4RQWehWb5BDIuhDekxSehhSXePy
 DwRE7/cGMuYWSlbMW09aDxFaFIOQPsQD5dc/jZAVPFjwua1LTVmBz7XZd704EigpTKWe
 VxnyV+lliKWMymOq1rnn17J9djXdkCKOBszhlQKy22Wh2QjnLsG8tp9ofizXKgL1eaFo
 dG0w==
X-Gm-Message-State: APjAAAXk6Z2Z2UlWQNA/cz8kEjClLyxJekpKq644ZUqOYHKefkq9qrEL
 QViMLOPgCwi200yENGKzl9WjGQ==
X-Google-Smtp-Source: APXvYqyPLzCNMj7vNHvNiodpwn0FVuHbfPgpqBsoZRBBK2pBoeehbEWH1qRowZP5cnYDV+iwsY1UPQ==
X-Received: by 2002:a17:902:5a44:: with SMTP id
 f4mr1093510plm.31.1568658539014; 
 Mon, 16 Sep 2019 11:28:59 -0700 (PDT)
Received: from localhost ([12.206.222.5])
 by smtp.gmail.com with ESMTPSA id a4sm12595350pfn.110.2019.09.16.11.28.57
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 16 Sep 2019 11:28:58 -0700 (PDT)
Date: Mon, 16 Sep 2019 11:28:58 -0700 (PDT)
X-Google-Original-Date: Mon, 16 Sep 2019 11:28:52 PDT (-0700)
Subject: Re: [PATCH RFC 11/14] arm64: Move the ASID allocator code in a
 separate file
In-Reply-To: <20190916181800.7lfpt3t627byoomt@willie-the-truck>
From: Palmer Dabbelt <palmer@sifive.com>
To: will@kernel.org
Message-ID: <mhng-11e0cc7f-264b-4412-9424-2357bc27dcb3@palmer-si-x1c4>
Mime-Version: 1.0 (MHng)
Cc: catalin.marinas@arm.com, Will Deacon <will.deacon@arm.com>,
 Atish Patra <Atish.Patra@wdc.com>, julien.grall@arm.com, guoren@kernel.org,
 gary@garyguo.net, linux-riscv@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, rppt@linux.ibm.com,
 Christoph Hellwig <hch@infradead.org>, aou@eecs.berkeley.edu,
 Arnd Bergmann <arnd@arndb.de>, marc.zyngier@arm.com,
 Paul Walmsley <paul.walmsley@sifive.com>, linux-arm-kernel@lists.infradead.org,
 Anup Patel <Anup.Patel@wdc.com>, linux-kernel@vger.kernel.org,
 iommu@lists.linux-foundation.org
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Mon, 16 Sep 2019 11:18:00 PDT (-0700), will@kernel.org wrote:
> On Sun, Sep 15, 2019 at 05:03:38AM +0000, Anup Patel wrote:
>>
>>
>> > -----Original Message-----
>> > From: linux-kernel-owner@vger.kernel.org <linux-kernel-
>> > owner@vger.kernel.org> On Behalf Of Palmer Dabbelt
>> > Sent: Saturday, September 14, 2019 7:31 PM
>> > To: will@kernel.org
>> > Cc: guoren@kernel.org; Will Deacon <will.deacon@arm.com>;
>> > julien.thierry@arm.com; aou@eecs.berkeley.edu; james.morse@arm.com;
>> > Arnd Bergmann <arnd@arndb.de>; suzuki.poulose@arm.com;
>> > marc.zyngier@arm.com; catalin.marinas@arm.com; Anup Patel
>> > <Anup.Patel@wdc.com>; linux-kernel@vger.kernel.org;
>> > rppt@linux.ibm.com; Christoph Hellwig <hch@infradead.org>; Atish Patra
>> > <Atish.Patra@wdc.com>; julien.grall@arm.com; gary@garyguo.net; Paul
>> > Walmsley <paul.walmsley@sifive.com>; christoffer.dall@arm.com; linux-
>> > riscv@lists.infradead.org; kvmarm@lists.cs.columbia.edu; linux-arm-
>> > kernel@lists.infradead.org; iommu@lists.linux-foundation.org
>> > Subject: Re: [PATCH RFC 11/14] arm64: Move the ASID allocator code in a
>> > separate file
>> >
>> > On Thu, 12 Sep 2019 07:02:56 PDT (-0700), will@kernel.org wrote:
>> > > On Sun, Sep 08, 2019 at 07:52:55AM +0800, Guo Ren wrote:
>> > >> On Mon, Jun 24, 2019 at 6:40 PM Will Deacon <will@kernel.org> wrote:
>> > >> > > I'll keep my system use the same ASID for SMP + IOMMU :P
>> > >> >
>> > >> > You will want a separate allocator for that:
>> > >> >
>> > >> > https://lkml.kernel.org/r/20190610184714.6786-2-jean-philippe.bruck
>> > >> > er@arm.com
>> > >>
>> > >> Yes, it is hard to maintain ASID between IOMMU and CPUMMU or
>> > >> different system, because it's difficult to synchronize the IO_ASID
>> > >> when the CPU ASID is rollover.
>> > >> But we could still use hardware broadcast TLB invalidation
>> > >> instruction to uniformly manage the ASID and IO_ASID, or OTHER_ASID in
>> > our IOMMU.
>> > >
>> > > That's probably a bad idea, because you'll likely stall execution on
>> > > the CPU until the IOTLB has completed invalidation. In the case of
>> > > ATS, I think an endpoint ATC is permitted to take over a minute to
>> > > respond. In reality, I suspect the worst you'll ever see would be in
>> > > the msec range, but that's still an unacceptable period of time to hold a
>> > CPU.
>> > >
>> > >> Welcome to join our disscusion:
>> > >> "Introduce an implementation of IOMMU in linux-riscv"
>> > >> 9 Sep 2019, 10:45 Jade-room-I&II (Corinthia Hotel Lisbon) RISC-V MC
>> > >
>> > > I attended this session, but it unfortunately raised many more
>> > > questions than it answered.
>> >
>> > Ya, we're a long way from figuring this out.
>>
>> For everyone's reference, here is our first attempt at RISC-V ASID allocator:
>> http://archive.lwn.net:8080/linux-kernel/20190329045111.14040-1-anup.patel@wdc.com/T/#u
>
> With a reply stating that the patch "absolutely does not work" ;)
>
> What exactly do you want people to do with that? It's an awful lot of effort
> to review this sort of stuff and given that Guo Ren is talking about sharing
> page tables between the CPU and an accelerator, maybe you're better off
> stabilising Linux for the platforms that you can actually test rather than
> getting so far ahead of yourselves that you end up with a bunch of wasted
> work on patches that probably won't get merged any time soon.
>
> Seriously, they say "walk before you can run", but this is more "crawl
> before you can fly". What's the rush?

I agree, and I think I've been pretty clear here: we're not merging this ASID 
stuff until we have a platform we can test on, particularly as the platforms we 
have now already need some wacky hacks around TLB flushing that we haven't 
gotten to the bottom of.

> Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

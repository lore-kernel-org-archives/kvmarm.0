Return-Path: <SRS0=SaMm=XH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 459ECC4CEC5
	for <kvmarm@archiver.kernel.org>; Thu, 12 Sep 2019 15:00:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BCC332081B
	for <kvmarm@archiver.kernel.org>; Thu, 12 Sep 2019 15:00:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mp8tMCnH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BCC332081B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 623D54A64E;
	Thu, 12 Sep 2019 11:00:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Tcj+aFjENSIs; Thu, 12 Sep 2019 11:00:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FD5B4A650;
	Thu, 12 Sep 2019 11:00:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FDBD4A64E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Sep 2019 10:59:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Q0C+bN4zO9RJ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Sep 2019 10:59:58 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 574764A60D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Sep 2019 10:59:58 -0400 (EDT)
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com
 [209.85.221.52])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 1361C216F4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Sep 2019 14:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1568300397;
 bh=RK47i9JzV2o8zYa+doB7UiayI/FwXMaWv5Ml8LccsgY=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=Mp8tMCnHBMtri7nKuvpjSoNW3SBhD9Q2PQQus+HoDhqqsO2hfh5+kB+09qrWUHo06
 Xg50YZM1a8zDvFIJJv0CI/EvakHiQne0lhgmu9mtHuf7+l8qkR8L3fuEBxSzlzY4/S
 /qPsvdajQdsWoOvQTd8Ut5MEZxBU2HYNYlaTeYNs=
Received: by mail-wr1-f52.google.com with SMTP id q17so24128756wrx.10
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Sep 2019 07:59:56 -0700 (PDT)
X-Gm-Message-State: APjAAAW525QrhjzjEXfUUNztEHo/yOA4iuy9y5hVR5LeD3Q8LsWd97nA
 fCKaZ2NYN2TNJ1K2Onf4TSIYEA0PF9N7olKQEFg=
X-Google-Smtp-Source: APXvYqyWrVR+NI16eudQNtduL1OAxnO0WQ4SkOLjY2AVyz5N6syNQZ1qE/5QhN1PWc17kzrEkpHSXdkh4aFf0C6oOhM=
X-Received: by 2002:a5d:6b49:: with SMTP id x9mr12703438wrw.80.1568300395358; 
 Thu, 12 Sep 2019 07:59:55 -0700 (PDT)
MIME-Version: 1.0
References: <20190321163623.20219-12-julien.grall@arm.com>
 <0dfe120b-066a-2ac8-13bc-3f5a29e2caa3@arm.com>
 <CAJF2gTTXHHgDboaexdHA284y6kNZVSjLis5-Q2rDnXCxr4RSmA@mail.gmail.com>
 <c871a5ae-914f-a8bb-9474-1dcfec5d45bf@arm.com>
 <20190619091219.GB7767@fuggles.cambridge.arm.com>
 <CAJF2gTTmFq3yYa9UrdZRAFwJgC=KmKTe2_NFy_UZBUQovqQJPg@mail.gmail.com>
 <20190619123939.GF7767@fuggles.cambridge.arm.com>
 <CAJF2gTSiiiewTLwVAXvPLO7rTSUw1rg8VtFLzANdP2S2EEbTjg@mail.gmail.com>
 <20190624104006.lvm32nahemaqklxc@willie-the-truck>
 <CAJF2gTSC1sGgmiTCgzKUTdPyUZ3LG4H7N8YbMyWr-E+eifGuYg@mail.gmail.com>
 <20190912140256.fwbutgmadpjbjnab@willie-the-truck>
In-Reply-To: <20190912140256.fwbutgmadpjbjnab@willie-the-truck>
From: Guo Ren <guoren@kernel.org>
Date: Thu, 12 Sep 2019 15:59:43 +0100
X-Gmail-Original-Message-ID: <CAJF2gTT2c45HRfATF+=zs-HNToFAKgq1inKRmJMV3uPYBo4iVg@mail.gmail.com>
Message-ID: <CAJF2gTT2c45HRfATF+=zs-HNToFAKgq1inKRmJMV3uPYBo4iVg@mail.gmail.com>
Subject: Re: [PATCH RFC 11/14] arm64: Move the ASID allocator code in a
 separate file
To: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Palmer Dabbelt <palmer@sifive.com>, Will Deacon <will.deacon@arm.com>,
 Atish Patra <Atish.Patra@wdc.com>, Julien Grall <julien.grall@arm.com>,
 gary@garyguo.net, linux-riscv@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, Mike Rapoport <rppt@linux.ibm.com>,
 Christoph Hellwig <hch@infradead.org>, aou@eecs.berkeley.edu,
 Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <marc.zyngier@arm.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, linux-arm-kernel@lists.infradead.org,
 Anup Patel <anup.Patel@wdc.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Thx Will for reply.

On Thu, Sep 12, 2019 at 3:03 PM Will Deacon <will@kernel.org> wrote:
>
> On Sun, Sep 08, 2019 at 07:52:55AM +0800, Guo Ren wrote:
> > On Mon, Jun 24, 2019 at 6:40 PM Will Deacon <will@kernel.org> wrote:
> > > > I'll keep my system use the same ASID for SMP + IOMMU :P
> > >
> > > You will want a separate allocator for that:
> > >
> > > https://lkml.kernel.org/r/20190610184714.6786-2-jean-philippe.brucker@arm.com
> >
> > Yes, it is hard to maintain ASID between IOMMU and CPUMMU or different
> > system, because it's difficult to synchronize the IO_ASID when the CPU
> > ASID is rollover.
> > But we could still use hardware broadcast TLB invalidation instruction
> > to uniformly manage the ASID and IO_ASID, or OTHER_ASID in our IOMMU.
>
> That's probably a bad idea, because you'll likely stall execution on the
> CPU until the IOTLB has completed invalidation. In the case of ATS, I think
> an endpoint ATC is permitted to take over a minute to respond. In reality, I
> suspect the worst you'll ever see would be in the msec range, but that's
> still an unacceptable period of time to hold a CPU.
Just as I've said in the session that IOTLB invalidate delay is
another topic, My main proposal is to introduce stage1.pgd and
stage2.pgd as address space identifiers between different TLB systems
based on vmid, asid. My last part of sildes will show you how to
translate stage1/2.pgd to as/vmid in PCI ATS system and the method
could work with SMMU-v3 and intel Vt-d. (It's regret for me there is
no time to show you the whole slides.)

In our light IOMMU implementation, there's no IOTLB invalidate delay
problem. Becasue IOMMU is very close to CPU MMU and interconnect's
delay is the same with SMP CPUs MMU (no PCI, VM supported).

To solve the problem, we could define a async mode in sfence.vma.b to
slove the problem and finished with per_cpu_irq/exception.

-- 
Best Regards
 Guo Ren

ML: https://lore.kernel.org/linux-csky/
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

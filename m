Return-Path: <SRS0=xcs2=UY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44CF6C48BD6
	for <kvmarm@archiver.kernel.org>; Tue, 25 Jun 2019 07:25:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C254C2085A
	for <kvmarm@archiver.kernel.org>; Tue, 25 Jun 2019 07:25:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C254C2085A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sifive.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F009E4A4EA;
	Tue, 25 Jun 2019 03:25:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id S0cyW5yVCDUE; Tue, 25 Jun 2019 03:25:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A6954A4DF;
	Tue, 25 Jun 2019 03:25:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D2264A4CA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jun 2019 03:25:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Yhj+Bda63Kck for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 Jun 2019 03:25:37 -0400 (EDT)
Received: from mail-pl1-f194.google.com (mail-pl1-f194.google.com
 [209.85.214.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B57094A2E7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jun 2019 03:25:37 -0400 (EDT)
Received: by mail-pl1-f194.google.com with SMTP id g4so8330341plb.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jun 2019 00:25:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
 :mime-version:content-transfer-encoding;
 bh=Z3WWGekE9WOmOiZaVOcy0eK3dDuIi2y2iQU5uOWyNfM=;
 b=pbRP2dBdTIbSA6ba/Tj62mCAIyieR/q9mQIu5fUsobN7uUjGecGwOnja3coFlzga5g
 JuARDYZ010EdMX4xYlzrSMQ4+/SQIHD3KjGhPsHGyfg7x4R8i3dkdUaOVKceJbA05G2b
 SBPt3sl3NQkkekYUCC4WTyuNyC9PGrzQAkQrBRX+eghMZp7Y82zRvlqwdMmm5Jr33Pvg
 qhLW0cCqnLqfbEnVE5Te3D8Gd2UBk91G5dEcjde61wg3cUF4Z+2VkWKjydr6pzA1hfoD
 awGqwd/UETHwzWLE0N6jaW/vechDRjOSNaa8gN/Fvx/GcmdfzJor3Jdj3kkwBv1gz7qV
 Y1iA==
X-Gm-Message-State: APjAAAWn0NLA1Dv6XMAA64YS8HueFyEV90ymeza5OVFt1pNrCX9NwGv1
 XQa+iN+IF0CVUlwFI3bvpprp2g==
X-Google-Smtp-Source: APXvYqyyNFqs8lEkqeWGIhFL1bL0p1mZU4/eLR8SPEZ1IWEPKLjr4nvS7kG+gigCSnFaxi9vTjiBWQ==
X-Received: by 2002:a17:902:b187:: with SMTP id
 s7mr61161997plr.309.1561447536395; 
 Tue, 25 Jun 2019 00:25:36 -0700 (PDT)
Received: from localhost (220-132-236-182.HINET-IP.hinet.net.
 [220.132.236.182])
 by smtp.gmail.com with ESMTPSA id k6sm15713401pfi.12.2019.06.25.00.25.35
 (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
 Tue, 25 Jun 2019 00:25:35 -0700 (PDT)
Date: Tue, 25 Jun 2019 00:25:35 -0700 (PDT)
X-Google-Original-Date: Mon, 24 Jun 2019 23:55:16 PDT (-0700)
Subject: Re: [PATCH RFC 11/14] arm64: Move the ASID allocator code in a
 separate file
In-Reply-To: <20190624104006.lvm32nahemaqklxc@willie-the-truck>
From: Palmer Dabbelt <palmer@sifive.com>
To: will@kernel.org
Message-ID: <mhng-9933e914-263f-4bb9-9bc5-3a75957e7da0@palmer-si-x1e>
Mime-Version: 1.0 (MHng)
Cc: julien.grall@arm.com, aou@eecs.berkeley.edu, Arnd Bergmann <arnd@arndb.de>,
 marc.zyngier@arm.com, catalin.marinas@arm.com,
 Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
 rppt@linux.ibm.com, Christoph Hellwig <hch@infradead.org>,
 Atish Patra <Atish.Patra@wdc.com>, Anup Patel <Anup.Patel@wdc.com>,
 guoren@kernel.org, gary@garyguo.net, Paul Walmsley <paul.walmsley@sifive.com>,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Mon, 24 Jun 2019 03:40:07 PDT (-0700), will@kernel.org wrote:
> On Thu, Jun 20, 2019 at 05:33:03PM +0800, Guo Ren wrote:
>> On Wed, Jun 19, 2019 at 8:39 PM Will Deacon <will.deacon@arm.com> wrote:
>> >
>> > On Wed, Jun 19, 2019 at 08:18:04PM +0800, Guo Ren wrote:
>> > > On Wed, Jun 19, 2019 at 5:12 PM Will Deacon <will.deacon@arm.com> wrote:
>> > > > This is one place where I'd actually prefer not to go down the route of
>> > > > making the code generic. Context-switching and low-level TLB management
>> > > > is deeply architecture-specific and I worry that by trying to make this
>> > > > code common, we run the real risk of introducing subtle bugs on some
>> > > > architecture every time it is changed.
>> > > "Add generic asid code" and "move arm's into generic" are two things.
>> > > We could do
>> > > first and let architecture's maintainer to choose.
>> >
>> > If I understand the proposal being discussed, it involves basing that
>> > generic ASID allocation code around the arm64 implementation which I don't
>> > necessarily think is a good starting point.
>> ...
>> >
>> > > > Furthermore, the algorithm we use
>> > > > on arm64 is designed to scale to large systems using DVM and may well be
>> > > > too complex and/or sub-optimal for architectures with different system
>> > > > topologies or TLB invalidation mechanisms.
>> > > It's just a asid algorithm not very complex and there is a callback
>> > > for architecture to define their
>> > > own local hart tlb flush. Seems it has nothing with DVM or tlb
>> > > broadcast mechanism.
>> >
>> > I'm pleased that you think the algorithm is not very complex, but I'm also
>> > worried that you might not have fully understood some of its finer details.
>> I understand your concern about my less understanding of asid
>> technology. Here is
>> my short-description of arm64 asid allocator: (If you find anything
>> wrong, please
>> correct me directly, thx :)
>
> The complexity mainly comes from the fact that this thing runs concurrently
> with itself without synchronization on the fast-path. Coupled with the
> need to use the same ASID for all threads of a task, you end up in fiddly
> situations where rollover can occur on one CPU whilst another CPU is trying
> to schedule a thread of a task that already has threads running in
> userspace.
>
> However, it's architecture-specific whether or not you care about that
> scenario.
>
>> > The reason I mention DVM and TLB broadcasting is because, depending on
>> > the mechanisms in your architecture relating to those, it may be strictly
>> > required that all concurrently running threads of a process have the same
>> > ASID at any given point in time, or it may be that you really don't care.
>> >
>> > If you don't care, then the arm64 allocator is over-engineered and likely
>> > inefficient for your system. If you do care, then it's worth considering
>> > whether a lock is sufficient around the allocator if you don't expect high
>> > core counts. Another possibility is that you end up using only one ASID and
>> > invalidating the local TLB on every context switch. Yet another design
>> > would be to manage per-cpu ASID pools.

FWIW: right now we don't have any implementations that support ASIDs, so we're
really not ready to make these sort of decisions because we just don't know
what systems are going to look like.  While it's a fun intellectual exercise to
try to design an allocator that would work acceptably on systems of various
shapes, there's no way to test this for performance or correctness right now so
I wouldn't be comfortable taking anything.  If you're really interested, the
right place to start is the RTL

    https://github.com/chipsalliance/rocket-chip/blob/master/src/main/scala/rocket/TLB.scala#L19

This is essentially the same problem we have for our spinlocks -- maybe start
with the TLB before doing a whole new pipeline, though :)

>> I'll keep my system use the same ASID for SMP + IOMMU :P
>
> You will want a separate allocator for that:
>
> https://lkml.kernel.org/r/20190610184714.6786-2-jean-philippe.brucker@arm.com
>
>> Yes, there are two styles of asid allocator: per-cpu ASID (MIPS) or
>> same ASID (ARM).
>> If the CPU couldn't support cache/tlb coherency maintian in hardware,
>> it should use
>> per-cpu ASID style because IPI is expensive and per-cpu ASID style
>> need more software
>> mechanism to improve performance (eg: delay cache flush). From software view the
>> same ASID is clearer and easier to build bigger system with more TLB caches.
>>
>> I think the same ASID style is a more sensible choice for modern
>> processor and let it be
>> one of generic is reasonable.
>
> I'm not sure I agree. x86, for example, is better off using a different
> algorithm for allocating its PCIDs.
>
>> > So rather than blindly copying the arm64 code, I suggest sitting down and
>> > designing something that fits to your architecture instead. You may end up
>> > with something that is both simpler and more efficient.
>> In fact, riscv folks have discussed a lot about arm's asid allocator
>> and I learned
>> a lot from the discussion:
>> https://lore.kernel.org/linux-riscv/20190327100201.32220-1-anup.patel@wdc.com/
>
> If you require all threads of the same process to have the same ASID, then
> that patch looks broken to me.
>
> Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <SRS0=nXD4=XJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3465C4CEC7
	for <kvmarm@archiver.kernel.org>; Sat, 14 Sep 2019 14:01:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 79B0020717
	for <kvmarm@archiver.kernel.org>; Sat, 14 Sep 2019 14:01:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 79B0020717
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sifive.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C792F4A69E;
	Sat, 14 Sep 2019 10:01:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NOSQP6z99i15; Sat, 14 Sep 2019 10:01:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B9E3A4A69B;
	Sat, 14 Sep 2019 10:01:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 812CB4A69B
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Sep 2019 10:01:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sXsVJJzantRX for <kvmarm@lists.cs.columbia.edu>;
 Sat, 14 Sep 2019 10:01:31 -0400 (EDT)
Received: from mail-pl1-f196.google.com (mail-pl1-f196.google.com
 [209.85.214.196])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6D3A34A698
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Sep 2019 10:01:31 -0400 (EDT)
Received: by mail-pl1-f196.google.com with SMTP id t1so14538486plq.13
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Sep 2019 07:01:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
 :mime-version:content-transfer-encoding;
 bh=SXwC5T6wCRhaSBRQu04uBARGF1aDUDc2HyVfMMcCfp8=;
 b=J5vZXB6qwYyIhgOqlJY8xoASLaBYe3xueqOZDHZcq3ZuuX6F+/6wFK1RlxoWem8s9I
 IyOri+vdiRjKREcAzy9WnPk9WIEsU+MRsiElbqNYIEPyU9nUE3Rym0XwzB1ab7hzXptk
 eYK5v3VXfnM5AXtvCyBYrDVwICAkXmwHVRzkgVTQaJRTczxUeM/5AHJM81iv0DVFElIP
 JeVagYSX8dZohJTpHlvhbzYe5rq5uhyP2SOxbe/PQYxBVgE4nwdhkYZza81rlwkkM1L1
 jU9O/2kf9HKTIZLENzaH/x9XU2q624DbhymPQvIz60ARa2y7V1FDPzOn7zfIhZguCu+q
 wLNA==
X-Gm-Message-State: APjAAAXjGVhpaLv6eC6gUnocyyaZZLtK7WtsD3HPk5GZzgIkILhbkVjy
 y+wgeUT3X+GSxQDRSYQaBzZJBg==
X-Google-Smtp-Source: APXvYqwLzMQI8pZxkVqd8/Fy8A16315KeB9n6NzIBBSxCASBhPGKSRyvm9h7GHG8COZItU0wdTcuOQ==
X-Received: by 2002:a17:902:d685:: with SMTP id
 v5mr16361073ply.15.1568469690307; 
 Sat, 14 Sep 2019 07:01:30 -0700 (PDT)
Received: from localhost (amx-tls3.starhub.net.sg. [203.116.164.13])
 by smtp.gmail.com with ESMTPSA id u17sm6671227pgf.8.2019.09.14.07.01.27
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 14 Sep 2019 07:01:29 -0700 (PDT)
Date: Sat, 14 Sep 2019 07:01:29 -0700 (PDT)
X-Google-Original-Date: Sat, 14 Sep 2019 07:00:16 PDT (-0700)
Subject: Re: [PATCH RFC 11/14] arm64: Move the ASID allocator code in a
 separate file
In-Reply-To: <20190912140256.fwbutgmadpjbjnab@willie-the-truck>
From: Palmer Dabbelt <palmer@sifive.com>
To: will@kernel.org
Message-ID: <mhng-166dcd4f-9483-4aab-a83a-914d70ddb5a4@palmer-si-x1e>
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

On Thu, 12 Sep 2019 07:02:56 PDT (-0700), will@kernel.org wrote:
> On Sun, Sep 08, 2019 at 07:52:55AM +0800, Guo Ren wrote:
>> On Mon, Jun 24, 2019 at 6:40 PM Will Deacon <will@kernel.org> wrote:
>> > > I'll keep my system use the same ASID for SMP + IOMMU :P
>> >
>> > You will want a separate allocator for that:
>> >
>> > https://lkml.kernel.org/r/20190610184714.6786-2-jean-philippe.brucker@arm.com
>>
>> Yes, it is hard to maintain ASID between IOMMU and CPUMMU or different
>> system, because it's difficult to synchronize the IO_ASID when the CPU
>> ASID is rollover.
>> But we could still use hardware broadcast TLB invalidation instruction
>> to uniformly manage the ASID and IO_ASID, or OTHER_ASID in our IOMMU.
>
> That's probably a bad idea, because you'll likely stall execution on the
> CPU until the IOTLB has completed invalidation. In the case of ATS, I think
> an endpoint ATC is permitted to take over a minute to respond. In reality, I
> suspect the worst you'll ever see would be in the msec range, but that's
> still an unacceptable period of time to hold a CPU.
>
>> Welcome to join our disscusion:
>> "Introduce an implementation of IOMMU in linux-riscv"
>> 9 Sep 2019, 10:45 Jade-room-I&II (Corinthia Hotel Lisbon) RISC-V MC
>
> I attended this session, but it unfortunately raised many more questions
> than it answered.

Ya, we're a long way from figuring this out.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

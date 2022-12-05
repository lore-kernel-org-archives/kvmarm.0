Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEBB2C47088
	for <kvmarm@archiver.kernel.org>; Mon,  5 Dec 2022 05:51:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 45A004B17D;
	Mon,  5 Dec 2022 00:51:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fOXtfvJ6WlzY; Mon,  5 Dec 2022 00:51:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C1D841175;
	Mon,  5 Dec 2022 00:51:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 245C941175
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Dec 2022 00:51:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U34VfSuWMk+7 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Dec 2022 00:51:19 -0500 (EST)
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com
 [209.85.214.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 015A6403AD
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Dec 2022 00:51:18 -0500 (EST)
Received: by mail-pl1-f169.google.com with SMTP id jn7so9829287plb.13
 for <kvmarm@lists.cs.columbia.edu>; Sun, 04 Dec 2022 21:51:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date:from:to
 :cc:subject:date:message-id:reply-to;
 bh=n/3g71sZYS1arRrHDyi+DR5mNcLeU7WNBhjw+Wlf1Xo=;
 b=cYn/nAw0Ws61jXvBUhPM1vmJHkD/22vD2Sn3+K76w49Kp0zmUsPPU5hXVO+Bu0lhGv
 LqqdTpLXMwAPIiOXhJ6/8In4cIc0ghPIPrRGwz3wLvfTp8mJcsDxf/FRcwEZZphNYN5K
 qzvehgWBe2G+o3n5QApbNmxjmPsCufAlX/mpu++RZAtH+n95AGwSshQEIpVuH1pMxnzR
 8NEp9TxYsqyb7C2ioTAH6NNx0C1+D4CJp1usSM8gWP8FMg+xKsvmbDBwrhYydG96vK7g
 00bh15sXZtXt1ZgHlrGNPSmqH7VN9ats6dDDrt2U2oDEDQUcOMeU0fiJta0w/iIFyUql
 inzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=n/3g71sZYS1arRrHDyi+DR5mNcLeU7WNBhjw+Wlf1Xo=;
 b=gptrLLrbsW+8I/EYsO71M7joRc6Iyvqf1MSYBzRorJ77AZ2pKzxt+05U0bkmBLz4KI
 /2aFGCJ99ktAI1vD7FjwsFF94e7h99BShz1hGTHn8IEZtZehjQhbRxfiKoB+cN7cPYwg
 MwbFYT2JHS7oMq1in6iOMURo5HhhCYVNgf6zbz+qba0zDyCkFi8YGD1Y9pFV3njQ+9V1
 6igcItWj20z1lBtqNoHIRsNJ8fkIElwW22c2/Fz04D0ZHcaYVDfMPyUXEgilrmLf69F1
 l/gQXAoBksbfKw8bF1ma5aPLA3AyKz6ZAa7KV7N+Y1NBfcq/c7tzh1dIeHdgnIx7givd
 QaYw==
X-Gm-Message-State: ANoB5pnOv9ham4t8PDhvuNyvsZre8gjEHtJwuWn4IxRqlnurI1jqYKlH
 3eDHhQwOQOiy89ghJtOEQ51Rxg==
X-Google-Smtp-Source: AA0mqf6kWqWPoKVUaLvRbnwYzzWjm6w9AFHV5qTk3d/QQMh6okJGCJdU1eiiRoC9l1A93Sa97YH/vg==
X-Received: by 2002:a17:902:e8c1:b0:189:c948:14a4 with SMTP id
 v1-20020a170902e8c100b00189c94814a4mr8532451plg.74.1670219477737; 
 Sun, 04 Dec 2022 21:51:17 -0800 (PST)
Received: from google.com (33.5.83.34.bc.googleusercontent.com. [34.83.5.33])
 by smtp.gmail.com with ESMTPSA id
 lx3-20020a17090b4b0300b002195819d541sm261423pjb.8.2022.12.04.21.51.16
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 04 Dec 2022 21:51:16 -0800 (PST)
Date: Mon, 5 Dec 2022 05:51:13 +0000
From: Mingwei Zhang <mizhang@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH v5 08/14] KVM: arm64: Protect stage-2 traversal with RCU
Message-ID: <Y42G0c9yBk2KHc+g@google.com>
References: <20221107215644.1895162-1-oliver.upton@linux.dev>
 <20221107215644.1895162-9-oliver.upton@linux.dev>
 <CGME20221114142915eucas1p258f3ca2c536bde712c068e96851468fd@eucas1p2.samsung.com>
 <d9854277-0411-8169-9e8b-68d15e4c0248@samsung.com>
 <Y3J97ZTef8HLUv4i@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Y3J97ZTef8HLUv4i@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev,
 Ben Gardon <bgardon@google.com>, David Matlack <dmatlack@google.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Marek Szyprowski <m.szyprowski@samsung.com>
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
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Mon, Nov 14, 2022, Oliver Upton wrote:
> Hi Marek,
> =

> On Mon, Nov 14, 2022 at 03:29:14PM +0100, Marek Szyprowski wrote:
> > This patch landed in today's linux-next (20221114) as commit =

> > c3119ae45dfb ("KVM: arm64: Protect stage-2 traversal with RCU"). =

> > Unfortunately it introduces a following warning:
> =

> Thanks for the bug report :) I had failed to test nVHE in the past few
> revisions of this series.
> =

> > --->8---
> > =

> > kvm [1]: IPA Size Limit: 40 bits
> > BUG: sleeping function called from invalid context at =

> > include/linux/sched/mm.h:274
> > in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 1, name: swapper=
/0
> > preempt_count: 0, expected: 0
> > RCU nest depth: 1, expected: 0
> > 2 locks held by swapper/0/1:
> >  =A0#0: ffff80000a8a44d0 (kvm_hyp_pgd_mutex){+.+.}-{3:3}, at: =

> > __create_hyp_mappings+0x80/0xc4
> >  =A0#1: ffff80000a927720 (rcu_read_lock){....}-{1:2}, at: =

> > kvm_pgtable_walk+0x0/0x1f4
> > CPU: 2 PID: 1 Comm: swapper/0 Not tainted 6.1.0-rc3+ #5918
> > Hardware name: Raspberry Pi 3 Model B (DT)
> > Call trace:
> >  =A0dump_backtrace.part.0+0xe4/0xf0
> >  =A0show_stack+0x18/0x40
> >  =A0dump_stack_lvl+0x8c/0xb8
> >  =A0dump_stack+0x18/0x34
> >  =A0__might_resched+0x178/0x220
> >  =A0__might_sleep+0x48/0xa0
> >  =A0prepare_alloc_pages+0x178/0x1a0
> >  =A0__alloc_pages+0x9c/0x109c
> >  =A0alloc_page_interleave+0x1c/0xc4
> >  =A0alloc_pages+0xec/0x160
> >  =A0get_zeroed_page+0x1c/0x44
> >  =A0kvm_hyp_zalloc_page+0x14/0x20
> >  =A0hyp_map_walker+0xd4/0x134
> >  =A0kvm_pgtable_visitor_cb.isra.0+0x38/0x5c
> >  =A0__kvm_pgtable_walk+0x1a4/0x220
> >  =A0kvm_pgtable_walk+0x104/0x1f4
> >  =A0kvm_pgtable_hyp_map+0x80/0xc4
> >  =A0__create_hyp_mappings+0x9c/0xc4
> >  =A0kvm_mmu_init+0x144/0x1cc
> >  =A0kvm_arch_init+0xe4/0xef4
> >  =A0kvm_init+0x3c/0x3d0
> >  =A0arm_init+0x20/0x30
> >  =A0do_one_initcall+0x74/0x400
> >  =A0kernel_init_freeable+0x2e0/0x350
> >  =A0kernel_init+0x24/0x130
> >  =A0ret_from_fork+0x10/0x20
> > kvm [1]: Hyp mode initialized successfully
> > =

> > --->8----
> > =

> > I looks that more changes in the KVM code are needed to use RCU for tha=
t =

> > code.
> =

> Right, the specific issue is that while the stage-2 walkers preallocate
> any table memory they may need, the hyp walkers do not and allocate
> inline.
> =

> As hyp stage-1 is protected by a spinlock there is no actual need for
> RCU in that case. I'll post something later on today that addresses the
> issue.
> =


For each stage-2 page table walk, KVM will use
kvm_mmu_topup_memory_cache() before taking the mmu lock. This ensures
whoever holding the mmu lock won't sleep. hyp walkers seems to
miss  this notion completely, whic makes me puzzeled. Using a spinlock
only ensures functionality but seems quite inefficient if the one who
holds the spinlock try to allocate pages and sleep...

But that seems to be a separate problem for nvhe. Why do we need an RCU
lock here. Oh is it for batching?
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

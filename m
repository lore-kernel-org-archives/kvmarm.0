Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CF3FC4321E
	for <kvmarm@archiver.kernel.org>; Mon,  5 Dec 2022 07:47:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 80B154B199;
	Mon,  5 Dec 2022 02:47:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PDflnHNBru9l; Mon,  5 Dec 2022 02:47:54 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5687640B6C;
	Mon,  5 Dec 2022 02:47:54 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BFB714042A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Dec 2022 02:47:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eQMEo20xEHBR for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Dec 2022 02:47:52 -0500 (EST)
Received: from out-22.mta0.migadu.com (out-22.mta0.migadu.com [91.218.175.22])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 64246403CD
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Dec 2022 02:47:52 -0500 (EST)
Date: Mon, 5 Dec 2022 07:47:45 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1670226470;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=SFXhjNJg/VGPR+qxqlId1yoMGevAJPF/9BAlI3Cx2LA=;
 b=LJp3jOesyzRjTIuPb3DvoBKpuxdiD0unikmxKd/WI9yo1C1EXz5ugIhfzHFePqnQa4WDFD
 jPgrMzq9BgeuTbF7NIP2T3Z3TQgYU4WESPWTJHyzBe/fPwtZaZq/6Dv7WhmjlIVbq+rRiC
 o4NsCnDOQi4URroo/lRFqwzzWrLSs7c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Mingwei Zhang <mizhang@google.com>
Subject: Re: [PATCH v5 08/14] KVM: arm64: Protect stage-2 traversal with RCU
Message-ID: <Y42iIXWbwxQ138fI@google.com>
References: <20221107215644.1895162-1-oliver.upton@linux.dev>
 <20221107215644.1895162-9-oliver.upton@linux.dev>
 <CGME20221114142915eucas1p258f3ca2c536bde712c068e96851468fd@eucas1p2.samsung.com>
 <d9854277-0411-8169-9e8b-68d15e4c0248@samsung.com>
 <Y3J97ZTef8HLUv4i@google.com> <Y42G0c9yBk2KHc+g@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Y42G0c9yBk2KHc+g@google.com>
X-Migadu-Flow: FLOW_OUT
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Mingwei,

On Mon, Dec 05, 2022 at 05:51:13AM +0000, Mingwei Zhang wrote:
> On Mon, Nov 14, 2022, Oliver Upton wrote:

[...]

> > As hyp stage-1 is protected by a spinlock there is no actual need for
> > RCU in that case. I'll post something later on today that addresses the
> > issue.
> > 
> 
> For each stage-2 page table walk, KVM will use
> kvm_mmu_topup_memory_cache() before taking the mmu lock. This ensures
> whoever holding the mmu lock won't sleep. hyp walkers seems to
> miss  this notion completely, whic makes me puzzeled. Using a spinlock
> only ensures functionality but seems quite inefficient if the one who
> holds the spinlock try to allocate pages and sleep...

You're probably confused by my mischaracterization in the above
paragraph. Hyp stage-1 walkers (outside of pKVM) are guarded with a
mutex and are perfectly able to sleep. The erroneous application of RCU
led to this path becoming non-sleepable, hence the bug.

pKVM's own hyp stage-1 walkers are guarded by a spinlock, but the memory
allocations come from its own allocator and there is no concept of a
scheduler at EL2.

> Why do we need an RCU lock here. Oh is it for batching?

We definitely don't need RCU here, thus the corrective measure was to
avoid RCU for exclusive table walks.

https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git/commit/?h=next&id=b7833bf202e3068abb77c642a0843f696e9c8d38

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

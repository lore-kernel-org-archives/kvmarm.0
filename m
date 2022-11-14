Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D34B4C4332F
	for <kvmarm@archiver.kernel.org>; Mon, 14 Nov 2022 17:42:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 39DD74B9C7;
	Mon, 14 Nov 2022 12:42:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id B1jcsmPkj1OS; Mon, 14 Nov 2022 12:42:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E54584B9E3;
	Mon, 14 Nov 2022 12:42:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DCCA54B9C7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Nov 2022 12:42:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JB4Ny2DWsqvc for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Nov 2022 12:42:11 -0500 (EST)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A35874B97E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Nov 2022 12:42:11 -0500 (EST)
Date: Mon, 14 Nov 2022 17:42:05 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1668447730;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=81grqjfzDbXvj/kXaN38dFg6IyEuzMGxJS1cZ3BwExg=;
 b=BYYs+S93PrA9vVkBPWsRJ92HUs5Bu24WxHWBumocLkBoLuv73fHHvwn4/0+o2MapvGeTyT
 RPXB5tTSzzkHJlhJt2zzpoKv+E3mEZPegjVH8mRb1KektxarogfmLvmou14ILn5UAplWns
 JjLprqhlcu/VJzDptSMXok7eHx8HAnk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v5 08/14] KVM: arm64: Protect stage-2 traversal with RCU
Message-ID: <Y3J97ZTef8HLUv4i@google.com>
References: <20221107215644.1895162-1-oliver.upton@linux.dev>
 <20221107215644.1895162-9-oliver.upton@linux.dev>
 <CGME20221114142915eucas1p258f3ca2c536bde712c068e96851468fd@eucas1p2.samsung.com>
 <d9854277-0411-8169-9e8b-68d15e4c0248@samsung.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <d9854277-0411-8169-9e8b-68d15e4c0248@samsung.com>
X-Migadu-Flow: FLOW_OUT
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev,
 Ben Gardon <bgardon@google.com>, David Matlack <dmatlack@google.com>,
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
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marek,

On Mon, Nov 14, 2022 at 03:29:14PM +0100, Marek Szyprowski wrote:
> This patch landed in today's linux-next (20221114) as commit =

> c3119ae45dfb ("KVM: arm64: Protect stage-2 traversal with RCU"). =

> Unfortunately it introduces a following warning:

Thanks for the bug report :) I had failed to test nVHE in the past few
revisions of this series.

> --->8---
> =

> kvm [1]: IPA Size Limit: 40 bits
> BUG: sleeping function called from invalid context at =

> include/linux/sched/mm.h:274
> in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 1, name: swapper/0
> preempt_count: 0, expected: 0
> RCU nest depth: 1, expected: 0
> 2 locks held by swapper/0/1:
>  =A0#0: ffff80000a8a44d0 (kvm_hyp_pgd_mutex){+.+.}-{3:3}, at: =

> __create_hyp_mappings+0x80/0xc4
>  =A0#1: ffff80000a927720 (rcu_read_lock){....}-{1:2}, at: =

> kvm_pgtable_walk+0x0/0x1f4
> CPU: 2 PID: 1 Comm: swapper/0 Not tainted 6.1.0-rc3+ #5918
> Hardware name: Raspberry Pi 3 Model B (DT)
> Call trace:
>  =A0dump_backtrace.part.0+0xe4/0xf0
>  =A0show_stack+0x18/0x40
>  =A0dump_stack_lvl+0x8c/0xb8
>  =A0dump_stack+0x18/0x34
>  =A0__might_resched+0x178/0x220
>  =A0__might_sleep+0x48/0xa0
>  =A0prepare_alloc_pages+0x178/0x1a0
>  =A0__alloc_pages+0x9c/0x109c
>  =A0alloc_page_interleave+0x1c/0xc4
>  =A0alloc_pages+0xec/0x160
>  =A0get_zeroed_page+0x1c/0x44
>  =A0kvm_hyp_zalloc_page+0x14/0x20
>  =A0hyp_map_walker+0xd4/0x134
>  =A0kvm_pgtable_visitor_cb.isra.0+0x38/0x5c
>  =A0__kvm_pgtable_walk+0x1a4/0x220
>  =A0kvm_pgtable_walk+0x104/0x1f4
>  =A0kvm_pgtable_hyp_map+0x80/0xc4
>  =A0__create_hyp_mappings+0x9c/0xc4
>  =A0kvm_mmu_init+0x144/0x1cc
>  =A0kvm_arch_init+0xe4/0xef4
>  =A0kvm_init+0x3c/0x3d0
>  =A0arm_init+0x20/0x30
>  =A0do_one_initcall+0x74/0x400
>  =A0kernel_init_freeable+0x2e0/0x350
>  =A0kernel_init+0x24/0x130
>  =A0ret_from_fork+0x10/0x20
> kvm [1]: Hyp mode initialized successfully
> =

> --->8----
> =

> I looks that more changes in the KVM code are needed to use RCU for that =

> code.

Right, the specific issue is that while the stage-2 walkers preallocate
any table memory they may need, the hyp walkers do not and allocate
inline.

As hyp stage-1 is protected by a spinlock there is no actual need for
RCU in that case. I'll post something later on today that addresses the
issue.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

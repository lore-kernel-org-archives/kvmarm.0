Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3171BC433FE
	for <kvmarm@archiver.kernel.org>; Tue,  1 Nov 2022 20:46:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A0434BAC7;
	Tue,  1 Nov 2022 16:46:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LwfHp0fbD00s; Tue,  1 Nov 2022 16:46:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 54E734BA2F;
	Tue,  1 Nov 2022 16:46:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E1494BA2F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Nov 2022 16:46:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7YhP7YNMl701 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Nov 2022 16:46:26 -0400 (EDT)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0779B4B9EE
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Nov 2022 16:46:25 -0400 (EDT)
Date: Tue, 1 Nov 2022 20:46:14 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1667335584;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=6x7DY2gFzopQuMFwkeq+iyUXN3O/bFmTMTh5Iwt6CyU=;
 b=Ntzyn+Jf1qlzNpR43HCbuxbzt104ksD0+HTq91Wbi7fM3ZJX+fuyM9zeZERcfo5B9ME3QU
 sNiBtHDKWktUciuMiYOqDL3Sx8rR8pqU4HneKRow7juwaiH+PSmc+w7NJIfezOQb25Kn7T
 1JxNVgb//P6smSrAzNQdZs3fjKuMhIU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v3 09/15] KVM: arm64: Free removed stage-2 tables in RCU
 callback
Message-ID: <Y2GFliAVxui9VyK2@google.com>
References: <20221027221752.1683510-1-oliver.upton@linux.dev>
 <20221027221752.1683510-10-oliver.upton@linux.dev>
 <Y2GBVML5MWXZE9Na@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Y2GBVML5MWXZE9Na@google.com>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Tue, Nov 01, 2022 at 08:28:04PM +0000, Sean Christopherson wrote:
> On Thu, Oct 27, 2022, Oliver Upton wrote:
> > There is no real urgency to free a stage-2 subtree that was pruned.
> > Nonetheless, KVM does the tear down in the stage-2 fault path while
> > holding the MMU lock.
> > 

[ copy ]

> This is _very_ misleading.  The above paints RCU as an optimization of sorts to
> avoid doing work while holding mmu_lock.  Freeing page tables in an RCU callback
> is _required_ for correctness when allowing parallel page faults to remove page
> tables, as holding mmu_lock for read in that case doesn't ensure no other CPU is
> accessing and/or holds a reference to the to-be-freed page table.

Agree, but it is still important to reason about what is changing here
too. Moving work out of the vCPU fault path _is_ valuable, though
ancillary to the correctness requirements.

> IMO, this patch should to be squashed with the previous patch, "Protect stage-2
> traversal with RCU".  One doesn't make any sense without the other.

I had split these up back when this series was a lot more gnarly and
there was too much slop in a single diff. That isn't the case any more,
so yeah I'll squash them.

[ paste ]

> > Free removed stage-2 subtrees after an RCU grace period. To guarantee
> > all stage-2 table pages are freed before killing a VM, add an
> > rcu_barrier() to the flush path.

An aside, this is flat-out wrong now.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

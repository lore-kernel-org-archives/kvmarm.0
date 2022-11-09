Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A1BAC4332F
	for <kvmarm@archiver.kernel.org>; Wed,  9 Nov 2022 23:55:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 010564BA7A;
	Wed,  9 Nov 2022 18:55:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BlLgjdQANqO5; Wed,  9 Nov 2022 18:55:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 861E34BA6F;
	Wed,  9 Nov 2022 18:55:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C9E354BA70
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Nov 2022 18:55:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J5SLn6LmHhCY for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Nov 2022 18:55:41 -0500 (EST)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 864534BA6F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Nov 2022 18:55:41 -0500 (EST)
Date: Wed, 9 Nov 2022 23:55:31 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1668038136;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=CMDbvPwRm+rrl6bjWjpWDOlNg7vwputyd1P9f5sAr6k=;
 b=TdavPo/9nDF2eoDdQROxJ9deOixtHkiiM66l+3DB4HC/VxfCurqHMnXZgooMmawAqSAHEp
 dq3CDwbPCdQ4Y+S+dZSll286UnKJcKfKIw6vJitHvjbCJtNDshGqU2kiQYxQOu1dw535fw
 LK72OZDLP2NaLxzryR8sVaq9n09Q8Xw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v5 08/14] KVM: arm64: Protect stage-2 traversal with RCU
Message-ID: <Y2w98zPmtefJlNfa@google.com>
References: <20221107215644.1895162-1-oliver.upton@linux.dev>
 <20221107215644.1895162-9-oliver.upton@linux.dev>
 <Y2whaWo3SIOOMKOE@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Y2whaWo3SIOOMKOE@google.com>
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

On Wed, Nov 09, 2022 at 09:53:45PM +0000, Sean Christopherson wrote:
> On Mon, Nov 07, 2022, Oliver Upton wrote:
> > Use RCU to safely walk the stage-2 page tables in parallel. Acquire and
> > release the RCU read lock when traversing the page tables. Defer the
> > freeing of table memory to an RCU callback. Indirect the calls into RCU
> > and provide stubs for hypervisor code, as RCU is not available in such a
> > context.
> > 
> > The RCU protection doesn't amount to much at the moment, as readers are
> > already protected by the read-write lock (all walkers that free table
> > memory take the write lock). Nonetheless, a subsequent change will
> > futher relax the locking requirements around the stage-2 MMU, thereby
> > depending on RCU.
> 
> Two somewhat off-topic questions (because I'm curious):

Worth asking!

>  1. Are there plans to enable "fast" page faults on ARM?  E.g. to fixup access
>     faults (handle_access_fault()) and/or write-protection faults without acquiring
>     mmu_lock?

I don't have any plans personally.

OTOH, adding support for read-side access faults is trivial, I just
didn't give it much thought as most large-scale implementations have
FEAT_HAFDBS (hardware access flag management).

>  2. If the answer to (1) is "yes!", what's the plan to protect the lockless walks
>     for the RCU-less hypervisor code?

If/when we are worried about fault serialization in the lowvisor I was
thinking something along the lines of disabling interrupts and using
IPIs as barriers before freeing removed table memory, crudely giving the
same protection as RCU.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

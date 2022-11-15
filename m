Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08A21C433FE
	for <kvmarm@archiver.kernel.org>; Tue, 15 Nov 2022 18:57:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 673164B7F0;
	Tue, 15 Nov 2022 13:57:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SFTE8nlsrm-B; Tue, 15 Nov 2022 13:57:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B05A4B831;
	Tue, 15 Nov 2022 13:57:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE6394B7C2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Nov 2022 13:57:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eMLBOR9h9gMK for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Nov 2022 13:57:17 -0500 (EST)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A81D940E76
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Nov 2022 13:57:17 -0500 (EST)
Date: Tue, 15 Nov 2022 18:57:11 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1668538636;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=7QB1+Pi5ihYjPOVelH2p1IvQmXrfrqBb7hAw9xGI4+s=;
 b=I1myR4ndvHoG/R+3q3YyBBw752W7c7nAptLsdp9bzz2TaXNUvXLTmSBz8RDrT1fNs4fur4
 qJ1Kt7tkmB2cUMJHbqNEnTOaVo7XEcWlyf52cXvPNkodaQCImpKorJcU3DiDrwX2BxPaE7
 3jNh9frc0of7v9Wspln4+YPOazLXBV4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v5 08/14] KVM: arm64: Protect stage-2 traversal with RCU
Message-ID: <Y3PhBwQPD5QtyRbf@google.com>
References: <20221107215644.1895162-1-oliver.upton@linux.dev>
 <20221107215644.1895162-9-oliver.upton@linux.dev>
 <Y2whaWo3SIOOMKOE@google.com> <Y2w98zPmtefJlNfa@google.com>
 <Y3PeyV4KIjoBBYNV@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Y3PeyV4KIjoBBYNV@google.com>
X-Migadu-Flow: FLOW_OUT
Cc: kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
 kvmarm@lists.linux.dev, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, David Matlack <dmatlack@google.com>,
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

On Tue, Nov 15, 2022 at 10:47:37AM -0800, Ricardo Koller wrote:
> On Wed, Nov 09, 2022 at 11:55:31PM +0000, Oliver Upton wrote:
> > On Wed, Nov 09, 2022 at 09:53:45PM +0000, Sean Christopherson wrote:
> > > On Mon, Nov 07, 2022, Oliver Upton wrote:
> > > > Use RCU to safely walk the stage-2 page tables in parallel. Acquire and
> > > > release the RCU read lock when traversing the page tables. Defer the
> > > > freeing of table memory to an RCU callback. Indirect the calls into RCU
> > > > and provide stubs for hypervisor code, as RCU is not available in such a
> > > > context.
> > > > 
> > > > The RCU protection doesn't amount to much at the moment, as readers are
> > > > already protected by the read-write lock (all walkers that free table
> > > > memory take the write lock). Nonetheless, a subsequent change will
> > > > futher relax the locking requirements around the stage-2 MMU, thereby
> > > > depending on RCU.
> > > 
> > > Two somewhat off-topic questions (because I'm curious):
> > 
> > Worth asking!
> > 
> > >  1. Are there plans to enable "fast" page faults on ARM?  E.g. to fixup access
> > >     faults (handle_access_fault()) and/or write-protection faults without acquiring
> > >     mmu_lock?
> > 
> > I don't have any plans personally.
> > 
> > OTOH, adding support for read-side access faults is trivial, I just
> > didn't give it much thought as most large-scale implementations have
> > FEAT_HAFDBS (hardware access flag management).
> 
> WDYT of permission relaxation (write-protection faults) on the fast
> path?
> 
> The benefits won't be as good as in x86 due to the required TLBI, but
> may be worth it due to not dealing with the mmu lock and avoiding some
> of the context save/restore.  Note that unlike x86, in ARM the TLB entry
> related to a protection fault needs to be flushed.

Right, the only guarantee we have on arm64 is that the TLB will never
hold an entry that would produce an access fault.

I have no issues whatsoever with implementing a lock-free walker, we're
already most of the way there with the RCU implementation modulo some
rules for atomic PTE updates. I don't believe lock acquisition is a
bounding issue for us quite yet as break-before-make + lazy splitting
hurts.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

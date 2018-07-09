From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 0/6] KVM/arm64: Cache maintenance relaxations
Date: Mon, 9 Jul 2018 11:52:34 +0100
Message-ID: <fce0b6be-cb9f-e7e8-1c24-4aac1a64d16c@arm.com>
References: <20180702150250.16550-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B4D1B49FAC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jul 2018 06:39:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rDwNj-YrFL3H for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jul 2018 06:39:56 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A9C8E4086E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jul 2018 06:39:56 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 44A937A9
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jul 2018 03:52:37 -0700 (PDT)
Received: from [10.1.206.75] (usa-sjc-imap-foss1.foss.arm.com [10.72.51.249])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id
 E76D93F318
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jul 2018 03:52:36 -0700 (PDT)
In-Reply-To: <20180702150250.16550-1-marc.zyngier@arm.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 02/07/18 16:02, Marc Zyngier wrote:
> This small series makes use of features recently introduced in the
> ARMv8 architecture to relax the cache maintenance operations on CPUs
> that implement these features.
> 
> FWB is the most important one. It allows stage-2 to enforce the
> cacheability of memory, no matter what the guest says. It also
> mandates that the whole machine is cache coherent (no non-coherent
> I/O), meaning we can drop a whole class of cache maintenance
> operations.
> 
> FWB also has the same effect as CTR_EL0.IDC being set, and when
> combined with CTR_EL0.DIC allows the removal of all cache maintenance
> and tracking of pages being executed.
> 
> We also take the opportunity to drop a few useless CMOs that were
> applied to the HYP page tables, but that were never necessary. This
> ended up requiring quite a few changes in out page table accessors so
> that they get consistent barriers. These barriers are a bit on the
> heavy side, and could be further optimized, although that's probably
> for a different patch series
> 
> Unless someone screams now, I plan to apply this to kvmarm/next
> shortly.

Now applied to queue.

	M.
-- 
Jazz is not dead. It just smells funny...

Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3FC5ECAAA1
	for <kvmarm@archiver.kernel.org>; Thu, 27 Oct 2022 23:39:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FFEF49ED7;
	Thu, 27 Oct 2022 19:39:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LBOLmrc2n2gm; Thu, 27 Oct 2022 19:39:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1EAE849673;
	Thu, 27 Oct 2022 19:39:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A4A8413E2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Oct 2022 19:39:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GArpmlF548cm for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 Oct 2022 19:39:17 -0400 (EDT)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2EF4A404CD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Oct 2022 19:39:17 -0400 (EDT)
Date: Thu, 27 Oct 2022 23:39:11 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1666913955;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=4OySq2lPcnWk1ygNMJS74tXjIlAzlxm25q99ZcmBZWU=;
 b=W3q6w/rApxamTznGicrMweNO9AfF9b5YCfMEQ8dW9ZKNbgTLdS6e5WLmzyJ0xNMkFGK6dq
 zXuAmu3YIUEGo/sQjDh04PD+4MuFq1FHB+ywX+0cWOGRBI15m3mbOfYy2Tc2QrFxSIaUDE
 iFeo2388RPrwJarIpvJq5DFkVZ+4Zyg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v3 00/15] KVM: arm64: Parallel stage-2 fault handling
Message-ID: <Y1sWnyHvMWP/DhHm@google.com>
References: <20221027221752.1683510-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221027221752.1683510-1-oliver.upton@linux.dev>
X-Migadu-Flow: FLOW_OUT
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Ben Gardon <bgardon@google.com>, David Matlack <dmatlack@google.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Thu, Oct 27, 2022 at 10:17:37PM +0000, Oliver Upton wrote:
> Presently KVM only takes a read lock for stage 2 faults if it believes
> the fault can be fixed by relaxing permissions on a PTE (write unprotect
> for dirty logging). Otherwise, stage 2 faults grab the write lock, which
> predictably can pile up all the vCPUs in a sufficiently large VM.
> 
> Like the TDP MMU for x86, this series loosens the locking around
> manipulations of the stage 2 page tables to allow parallel faults. RCU
> and atomics are exploited to safely build/destroy the stage 2 page
> tables in light of multiple software observers.
> 
> Patches 1-4 clean up the context associated with a page table walk / PTE
> visit. This is helpful for:
>  - Extending the context passed through for a visit
>  - Building page table walkers that operate outside of a kvm_pgtable
>    context (e.g. RCU callback)

As is always the case, I failed to update the changelogs when twiddling
things around a bit more.

Specifically, 8/15 and 14/15 don't directly match the diffs anymore. I
wont respin (yet) to avoid bombarding mailboxes.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

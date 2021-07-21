Return-Path: <SRS0=81/H=MN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B698C12002
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 14:58:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9769061248
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 14:58:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9769061248
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1428740CF8;
	Wed, 21 Jul 2021 10:58:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YKrKyMoidSlN; Wed, 21 Jul 2021 10:58:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E84E14B0DB;
	Wed, 21 Jul 2021 10:58:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2275E40CF8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 10:58:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qPjwCMjy2z9G for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Jul 2021 10:58:36 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D328C407ED
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 10:58:35 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBCC06100C;
 Wed, 21 Jul 2021 14:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1626879514;
 bh=5qyI/dHQJICF0PI2wKZT99Bdl/k2f3fmU1dVHwc/8s0=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=hIb2Qs9AMnjjTxASv+1K/W04SwruC8bJ3jE/kKRcHTiVA/VFjxNybv99GVYp5KJU+
 Y9u1tG5xl86/3dBZd1IFXJx/eB/TxK16lWKrYe/jfUd7h9f7i4ljjV8yJb2AUF8m6G
 LADuVspziD0GkzprmshJpVafgcrM2WoDclvJdF+NK7RXhekmCNf9jPrq0p1WnPMIGa
 vhSY6VVHZB/R6uitg1ZBSrNiVmFtFbrUTJXFnXDAGBe2bCnbj5i1728wtIOCXad7ge
 GZYrChF0IGZadDFcqJAeoC7y30hxdZNFReq3dRRpHfMULW6Qa3ftNd3EgPIhn0YGz/
 8aK3eBOhBjhZw==
Date: Wed, 21 Jul 2021 15:58:29 +0100
From: Will Deacon <will@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 1/5] KVM: arm64: Walk userspace page tables to compute
 the THP mapping size
Message-ID: <20210721145828.GA11003@willie-the-truck>
References: <20210717095541.1486210-1-maz@kernel.org>
 <20210717095541.1486210-2-maz@kernel.org>
 <f09c297b-21dd-a6fa-6e72-49587ba80fe5@arm.com>
 <YPczKoLqlKElLxzb@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YPczKoLqlKElLxzb@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kernel-team@android.com, kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

Hey Sean,

On Tue, Jul 20, 2021 at 08:33:46PM +0000, Sean Christopherson wrote:
> On Tue, Jul 20, 2021, Alexandru Elisei wrote:
> > I just can't figure out why having the mmap lock is not needed to walk the
> > userspace page tables. Any hints? Or am I not seeing where it's taken?
> 
> Disclaimer: I'm not super familiar with arm64's page tables, but the relevant KVM
> functionality is common across x86 and arm64.

No need for the disclaimer, there are so many moving parts here that I don't
think it's possible to be familiar with them all! Thanks for taking the time
to write it up so clearly.

> KVM arm64 (and x86) unconditionally registers a mmu_notifier for the mm_struct
> associated with the VM, and disallows calling ioctls from a different process,
> i.e. walking the page tables during KVM_RUN is guaranteed to use the mm for which
> KVM registered the mmu_notifier.  As part of registration, the mmu_notifier
> does mmgrab() and doesn't do mmdrop() until it's unregistered.  That ensures the
> mm_struct itself is live.
> 
> For the page tables liveliness, KVM implements mmu_notifier_ops.release, which is
> invoked at the beginning of exit_mmap(), before the page tables are freed.  In
> its implementation, KVM takes mmu_lock and zaps all its shadow page tables, a.k.a.
> the stage2 tables in KVM arm64.  The flow in question, get_user_mapping_size(),
> also runs under mmu_lock, and so effectively blocks exit_mmap() and thus is
> guaranteed to run with live userspace tables.

Unless I missed a case, exit_mmap() only runs when mm_struct::mm_users drops
to zero, right? The vCPU tasks should hold references to that afaict, so I
don't think it should be possible for exit_mmap() to run while there are
vCPUs running with the corresponding page-table.

> Looking at the arm64 code, one thing I'm not clear on is whether arm64 correctly
> handles the case where exit_mmap() wins the race.  The invalidate_range hooks will
> still be called, so userspace page tables aren't a problem, but
> kvm_arch_flush_shadow_all() -> kvm_free_stage2_pgd() nullifies mmu->pgt without
> any additional notifications that I see.  x86 deals with this by ensuring its
> top-level TDP entry (stage2 equivalent) is valid while the page fault handler is
> running.

But the fact that x86 handles this race has me worried. What am I missing?

I agree that, if the race can occur, we don't appear to handle it in the
arm64 backend.

Cheers,

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

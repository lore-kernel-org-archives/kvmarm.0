Return-Path: <SRS0=81/H=MN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CB65C12002
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 16:36:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E47F561245
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 16:36:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E47F561245
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6777B4B10E;
	Wed, 21 Jul 2021 12:36:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HUS5Fnm0wQlF; Wed, 21 Jul 2021 12:36:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1EDFF4B114;
	Wed, 21 Jul 2021 12:36:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 69B7C4B0ED
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 12:36:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JTH7Eg+33h+A for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Jul 2021 12:36:14 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D75B84B0C5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 12:36:14 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 561AB1FB;
 Wed, 21 Jul 2021 09:36:14 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 46B1A3F73D;
 Wed, 21 Jul 2021 09:36:12 -0700 (PDT)
Subject: Re: [PATCH 1/5] KVM: arm64: Walk userspace page tables to compute the
 THP mapping size
To: Sean Christopherson <seanjc@google.com>
References: <20210717095541.1486210-1-maz@kernel.org>
 <20210717095541.1486210-2-maz@kernel.org>
 <f09c297b-21dd-a6fa-6e72-49587ba80fe5@arm.com> <YPczKoLqlKElLxzb@google.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <568c571a-17f5-24a5-4aec-8b508f21eddd@arm.com>
Date: Wed, 21 Jul 2021 17:37:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YPczKoLqlKElLxzb@google.com>
Content-Language: en-US
Cc: kernel-team@android.com, kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
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

Hi Sean,

Thank you for writing this, it explains exactly what I wanted to know.

On 7/20/21 9:33 PM, Sean Christopherson wrote:
> On Tue, Jul 20, 2021, Alexandru Elisei wrote:
>> Hi Marc,
>>
>> I just can't figure out why having the mmap lock is not needed to walk the
>> userspace page tables. Any hints? Or am I not seeing where it's taken?
> Disclaimer: I'm not super familiar with arm64's page tables, but the relevant KVM
> functionality is common across x86 and arm64.
>
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
>
> Lastly, KVM also implements mmu_notifier_ops.invalidate_range_{start,end}.  KVM's
> invalidate_range implementations also take mmu_lock, and also update a sequence
> counter and a flag stating that there's an invalidation in progress.  When
> installing a stage2 entry, KVM snapshots the sequence counter before taking
> mmu_lock, and then checks it again after acquiring mmu_lock.  If the counter
> mismatches, or an invalidation is in-progress, then KVM bails and resumes the
> guest without fixing the fault.
>
> E.g. if the host zaps userspace page tables and KVM "wins" the race, the subsequent
> kvm_mmu_notifier_invalidate_range_start() will zap the recently installed stage2
> entries.  And if the host zap "wins" the race, KVM will resume the guest, which
> in normal operation will hit the exception again and go back through the entire
> process of installing stage2 entries.
>
> Looking at the arm64 code, one thing I'm not clear on is whether arm64 correctly
> handles the case where exit_mmap() wins the race.  The invalidate_range hooks will
> still be called, so userspace page tables aren't a problem, but
> kvm_arch_flush_shadow_all() -> kvm_free_stage2_pgd() nullifies mmu->pgt without
> any additional notifications that I see.  x86 deals with this by ensuring its
> top-level TDP entry (stage2 equivalent) is valid while the page fault handler is
> running.
>
>   void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>   {
> 	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
> 	struct kvm_pgtable *pgt = NULL;
>
> 	spin_lock(&kvm->mmu_lock);
> 	pgt = mmu->pgt;
> 	if (pgt) {
> 		mmu->pgd_phys = 0;
> 		mmu->pgt = NULL;
> 		free_percpu(mmu->last_vcpu_ran);
> 	}
> 	spin_unlock(&kvm->mmu_lock);
>
> 	...
>   }
>
> AFAICT, nothing in user_mem_abort() would prevent consuming that null mmu->pgt
> if exit_mmap() collidied with user_mem_abort().
>
>   static int user_mem_abort(...)
>   {
>
> 	...
>
> 	spin_lock(&kvm->mmu_lock);
> 	pgt = vcpu->arch.hw_mmu->pgt;         <-- hw_mmu->pgt may be NULL (hw_mmu points at vcpu->kvm->arch.mmu)
> 	if (mmu_notifier_retry(kvm, mmu_seq)) <-- mmu_seq not guaranteed to change
> 		goto out_unlock;
>
> 	...
>
> 	if (fault_status == FSC_PERM && vma_pagesize == fault_granule) {
> 		ret = kvm_pgtable_stage2_relax_perms(pgt, fault_ipa, prot);
> 	} else {
> 		ret = kvm_pgtable_stage2_map(pgt, fault_ipa, vma_pagesize,
> 					     __pfn_to_phys(pfn), prot,
> 					     memcache);
> 	}
>   }
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

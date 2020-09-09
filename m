Return-Path: <SRS0=Sq8/=CS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28420C433E2
	for <kvmarm@archiver.kernel.org>; Wed,  9 Sep 2020 10:56:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5EDFF21D7A
	for <kvmarm@archiver.kernel.org>; Wed,  9 Sep 2020 10:56:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5EDFF21D7A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A40BF4B3CA;
	Wed,  9 Sep 2020 06:56:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9J27Q4O-cxJR; Wed,  9 Sep 2020 06:56:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 78E704B52B;
	Wed,  9 Sep 2020 06:56:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 112524B3C6
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Sep 2020 06:56:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MwLfJgGyVrWF for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Sep 2020 06:56:26 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC6F24B3B1
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Sep 2020 06:56:26 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0CEB531B;
 Wed,  9 Sep 2020 03:56:26 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3CB323F68F;
 Wed,  9 Sep 2020 03:56:25 -0700 (PDT)
Subject: Re: [PATCH v3 09/21] KVM: arm64: Convert unmap_stage2_range() to
 generic page-table API
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Will Deacon <will@kernel.org>
References: <20200825093953.26493-1-will@kernel.org>
 <20200825093953.26493-10-will@kernel.org>
 <1f2e88b7-0265-195f-3bd8-4e1d5b8694e3@arm.com>
 <20200903175702.GA8078@willie-the-truck>
 <c9c30b62-601a-41e9-3821-6f9c2802d97f@arm.com>
Message-ID: <3aaf6f41-2a28-910b-553c-7a9e98d91165@arm.com>
Date: Wed, 9 Sep 2020 11:57:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <c9c30b62-601a-41e9-3821-6f9c2802d97f@arm.com>
Content-Language: en-US
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>
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

Hi Will,

I'm answering my own question, again. See below.

On 9/8/20 2:07 PM, Alexandru Elisei wrote:
> Hi Will,
>
> On 9/3/20 6:57 PM, Will Deacon wrote:
>> On Wed, Sep 02, 2020 at 05:23:08PM +0100, Alexandru Elisei wrote:
>>> On 8/25/20 10:39 AM, Will Deacon wrote:
>>>> Convert unmap_stage2_range() to use kvm_pgtable_stage2_unmap() instead
>>>> of walking the page-table directly.
>>>>
>>>> Cc: Marc Zyngier <maz@kernel.org>
>>>> Cc: Quentin Perret <qperret@google.com>
>>>> Signed-off-by: Will Deacon <will@kernel.org>
>>>> ---
>>>>  arch/arm64/kvm/mmu.c | 57 +++++++++++++++++++++++++-------------------
>>>>  1 file changed, 32 insertions(+), 25 deletions(-)
>>>>
>>>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>>>> index 704b471a48ce..751ce2462765 100644
>>>> --- a/arch/arm64/kvm/mmu.c
>>>> +++ b/arch/arm64/kvm/mmu.c
>>>> @@ -39,6 +39,33 @@ static bool is_iomap(unsigned long flags)
>>>>  	return flags & KVM_S2PTE_FLAG_IS_IOMAP;
>>>>  }
>>>>  
>>>> +/*
>>>> + * Release kvm_mmu_lock periodically if the memory region is large. Otherwise,
>>>> + * we may see kernel panics with CONFIG_DETECT_HUNG_TASK,
>>>> + * CONFIG_LOCKUP_DETECTOR, CONFIG_LOCKDEP. Additionally, holding the lock too
>>>> + * long will also starve other vCPUs. We have to also make sure that the page
>>>> + * tables are not freed while we released the lock.
>>>> + */
>>>> +#define stage2_apply_range(kvm, addr, end, fn, resched)			\
>>>> +({									\
>>>> +	int ret;							\
>>>> +	struct kvm *__kvm = (kvm);					\
>>>> +	bool __resched = (resched);					\
>>>> +	u64 next, __addr = (addr), __end = (end);			\
>>>> +	do {								\
>>>> +		struct kvm_pgtable *pgt = __kvm->arch.mmu.pgt;		\
>>>> +		if (!pgt)						\
>>>> +			break;						\
>>> I'm 100% sure there's a reason why we've dropped the READ_ONCE, but it still looks
>>> to me like the compiler might decide to optimize by reading pgt once at the start
>>> of the loop and stashing it in a register. Would you mind explaining what I am
>>> missing?
>> The load always happens with the mmu_lock held, so I think it's not a
>> problem because it means that the pointer is stable.
>> spin_lock()/spin_unlock() imply compiler barriers.
> I think you are correct, if this is supposed to always execute with kvm->mmu_lock
> held, then pgt should not change between iterations. It didn't immediately occur
> to me that that is the case because we check if pgt is NULL every iteration. If we
> are relying on the lock being held, maybe we should move the pgt load + comparison
> against NULL out of the loop? That should avoid any confusion and make the code
> ever so slightly faster.
>
> Also, I see that in __unmap_stage2_range() we check that the mmu_lock is held, but
> we don't check that at all call sites (for example, in stage2_wp_range()). I
> realize this is me bikeshedding, but that looks a bit asymmetrical. Should we move
> the assert_spin_locked(&kvm->mmu_lock) statement in stage2_apply_range(), since
> the function assumes the pgt will remain unchanged? What do you think?

What I wrote is wrong, because we can drop the lock in cond_resched_lock(). I
don't see the need for any changes.

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

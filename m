Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 941B3ECAAD8
	for <kvmarm@archiver.kernel.org>; Thu, 22 Sep 2022 23:47:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E2FC34B2B4;
	Thu, 22 Sep 2022 19:47:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id M8EKMOyWE2H9; Thu, 22 Sep 2022 19:47:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8186B4B1B7;
	Thu, 22 Sep 2022 19:47:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DDF214B1B7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2022 19:47:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id etDwo5Y+Q87v for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Sep 2022 19:47:11 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 362734B0F4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2022 19:47:11 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1663890430;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=JNeVq+wGsryjN6c4r6dUHWC2q43V8h7EZ89EqqZp5hk=;
 b=b9MmXxFl5/m4sywDCQ5tfZM1BzfzBMi69MJQ6AIDOqu5hjfmR2LrYa5LXmdPikcb4fAr4z
 G2UUwh2H5ZJYkpX9CNMlCdslwO8DHue7iDH96O1gJIqntF0VKFPU/pXzBTAM4h9/nc2Ayg
 Z8LxdhfKxH/Wmhcg34CcBXeA6FQCOhI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-172-lOs1RUxLNIaFO_ztvXyOdQ-1; Thu, 22 Sep 2022 19:47:07 -0400
X-MC-Unique: lOs1RUxLNIaFO_ztvXyOdQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E94A23C0D1A6;
 Thu, 22 Sep 2022 23:47:06 +0000 (UTC)
Received: from [10.64.54.126] (vpn2-54-126.bne.redhat.com [10.64.54.126])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B2EF940C6EC2;
 Thu, 22 Sep 2022 23:47:00 +0000 (UTC)
Subject: Re: [PATCH 1/6] KVM: Use acquire/release semantics when accessing
 dirty ring GFN state
To: Peter Xu <peterx@redhat.com>, Marc Zyngier <maz@kernel.org>
References: <20220922170133.2617189-1-maz@kernel.org>
 <20220922170133.2617189-2-maz@kernel.org> <YyzV2Q/PZHPFMD6y@xz-m1.local>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <e8ddf130-c5e1-d872-c7c8-675d40742b1e@redhat.com>
Date: Fri, 23 Sep 2022 09:46:58 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <YyzV2Q/PZHPFMD6y@xz-m1.local>
Content-Language: en-US
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, andrew.jones@linux.dev,
 will@kernel.org, shan.gavin@gmail.com, bgardon@google.com, dmatlack@google.com,
 pbonzini@redhat.com, zhenyzha@redhat.com, shuah@kernel.org,
 kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Gavin Shan <gshan@redhat.com>
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Peter,

On 9/23/22 7:38 AM, Peter Xu wrote:
> On Thu, Sep 22, 2022 at 06:01:28PM +0100, Marc Zyngier wrote:
>> The current implementation of the dirty ring has an implicit requirement
>> that stores to the dirty ring from userspace must be:
>>
>> - be ordered with one another
>>
>> - visible from another CPU executing a ring reset
>>
>> While these implicit requirements work well for x86 (and any other
>> TSO-like architecture), they do not work for more relaxed architectures
>> such as arm64 where stores to different addresses can be freely
>> reordered, and loads from these addresses not observing writes from
>> another CPU unless the required barriers (or acquire/release semantics)
>> are used.
>>
>> In order to start fixing this, upgrade the ring reset accesses:
>>
>> - the kvm_dirty_gfn_harvested() helper now uses acquire semantics
>>    so it is ordered after all previous writes, including that from
>>    userspace
>>
>> - the kvm_dirty_gfn_set_invalid() helper now uses release semantics
>>    so that the next_slot and next_offset reads don't drift past
>>    the entry invalidation
>>
>> This is only a partial fix as the userspace side also need upgrading.
> 
> Paolo has one fix 4802bf910e ("KVM: dirty ring: add missing memory
> barrier", 2022-09-01) which has already landed.
> 
> I think the other one to reset it was lost too.  I just posted a patch.
> 
> https://lore.kernel.org/qemu-devel/20220922213522.68861-1-peterx@redhat.com/
> (link still not yet available so far, but should be)
> 
>>
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>   virt/kvm/dirty_ring.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
>> index f4c2a6eb1666..784bed80221d 100644
>> --- a/virt/kvm/dirty_ring.c
>> +++ b/virt/kvm/dirty_ring.c
>> @@ -79,12 +79,12 @@ static inline void kvm_dirty_gfn_set_invalid(struct kvm_dirty_gfn *gfn)
>>   
>>   static inline void kvm_dirty_gfn_set_dirtied(struct kvm_dirty_gfn *gfn)
>>   {
>> -	gfn->flags = KVM_DIRTY_GFN_F_DIRTY;
>> +	smp_store_release(&gfn->flags, KVM_DIRTY_GFN_F_DIRTY);
> 
> IIUC you meant kvm_dirty_gfn_set_invalid as the comment says?
> 
> kvm_dirty_gfn_set_dirtied() has been guarded by smp_wmb() and AFAICT that's
> already safe.  Otherwise looks good to me.
> 

If I'm understanding the full context, smp_store_release() also enforces
guard on 'gfn->flags' itself. It is needed by user space for the synchronization.

>>   }
>>   
>>   static inline bool kvm_dirty_gfn_harvested(struct kvm_dirty_gfn *gfn)
>>   {
>> -	return gfn->flags & KVM_DIRTY_GFN_F_RESET;
>> +	return smp_load_acquire(&gfn->flags) & KVM_DIRTY_GFN_F_RESET;
>>   }
>>   
>>   int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring)
>> -- 
>> 2.34.1
>>

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

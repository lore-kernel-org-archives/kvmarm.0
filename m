Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38DB8C433FE
	for <kvmarm@archiver.kernel.org>; Fri, 21 Oct 2022 23:03:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A46254B643;
	Fri, 21 Oct 2022 19:03:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MEeRHvo99+yU; Fri, 21 Oct 2022 19:03:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 67D694B17D;
	Fri, 21 Oct 2022 19:03:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 71A434B0B9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Oct 2022 19:03:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ma5x6rjBMM3z for <kvmarm@lists.cs.columbia.edu>;
 Fri, 21 Oct 2022 19:03:34 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B3A04B092
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Oct 2022 19:03:34 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1666393413;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=1fEenf3S8YDuePBXqNmkM7mhB11g2I303XsHD03t0YI=;
 b=SxGhBGaBx0Qv+96fiJi6sTLmxn2QM9G/bCHEFaQoQCkdMy0D7LTg4nZFMdkt0oYXwPvaYY
 ORDCio5XzS5glFCiHHuKFlOiRBJVUHfdnNkEHKca8F0yoGbaeObdu4HhC0hz4arMOXldph
 SvNIM/fB2Y+B+r8oeEvCEjpE+0CKFhc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-119-kHzCcEMtNhaZeisscdvnug-1; Fri, 21 Oct 2022 19:03:30 -0400
X-MC-Unique: kHzCcEMtNhaZeisscdvnug-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5F84029AB45D;
 Fri, 21 Oct 2022 23:03:29 +0000 (UTC)
Received: from [10.64.54.99] (vpn2-54-99.bne.redhat.com [10.64.54.99])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8A94949BB60;
 Fri, 21 Oct 2022 23:03:17 +0000 (UTC)
Subject: Re: [PATCH v6 1/8] KVM: x86: Introduce KVM_REQ_RING_SOFT_FULL
To: Sean Christopherson <seanjc@google.com>
References: <20221011061447.131531-1-gshan@redhat.com>
 <20221011061447.131531-2-gshan@redhat.com> <Y1HO46UCyhc9M6nM@google.com>
 <db2cb7da-d3b1-c87e-4362-94764a7ea480@redhat.com>
 <Y1K5/MN9o7tEvYu5@google.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <85d15a4a-bbae-c5e6-f6dc-1d972d07dafb@redhat.com>
Date: Sat, 22 Oct 2022 07:03:12 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <Y1K5/MN9o7tEvYu5@google.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Cc: shuah@kernel.org, kvm@vger.kernel.org, maz@kernel.org, bgardon@google.com,
 andrew.jones@linux.dev, dmatlack@google.com, shan.gavin@gmail.com,
 catalin.marinas@arm.com, kvmarm@lists.linux.dev, pbonzini@redhat.com,
 zhenyzha@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu
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

Hi Sean,

On 10/21/22 11:25 PM, Sean Christopherson wrote:
> On Fri, Oct 21, 2022, Gavin Shan wrote:
>> I think Marc want to make the check more generalized with a new event [1].
> 
> Generalized code can be achieved with a helper though.  The motivation is indeed
> to avoid overhead on every run:
> 
>    : A seemingly approach would be to make this a request on dirty log
>    : insertion, and avoid the whole "check the log size" on every run,
>    : which adds pointless overhead to unsuspecting users (aka everyone).
> 
> 
> https://lore.kernel.org/kvmarm/87lerkwtm5.wl-maz@kernel.org
> 

Ok. I would say both are the motivations. I will refer to the words in the commit
log and include the link. In that way, the motivations are cleared mentioned in
the commit log.

>>> I'm pretty sure the check can be moved to the very end of the request checks,
>>> e.g. to avoid an aborted VM-Enter attempt if one of the other request triggers
>>> KVM_REQ_RING_SOFT_FULL.
>>>
>>> Heh, this might actually be a bug fix of sorts.  If anything pushes to the ring
>>> after the check at the start of vcpu_enter_guest(), then without the request, KVM
>>> would enter the guest while at or above the soft limit, e.g. record_steal_time()
>>> can dirty a page, and the big pile of stuff that's behind KVM_REQ_EVENT can
>>> certainly dirty pages.
>>>
>>
>> When dirty ring becomes full, the VCPU can't handle any operations, which will
>> bring more dirty pages.
> 
> Right, but there's a buffer of 64 entries on top of what the CPU can buffer (VMX's
> PML can buffer 512 entries).  Hence the "soft full".  If x86 is already on the
> edge of exhausting that buffer, i.e. can fill 64 entries while handling requests,
> than we need to increase the buffer provided by the soft limit because sooner or
> later KVM will be able to fill 65 entries, at which point errors will occur
> regardless of when the "soft full" request is processed.
> 
> In other words, we can take advantage of the fact that the soft-limit buffer needs
> to be quite conservative.
> 

Right, there are extra 64 entries in the ring between soft full and hard full.
Another 512 entries are reserved when PML is enabled. However, the other requests,
who produce dirty pages, are producers to the ring. We can't just have the assumption
that those producers will need less than 64 entries. So I think KVM_REQ_DIRTY_RING_SOFT_FULL
has higher priority than other requests, except KVM_REQ_VM_DEAD. KVM_REQ_VM_DEAD
needs to be handled immediately.

>>> Would it make sense to clear the request in kvm_dirty_ring_reset()?  I don't care
>>> about the overhead of having to re-check the request, the goal would be to help
>>> document what causes the request to go away.
>>>
>>> E.g. modify kvm_dirty_ring_reset() to take @vcpu and then do:
>>>
>>> 	if (!kvm_dirty_ring_soft_full(ring))
>>> 		kvm_clear_request(KVM_REQ_RING_SOFT_FULL, vcpu);
>>>
>>
>> It's reasonable to clear KVM_REQ_DIRTY_RING_SOFT_FULL when the ring is reseted.
>> @vcpu can be achieved by container_of(..., ring).
> 
> Using container_of() is silly, there's literally one caller that does:
> 
> 	kvm_for_each_vcpu(i, vcpu, kvm)
> 		cleared += kvm_dirty_ring_reset(vcpu->kvm, &vcpu->dirty_ring);
> 

May I ask why it's silly by using container_of()? In order to avoid using
container_of(), kvm_dirty_ring_push() also need @vcpu. So lets change those
two functions to something like below. Please double-check if they looks good
to you?

   void kvm_dirty_ring_push(struct kvm_vcpu *vcpu, u32 slot, u64 offset);
   int kvm_dirty_ring_reset(struct kvm_vcpu *vcpu);

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

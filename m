Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C3D4C4332F
	for <kvmarm@archiver.kernel.org>; Thu,  3 Nov 2022 00:44:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E88249EDE;
	Wed,  2 Nov 2022 20:44:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zmf6UWKRPNd5; Wed,  2 Nov 2022 20:44:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F5EF4B28D;
	Wed,  2 Nov 2022 20:44:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 64FB749EDE
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2022 20:44:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Q26XJTnWgq2z for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Nov 2022 20:44:45 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E84F141070
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2022 20:44:45 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1667436285;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=SSLSYckBlW+n3JxKkI9fBnOPYDTW+sybGJFFtiBCB1Y=;
 b=HfTE2yQ029MFEwb2PIcDk6Qn9yXBlyYiGLQ0L7zmn+KgIEsYVm8tvM8VDfJgfRTo9E/AO1
 nD+DtFS6KNjTfnd42qQ1jMn4A10iLU9tCGd29wzFg6eFnoiT7vLxP1mmw7an8jLiETwpKG
 +X3zbTEsfcM6o72S399tkDatNxbcpTI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-357-7Sa5Kei4P9qdoyUA1xC4lA-1; Wed, 02 Nov 2022 20:44:43 -0400
X-MC-Unique: 7Sa5Kei4P9qdoyUA1xC4lA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2815D185A78F;
 Thu,  3 Nov 2022 00:44:42 +0000 (UTC)
Received: from [10.64.54.56] (vpn2-54-56.bne.redhat.com [10.64.54.56])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CF32C40C6EE9;
 Thu,  3 Nov 2022 00:44:35 +0000 (UTC)
Subject: Re: [PATCH v7 1/9] KVM: x86: Introduce KVM_REQ_DIRTY_RING_SOFT_FULL
To: Marc Zyngier <maz@kernel.org>, Sean Christopherson <seanjc@google.com>
References: <20221031003621.164306-1-gshan@redhat.com>
 <20221031003621.164306-2-gshan@redhat.com> <Y2F17Y7YG5Z9XnOJ@google.com>
 <Y2J+xhBYhqBI81f7@x1n> <867d0de4b0.wl-maz@kernel.org>
 <Y2KWm8wiL3jBryMI@google.com> <871qqlgvba.wl-maz@kernel.org>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <c44d4e62-ffbb-bdba-f1a7-7fb6a0f44e75@redhat.com>
Date: Thu, 3 Nov 2022 08:44:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <871qqlgvba.wl-maz@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Cc: shuah@kernel.org, kvm@vger.kernel.org, catalin.marinas@arm.com,
 andrew.jones@linux.dev, dmatlack@google.com, shan.gavin@gmail.com,
 bgardon@google.com, kvmarm@lists.linux.dev, pbonzini@redhat.com,
 zhenyzha@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 ajones@ventanamicro.com
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

On 11/3/22 12:44 AM, Marc Zyngier wrote:
> On Wed, 02 Nov 2022 16:11:07 +0000,
> Sean Christopherson <seanjc@google.com> wrote:
>>
>> On Wed, Nov 02, 2022, Marc Zyngier wrote:
>>> On Wed, 02 Nov 2022 14:29:26 +0000, Peter Xu <peterx@redhat.com> wrote:
>>>> However I don't see anything stops a simple "race" to trigger like below:
>>>>
>>>>            recycle thread                   vcpu thread
>>>>            --------------                   -----------
>>>>        if (!dirty_ring_soft_full)                                   <--- not full
>>>>                                          dirty_ring_push();
>>>>                                          if (dirty_ring_soft_full)  <--- full due to the push
>>>>                                              set_request(SOFT_FULL);
>>>>            clear_request(SOFT_FULL);                                <--- can wrongly clear the request?
>>>>
>>>
>>> Hmmm, well spotted. That's another ugly effect of the recycle thread
>>> playing with someone else's toys.
>>>
>>>> But I don't think that's a huge matter, as it'll just let the vcpu to have
>>>> one more chance to do another round of KVM_RUN.  Normally I think it means
>>>> there can be one more dirty GFN (perhaps there're cases that it can push >1
>>>> gfns for one KVM_RUN cycle?  I never figured out the details here, but
>>>> still..) pushed to the ring so closer to the hard limit, but we have had a
>>>> buffer zone of KVM_DIRTY_RING_RSVD_ENTRIES (64) entries.  So I assume
>>>> that's still fine, but maybe worth a short comment here?
>>>>
>>>> I never know what's the maximum possible GFNs being dirtied for a KVM_RUN
>>>> cycle.  It would be good if there's an answer to that from anyone.
>>>
>>> This is dangerous, and I'd rather not go there.
>>>
>>> It is starting to look like we need the recycle thread to get out of
>>> the way. And to be honest:
>>>
>>> +	if (!kvm_dirty_ring_soft_full(ring))
>>> +		kvm_clear_request(KVM_REQ_DIRTY_RING_SOFT_FULL, vcpu);
>>>
>>> seems rather superfluous. Only clearing the flag in the vcpu entry
>>> path feels much saner, and I can't see anything that would break.
>>>
>>> Thoughts?
>>
>> I've no objections to dropping the clear on reset, I suggested it
>> primarily so that it would be easier to understand what action
>> causes the dirty ring to become not-full.  I agree that the explicit
>> clear is unnecessary from a functional perspective.
> 
> The core of the issue is that the whole request mechanism is a
> producer/consumer model, where consuming a request is a CLEAR
> action. The standard model is that the vcpu thread is the consumer,
> and that any thread (including the vcpu itself) can be a producer.
> 
> With this flag clearing being on a non-vcpu thread, you end-up with
> two consumers, and things can go subtly wrong.
> 
> I'd suggest replacing this hunk with a comment saying that the request
> will be cleared by the vcpu thread next time it enters the guest.
> 

Thanks, Marc. I will replace the hunk of code with the following
comments, as you suggested, in next respin.

     /*
      * The request KVM_REQ_DIRTY_RING_SOFT_FULL will be cleared
      * by the VCPU thread next time when it enters the guest.
      */

I will post v8 after Peter/Sean/Oliver take a look on [PATCH v7 4/9].
I think we're settled on other patches.

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

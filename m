Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9411EC433F5
	for <kvmarm@archiver.kernel.org>; Mon,  2 May 2022 02:35:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D3B644B278;
	Sun,  1 May 2022 22:35:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ho7-a5KbNa7O; Sun,  1 May 2022 22:35:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A4AF4B1C5;
	Sun,  1 May 2022 22:35:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B5094410F6
 for <kvmarm@lists.cs.columbia.edu>; Sun,  1 May 2022 22:35:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 14vHVbtZw1tK for <kvmarm@lists.cs.columbia.edu>;
 Sun,  1 May 2022 22:35:28 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D790410F3
 for <kvmarm@lists.cs.columbia.edu>; Sun,  1 May 2022 22:35:27 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1651458927;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Dj6lOIpl1/fVHNjIgwNOiF+RPKGdSdTc7hK+FjT4aNs=;
 b=Pm5JH63u0TG5H3c5Uk9nDorMxlp63N+9fFFqm6MMmnFqDw2UZJRE4lKz/qbHpGDZsA3ZHW
 eqFESoRNz2F1blW3kY8UhhvYW3rQrutdLmAFjFBPgBsNXT5lfj/doN3LJ9On8JLpZkgy7Q
 GuE6chNkUVSTNvQFmcZrAuRD3DlxXbU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-350-ilWeI8ciPjGVNZKyEVIsgw-1; Sun, 01 May 2022 22:35:18 -0400
X-MC-Unique: ilWeI8ciPjGVNZKyEVIsgw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1192A1814501;
 Mon,  2 May 2022 02:35:18 +0000 (UTC)
Received: from [10.72.12.86] (ovpn-12-86.pek2.redhat.com [10.72.12.86])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5DF15C27E97;
 Mon,  2 May 2022 02:35:10 +0000 (UTC)
Subject: Re: [PATCH v6 03/18] KVM: arm64: Add SDEI virtualization
 infrastructure
To: Oliver Upton <oupton@google.com>
References: <20220403153911.12332-1-gshan@redhat.com>
 <20220403153911.12332-4-gshan@redhat.com> <YmMiyt/TDjJt0mdG@google.com>
 <36899ea9-e8bd-27b2-8dfb-75b76eab50d7@redhat.com>
 <YmRI7Bh7fWCYLUGT@google.com>
 <0e26da1a-00bb-3d63-a8bf-6cd3271b0a38@redhat.com>
 <Ymr45B+8xTlhi7vk@google.com>
 <96711526-c4f3-3b50-c015-beba8cc9fcc9@redhat.com>
 <Ym1EztjkJIHrg4Qz@google.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <62f06a03-d6fc-3803-a2d2-7a85cf733459@redhat.com>
Date: Mon, 2 May 2022 10:35:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <Ym1EztjkJIHrg4Qz@google.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, eauger@redhat.com,
 shan.gavin@gmail.com, Jonathan.Cameron@huawei.com, pbonzini@redhat.com,
 vkuznets@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu
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

Hi Oliver,

On 4/30/22 10:16 PM, Oliver Upton wrote:
> On Sat, Apr 30, 2022 at 07:38:29PM +0800, Gavin Shan wrote:
>> Thank you for the comments and details. It should work by using bitmaps
>> to represent event's states. I will adopt your proposed structs in next
>> respin. However, there are more states needed. So I would adjust
>> "struct kvm_sdei_vcpu" like below in next respin.
>>
>>      struct kvm_sdei_vcpu {
>>          unsigned long registered;    /* the event is registered or not                 */
>>          unsigned long enabled;       /* the event is enabled or not                    */
>>          unsigned long unregistering; /* the event is pending for unregistration        */
> 
> I'm not following why we need to keep track of the 'pending unregister'
> state directly. Is it not possible to infer from (active && !registered)?
> 

The event can be unregistered and reseted through hypercalls when it's
being handled. In this case, the unregistration for the event can't
be done immediately and has to be delayed until the handling is finished.
The unregistration pending state is used in this case. Yes, it's
correct we also can use (active & !registered) to represent the state.

>>          unsigned long pending;       /* the event is pending for delivery and handling */
>>          unsigned long active;        /* the event is currently being handled           */
>>
>>          :
>>          <this part is just like what you suggested>
>>      };
>>
>> I rename @pending to @unregister. Besides, there are two states added:
>>
>>     @pending: Indicate there has one event has been injected. The next step
>>               for the event is to deliver it for handling. For one particular
>>               event, we allow one pending event in the maximum.
> 
> Right, if an event retriggers when it is pending we still dispatch a
> single event to the guest. And since we're only doing normal priority
> events, it is entirely implementation defined which gets dispatched
> first.
> 

Yep, we will simply rely on find_first_bit() for the priority. It means
the software signaled event, whose number is zero, will have the highest
priority.

>>     @active:  Indicate the event is currently being handled. The information
>>               stored in 'struct kvm_sdei_event_context' instance can be
>>               correlated with the event.
> 
> Does this need to be a bitmap though? We can't ever have more than one
> SDEI event active at a time since this is private to a vCPU.
> 

Yes, one event is active at most on one particular vCPU. So tt don't
have to be a bitmap necessarily. The reason I proposed to use bitmap
for this state is to having all (event) states represented by bitmaps.
In this way, all states are managed in a unified fashion. The alternative
way is to have "unsigned long active_event", which traces the active
event number. It also consumes 8-bytes when live migration is concerned.
So I prefer a bitmap :)

>> Furthermore, it's fair enough to put the (vcpu) mask state into 'flags'
>> field of struct kvm_vcpu_arch :)
> 
> I think you can get away with putting active in there too, I don't see
> why we need more than a single bit for this info.
> 

Not really. We just need one single bit for vCPU's mask state. We need
multiple bits for event's active state, depending on how many events are
supported. We need to know which event is currently active at least.
For now, there are only two supported events (0/1), but one single bit
is still not enough because there are 3 states: (1) software signaled
event is active. (2) async pf event is active. (3) none of them is
active.

Lets use a bitmap for the event active state as I said above, if you
don't strongly object :)

>>>>>>> Do we need this if we disallow nesting events?
>>>>>>>
>>>>>>
>>>>>> Yes, we need this. "event == NULL" is used as indication of invalid
>>>>>> context. @event is the associated SDEI event when the context is
>>>>>> valid.
>>>>>
>>>>> What if we use some other plumbing to indicate the state of the vCPU? MP
>>>>> state comes to mind, for example.
>>>>>
>>>>
>>>> Even the indication is done by another state, kvm_sdei_vcpu_context still
>>>> need to be linked (associated) with the event. After the vCPU context becomes
>>>> valid after the event is delivered, we still need to know the associated
>>>> event when some of hypercalls are triggered. SDEI_1_0_FN_SDEI_EVENT_COMPLETE
>>>> is one of the examples, we need to decrease struct kvm_sdei_event::event_count
>>>> for the hypercall.
>>>
>>> Why do we need to keep track of how many times an event has been
>>> signaled? Nothing in SDEI seems to suggest that the number of event
>>> signals corresponds to the number of times the handler is invoked. In
>>> fact, the documentation on SDEI_EVENT_SIGNAL corroborates this:
>>>
>>> """
>>> The event has edgetriggered semantics and the number of event signals
>>> may not correspond to the number of times the handler is invoked in the
>>> target PE.
>>> """
>>>
>>> DEN0054C 5.1.16.1
>>>
>>> So perhaps we queue at most 1 pending event for the guest.
>>>
>>> I'd also like to see if anyone else has thoughts on the topic, as I'd
>>> hate for you to go back to the whiteboard again in the next spin.
>>>
>>
>> Agreed. In next respin, we will have one pending event at most. Error
>> can be returned if user attempts to inject event whose pending state
>> (struct kvm_sdei_vcpu::pending) has been set.
> 
> I don't believe we can do that. The SDEI_EVENT_SIGNAL call should succeed,
> even if the event was already pending.
> 

I rethinking it a bit. Yes, you're correct. In this specific case, the
event handler is running for multiple events.

>> Indeed, the hardest part is to determine the data structures and
>> functions we need. Oliver, your valuable comments are helping to
>> bring this series to the right track. However, I do think it's
>> helpful if somebody else can confirm the outcomes from the previous
>> discussions. I'm not sure if Marc has time for a quick scan and provide
>> comments.
>>
>> I would summarize the outcomes from our discussions, to help Marc
>> or others to confirm:
> 
> Going to take a look at some of your later patches as well, just a heads
> up.
> 

Yep, thanks again for your valuable comments :)

>> - Drop support for the shared event.
>> - Dropsupport for the critical event.
>> - The events in the implementations are all private and can be signaled
>>    (raised) by software.
>> - Drop migration support for now, and we will consider it using
>>    pseudo firmware registers. So add-on patches are expected to support
>>    the migration in future.
> 
> Migration will be supported in a future spin of this series, not a
> subsequent one right? :) I had just made the suggestion because there was
> a lot of renovations that we were discussing.
> 

I prefer a separate series to support migration after this series gets
merged. There are couple of reasons to do so: (1) The migration depends
on Raghavendra's series to support for hypercall services selection.
The series is close to be merged, but not happen yet. The SDEI is one
of the hypercall services at least. SDEI's pseudo firmware registers
for migration will be managed by the infrastructure. (2) I would focus
on the core functinality for now. In this way, we give migration space.
For example, the data structures needs sorts of adjustments for migration,
just in case.

>> - Drop locking mechanism. All the functions are executed in vcpu context.
> 
> Well, not entirely. Just need to make sure atomics are used to post
> events to another vCPU in the case of SDEI_EVENT_SIGNAL.
> 
> set_bit() fits the bill here, as we've discussed.
> 

Yes, I meant to remove struct kvm_sdei_vcpu::lock by dropping the
locking mechanism :)

>> - To use the data struct as you suggested. Besides, the vcpu's mask
>>    state is put to struct kvm_arch_vcpu::flags.
>>    enum kvm_sdei_event
>>    struct kvm_sdei_event_handler
>>    struct kvm_sdei_event_context
>>    struct kvm_sdei_vcpu
>>

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

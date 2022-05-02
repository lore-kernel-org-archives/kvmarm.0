Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C8DFC433F5
	for <kvmarm@archiver.kernel.org>; Mon,  2 May 2022 08:24:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CB364B1F7;
	Mon,  2 May 2022 04:24:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id leYmvzjlreHb; Mon,  2 May 2022 04:24:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3331449EF6;
	Mon,  2 May 2022 04:24:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F2BA49EF6
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 May 2022 04:24:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zD7bwdx424xV for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 May 2022 04:24:01 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5996F49EF0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 May 2022 04:24:01 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1651479840;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=bFjPQJ4gs0bSHs76Svu0ngyI6tX2L+HSW5bxHt+dBUk=;
 b=ar3DGrZcGF2KUoBrGJTsy6YuQ/Rjmw9p4oIQtz0b6ekG51tWGspGVbB4Z+AJX4UjFAsUBW
 xBJhbPtvSt3ilwFSupmdt16zfisHe2kB91H5EaCLAA00iB42+Yp3V0yFX5/jBkb1Zyu6iG
 ItZpPr/Or+rLcGu9Pt2B+yCzREP2qSU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-629-42pL4FRSMGWZ-kxRO2QG-Q-1; Mon, 02 May 2022 04:23:55 -0400
X-MC-Unique: 42pL4FRSMGWZ-kxRO2QG-Q-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4330985A5A8;
 Mon,  2 May 2022 08:23:55 +0000 (UTC)
Received: from [10.72.12.86] (ovpn-12-86.pek2.redhat.com [10.72.12.86])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1BDA4416146;
 Mon,  2 May 2022 08:23:48 +0000 (UTC)
Subject: Re: [PATCH v6 03/18] KVM: arm64: Add SDEI virtualization
 infrastructure
To: Oliver Upton <oupton@google.com>
References: <YmMiyt/TDjJt0mdG@google.com>
 <36899ea9-e8bd-27b2-8dfb-75b76eab50d7@redhat.com>
 <YmRI7Bh7fWCYLUGT@google.com>
 <0e26da1a-00bb-3d63-a8bf-6cd3271b0a38@redhat.com>
 <Ymr45B+8xTlhi7vk@google.com>
 <96711526-c4f3-3b50-c015-beba8cc9fcc9@redhat.com>
 <Ym1EztjkJIHrg4Qz@google.com>
 <62f06a03-d6fc-3803-a2d2-7a85cf733459@redhat.com>
 <Ym9So9YariC0M7Zu@google.com>
 <2d631426-17fd-e7e3-5c62-eda547732bb7@redhat.com>
 <Ym+O+JLU5e9NUs39@google.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <a5b81935-50e6-72c5-58bc-bf591f9b826e@redhat.com>
Date: Mon, 2 May 2022 16:23:45 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <Ym+O+JLU5e9NUs39@google.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
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

On 5/2/22 3:57 PM, Oliver Upton wrote:
> On Mon, May 02, 2022 at 03:25:40PM +0800, Gavin Shan wrote:
>> Oliver, how about to adjust struct kvm_sdei_vcpu like below. With the
>> changes, struct kvm_sdei_vcpu::unregistering is dropped, to match with
>> the specification strictly.
>>
>>     struct kvm_sdei_vcpu {
>>         unsigned long registered;
>>         unsigned long enabled;
>>         unsigned long running;        // renamed from 'active' to match the specification strictly
>>         unsigned long pending;        // event pending for delivery
>>            :
>>     };
>>
>>     state                          @registered  @enabled  @running  @pending
>>     --------------------------------------------------------------------------------
>>     unregistered                   0            0         0/1       0
>>     registered-disabled            1            0         0         0/1
>>     registered-enabled             1            1         0/1       0/1
>>     handler-running                0/1          0/1       1         0/1
>>
>> We can use the specific encoding to represent the unregistration-pending.
>>
>>     state                          @registered  @enabled  @running  @pending
>>     -------------------------------------------------------------------------
>>     handler-running                0            0          1        0
> 
> Right, this is what I had in mind. This encodes the
> 'handler-unregister-pending' state.
> 

Cool, Thanks for your confirm. I think we're on same page for the
data structures now. With this, I'm able to start working on next
revision. Oliver, I'm sorry for taking you too much time to reach
to the point :)

>> Thanks for your valuable comments, Oliver. I'm not starting to work on
>> v7 yet. I also would like to make everything clear before that. In that
>> case, it will be easier for you to review next revision :)
>>
>>>>>>            unsigned long pending;       /* the event is pending for delivery and handling */
>>>>>>            unsigned long active;        /* the event is currently being handled           */
>>>>>>
>>>>>>            :
>>>>>>            <this part is just like what you suggested>
>>>>>>        };
>>>>>>
>>>>>> I rename @pending to @unregister. Besides, there are two states added:
>>>>>>
>>>>>>       @pending: Indicate there has one event has been injected. The next step
>>>>>>                 for the event is to deliver it for handling. For one particular
>>>>>>                 event, we allow one pending event in the maximum.
>>>>>
>>>>> Right, if an event retriggers when it is pending we still dispatch a
>>>>> single event to the guest. And since we're only doing normal priority
>>>>> events, it is entirely implementation defined which gets dispatched
>>>>> first.
>>>>>
>>>>
>>>> Yep, we will simply rely on find_first_bit() for the priority. It means
>>>> the software signaled event, whose number is zero, will have the highest
>>>> priority.
>>>>
>>>>>>       @active:  Indicate the event is currently being handled. The information
>>>>>>                 stored in 'struct kvm_sdei_event_context' instance can be
>>>>>>                 correlated with the event.
>>>>>
>>>>> Does this need to be a bitmap though? We can't ever have more than one
>>>>> SDEI event active at a time since this is private to a vCPU.
>>>>>
>>>>
>>>> Yes, one event is active at most on one particular vCPU. So tt don't
>>>> have to be a bitmap necessarily. The reason I proposed to use bitmap
>>>> for this state is to having all (event) states represented by bitmaps.
>>>> In this way, all states are managed in a unified fashion. The alternative
>>>> way is to have "unsigned long active_event", which traces the active
>>>> event number. It also consumes 8-bytes when live migration is concerned.
>>>> So I prefer a bitmap :)
>>>>
>>>
>>> The small benefit of using the event number is that we can address all
>>> events in 8 bytes, whereas we'd need to extend the bitmap for >64
>>> events. I suppose we'll run into that issue either way, since the
>>> pending, registered, and enabled portions are also bitmaps.
>>>
>>> When live migration is in scope we should probably bark at userspace if
>>> it attempts to set more than a single bit in the register.
>>>
>>
>> Even it's unlikely to support the shared event, bitmap will help in that
>> case. I'm not sure about other VMM, the pseudo firmware registers are
>> almost transparent to user space in QEMU. They're accessed and no one
>> cares the values reading from and writing to these registers in QEMU ;-)
> 
> Regardless of whether userspace actually manipulates the registers we
> should still reject unsupported values. For example:
> 
> Let's say the VM is started on a kernel that introduced yet another SDEI
> widget outside of your series. The VM was migrated back to an older
> kernel w/o the SDEI widget, and as such the VMM attempts to set the
> widget bit. Since the old kernel doesn't know what to do with the value
> it should return EINVAL to userspace.
> 

Yep, agreed. Thanks for the examples and details. Lets have more
discussion when the series to support migration is posted.

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

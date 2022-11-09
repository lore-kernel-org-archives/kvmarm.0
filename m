Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2561C433FE
	for <kvmarm@archiver.kernel.org>; Wed,  9 Nov 2022 00:51:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3909C4B848;
	Tue,  8 Nov 2022 19:51:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5aWvrPBAhg75; Tue,  8 Nov 2022 19:51:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C9E184B850;
	Tue,  8 Nov 2022 19:51:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 96BAD4B848
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Nov 2022 19:51:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OjUJ9mkZo+by for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Nov 2022 19:51:48 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 09C874B836
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Nov 2022 19:51:47 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1667955107;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=CA553UdMHM5fe7exANwpCbWYCtvriI9MY8mWlunIGdY=;
 b=RAiyYzwkTiZoESEdTk5vP7F23MHIaHdlFDk9YjMlo2ZixxhWmIX5Lrs/DYI+OrXPLKT+f4
 Yfxf2pFM52Y+yHkrWCCltTSSbZTpU6m7V9suYdIHrwdB4mGN4Gy9lE6EGqItQVz3WaUGsL
 FP3VLzKDnG44LJdUgtZ34rPTvHQPmTE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-408-lAi4c7PLNBi9hDTwzs2qeQ-1; Tue, 08 Nov 2022 19:51:40 -0500
X-MC-Unique: lAi4c7PLNBi9hDTwzs2qeQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 648BA101A528;
 Wed,  9 Nov 2022 00:51:30 +0000 (UTC)
Received: from [10.64.54.78] (vpn2-54-78.bne.redhat.com [10.64.54.78])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3C38D140EBF3;
 Wed,  9 Nov 2022 00:51:23 +0000 (UTC)
Subject: Re: [PATCH v9 3/7] KVM: Support dirty ring in conjunction with bitmap
To: Sean Christopherson <seanjc@google.com>
References: <20221108041039.111145-1-gshan@redhat.com>
 <20221108041039.111145-4-gshan@redhat.com> <Y2qDCqFeL1vwqq3f@google.com>
 <49217b8f-ce53-c41b-98aa-ced34cd079cc@redhat.com>
 <Y2rurDmCrXZaxY8F@google.com>
 <49c18201-b73a-b654-7f8a-77befa80c61b@redhat.com>
 <Y2r1ErahBE3+Dsv8@google.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <672eb11b-19db-9a9f-1898-8d2af0d45724@redhat.com>
Date: Wed, 9 Nov 2022 08:51:21 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <Y2r1ErahBE3+Dsv8@google.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Cc: maz@kernel.org, kvm@vger.kernel.org, catalin.marinas@arm.com,
 andrew.jones@linux.dev, dmatlack@google.com, will@kernel.org,
 shan.gavin@gmail.com, bgardon@google.com, kvmarm@lists.linux.dev,
 pbonzini@redhat.com, zhenyzha@redhat.com, shuah@kernel.org,
 kvmarm@lists.cs.columbia.edu, ajones@ventanamicro.com
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

On 11/9/22 8:32 AM, Sean Christopherson wrote:
> On Wed, Nov 09, 2022, Gavin Shan wrote:
>> On 11/9/22 8:05 AM, Sean Christopherson wrote:
>>> On Wed, Nov 09, 2022, Gavin Shan wrote:
>>>> On 11/9/22 12:25 AM, Sean Christopherson wrote:
>>>>> I have no objection to disallowing userspace from disabling the combo, but I
>>>>> think it's worth requiring cap->args[0] to be '0' just in case we change our minds
>>>>> in the future.
>>>>>
>>>>
>>>> I assume you're suggesting to have non-zero value in cap->args[0] to enable the
>>>> capability.
>>>>
>>>>       if (!IS_ENABLED(CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP) ||
>>>>           !kvm->dirty_ring_size || !cap->args[0])
>>>>           return r;
>>>
>>> I was actually thinking of taking the lazy route and requiring userspace to zero
>>> the arg, i.e. treat it as a flags extensions.  Oh, wait, that's silly.  I always
>>> forget that `cap->flags` exists.
>>>
>>> Just this?
>>>
>>> 	if (!IS_ENABLED(CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP) ||
>>> 	    !kvm->dirty_ring_size || cap->flags)
>>> 		return r;
>>>
>>> It'll be kinda awkward if KVM ever does add a flag to disable the bitmap, but
>>> that's seems quite unlikely and not the end of the world if it does happen.  And
>>> on the other hand, requiring '0' is less weird and less annoying for userspace
>>> _now_.
>>>
>>
>> I don't quiet understand the term "lazy route".
> 
> "lazy" in that requiring a non-zero value would mean adding another #define,
> otherwise the extensibility is limited to two values.  Again, unlikely to matter,
> but it wouldn't make sense to go through the effort to provide some extensibility
> and then only allow for one possible extension.  If KVM is "lazy" and just requires
> flags to be '0', then there's no need for more #defines, and userspace doesn't
> have to pass more values in its enabling.
> 

Thanks for the explanation. I understand the term 'lazy route' now. Right,
cap->flags is good place to hold #defines in future. cap->args[0] doesn't
suite strictly here.

>> So you're still thinking of the possibility to allow disabling the capability
>> in future?
> 
> Yes, or more likely, tweaking the behavior of ring+bitmap.  As is, the behavior
> is purely a fallback for a single case where KVM can't push to the dirty ring due
> to not having a running vCPU.  It's possible someone might come up with a use case
> where they want KVM to do something different, e.g. fallback to the bitmap if the
> ring is full.
> 
> In other words, it's mostly to hedge against futures we haven't thought of.  Reserving
> cap->flags is cheap and easy for both KVM and userspace, so there's no real reason
> not to do so.
> 

Agreed that it's cheap to reserve cap->flags. I will change the code accordingly
in v10.

>> If so, cap->flags or cap->args[0] can be used. For now, we just
>> need a binding between cap->flags/args[0] with the operation of enabling the
>> capability. For example, "cap->flags == 0x0" means to enable the capability
>> for now, and "cap->flags != 0x0" to disable the capability in future.
>>
>> The suggested changes look good to me in either way. Sean, can I grab your
>> reviewed-by with your comments addressed?
> 
> I'll look at v10, I don't like providing reviews that are conditional on changes
> that are more than nits.
> 
> That said, there're no remaining issues that can't be sorted out on top, so don't
> hold up v10 if I don't look at it in a timely manner for whatever reason.  I agree
> with Marc that it'd be good to get this in -next sooner than later.
> 

Sure. I would give v9 a few days, prior to posting v10. I'm not sure if other people
still have concerns. If there are more comments, I want to address all of them
in v10 :)

Thanks,
Gavin


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BBA1C433FE
	for <kvmarm@archiver.kernel.org>; Sat, 12 Nov 2022 09:50:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 62E9D4B813;
	Sat, 12 Nov 2022 04:50:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cIW96p4ypKt9; Sat, 12 Nov 2022 04:50:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 79A174B815;
	Sat, 12 Nov 2022 04:50:38 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 37ABD4B808
 for <kvmarm@lists.cs.columbia.edu>; Sat, 12 Nov 2022 04:50:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id armO2LuzZVv3 for <kvmarm@lists.cs.columbia.edu>;
 Sat, 12 Nov 2022 04:50:35 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BCFF04B7B6
 for <kvmarm@lists.cs.columbia.edu>; Sat, 12 Nov 2022 04:50:35 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1668246635;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=MQvWWb38uU9+o+OgbHz/CB6KHVLKTjhlq9EoM/gzvVo=;
 b=XT1eCk0nbORcyNuEc37pvkFqcbIw1JtpHUWRHwG7pyrDF0P/lSUwBFfgmEB/EkZVgZ/MkL
 1nYRRh3/aQLdHaadf+A7qQDIINsz759m71XzmzBWRwvAbSA9gJ2TjaZesVGOg0jWLYN3Bo
 +8fc18Yhb4meJ4DP38MOEGGq1Z4ERdA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-124-XoCLGkQsMRSORDbsh9z_GQ-1; Sat, 12 Nov 2022 04:50:29 -0500
X-MC-Unique: XoCLGkQsMRSORDbsh9z_GQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 089B23800C29;
 Sat, 12 Nov 2022 09:50:29 +0000 (UTC)
Received: from [10.67.24.81] (unknown [10.67.24.81])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8F20540C2066;
 Sat, 12 Nov 2022 09:50:19 +0000 (UTC)
Subject: Re: [PATCH v10 3/7] KVM: Support dirty ring in conjunction with bitmap
To: Sean Christopherson <seanjc@google.com>
References: <20221110104914.31280-1-gshan@redhat.com>
 <20221110104914.31280-4-gshan@redhat.com> <Y20q3lq5oc2gAqr+@google.com>
 <1cfa0286-9a42-edd9-beab-02f95fc440ad@redhat.com>
 <86h6z5plhz.wl-maz@kernel.org>
 <d11043b5-ff65-0461-146e-6353cf66f737@redhat.com>
 <Y27T+1Y8w0U6j63k@google.com>
 <c95c9912-0ca9-88e5-8b51-0c6826cf49b9@redhat.com>
 <Y27mUerBVW5+loCf@google.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <d503d56a-bbf8-4935-7f88-9453c115f758@redhat.com>
Date: Sat, 12 Nov 2022 17:50:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <Y27mUerBVW5+loCf@google.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>, bgardon@google.com,
 andrew.jones@linux.dev, dmatlack@google.com, will@kernel.org,
 shan.gavin@gmail.com, catalin.marinas@arm.com, kvmarm@lists.linux.dev,
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

On 11/12/22 8:18 AM, Sean Christopherson wrote:
> On Sat, Nov 12, 2022, Gavin Shan wrote:
>> On 11/12/22 7:00 AM, Sean Christopherson wrote:
>>> On Sat, Nov 12, 2022, Gavin Shan wrote:
>>>> On 11/11/22 11:19 PM, Marc Zyngier wrote:
>>>>> On Thu, 10 Nov 2022 23:47:41 +0000,
>>>>> Gavin Shan <gshan@redhat.com> wrote:
>>>>> But that I don't get. Or rather, I don't get the commit message that
>>>>> matches this hunk. Do we want to catch the case where all of the
>>>>> following are true:
>>>>>
>>>>> - we don't have a vcpu,
>>>>> - we're allowed to log non-vcpu dirtying
>>>>> - we *only* have the ring?
>>>
>>> As written, no, because the resulting WARN will be user-triggerable.  As mentioned
>>> earlier in the thread[*], if ARM rejects KVM_DEV_ARM_ITS_SAVE_TABLES when dirty
>>> logging is enabled with a bitmap, then this code can WARN.
>>>
>>
>> I assume you're saying to reject the command when dirty ring is enabled
>> __without__ a bitmap. vgic/its is the upper layer of dirty dirty.
> 
> I was stating that that is an option.  I was not opining anything, I truly don't
> care whether or not KVM_DEV_ARM_ITS_SAVE_TABLES is rejected.
> 

Ok.

>> To me, it's a bad idea for the upper layer needs to worry too much about the
>> lower layer.
> 
> That ship sailed when we added kvm_arch_allow_write_without_running_vcpu().
> Arguably, it sailed when the dirty ring was added, which solidified the requirement
> that writing guest memory "must" be done with a running vCPU.
> 

Well, sort of. I don't expect large mount of dirty pages will be tracked by
the backup bitmap :)

>>>>> If so, can we please capture that in the commit message?
>>>>>
>>>>
>>>> Nice catch! This particular case needs to be warned explicitly. Without
>>>> the patch, kernel crash is triggered. With this patch applied, the error
>>>> or warning is dropped silently. We either check memslot->dirty_bitmap
>>>> in mark_page_dirty_in_slot(), or check it in kvm_arch_allow_write_without_running_vcpu().
>>>> I personally the later one. Let me post a formal patch on top of your
>>>> 'next' branch where the commit log will be improved accordingly.
>>>
>>> As above, a full WARN is not a viable option unless ARM commits to rejecting
>>> KVM_DEV_ARM_ITS_SAVE_TABLES in this scenario.  IMO, either reject the ITS save
>>> or silently ignore the goof.  Adding a pr_warn_ratelimited() to alert the user
>>> that they shot themselves in the foot after the fact seems rather pointless if
>>> KVM could have prevented the self-inflicted wound in the first place.
>>>
>>> [*] https://lore.kernel.org/all/Y20q3lq5oc2gAqr+@google.com
>>>
>>
>> Without a message printed by WARN, kernel crash or pr_warn_ratelimited(), it
>> will be hard for userspace to know what's going on, because the dirty bits
>> have been dropped silently.I think we still survive since we have WARN
>> message for other known cases where no running vcpu context exists.
> 
> That WARN is to catch KVM bugs.  No KVM bugs, no WARN.  WARNs must not be user
> triggerable in the absence of kernel bugs.  This is a kernel rule, not a KVM thing,
> e.g. see panic_on_warn.
> 
> printk() is useless for running at any kind of scale as userspace can't take action
> on "failure", e.g. unless userspace has a priori knowledge of the _exact_ error
> message then human intervention is required (there are other issues as well).
> 
> A ratelimited printk() makes things even worse because then a failing VM may not
> get its "failure" logged, i.e. the printk() is even less actionable.
> 
> And user triggerable printks() need to be ratelimited to prevent a malicious or
> broken userspace from flooding the kernel log.  Thus, this "failure" would need
> to be ratelimited, making it all but useless for anyone but developers.
> 

Thanks for the details to explain. Right, It's true for WARN to catch KVM bugs
instead of user-triggerable bugs. I agree that none of WARN/printk/ratelimited_printk()
is applicable in this case.

>> So if I'm correct, what we need to do is to improve the commit message to
>> address Marc's concerns here? :)
> 
> Yes, Marc is saying that it's not strictly wrong for userspace to not dirty log
> the ITS save, so rejecting KVM_DEV_ARM_ITS_SAVE_TABLES is a bad option.
> 

Ok. I've posted formal patch for 'next' branch, with the improved commit message.
Please take a look when you get a chance.

https://lore.kernel.org/kvmarm/20221112094322.21911-1-gshan@redhat.com/T/#u

Thanks,
Gavin


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

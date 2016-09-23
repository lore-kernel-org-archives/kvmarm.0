From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v6] KVM: arm/arm64: Route vtimer events to user space
Date: Fri, 23 Sep 2016 14:46:48 +0200
Message-ID: <55ac71d8-7e92-aa57-9856-5fc48a7f8357@redhat.com>
References: <1474628854-69945-1-git-send-email-agraf@suse.de>
 <dd9267b6-2323-2d74-0553-71a89d05a654@redhat.com>
 <D82BA95A-A89E-46EB-93D2-197DF44433EC@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <D82BA95A-A89E-46EB-93D2-197DF44433EC@suse.de>
Sender: kvm-owner@vger.kernel.org
To: Alexander Graf <agraf@suse.de>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, drjones@redhat.com, christoffer.dall@linaro.org, marc.zyngier@arm.com, peter.maydell@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu



On 23/09/2016 14:36, Alexander Graf wrote:
>>>
>>> +        if ((ret == 1) && timer_ret) {
>>> +            /*
>>> +             * We have to exit straight away to ensure that we only
>>> +             * ever notify user space once about a level change
>>> +             */
>>
>> Is this really a requirement?  It complicates the logic noticeably.
> 
> The alternative would be to track the state on ioctl entry, which
> Christoffer disliked :).

Ok, I see.  Maybe he's convinced by the ugly code. :)

It's not an architectural concept, it's a KVM API concept.  Tracking the
state on entry just the equivalent of making this vmexit edge-triggered
(both rising and falling edge).

Paolo

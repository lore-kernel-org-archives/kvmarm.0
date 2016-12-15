From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 1/2] ARM: hyp-stub: improve ABI
Date: Thu, 15 Dec 2016 15:37:15 +0000
Message-ID: <c21d6514-44a2-ba88-0fe5-d14d5897cc48@arm.com>
References: <20161213113044.GC19985@leverpostej>
 <E1cH74w-0003ke-Qp@rmk-PC.armlinux.org.uk>
 <72f93940-cf87-fd91-90f2-760b7ff050fb@arm.com>
 <20161215113539.GK14217@n2100.armlinux.org.uk>
 <06fca797-da5d-f7f2-eecb-9b1b33b7e83f@arm.com>
 <20161215151548.GL14217@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D2E0C402AF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Dec 2016 10:36:09 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Zoml+YPzT+k0 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Dec 2016 10:36:08 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 757B1401C7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Dec 2016 10:36:08 -0500 (EST)
In-Reply-To: <20161215151548.GL14217@n2100.armlinux.org.uk>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, dave.martin@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 15/12/16 15:15, Russell King - ARM Linux wrote:
> On Thu, Dec 15, 2016 at 11:46:41AM +0000, Marc Zyngier wrote:
>> On 15/12/16 11:35, Russell King - ARM Linux wrote:
>>> On Thu, Dec 15, 2016 at 11:18:48AM +0000, Marc Zyngier wrote:
>>>> On 14/12/16 10:46, Russell King wrote:
>>>>> @@ -231,10 +244,14 @@ ENDPROC(__hyp_stub_do_trap)
>>>>>   * initialisation entry point.
>>>>>   */
>>>>>  ENTRY(__hyp_get_vectors)
>>>>> -	mov	r0, #-1
>>>>> +	mov	r0, #HVC_GET_VECTORS
>>>>
>>>> This breaks the KVM implementation of __hyp_get_vectors, easily fixed
>>>> with the following patchlet:
>>>
>>> Right, so what Mark said is wrong:
>>>
>>> "The hyp-stub is part of the kernel image, and the API is private to
>>>  that particular image, so we can change things -- there's no ABI to
>>>  worry about."
>>
>> I think Mark is right. The API *is* private to the kernel, and KVM being
>> the only in-kernel hypervisor on ARM, this is not an ABI.
> 
> Again, that's wrong.
> 
> We have two hypervisors in the kernel.  One is KVM, the other is the
> stub.  Sure, the stub isn't a full implementation of a hypervisor, but
> it is nevertheless, for the purposes of _this_ discussion, a hypervisor
> of sorts.
> 
> The reason that both are included is because they both appear to share
> a common interface (although that's totally not documented anywhere.)

And this interface exists for the sole purpose of enabling KVM. Call it
a hypervisor if you wish, but its usefulness is doubtful on its own.

>>> So no, I'm going with my original patch (which TI has tested) which is
>>> the minimal change, and if we _then_ want to rework the HYP mode
>>> interfaces, that's the time to do the other changes when more people
>>> (such as KVM folk) are paying attention and we can come to a cross-
>>> hypervisor agreement on what the interface should be.
>>
>> Given that there is a single in-kernel hypervisor, I can't really see
>> who we're going to agree anything with...
> 
> As far as I can see, the hyp-stub falls under ARM arch maintanence.
> KVM falls under KVM people.  Two different groups, we need agreement
> between them what a sane API for both "hypervisors" should be.

Well, I though we had the right level of discussion by reviewing your
patches and coming up with improvements. If you're after something else,
please let me know.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...

From: nick <xerofoify@gmail.com>
Subject: Re: [PATCH] kvm:arm:Fix error handling in the function vgic_v3_probe
Date: Thu, 06 Aug 2015 21:31:42 -0400
Message-ID: <55C40A7E.6040003@gmail.com>
References: <1438793303-30228-1-git-send-email-xerofoify@gmail.com>	<55C240D9.5060900@redhat.com>	<55C242C6.6060200@gmail.com>	<55C31582.4000809@arm.com>	<55C34C77.7090303@redhat.com>	<55C35E3D.9000708@gmail.com>
 <CAJKOXPeVGmrkBwRRY6D46MhXtWH+_ybxyJpQjyH4F7BOpKLxSQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BEFBC5A39F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Aug 2015 21:18:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0frU8PzGydqJ for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Aug 2015 21:18:52 -0400 (EDT)
Received: from mail-ig0-f182.google.com (mail-ig0-f182.google.com
 [209.85.213.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BF4755A2D7
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Aug 2015 21:18:52 -0400 (EDT)
Received: by igbij6 with SMTP id ij6so22552913igb.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 06 Aug 2015 18:31:44 -0700 (PDT)
In-Reply-To: <CAJKOXPeVGmrkBwRRY6D46MhXtWH+_ybxyJpQjyH4F7BOpKLxSQ@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "gleb@kernel.org" <gleb@kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Paolo Bonzini <pbonzini@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu



On 2015-08-06 08:47 PM, Krzysztof Kozlowski wrote:
> 2015-08-06 22:16 GMT+09:00 nick <xerofoify@gmail.com>:
>>
>>
>> On 2015-08-06 08:00 AM, Paolo Bonzini wrote:
>>>
>>>
>>> On 06/08/2015 10:06, Marc Zyngier wrote:
>>>>> If this structure of function pointers can handle function pointers with a return type of
>>>>> void I will be glad to do what you request otherwise this would require a major rewrite
>>>>> of kvm arm subsystem for a very simple bug fix.
>>>>
>>>> Just like Paolo said, the error you report should never happen, and
>>>> would be caught by a WARN_ON() the first time anyone boots the kernel.
>>>> Also, failing to register the device ops results in not being able to
>>>> instantiate a VGIC. No harm done. I really don't understand why you want
>>>> to rewrite the probe functions.
>>>
>>> I think he just misunderstood my suggestion.  I didn't suggest making
>>> the probe functions return void.  I suggested that
>>> kvm_register_device_ops return void.
>>>
>>> Paolo
>>>
>> Unfortunately the other maintainer is right in the s390 kvm subsystem uses the return value of the call to
>> kvm_register_device_ops. However we could do something like a WARN_ON if kvm_register_device_ops fails in
>> callers that never are required to never use it's return value.
>> Sorry about the Misunderstanding as I misread your suggestion.
>> Nick
> 
> Dear Nick,
> 
> Since you are not testing the patches, please always mark them with
> RFT prefix, instead of PATCH. Someone may get confused and actually
> apply untested patch.
> 
> Best regards,
> Krzysztof
> 
Krzysztof,
I am not stating your wrong here but most of my patches are either trivial bug fixes that
don't need any testing or our on hardware I don't have lying around. In addition unless
my bugs are hard to trace a.k.a locking issues or hardware dependent that need proof due
to being unable to trace without the hardware I feel that your statement is a valid idea
but may not be the best here. If you would like me to still write RFT on my patches or
our concerned about me testing them I can assure you that there tested when I am able
to.
Cheers,
Nick 

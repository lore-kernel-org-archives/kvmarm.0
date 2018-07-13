From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v7 3/4] KVM: arm64: Share the parts of get/set events
 useful to 32bit
Date: Fri, 13 Jul 2018 16:27:37 +0100
Message-ID: <77fa3cb5-ef9c-962a-0d0c-b7cac19c1ce7@arm.com>
References: <20180710164952.23736-1-james.morse@arm.com>
 <20180710164952.23736-4-james.morse@arm.com>
 <b392c9e1-d0e4-9674-a223-351b381db76c@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D0E74A0DD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Jul 2018 11:14:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vQg7e14i51LI for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Jul 2018 11:14:50 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5853E4A0D9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Jul 2018 11:14:50 -0400 (EDT)
In-Reply-To: <b392c9e1-d0e4-9674-a223-351b381db76c@huawei.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: gengdongjiu <gengdongjiu@huawei.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, linuxarm@huawei.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi gengdongjiu,

On 11/07/18 08:16, gengdongjiu wrote:
> On 2018/7/11 0:49, James Morse wrote:
>> The get/set events helpers to do some work to check reserved
>> and padding fields are zero. This is useful on 32bit too.
>>
>> Move this code into virt/kvm/arm/arm.c, and give the arch
>> code some underscores.
>>
>> This is temporarily hidden behind __KVM_HAVE_VCPU_EVENTS until
>> 32bit is wired up.

>> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
>> index a94eab71e5c7..f70d24e1751d 100644
>> --- a/virt/kvm/arm/arm.c
>> +++ b/virt/kvm/arm/arm.c
>> @@ -1044,6 +1044,34 @@ static int kvm_arm_vcpu_has_attr(struct kvm_vcpu *vcpu,

>> +#ifdef __KVM_HAVE_VCPU_EVENTS	/* temporary: until 32bit is wired up */

[..]

>> +#endif /* __KVM_HAVE_VCPU_EVENTS */

> In [PATCH v7 4/4] KVM: arm: Add 32bit get/set events support, I see you> remove "__KVM_HAVE_VCPU_EVENTS" in kvm_arch_vcpu_ioctl()
> but here it adds, it looks like strange.
> so maybe it is better keep it in both place, or remove them both.
> 
> From the comments /* temporary: until 32bit is wired up */, do you forget
> to remove the __KVM_HAVE_VCPU_EVENTS	after wiring up the 32bit?

Indeed I did, the 'temporary' note was meant to remind me!
(and I forgot about the documentation too)


Thanks!

James

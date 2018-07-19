From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v8 1/4] arm/arm64: KVM: Add KVM_GET/SET_VCPU_EVENTS
Date: Thu, 19 Jul 2018 15:15:20 +0100
Message-ID: <a840714a-16b3-2da8-c6e2-5be85c73bda2@arm.com>
References: <20180713154751.18131-1-james.morse@arm.com>
 <20180713154751.18131-2-james.morse@arm.com>
 <CAFEAcA-t8U-GmkCtAcAN8tj4UAaynCZhgTi1Cg1RhaarGUOJfg@mail.gmail.com>
 <49bb119c-ec31-34ee-f4e5-9f3e90d7c181@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D3BC4065F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Jul 2018 10:02:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xkV3ZwP7S2n8 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Jul 2018 10:02:19 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7649640192
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Jul 2018 10:02:19 -0400 (EDT)
In-Reply-To: <49bb119c-ec31-34ee-f4e5-9f3e90d7c181@huawei.com>
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
To: gengdongjiu <gengdongjiu@huawei.com>, Peter Maydell <peter.maydell@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, kvmarm@lists.cs.columbia.edu, kvm-devel <kvm@vger.kernel.org>, Linuxarm <linuxarm@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi guys,

On 19/07/18 08:39, gengdongjiu wrote:
> On 2018/7/18 0:33, Peter Maydell wrote:
>> On 13 July 2018 at 16:47, James Morse <james.morse@arm.com> wrote:
>>> From: Dongjiu Geng <gengdongjiu@huawei.com>
>>>
>>> For the migrating VMs, user space may need to know the exception
>>> state. For example, in the machine A, KVM make an SError pending,
>>> when migrate to B, KVM also needs to pend an SError.
>>>
>>> This new IOCTL exports user-invisible states related to SError.
>>> Together with appropriate user space changes, user space can get/set
>>> the SError exception state to do migrate/snapshot/suspend.

>>> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
>>> index d10944e619d3..e3940f8715a5 100644
>>> --- a/Documentation/virtual/kvm/api.txt
>>> +++ b/Documentation/virtual/kvm/api.txt


>>> +Gets currently pending SError exceptions as well as related states of the vcpu.
>>
>> Any chance of expanding this to explain what this state actually is?
>> (ie something you could use to implement or review the userspace
>> code which has to manipulate it)
> sure, can expand it.
> 
> serror_pending means whether KVM is pending Serror for guest.
> serror_has_esr means whether KVM or user space can set the SError syndrome for guest.
> serror_esr means the value of SError syndrome.

I've had a go at something more verbose for this section:
------------------%<------------------
If the guest accesses a device that is being emulated by the host kernel in such
a way that a real device would generate a physical SError, KVM may make a
virtual SError pending for that VCPU. This system error interrupt remains
pending until the guest takes the exception by unmasking PSTATE.A.

Running the VCPU may cause it to take a pending SError, or make an access that
causes an SError to become pending. The event's description is only valid while
the VPCU is not running.

This API provides a way to read and write the pending 'event' state that is not
visible to the guest. To save, restore or migrate a VCPU the struct representing
the state can be read then written using this GET/SET API, along with the other
guest-visible registers. It is not possible to 'cancel' an SError that has been
made pending.

A device being emulated in user-space may also wish to generate an SError. To do
this the events structure can be populated by user-space. The current state
should be read first, to ensure no existing SError is pending. If an existing
SError is pending, the architectures 'Multiple SError interrupts' rules should
be followed. (2.5.3 of DDI0587.a "ARM Reliability, Availability, and
Serviceability (RAS) Specification").
------------------%<------------------


Thanks,

James

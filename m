Return-Path: <SRS0=WCH4=CT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C4D8C43461
	for <kvmarm@archiver.kernel.org>; Thu, 10 Sep 2020 17:41:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 89164221E3
	for <kvmarm@archiver.kernel.org>; Thu, 10 Sep 2020 17:41:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 89164221E3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BE4054B2D8;
	Thu, 10 Sep 2020 13:41:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xRIp5g1slDDi; Thu, 10 Sep 2020 13:41:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 214194B2DC;
	Thu, 10 Sep 2020 13:41:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 82A7F4B2D5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Sep 2020 13:41:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id j8ggRQ7F5msY for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Sep 2020 13:41:50 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A95AE4B2BF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Sep 2020 13:41:50 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3CE35106F;
 Thu, 10 Sep 2020 10:41:50 -0700 (PDT)
Received: from [10.57.40.122] (unknown [10.57.40.122])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 662A43F73C;
 Thu, 10 Sep 2020 10:41:47 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: arm64: Allow to limit number of PMU counters
To: Alexander Graf <graf@amazon.com>, Marc Zyngier <maz@kernel.org>
References: <20200908205730.23898-1-graf@amazon.com>
 <9a4279aa9bf0a40bece3930c11c2f7cb@kernel.org>
 <07255b9e-95d3-94d4-cfb0-6408e8bf7818@amazon.com>
 <09d6b66a-e20b-b424-cc4a-480297b544cf@arm.com>
 <6cd8e545-f083-7d08-32aa-63e41dd69214@amazon.com>
From: Robin Murphy <robin.murphy@arm.com>
Message-ID: <0071fa4a-328d-8bd6-106b-2407e5f0a93d@arm.com>
Date: Thu, 10 Sep 2020 18:41:44 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <6cd8e545-f083-7d08-32aa-63e41dd69214@amazon.com>
Content-Language: en-GB
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2020-09-10 17:46, Alexander Graf wrote:
> =

> =

> On 10.09.20 17:52, Robin Murphy wrote:
>>
>> On 2020-09-10 11:18, Alexander Graf wrote:
>>>
>>>
>>> On 10.09.20 12:06, Marc Zyngier wrote:
>>>>
>>>> On 2020-09-08 21:57, Alexander Graf wrote:
>>>>> We currently pass through the number of PMU counters that we have
>>>>> available
>>>>> in hardware to guests. So if my host supports 10 concurrently active
>>>>> PMU
>>>>> counters, my guest will be able to spawn 10 counters as well.
>>>>>
>>>>> This is undesireable if we also want to use the PMU on the host for
>>>>> monitoring. In that case, we want to split the PMU between guest and
>>>>> host.
>>>>>
>>>>> To help that case, let's add a PMU attr that allows us to limit the
>>>>> number
>>>>> of PMU counters that we expose. With this patch in place, user space
>>>>> can
>>>>> keep some counters free for host use.
>>>>>
>>>>> Signed-off-by: Alexander Graf <graf@amazon.com>
>>>>>
>>>>> ---
>>>>>
>>>>> Because this patch touches the same code paths as the vPMU filtering
>>>>> one
>>>>> and the vPMU filtering generalized a few conditions in the attr path,
>>>>> I've based it on top. Please let me know if you want it independent
>>>>> instead.
>>>>>
>>>>> v1 -> v2:
>>>>>
>>>>> =A0 - Add documentation
>>>>> =A0 - Add read support
>>>>> ---
>>>>> =A0Documentation/virt/kvm/devices/vcpu.rst | 25 =

>>>>> +++++++++++++++++++++++++
>>>>> =A0arch/arm64/include/uapi/asm/kvm.h=A0=A0=A0=A0=A0=A0 |=A0 7 ++++---
>>>>> =A0arch/arm64/kvm/pmu-emul.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 | 32
>>>>> ++++++++++++++++++++++++++++++++
>>>>> =A0arch/arm64/kvm/sys_regs.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 |=A0 5 +++++
>>>>> =A0include/kvm/arm_pmu.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 |=A0 1 +
>>>>> =A05 files changed, 67 insertions(+), 3 deletions(-)
>>>>>
>>>>> diff --git a/Documentation/virt/kvm/devices/vcpu.rst
>>>>> b/Documentation/virt/kvm/devices/vcpu.rst
>>>>> index 203b91e93151..1a1c8d8c8b1d 100644
>>>>> --- a/Documentation/virt/kvm/devices/vcpu.rst
>>>>> +++ b/Documentation/virt/kvm/devices/vcpu.rst
>>>>> @@ -102,6 +102,31 @@ isn't strictly speaking an event. Filtering the
>>>>> cycle counter is possible
>>>>> =A0using event 0x11 (CPU_CYCLES).
>>>>>
>>>>>
>>>>> +1.4 ATTRIBUTE: KVM_ARM_VCPU_PMU_V3_NUM_EVENTS
>>>>> +---------------------------------------------
>>>>> +
>>>>> +:Parameters: in kvm_device_attr.addr the address for the limit of
>>>>> concurrent
>>>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 events is a pointer to an int
>>>>> +
>>>>> +:Returns:
>>>>> +
>>>>> +=A0=A0=A0=A0=A0 =3D=3D=3D=3D=3D=3D=3D=A0 =3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>>> +=A0=A0=A0=A0=A0 -ENODEV: PMUv3 not supported
>>>>> +=A0=A0=A0=A0=A0 -EBUSY:=A0 PMUv3 already initialized
>>>>> +=A0=A0=A0=A0=A0 -EINVAL: Too large number of events
>>>>> +=A0=A0=A0=A0=A0 =3D=3D=3D=3D=3D=3D=3D=A0 =3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>>> +
>>>>> +Reconfigure the limit of concurrent PMU events that the guest can
>>>>> monitor.
>>>>> +This number is directly exposed as part of the PMCR_EL0 register.
>>>>> +
>>>>> +On vcpu creation, this attribute is set to the hardware limit of the
>>>>> current
>>>>> +platform. If you need to determine the hardware limit, you can read
>>>>> this
>>>>> +attribute before setting it.
>>>>> +
>>>>> +Restrictions: The default value for this property is the number of
>>>>> hardware
>>>>> +supported events. Only values that are smaller than the hardware =

>>>>> limit
>>>>> can
>>>>> +be set.
>>>>> +
>>>>> =A02. GROUP: KVM_ARM_VCPU_TIMER_CTRL
>>>>> =A0=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>>>
>>>>> diff --git a/arch/arm64/include/uapi/asm/kvm.h
>>>>> b/arch/arm64/include/uapi/asm/kvm.h
>>>>> index 7b1511d6ce44..db025c0b5a40 100644
>>>>> --- a/arch/arm64/include/uapi/asm/kvm.h
>>>>> +++ b/arch/arm64/include/uapi/asm/kvm.h
>>>>> @@ -342,9 +342,10 @@ struct kvm_vcpu_events {
>>>>>
>>>>> =A0/* Device Control API on vcpu fd */
>>>>> =A0#define KVM_ARM_VCPU_PMU_V3_CTRL=A0=A0=A0=A0 0
>>>>> -#define=A0=A0 KVM_ARM_VCPU_PMU_V3_IRQ=A0=A0=A0 0
>>>>> -#define=A0=A0 KVM_ARM_VCPU_PMU_V3_INIT=A0=A0 1
>>>>> -#define=A0=A0 KVM_ARM_VCPU_PMU_V3_FILTER 2
>>>>> +#define=A0=A0 KVM_ARM_VCPU_PMU_V3_IRQ=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 0
>>>>> +#define=A0=A0 KVM_ARM_VCPU_PMU_V3_INIT=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 1
>>>>> +#define=A0=A0 KVM_ARM_VCPU_PMU_V3_FILTER=A0=A0=A0=A0=A0=A0=A0=A0 2
>>>>> +#define=A0=A0 KVM_ARM_VCPU_PMU_V3_NUM_EVENTS=A0=A0=A0=A0 3
>>>>> =A0#define KVM_ARM_VCPU_TIMER_CTRL=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 1
>>>>> =A0#define=A0=A0 KVM_ARM_VCPU_TIMER_IRQ_VTIMER=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 0
>>>>> =A0#define=A0=A0 KVM_ARM_VCPU_TIMER_IRQ_PTIMER=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 1
>>>>> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
>>>>> index 0458860bade2..c7915b95fec0 100644
>>>>> --- a/arch/arm64/kvm/pmu-emul.c
>>>>> +++ b/arch/arm64/kvm/pmu-emul.c
>>>>> @@ -253,6 +253,8 @@ void kvm_pmu_vcpu_init(struct kvm_vcpu *vcpu)
>>>>>
>>>>> =A0=A0=A0=A0=A0 for (i =3D 0; i < ARMV8_PMU_MAX_COUNTERS; i++)
>>>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pmu->pmc[i].idx =3D i;
>>>>> +
>>>>> +=A0=A0=A0=A0 pmu->num_events =3D perf_num_counters() - 1;
>>>>> =A0}
>>>>>
>>>>> =A0/**
>>>>> @@ -978,6 +980,25 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu
>>>>> *vcpu, struct kvm_device_attr *attr)
>>>>>
>>>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 0;
>>>>> =A0=A0=A0=A0=A0 }
>>>>> +=A0=A0=A0=A0 case KVM_ARM_VCPU_PMU_V3_NUM_EVENTS: {
>>>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u64 mask =3D ARMV8_PMU_PMCR_N_M=
ASK <<
>>>>> ARMV8_PMU_PMCR_N_SHIFT;
>>>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 int __user *uaddr =3D (int __us=
er *)(long)attr->addr;
>>>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u32 num_events;
>>>>> +
>>>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (get_user(num_events, uaddr))
>>>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return =
-EFAULT;
>>>>> +
>>>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (num_events >=3D perf_num_co=
unters())
>>>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return =
-EINVAL;
>>>>> +
>>>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 vcpu->arch.pmu.num_events =3D n=
um_events;
>>>>> +
>>>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 num_events <<=3D ARMV8_PMU_PMCR=
_N_SHIFT;
>>>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 __vcpu_sys_reg(vcpu, SYS_PMCR_E=
L0) &=3D ~mask;
>>>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 __vcpu_sys_reg(vcpu, SYS_PMCR_E=
L0) |=3D num_events;
>>>>> +
>>>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 0;
>>>>> +=A0=A0=A0=A0 }
>>>>> =A0=A0=A0=A0=A0 case KVM_ARM_VCPU_PMU_V3_INIT:
>>>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return kvm_arm_pmu_v3_init(vc=
pu);
>>>>> =A0=A0=A0=A0=A0 }
>>>>> @@ -1004,6 +1025,16 @@ int kvm_arm_pmu_v3_get_attr(struct kvm_vcpu
>>>>> *vcpu, struct kvm_device_attr *attr)
>>>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 irq =3D vcpu->arch.pmu.irq_nu=
m;
>>>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return put_user(irq, uaddr);
>>>>> =A0=A0=A0=A0=A0 }
>>>>> +=A0=A0=A0=A0 case KVM_ARM_VCPU_PMU_V3_NUM_EVENTS: {
>>>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 int __user *uaddr =3D (int __us=
er *)(long)attr->addr;
>>>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u32 num_events;
>>>>> +
>>>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!test_bit(KVM_ARM_VCPU_PMU_=
V3, vcpu->arch.features))
>>>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return =
-ENODEV;
>>>>> +
>>>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 num_events =3D vcpu->arch.pmu.n=
um_events;
>>>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return put_user(num_events, uad=
dr);
>>>>> +=A0=A0=A0=A0 }
>>>>> =A0=A0=A0=A0=A0 }
>>>>>
>>>>> =A0=A0=A0=A0=A0 return -ENXIO;
>>>>> @@ -1015,6 +1046,7 @@ int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu
>>>>> *vcpu, struct kvm_device_attr *attr)
>>>>> =A0=A0=A0=A0=A0 case KVM_ARM_VCPU_PMU_V3_IRQ:
>>>>> =A0=A0=A0=A0=A0 case KVM_ARM_VCPU_PMU_V3_INIT:
>>>>> =A0=A0=A0=A0=A0 case KVM_ARM_VCPU_PMU_V3_FILTER:
>>>>> +=A0=A0=A0=A0 case KVM_ARM_VCPU_PMU_V3_NUM_EVENTS:
>>>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (kvm_arm_support_pmu_v3() =
&&
>>>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 test_bit(KVM_ARM_=
VCPU_PMU_V3, vcpu->arch.features))
>>>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 retur=
n 0;
>>>>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>>>>> index 20ab2a7d37ca..d51e39600bbd 100644
>>>>> --- a/arch/arm64/kvm/sys_regs.c
>>>>> +++ b/arch/arm64/kvm/sys_regs.c
>>>>> @@ -672,6 +672,11 @@ static void reset_pmcr(struct kvm_vcpu *vcpu,
>>>>> const struct sys_reg_desc *r)
>>>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | (ARMV8_PMU_PMCR_MASK & 0xdecaf=
bad)) &
>>>>> (~ARMV8_PMU_PMCR_E);
>>>>> =A0=A0=A0=A0=A0 if (!system_supports_32bit_el0())
>>>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 val |=3D ARMV8_PMU_PMCR_LC;
>>>>> +
>>>>> +=A0=A0=A0=A0 /* Override number of event selectors */
>>>>> +=A0=A0=A0=A0 val &=3D ~(ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SH=
IFT);
>>>>> +=A0=A0=A0=A0 val |=3D (u32)vcpu->arch.pmu.num_events << ARMV8_PMU_PM=
CR_N_SHIFT;
>>>>> +
>>>>> =A0=A0=A0=A0=A0 __vcpu_sys_reg(vcpu, r->reg) =3D val;
>>>>> =A0}
>>>>>
>>>>> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
>>>>> index 98cbfe885a53..ea3fc96a37d9 100644
>>>>> --- a/include/kvm/arm_pmu.h
>>>>> +++ b/include/kvm/arm_pmu.h
>>>>> @@ -27,6 +27,7 @@ struct kvm_pmu {
>>>>> =A0=A0=A0=A0=A0 bool ready;
>>>>> =A0=A0=A0=A0=A0 bool created;
>>>>> =A0=A0=A0=A0=A0 bool irq_level;
>>>>> +=A0=A0=A0=A0 u8 num_events;
>>>>> =A0};
>>>>>
>>>>> =A0#define kvm_arm_pmu_v3_ready(v)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 ((v)->arch.pmu.ready)
>>>>
>>>> I see several problems with this approach:
>>>>
>>>> - userspace doesn't really have a good way to retrieve the number of
>>>> =A0=A0 counters.
>>> It does with v2, because it can then just read the register ;). I agree
>>> that it's clunky though.
>>>
>>>>
>>>> - Limiting the number of counters for the guest doesn't mean anything
>>>> =A0=A0 when it comes to the actual use of the HW counters, given that =
we
>>>> =A0=A0 don't allocate them ourselves (it's all perf doing the actual w=
ork).
>>>
>>> We do cap the number of actively requestable counters via perf by the
>>> PMCR.N limit. So in a way, it does mean something.
>>>
>>>> - If you want to "pin" counters for the host, why don't you just do
>>>> =A0=A0 that before starting the guest?
>>>
>>> You can do that. Imagine I have 10 counters. I pin 4 of them to the
>>> host. I still tell my guest that it can use 6. That means perf will then
>>> time slice and juggle 10 guest event counters on those remaining 6
>>> hardware counters. That juggling heavily reduces accuracy.
>>>
>>>> I think you need to look at the bigger picture: how to limit the use
>>>> of physical counter usage for a given userspace task. This needs
>>>> to happen in perf itself, and not in KVM.
>>>
>>> That's definitely another way to look at it that I agree with.
>>>
>>> What we really want is to expose the number of counters the guest has
>>> available, not the number of counters hardware can support at maximum.
>>>
>>> So in theory it would be enough to ask perf how many counters it does
>>> have free for me to consume without overcommitting. But that would
>>> potentially change between multiple invocations of KVM and thus break
>>> things like live migration, no?
>>>
>>> Maybe what we really want is an interface to perf from user space to say
>>> "how many counters can you dedicate to me?" and "reserve them for me".
>>> Then user space could reserve them as dedicated counters and KVM would
>>> just need to either probe for the reservation or get told by user space
>>> what to expose via ONE_REG as Drew suggested. It'd be up to user space
>>> to ensure that the reservation matches the number of exposed counters =

>>> then.
>>
>> Note that if the aim is to avoid the guest seeing unexpectedly weird
>> behaviour, then it's not just the *number* of counters that matters, but
>> the underlying physical allocation too, thanks to the possibility of
>> chained events.
> =

> Wouldn't ideally guest chaining propagate into host chaining as well? =

> I'd have to double check if it does, but in my naive thinking if I =

> reserve 4 hardware counters for the guest and the guest ends up using 4 =

> hardware counters regardless of their chaining attributes, I'd still be =

> able to fit them all?

It depends what you mean by "reserve" - if you merely tell the guest =

that the vPMU only has 4 counters, and at any given time your (n-4) host =

events happen to have ended up scheduled such that no physical even/odd =

pair of counters is free, then even a single chained event from the =

guest might trigger context rotation despite there being 4 or more =

counters free in total.

If you want truly deterministic results then you'll probably need some =

brain surgery on the PMU driver to actually partition the physical =

counters rather than simply relying on perf's scheduling.

Robin.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

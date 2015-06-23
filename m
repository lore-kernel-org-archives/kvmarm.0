From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [RFC 0/6] KVM: arm/arm64: gsi routing support
Date: Tue, 23 Jun 2015 14:53:56 +0200
Message-ID: <558956E4.2050700@linaro.org>
References: <1434649258-27065-1-git-send-email-eric.auger@linaro.org>
 <5587CA18.6050101@arm.com> <5587D398.8040002@linaro.org>
 <558920F7.9090301@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B14695656F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Jun 2015 08:43:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id g4tfNan1nP5t for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Jun 2015 08:43:23 -0400 (EDT)
Received: from mail-wi0-f176.google.com (mail-wi0-f176.google.com
 [209.85.212.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 35C985655E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Jun 2015 08:43:22 -0400 (EDT)
Received: by wicnd19 with SMTP id nd19so105232721wic.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Jun 2015 05:54:16 -0700 (PDT)
In-Reply-To: <558920F7.9090301@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>, "eric.auger@st.com" <eric.auger@st.com>, "p.fedin@samsung.com" <p.fedin@samsung.com>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Andre,
On 06/23/2015 11:03 AM, Andre Przywara wrote:
> Hi Eric,
> 
> I went back reading the code and looked at how the x86 APIC works more
> closely to understand the GSI routing better.
> See below for more ...
> 
> On 22/06/15 10:21, Eric Auger wrote:
>> On 06/22/2015 10:40 AM, Andre Przywara wrote:
>>> Hi Eric,
>>>
>>> I briefly looked over the series, the patches itself look good overall.
>>> I have one or two comments on the actual code, but want to discuss the
>>> general approach first (more a dump of some first thoughts):
>>>
>>> On 18/06/15 18:40, Eric Auger wrote:
>>>> With the advent of GICv3 ITS in-kernel emulation, KVM GSI routing
>>>> appears to be requested. More specifically MSI routing is needed.
>>>> irqchip routing does not sound to be really useful on arm but usage of
>>>> MSI routing also mandates to integrate irqchip routing. The initial
>>>> implementation of irqfd on arm must be upgraded with the integration
>>>> of kvm irqchip.c code and the implementation of its standard hooks
>>>> in the architecture specific part.
>>>>
>>>> The series therefore allows and mandates the usage of KVM_SET_GSI_ROUTING
>>>> ioctl along with KVM_IRQFD. If the userspace does not define any routing
>>>> table, no irqfd injection can happen. The user-space can use
>>>> KVM_CAP_IRQ_ROUTING to detect whether a routing table is needed.
>>>>
>>>> for irqchip routing, the convention is, only SPI can be injected and the
>>>> SPI ID corresponds to irqchip.pin + 32. For MSI routing the interrupt ID
>>>> matches the MSI msg data. API evolve to support associating a device ID
>>>> to a routine entry.
>>>
>>> So if I get this right, in a guest ITS case we have now three different
>>> IRQ name spaces:
>>> a) the LPI number, which is guest internal. The ITS driver in the guest
>>> maintains it. We can track assignments and changes when handling the
>>> MAPVI command in the host kernel, but this would stay in the kernel, as
>>> I don't see an efficient way of propagating this to userland.
>>> b) the GSI number, which is used in communication between userland and
>>> the host kernel. The guest kernel does not know about this at all. Also
>>> the ioctl requires us to set the routing for _all_ GSIs, and I read it
>>> that it assumes starting at GSI 0.
>> all injected GSI must effectively have a routing entry in KVM. Starting
>> at 0 that's not requested. At qemu level there's just the constaint gsi
>> fits between [0, max route number].
> 
> Yeah, you are right, I somehow missed that each routing entry has a gsi
> field in it. So we have to allocate all of them at once with one ioctl,
> but they can be sparse.
> 
>>  So we cannot even pretend to have
>>> LPIs here, because we would need at least 8192 empty entries then, not
>>> to speak of the possibly sparse allocation above. So we have a
>>> completely distinct name space here.
>> What is done currently at qemu level for other archs -  if I understand
>> it correctly -  is there is static GSI routing for standard IRQ. For MSI
>> irqfd setup they use spare gsi number not yet used for GSI routing < max
>> route number. So this is sparse for MSI but not for standard IRQs.
>> Effectively we do not plan to have GSI routing for LPIs but only MSI
>> routing.
> 
> That seems to make sense to me. Since we already limit the number of
> SPIs to something sensible with our KVM_DEV_ARM_VGIC_GRP_NR_IRQS, we
> could infer an implicit direct routing for those SPIs. KVM could check
> the IRQ number against vgic.nr_irqs to see whether an IRQ is routed or not.
> Any GSI beyond that number would be an MSI with your enhanced DevID:EvID
> pair in it, which gets injected via the ITS emulation code (or the
> respective GICv2m code).
> 
> That would be the idea, but if it turns out that not routing SPIs but
> only MSIs requires too many changes to the (core) KVM code (haven't
> looked yet), we could require routing entries for SPIs as well.
Well you were right ;-) I forgot the fact KVM_SET_GSI_ROUTING overwrites
the existing routing table with new user-space provided entries and it's
not possible to keep any hidden irqchip routing entries in place without
the user-space being aware of them.

What I can simply do is preventing any non identity mapping for irqchip
routing entries, ie. gsi != irqchip.pin. This fixes the problem of
KVM_IRQ_LINE. This check can happen in arm kvm_set_routing_entry() and
that's it.

Best Regards

Eric
> After all that's what for instance kvmtool sets up for x86, creating
> default 1:1 mappings for ISA and low PIC IRQs and allocating MSIs on
> demand after that.
> 
>>> c) The DevID:EvID pair, which actually identifies an IRQ in all the
>>> three regimes and is the only authoritative ID.
>>>
>>> So that means we need to maintain the connection between all the three,
>>> somehow duplicating the whole ITS mapping again to map GSIs to DevID:EvID.
>> Currently the KVM routing table indeed stores GSI/DevID:EvID mapping.
>>>
>>> So I wonder if we could use DevID:EvID directly.
>>> The KVM_IRQFD ioctl struct has some space, so we could put the DevID
>>> into the pad area.
>>> Also (more forward-looking) KVM_CAP_ASSIGN_DEV_IRQ identifies guest IRQs
>>> by an u32, but again there is quite some padding area available.
> 
>> ASSIGN_DEV_IRQ is a deprecated feature. We should not use that API I think.
> 
> OK, so do we have other users of the GSI routing beside IRQFD then?
> 
> I will go ahead and try to implement some code matching Eric's patches
> in kvmtool to test the GSI routing.
> 
> Eric, how did you test the irqchip routing on the Midway?
> 
> Cheers,
> Andre.
> 
>> Eric
>>>
>>> In general I am a bit reluctant to introduce just another level of
>>> complexity to the already quite convoluted way of doing IRQs and MSIs on
>>> ARM(64), that's why I will investigate if we can use DevID:EvID to refer
>>> to an interrupt.
>>>
>>> So far,
>>> Andre.
>>>
>>>>
>>>> Known Issues of this RFC:
>>>>
>>>> - One of the biggest is the API inconsistencies on ARM. Blame me.
>>>>   Routing should apply to KVM_IRQ_LINE ioctl which is not the case yet
>>>>   in this series. It only applies to irqfd.
>>>>   on x86 typically this KVM_IRQ_LINE is plugged onto irqchip.c kvm_set_irq
>>>>   whereas on ARM we inject directly through kvm_vgic_inject_irq
>>>>   x on arm/arm64 gsi has a specific structure:
>>>>     bits:  | 31 ... 24 | 23  ... 16 | 15    ...    0 |
>>>>     field: | irq_type  | vcpu_index |     irq_id     |
>>>>     where irq_id matches the Interrupt ID
>>>> - for KVM_IRQFD without routing (current implementation) the gsi field
>>>>   corresponds to an SPI index = irq_id (above) -32.
>>>> - as far as understand qemu integration, gsi is supposed to be within
>>>>   [0, KVM_MAX_IRQ_ROUTES]. Difficult to use KVM_IRQ_LINE gsi.
>>>> - to be defined what we choose as a convention with irqchip routing is
>>>>   applied: gsi -> irqchip input pin.
>>>> - Or shouldn't we simply rule out any userspace irqchip routing and stick
>>>>   to MSI routing? we could define a fixed identity in-kernel irqchip mapping
>>>>   and only offer MSI routing.
>>>> - static allocation of chip[KVM_NR_IRQCHIPS][KVM_IRQCHIP_NUM_PINS];
>>>>   arbitrary put KVM_IRQCHIP_NUM_PINS = 1020 - 32 (SPI count). On s390
>>>>   this is even bigger.
>>>>
>>>> Currently tested on irqchip routing only (Calxeda midway only),
>>>> ie NOT TESTED on MSI routing yet.
>>>>
>>>> This is a very preliminary RFC to ease the discussion.
>>>>
>>>> Code can be found at https://git.linaro.org/people/eric.auger/linux.git/shortlog/refs/heads/v4.1-rc8-gsi-routing-rfc
>>>>
>>>> It applies on Andre's [PATCH 00/13] arm64: KVM: GICv3 ITS emulation
>>>> (http://www.spinics.net/lists/kvm/msg117402.html)
>>>>
>>>> Eric Auger (6):
>>>>   KVM: api: add kvm_irq_routing_extended_msi
>>>>   KVM: kvm_host: add kvm_extended_msi
>>>>   KVM: irqchip: convey devid to kvm_set_msi
>>>>   KVM: arm/arm64: enable irqchip routing
>>>>   KVM: arm/arm64: enable MSI routing
>>>>   KVM: arm: implement kvm_set_msi by gsi direct mapping
>>>>
>>>>  Documentation/virtual/kvm/api.txt | 20 ++++++--
>>>>  arch/arm/include/asm/kvm_host.h   |  2 +
>>>>  arch/arm/kvm/Kconfig              |  3 ++
>>>>  arch/arm/kvm/Makefile             |  2 +-
>>>>  arch/arm64/include/asm/kvm_host.h |  1 +
>>>>  arch/arm64/kvm/Kconfig            |  2 +
>>>>  arch/arm64/kvm/Makefile           |  2 +-
>>>>  include/kvm/arm_vgic.h            |  9 ----
>>>>  include/linux/kvm_host.h          | 10 ++++
>>>>  include/uapi/linux/kvm.h          |  9 ++++
>>>>  virt/kvm/arm/vgic.c               | 96 +++++++++++++++++++++++++++------------
>>>>  virt/kvm/irqchip.c                | 20 ++++++--
>>>>  12 files changed, 128 insertions(+), 48 deletions(-)
>>>>
>>

From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [RFC 0/6] KVM: arm/arm64: gsi routing support
Date: Mon, 22 Jun 2015 09:40:56 +0100
Message-ID: <5587CA18.6050101@arm.com>
References: <1434649258-27065-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4551755F9E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2015 04:29:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0W1AcG0G2NX5 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Jun 2015 04:29:47 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D1A255DA1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2015 04:29:47 -0400 (EDT)
In-Reply-To: <1434649258-27065-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>, "eric.auger@st.com" <eric.auger@st.com>, "p.fedin@samsung.com" <p.fedin@samsung.com>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Eric,

I briefly looked over the series, the patches itself look good overall.
I have one or two comments on the actual code, but want to discuss the
general approach first (more a dump of some first thoughts):

On 18/06/15 18:40, Eric Auger wrote:
> With the advent of GICv3 ITS in-kernel emulation, KVM GSI routing
> appears to be requested. More specifically MSI routing is needed.
> irqchip routing does not sound to be really useful on arm but usage of
> MSI routing also mandates to integrate irqchip routing. The initial
> implementation of irqfd on arm must be upgraded with the integration
> of kvm irqchip.c code and the implementation of its standard hooks
> in the architecture specific part.
> 
> The series therefore allows and mandates the usage of KVM_SET_GSI_ROUTING
> ioctl along with KVM_IRQFD. If the userspace does not define any routing
> table, no irqfd injection can happen. The user-space can use
> KVM_CAP_IRQ_ROUTING to detect whether a routing table is needed.
> 
> for irqchip routing, the convention is, only SPI can be injected and the
> SPI ID corresponds to irqchip.pin + 32. For MSI routing the interrupt ID
> matches the MSI msg data. API evolve to support associating a device ID
> to a routine entry.

So if I get this right, in a guest ITS case we have now three different
IRQ name spaces:
a) the LPI number, which is guest internal. The ITS driver in the guest
maintains it. We can track assignments and changes when handling the
MAPVI command in the host kernel, but this would stay in the kernel, as
I don't see an efficient way of propagating this to userland.
b) the GSI number, which is used in communication between userland and
the host kernel. The guest kernel does not know about this at all. Also
the ioctl requires us to set the routing for _all_ GSIs, and I read it
that it assumes starting at GSI 0. So we cannot even pretend to have
LPIs here, because we would need at least 8192 empty entries then, not
to speak of the possibly sparse allocation above. So we have a
completely distinct name space here.
c) The DevID:EvID pair, which actually identifies an IRQ in all the
three regimes and is the only authoritative ID.

So that means we need to maintain the connection between all the three,
somehow duplicating the whole ITS mapping again to map GSIs to DevID:EvID.

So I wonder if we could use DevID:EvID directly.
The KVM_IRQFD ioctl struct has some space, so we could put the DevID
into the pad area.
Also (more forward-looking) KVM_CAP_ASSIGN_DEV_IRQ identifies guest IRQs
by an u32, but again there is quite some padding area available.

In general I am a bit reluctant to introduce just another level of
complexity to the already quite convoluted way of doing IRQs and MSIs on
ARM(64), that's why I will investigate if we can use DevID:EvID to refer
to an interrupt.

So far,
Andre.

> 
> Known Issues of this RFC:
> 
> - One of the biggest is the API inconsistencies on ARM. Blame me.
>   Routing should apply to KVM_IRQ_LINE ioctl which is not the case yet
>   in this series. It only applies to irqfd.
>   on x86 typically this KVM_IRQ_LINE is plugged onto irqchip.c kvm_set_irq
>   whereas on ARM we inject directly through kvm_vgic_inject_irq
>   x on arm/arm64 gsi has a specific structure:
>     bits:  | 31 ... 24 | 23  ... 16 | 15    ...    0 |
>     field: | irq_type  | vcpu_index |     irq_id     |
>     where irq_id matches the Interrupt ID
> - for KVM_IRQFD without routing (current implementation) the gsi field
>   corresponds to an SPI index = irq_id (above) -32.
> - as far as understand qemu integration, gsi is supposed to be within
>   [0, KVM_MAX_IRQ_ROUTES]. Difficult to use KVM_IRQ_LINE gsi.
> - to be defined what we choose as a convention with irqchip routing is
>   applied: gsi -> irqchip input pin.
> - Or shouldn't we simply rule out any userspace irqchip routing and stick
>   to MSI routing? we could define a fixed identity in-kernel irqchip mapping
>   and only offer MSI routing.
> - static allocation of chip[KVM_NR_IRQCHIPS][KVM_IRQCHIP_NUM_PINS];
>   arbitrary put KVM_IRQCHIP_NUM_PINS = 1020 - 32 (SPI count). On s390
>   this is even bigger.
> 
> Currently tested on irqchip routing only (Calxeda midway only),
> ie NOT TESTED on MSI routing yet.
> 
> This is a very preliminary RFC to ease the discussion.
> 
> Code can be found at https://git.linaro.org/people/eric.auger/linux.git/shortlog/refs/heads/v4.1-rc8-gsi-routing-rfc
> 
> It applies on Andre's [PATCH 00/13] arm64: KVM: GICv3 ITS emulation
> (http://www.spinics.net/lists/kvm/msg117402.html)
> 
> Eric Auger (6):
>   KVM: api: add kvm_irq_routing_extended_msi
>   KVM: kvm_host: add kvm_extended_msi
>   KVM: irqchip: convey devid to kvm_set_msi
>   KVM: arm/arm64: enable irqchip routing
>   KVM: arm/arm64: enable MSI routing
>   KVM: arm: implement kvm_set_msi by gsi direct mapping
> 
>  Documentation/virtual/kvm/api.txt | 20 ++++++--
>  arch/arm/include/asm/kvm_host.h   |  2 +
>  arch/arm/kvm/Kconfig              |  3 ++
>  arch/arm/kvm/Makefile             |  2 +-
>  arch/arm64/include/asm/kvm_host.h |  1 +
>  arch/arm64/kvm/Kconfig            |  2 +
>  arch/arm64/kvm/Makefile           |  2 +-
>  include/kvm/arm_vgic.h            |  9 ----
>  include/linux/kvm_host.h          | 10 ++++
>  include/uapi/linux/kvm.h          |  9 ++++
>  virt/kvm/arm/vgic.c               | 96 +++++++++++++++++++++++++++------------
>  virt/kvm/irqchip.c                | 20 ++++++--
>  12 files changed, 128 insertions(+), 48 deletions(-)
> 

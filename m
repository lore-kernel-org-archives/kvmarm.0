From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC 0/6] KVM: arm/arm64: gsi routing support
Date: Thu, 18 Jun 2015 19:40:52 +0200
Message-ID: <1434649258-27065-1-git-send-email-eric.auger@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, andre.przywara@arm.com, p.fedin@samsung.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

With the advent of GICv3 ITS in-kernel emulation, KVM GSI routing
appears to be requested. More specifically MSI routing is needed.
irqchip routing does not sound to be really useful on arm but usage of
MSI routing also mandates to integrate irqchip routing. The initial
implementation of irqfd on arm must be upgraded with the integration
of kvm irqchip.c code and the implementation of its standard hooks
in the architecture specific part.

The series therefore allows and mandates the usage of KVM_SET_GSI_ROUTING
ioctl along with KVM_IRQFD. If the userspace does not define any routing
table, no irqfd injection can happen. The user-space can use
KVM_CAP_IRQ_ROUTING to detect whether a routing table is needed.

for irqchip routing, the convention is, only SPI can be injected and the
SPI ID corresponds to irqchip.pin + 32. For MSI routing the interrupt ID
matches the MSI msg data. API evolve to support associating a device ID
to a routine entry.

Known Issues of this RFC:

- One of the biggest is the API inconsistencies on ARM. Blame me.
  Routing should apply to KVM_IRQ_LINE ioctl which is not the case yet
  in this series. It only applies to irqfd.
  on x86 typically this KVM_IRQ_LINE is plugged onto irqchip.c kvm_set_irq
  whereas on ARM we inject directly through kvm_vgic_inject_irq
  x on arm/arm64 gsi has a specific structure:
    bits:  | 31 ... 24 | 23  ... 16 | 15    ...    0 |
    field: | irq_type  | vcpu_index |     irq_id     |
    where irq_id matches the Interrupt ID
- for KVM_IRQFD without routing (current implementation) the gsi field
  corresponds to an SPI index = irq_id (above) -32.
- as far as understand qemu integration, gsi is supposed to be within
  [0, KVM_MAX_IRQ_ROUTES]. Difficult to use KVM_IRQ_LINE gsi.
- to be defined what we choose as a convention with irqchip routing is
  applied: gsi -> irqchip input pin.
- Or shouldn't we simply rule out any userspace irqchip routing and stick
  to MSI routing? we could define a fixed identity in-kernel irqchip mapping
  and only offer MSI routing.
- static allocation of chip[KVM_NR_IRQCHIPS][KVM_IRQCHIP_NUM_PINS];
  arbitrary put KVM_IRQCHIP_NUM_PINS = 1020 - 32 (SPI count). On s390
  this is even bigger.

Currently tested on irqchip routing only (Calxeda midway only),
ie NOT TESTED on MSI routing yet.

This is a very preliminary RFC to ease the discussion.

Code can be found at https://git.linaro.org/people/eric.auger/linux.git/shortlog/refs/heads/v4.1-rc8-gsi-routing-rfc

It applies on Andre's [PATCH 00/13] arm64: KVM: GICv3 ITS emulation
(http://www.spinics.net/lists/kvm/msg117402.html)

Eric Auger (6):
  KVM: api: add kvm_irq_routing_extended_msi
  KVM: kvm_host: add kvm_extended_msi
  KVM: irqchip: convey devid to kvm_set_msi
  KVM: arm/arm64: enable irqchip routing
  KVM: arm/arm64: enable MSI routing
  KVM: arm: implement kvm_set_msi by gsi direct mapping

 Documentation/virtual/kvm/api.txt | 20 ++++++--
 arch/arm/include/asm/kvm_host.h   |  2 +
 arch/arm/kvm/Kconfig              |  3 ++
 arch/arm/kvm/Makefile             |  2 +-
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/Kconfig            |  2 +
 arch/arm64/kvm/Makefile           |  2 +-
 include/kvm/arm_vgic.h            |  9 ----
 include/linux/kvm_host.h          | 10 ++++
 include/uapi/linux/kvm.h          |  9 ++++
 virt/kvm/arm/vgic.c               | 96 +++++++++++++++++++++++++++------------
 virt/kvm/irqchip.c                | 20 ++++++--
 12 files changed, 128 insertions(+), 48 deletions(-)

-- 
1.9.1


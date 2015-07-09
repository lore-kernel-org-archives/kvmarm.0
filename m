From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v2 0/7] KVM: arm/arm64: gsi routing support
Date: Thu,  9 Jul 2015 10:22:10 +0200
Message-ID: <1436430137-24205-1-git-send-email-eric.auger@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: eric.auger@st.com, eric.auger@linaro.org, linux-arm-kernel@lists.infradead.org, marc.zyngier@arm.com, christoffer.dall@linaro.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: patches@linaro.org, andre.przywara@arm.com, p.fedin@samsung.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

With the advent of GICv3 ITS in-kernel emulation, KVM GSI routing
appears to be requested. More specifically MSI routing is needed.
irqchip routing does not sound to be really useful on arm but usage of
MSI routing also mandates to integrate irqchip routing. The initial
implementation of irqfd on arm must be upgraded with the integration
of kvm irqchip.c code and the implementation of its standard hooks
in the architecture specific part.

In case KVM_SET_GSI_ROUTING ioctl is not called, a default routing
table with flat irqchip routing entries is built enabling to inject gsi
corresponding to the SPI indexes seen by the guest.

As soon as KVM_SET_GSI_ROUTING is called, user-space overwrites this
default routing table and is responsible for building the whole routing
table.

for arm/arm64 KVM_SET_GSI_ROUTING has a limited support:
- only applies to KVM_IRQFD and not to KVM_IRQ_LINE

- irqchip routing was tested on Calxeda midway (VFIO with irqfd)
  with and without explicit routing
- MSI routing without GICv3 ITS was tested using APM Xgene-I
  (qemu VIRTIO-PCI vhost net without gsi_direct_mapping).
- MSI routing with GICv3 ITS is *NOT* tested.

Code can be found at https://git.linaro.org/people/eric.auger/linux.git/shortlog/refs/heads/v4.2-rc1-gsi-routing-v2

It applies on Andre's [PATCH 00/13] arm64: KVM: GICv3 ITS emulation
(http://www.spinics.net/lists/kvm/msg117402.html)

History:

v1 -> v2:
- user API changed:
  x devid id passed in kvm_irq_routing_msi
  x kept the new routing entry type: KVM_IRQ_ROUTING_EXTENDED_MSI
- kvm_host.h: adopt Andre's proposal to replace the msi_msg by a struct
  composed of the msi_msg and devid in kvm_kernel_irq_routing_entry
- Fix bug reported by Pavel: Added KVM_IRQ_ROUTING_EXTENDED_MSI handling
  in eventfd.c
- added vgic_v2m_inject_msi in vgic-v2-emul.c as suggested by Andre
- fix bug reported by Andre: bad setting of msi.flags and msi.devid
  in kvm_send_userspace_msi
- avoid injecting reserved IRQ numbers in vgic_irqfd_set_irq

RFC -> PATCH:
- clearly state limited support on arm/arm64:
  KVM_IRQ_LINE not impacted by GSI routing
- add default routing table feature (new patch file)
- changed uapi to use padding field area
- reword api.txt

Eric Auger (7):
  KVM: api: introduce KVM_IRQ_ROUTING_EXTENDED_MSI
  KVM: kvm_host: add devid in kvm_kernel_irq_routing_entry
  KVM: irqchip: convey devid to kvm_set_msi
  KVM: arm/arm64: enable irqchip routing
  KVM: arm/arm64: build a default routing table
  KVM: arm/arm64: enable MSI routing
  KVM: arm: implement kvm_set_msi by gsi direct mapping

 Documentation/virtual/kvm/api.txt |  32 ++++++++++--
 arch/arm/include/asm/kvm_host.h   |   2 +
 arch/arm/kvm/Kconfig              |   3 ++
 arch/arm/kvm/Makefile             |   2 +-
 arch/arm64/include/asm/kvm_host.h |   1 +
 arch/arm64/kvm/Kconfig            |   2 +
 arch/arm64/kvm/Makefile           |   2 +-
 include/kvm/arm_vgic.h            |   9 ----
 include/linux/kvm_host.h          |   7 ++-
 include/uapi/linux/kvm.h          |   6 ++-
 virt/kvm/arm/vgic-v2-emul.c       |  12 +++++
 virt/kvm/arm/vgic.c               | 101 +++++++++++++++++++++++++++++---------
 virt/kvm/eventfd.c                |   6 ++-
 virt/kvm/irqchip.c                |  12 ++++-
 14 files changed, 153 insertions(+), 44 deletions(-)

-- 
1.9.1


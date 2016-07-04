From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC v5 0/6] KVM: arm/arm64: gsi routing support
Date: Mon,  4 Jul 2016 17:12:39 +0000
Message-ID: <1467652365-4921-1-git-send-email-eric.auger@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: eric.auger@redhat.com, eric.auger.pro@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: drjones@redhat.com, andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

With the advent of GICv3 ITS in-kernel emulation, KVM MSI routing
becomes mandated for proper VIRTIO-PCI vhost integration.

In QEMU, when the VIRTIO-PCI device is programmed with the MSI message,
we previously used direct_mapping trick: this consists in extracting the
IRQ ID found in the MSI message and associating an irqfd to that IRQ ID.
When vhost worker thread gets a new buffer it signals the irqfd and kvm
then injects this IRQ ID on guest. That way although the guest uses MSIs,
no MSI emulation is used.

This worked fine with GICv2m but does not work anymore with GICV3 ITS.
Indeed this latter implements IRQ translation: what is found in the MSI
message no more is the target IRQ ID but is an intermediate event ID used
in the translation process.

Hence true MSI routing is needed so that the vhost back channel irqfd is
associated to a dummy gsi ID, routed towards the programmed MSI. When KVM
injects the MSI through the in-kernel ITS emulation, the MSI is properly
translated and eventually the LPI ID associated to the event ID is injected
on guest.

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
- MSI routing without GICv3 ITS was tested on AMD Overdrive
  (qemu VIRTIO-PCI vhost-net without gsi_direct_mapping).
- MSI routing with GICv3 ITS is *NOT* tested.

Code can be found at https:
https://github.com/eauger/linux/tree/v4.7-rc6-its-emul-v7-gsi-routing-v5

The series depends on

[1]: [PATCH v7 00/12] KVM: arm64: GICv3 ITS emulation
     http://www.spinics.net/lists/kvm/msg134737.html

hence the RFC.

GSI flat routing setup on QEMU can be found at:
https://lists.nongnu.org/archive/html/qemu-devel/2015-07/msg06262.html

History:
V4 -> v5:
- rebase on Andre's v7 + final new vgic code
- check msi->data is within SPI range in vgic_v2m_inject_msi
- squashed enable irq routing and default irqchip table patches
- handle default irqchip table allocation failure
- some rephrasing in doc & comment according to Christoffer's feedbacks
- lock issue reported by Pavel seems to have disappear after 4.2 (MSI injection
  fast path)

v3 -> v4:
- rebase on top of NEW-VGIC RFC and ITS emulation series v4. This is not
  a stable foundation yet. Hence the revert to RFC. This v4 mostly is a
  reflesh/reminder.
- rewrite the cover letter

v2 -> v3:
- don't use KVM_IRQ_ROUTING_EXTENDED_MSI type at uapi and kernel level anymore;
  use KVM_MSI_VALID_DEVID flag instead
- propagate user flags downto the kernel to make sure the userspace
  correctly set devid in GICv3 ITS case (still under discussion)

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

Eric Auger (6):
  KVM: api: pass the devid in the msi routing entry
  KVM: kvm_host: add devid in kvm_kernel_irq_routing_entry
  KVM: irqchip: convey devid to kvm_set_msi
  KVM: arm/arm64: enable irqchip routing
  KVM: arm/arm64: enable MSI routing
  KVM: arm: enable KVM_SIGNAL_MSI and MSI routing

 Documentation/virtual/kvm/api.txt | 36 +++++++++++++---
 arch/arm/include/asm/kvm_host.h   |  2 +
 arch/arm/kvm/Kconfig              |  3 ++
 arch/arm/kvm/Makefile             |  1 +
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/Kconfig            |  2 +
 arch/arm64/kvm/Makefile           |  1 +
 include/linux/kvm_host.h          |  8 +++-
 include/uapi/linux/kvm.h          |  5 ++-
 virt/kvm/arm/vgic/vgic-init.c     | 27 ++++++++++++
 virt/kvm/arm/vgic/vgic-irqfd.c    | 90 ++++++++++++++++++++++++++++++---------
 virt/kvm/arm/vgic/vgic-v2.c       | 17 ++++++++
 virt/kvm/arm/vgic/vgic.c          |  7 ---
 virt/kvm/arm/vgic/vgic.h          |  1 +
 virt/kvm/irqchip.c                |  8 +++-
 15 files changed, 173 insertions(+), 36 deletions(-)

-- 
1.9.1


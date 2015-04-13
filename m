From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC v6 00/16] KVM-VFIO IRQ forward control
Date: Mon, 13 Apr 2015 14:29:15 +0200
Message-ID: <1428928171-18884-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EBAF4C3D6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2015 08:24:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id T8ahGkIJ52QY for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Apr 2015 08:24:46 -0400 (EDT)
Received: from mail-wg0-f46.google.com (mail-wg0-f46.google.com [74.125.82.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E1F814C3D1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2015 08:24:45 -0400 (EDT)
Received: by wgsk9 with SMTP id k9so79013690wgs.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2015 05:32:31 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, alex.williamson@redhat.com, pbonzini@redhat.com
Cc: feng.wu@intel.com, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

This series proposes an integration of "ARM: Forwarding physical
interrupts to a guest VM" (http://lwn.net/Articles/603514/) in
KVM.

It enables to set/unset forwarding for a VFIO platform device IRQ.

A forwarded IRQ is deactivated by the guest and not by the host.
When the guest deactivates the associated virtual IRQ, the interrupt
controller automatically completes the physical IRQ. Obviously
this requires some HW support in the interrupt controller. This is
the case for ARM GICv2.

The direct benefit is that, for a level sensitive IRQ, a VM exit
can be avoided on forwarded IRQ completion.

When the IRQ is forwarded, the VFIO platform driver does not need to
mask the physical IRQ anymore before signaling the eventfd. Indeed
genirq lowers the running priority, enabling other physical IRQ to hit
except that one.

Besides, the injection still is based on irqfd triggering. The only
impact on irqfd process is resamplefd is not called anymore on
virtual IRQ completion since deactivation is not trapped by KVM.

The current integration is based on an extension of the KVM-VFIO
device, previously used by KVM to interact with VFIO groups. The
patch series now enables KVM to directly interact with a VFIO
platform device. The VFIO external API was extended for that purpose.

The IRQ forward programming is architecture specific (virtual interrupt
controller programming basically). However the whole infrastructure is
kept generic.

from a user point of view, the functionality is provided through a
new KVM-VFIO group named KVM_DEV_VFIO_DEVICE and 2 associated
attributes:
- KVM_DEV_VFIO_DEVICE_FORWARD_IRQ,
- KVM_DEV_VFIO_DEVICE_UNFORWARD_IRQ.

The capability can be checked with KVM_HAS_DEVICE_ATTR.

Forwarding must be activated when the VFIO IRQ is not active at
physical level or being under injection into the guest (VFIO masked)
Forwarding can be unset at any time.

This patch series has the following dependencies:
- RFC "ARM: Forwarding physical interrupts to a guest VM"
  (http://lwn.net/Articles/603514/)
  Note part of this RFC has not evolved since June 2014. Only below subset
  has progressed.
- [PATCH v4 0/3] genirq: Saving/restoring the irqchip state of an irq line
  http://lkml.iu.edu/hypermail/linux/kernel/1503.2/02462.html
- [RFC v2] chip/vgic adaptations for forwarded irq
  http://lists.infradead.org/pipermail/linux-arm-kernel/2015-February/323183.html

Integrated pieces can be found at:
https://git.linaro.org/people/eric.auger/linux.git/shortlog/refs/heads/4.O_forward_v6

This was tested on Calxeda Midway, assigning the xgmac main IRQ.
Unforward was tested doing periodic forward/unforward with random offsets,
while using netcat traffic to make sure unforward often occurs while the
IRQ is in progress.

v5 -> v6:
Took into account Alex comments:
- vfio
  x introduced vfio_device_external_ops to hold external callbacks:
    mask, is_active, set_automasked
  x their proto now feature index, start, count
  x implementation of vfio_external_[mask, is_active, set_automasked] moved
    to vfio.c. the functions just call bus specific callbacks, currently
    only implemented on vfio_platform side.
- kvm-vfio
  x does not use struct vfio_platform_device handles anymore. Use vfio_device.
  x remove DEBUG flags
  x rename kvm_vfio_platform_get_irq into kvm_vfio_get_hwirq

v4 -> v5:
- fix arm64 compilation issues
  - arch/arm64/include/asm/kvm_host.h now defines
    x __KVM_HAVE_ARCH_KVM_VFIO_FORWARD for arm64
    x __KVM_HAVE_ARCH_HALT_GUEST
    x and features pause renamed into power_off

v3 -> v4:
- revert as RFC again due to lots of changes, extra complexity induced
  by new set/unset_forward implementation, and dependencies on RFC patches
- kvm_vfio_dev_irq struct is used at user level to pass the parameters
  to KVM-VFIO KVM_DEV_VFIO_DEVICE/KVM_DEV_VFIO_DEVICE_UNFORWARD_IRQ. Shared
  with Intel posted IRQs.
- unforward now can happen any time with no constraint and cannot fail
- new VFIO platform external functions introduced:
  vfio_externl_set_automasked, vfio_external_mask, vfio_external_is_active,
- introduce a modality to force guest to exit & prevent it from being
  re-entered and rename older ARM pause modality into power-off
  (related to PSCI power-off start)
- kvm_vfio_arm.c no more exists. architecture specific code is moved into
  arm/gic.c. This code is not that much VFIO dependent anymore. Although
  some references still exit in comments.
- 2 separate architecture specific functions for set and unset (only one
  has a return value).

v2 -> v3:
- kvm_fwd_irq_action enum replaced by a bool (KVM_VFIO_IRQ_CLEANUP does not
  exist anymore)
- a new struct local to vfio.c was introduced to wrap kvm_fw_irq and make it
  linkable: kvm_vfio_fwd_irq_node
- kvm_fwd_irq now is self-contained (includes struct vfio_device *)
- a single list of kvm_vfio_fwd_irq_irq_node is used instead of having
  a list of devices and a list of forward irq per device. Having 2 lists
  brought extra complexity.
- the VFIO device ref counter is incremented each time a new IRQ is forwarded.
  It is not attempted anymore to hold a single reference whatever the number
  of forwarded IRQs.
- subindex added on top of index to be closer to VFIO API
- platform device check moved in the arm specific implementation
- enable the KVM-VFIO device for arm64
- forwarded state change only can happen while the VFIO IRQ handler is not
  set; in other words, when the VFIO IRQ signaling is not set.

v1 -> v2:
- forward control is moved from architecture specific file into generic
  vfio.c module.
  only kvm_arch_set_fwd_state remains architecture specific
- integrate Kim's patch which enables KVM-VFIO for ARM
- fix vgic state bypass in vgic_queue_hwirq
- struct kvm_arch_forwarded_irq moved from arch/arm/include/uapi/asm/kvm.h
  to include/uapi/linux/kvm.h
  also irq_index renamed into index and guest_irq renamed into gsi
- ASSIGN/DEASSIGN renamed into FORWARD/UNFORWARD
- vfio_external_get_base_device renamed into vfio_external_base_device
- vfio_external_get_type removed
- kvm_vfio_external_get_base_device renamed into kvm_vfio_external_base_device
- __KVM_HAVE_ARCH_KVM_VFIO renamed into __KVM_HAVE_ARCH_KVM_VFIO_FORWARD


Eric Auger (15):
  VFIO: platform: test forwarded state when selecting IRQ handler
  VFIO: platform: single handler using function pointer
  KVM: kvm-vfio: User API for IRQ forwarding
  VFIO: external user API for interaction with vfio devices
  VFIO: Introduce vfio_device_external_ops
  VFIO: pci: initialize vfio_device_external_ops
  VFIO: platform: implement vfio_device_external_ops callbacks
  VFIO: add vfio_external_{mask|is_active|set_automasked}
  KVM: kvm-vfio: wrappers to VFIO external API device helpers
  KVM: kvm-vfio: wrappers for
    vfio_external_{mask|is_active|set_automasked}
  KVM: arm: rename pause into power_off
  kvm: introduce kvm_arch_halt_guest and kvm_arch_resume_guest
  kvm: arm/arm64: implement kvm_arch_halt_guest and
    kvm_arch_resume_guest
  KVM: kvm-vfio: generic forwarding control
  KVM: arm/arm64: vgic: forwarding control

Kim Phillips (1):
  KVM: arm/arm64: Enable the KVM-VFIO device

 Documentation/virtual/kvm/devices/vfio.txt    |  34 +-
 arch/arm/include/asm/kvm_host.h               |   7 +-
 arch/arm/kvm/Kconfig                          |   1 +
 arch/arm/kvm/Makefile                         |   2 +-
 arch/arm/kvm/arm.c                            |  38 ++-
 arch/arm/kvm/psci.c                           |  10 +-
 arch/arm64/include/asm/kvm_host.h             |   5 +
 arch/arm64/kvm/Kconfig                        |   1 +
 arch/arm64/kvm/Makefile                       |   2 +-
 drivers/vfio/pci/vfio_pci.c                   |   1 +
 drivers/vfio/platform/vfio_platform_common.c  |   7 +
 drivers/vfio/platform/vfio_platform_irq.c     |  77 ++++-
 drivers/vfio/platform/vfio_platform_private.h |  12 +
 drivers/vfio/vfio.c                           |  63 ++++
 include/linux/kvm_host.h                      |  59 ++++
 include/linux/vfio.h                          |  37 +++
 include/uapi/linux/kvm.h                      |  12 +
 virt/kvm/arm/vgic.c                           | 190 +++++++++++
 virt/kvm/vfio.c                               | 436 +++++++++++++++++++++++++-
 19 files changed, 964 insertions(+), 30 deletions(-)

-- 
1.9.1

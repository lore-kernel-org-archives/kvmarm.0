From: Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH v2 0/6] KVM: arm/arm64: vgic: Virtual interrupt grouping
 support
Date: Wed,  4 Jul 2018 11:38:14 +0200
Message-ID: <1530697100-22419-1-git-send-email-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Eric Auger <eric.auger@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

This small series addresses a peculiarity of the current VGIC
implementation, namely that we don't support interrupt grouping.

KVM either implements a GICv2 without support for the security
extensions, or a GICv3 with DS=1.  For GICv2, on systems without the
security extensions, group 0 interrupts can be configured to be either
signalled as FIQs or as IRQs by the VM, whereas group 1 interrupts are
always IRQs.  For GICv3, with DS=1, group 1 interrupts are always IRQs
and group 0 interrupts are always FIQs, and there is no concept of
secure vs. non-secure group 1 interrupts when DS=1.

We were treating all interrupts on GICv2 as group 0, but yet telling the
guest that they were group 1.  The first patch changes this behavior,
which seems to have no effect on no known guests, but still.

The remaining patches introduce proper interrupt grouping support, along
with MMIO accessors for the VM and userspace to retrieve and set the
which group SGIs, PPIs, and SPIs belong to.  LPIs are always group 1
interrupts as per the architecture, and there is no way to modify this
configuration (no IGROUPR registers for LPIs or equivalent ITS
commands).

Lightly tested on Seattle, TX1, and the foundation model.  I've run a
GICv2 guest on a GICv3 host on the foundation model.  I've tested
migration on Seattle, and as expected, migrating a payload from an older
kernel fails, but migration on same kernel works fine both before and
after this series.  See the last patch for more info.

Applies to v4.18-rc3.

Changes since v1:
 - Bumped implementation revision field in GICD_IIDR along with changes
 - Changed logic in init code to correctly detect vgic emulation type
 - Rebased to v4.18-rc3

Christoffer Dall (6):
  KVM: arm/arm64: vgic: Define GICD_IIDR fields for GICv2 and GIv3
  KVM: arm/arm64: vgic: Keep track of implementation revision
  KVM: arm/arm64: vgic: GICv2 IGROUPR should read as zero
  KVM: arm/arm64: vgic: Add group field to struct irq
  KVM: arm/arm64: vgic: Signal IRQs using their configured group
  KVM: arm/arm64: vgic: Allow configuration of interrupt groups

 include/kvm/arm_vgic.h             |  4 ++++
 include/linux/irqchip/arm-gic-v3.h | 10 ++++++++++
 include/linux/irqchip/arm-gic.h    | 11 +++++++++++
 virt/kvm/arm/vgic/vgic-debug.c     |  8 +++++---
 virt/kvm/arm/vgic/vgic-init.c      | 20 ++++++++++++++++++--
 virt/kvm/arm/vgic/vgic-its.c       |  1 +
 virt/kvm/arm/vgic/vgic-mmio-v2.c   | 19 +++++++++++++++----
 virt/kvm/arm/vgic/vgic-mmio-v3.c   | 20 +++++++++++++++-----
 virt/kvm/arm/vgic/vgic-mmio.c      | 38 ++++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-mmio.h      |  6 ++++++
 virt/kvm/arm/vgic/vgic-v2.c        |  3 +++
 virt/kvm/arm/vgic/vgic-v3.c        |  6 +-----
 12 files changed, 127 insertions(+), 19 deletions(-)

--
2.7.4

IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.

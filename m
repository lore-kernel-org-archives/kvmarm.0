From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v2 0/3] Add support for for GICv2m and MSIs to
	arm-virt
Date: Mon, 27 Apr 2015 19:31:09 +0200
Message-ID: <1430155872-27030-1-git-send-email-christoffer.dall@linaro.org>
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: qemu-devel@nongnu.org
Cc: kvmarm@lists.cs.columbia.edu, Christoffer Dall <christoffer.dall@linaro.org>, eric.auger@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Now when we have a host generic PCIe controller in the virt board, it
would be nice to be able to use MSIs so that we can eventually enable
VHOST with KVM.

With these patches you can use MSIs with TCG and with KVM, but you still
need some fixes for the mapping of the IRQ index to the GSI number for
IRQFD to work.  A separate series that enables IRQFD and vhost
is available: "ARM adaptations for vhost irqfd setup"
https://lists.gnu.org/archive/html/qemu-devel/2015-04/msg01054.html)

Tested with KVM on XGene and with TCG by configuring a virtio-pci
network adapter for the guest and verifying MSIs going through as
expected.

See the individual patches for changelogs.

Christoffer Dall (3):
  target-arm: Add GIC phandle to VirtBoardInfo
  arm_gicv2m: Add GICv2m widget to support MSIs
  target-arm: Add the GICv2m to the virt board

 hw/arm/virt.c         |  67 ++++++++++++++----
 hw/intc/Makefile.objs |   1 +
 hw/intc/arm_gicv2m.c  | 190 ++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 244 insertions(+), 14 deletions(-)
 create mode 100644 hw/intc/arm_gicv2m.c

-- 
2.1.2.330.g565301e.dirty

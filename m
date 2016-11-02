From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH v1 0/2] KVM: Support GICv3 vITS in 32-bit mode
Date: Wed,  2 Nov 2016 11:55:32 +0000
Message-ID: <1478087734-15401-1-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BAC844029D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2016 07:55:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id e9iDozK1Buto for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Nov 2016 07:55:45 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7689A401A1
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2016 07:55:45 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com, andre.przywara@arm.com, kbuild-all@01.org
List-Id: kvmarm@lists.cs.columbia.edu

This patch set adds ITS emulation for 32-bit KVM.

I used Andrea's its/v8 branch at [1] for testing with the following
diff on top (it will be send separately)

diff --git a/arm/aarch32/arm-cpu.c b/arm/aarch32/arm-cpu.c
index 27a8e17..16bba55 100644
--- a/arm/aarch32/arm-cpu.c
+++ b/arm/aarch32/arm-cpu.c
@@ -12,7 +12,7 @@ static void generate_fdt_nodes(void *fdt, struct kvm *kvm)
 {
 	int timer_interrupts[4] = {13, 14, 11, 10};
 
-	gic__generate_fdt_nodes(fdt, IRQCHIP_GICV2);
+	gic__generate_fdt_nodes(fdt, kvm->cfg.arch.irqchip);
 	timer__generate_fdt_nodes(fdt, kvm, timer_interrupts);
 }
 
diff --git a/arm/aarch32/include/kvm/kvm-arch.h b/arm/aarch32/include/kvm/kvm-arch.h
index 1632e3c..99231f6 100644
--- a/arm/aarch32/include/kvm/kvm-arch.h
+++ b/arm/aarch32/include/kvm/kvm-arch.h
@@ -1,8 +1,8 @@
 #ifndef KVM__KVM_ARCH_H
 #define KVM__KVM_ARCH_H
 
-#define ARM_GIC_DIST_SIZE	0x1000
-#define ARM_GIC_CPUI_SIZE	0x2000
+#define ARM_GIC_DIST_SIZE	0x100000
+#define ARM_GIC_CPUI_SIZE	0x200000
 
 #define ARM_KERN_OFFSET(...)	0x8000
 

After passing --irqchip=gicv3-its --force-pci to kvmtool I can see
that MSI is used:

# cat /proc/interrupts
           CPU0       
 18:       1251     GICv3  27 Level     arch_timer
 28:          0   ITS-MSI 49152 Edge      virtio3-config
 29:          0   ITS-MSI 49153 Edge      virtio3-input
 30:          0   ITS-MSI 49154 Edge      virtio3-output
 31:          0   ITS-MSI 32768 Edge      virtio2-config
 32:          2   ITS-MSI 32769 Edge      virtio2-input.0
 33:          1   ITS-MSI 32770 Edge      virtio2-output.0
 34:          0   ITS-MSI   0 Edge      virtio0-config
 35:        303   ITS-MSI   1 Edge      virtio0-requests
 36:          0   ITS-MSI 16384 Edge      virtio1-config
 37:        218   ITS-MSI 16385 Edge      virtio1-requests
IPI0:          0  CPU wakeup interrupts
IPI1:          0  Timer broadcast interrupts
IPI2:          0  Rescheduling interrupts
IPI3:          0  Function call interrupts
IPI4:          0  CPU stop interrupts
IPI5:          0  IRQ work interrupts
IPI6:          0  completion interrupts
Err:          0

[1] git://www.linux-arm.org/kvmtool.git

Changelog:

    RFC -> v1
	- spilt ITS and vITS in separate patch sets
	- added Reviewed-by from Andrea

Vladimir Murzin (2):
  KVM: arm64: vgic-its: Fix compatability with 32-bit
  ARM: KVM: Support vGICv3 ITS

 Documentation/virtual/kvm/api.txt   |    2 +-
 arch/arm/include/uapi/asm/kvm.h     |    2 ++
 arch/arm/kvm/Kconfig                |    1 +
 arch/arm/kvm/Makefile               |    1 +
 arch/arm/kvm/arm.c                  |    6 ++++++
 arch/arm64/kvm/Kconfig              |    4 ----
 arch/arm64/kvm/reset.c              |    6 ------
 include/linux/irqchip/arm-gic-v3.h  |    8 ++++----
 virt/kvm/arm/vgic/vgic-its.c        |   11 ++++++-----
 virt/kvm/arm/vgic/vgic-kvm-device.c |    2 --
 virt/kvm/arm/vgic/vgic-mmio-v3.c    |    2 --
 virt/kvm/arm/vgic/vgic.h            |   26 --------------------------
 12 files changed, 21 insertions(+), 50 deletions(-)

-- 
1.7.9.5

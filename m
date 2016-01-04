From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 2/2] arm: configs: add kvm_defconfig
Date: Mon,  4 Jan 2016 14:50:34 +0000
Message-ID: <1451919034-12846-3-git-send-email-andre.przywara@arm.com>
References: <1451919034-12846-1-git-send-email-andre.przywara@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1451919034-12846-1-git-send-email-andre.przywara@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Russell King <linux@arm.linux.org.uk>, arnd@arndb.de
Cc: alison.wang@freescale.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

This new config enables KVM (and thus LPAE) on top of
multi_v7_defconfig. This creates a kernel that can _host_ KVM guests,
for guests a multi_v7_defconfig with virtio drivers is sufficient.
Since LPAE kernels are not compatible with non-LPAE capable hardware,
this has to be separate from the existing multi_v7_defconfig.

The purpose of this new defconfig is both to simplify creation of KVM
host kernels as well as to give the LPAE option some better testing
coverage, as the enlarged dma_addr_t and phys_addr_t types create some
headache to some drivers.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arch/arm/configs/{multi_v7_defconfig => kvm_defconfig} | 6 ++++++
 1 file changed, 6 insertions(+)
 copy arch/arm/configs/{multi_v7_defconfig => kvm_defconfig} (99%)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/kvm_defconfig
similarity index 99%
copy from arch/arm/configs/multi_v7_defconfig
copy to arch/arm/configs/kvm_defconfig
index 4ee2f36..2a3d81a 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/kvm_defconfig
@@ -24,6 +24,7 @@ CONFIG_ARCH_AT91=y
 CONFIG_SOC_SAMA5D2=y
 CONFIG_SOC_SAMA5D3=y
 CONFIG_SOC_SAMA5D4=y
+CONFIG_ARCH_AXXIA=y
 CONFIG_ARCH_BCM=y
 CONFIG_ARCH_BCM_CYGNUS=y
 CONFIG_ARCH_BCM_NSP=y
@@ -105,6 +106,8 @@ CONFIG_ARCH_VEXPRESS_CA9X4=y
 CONFIG_ARCH_VEXPRESS_TC2_PM=y
 CONFIG_ARCH_WM8850=y
 CONFIG_ARCH_ZYNQ=y
+CONFIG_ARM_LPAE=y
+CONFIG_TRANSPARENT_HUGEPAGE=y
 CONFIG_TRUSTED_FOUNDATIONS=y
 CONFIG_PCI=y
 CONFIG_PCI_HOST_GENERIC=y
@@ -204,6 +207,7 @@ CONFIG_SATA_MV=y
 CONFIG_SATA_RCAR=y
 CONFIG_NETDEVICES=y
 CONFIG_VIRTIO_NET=y
+CONFIG_VHOST_NET=y
 CONFIG_HIX5HD2_GMAC=y
 CONFIG_SUN4I_EMAC=y
 CONFIG_MACB=y
@@ -753,3 +757,5 @@ CONFIG_VIRTIO=y
 CONFIG_VIRTIO_PCI=y
 CONFIG_VIRTIO_PCI_LEGACY=y
 CONFIG_VIRTIO_MMIO=y
+CONFIG_VIRTUALIZATION=y
+CONFIG_KVM=y
-- 
2.6.4

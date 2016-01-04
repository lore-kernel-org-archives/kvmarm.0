From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 1/2] arm: multi_v7_defconfig: Add virtio drivers
Date: Mon,  4 Jan 2016 14:50:33 +0000
Message-ID: <1451919034-12846-2-git-send-email-andre.przywara@arm.com>
References: <1451919034-12846-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D923498CA
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Jan 2016 09:47:31 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Bxc1YbbOY4nm for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Jan 2016 09:47:30 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 140A2498A3
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Jan 2016 09:47:30 -0500 (EST)
In-Reply-To: <1451919034-12846-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Russell King <linux@arm.linux.org.uk>, arnd@arndb.de
Cc: alison.wang@freescale.com, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

To make multi_v7_defconfig really "multi", let's add virtio drivers
to allow booting a default kernel as a KVM/QEMU guest.
MACH_VIRT is already defined, so we just add VIRTIO_BLK, VIRTIO_NET
and VIRTIO_CONSOLE to actually make this kernel useful in a guest.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arch/arm/configs/multi_v7_defconfig | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index 69a22fd..4ee2f36 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -180,6 +180,7 @@ CONFIG_MTD_NAND_DAVINCI=y
 CONFIG_MTD_SPI_NOR=y
 CONFIG_MTD_UBI=y
 CONFIG_BLK_DEV_LOOP=y
+CONFIG_VIRTIO_BLK=y
 CONFIG_AD525X_DPOT=y
 CONFIG_AD525X_DPOT_I2C=y
 CONFIG_ATMEL_TCLIB=y
@@ -202,6 +203,7 @@ CONFIG_SATA_HIGHBANK=y
 CONFIG_SATA_MV=y
 CONFIG_SATA_RCAR=y
 CONFIG_NETDEVICES=y
+CONFIG_VIRTIO_NET=y
 CONFIG_HIX5HD2_GMAC=y
 CONFIG_SUN4I_EMAC=y
 CONFIG_MACB=y
@@ -294,6 +296,8 @@ CONFIG_SERIAL_CONEXANT_DIGICOLOR=y
 CONFIG_SERIAL_CONEXANT_DIGICOLOR_CONSOLE=y
 CONFIG_SERIAL_ST_ASC=y
 CONFIG_SERIAL_ST_ASC_CONSOLE=y
+CONFIG_HVC_DRIVER=y
+CONFIG_VIRTIO_CONSOLE=y
 CONFIG_I2C_CHARDEV=y
 CONFIG_I2C_DAVINCI=y
 CONFIG_I2C_MUX=y
@@ -745,3 +749,7 @@ CONFIG_CRYPTO_GHASH_ARM_CE=m
 CONFIG_CRYPTO_DEV_ATMEL_AES=m
 CONFIG_CRYPTO_DEV_ATMEL_TDES=m
 CONFIG_CRYPTO_DEV_ATMEL_SHA=m
+CONFIG_VIRTIO=y
+CONFIG_VIRTIO_PCI=y
+CONFIG_VIRTIO_PCI_LEGACY=y
+CONFIG_VIRTIO_MMIO=y
-- 
2.6.4

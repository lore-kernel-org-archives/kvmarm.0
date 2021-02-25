Return-Path: <SRS0=vuhq=H3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C898C433E6
	for <kvmarm@archiver.kernel.org>; Thu, 25 Feb 2021 01:01:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8C4EE64F0D
	for <kvmarm@archiver.kernel.org>; Thu, 25 Feb 2021 01:01:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8C4EE64F0D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A9A84B29A;
	Wed, 24 Feb 2021 20:01:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HsLmtPxsTXoz; Wed, 24 Feb 2021 20:01:04 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 987CA4B324;
	Wed, 24 Feb 2021 20:01:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 63C7B4B24F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Feb 2021 20:01:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jUQb96iM6FFe for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Feb 2021 20:01:01 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F35FE4B328
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Feb 2021 20:00:58 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BCA3C1509;
 Wed, 24 Feb 2021 17:00:58 -0800 (PST)
Received: from localhost.localdomain (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 714B23F73B;
 Wed, 24 Feb 2021 17:00:57 -0800 (PST)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
 Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: [PATCH kvmtool v2 21/22] hw/serial: ARM/arm64: Use MMIO at higher
 addresses
Date: Thu, 25 Feb 2021 00:59:14 +0000
Message-Id: <20210225005915.26423-22-andre.przywara@arm.com>
X-Mailer: git-send-email 2.14.1
In-Reply-To: <20210225005915.26423-1-andre.przywara@arm.com>
References: <20210225005915.26423-1-andre.przywara@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Sami Mujawar <sami.mujawar@arm.com>,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Using the UART devices at their legacy I/O addresses as set by IBM in
1981 was a kludge we used for simplicity on ARM platforms as well.
However this imposes problems due to their missing alignment and overlap
with the PCI I/O address space.

Now that we can switch a device easily between using ioports and MMIO,
let's move the UARTs out of the first 4K of memory on ARM platforms.

That should be transparent for well behaved guests, since the change is
naturally reflected in the device tree. Even "earlycon" keeps working,
as the stdout-path property is adjusted automatically.

People providing direct earlycon parameters via the command line need to
adjust it to: "earlycon=uart,mmio,0x1000000".

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/include/arm-common/kvm-arch.h |  3 +++
 hw/serial.c                       | 45 ++++++++++++++++++++-----------
 2 files changed, 32 insertions(+), 16 deletions(-)

diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
index b12255b0..633ea8fa 100644
--- a/arm/include/arm-common/kvm-arch.h
+++ b/arm/include/arm-common/kvm-arch.h
@@ -28,6 +28,9 @@
 #define ARM_IOPORT_SIZE		(1U << 16)
 
 
+#define ARM_UART_MMIO_BASE	ARM_MMIO_AREA
+#define ARM_UART_MMIO_SIZE	0x10000
+
 #define KVM_FLASH_MMIO_BASE	(ARM_MMIO_AREA + 0x1000000)
 #define KVM_FLASH_MAX_SIZE	0x1000000
 
diff --git a/hw/serial.c b/hw/serial.c
index 4be188a1..1854add2 100644
--- a/hw/serial.c
+++ b/hw/serial.c
@@ -13,6 +13,17 @@
 
 #include <pthread.h>
 
+#if defined(CONFIG_ARM) || defined(CONFIG_ARM64)
+#define serial_iobase(nr)	(ARM_UART_MMIO_BASE + (nr) * 0x1000)
+#define serial_irq(nr)		(32 + (nr))
+#define SERIAL8250_BUS_TYPE	DEVICE_BUS_MMIO
+#else
+#define serial_iobase(nr)	((((nr) & 1) ? 0x200 : 0x300) +	\
+				 ((nr) >= 2 ? 0xe8 : 0xf8))
+#define serial_irq(nr)		(((nr) & 1) ? 3 : 4)
+#define SERIAL8250_BUS_TYPE	DEVICE_BUS_IOPORT
+#endif
+
 /*
  * This fakes a U6_16550A. The fifo len needs to be 64 as the kernel
  * expects that for autodetection.
@@ -27,7 +38,7 @@ struct serial8250_device {
 	struct mutex		mutex;
 	u8			id;
 
-	u16			iobase;
+	u32			iobase;
 	u8			irq;
 	u8			irq_state;
 	int			txcnt;
@@ -65,56 +76,56 @@ static struct serial8250_device devices[] = {
 	/* ttyS0 */
 	[0]	= {
 		.dev_hdr = {
-			.bus_type	= DEVICE_BUS_IOPORT,
+			.bus_type	= SERIAL8250_BUS_TYPE,
 			.data		= serial8250_generate_fdt_node,
 		},
 		.mutex			= MUTEX_INITIALIZER,
 
 		.id			= 0,
-		.iobase			= 0x3f8,
-		.irq			= 4,
+		.iobase			= serial_iobase(0),
+		.irq			= serial_irq(0),
 
 		SERIAL_REGS_SETTING
 	},
 	/* ttyS1 */
 	[1]	= {
 		.dev_hdr = {
-			.bus_type	= DEVICE_BUS_IOPORT,
+			.bus_type	= SERIAL8250_BUS_TYPE,
 			.data		= serial8250_generate_fdt_node,
 		},
 		.mutex			= MUTEX_INITIALIZER,
 
 		.id			= 1,
-		.iobase			= 0x2f8,
-		.irq			= 3,
+		.iobase			= serial_iobase(1),
+		.irq			= serial_irq(1),
 
 		SERIAL_REGS_SETTING
 	},
 	/* ttyS2 */
 	[2]	= {
 		.dev_hdr = {
-			.bus_type	= DEVICE_BUS_IOPORT,
+			.bus_type	= SERIAL8250_BUS_TYPE,
 			.data		= serial8250_generate_fdt_node,
 		},
 		.mutex			= MUTEX_INITIALIZER,
 
 		.id			= 2,
-		.iobase			= 0x3e8,
-		.irq			= 4,
+		.iobase			= serial_iobase(2),
+		.irq			= serial_irq(2),
 
 		SERIAL_REGS_SETTING
 	},
 	/* ttyS3 */
 	[3]	= {
 		.dev_hdr = {
-			.bus_type	= DEVICE_BUS_IOPORT,
+			.bus_type	= SERIAL8250_BUS_TYPE,
 			.data		= serial8250_generate_fdt_node,
 		},
 		.mutex			= MUTEX_INITIALIZER,
 
 		.id			= 3,
-		.iobase			= 0x2e8,
-		.irq			= 3,
+		.iobase			= serial_iobase(3),
+		.irq			= serial_irq(3),
 
 		SERIAL_REGS_SETTING
 	},
@@ -439,7 +450,8 @@ static int serial8250__device_init(struct kvm *kvm,
 		return r;
 
 	ioport__map_irq(&dev->irq);
-	r = kvm__register_pio(kvm, dev->iobase, 8, serial8250_mmio, dev);
+	r = kvm__register_iotrap(kvm, dev->iobase, 8, serial8250_mmio, dev,
+				 SERIAL8250_BUS_TYPE);
 
 	return r;
 }
@@ -462,7 +474,7 @@ cleanup:
 	for (j = 0; j <= i; j++) {
 		struct serial8250_device *dev = &devices[j];
 
-		kvm__deregister_pio(kvm, dev->iobase);
+		kvm__deregister_iotrap(kvm, dev->iobase, SERIAL8250_BUS_TYPE);
 		device__unregister(&dev->dev_hdr);
 	}
 
@@ -478,7 +490,8 @@ int serial8250__exit(struct kvm *kvm)
 	for (i = 0; i < ARRAY_SIZE(devices); i++) {
 		struct serial8250_device *dev = &devices[i];
 
-		r = kvm__deregister_pio(kvm, dev->iobase);
+		r = kvm__deregister_iotrap(kvm, dev->iobase,
+					   SERIAL8250_BUS_TYPE);
 		if (r < 0)
 			return r;
 		device__unregister(&dev->dev_hdr);
-- 
2.17.5

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <SRS0=L5kI=FO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0718C4361B
	for <kvmarm@archiver.kernel.org>; Thu, 10 Dec 2020 14:29:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 31BC023E22
	for <kvmarm@archiver.kernel.org>; Thu, 10 Dec 2020 14:29:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 31BC023E22
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A68F24B1B3;
	Thu, 10 Dec 2020 09:29:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1uxopAuAXdiO; Thu, 10 Dec 2020 09:29:27 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 383FA4B1DA;
	Thu, 10 Dec 2020 09:29:27 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E51B4B1B3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Dec 2020 09:29:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id x3To7a5+Nl2k for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Dec 2020 09:29:25 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E86234B1A6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Dec 2020 09:29:24 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 928F71396;
 Thu, 10 Dec 2020 06:29:24 -0800 (PST)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.195.35])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 772623F718;
 Thu, 10 Dec 2020 06:29:23 -0800 (PST)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
 Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: [PATCH kvmtool 02/21] hw/serial: Use device abstraction for FDT
 generator function
Date: Thu, 10 Dec 2020 14:28:49 +0000
Message-Id: <20201210142908.169597-3-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201210142908.169597-1-andre.przywara@arm.com>
References: <20201210142908.169597-1-andre.przywara@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
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

At the moment we use the .generate_fdt_node member of the ioport ops
structure to store the function pointer for the FDT node generator
function. ioport__register() will then put a wrapper and this pointer
into the device header.
The serial device is the only device making use of this special ioport
feature, so let's move this over to using the device header directly.

This will allow us to get rid of this .generate_fdt_node member in the
ops and simplify the code.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 hw/serial.c       | 49 +++++++++++++++++++++++++++++++++++++----------
 include/kvm/kvm.h |  2 ++
 2 files changed, 41 insertions(+), 10 deletions(-)

diff --git a/hw/serial.c b/hw/serial.c
index 13c4663e..b0465d99 100644
--- a/hw/serial.c
+++ b/hw/serial.c
@@ -23,6 +23,7 @@
 #define UART_IIR_TYPE_BITS	0xc0
 
 struct serial8250_device {
+	struct device_header	dev_hdr;
 	struct mutex		mutex;
 	u8			id;
 
@@ -53,9 +54,20 @@ struct serial8250_device {
 	.msr			= UART_MSR_DCD | UART_MSR_DSR | UART_MSR_CTS, \
 	.mcr			= UART_MCR_OUT2,
 
+#ifdef CONFIG_HAS_LIBFDT
+static
+void serial8250_generate_fdt_node(void *fdt, struct device_header *dev_hdr,
+				  fdt_irq_fn irq_fn);
+#else
+#define serial8250_generate_fdt_node	NULL
+#endif
 static struct serial8250_device devices[] = {
 	/* ttyS0 */
 	[0]	= {
+		.dev_hdr = {
+			.bus_type	= DEVICE_BUS_IOPORT,
+			.data		= serial8250_generate_fdt_node,
+		},
 		.mutex			= MUTEX_INITIALIZER,
 
 		.id			= 0,
@@ -66,6 +78,10 @@ static struct serial8250_device devices[] = {
 	},
 	/* ttyS1 */
 	[1]	= {
+		.dev_hdr = {
+			.bus_type	= DEVICE_BUS_IOPORT,
+			.data		= serial8250_generate_fdt_node,
+		},
 		.mutex			= MUTEX_INITIALIZER,
 
 		.id			= 1,
@@ -76,6 +92,10 @@ static struct serial8250_device devices[] = {
 	},
 	/* ttyS2 */
 	[2]	= {
+		.dev_hdr = {
+			.bus_type	= DEVICE_BUS_IOPORT,
+			.data		= serial8250_generate_fdt_node,
+		},
 		.mutex			= MUTEX_INITIALIZER,
 
 		.id			= 2,
@@ -86,6 +106,10 @@ static struct serial8250_device devices[] = {
 	},
 	/* ttyS3 */
 	[3]	= {
+		.dev_hdr = {
+			.bus_type	= DEVICE_BUS_IOPORT,
+			.data		= serial8250_generate_fdt_node,
+		},
 		.mutex			= MUTEX_INITIALIZER,
 
 		.id			= 3,
@@ -371,13 +395,14 @@ char *fdt_stdout_path = NULL;
 
 #define DEVICE_NAME_MAX_LEN 32
 static
-void serial8250_generate_fdt_node(struct ioport *ioport, void *fdt,
-				  void (*generate_irq_prop)(void *fdt,
-							    u8 irq,
-							    enum irq_type))
+void serial8250_generate_fdt_node(void *fdt, struct device_header *dev_hdr,
+				  fdt_irq_fn irq_fn)
 {
 	char dev_name[DEVICE_NAME_MAX_LEN];
-	struct serial8250_device *dev = ioport->priv;
+	struct serial8250_device *dev = container_of(dev_hdr,
+						     struct serial8250_device,
+						     dev_hdr);
+
 	u64 addr = KVM_IOPORT_AREA + dev->iobase;
 	u64 reg_prop[] = {
 		cpu_to_fdt64(addr),
@@ -395,24 +420,26 @@ void serial8250_generate_fdt_node(struct ioport *ioport, void *fdt,
 	_FDT(fdt_begin_node(fdt, dev_name));
 	_FDT(fdt_property_string(fdt, "compatible", "ns16550a"));
 	_FDT(fdt_property(fdt, "reg", reg_prop, sizeof(reg_prop)));
-	generate_irq_prop(fdt, dev->irq, IRQ_TYPE_LEVEL_HIGH);
+	irq_fn(fdt, dev->irq, IRQ_TYPE_LEVEL_HIGH);
 	_FDT(fdt_property_cell(fdt, "clock-frequency", 1843200));
 	_FDT(fdt_end_node(fdt));
 }
-#else
-#define serial8250_generate_fdt_node	NULL
 #endif
 
 static struct ioport_operations serial8250_ops = {
 	.io_in			= serial8250_in,
 	.io_out			= serial8250_out,
-	.generate_fdt_node	= serial8250_generate_fdt_node,
 };
 
-static int serial8250__device_init(struct kvm *kvm, struct serial8250_device *dev)
+static int serial8250__device_init(struct kvm *kvm,
+				   struct serial8250_device *dev)
 {
 	int r;
 
+	r = device__register(&dev->dev_hdr);
+	if (r < 0)
+		return r;
+
 	ioport__map_irq(&dev->irq);
 	r = ioport__register(kvm, dev->iobase, &serial8250_ops, 8, dev);
 
@@ -438,6 +465,7 @@ cleanup:
 		struct serial8250_device *dev = &devices[j];
 
 		ioport__unregister(kvm, dev->iobase);
+		device__unregister(&dev->dev_hdr);
 	}
 
 	return r;
@@ -455,6 +483,7 @@ int serial8250__exit(struct kvm *kvm)
 		r = ioport__unregister(kvm, dev->iobase);
 		if (r < 0)
 			return r;
+		device__unregister(&dev->dev_hdr);
 	}
 
 	return 0;
diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
index 53373b08..ee99c28e 100644
--- a/include/kvm/kvm.h
+++ b/include/kvm/kvm.h
@@ -31,6 +31,8 @@
 	.name = #ext,			\
 	.code = ext
 
+typedef void (*fdt_irq_fn)(void *fdt, u8 irq, enum irq_type);
+
 enum {
 	KVM_VMSTATE_RUNNING,
 	KVM_VMSTATE_PAUSED,
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

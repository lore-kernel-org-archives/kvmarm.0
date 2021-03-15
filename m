Return-Path: <SRS0=nsVm=IN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82BA0C433E9
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 15:34:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2F54664E76
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 15:34:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2F54664E76
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D6C734B5B8;
	Mon, 15 Mar 2021 11:34:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3ZHZS8ERgiSi; Mon, 15 Mar 2021 11:34:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 663934B601;
	Mon, 15 Mar 2021 11:34:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 46AC14B63C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 11:34:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mBqwW+uZowdz for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Mar 2021 11:34:49 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 84BCC4B448
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 11:34:45 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4ECDA1FB;
 Mon, 15 Mar 2021 08:34:45 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 034CA3F792;
 Mon, 15 Mar 2021 08:34:43 -0700 (PDT)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
 Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: [PATCH kvmtool v3 22/22] hw/rtc: ARM/arm64: Use MMIO at higher
 addresses
Date: Mon, 15 Mar 2021 15:33:50 +0000
Message-Id: <20210315153350.19988-23-andre.przywara@arm.com>
X-Mailer: git-send-email 2.14.1
In-Reply-To: <20210315153350.19988-1-andre.przywara@arm.com>
References: <20210315153350.19988-1-andre.przywara@arm.com>
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

Using the RTC device at its legacy I/O address as set by IBM in 1981
was a kludge we used for simplicity on ARM platforms as well.
However this imposes problems due to their missing alignment and overlap
with the PCI I/O address space.

Now that we can switch a device easily between using ioports and
MMIO, let's move the RTC out of the first 4K of memory on ARM platforms.

That should be transparent for well behaved guests, since the change is
naturally reflected in the device tree.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/include/arm-common/kvm-arch.h |  7 +++++--
 hw/rtc.c                          | 24 ++++++++++++++++--------
 2 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
index bf34d742..436b67b8 100644
--- a/arm/include/arm-common/kvm-arch.h
+++ b/arm/include/arm-common/kvm-arch.h
@@ -14,8 +14,8 @@
  * +-------+----+-------+-------+--------+-----+---------+---......
  * |  PCI  |////| plat  |       |        |     |         |
  * |  I/O  |////| MMIO: | Flash | virtio | GIC |   PCI   |  DRAM
- * | space |////| UART  |       |  MMIO  |     |  (AXI)  |
- * |       |////|       |       |        |     |         |
+ * | space |////| UART, |       |  MMIO  |     |  (AXI)  |
+ * |       |////| RTC   |       |        |     |         |
  * +-------+----+-------+-------+--------+-----+---------+---......
  */
 
@@ -31,6 +31,9 @@
 #define ARM_UART_MMIO_BASE	ARM_MMIO_AREA
 #define ARM_UART_MMIO_SIZE	0x10000
 
+#define ARM_RTC_MMIO_BASE	(ARM_UART_MMIO_BASE + ARM_UART_MMIO_SIZE)
+#define ARM_RTC_MMIO_SIZE	0x10000
+
 #define KVM_FLASH_MMIO_BASE	(ARM_MMIO_AREA + 0x1000000)
 #define KVM_FLASH_MAX_SIZE	0x1000000
 
diff --git a/hw/rtc.c b/hw/rtc.c
index ee4c9102..aec31c52 100644
--- a/hw/rtc.c
+++ b/hw/rtc.c
@@ -5,6 +5,15 @@
 
 #include <time.h>
 
+#if defined(CONFIG_ARM) || defined(CONFIG_ARM64)
+#define RTC_BUS_TYPE		DEVICE_BUS_MMIO
+#define RTC_BASE_ADDRESS	ARM_RTC_MMIO_BASE
+#else
+/* PORT 0070-007F - CMOS RAM/RTC (REAL TIME CLOCK) */
+#define RTC_BUS_TYPE		DEVICE_BUS_IOPORT
+#define RTC_BASE_ADDRESS	0x70
+#endif
+
 /*
  * MC146818 RTC registers
  */
@@ -49,7 +58,7 @@ static void cmos_ram_io(struct kvm_cpu *vcpu, u64 addr, u8 *data,
 	time_t ti;
 
 	if (is_write) {
-		if (addr == 0x70) {	/* index register */
+		if (addr == RTC_BASE_ADDRESS) {	/* index register */
 			u8 value = ioport__read8(data);
 
 			vcpu->kvm->nmi_disabled	= value & (1UL << 7);
@@ -70,7 +79,7 @@ static void cmos_ram_io(struct kvm_cpu *vcpu, u64 addr, u8 *data,
 		return;
 	}
 
-	if (addr == 0x70)
+	if (addr == RTC_BASE_ADDRESS)	/* index register is write-only */
 		return;
 
 	time(&ti);
@@ -127,7 +136,7 @@ static void generate_rtc_fdt_node(void *fdt,
 							    u8 irq,
 							    enum irq_type))
 {
-	u64 reg_prop[2] = { cpu_to_fdt64(0x70), cpu_to_fdt64(2) };
+	u64 reg_prop[2] = { cpu_to_fdt64(RTC_BASE_ADDRESS), cpu_to_fdt64(2) };
 
 	_FDT(fdt_begin_node(fdt, "rtc"));
 	_FDT(fdt_property_string(fdt, "compatible", "motorola,mc146818"));
@@ -139,7 +148,7 @@ static void generate_rtc_fdt_node(void *fdt,
 #endif
 
 struct device_header rtc_dev_hdr = {
-	.bus_type = DEVICE_BUS_IOPORT,
+	.bus_type = RTC_BUS_TYPE,
 	.data = generate_rtc_fdt_node,
 };
 
@@ -151,8 +160,8 @@ int rtc__init(struct kvm *kvm)
 	if (r < 0)
 		return r;
 
-	/* PORT 0070-007F - CMOS RAM/RTC (REAL TIME CLOCK) */
-	r = kvm__register_pio(kvm, 0x0070, 2, cmos_ram_io, NULL);
+	r = kvm__register_iotrap(kvm, RTC_BASE_ADDRESS, 2, cmos_ram_io, NULL,
+				 RTC_BUS_TYPE);
 	if (r < 0)
 		goto out_device;
 
@@ -170,8 +179,7 @@ dev_init(rtc__init);
 
 int rtc__exit(struct kvm *kvm)
 {
-	/* PORT 0070-007F - CMOS RAM/RTC (REAL TIME CLOCK) */
-	kvm__deregister_pio(kvm, 0x0070);
+	kvm__deregister_iotrap(kvm, RTC_BASE_ADDRESS, RTC_BUS_TYPE);
 
 	return 0;
 }
-- 
2.17.5

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

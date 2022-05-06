Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CC74C433EF
	for <kvmarm@archiver.kernel.org>; Sat,  7 May 2022 09:14:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DD0FD4B2E1;
	Sat,  7 May 2022 05:14:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GgsYzTkHlXBQ; Sat,  7 May 2022 05:14:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DD814B2B5;
	Sat,  7 May 2022 05:14:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DE26A4B18A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 May 2022 10:09:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p0WbmsSvGhIf for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 May 2022 10:09:10 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A6B34B17D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 May 2022 10:09:10 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 106DB1570;
 Fri,  6 May 2022 07:09:10 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com
 [10.7.66.42])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2121F3F885;
 Fri,  6 May 2022 07:09:09 -0700 (PDT)
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
To: Andrew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH 06/23] arm/arm64: Add support for discovering
 the UART through ACPI
Date: Fri,  6 May 2022 15:08:38 +0100
Message-Id: <20220506140855.353337-7-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220506140855.353337-1-nikos.nikoleris@arm.com>
References: <20220506140855.353337-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
X-Mailman-Approved-At: Sat, 07 May 2022 05:14:38 -0400
Cc: Nikos Nikoleris <nikos.nikoleris@arm.com>, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, jade.alglave@arm.com
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

In systems with ACPI support and when a DT is not provided, we can use
the SPCR to discover the serial port address range. This change
implements this but retains the default behavior; we check if a valid
DT is provided, if not, we try to discover the UART using ACPI.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
---
 lib/acpi.h   | 25 +++++++++++++++++++++++++
 lib/arm/io.c | 21 +++++++++++++++++++--
 2 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/lib/acpi.h b/lib/acpi.h
index 40392e3..0611cdf 100644
--- a/lib/acpi.h
+++ b/lib/acpi.h
@@ -16,6 +16,7 @@
 #define XSDT_SIGNATURE ACPI_SIGNATURE('X','S','D','T')
 #define FACP_SIGNATURE ACPI_SIGNATURE('F','A','C','P')
 #define FACS_SIGNATURE ACPI_SIGNATURE('F','A','C','S')
+#define SPCR_SIGNATURE ACPI_SIGNATURE('S','P','C','R')
 
 
 #define ACPI_SIGNATURE_8BYTE(c1, c2, c3, c4, c5, c6, c7, c8) \
@@ -147,6 +148,30 @@ struct facs_descriptor_rev1
     u8  reserved3 [40];         /* Reserved - must be zero */
 } __attribute__ ((packed));
 
+struct spcr_descriptor {
+    ACPI_TABLE_HEADER_DEF   /* ACPI common table header */
+    u8 interface_type;      /* 0=full 16550, 1=subset of 16550 */
+    u8 reserved[3];
+    struct acpi_generic_address serial_port;
+    u8 interrupt_type;
+    u8 pc_interrupt;
+    u32 interrupt;
+    u8 baud_rate;
+    u8 parity;
+    u8 stop_bits;
+    u8 flow_control;
+    u8 terminal_type;
+    u8 reserved1;
+    u16 pci_device_id;
+    u16 pci_vendor_id;
+    u8 pci_bus;
+    u8 pci_device;
+    u8 pci_function;
+    u32 pci_flags;
+    u8 pci_segment;
+    u32 reserved2;
+} __attribute__ ((packed));
+
 void set_efi_rsdp(struct rsdp_descriptor *rsdp);
 void* find_acpi_table_addr(u32 sig);
 
diff --git a/lib/arm/io.c b/lib/arm/io.c
index 343e108..893bdfc 100644
--- a/lib/arm/io.c
+++ b/lib/arm/io.c
@@ -8,6 +8,7 @@
  *
  * This work is licensed under the terms of the GNU LGPL, version 2.
  */
+#include <acpi.h>
 #include <libcflat.h>
 #include <devicetree.h>
 #include <chr-testdev.h>
@@ -29,7 +30,7 @@ static struct spinlock uart_lock;
 #define UART_EARLY_BASE (u8 *)(unsigned long)CONFIG_UART_EARLY_BASE
 static volatile u8 *uart0_base = UART_EARLY_BASE;
 
-static void uart0_init(void)
+static void uart0_init_fdt(void)
 {
 	/*
 	 * kvm-unit-tests uses the uart only for output. Both uart models have
@@ -73,9 +74,25 @@ static void uart0_init(void)
 	}
 }
 
+static void uart0_init_acpi(void)
+{
+	struct spcr_descriptor *spcr = find_acpi_table_addr(SPCR_SIGNATURE);
+	assert_msg(spcr, "Unable to find ACPI SPCR");
+	uart0_base = ioremap(spcr->serial_port.address, spcr->serial_port.bit_width);
+
+	if (uart0_base != UART_EARLY_BASE) {
+		printf("WARNING: early print support may not work. "
+		       "Found uart at %p, but early base is %p.\n",
+			uart0_base, UART_EARLY_BASE);
+	}
+}
+
 void io_init(void)
 {
-	uart0_init();
+	if (dt_available())
+		uart0_init_fdt();
+	else
+		uart0_init_acpi();
 	chr_testdev_init();
 }
 
-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

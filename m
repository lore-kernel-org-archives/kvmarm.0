Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3165256F
	for <kvmarm@lists.linux.dev>; Mon, 13 Feb 2023 10:18:19 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5BC581D34;
	Mon, 13 Feb 2023 02:19:02 -0800 (PST)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C1B013F703;
	Mon, 13 Feb 2023 02:18:18 -0800 (PST)
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	andrew.jones@linux.dev
Cc: pbonzini@redhat.com,
	alexandru.elisei@arm.com,
	ricarkol@google.com,
	Andrew Jones <drjones@redhat.com>
Subject: [PATCH v4 13/30] arm64: Add support for discovering the UART through ACPI
Date: Mon, 13 Feb 2023 10:17:42 +0000
Message-Id: <20230213101759.2577077-14-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230213101759.2577077-1-nikos.nikoleris@arm.com>
References: <20230213101759.2577077-1-nikos.nikoleris@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
Content-Transfer-Encoding: 8bit

In systems with ACPI support and when a DT is not provided, we can use
the SPCR to discover the serial port address range. This change
implements this but retains the default behavior; we check if a valid
DT is provided, if not, we try to discover the UART using ACPI.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Ricardo Koller <ricarkol@google.com>
---
 lib/acpi.h   | 25 +++++++++++++++++++++++++
 lib/arm/io.c | 34 +++++++++++++++++++++++++++++-----
 2 files changed, 54 insertions(+), 5 deletions(-)

diff --git a/lib/acpi.h b/lib/acpi.h
index 5ba6e29d..02ca8958 100644
--- a/lib/acpi.h
+++ b/lib/acpi.h
@@ -17,6 +17,7 @@
 #define XSDT_SIGNATURE ACPI_SIGNATURE('X','S','D','T')
 #define FACP_SIGNATURE ACPI_SIGNATURE('F','A','C','P')
 #define FACS_SIGNATURE ACPI_SIGNATURE('F','A','C','S')
+#define SPCR_SIGNATURE ACPI_SIGNATURE('S','P','C','R')
 
 #define ACPI_SIGNATURE_8BYTE(c1, c2, c3, c4, c5, c6, c7, c8) \
 	(((uint64_t)(ACPI_SIGNATURE(c1, c2, c3, c4))) |	     \
@@ -145,6 +146,30 @@ struct acpi_table_facs_rev1 {
 	u8 reserved3[40];	/* Reserved - must be zero */
 };
 
+struct spcr_descriptor {
+	ACPI_TABLE_HEADER_DEF	/* ACPI common table header */
+	u8 interface_type;	/* 0=full 16550, 1=subset of 16550 */
+	u8 reserved[3];
+	struct acpi_generic_address serial_port;
+	u8 interrupt_type;
+	u8 pc_interrupt;
+	u32 interrupt;
+	u8 baud_rate;
+	u8 parity;
+	u8 stop_bits;
+	u8 flow_control;
+	u8 terminal_type;
+	u8 reserved1;
+	u16 pci_device_id;
+	u16 pci_vendor_id;
+	u8 pci_bus;
+	u8 pci_device;
+	u8 pci_function;
+	u32 pci_flags;
+	u8 pci_segment;
+	u32 reserved2;
+};
+
 #pragma pack(0)
 
 void set_efi_rsdp(struct acpi_table_rsdp *rsdp);
diff --git a/lib/arm/io.c b/lib/arm/io.c
index 343e1082..19f93490 100644
--- a/lib/arm/io.c
+++ b/lib/arm/io.c
@@ -29,7 +29,7 @@ static struct spinlock uart_lock;
 #define UART_EARLY_BASE (u8 *)(unsigned long)CONFIG_UART_EARLY_BASE
 static volatile u8 *uart0_base = UART_EARLY_BASE;
 
-static void uart0_init(void)
+static void uart0_init_fdt(void)
 {
 	/*
 	 * kvm-unit-tests uses the uart only for output. Both uart models have
@@ -65,17 +65,41 @@ static void uart0_init(void)
 	}
 
 	uart0_base = ioremap(base.addr, base.size);
+}
+
+#ifdef CONFIG_EFI
+
+#include <acpi.h>
+
+static void uart0_init_acpi(void)
+{
+	struct spcr_descriptor *spcr = find_acpi_table_addr(SPCR_SIGNATURE);
+
+	assert_msg(spcr, "Unable to find ACPI SPCR");
+	uart0_base = ioremap(spcr->serial_port.address, spcr->serial_port.bit_width);
+}
+#else
+
+static void uart0_init_acpi(void)
+{
+	assert_msg(false, "ACPI not available");
+}
+
+#endif
+
+void io_init(void)
+{
+	if (dt_available())
+		uart0_init_fdt();
+	else
+		uart0_init_acpi();
 
 	if (uart0_base != UART_EARLY_BASE) {
 		printf("WARNING: early print support may not work. "
 		       "Found uart at %p, but early base is %p.\n",
 			uart0_base, UART_EARLY_BASE);
 	}
-}
 
-void io_init(void)
-{
-	uart0_init();
 	chr_testdev_init();
 }
 
-- 
2.25.1


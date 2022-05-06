Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A705C433FE
	for <kvmarm@archiver.kernel.org>; Sat,  7 May 2022 09:14:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 44EF14B2F0;
	Sat,  7 May 2022 05:14:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id niiSAQz3qnQw; Sat,  7 May 2022 05:14:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 414A44B2BD;
	Sat,  7 May 2022 05:14:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D4134B18F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 May 2022 10:09:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pW28atOJjhZt for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 May 2022 10:09:12 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9854E4B17D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 May 2022 10:09:12 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6448B1570;
 Fri,  6 May 2022 07:09:12 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com
 [10.7.66.42])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 74D4C3F885;
 Fri,  6 May 2022 07:09:11 -0700 (PDT)
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
To: Andrew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH 08/23] arm/arm64: Add support for cpu
 initialization through ACPI
Date: Fri,  6 May 2022 15:08:40 +0100
Message-Id: <20220506140855.353337-9-nikos.nikoleris@arm.com>
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
the MADTs to discover the number of CPUs and their corresponding MIDR.
This change implements this but retains the default behavior; we check
if a valid DT is provided, if not, we try to discover the cores in the
system using ACPI.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
---
 lib/acpi.h      | 64 +++++++++++++++++++++++++++++++++++++++++++++++++
 lib/acpi.c      | 21 ++++++++++++++++
 lib/arm/setup.c | 25 ++++++++++++++++---
 3 files changed, 107 insertions(+), 3 deletions(-)

diff --git a/lib/acpi.h b/lib/acpi.h
index 47e56d2..296ad25 100644
--- a/lib/acpi.h
+++ b/lib/acpi.h
@@ -16,6 +16,7 @@
 #define XSDT_SIGNATURE ACPI_SIGNATURE('X','S','D','T')
 #define FACP_SIGNATURE ACPI_SIGNATURE('F','A','C','P')
 #define FACS_SIGNATURE ACPI_SIGNATURE('F','A','C','S')
+#define MADT_SIGNATURE ACPI_SIGNATURE('A','P','I','C')
 #define SPCR_SIGNATURE ACPI_SIGNATURE('S','P','C','R')
 #define GTDT_SIGNATURE ACPI_SIGNATURE('G','T','D','T')
 
@@ -149,6 +150,67 @@ struct facs_descriptor_rev1
     u8  reserved3 [40];         /* Reserved - must be zero */
 } __attribute__ ((packed));
 
+struct acpi_table_madt {
+    ACPI_TABLE_HEADER_DEF     /* ACPI common table header */
+    u32 address;               /* Physical address of local APIC */
+    u32 flags;
+} __attribute__ ((packed));
+
+struct acpi_subtable_header {
+    u8 type;
+    u8 length;
+}  __attribute__ ((packed));
+
+typedef int (*acpi_table_handler)(struct acpi_subtable_header *header);
+
+/* 11: Generic interrupt - GICC (ACPI 5.0 + ACPI 6.0 + ACPI 6.3 changes) */
+
+struct acpi_madt_generic_interrupt {
+    u8 type;
+    u8 length;
+    u16 reserved;           /* reserved - must be zero */
+    u32 cpu_interface_number;
+    u32 uid;
+    u32 flags;
+    u32 parking_version;
+    u32 performance_interrupt;
+    u64 parked_address;
+    u64 base_address;
+    u64 gicv_base_address;
+    u64 gich_base_address;
+    u32 vgic_interrupt;
+    u64 gicr_base_address;
+    u64 arm_mpidr;
+    u8 efficiency_class;
+    u8 reserved2[1];
+    u16 spe_interrupt;      /* ACPI 6.3 */
+} __attribute__ ((packed));
+
+/* Values for MADT subtable type in struct acpi_subtable_header */
+
+enum acpi_madt_type {
+    ACPI_MADT_TYPE_LOCAL_APIC = 0,
+    ACPI_MADT_TYPE_IO_APIC = 1,
+    ACPI_MADT_TYPE_INTERRUPT_OVERRIDE = 2,
+    ACPI_MADT_TYPE_NMI_SOURCE = 3,
+    ACPI_MADT_TYPE_LOCAL_APIC_NMI = 4,
+    ACPI_MADT_TYPE_LOCAL_APIC_OVERRIDE = 5,
+    ACPI_MADT_TYPE_IO_SAPIC = 6,
+    ACPI_MADT_TYPE_LOCAL_SAPIC = 7,
+    ACPI_MADT_TYPE_INTERRUPT_SOURCE = 8,
+    ACPI_MADT_TYPE_LOCAL_X2APIC = 9,
+    ACPI_MADT_TYPE_LOCAL_X2APIC_NMI = 10,
+    ACPI_MADT_TYPE_GENERIC_INTERRUPT = 11,
+    ACPI_MADT_TYPE_GENERIC_DISTRIBUTOR = 12,
+    ACPI_MADT_TYPE_GENERIC_MSI_FRAME = 13,
+    ACPI_MADT_TYPE_GENERIC_REDISTRIBUTOR = 14,
+    ACPI_MADT_TYPE_GENERIC_TRANSLATOR = 15,
+    ACPI_MADT_TYPE_RESERVED = 16    /* 16 and greater are reserved */
+};
+
+/* MADT Local APIC flags */
+#define ACPI_MADT_ENABLED           (1) /* 00: Processor is usable if set */
+
 struct spcr_descriptor {
     ACPI_TABLE_HEADER_DEF   /* ACPI common table header */
     u8 interface_type;      /* 0=full 16550, 1=subset of 16550 */
@@ -192,5 +254,7 @@ struct acpi_table_gtdt {
 
 void set_efi_rsdp(struct rsdp_descriptor *rsdp);
 void* find_acpi_table_addr(u32 sig);
+void acpi_table_parse_madt(enum acpi_madt_type mtype,
+			   acpi_table_handler handler);
 
 #endif
diff --git a/lib/acpi.c b/lib/acpi.c
index 5e56dff..d76c762 100644
--- a/lib/acpi.c
+++ b/lib/acpi.c
@@ -102,3 +102,24 @@ void* find_acpi_table_addr(u32 sig)
 
 	return NULL;
 }
+
+void acpi_table_parse_madt(enum acpi_madt_type mtype,
+			   acpi_table_handler handler)
+{
+	struct acpi_table_madt *madt;
+	void *end;
+
+	madt = find_acpi_table_addr(MADT_SIGNATURE);
+	assert(madt);
+
+	struct acpi_subtable_header *header =
+		(void*)(ulong)madt + sizeof(struct acpi_table_madt);
+	end = (void*)((ulong)madt + madt->length);
+
+	while ((void *)header < end) {
+		if (header->type == mtype) {
+			handler(header);
+		}
+		header = (void*)(ulong)header + header->length;
+	}
+}
diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index 1572c64..3c24c75 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -13,6 +13,7 @@
 #include <libcflat.h>
 #include <libfdt/libfdt.h>
 #include <devicetree.h>
+#include <acpi.h>
 #include <alloc.h>
 #include <alloc_phys.h>
 #include <alloc_page.h>
@@ -55,7 +56,7 @@ int mpidr_to_cpu(uint64_t mpidr)
 	return -1;
 }
 
-static void cpu_set(int fdtnode __unused, u64 regval, void *info __unused)
+static void cpu_set_fdt(int fdtnode __unused, u64 regval, void *info __unused)
 {
 	int cpu = nr_cpus++;
 
@@ -65,13 +66,31 @@ static void cpu_set(int fdtnode __unused, u64 regval, void *info __unused)
 	set_cpu_present(cpu, true);
 }
 
+static int cpu_set_acpi(struct acpi_subtable_header *header)
+{
+	int cpu = nr_cpus++;
+	struct acpi_madt_generic_interrupt *gicc = (void *)header;
+
+	assert_msg(cpu < NR_CPUS, "Number cpus exceeds maximum supported (%d).", NR_CPUS);
+
+	cpus[cpu] = gicc->arm_mpidr;
+	set_cpu_present(cpu, true);
+
+	return 0;
+}
+
 static void cpu_init(void)
 {
 	int ret;
 
 	nr_cpus = 0;
-	ret = dt_for_each_cpu_node(cpu_set, NULL);
-	assert(ret == 0);
+	if (dt_available()) {
+		ret = dt_for_each_cpu_node(cpu_set_fdt, NULL);
+		assert(ret == 0);
+	} else
+		acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_INTERRUPT,
+				      cpu_set_acpi);
+
 	set_cpu_online(0, true);
 }
 
-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

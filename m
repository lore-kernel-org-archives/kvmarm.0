Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 196D8C433F5
	for <kvmarm@archiver.kernel.org>; Sat,  7 May 2022 09:14:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A2EB4B103;
	Sat,  7 May 2022 05:14:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 75775Ow8zyso; Sat,  7 May 2022 05:14:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E4E574B22A;
	Sat,  7 May 2022 05:14:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 062024B18A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 May 2022 10:09:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2iUZ4TvTI1oN for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 May 2022 10:09:09 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 74E084B177
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 May 2022 10:09:09 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DB8151596;
 Fri,  6 May 2022 07:09:08 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com
 [10.7.66.42])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EBD683F885;
 Fri,  6 May 2022 07:09:07 -0700 (PDT)
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
To: Andrew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH 05/23] arm/arm64: Add support for setting up
 the PSCI conduit through ACPI
Date: Fri,  6 May 2022 15:08:37 +0100
Message-Id: <20220506140855.353337-6-nikos.nikoleris@arm.com>
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
the FADT to discover whether PSCI calls need to use smc or hvc
calls. This change implements this but retains the default behavior;
we check if a valid DT is provided, if not, we try to setup the PSCI
conduit using ACPI.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
---
 arm/Makefile.common |  1 +
 lib/acpi.h          |  5 +++++
 lib/arm/psci.c      | 23 ++++++++++++++++++++++-
 lib/devicetree.c    |  2 +-
 4 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/arm/Makefile.common b/arm/Makefile.common
index 38385e0..8e9b3bb 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -38,6 +38,7 @@ cflatobjs += lib/alloc_page.o
 cflatobjs += lib/vmalloc.o
 cflatobjs += lib/alloc.o
 cflatobjs += lib/devicetree.o
+cflatobjs += lib/acpi.o
 cflatobjs += lib/pci.o
 cflatobjs += lib/pci-host-generic.o
 cflatobjs += lib/pci-testdev.o
diff --git a/lib/acpi.h b/lib/acpi.h
index 657e868..40392e3 100644
--- a/lib/acpi.h
+++ b/lib/acpi.h
@@ -130,6 +130,11 @@ struct acpi_table_fadt
     u64 hypervisor_id;      /* Hypervisor Vendor ID (ACPI 6.0) */
 }  __attribute__ ((packed));
 
+/* Masks for FADT ARM Boot Architecture Flags (arm_boot_flags) ACPI 5.1 */
+
+#define ACPI_FADT_PSCI_COMPLIANT    (1)         /* 00: [V5+] PSCI 0.2+ is implemented */
+#define ACPI_FADT_PSCI_USE_HVC      (1<<1)      /* 01: [V5+] HVC must be used instead of SMC as the PSCI conduit */
+
 struct facs_descriptor_rev1
 {
     u32 signature;           /* ACPI Signature */
diff --git a/lib/arm/psci.c b/lib/arm/psci.c
index 9c031a1..0e96d19 100644
--- a/lib/arm/psci.c
+++ b/lib/arm/psci.c
@@ -6,6 +6,7 @@
  *
  * This work is licensed under the terms of the GNU LGPL, version 2.
  */
+#include <acpi.h>
 #include <devicetree.h>
 #include <asm/psci.h>
 #include <asm/setup.h>
@@ -56,7 +57,7 @@ void psci_system_off(void)
 	printf("CPU%d unable to do system off (error = %d)\n", smp_processor_id(), err);
 }
 
-void psci_set_conduit(void)
+static void psci_set_conduit_fdt(void)
 {
 	const void *fdt = dt_fdt();
 	const struct fdt_property *method;
@@ -75,3 +76,23 @@ void psci_set_conduit(void)
 	else
 		assert_msg(false, "Unknown PSCI conduit: %s", method->data);
 }
+
+static void psci_set_conduit_acpi(void)
+{
+	struct acpi_table_fadt *fadt = find_acpi_table_addr(FACP_SIGNATURE);
+	assert_msg(fadt, "Unable to find ACPI FADT");
+	assert_msg(fadt->arm_boot_flags & ACPI_FADT_PSCI_COMPLIANT,
+		   "PSCI is not supported in this platfrom");
+	if (fadt->arm_boot_flags & ACPI_FADT_PSCI_USE_HVC)
+		psci_invoke = psci_invoke_hvc;
+	else
+		psci_invoke = psci_invoke_smc;
+}
+
+void psci_set_conduit(void)
+{
+	if (dt_available())
+		psci_set_conduit_fdt();
+	else
+		psci_set_conduit_acpi();
+}
diff --git a/lib/devicetree.c b/lib/devicetree.c
index 78c1f6f..3ff9d16 100644
--- a/lib/devicetree.c
+++ b/lib/devicetree.c
@@ -16,7 +16,7 @@ const void *dt_fdt(void)
 
 bool dt_available(void)
 {
-	return fdt_check_header(fdt) == 0;
+	return fdt && fdt_check_header(fdt) == 0;
 }
 
 int dt_get_nr_cells(int fdtnode, u32 *nr_address_cells, u32 *nr_size_cells)
-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

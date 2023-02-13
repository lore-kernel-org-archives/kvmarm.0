Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CF852572
	for <kvmarm@lists.linux.dev>; Mon, 13 Feb 2023 10:18:11 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4B79B1A00;
	Mon, 13 Feb 2023 02:18:53 -0800 (PST)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CBEB53F703;
	Mon, 13 Feb 2023 02:18:09 -0800 (PST)
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	andrew.jones@linux.dev
Cc: pbonzini@redhat.com,
	alexandru.elisei@arm.com,
	ricarkol@google.com
Subject: [PATCH v4 05/30] lib: Fix style for acpi.{c,h}
Date: Mon, 13 Feb 2023 10:17:34 +0000
Message-Id: <20230213101759.2577077-6-nikos.nikoleris@arm.com>
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

Manually fix style issues to make the files consistent with the kernel
coding style.

Zero-length array members have been replaced with flexible array members
(for details about the motivation, consult
Documentation/process/deprecated.rst in the Linux tree, the section about
zero-length and one-element arrays).

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
[ Alex E: changes other than indentation ]
---
 lib/acpi.c | 16 ++++++++--------
 lib/acpi.h | 12 ++++++------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/lib/acpi.c b/lib/acpi.c
index 836156a1..3f87711a 100644
--- a/lib/acpi.c
+++ b/lib/acpi.c
@@ -11,9 +11,9 @@ void set_efi_rsdp(struct rsdp_descriptor *rsdp)
 
 static struct rsdp_descriptor *get_rsdp(void)
 {
-	if (efi_rsdp == NULL) {
+	if (efi_rsdp == NULL)
 		printf("Can't find RSDP from UEFI, maybe set_efi_rsdp() was not called\n");
-	}
+
 	return efi_rsdp;
 }
 #else
@@ -28,9 +28,8 @@ static struct rsdp_descriptor *get_rsdp(void)
 			break;
 	}
 
-	if (addr == 0x100000) {
+	if (addr == 0x100000)
 		return NULL;
-	}
 
 	return rsdp;
 }
@@ -38,18 +37,18 @@ static struct rsdp_descriptor *get_rsdp(void)
 
 void *find_acpi_table_addr(u32 sig)
 {
-	struct rsdp_descriptor *rsdp;
 	struct rsdt_descriptor_rev1 *rsdt;
+	struct rsdp_descriptor *rsdp;
 	void *end;
 	int i;
 
 	/* FACS is special... */
 	if (sig == FACS_SIGNATURE) {
 		struct fadt_descriptor_rev1 *fadt;
+
 		fadt = find_acpi_table_addr(FACP_SIGNATURE);
 		if (!fadt)
 			return NULL;
-
 		return (void *)(ulong) fadt->firmware_ctrl;
 	}
 
@@ -72,9 +71,10 @@ void *find_acpi_table_addr(u32 sig)
 	end = (void *)rsdt + rsdt->length;
 	for (i = 0; (void *)&rsdt->table_offset_entry[i] < end; i++) {
 		struct acpi_table *t = (void *)(ulong) rsdt->table_offset_entry[i];
-		if (t && t->signature == sig) {
+
+		if (t && t->signature == sig)
 			return t;
-		}
 	}
+
 	return NULL;
 }
diff --git a/lib/acpi.h b/lib/acpi.h
index b67bbe19..fad28792 100644
--- a/lib/acpi.h
+++ b/lib/acpi.h
@@ -3,7 +3,7 @@
 
 #include "libcflat.h"
 
-#define ACPI_SIGNATURE(c1, c2, c3, c4)				\
+#define ACPI_SIGNATURE(c1, c2, c3, c4) \
 	((c1) | ((c2) << 8) | ((c3) << 16) | ((c4) << 24))
 
 #define RSDP_SIGNATURE ACPI_SIGNATURE('R','S','D','P')
@@ -11,9 +11,9 @@
 #define FACP_SIGNATURE ACPI_SIGNATURE('F','A','C','P')
 #define FACS_SIGNATURE ACPI_SIGNATURE('F','A','C','S')
 
-#define ACPI_SIGNATURE_8BYTE(c1, c2, c3, c4, c5, c6, c7, c8)	\
-	((uint64_t)(ACPI_SIGNATURE(c1, c2, c3, c4))) |		\
-	((uint64_t)(ACPI_SIGNATURE(c5, c6, c7, c8)) << 32)
+#define ACPI_SIGNATURE_8BYTE(c1, c2, c3, c4, c5, c6, c7, c8) \
+	(((uint64_t)(ACPI_SIGNATURE(c1, c2, c3, c4))) |	     \
+	 ((uint64_t)(ACPI_SIGNATURE(c5, c6, c7, c8)) << 32))
 
 #define RSDP_SIGNATURE_8BYTE (ACPI_SIGNATURE_8BYTE('R', 'S', 'D', ' ', 'P', 'T', 'R', ' '))
 
@@ -42,12 +42,12 @@ struct rsdp_descriptor {	/* Root System Descriptor Pointer */
 
 struct acpi_table {
 	ACPI_TABLE_HEADER_DEF
-	char data[0];
+	char data[];
 };
 
 struct rsdt_descriptor_rev1 {
 	ACPI_TABLE_HEADER_DEF
-	u32 table_offset_entry[1];
+	u32 table_offset_entry[];
 };
 
 struct fadt_descriptor_rev1 {
-- 
2.25.1


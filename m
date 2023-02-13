Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 411D1256F
	for <kvmarm@lists.linux.dev>; Mon, 13 Feb 2023 10:18:15 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A79ED1D13;
	Mon, 13 Feb 2023 02:18:57 -0800 (PST)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3329E3F703;
	Mon, 13 Feb 2023 02:18:14 -0800 (PST)
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	andrew.jones@linux.dev
Cc: pbonzini@redhat.com,
	alexandru.elisei@arm.com,
	ricarkol@google.com
Subject: [PATCH v4 09/30] lib/acpi: Add support for the XSDT table
Date: Mon, 13 Feb 2023 10:17:38 +0000
Message-Id: <20230213101759.2577077-10-nikos.nikoleris@arm.com>
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

XSDT provides pointers to other ACPI tables much like RSDT. However,
contrary to RSDT that provides 32-bit addresses, XSDT provides 64-bit
pointers. ACPI requires that if XSDT is valid then it takes precedence
over RSDT.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
[ Alex E: Use flexible array member for XSDT struct ]
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/acpi.c | 40 ++++++++++++++++++++++++++++++++--------
 lib/acpi.h |  6 ++++++
 2 files changed, 38 insertions(+), 8 deletions(-)

diff --git a/lib/acpi.c b/lib/acpi.c
index 166ffd14..d35f09a6 100644
--- a/lib/acpi.c
+++ b/lib/acpi.c
@@ -37,7 +37,8 @@ static struct acpi_table_rsdp *get_rsdp(void)
 
 void *find_acpi_table_addr(u32 sig)
 {
-	struct acpi_table_rsdt_rev1 *rsdt;
+	struct acpi_table_rsdt_rev1 *rsdt = NULL;
+	struct acpi_table_xsdt *xsdt = NULL;
 	struct acpi_table_rsdp *rsdp;
 	void *end;
 	int i;
@@ -62,18 +63,41 @@ void *find_acpi_table_addr(u32 sig)
 		return rsdp;
 
 	rsdt = (void *)(ulong) rsdp->rsdt_physical_address;
-	if (!rsdt || rsdt->signature != RSDT_SIGNATURE)
-		return NULL;
+	if (rsdt && rsdt->signature != RSDT_SIGNATURE)
+		rsdt = NULL;
 
 	if (sig == RSDT_SIGNATURE)
 		return rsdt;
 
-	end = (void *)rsdt + rsdt->length;
-	for (i = 0; (void *)&rsdt->table_offset_entry[i] < end; i++) {
-		struct acpi_table *t = (void *)(ulong) rsdt->table_offset_entry[i];
+	if (rsdp->revision >= 2) {
+		xsdt = (void *)rsdp->xsdt_physical_address;
+		if (xsdt && xsdt->signature != XSDT_SIGNATURE)
+			xsdt = NULL;
+	}
 
-		if (t && t->signature == sig)
-			return t;
+	if (sig == XSDT_SIGNATURE)
+		return xsdt;
+
+	/*
+	 * When the system implements APCI 2.0 and above and XSDT is valid we
+	 * have use XSDT to find other ACPI tables, otherwise, we use RSDT.
+	 */
+	if (xsdt) {
+		end = (void *)xsdt + xsdt->length;
+		for (i = 0; (void *)&xsdt->table_offset_entry[i] < end; i++) {
+			struct acpi_table *t = (void *)(ulong) xsdt->table_offset_entry[i];
+
+			if (t && t->signature == sig)
+				return t;
+		}
+	} else if (rsdt) {
+		end = (void *)rsdt + rsdt->length;
+		for (i = 0; (void *)&rsdt->table_offset_entry[i] < end; i++) {
+			struct acpi_table *t = (void *)(ulong) rsdt->table_offset_entry[i];
+
+			if (t && t->signature == sig)
+				return t;
+		}
 	}
 
 	return NULL;
diff --git a/lib/acpi.h b/lib/acpi.h
index 67d12942..621ad08a 100644
--- a/lib/acpi.h
+++ b/lib/acpi.h
@@ -14,6 +14,7 @@
 
 #define RSDP_SIGNATURE ACPI_SIGNATURE('R','S','D','P')
 #define RSDT_SIGNATURE ACPI_SIGNATURE('R','S','D','T')
+#define XSDT_SIGNATURE ACPI_SIGNATURE('X','S','D','T')
 #define FACP_SIGNATURE ACPI_SIGNATURE('F','A','C','P')
 #define FACS_SIGNATURE ACPI_SIGNATURE('F','A','C','S')
 
@@ -56,6 +57,11 @@ struct acpi_table_rsdt_rev1 {
 	u32 table_offset_entry[];
 };
 
+struct acpi_table_xsdt {
+	ACPI_TABLE_HEADER_DEF
+	u64 table_offset_entry[];
+};
+
 struct acpi_table_fadt_rev1 {
 	ACPI_TABLE_HEADER_DEF	/* ACPI common table header */
 	u32 firmware_ctrl;	/* Physical address of FACS */
-- 
2.25.1


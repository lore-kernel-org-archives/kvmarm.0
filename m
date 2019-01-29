From: James Morse <james.morse@arm.com>
Subject: [PATCH v8 19/26] ACPI / APEI: Split ghes_read_estatus() to allow a
 peek at the CPER length
Date: Tue, 29 Jan 2019 18:48:55 +0000
Message-ID: <20190129184902.102850-20-james.morse@arm.com>
References: <20190129184902.102850-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED1344A36D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Jan 2019 13:50:36 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id f5tU3gv46KbX for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Jan 2019 13:50:35 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 914864A331
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Jan 2019 13:50:34 -0500 (EST)
In-Reply-To: <20190129184902.102850-1-james.morse@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-acpi@vger.kernel.org
Cc: Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-mm@kvack.org, Borislav Petkov <bp@alien8.de>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

ghes_read_estatus() reads the record address, then the record's
header, then performs some sanity checks before reading the
records into the provided estatus buffer.

To provide this estatus buffer the caller must know the size of the
records in advance, or always provide a worst-case sized buffer as
happens today for the non-NMI notifications.

Add a function to peek at the record's header to find the size. This
will let the NMI path allocate the right amount of memory before reading
the records, instead of using the worst-case size, and having to copy
the records.

Split ghes_read_estatus() to create __ghes_peek_estatus() which
returns the address and size of the CPER records.

Signed-off-by: James Morse <james.morse@arm.com>

Changes since v7:
 * Grammar
 * concistent argument ordering

Changes since v6:
 * Additional buf_addr = 0 error handling
 * Moved checking out of peek-estatus
 * Reworded an error message so we can tell them apart
---
 drivers/acpi/apei/ghes.c | 40 +++++++++++++++++++++++++++++-----------
 1 file changed, 29 insertions(+), 11 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 9391fff71344..12375a82fa03 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -317,12 +317,12 @@ int __ghes_check_estatus(struct ghes *ghes,
 	return 0;
 }
 
-static int ghes_read_estatus(struct ghes *ghes,
-			     struct acpi_hest_generic_status *estatus,
-			     u64 *buf_paddr, enum fixed_addresses fixmap_idx)
+/* Read the CPER block, returning its address, and header in estatus. */
+static int __ghes_peek_estatus(struct ghes *ghes,
+			       struct acpi_hest_generic_status *estatus,
+			       u64 *buf_paddr, enum fixed_addresses fixmap_idx)
 {
 	struct acpi_hest_generic *g = ghes->generic;
-	u32 len;
 	int rc;
 
 	rc = apei_read(buf_paddr, &g->error_status_address);
@@ -343,14 +343,14 @@ static int ghes_read_estatus(struct ghes *ghes,
 		return -ENOENT;
 	}
 
-	rc = __ghes_check_estatus(ghes, estatus);
-	if (rc)
-		return rc;
+	return __ghes_check_estatus(ghes, estatus);
+}
 
-	len = cper_estatus_len(estatus);
-	ghes_copy_tofrom_phys(estatus + 1,
-			      *buf_paddr + sizeof(*estatus),
-			      len - sizeof(*estatus), 1, fixmap_idx);
+static int __ghes_read_estatus(struct acpi_hest_generic_status *estatus,
+			       u64 buf_paddr, enum fixed_addresses fixmap_idx,
+			       size_t buf_len)
+{
+	ghes_copy_tofrom_phys(estatus, buf_paddr, buf_len, 1, fixmap_idx);
 	if (cper_estatus_check(estatus)) {
 		pr_warn_ratelimited(FW_WARN GHES_PFX
 				    "Failed to read error status block!\n");
@@ -360,6 +360,24 @@ static int ghes_read_estatus(struct ghes *ghes,
 	return 0;
 }
 
+static int ghes_read_estatus(struct ghes *ghes,
+			     struct acpi_hest_generic_status *estatus,
+			     u64 *buf_paddr, enum fixed_addresses fixmap_idx)
+{
+	int rc;
+
+	rc = __ghes_peek_estatus(ghes, estatus, buf_paddr, fixmap_idx);
+	if (rc)
+		return rc;
+
+	rc = __ghes_check_estatus(ghes, estatus);
+	if (rc)
+		return rc;
+
+	return __ghes_read_estatus(estatus, *buf_paddr, fixmap_idx,
+				   cper_estatus_len(estatus));
+}
+
 static void ghes_clear_estatus(struct ghes *ghes,
 			       struct acpi_hest_generic_status *estatus,
 			       u64 buf_paddr, enum fixed_addresses fixmap_idx)
-- 
2.20.1

From: James Morse <james.morse@arm.com>
Subject: [PATCH v7 18/25] ACPI / APEI: Split ghes_read_estatus() to allow a
 peek at the CPER length
Date: Mon,  3 Dec 2018 18:06:06 +0000
Message-ID: <20181203180613.228133-19-james.morse@arm.com>
References: <20181203180613.228133-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 63C3C4A2BD
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Dec 2018 13:07:43 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ycvj5-YpfkmI for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Dec 2018 13:07:42 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A0B9F4A2BB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Dec 2018 13:07:41 -0500 (EST)
In-Reply-To: <20181203180613.228133-1-james.morse@arm.com>
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
Cc: Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, Fan Wu <wufan@codeaurora.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-mm@kvack.org, Borislav Petkov <bp@alien8.de>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
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

Changes since v6:
 * Additional buf_addr = 0 error handling
 * Moved checking out of peek-estatus
 * Reworded an error message so we can tell them apart
---
 drivers/acpi/apei/ghes.c | 59 ++++++++++++++++++++++++++++++++--------
 1 file changed, 47 insertions(+), 12 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index b70f5fd962cc..07a12aac4c1a 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -277,12 +277,12 @@ static void ghes_copy_tofrom_phys(void *buffer, u64 paddr, u32 len,
 	}
 }
 
-static int ghes_read_estatus(struct ghes *ghes,
-			     struct acpi_hest_generic_status *estatus,
-			     u64 *buf_paddr, int fixmap_idx)
+/* Read the CPER block and returning its address, and header in estatus. */
+static int __ghes_peek_estatus(struct ghes *ghes, int fixmap_idx,
+			       struct acpi_hest_generic_status *estatus,
+			       u64 *buf_paddr)
 {
 	struct acpi_hest_generic *g = ghes->generic;
-	u32 len;
 	int rc;
 
 	rc = apei_read(buf_paddr, &g->error_status_address);
@@ -303,29 +303,64 @@ static int ghes_read_estatus(struct ghes *ghes,
 		return -ENOENT;
 	}
 
-	rc = -EIO;
-	len = cper_estatus_len(estatus);
+	return 0;
+}
+
+/* Check the top-level record header has an appropriate size. */
+int __ghes_check_estatus(struct ghes *ghes,
+			 struct acpi_hest_generic_status *estatus)
+{
+	u32 len = cper_estatus_len(estatus);
+	int rc = -EIO;
+
 	if (len < sizeof(*estatus))
 		goto err_read_block;
 	if (len > ghes->generic->error_block_length)
 		goto err_read_block;
 	if (cper_estatus_check_header(estatus))
 		goto err_read_block;
-	ghes_copy_tofrom_phys(estatus + 1,
-			      *buf_paddr + sizeof(*estatus),
-			      len - sizeof(*estatus), 1, fixmap_idx);
-	if (cper_estatus_check(estatus))
-		goto err_read_block;
 	rc = 0;
 
 err_read_block:
 	if (rc)
 		pr_warn_ratelimited(FW_WARN GHES_PFX
-				    "Failed to read error status block!\n");
+				    "Invalid Error status block!\n");
 
 	return rc;
 }
 
+static int __ghes_read_estatus(struct acpi_hest_generic_status *estatus,
+			       u64 buf_paddr, size_t buf_len,
+			       int fixmap_idx)
+{
+	ghes_copy_tofrom_phys(estatus, buf_paddr, buf_len, 1, fixmap_idx);
+	if (cper_estatus_check(estatus)) {
+		pr_warn_ratelimited(FW_WARN GHES_PFX
+				   "Failed to read error status block!\n");
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int ghes_read_estatus(struct ghes *ghes,
+			     struct acpi_hest_generic_status *estatus,
+			     u64 *buf_paddr, int fixmap_idx)
+{
+	int rc;
+
+	rc = __ghes_peek_estatus(ghes, fixmap_idx, estatus, buf_paddr);
+	if (rc)
+		return rc;
+
+	rc = __ghes_check_estatus(ghes, estatus);
+	if (rc)
+		return rc;
+
+	return __ghes_read_estatus(estatus, *buf_paddr,
+				   cper_estatus_len(estatus), fixmap_idx);
+}
+
 static void ghes_clear_estatus(struct acpi_hest_generic_status *estatus,
 			       u64 buf_paddr, int fixmap_idx)
 {
-- 
2.19.2

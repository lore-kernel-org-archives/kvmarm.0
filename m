From: James Morse <james.morse@arm.com>
Subject: [PATCH v8 18/26] ACPI / APEI: Make GHES estatus header validation
 more user friendly
Date: Tue, 29 Jan 2019 18:48:54 +0000
Message-ID: <20190129184902.102850-19-james.morse@arm.com>
References: <20190129184902.102850-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EEC74A331
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Jan 2019 13:50:34 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id K4Qs3dp+U+f6 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Jan 2019 13:50:33 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA97F4A3B3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Jan 2019 13:50:31 -0500 (EST)
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

ghes_read_estatus() checks various lengths in the top-level header to
ensure the CPER records to be read aren't obviously corrupt.

Take the opportunity to make this more user-friendly, printing a
(ratelimited) message about the nature of the header format error.

Suggested-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: James Morse <james.morse@arm.com>
---
 drivers/acpi/apei/ghes.c | 46 ++++++++++++++++++++++++++++------------
 1 file changed, 32 insertions(+), 14 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index f95db2398dd5..9391fff71344 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -293,6 +293,30 @@ static void ghes_copy_tofrom_phys(void *buffer, u64 paddr, u32 len,
 	}
 }
 
+/* Check the top-level record header has an appropriate size. */
+int __ghes_check_estatus(struct ghes *ghes,
+			 struct acpi_hest_generic_status *estatus)
+{
+	u32 len = cper_estatus_len(estatus);
+
+	if (len < sizeof(*estatus)) {
+		pr_warn_ratelimited(FW_WARN GHES_PFX "Truncated error status block!\n");
+		return -EIO;
+	}
+
+	if (len > ghes->generic->error_block_length) {
+		pr_warn_ratelimited(FW_WARN GHES_PFX "Invalid error status block length!\n");
+		return -EIO;
+	}
+
+	if (cper_estatus_check_header(estatus)) {
+		pr_warn_ratelimited(FW_WARN GHES_PFX "Invalid CPER header!\n");
+		return -EIO;
+	}
+
+	return 0;
+}
+
 static int ghes_read_estatus(struct ghes *ghes,
 			     struct acpi_hest_generic_status *estatus,
 			     u64 *buf_paddr, enum fixed_addresses fixmap_idx)
@@ -319,27 +343,21 @@ static int ghes_read_estatus(struct ghes *ghes,
 		return -ENOENT;
 	}
 
-	rc = -EIO;
+	rc = __ghes_check_estatus(ghes, estatus);
+	if (rc)
+		return rc;
+
 	len = cper_estatus_len(estatus);
-	if (len < sizeof(*estatus))
-		goto err_read_block;
-	if (len > ghes->generic->error_block_length)
-		goto err_read_block;
-	if (cper_estatus_check_header(estatus))
-		goto err_read_block;
 	ghes_copy_tofrom_phys(estatus + 1,
 			      *buf_paddr + sizeof(*estatus),
 			      len - sizeof(*estatus), 1, fixmap_idx);
-	if (cper_estatus_check(estatus))
-		goto err_read_block;
-	rc = 0;
-
-err_read_block:
-	if (rc)
+	if (cper_estatus_check(estatus)) {
 		pr_warn_ratelimited(FW_WARN GHES_PFX
 				    "Failed to read error status block!\n");
+		return -EIO;
+	}
 
-	return rc;
+	return 0;
 }
 
 static void ghes_clear_estatus(struct ghes *ghes,
-- 
2.20.1

From: James Morse <james.morse@arm.com>
Subject: [PATCH v6 11/18] ACPI / APEI: Remove silent flag from
 ghes_read_estatus()
Date: Fri, 21 Sep 2018 23:16:58 +0100
Message-ID: <20180921221705.6478-12-james.morse@arm.com>
References: <20180921221705.6478-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 99F4F4A1DF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Sep 2018 18:18:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JvOO03B4h4eY for <kvmarm@lists.cs.columbia.edu>;
 Fri, 21 Sep 2018 18:18:35 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D23A4A1E1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Sep 2018 18:18:35 -0400 (EDT)
In-Reply-To: <20180921221705.6478-1-james.morse@arm.com>
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
Cc: jonathan.zhang@cavium.com, Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, Punit Agrawal <punit.agrawal@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Tyler Baicar <tbaicar@codeaurora.org>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-mm@kvack.org, Borislav Petkov <bp@alien8.de>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Subsequent patches will split up ghes_read_estatus(), at which
point passing around the 'silent' flag gets annoying. This is to
suppress prink() messages, which prior to 42a0bb3f7138 ("printk/nmi:
generic solution for safe printk in NMI"), were unsafe in NMI context.

We don't need to do this anymore, remove the flag. printk() messages
are batched in a per-cpu buffer and printed via irq-work, or a call
back from panic().

Signed-off-by: James Morse <james.morse@arm.com>
---
 drivers/acpi/apei/ghes.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 586689cbc0fd..ba5344d26a39 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -300,7 +300,7 @@ static void ghes_copy_tofrom_phys(void *buffer, u64 paddr, u32 len,
 
 static int ghes_read_estatus(struct ghes *ghes,
 			     struct acpi_hest_generic_status *estatus,
-			     int silent, int fixmap_idx)
+			     int fixmap_idx)
 {
 	struct acpi_hest_generic *g = ghes->generic;
 	u64 buf_paddr;
@@ -309,7 +309,7 @@ static int ghes_read_estatus(struct ghes *ghes,
 
 	rc = apei_read(&buf_paddr, &g->error_status_address);
 	if (rc) {
-		if (!silent && printk_ratelimit())
+		if (printk_ratelimit())
 			pr_warning(FW_WARN GHES_PFX
 "Failed to read error status block address for hardware error source: %d.\n",
 				   g->header.source_id);
@@ -342,7 +342,7 @@ static int ghes_read_estatus(struct ghes *ghes,
 	rc = 0;
 
 err_read_block:
-	if (rc && !silent && printk_ratelimit())
+	if (rc && printk_ratelimit())
 		pr_warning(FW_WARN GHES_PFX
 			   "Failed to read error status block!\n");
 	return rc;
@@ -729,7 +729,7 @@ static int _in_nmi_notify_one(struct ghes *ghes, int fixmap_idx)
 	int sev;
 	struct acpi_hest_generic_status *estatus = ghes->estatus;
 
-	if (ghes_read_estatus(ghes, estatus, 1, fixmap_idx)) {
+	if (ghes_read_estatus(ghes, estatus, fixmap_idx)) {
 		ghes_clear_estatus(ghes, estatus, fixmap_idx);
 		return -ENOENT;
 	}
@@ -863,7 +863,7 @@ static int ghes_proc(struct ghes *ghes)
 	int rc;
 	struct acpi_hest_generic_status *estatus = ghes->estatus;
 
-	rc = ghes_read_estatus(ghes, estatus, 0, FIX_APEI_GHES_IRQ);
+	rc = ghes_read_estatus(ghes, estatus, FIX_APEI_GHES_IRQ);
 	if (rc)
 		goto out;
 
-- 
2.19.0

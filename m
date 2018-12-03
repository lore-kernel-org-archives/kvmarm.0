From: James Morse <james.morse@arm.com>
Subject: [PATCH v7 02/25] ACPI / APEI: Remove silent flag from
 ghes_read_estatus()
Date: Mon,  3 Dec 2018 18:05:50 +0000
Message-ID: <20181203180613.228133-3-james.morse@arm.com>
References: <20181203180613.228133-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D448A4A1E5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Dec 2018 13:06:45 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jzhVXP4vrDrU for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Dec 2018 13:06:43 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7357E4A348
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Dec 2018 13:06:43 -0500 (EST)
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

Subsequent patches will split up ghes_read_estatus(), at which
point passing around the 'silent' flag gets annoying. This is to
suppress prink() messages, which prior to commit 42a0bb3f7138
("printk/nmi: generic solution for safe printk in NMI"), were
unsafe in NMI context.

This is no longer necessary, remove the flag. printk() messages
are batched in a per-cpu buffer and printed via irq-work, or a call
back from panic().

Signed-off-by: James Morse <james.morse@arm.com>
---
Changes since v6:
 * Moved earlier in the series,
 * Tinkered with the commit message.
 * switched to pr_warn_ratelimited() to shut checkpatch up

shutup checkpatch
---
 drivers/acpi/apei/ghes.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index ab2dae6fc7e4..e8503c7d721f 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -324,7 +324,7 @@ static void ghes_copy_tofrom_phys(void *buffer, u64 paddr, u32 len,
 	}
 }
 
-static int ghes_read_estatus(struct ghes *ghes, int silent)
+static int ghes_read_estatus(struct ghes *ghes)
 {
 	struct acpi_hest_generic *g = ghes->generic;
 	u64 buf_paddr;
@@ -333,8 +333,7 @@ static int ghes_read_estatus(struct ghes *ghes, int silent)
 
 	rc = apei_read(&buf_paddr, &g->error_status_address);
 	if (rc) {
-		if (!silent && printk_ratelimit())
-			pr_warning(FW_WARN GHES_PFX
+		pr_warn_ratelimited(FW_WARN GHES_PFX
 "Failed to read error status block address for hardware error source: %d.\n",
 				   g->header.source_id);
 		return -EIO;
@@ -366,9 +365,9 @@ static int ghes_read_estatus(struct ghes *ghes, int silent)
 	rc = 0;
 
 err_read_block:
-	if (rc && !silent && printk_ratelimit())
-		pr_warning(FW_WARN GHES_PFX
-			   "Failed to read error status block!\n");
+	if (rc)
+		pr_warn_ratelimited(FW_WARN GHES_PFX
+				    "Failed to read error status block!\n");
 	return rc;
 }
 
@@ -700,7 +699,7 @@ static int ghes_proc(struct ghes *ghes)
 {
 	int rc;
 
-	rc = ghes_read_estatus(ghes, 0);
+	rc = ghes_read_estatus(ghes);
 	if (rc)
 		goto out;
 
@@ -937,7 +936,7 @@ static int ghes_notify_nmi(unsigned int cmd, struct pt_regs *regs)
 		return ret;
 
 	list_for_each_entry_rcu(ghes, &ghes_nmi, list) {
-		if (ghes_read_estatus(ghes, 1)) {
+		if (ghes_read_estatus(ghes)) {
 			ghes_clear_estatus(ghes);
 			continue;
 		} else {
-- 
2.19.2

From: James Morse <james.morse@arm.com>
Subject: [PATCH v8 10/26] ACPI / APEI: Don't allow ghes_ack_error() to mask
 earlier errors
Date: Tue, 29 Jan 2019 18:48:46 +0000
Message-ID: <20190129184902.102850-11-james.morse@arm.com>
References: <20190129184902.102850-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B07D04A36B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Jan 2019 13:50:09 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id f+EOM94kfPuW for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Jan 2019 13:50:08 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4582E4A2D3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Jan 2019 13:50:08 -0500 (EST)
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

During ghes_proc() we use ghes_ack_error() to tell an external agent
we are done with these records and it can re-use the memory.

rc may hold an error returned by ghes_read_estatus(), ENOENT causes
us to skip ghes_ack_error() (as there is nothing to ack), but rc may
also by EIO, which gets supressed.

ghes_clear_estatus() is where we mark the records as processed for
non GHESv2 error sources, and already spots the ENOENT case as
buf_paddr is set to 0 by ghes_read_estatus().

Move the ghes_ack_error() call in here to avoid extra logic with
the return code in ghes_proc().

This enables GHESv2 acking for NMI-like error sources. This is safe
as the buffer is pre-mapped by map_gen_v2() before the GHES is added
to any NMI handler lists.

This same pre-mapping step means we can't receive an error from
apei_read()/write() here as apei_check_gar() succeeded when it
was mapped, and the mapping was cached, so the address can't be
rejected at runtime. Remove the error-returns as this is now
called from a function with no return.

Signed-off-by: James Morse <james.morse@arm.com>
---
 drivers/acpi/apei/ghes.c | 47 +++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 25 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index cb3d88de711f..bd58749d31bb 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -197,6 +197,21 @@ static void unmap_gen_v2(struct ghes *ghes)
 	apei_unmap_generic_address(&ghes->generic_v2->read_ack_register);
 }
 
+static void ghes_ack_error(struct acpi_hest_generic_v2 *gv2)
+{
+	int rc;
+	u64 val = 0;
+
+	rc = apei_read(&val, &gv2->read_ack_register);
+	if (rc)
+		return;
+
+	val &= gv2->read_ack_preserve << gv2->read_ack_register.bit_offset;
+	val |= gv2->read_ack_write    << gv2->read_ack_register.bit_offset;
+
+	apei_write(val, &gv2->read_ack_register);
+}
+
 static struct ghes *ghes_new(struct acpi_hest_generic *generic)
 {
 	struct ghes *ghes;
@@ -361,6 +376,13 @@ static void ghes_clear_estatus(struct ghes *ghes, u64 buf_paddr)
 
 	ghes_copy_tofrom_phys(ghes->estatus, buf_paddr,
 			      sizeof(ghes->estatus->block_status), 0);
+
+	/*
+	 * GHESv2 type HEST entries introduce support for error acknowledgment,
+	 * so only acknowledge the error if this support is present.
+	 */
+	if (is_hest_type_generic_v2(ghes))
+		ghes_ack_error(ghes->generic_v2);
 }
 
 static void ghes_handle_memory_failure(struct acpi_hest_generic_data *gdata, int sev)
@@ -652,21 +674,6 @@ static void ghes_estatus_cache_add(
 	rcu_read_unlock();
 }
 
-static int ghes_ack_error(struct acpi_hest_generic_v2 *gv2)
-{
-	int rc;
-	u64 val = 0;
-
-	rc = apei_read(&val, &gv2->read_ack_register);
-	if (rc)
-		return rc;
-
-	val &= gv2->read_ack_preserve << gv2->read_ack_register.bit_offset;
-	val |= gv2->read_ack_write    << gv2->read_ack_register.bit_offset;
-
-	return apei_write(val, &gv2->read_ack_register);
-}
-
 static void __ghes_panic(struct ghes *ghes, u64 buf_paddr)
 {
 	__ghes_print_estatus(KERN_EMERG, ghes->generic, ghes->estatus);
@@ -701,16 +708,6 @@ static int ghes_proc(struct ghes *ghes)
 out:
 	ghes_clear_estatus(ghes, buf_paddr);
 
-	if (rc == -ENOENT)
-		return rc;
-
-	/*
-	 * GHESv2 type HEST entries introduce support for error acknowledgment,
-	 * so only acknowledge the error if this support is present.
-	 */
-	if (is_hest_type_generic_v2(ghes))
-		return ghes_ack_error(ghes->generic_v2);
-
 	return rc;
 }
 
-- 
2.20.1

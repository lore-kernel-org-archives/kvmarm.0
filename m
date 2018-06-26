From: James Morse <james.morse@arm.com>
Subject: [PATCH v5 03/20] ACPI / APEI: don't wait to serialise with oops
 messages when panic()ing
Date: Tue, 26 Jun 2018 18:00:59 +0100
Message-ID: <20180626170116.25825-4-james.morse@arm.com>
References: <20180626170116.25825-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D02D4A0EC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jun 2018 12:50:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ADRyN7yv9a4y for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jun 2018 12:50:09 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 563AC4A0F0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jun 2018 12:49:55 -0400 (EDT)
In-Reply-To: <20180626170116.25825-1-james.morse@arm.com>
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

oops_begin() exists to group printk() messages with the oops message
printed by die(). To reach this caller we know that platform firmware
took this error first, then notified the OS via NMI with a 'panic'
severity.

Don't wait for another CPU to release the die-lock before we can
panic(), our only goal is to print this fatal error and panic().

This code is always called in_nmi(), and since 42a0bb3f7138 ("printk/nmi:
generic solution for safe printk in NMI"), it has been safe to call
printk() from this context. Messages are batched in a per-cpu buffer
and printed via irq-work, or a call back from panic().

Link: https://patchwork.kernel.org/patch/10313555/
Acked-by: Borislav Petkov <bp@suse.de>
Signed-off-by: James Morse <james.morse@arm.com>
---
 drivers/acpi/apei/ghes.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 29d863ff2f87..d7c46236b353 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -33,7 +33,6 @@
 #include <linux/interrupt.h>
 #include <linux/timer.h>
 #include <linux/cper.h>
-#include <linux/kdebug.h>
 #include <linux/platform_device.h>
 #include <linux/mutex.h>
 #include <linux/ratelimit.h>
@@ -758,9 +757,6 @@ static int _in_nmi_notify_one(struct ghes *ghes)
 
 	sev = ghes_severity(ghes->estatus->error_severity);
 	if (sev >= GHES_SEV_PANIC) {
-#ifdef CONFIG_X86
-		oops_begin();
-#endif
 		ghes_print_queued_estatus();
 		__ghes_panic(ghes);
 	}
-- 
2.17.1

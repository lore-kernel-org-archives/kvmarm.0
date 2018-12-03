From: James Morse <james.morse@arm.com>
Subject: [PATCH v7 07/25] ACPI / APEI: Remove spurious GHES_TO_CLEAR check
Date: Mon,  3 Dec 2018 18:05:55 +0000
Message-ID: <20181203180613.228133-8-james.morse@arm.com>
References: <20181203180613.228133-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 225544A355
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Dec 2018 13:07:02 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Mz+JvU98si1Z for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Dec 2018 13:07:01 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 01A5F4A36F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Dec 2018 13:07:01 -0500 (EST)
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

ghes_notify_nmi() checks ghes->flags for GHES_TO_CLEAR before going
on to __process_error(). This is pointless as ghes_read_estatus()
will always set this flag if it returns success, which was checked
earlier in the loop. Remove it.

Signed-off-by: James Morse <james.morse@arm.com>
---
 drivers/acpi/apei/ghes.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index acf0c37e9af9..f7a0ff1c785a 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -936,9 +936,6 @@ static int ghes_notify_nmi(unsigned int cmd, struct pt_regs *regs)
 			__ghes_panic(ghes);
 		}
 
-		if (!(ghes->flags & GHES_TO_CLEAR))
-			continue;
-
 		__process_error(ghes);
 		ghes_clear_estatus(ghes, buf_paddr);
 	}
-- 
2.19.2

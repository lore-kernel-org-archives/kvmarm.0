From: James Morse <james.morse@arm.com>
Subject: [PATCH v7 10/25] ACPI / APEI: Tell firmware the estatus queue
 consumed the records
Date: Mon,  3 Dec 2018 18:05:58 +0000
Message-ID: <20181203180613.228133-11-james.morse@arm.com>
References: <20181203180613.228133-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 521464A2F8
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Dec 2018 13:07:13 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id E8LdPF8bk0CT for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Dec 2018 13:07:12 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 430444A324
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Dec 2018 13:07:12 -0500 (EST)
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

ACPI has a GHESv2 which is used on hardware reduced platforms to
explicitly acknowledge that the memory for CPER records has been
consumed. This lets an external agent know it can re-use this
memory for something else.

Previously notify_nmi and the estatus queue didn't do this as
they were never used on hardware reduced platforms. Once we move
notify_sea over to use the estatus queue, it may become necessary.

Add the call. This is safe for use in NMI context as the
read_ack_register is pre-mapped by ghes_new() before the
ghes can be added to an RCU list, and then found by the
notification handler.

Signed-off-by: James Morse <james.morse@arm.com>
---
 drivers/acpi/apei/ghes.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 366dbdd41ef3..15d94373ba72 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -926,6 +926,10 @@ static int _in_nmi_notify_one(struct ghes *ghes)
 	__process_error(ghes);
 	ghes_clear_estatus(ghes, buf_paddr);
 
+	if (is_hest_type_generic_v2(ghes) && ghes_ack_error(ghes->generic_v2))
+		pr_warn_ratelimited(FW_WARN GHES_PFX
+				    "Failed to ack error status block!\n");
+
 	return 0;
 }
 
-- 
2.19.2

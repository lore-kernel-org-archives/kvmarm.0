From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH kvmtool] irq.h: fix compilation error due to missing bool type
Date: Fri,  3 Nov 2017 16:10:21 +0000
Message-ID: <20171103161021.6511-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2258749D50
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Nov 2017 12:08:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6ASazuwMW-Tu for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Nov 2017 12:08:52 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C66E49D4B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Nov 2017 12:08:52 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Commit f6108d72e977 ("Add GICv2m support") introduced a bool return
type, but missed to include the respective header (this was probably
part of a former prerequisite series).
Fix this by including the header.

Fixes: f6108d72e977cce00e7bc824acd1d73da8cc9729 ("Add GICv2m support")
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 include/kvm/irq.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/kvm/irq.h b/include/kvm/irq.h
index 429542d8..8ba8b740 100644
--- a/include/kvm/irq.h
+++ b/include/kvm/irq.h
@@ -1,6 +1,7 @@
 #ifndef KVM__IRQ_H
 #define KVM__IRQ_H
 
+#include <stdbool.h>
 #include <linux/types.h>
 #include <linux/rbtree.h>
 #include <linux/list.h>
-- 
2.14.1

From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH kvm-unit-tests 1/2] arm/arm64: add GICD_IIDR definition
Date: Thu, 30 Aug 2018 16:17:32 +0200
Message-ID: <20180830141733.21725-2-drjones@redhat.com>
References: <20180830141733.21725-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DEE824A1E1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Aug 2018 10:17:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qmvv8OAdecmy for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Aug 2018 10:17:38 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4A8D24A229
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Aug 2018 10:17:38 -0400 (EDT)
In-Reply-To: <20180830141733.21725-1-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org
Cc: marc.zyngier@arm.com, ynorov@caviumnetworks.com, shihwei@cs.columbia.edu, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Shih-Wei Li <shihwei@cs.columbia.edu>

Signed-off-by: Shih-Wei Li <shihwei@cs.columbia.edu>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 lib/arm/asm/gic.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
index 2eb4af8d6c81..3b9982b0e7b5 100644
--- a/lib/arm/asm/gic.h
+++ b/lib/arm/asm/gic.h
@@ -10,6 +10,7 @@
 /* Distributor registers */
 #define GICD_CTLR			0x0000
 #define GICD_TYPER			0x0004
+#define GICD_IIDR			0x0008
 #define GICD_IGROUPR			0x0080
 #define GICD_ISENABLER			0x0100
 #define GICD_ISPENDR			0x0200
-- 
2.17.1

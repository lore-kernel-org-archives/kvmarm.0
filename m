From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v8 08/16] arm: gic: allow 32-bit compilation
Date: Fri,  4 Nov 2016 17:31:55 +0000
Message-ID: <20161104173203.21168-9-andre.przywara@arm.com>
References: <20161104173203.21168-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DDEF6404D5
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2016 13:31:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ci6ct5HHFo61 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Nov 2016 13:31:34 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BBF264055D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2016 13:31:32 -0400 (EDT)
In-Reply-To: <20161104173203.21168-1-andre.przywara@arm.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

The ARM GIC code is shared between ARM and arm64, though the header
files from the Linux kernel are actually different, reflecting the
different level of GIC emulation support between the two architectures.
Since it is conceivable that ARM will gain GICv3 (and possibly ITS)
emulation support too, lets conditionally define those missing
symbols in the source file until an upcoming ARM header update eventually
includes those.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/gic.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arm/gic.c b/arm/gic.c
index 2c1a547..4d12f31 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -18,6 +18,14 @@
 #define KVM_VGIC_V3_ADDR_TYPE_REDIST 3
 #endif
 
+#ifndef KVM_VGIC_ITS_ADDR_TYPE
+#define KVM_VGIC_ITS_ADDR_TYPE 4
+#endif
+
+#ifndef KVM_VGIC_V3_ITS_SIZE
+#define KVM_VGIC_V3_ITS_SIZE (2 * SZ_64K)
+#endif
+
 static int gic_fd = -1;
 static u64 gic_redists_base;
 static u64 gic_redists_size;
-- 
2.9.0

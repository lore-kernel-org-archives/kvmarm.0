From: Andrew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH v4 08/11] libcflat: add IS_ALIGNED() macro,
 and page sizes
Date: Thu, 10 Nov 2016 17:08:01 +0100
Message-ID: <1478794084-5273-9-git-send-email-drjones@redhat.com>
References: <1478794084-5273-1-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DB98405B0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Nov 2016 11:08:10 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6GURWRzNfESQ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Nov 2016 11:08:06 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A20514068E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Nov 2016 11:08:06 -0500 (EST)
In-Reply-To: <1478794084-5273-1-git-send-email-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: marc.zyngier@arm.com, andre.przywara@arm.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Peter Xu <peterx@redhat.com>

These macros will be useful to do page alignment checks.

Signed-off-by: Peter Xu <peterx@redhat.com>
[drew: also added SZ_64K]
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 lib/libcflat.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/lib/libcflat.h b/lib/libcflat.h
index 82005f5d014f..143fc53061fe 100644
--- a/lib/libcflat.h
+++ b/lib/libcflat.h
@@ -33,6 +33,12 @@
 #define __ALIGN_MASK(x, mask)	(((x) + (mask)) & ~(mask))
 #define __ALIGN(x, a)		__ALIGN_MASK(x, (typeof(x))(a) - 1)
 #define ALIGN(x, a)		__ALIGN((x), (a))
+#define IS_ALIGNED(x, a)	(((x) & ((typeof(x))(a) - 1)) == 0)
+
+#define SZ_4K			(0x1000)
+#define SZ_64K			(0x10000)
+#define SZ_2M			(0x200000)
+#define SZ_1G			(0x40000000)
 
 typedef uint8_t		u8;
 typedef int8_t		s8;
-- 
2.7.4

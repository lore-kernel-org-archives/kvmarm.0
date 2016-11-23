From: Andrew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH v7 08/11] libcflat: add IS_ALIGNED() macro,
 and page sizes
Date: Wed, 23 Nov 2016 17:54:03 +0100
Message-ID: <20161123165406.32661-9-drjones@redhat.com>
References: <20161123165406.32661-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D3DC240C5B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Nov 2016 11:53:52 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2NamQu9J1vNs for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Nov 2016 11:53:52 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 73A1C40D44
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Nov 2016 11:53:51 -0500 (EST)
In-Reply-To: <20161123165406.32661-1-drjones@redhat.com>
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

Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
[drew: also added SZ_64K and changed to shifts]
Signed-off-by: Andrew Jones <drjones@redhat.com>

---
v6: change to shifts [Alex]
---
 lib/libcflat.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/lib/libcflat.h b/lib/libcflat.h
index c3fa4f24c499..bdcc561ccafd 100644
--- a/lib/libcflat.h
+++ b/lib/libcflat.h
@@ -33,6 +33,12 @@
 #define __ALIGN_MASK(x, mask)	(((x) + (mask)) & ~(mask))
 #define __ALIGN(x, a)		__ALIGN_MASK(x, (typeof(x))(a) - 1)
 #define ALIGN(x, a)		__ALIGN((x), (a))
+#define IS_ALIGNED(x, a)	(((x) & ((typeof(x))(a) - 1)) == 0)
+
+#define SZ_4K			(1 << 12)
+#define SZ_64K			(1 << 16)
+#define SZ_2M			(1 << 21)
+#define SZ_1G			(1 << 30)
 
 typedef uint8_t		u8;
 typedef int8_t		s8;
-- 
2.9.3

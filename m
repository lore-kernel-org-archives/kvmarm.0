From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH kvm-unit-tests v8 07/10] libcflat: add IS_ALIGNED() macro, and page sizes
Date: Thu,  8 Dec 2016 18:50:27 +0100
Message-ID: <20161208175030.12269-8-drjones@redhat.com>
References: <20161208175030.12269-1-drjones@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20161208175030.12269-1-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peter.maydell@linaro.org, marc.zyngier@arm.com, andre.przywara@arm.com, eric.auger@redhat.com, pbonzini@redhat.com, alex.bennee@linaro.org, christoffer.dall@linaro.org, Peter Xu <peterx@redhat.com>
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
index 15dbcadc6c7a..e636705e12b3 100644
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


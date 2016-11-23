From: Andrew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH v7 01/11] lib: xstr: allow multiple args
Date: Wed, 23 Nov 2016 17:53:56 +0100
Message-ID: <20161123165406.32661-2-drjones@redhat.com>
References: <20161123165406.32661-1-drjones@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20161123165406.32661-1-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peter.maydell@linaro.org, marc.zyngier@arm.com, andre.przywara@arm.com, eric.auger@redhat.com, pbonzini@redhat.com, alex.bennee@linaro.org, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Make implementation equivalent to Linux's include/linux/stringify.h

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 lib/libcflat.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/libcflat.h b/lib/libcflat.h
index c622198677c1..c3fa4f24c499 100644
--- a/lib/libcflat.h
+++ b/lib/libcflat.h
@@ -27,8 +27,8 @@
 
 #define __unused __attribute__((__unused__))
 
-#define xstr(s) xxstr(s)
-#define xxstr(s) #s
+#define xstr(s...) xxstr(s)
+#define xxstr(s...) #s
 
 #define __ALIGN_MASK(x, mask)	(((x) + (mask)) & ~(mask))
 #define __ALIGN(x, a)		__ALIGN_MASK(x, (typeof(x))(a) - 1)
-- 
2.9.3


From: Andrew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH 01/10] lib: xstr: allow multiple args
Date: Mon, 16 May 2016 09:57:15 +0200
Message-ID: <1463385444-12916-2-git-send-email-drjones@redhat.com>
References: <1463385444-12916-1-git-send-email-drjones@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1463385444-12916-1-git-send-email-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, qemu-arm@nongnu.org, andre.przywara@arm.com, peter.maydell@linaro.org, alex.bennee@linaro.org
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 lib/libcflat.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/libcflat.h b/lib/libcflat.h
index df50615b43666..ba29041b731e2 100644
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
2.4.11


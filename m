From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 10/12] check for and use C library provided strlcpy and strlcat
Date: Fri, 17 Jul 2015 17:02:16 +0100
Message-ID: <1437148938-5394-11-git-send-email-andre.przywara@arm.com>
References: <1437148938-5394-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3576158CC3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2015 11:50:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R5ybmCOle++G for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jul 2015 11:50:34 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD67C58CCB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2015 11:50:31 -0400 (EDT)
In-Reply-To: <1437148938-5394-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: will.deacon@arm.com, kvm@vger.kernel.org
Cc: Szabolcs.Nagy@arm.com, marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

The musl-libc library provides implementations of strlcpy and strlcat,
so introduce a feature check for it and only use the kvmtool
implementation if there is no library support for it.
This avoids clashes with the public definition.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 Makefile                 |  5 +++++
 config/feature-tests.mak | 10 ++++++++++
 include/kvm/strbuf.h     |  2 ++
 util/strbuf.c            |  2 ++
 4 files changed, 19 insertions(+)

diff --git a/Makefile b/Makefile
index 46e4a9d..285c482 100644
--- a/Makefile
+++ b/Makefile
@@ -199,6 +199,11 @@ endif
 # On a given system, some libs may link statically, some may not; so, check
 # both and only build those that link!
 
+ifeq ($(call try-build,$(SOURCE_STRLCPY),$(CFLAGS),),y)
+	CFLAGS_DYNOPT	+= -DHAVE_STRLCPY
+	CFLAGS_STATOPT	+= -DHAVE_STRLCPY
+endif
+
 ifeq ($(call try-build,$(SOURCE_BFD),$(CFLAGS),-lbfd -static),y)
 	CFLAGS_STATOPT	+= -DCONFIG_HAS_BFD
 	OBJS_STATOPT	+= symbol.o
diff --git a/config/feature-tests.mak b/config/feature-tests.mak
index 6bee6c2..03cdb42 100644
--- a/config/feature-tests.mak
+++ b/config/feature-tests.mak
@@ -196,3 +196,13 @@ int main(void)
 	return 0;
 }
 endef
+
+define SOURCE_STRLCPY
+#include <string.h>
+
+int main(void)
+{
+	strlcpy(NULL, NULL, 0);
+	return 0;
+}
+endef
diff --git a/include/kvm/strbuf.h b/include/kvm/strbuf.h
index 2beefbc..7657339 100644
--- a/include/kvm/strbuf.h
+++ b/include/kvm/strbuf.h
@@ -6,8 +6,10 @@
 
 int prefixcmp(const char *str, const char *prefix);
 
+#ifndef HAVE_STRLCPY
 extern size_t strlcat(char *dest, const char *src, size_t count);
 extern size_t strlcpy(char *dest, const char *src, size_t size);
+#endif
 
 /* some inline functions */
 
diff --git a/util/strbuf.c b/util/strbuf.c
index 99d6b0c..2c6e8ad 100644
--- a/util/strbuf.c
+++ b/util/strbuf.c
@@ -13,6 +13,7 @@ int prefixcmp(const char *str, const char *prefix)
 	}
 }
 
+#ifndef HAVE_STRLCPY
 /**
  * strlcat - Append a length-limited, %NUL-terminated string to another
  * @dest: The string to be appended to
@@ -60,3 +61,4 @@ size_t strlcpy(char *dest, const char *src, size_t size)
 	}
 	return ret;
 }
+#endif
-- 
2.3.5

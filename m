From: Julien Thierry <julien.thierry@arm.com>
Subject: [kvmtool PATCH 1/2] Makefile: fix skipped dependencies
Date: Fri, 13 Jul 2018 09:04:03 +0100
Message-ID: <1531469044-5718-2-git-send-email-julien.thierry@arm.com>
References: <1531469044-5718-1-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 451374A10C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Jul 2018 03:51:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6ajfAjInKOOW for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Jul 2018 03:51:28 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E5834A0D1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Jul 2018 03:51:28 -0400 (EDT)
In-Reply-To: <1531469044-5718-1-git-send-email-julien.thierry@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: andre.przywara@arm.com, will.deacon@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

For some optional dependencies, both static and dynamic linking is tested.
But if the first one being tested fails, the dependency is added to the
NOTFOUND list and reported as being skipped while it might still be built
with another linkage.

Add optional dependencies to NOTFOUND only if both linkage are invalid.

Signed-off-by: Julien Thierry <julien.thierry@arm.com>
---
 Makefile | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/Makefile b/Makefile
index dfa0b62..d535204 100644
--- a/Makefile
+++ b/Makefile
@@ -254,22 +254,24 @@ ifeq ($(call try-build,$(SOURCE_ZLIB),$(CFLAGS),$(LDFLAGS) -lz),y)
 	CFLAGS_DYNOPT	+= -DCONFIG_HAS_ZLIB
 	LIBS_DYNOPT	+= -lz
 else
-	NOTFOUND	+= zlib
-endif
-ifeq ($(call try-build,$(SOURCE_ZLIB),$(CFLAGS),$(LDFLAGS) -lz -static),y)
-	CFLAGS_STATOPT	+= -DCONFIG_HAS_ZLIB
-	LIBS_STATOPT	+= -lz
+	ifeq ($(call try-build,$(SOURCE_ZLIB),$(CFLAGS),$(LDFLAGS) -lz -static),y)
+		CFLAGS_STATOPT	+= -DCONFIG_HAS_ZLIB
+		LIBS_STATOPT	+= -lz
+	else
+		NOTFOUND	+= zlib
+	endif
 endif
 
 ifeq ($(call try-build,$(SOURCE_AIO),$(CFLAGS),$(LDFLAGS) -laio),y)
 	CFLAGS_DYNOPT	+= -DCONFIG_HAS_AIO
 	LIBS_DYNOPT	+= -laio
 else
-	NOTFOUND	+= aio
-endif
-ifeq ($(call try-build,$(SOURCE_AIO),$(CFLAGS),$(LDFLAGS) -laio -static),y)
-	CFLAGS_STATOPT	+= -DCONFIG_HAS_AIO
-	LIBS_STATOPT	+= -laio
+	ifeq ($(call try-build,$(SOURCE_AIO),$(CFLAGS),$(LDFLAGS) -laio -static),y)
+		CFLAGS_STATOPT	+= -DCONFIG_HAS_AIO
+		LIBS_STATOPT	+= -laio
+	else
+		NOTFOUND	+= aio
+	endif
 endif
 
 ifeq ($(LTO),1)
-- 
1.9.1

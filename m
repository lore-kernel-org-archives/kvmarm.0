From: Julien Thierry <julien.thierry@arm.com>
Subject: [kvmtool PATCH 2/2] Makefile: Try dynamic linkage for bfd
Date: Fri, 13 Jul 2018 09:04:04 +0100
Message-ID: <1531469044-5718-3-git-send-email-julien.thierry@arm.com>
References: <1531469044-5718-1-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 78EE94A0E7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Jul 2018 03:51:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xFbw3yceqQNr for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Jul 2018 03:51:29 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 727624A109
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Jul 2018 03:51:29 -0400 (EDT)
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

On Debian Stretch/Ubuntu 14.04, the libbfd provided by libbfd-dev or
binutils-dev packages does not like being linked statically.

Add a dynamic linkage test when detecting libbfd.

Signed-off-by: Julien Thierry <julien.thierry@arm.com>
---
 Makefile | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index d535204..c4faff6 100644
--- a/Makefile
+++ b/Makefile
@@ -209,7 +209,13 @@ ifeq ($(call try-build,$(SOURCE_BFD),$(CFLAGS),$(LDFLAGS) -lbfd -static),y)
 	OBJS_STATOPT	+= symbol.o
 	LIBS_STATOPT	+= -lbfd
 else
-	NOTFOUND	+= bfd
+	ifeq ($(call try-build,$(SOURCE_BFD),$(CFLAGS),$(LDFLAGS) -lbfd),y)
+		CFLAGS_DYNOPT	+= -DCONFIG_HAS_BFD
+		OBJS_DYNOPT	+= symbol.o
+		LIBS_DYNOPT	+= -lbfd
+	else
+		NOTFOUND	+= bfd
+	endif
 endif
 
 ifeq (y,$(ARCH_HAS_FRAMEBUFFER))
-- 
1.9.1

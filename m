From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 09/12] use <poll.h> instead of <sys/poll.h>
Date: Fri, 17 Jul 2015 17:02:15 +0100
Message-ID: <1437148938-5394-10-git-send-email-andre.przywara@arm.com>
References: <1437148938-5394-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1437148938-5394-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: will.deacon@arm.com, kvm@vger.kernel.org
Cc: Szabolcs.Nagy@arm.com, marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

The manpage of poll(2) states that the prototype of poll is defined
in <poll.h>. Use that header file instead of <sys/poll.h> to allow
compilation against musl-libc.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 disk/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/disk/core.c b/disk/core.c
index 309e16c..dd2f258 100644
--- a/disk/core.c
+++ b/disk/core.c
@@ -5,7 +5,7 @@
 
 #include <linux/err.h>
 #include <sys/eventfd.h>
-#include <sys/poll.h>
+#include <poll.h>
 
 #define AIO_MAX 256
 
-- 
2.3.5


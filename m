From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 07/12] util/util.c: avoid clang error on vsnprintf
Date: Fri, 17 Jul 2015 17:02:13 +0100
Message-ID: <1437148938-5394-8-git-send-email-andre.przywara@arm.com>
References: <1437148938-5394-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1437148938-5394-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: will.deacon@arm.com, kvm@vger.kernel.org
Cc: Szabolcs.Nagy@arm.com, marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

clang by default doesn't seem to like printf calls with non-literal
format strings.
Add the proper pragma to disable this warning in the report function
to make kvmtool compile with clang. Despite its GCC name, clang also
accepts this.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 util/util.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/util/util.c b/util/util.c
index 1877105..825da3f 100644
--- a/util/util.c
+++ b/util/util.c
@@ -10,6 +10,7 @@
 #include <sys/stat.h>
 #include <sys/statfs.h>
 
+#pragma GCC diagnostic ignored "-Wformat-nonliteral"
 static void report(const char *prefix, const char *err, va_list params)
 {
 	char msg[1024];
-- 
2.3.5


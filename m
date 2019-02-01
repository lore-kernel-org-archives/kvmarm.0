From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v2 2/4] Makefile: support -s switch
Date: Fri,  1 Feb 2019 12:37:14 +0000
Message-ID: <20190201123716.92901-3-andre.przywara@arm.com>
References: <20190201123716.92901-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C5674A369
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Feb 2019 07:37:25 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id po6TezOehvig for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Feb 2019 07:37:24 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 314A74A3A6
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Feb 2019 07:37:24 -0500 (EST)
In-Reply-To: <20190201123716.92901-1-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

"make -s" suppresses normal output, just shows warnings and errors.
But since we explicitly override the make output with our fancy concise
version, we miss out on this feature.

Do as the kernel does and explicitly suppress every normal output when -s
is given. This helps to spot warnings that scroll out of the terminal
window too quickly.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 Makefile | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index c4faff66..ec75cd99 100644
--- a/Makefile
+++ b/Makefile
@@ -3,7 +3,11 @@
 #
 
 ifeq ($(strip $(V)),)
-	E = @echo
+	ifeq ($(findstring s,$(filter-out --%,$(MAKEFLAGS))),)
+		E = @echo
+	else
+		E = @\#
+	endif
 	Q = @
 else
 	E = @\#
-- 
2.17.1

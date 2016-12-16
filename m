From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 08/13] arm/arm64: xen: avoid gcc-4.4 warning
Date: Fri, 16 Dec 2016 11:56:29 +0100
Message-ID: <20161216105634.235457-9-arnd@arndb.de>
References: <20161216105634.235457-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F3FB7404AC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Dec 2016 05:55:40 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wjNjtqlsnUdK for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Dec 2016 05:55:40 -0500 (EST)
Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B3B4D405D5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Dec 2016 05:55:39 -0500 (EST)
In-Reply-To: <20161216105634.235457-1-arnd@arndb.de>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arch@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, kernel-build-reports@lists.linaro.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Ancient gcc doesn't know about __builtin_unreachable(), causing
lots of instances of a harmless warning:

include/xen/arm/page.h: In function 'arbitrary_virt_to_machine':
include/xen/arm/page.h:85: warning: no return statement in function returning non-void

Adding a return statement doesn't change the behavior here, but
shuts up that warning.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/xen/arm/page.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/xen/arm/page.h b/include/xen/arm/page.h
index 415dbc6e43fd..2485013e3c6f 100644
--- a/include/xen/arm/page.h
+++ b/include/xen/arm/page.h
@@ -82,6 +82,7 @@ static inline unsigned long bfn_to_pfn(unsigned long bfn)
 static inline xmaddr_t arbitrary_virt_to_machine(void *vaddr)
 {
 	BUG();
+	return XMADDR(0);
 }
 
 /* TODO: this shouldn't be here but it is because the frontend drivers
-- 
2.9.0

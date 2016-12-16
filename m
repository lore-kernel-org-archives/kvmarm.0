From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 06/13] ARM: atomic: fix gcc-4.4 build
Date: Fri, 16 Dec 2016 11:56:27 +0100
Message-ID: <20161216105634.235457-7-arnd@arndb.de>
References: <20161216105634.235457-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F037405D2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Dec 2016 05:55:40 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0gPYrNK6JPfS for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Dec 2016 05:55:39 -0500 (EST)
Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3D5DA404EF
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

gcc-4.4 fails to build some files with this constraint, which was
added to help out with gcc-4.6 and higher:

fs/btrfs/delayed-ref.c: In function 'add_delayed_tree_ref':
arch/arm/include/asm/atomic.h:280: error: 'asm' operand requires impossible reload

Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=44492
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/include/asm/atomic.h | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/atomic.h b/arch/arm/include/asm/atomic.h
index 66d0e215a773..65d5b843831a 100644
--- a/arch/arm/include/asm/atomic.h
+++ b/arch/arm/include/asm/atomic.h
@@ -280,7 +280,10 @@ static inline long long atomic64_read(const atomic64_t *v)
 	__asm__ __volatile__("@ atomic64_read\n"
 "	ldrd	%0, %H0, [%1]"
 	: "=&r" (result)
-	: "r" (&v->counter), "Qo" (v->counter)
+	: "r" (&v->counter)
+#if GCC_VERSION >= 40600
+	, "Qo" (v->counter)
+#endif
 	);
 
 	return result;
@@ -302,7 +305,10 @@ static inline long long atomic64_read(const atomic64_t *v)
 	__asm__ __volatile__("@ atomic64_read\n"
 "	ldrexd	%0, %H0, [%1]"
 	: "=&r" (result)
-	: "r" (&v->counter), "Qo" (v->counter)
+	: "r" (&v->counter)
+#if GCC_VERSION >= 40600
+	, "Qo" (v->counter)
+#endif
 	);
 
 	return result;
-- 
2.9.0

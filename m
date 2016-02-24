From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 2/4] pre_init: x86/init64.S: use defines for syscall numbers
Date: Wed, 24 Feb 2016 15:33:06 +0000
Message-ID: <1456327988-31568-3-git-send-email-andre.przywara@arm.com>
References: <1456327988-31568-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DA864965E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Feb 2016 10:26:37 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LE-Ue-8HhSEP for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Feb 2016 10:26:33 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 97749412F3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Feb 2016 10:26:33 -0500 (EST)
In-Reply-To: <1456327988-31568-1-git-send-email-andre.przywara@arm.com>
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
Cc: Oleg Nesterov <oleg@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Instead of hardcoding the syscall numbers and providing the symbol
in the comments, just include <asm/unistd.h> and use the symbol
directly.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 x86/init64.S | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/x86/init64.S b/x86/init64.S
index 488a93f..1a7c40f 100644
--- a/x86/init64.S
+++ b/x86/init64.S
@@ -1,3 +1,11 @@
+/*
+ * #!/bin/sh
+ * mount -t 9p -o trans=virtio,version=9p2000.L hostfs /host
+ * /virt/init $*
+ */
+
+#include <asm/unistd.h>
+
 .data
 
 .m_dev:
@@ -16,7 +24,7 @@
 .globl _start
 _start:
 
-	mov $165, %rax		# __NR_mount
+	mov $__NR_mount, %rax
 	mov $.m_dev, %rdi
 	mov $.m_dir, %rsi
 	mov $.m_typ, %rdx
@@ -24,7 +32,7 @@ _start:
 	mov $.m_opt, %r8
 	syscall
 
-	mov $59, %rax		# __NR_execve
+	mov $__NR_execve, %rax
 	mov $.e_nam, %rdi
 	lea 8(%rsp), %rsi	# argv[]
 	mov %rdi, (%rsi)	# change argv[0]
@@ -33,6 +41,6 @@ _start:
 	lea (%rsi,%rcx,8), %rdx # envp[]
 	syscall
 
-	mov $60, %rax		# __NR_exit
+	mov $__NR_exit, %rax
 	mov $1, %rdi
 	syscall			# panic
-- 
2.6.4

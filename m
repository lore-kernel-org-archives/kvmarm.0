From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 12/14] powerpc: use read_file() in kernel and initrd loading
Date: Thu, 30 Jul 2015 11:52:29 +0100
Message-ID: <1438253551-2378-13-git-send-email-andre.przywara@arm.com>
References: <1438253551-2378-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A5E365971B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2015 06:40:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5HHZbeov77tx for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jul 2015 06:40:11 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8306059709
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2015 06:40:10 -0400 (EDT)
In-Reply-To: <1438253551-2378-1-git-send-email-andre.przywara@arm.com>
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
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, kvm-ppc@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Replace the unsafe read-loops in the powerpc kernel image loading
function with our new and safe read_file() wrapper.
This should fix random fails in kernel image loading, especially
from pipes and sockets.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 powerpc/kvm.c | 36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

diff --git a/powerpc/kvm.c b/powerpc/kvm.c
index 87d0f9e..9888bf1 100644
--- a/powerpc/kvm.c
+++ b/powerpc/kvm.c
@@ -162,16 +162,19 @@ bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
 {
 	void *p;
 	void *k_start;
-	void *i_start;
-	int nr;
+	ssize_t filesize;
 
 	p = k_start = guest_flat_to_host(kvm, KERNEL_LOAD_ADDR);
 
-	while ((nr = read(fd_kernel, p, 65536)) > 0)
-		p += nr;
-
-	pr_info("Loaded kernel to 0x%x (%ld bytes)", KERNEL_LOAD_ADDR, (long)(p-k_start));
+	filesize = read_file(fd_kernel, p, INITRD_LOAD_ADDR - KERNEL_LOAD_ADDR);
+	if (filesize < 0) {
+		if (errno == ENOMEM)
+			die("Kernel overlaps initrd!");
 
+		die_perror("kernel read");
+	}
+	pr_info("Loaded kernel to 0x%x (%ld bytes)", KERNEL_LOAD_ADDR,
+		filesize);
 	if (fd_initrd != -1) {
 		if (lseek(fd_initrd, 0, SEEK_SET) < 0)
 			die_perror("lseek");
@@ -180,19 +183,20 @@ bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
 			die("Kernel overlaps initrd!");
 
 		/* Round up kernel size to 8byte alignment, and load initrd right after. */
-		i_start = p = guest_flat_to_host(kvm, INITRD_LOAD_ADDR);
-
-		while (((nr = read(fd_initrd, p, 65536)) > 0) &&
-		       p < (kvm->ram_start + kvm->ram_size))
-			p += nr;
-
-		if (p >= (kvm->ram_start + kvm->ram_size))
-			die("initrd too big to contain in guest RAM.\n");
+		p = guest_flat_to_host(kvm, INITRD_LOAD_ADDR);
+
+		filesize = read_file(fd_initrd, p,
+			       (kvm->ram_start + kvm->ram_size) - p);
+		if (filesize < 0) {
+			if (errno == ENOMEM)
+				die("initrd too big to contain in guest RAM.\n");
+			die_perror("initrd read");
+		}
 
 		pr_info("Loaded initrd to 0x%x (%ld bytes)",
-			INITRD_LOAD_ADDR, (long)(p-i_start));
+			INITRD_LOAD_ADDR, filesize);
 		kvm->arch.initrd_gra = INITRD_LOAD_ADDR;
-		kvm->arch.initrd_size = p-i_start;
+		kvm->arch.initrd_size = filesize;
 	} else {
 		kvm->arch.initrd_size = 0;
 	}
-- 
2.3.5

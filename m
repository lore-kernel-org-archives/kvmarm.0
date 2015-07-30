From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 14/14] x86: use read wrappers in kernel loading
Date: Thu, 30 Jul 2015 11:52:31 +0100
Message-ID: <1438253551-2378-15-git-send-email-andre.przywara@arm.com>
References: <1438253551-2378-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E50459745
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2015 06:40:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WyWCAecMiLaT for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jul 2015 06:40:15 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F8A959709
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2015 06:40:13 -0400 (EDT)
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

Replace the unsafe read-loops in the x86 kernel image loading
functions with our safe read_file() and read_in_full() wrappers.
This should fix random fails in kernel image loading, especially
from pipes and sockets.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 x86/kvm.c | 40 +++++++++++++++++++---------------------
 1 file changed, 19 insertions(+), 21 deletions(-)

diff --git a/x86/kvm.c b/x86/kvm.c
index 9817953..8cf4ec6 100644
--- a/x86/kvm.c
+++ b/x86/kvm.c
@@ -9,6 +9,7 @@
 
 #include <asm/bootparam.h>
 #include <linux/kvm.h>
+#include <linux/kernel.h>
 
 #include <sys/types.h>
 #include <sys/ioctl.h>
@@ -209,15 +210,14 @@ static inline void *guest_real_to_host(struct kvm *kvm, u16 selector, u16 offset
 static bool load_flat_binary(struct kvm *kvm, int fd_kernel, void *buf, int len)
 {
 	void *p;
-	int nr;
 
 	p = guest_real_to_host(kvm, BOOT_LOADER_SELECTOR, BOOT_LOADER_IP);
 
 	memcpy(p, buf, len);
 	p += len;
 
-	while ((nr = read(fd_kernel, p, 65536)) > 0)
-		p += nr;
+	if (read_file(fd_kernel, p, kvm->cfg.ram_size) < 0)
+		die_perror("read");
 
 	kvm->arch.boot_selector	= BOOT_LOADER_SELECTOR;
 	kvm->arch.boot_ip	= BOOT_LOADER_IP;
@@ -232,11 +232,9 @@ static bool load_bzimage(struct kvm *kvm, int fd_kernel, int fd_initrd,
 			 const char *kernel_cmdline, struct boot_params *boot)
 {
 	struct boot_params *kern_boot;
-	unsigned long setup_sects;
 	size_t cmdline_size;
-	ssize_t setup_size;
+	ssize_t file_size;
 	void *p;
-	int nr;
 	u16 vidmode;
 
 	/*
@@ -250,25 +248,26 @@ static bool load_bzimage(struct kvm *kvm, int fd_kernel, int fd_initrd,
 	if (boot->hdr.version < BOOT_PROTOCOL_REQUIRED)
 		die("Too old kernel");
 
+	/* read real-mode setup.bin to boot loader address */
+	p = guest_real_to_host(kvm, BOOT_LOADER_SELECTOR, BOOT_LOADER_IP);
 	if (!boot->hdr.setup_sects)
 		boot->hdr.setup_sects = BZ_DEFAULT_SETUP_SECTS;
-	setup_sects = boot->hdr.setup_sects + 1;
-
-	setup_size = setup_sects << 9;
-	p = guest_real_to_host(kvm, BOOT_LOADER_SELECTOR, BOOT_LOADER_IP);
+	file_size = (boot->hdr.setup_sects + 1) << 9;
 
-	/* copy setup.bin to mem */
+	/* copy in the part already read earlier from the file */
 	memcpy(p, boot, sizeof(struct boot_params));
 	p += sizeof(struct boot_params);
-	setup_size -= sizeof(struct boot_params);
-	if (read(fd_kernel, p, setup_size) != setup_size)
-		die_perror("read");
+	file_size -= sizeof(struct boot_params);
 
-	/* copy vmlinux.bin to BZ_KERNEL_START*/
-	p = guest_flat_to_host(kvm, BZ_KERNEL_START);
+	if (read_in_full(fd_kernel, p, file_size) != file_size)
+		die_perror("kernel setup read");
 
-	while ((nr = read(fd_kernel, p, 65536)) > 0)
-		p += nr;
+	/* read actual kernel image (vmlinux.bin) to BZ_KERNEL_START */
+	p = guest_flat_to_host(kvm, BZ_KERNEL_START);
+	file_size = read_file(fd_kernel, p,
+			      kvm->cfg.ram_size - BZ_KERNEL_START);
+	if (file_size < 0)
+		die_perror("kernel read");
 
 	p = guest_flat_to_host(kvm, BOOT_CMDLINE_OFFSET);
 	if (kernel_cmdline) {
@@ -319,8 +318,7 @@ static bool load_bzimage(struct kvm *kvm, int fd_kernel, int fd_initrd,
 		}
 
 		p = guest_flat_to_host(kvm, addr);
-		nr = read(fd_initrd, p, initrd_stat.st_size);
-		if (nr != initrd_stat.st_size)
+		if (read_in_full(fd_initrd, p, initrd_stat.st_size) < 0)
 			die("Failed to read initrd");
 
 		kern_boot->hdr.ramdisk_image	= addr;
@@ -343,7 +341,7 @@ bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
 {
 	struct boot_params boot;
 
-	if (read(fd_kernel, &boot, sizeof(boot)) != sizeof(boot))
+	if (read_in_full(fd_kernel, &boot, sizeof(boot)) != sizeof(boot))
 		return false;
 
 	if (load_bzimage(kvm, fd_kernel, fd_initrd, kernel_cmdline, &boot))
-- 
2.3.5

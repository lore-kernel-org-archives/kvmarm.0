From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 5/7] x86: use read wrappers in kernel loading
Date: Fri, 30 Oct 2015 18:26:58 +0000
Message-ID: <1446229620-28088-6-git-send-email-andre.przywara@arm.com>
References: <1446229620-28088-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1446229620-28088-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: will.deacon@arm.com, kvm@vger.kernel.org
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm-ppc@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Replace the unsafe read-loops in the x86 kernel image loading
functions with our safe read_file() and read_in_full() wrappers.
This should fix random fails in kernel image loading, especially
from pipes and sockets.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 x86/kvm.c | 35 ++++++++++++++---------------------
 1 file changed, 14 insertions(+), 21 deletions(-)

diff --git a/x86/kvm.c b/x86/kvm.c
index a0204b8..ae430a0 100644
--- a/x86/kvm.c
+++ b/x86/kvm.c
@@ -9,6 +9,7 @@
 
 #include <asm/bootparam.h>
 #include <linux/kvm.h>
+#include <linux/kernel.h>
 
 #include <sys/types.h>
 #include <sys/ioctl.h>
@@ -209,15 +210,14 @@ static inline void *guest_real_to_host(struct kvm *kvm, u16 selector, u16 offset
 static bool load_flat_binary(struct kvm *kvm, int fd_kernel)
 {
 	void *p;
-	int nr;
 
 	if (lseek(fd_kernel, 0, SEEK_SET) < 0)
 		die_perror("lseek");
 
 	p = guest_real_to_host(kvm, BOOT_LOADER_SELECTOR, BOOT_LOADER_IP);
 
-	while ((nr = read(fd_kernel, p, 65536)) > 0)
-		p += nr;
+	if (read_file(fd_kernel, p, kvm->cfg.ram_size) < 0)
+		die_perror("read");
 
 	kvm->arch.boot_selector	= BOOT_LOADER_SELECTOR;
 	kvm->arch.boot_ip	= BOOT_LOADER_IP;
@@ -232,12 +232,10 @@ static bool load_bzimage(struct kvm *kvm, int fd_kernel, int fd_initrd,
 			 const char *kernel_cmdline)
 {
 	struct boot_params *kern_boot;
-	unsigned long setup_sects;
 	struct boot_params boot;
 	size_t cmdline_size;
-	ssize_t setup_size;
+	ssize_t file_size;
 	void *p;
-	int nr;
 	u16 vidmode;
 
 	/*
@@ -248,7 +246,7 @@ static bool load_bzimage(struct kvm *kvm, int fd_kernel, int fd_initrd,
 	if (lseek(fd_kernel, 0, SEEK_SET) < 0)
 		die_perror("lseek");
 
-	if (read(fd_kernel, &boot, sizeof(boot)) != sizeof(boot))
+	if (read_in_full(fd_kernel, &boot, sizeof(boot)) != sizeof(boot))
 		return false;
 
 	if (memcmp(&boot.hdr.header, BZIMAGE_MAGIC, strlen(BZIMAGE_MAGIC)))
@@ -262,20 +260,17 @@ static bool load_bzimage(struct kvm *kvm, int fd_kernel, int fd_initrd,
 
 	if (!boot.hdr.setup_sects)
 		boot.hdr.setup_sects = BZ_DEFAULT_SETUP_SECTS;
-	setup_sects = boot.hdr.setup_sects + 1;
-
-	setup_size = setup_sects << 9;
+	file_size = (boot.hdr.setup_sects + 1) << 9;
 	p = guest_real_to_host(kvm, BOOT_LOADER_SELECTOR, BOOT_LOADER_IP);
+	if (read_in_full(fd_kernel, p, file_size) != file_size)
+		die_perror("kernel setup read");
 
-	/* copy setup.bin to mem*/
-	if (read(fd_kernel, p, setup_size) != setup_size)
-		die_perror("read");
-
-	/* copy vmlinux.bin to BZ_KERNEL_START*/
+	/* read actual kernel image (vmlinux.bin) to BZ_KERNEL_START */
 	p = guest_flat_to_host(kvm, BZ_KERNEL_START);
-
-	while ((nr = read(fd_kernel, p, 65536)) > 0)
-		p += nr;
+	file_size = read_file(fd_kernel, p,
+			      kvm->cfg.ram_size - BZ_KERNEL_START);
+	if (file_size < 0)
+		die_perror("kernel read");
 
 	p = guest_flat_to_host(kvm, BOOT_CMDLINE_OFFSET);
 	if (kernel_cmdline) {
@@ -287,7 +282,6 @@ static bool load_bzimage(struct kvm *kvm, int fd_kernel, int fd_initrd,
 		memcpy(p, kernel_cmdline, cmdline_size - 1);
 	}
 
-
 	/* vidmode should be either specified or set by default */
 	if (kvm->cfg.vnc || kvm->cfg.sdl || kvm->cfg.gtk) {
 		if (!kvm->cfg.arch.vidmode)
@@ -326,8 +320,7 @@ static bool load_bzimage(struct kvm *kvm, int fd_kernel, int fd_initrd,
 		}
 
 		p = guest_flat_to_host(kvm, addr);
-		nr = read(fd_initrd, p, initrd_stat.st_size);
-		if (nr != initrd_stat.st_size)
+		if (read_in_full(fd_initrd, p, initrd_stat.st_size) < 0)
 			die("Failed to read initrd");
 
 		kern_boot->hdr.ramdisk_image	= addr;
-- 
2.5.1


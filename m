From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 04/14] x86: support loading flat binary kernel images from a
 pipe
Date: Thu, 30 Jul 2015 11:52:21 +0100
Message-ID: <1438253551-2378-5-git-send-email-andre.przywara@arm.com>
References: <1438253551-2378-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E189659676
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2015 06:39:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id W5Wh-G3veheQ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jul 2015 06:39:59 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 87FAD596B8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2015 06:39:58 -0400 (EDT)
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

With the latest patches we allow loading bzImage kernels from a pipe,
but we still fail on "flat binary" images.
Rework the loading routines to take memory buffers for the beginning
of the file, so we don't need to rewind the image.
This allows to fall back to flat binary loading if bzImage fails
without using a seek, so kvmtool will happily accept any file
descriptor (including pipes) for the image file.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 x86/kvm.c | 48 +++++++++++++++++++++++++-----------------------
 1 file changed, 25 insertions(+), 23 deletions(-)

diff --git a/x86/kvm.c b/x86/kvm.c
index 8fe5585..9817953 100644
--- a/x86/kvm.c
+++ b/x86/kvm.c
@@ -206,16 +206,16 @@ static inline void *guest_real_to_host(struct kvm *kvm, u16 selector, u16 offset
 	return guest_flat_to_host(kvm, flat);
 }
 
-static bool load_flat_binary(struct kvm *kvm, int fd_kernel)
+static bool load_flat_binary(struct kvm *kvm, int fd_kernel, void *buf, int len)
 {
 	void *p;
 	int nr;
 
-	if (lseek(fd_kernel, 0, SEEK_SET) < 0)
-		die_perror("lseek");
-
 	p = guest_real_to_host(kvm, BOOT_LOADER_SELECTOR, BOOT_LOADER_IP);
 
+	memcpy(p, buf, len);
+	p += len;
+
 	while ((nr = read(fd_kernel, p, 65536)) > 0)
 		p += nr;
 
@@ -229,11 +229,10 @@ static bool load_flat_binary(struct kvm *kvm, int fd_kernel)
 static const char *BZIMAGE_MAGIC = "HdrS";
 
 static bool load_bzimage(struct kvm *kvm, int fd_kernel, int fd_initrd,
-			 const char *kernel_cmdline)
+			 const char *kernel_cmdline, struct boot_params *boot)
 {
 	struct boot_params *kern_boot;
 	unsigned long setup_sects;
-	struct boot_params boot;
 	size_t cmdline_size;
 	ssize_t setup_size;
 	void *p;
@@ -245,26 +244,23 @@ static bool load_bzimage(struct kvm *kvm, int fd_kernel, int fd_initrd,
 	 * memory layout.
 	 */
 
-	if (read(fd_kernel, &boot, sizeof(boot)) != sizeof(boot))
-		return false;
-
-	if (memcmp(&boot.hdr.header, BZIMAGE_MAGIC, strlen(BZIMAGE_MAGIC)))
+	if (memcmp(&boot->hdr.header, BZIMAGE_MAGIC, strlen(BZIMAGE_MAGIC)))
 		return false;
 
-	if (boot.hdr.version < BOOT_PROTOCOL_REQUIRED)
+	if (boot->hdr.version < BOOT_PROTOCOL_REQUIRED)
 		die("Too old kernel");
 
-	if (!boot.hdr.setup_sects)
-		boot.hdr.setup_sects = BZ_DEFAULT_SETUP_SECTS;
-	setup_sects = boot.hdr.setup_sects + 1;
+	if (!boot->hdr.setup_sects)
+		boot->hdr.setup_sects = BZ_DEFAULT_SETUP_SECTS;
+	setup_sects = boot->hdr.setup_sects + 1;
 
 	setup_size = setup_sects << 9;
 	p = guest_real_to_host(kvm, BOOT_LOADER_SELECTOR, BOOT_LOADER_IP);
 
 	/* copy setup.bin to mem */
-	memcpy(p, &boot, sizeof(boot));
-	p += sizeof(boot);
-	setup_size -= sizeof(boot);
+	memcpy(p, boot, sizeof(struct boot_params));
+	p += sizeof(struct boot_params);
+	setup_size -= sizeof(struct boot_params);
 	if (read(fd_kernel, p, setup_size) != setup_size)
 		die_perror("read");
 
@@ -277,10 +273,10 @@ static bool load_bzimage(struct kvm *kvm, int fd_kernel, int fd_initrd,
 	p = guest_flat_to_host(kvm, BOOT_CMDLINE_OFFSET);
 	if (kernel_cmdline) {
 		cmdline_size = strlen(kernel_cmdline) + 1;
-		if (cmdline_size > boot.hdr.cmdline_size)
-			cmdline_size = boot.hdr.cmdline_size;
+		if (cmdline_size > boot->hdr.cmdline_size)
+			cmdline_size = boot->hdr.cmdline_size;
 
-		memset(p, 0, boot.hdr.cmdline_size);
+		memset(p, 0, boot->hdr.cmdline_size);
 		memcpy(p, kernel_cmdline, cmdline_size - 1);
 	}
 
@@ -313,7 +309,7 @@ static bool load_bzimage(struct kvm *kvm, int fd_kernel, int fd_initrd,
 		if (fstat(fd_initrd, &initrd_stat))
 			die_perror("fstat");
 
-		addr = boot.hdr.initrd_addr_max & ~0xfffff;
+		addr = boot->hdr.initrd_addr_max & ~0xfffff;
 		for (;;) {
 			if (addr < BZ_KERNEL_START)
 				die("Not enough memory for initrd");
@@ -345,15 +341,21 @@ static bool load_bzimage(struct kvm *kvm, int fd_kernel, int fd_initrd,
 bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
 				 const char *kernel_cmdline)
 {
-	if (load_bzimage(kvm, fd_kernel, fd_initrd, kernel_cmdline))
+	struct boot_params boot;
+
+	if (read(fd_kernel, &boot, sizeof(boot)) != sizeof(boot))
+		return false;
+
+	if (load_bzimage(kvm, fd_kernel, fd_initrd, kernel_cmdline, &boot))
 		return true;
+
 	pr_warning("Kernel image is not a bzImage.");
 	pr_warning("Trying to load it as a flat binary (no cmdline support)");
 
 	if (fd_initrd != -1)
 		pr_warning("Loading initrd with flat binary not supported.");
 
-	return load_flat_binary(kvm, fd_kernel);
+	return load_flat_binary(kvm, fd_kernel, &boot, sizeof(boot));
 }
 
 /**
-- 
2.3.5

From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 01/14] Refactor kernel image loading
Date: Thu, 30 Jul 2015 11:52:18 +0100
Message-ID: <1438253551-2378-2-git-send-email-andre.przywara@arm.com>
References: <1438253551-2378-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DA4E5944F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2015 06:39:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id C-zDv7CePULg for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jul 2015 06:39:54 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 35B4B59548
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2015 06:39:54 -0400 (EDT)
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

Let's face it: Kernel loading is quite architecture specific. Don't
claim otherwise and move the loading routines into each
architecture's responsibility.
This introduces kvm__arch_load_kernel(), which each architecture can
implement accordingly.
Provide bzImage loading for x86 and ELF loading for MIPS as special
cases for those architectures and rename the existing "flat binary"
loader functions for the other architectures to the new name.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/fdt.c         |  4 ++--
 include/kvm/kvm.h |  5 ++---
 kvm.c             | 42 ++++--------------------------------------
 mips/kvm.c        | 23 +++++++++++++++++++----
 powerpc/kvm.c     |  3 ++-
 x86/kvm.c         | 27 +++++++++++++++++----------
 6 files changed, 46 insertions(+), 58 deletions(-)

diff --git a/arm/fdt.c b/arm/fdt.c
index 3657108..ec7453f 100644
--- a/arm/fdt.c
+++ b/arm/fdt.c
@@ -239,8 +239,8 @@ static int read_image(int fd, void **pos, void *limit)
 
 #define FDT_ALIGN	SZ_2M
 #define INITRD_ALIGN	4
-int load_flat_binary(struct kvm *kvm, int fd_kernel, int fd_initrd,
-		     const char *kernel_cmdline)
+bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
+				 const char *kernel_cmdline)
 {
 	void *pos, *kernel_end, *limit;
 	unsigned long guest_addr;
diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
index 37155db..055a7a2 100644
--- a/include/kvm/kvm.h
+++ b/include/kvm/kvm.h
@@ -111,9 +111,8 @@ void kvm__arch_read_term(struct kvm *kvm);
 void *guest_flat_to_host(struct kvm *kvm, u64 offset);
 u64 host_to_guest_flat(struct kvm *kvm, void *ptr);
 
-int load_flat_binary(struct kvm *kvm, int fd_kernel, int fd_initrd, const char *kernel_cmdline);
-int load_elf_binary(struct kvm *kvm, int fd_kernel, int fd_initrd, const char *kernel_cmdline);
-bool load_bzimage(struct kvm *kvm, int fd_kernel, int fd_initrd, const char *kernel_cmdline);
+bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
+				 const char *kernel_cmdline);
 
 /*
  * Debugging
diff --git a/kvm.c b/kvm.c
index 10ed230..ca7dfee 100644
--- a/kvm.c
+++ b/kvm.c
@@ -341,18 +341,6 @@ static bool initrd_check(int fd)
 		!memcmp(id, CPIO_MAGIC, 4);
 }
 
-int __attribute__((__weak__)) load_elf_binary(struct kvm *kvm, int fd_kernel,
-				int fd_initrd, const char *kernel_cmdline)
-{
-	return false;
-}
-
-bool __attribute__((__weak__)) load_bzimage(struct kvm *kvm, int fd_kernel,
-				int fd_initrd, const char *kernel_cmdline)
-{
-	return false;
-}
-
 bool kvm__load_kernel(struct kvm *kvm, const char *kernel_filename,
 		const char *initrd_filename, const char *kernel_cmdline)
 {
@@ -372,40 +360,18 @@ bool kvm__load_kernel(struct kvm *kvm, const char *kernel_filename,
 			die("%s is not an initrd", initrd_filename);
 	}
 
-#ifdef CONFIG_X86
-	ret = load_bzimage(kvm, fd_kernel, fd_initrd, kernel_cmdline);
-
-	if (ret)
-		goto found_kernel;
-
-	pr_warning("%s is not a bzImage. Trying to load it as a flat binary...", kernel_filename);
-#endif
-
-	ret = load_elf_binary(kvm, fd_kernel, fd_initrd, kernel_cmdline);
-
-	if (ret)
-		goto found_kernel;
-
-	ret = load_flat_binary(kvm, fd_kernel, fd_initrd, kernel_cmdline);
-
-	if (ret)
-		goto found_kernel;
+	ret = kvm__arch_load_kernel_image(kvm, fd_kernel, fd_initrd,
+					  kernel_cmdline);
 
 	if (initrd_filename)
 		close(fd_initrd);
 	close(fd_kernel);
 
-	die("%s is not a valid bzImage or flat binary", kernel_filename);
-
-found_kernel:
-	if (initrd_filename)
-		close(fd_initrd);
-	close(fd_kernel);
-
+	if (!ret)
+		die("%s is not a valid kernel image", kernel_filename);
 	return ret;
 }
 
-
 void kvm__dump_mem(struct kvm *kvm, unsigned long addr, unsigned long size, int debug_fd)
 {
 	unsigned char *p;
diff --git a/mips/kvm.c b/mips/kvm.c
index 1925f38..c1c596c 100644
--- a/mips/kvm.c
+++ b/mips/kvm.c
@@ -163,7 +163,8 @@ static void kvm__mips_install_cmdline(struct kvm *kvm)
 
 /* Load at the 1M point. */
 #define KERNEL_LOAD_ADDR 0x1000000
-int load_flat_binary(struct kvm *kvm, int fd_kernel, int fd_initrd, const char *kernel_cmdline)
+
+static bool load_flat_binary(struct kvm *kvm, int fd_kernel)
 {
 	void *p;
 	void *k_start;
@@ -281,7 +282,7 @@ static bool kvm__arch_get_elf_32_info(Elf32_Ehdr *ehdr, int fd_kernel,
 	return true;
 }
 
-int load_elf_binary(struct kvm *kvm, int fd_kernel, int fd_initrd, const char *kernel_cmdline)
+static bool load_elf_binary(struct kvm *kvm, int fd_kernel)
 {
 	union {
 		Elf64_Ehdr ehdr;
@@ -342,11 +343,25 @@ int load_elf_binary(struct kvm *kvm, int fd_kernel, int fd_initrd, const char *k
 		ei.len -= nr;
 	} while (ei.len);
 
-	kvm__mips_install_cmdline(kvm);
-
 	return true;
 }
 
+bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
+				 const char *kernel_cmdline)
+{
+	if (fd_initrd != -1) {
+		pr_err("Initrd not supported on MIPS.");
+		return false;
+	}
+
+	if (load_elf_binary(kvm, fd_kernel)) {
+		kvm__mips_install_cmdline(kvm);
+		return true;
+	}
+
+	return load_flat_binary(kvm, fd_kernel);
+}
+
 void ioport__map_irq(u8 *irq)
 {
 }
diff --git a/powerpc/kvm.c b/powerpc/kvm.c
index b4c3310..13bba30 100644
--- a/powerpc/kvm.c
+++ b/powerpc/kvm.c
@@ -157,7 +157,8 @@ void kvm__arch_read_term(struct kvm *kvm)
 	spapr_hvcons_poll(kvm);
 }
 
-int load_flat_binary(struct kvm *kvm, int fd_kernel, int fd_initrd, const char *kernel_cmdline)
+bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
+				 const char *kernel_cmdline)
 {
 	void *p;
 	void *k_start;
diff --git a/x86/kvm.c b/x86/kvm.c
index 512ad67..a0204b8 100644
--- a/x86/kvm.c
+++ b/x86/kvm.c
@@ -206,18 +206,11 @@ static inline void *guest_real_to_host(struct kvm *kvm, u16 selector, u16 offset
 	return guest_flat_to_host(kvm, flat);
 }
 
-int load_flat_binary(struct kvm *kvm, int fd_kernel, int fd_initrd, const char *kernel_cmdline)
+static bool load_flat_binary(struct kvm *kvm, int fd_kernel)
 {
 	void *p;
 	int nr;
 
-	/*
-	 * Some architectures may support loading an initrd alongside the flat kernel,
-	 * but we do not.
-	 */
-	if (fd_initrd != -1)
-		pr_warning("Loading initrd with flat binary not supported.");
-
 	if (lseek(fd_kernel, 0, SEEK_SET) < 0)
 		die_perror("lseek");
 
@@ -235,8 +228,8 @@ int load_flat_binary(struct kvm *kvm, int fd_kernel, int fd_initrd, const char *
 
 static const char *BZIMAGE_MAGIC = "HdrS";
 
-bool load_bzimage(struct kvm *kvm, int fd_kernel, int fd_initrd,
-		  const char *kernel_cmdline)
+static bool load_bzimage(struct kvm *kvm, int fd_kernel, int fd_initrd,
+			 const char *kernel_cmdline)
 {
 	struct boot_params *kern_boot;
 	unsigned long setup_sects;
@@ -352,6 +345,20 @@ bool load_bzimage(struct kvm *kvm, int fd_kernel, int fd_initrd,
 	return true;
 }
 
+bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
+				 const char *kernel_cmdline)
+{
+	if (load_bzimage(kvm, fd_kernel, fd_initrd, kernel_cmdline))
+		return true;
+	pr_warning("Kernel image is not a bzImage.");
+	pr_warning("Trying to load it as a flat binary (no cmdline support)");
+
+	if (fd_initrd != -1)
+		pr_warning("Loading initrd with flat binary not supported.");
+
+	return load_flat_binary(kvm, fd_kernel);
+}
+
 /**
  * kvm__arch_setup_firmware - inject BIOS into guest system memory
  * @kvm - guest system descriptor
-- 
2.3.5

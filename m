From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 7/7] arm: move kernel loading into arm/kvm.c
Date: Fri, 30 Oct 2015 18:27:00 +0000
Message-ID: <1446229620-28088-8-git-send-email-andre.przywara@arm.com>
References: <1446229620-28088-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1446229620-28088-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: will.deacon@arm.com, kvm@vger.kernel.org
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm-ppc@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

For some reasons (probably to have easy access to the command line)
the kernel loading for arm and arm64 was located in arm/fdt.c.
Move the routines to kvm.c (where other architectures put it) to
only have real device tree code in fdt.c. We use the pointer in
struct kvm to access the command line string.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/fdt.c | 95 +--------------------------------------------------------------
 arm/kvm.c | 88 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 89 insertions(+), 94 deletions(-)

diff --git a/arm/fdt.c b/arm/fdt.c
index 19d7ed9..381d48f 100644
--- a/arm/fdt.c
+++ b/arm/fdt.c
@@ -9,14 +9,11 @@
 
 #include <stdbool.h>
 
-#include <asm/setup.h>
 #include <linux/byteorder.h>
 #include <linux/kernel.h>
 #include <linux/sizes.h>
 #include <linux/psci.h>
 
-static char kern_cmdline[COMMAND_LINE_SIZE];
-
 bool kvm__load_firmware(struct kvm *kvm, const char *firmware_filename)
 {
 	return false;
@@ -145,7 +142,7 @@ static int setup_fdt(struct kvm *kvm)
 	/* /chosen */
 	_FDT(fdt_begin_node(fdt, "chosen"));
 	_FDT(fdt_property_cell(fdt, "linux,pci-probe-only", 1));
-	_FDT(fdt_property_string(fdt, "bootargs", kern_cmdline));
+	_FDT(fdt_property_string(fdt, "bootargs", kvm->cfg.real_cmdline));
 
 	/* Initrd */
 	if (kvm->arch.initrd_size != 0) {
@@ -223,93 +220,3 @@ static int setup_fdt(struct kvm *kvm)
 	return 0;
 }
 late_init(setup_fdt);
-
-#define FDT_ALIGN	SZ_2M
-#define INITRD_ALIGN	4
-bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
-				 const char *kernel_cmdline)
-{
-	void *pos, *kernel_end, *limit;
-	unsigned long guest_addr;
-	ssize_t file_size;
-
-	if (lseek(fd_kernel, 0, SEEK_SET) < 0)
-		die_perror("lseek");
-
-	/*
-	 * Linux requires the initrd and dtb to be mapped inside lowmem,
-	 * so we can't just place them at the top of memory.
-	 */
-	limit = kvm->ram_start + min(kvm->ram_size, (u64)SZ_256M) - 1;
-
-	pos = kvm->ram_start + ARM_KERN_OFFSET(kvm);
-	kvm->arch.kern_guest_start = host_to_guest_flat(kvm, pos);
-	file_size = read_file(fd_kernel, pos, limit - pos);
-	if (file_size < 0) {
-		if (errno == ENOMEM)
-			die("kernel image too big to contain in guest memory.");
-
-		die_perror("kernel read");
-	}
-	kernel_end = pos + file_size;
-	pr_info("Loaded kernel to 0x%llx (%zd bytes)",
-		kvm->arch.kern_guest_start, file_size);
-
-	/*
-	 * Now load backwards from the end of memory so the kernel
-	 * decompressor has plenty of space to work with. First up is
-	 * the device tree blob...
-	 */
-	pos = limit;
-	pos -= (FDT_MAX_SIZE + FDT_ALIGN);
-	guest_addr = ALIGN(host_to_guest_flat(kvm, pos), FDT_ALIGN);
-	pos = guest_flat_to_host(kvm, guest_addr);
-	if (pos < kernel_end)
-		die("fdt overlaps with kernel image.");
-
-	kvm->arch.dtb_guest_start = guest_addr;
-	pr_info("Placing fdt at 0x%llx - 0x%llx",
-		kvm->arch.dtb_guest_start,
-		host_to_guest_flat(kvm, limit));
-	limit = pos;
-
-	/* ... and finally the initrd, if we have one. */
-	if (fd_initrd != -1) {
-		struct stat sb;
-		unsigned long initrd_start;
-
-		if (lseek(fd_initrd, 0, SEEK_SET) < 0)
-			die_perror("lseek");
-
-		if (fstat(fd_initrd, &sb))
-			die_perror("fstat");
-
-		pos -= (sb.st_size + INITRD_ALIGN);
-		guest_addr = ALIGN(host_to_guest_flat(kvm, pos), INITRD_ALIGN);
-		pos = guest_flat_to_host(kvm, guest_addr);
-		if (pos < kernel_end)
-			die("initrd overlaps with kernel image.");
-
-		initrd_start = guest_addr;
-		file_size = read_file(fd_initrd, pos, limit - pos);
-		if (file_size == -1) {
-			if (errno == ENOMEM)
-				die("initrd too big to contain in guest memory.");
-
-			die_perror("initrd read");
-		}
-
-		kvm->arch.initrd_guest_start = initrd_start;
-		kvm->arch.initrd_size = file_size;
-		pr_info("Loaded initrd to 0x%llx (%llu bytes)",
-			kvm->arch.initrd_guest_start,
-			kvm->arch.initrd_size);
-	} else {
-		kvm->arch.initrd_size = 0;
-	}
-
-	strncpy(kern_cmdline, kernel_cmdline, COMMAND_LINE_SIZE);
-	kern_cmdline[COMMAND_LINE_SIZE - 1] = '\0';
-
-	return true;
-}
diff --git a/arm/kvm.c b/arm/kvm.c
index d0e4a20..433a7bc 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -3,6 +3,7 @@
 #include "kvm/util.h"
 #include "kvm/8250-serial.h"
 #include "kvm/virtio-console.h"
+#include "kvm/fdt.h"
 
 #include "arm-common/gic.h"
 
@@ -85,3 +86,90 @@ void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64 ram_size)
 	if (gic__create(kvm, kvm->cfg.arch.irqchip))
 		die("Failed to create virtual GIC");
 }
+
+#define FDT_ALIGN	SZ_2M
+#define INITRD_ALIGN	4
+bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
+				 const char *kernel_cmdline)
+{
+	void *pos, *kernel_end, *limit;
+	unsigned long guest_addr;
+	ssize_t file_size;
+
+	if (lseek(fd_kernel, 0, SEEK_SET) < 0)
+		die_perror("lseek");
+
+	/*
+	 * Linux requires the initrd and dtb to be mapped inside lowmem,
+	 * so we can't just place them at the top of memory.
+	 */
+	limit = kvm->ram_start + min(kvm->ram_size, (u64)SZ_256M) - 1;
+
+	pos = kvm->ram_start + ARM_KERN_OFFSET(kvm);
+	kvm->arch.kern_guest_start = host_to_guest_flat(kvm, pos);
+	file_size = read_file(fd_kernel, pos, limit - pos);
+	if (file_size < 0) {
+		if (errno == ENOMEM)
+			die("kernel image too big to contain in guest memory.");
+
+		die_perror("kernel read");
+	}
+	kernel_end = pos + file_size;
+	pr_info("Loaded kernel to 0x%llx (%zd bytes)",
+		kvm->arch.kern_guest_start, file_size);
+
+	/*
+	 * Now load backwards from the end of memory so the kernel
+	 * decompressor has plenty of space to work with. First up is
+	 * the device tree blob...
+	 */
+	pos = limit;
+	pos -= (FDT_MAX_SIZE + FDT_ALIGN);
+	guest_addr = ALIGN(host_to_guest_flat(kvm, pos), FDT_ALIGN);
+	pos = guest_flat_to_host(kvm, guest_addr);
+	if (pos < kernel_end)
+		die("fdt overlaps with kernel image.");
+
+	kvm->arch.dtb_guest_start = guest_addr;
+	pr_info("Placing fdt at 0x%llx - 0x%llx",
+		kvm->arch.dtb_guest_start,
+		host_to_guest_flat(kvm, limit));
+	limit = pos;
+
+	/* ... and finally the initrd, if we have one. */
+	if (fd_initrd != -1) {
+		struct stat sb;
+		unsigned long initrd_start;
+
+		if (lseek(fd_initrd, 0, SEEK_SET) < 0)
+			die_perror("lseek");
+
+		if (fstat(fd_initrd, &sb))
+			die_perror("fstat");
+
+		pos -= (sb.st_size + INITRD_ALIGN);
+		guest_addr = ALIGN(host_to_guest_flat(kvm, pos), INITRD_ALIGN);
+		pos = guest_flat_to_host(kvm, guest_addr);
+		if (pos < kernel_end)
+			die("initrd overlaps with kernel image.");
+
+		initrd_start = guest_addr;
+		file_size = read_file(fd_initrd, pos, limit - pos);
+		if (file_size == -1) {
+			if (errno == ENOMEM)
+				die("initrd too big to contain in guest memory.");
+
+			die_perror("initrd read");
+		}
+
+		kvm->arch.initrd_guest_start = initrd_start;
+		kvm->arch.initrd_size = file_size;
+		pr_info("Loaded initrd to 0x%llx (%llu bytes)",
+			kvm->arch.initrd_guest_start,
+			kvm->arch.initrd_size);
+	} else {
+		kvm->arch.initrd_size = 0;
+	}
+
+	return true;
+}
-- 
2.5.1


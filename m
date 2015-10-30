From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 6/7] arm/arm64: use read_file() in kernel and initrd loading
Date: Fri, 30 Oct 2015 18:26:59 +0000
Message-ID: <1446229620-28088-7-git-send-email-andre.przywara@arm.com>
References: <1446229620-28088-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1446229620-28088-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: will.deacon@arm.com, kvm@vger.kernel.org
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm-ppc@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Use the new read_file() wrapper in our arm/arm64 kernel image loading
function instead of the private implementation.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/fdt.c | 40 ++++++++++++++++++----------------------
 1 file changed, 18 insertions(+), 22 deletions(-)

diff --git a/arm/fdt.c b/arm/fdt.c
index ec7453f..19d7ed9 100644
--- a/arm/fdt.c
+++ b/arm/fdt.c
@@ -224,19 +224,6 @@ static int setup_fdt(struct kvm *kvm)
 }
 late_init(setup_fdt);
 
-static int read_image(int fd, void **pos, void *limit)
-{
-	int count;
-
-	while (((count = xread(fd, *pos, SZ_64K)) > 0) && *pos <= limit)
-		*pos += count;
-
-	if (pos < 0)
-		die_perror("xread");
-
-	return *pos < limit ? 0 : -ENOMEM;
-}
-
 #define FDT_ALIGN	SZ_2M
 #define INITRD_ALIGN	4
 bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
@@ -244,6 +231,7 @@ bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
 {
 	void *pos, *kernel_end, *limit;
 	unsigned long guest_addr;
+	ssize_t file_size;
 
 	if (lseek(fd_kernel, 0, SEEK_SET) < 0)
 		die_perror("lseek");
@@ -256,13 +244,16 @@ bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
 
 	pos = kvm->ram_start + ARM_KERN_OFFSET(kvm);
 	kvm->arch.kern_guest_start = host_to_guest_flat(kvm, pos);
-	if (read_image(fd_kernel, &pos, limit) == -ENOMEM)
-		die("kernel image too big to contain in guest memory.");
+	file_size = read_file(fd_kernel, pos, limit - pos);
+	if (file_size < 0) {
+		if (errno == ENOMEM)
+			die("kernel image too big to contain in guest memory.");
 
-	kernel_end = pos;
-	pr_info("Loaded kernel to 0x%llx (%llu bytes)",
-		kvm->arch.kern_guest_start,
-		host_to_guest_flat(kvm, pos) - kvm->arch.kern_guest_start);
+		die_perror("kernel read");
+	}
+	kernel_end = pos + file_size;
+	pr_info("Loaded kernel to 0x%llx (%zd bytes)",
+		kvm->arch.kern_guest_start, file_size);
 
 	/*
 	 * Now load backwards from the end of memory so the kernel
@@ -300,11 +291,16 @@ bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
 			die("initrd overlaps with kernel image.");
 
 		initrd_start = guest_addr;
-		if (read_image(fd_initrd, &pos, limit) == -ENOMEM)
-			die("initrd too big to contain in guest memory.");
+		file_size = read_file(fd_initrd, pos, limit - pos);
+		if (file_size == -1) {
+			if (errno == ENOMEM)
+				die("initrd too big to contain in guest memory.");
+
+			die_perror("initrd read");
+		}
 
 		kvm->arch.initrd_guest_start = initrd_start;
-		kvm->arch.initrd_size = host_to_guest_flat(kvm, pos) - initrd_start;
+		kvm->arch.initrd_size = file_size;
 		pr_info("Loaded initrd to 0x%llx (%llu bytes)",
 			kvm->arch.initrd_guest_start,
 			kvm->arch.initrd_size);
-- 
2.5.1


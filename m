From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 11/14] arm/arm64: use read_file() in kernel and initrd loading
Date: Thu, 30 Jul 2015 11:52:28 +0100
Message-ID: <1438253551-2378-12-git-send-email-andre.przywara@arm.com>
References: <1438253551-2378-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1438253551-2378-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: will.deacon@arm.com, kvm@vger.kernel.org
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, kvm-ppc@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Use the new read_file() wrapper in our arm/arm64 kernel image loading
function instead of the private implementation.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/kvm.c | 42 ++++++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 22 deletions(-)

diff --git a/arm/kvm.c b/arm/kvm.c
index 6e3f80e..277d9e6 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -87,19 +87,6 @@ void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64 ram_size)
 		die("Failed to create virtual GIC");
 }
 
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
@@ -107,6 +94,7 @@ bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
 {
 	void *pos, *kernel_end, *limit;
 	unsigned long guest_addr;
+	ssize_t file_size;
 
 	/*
 	 * Linux requires the initrd and dtb to be mapped inside lowmem,
@@ -116,13 +104,17 @@ bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
 
 	pos = kvm->ram_start + ARM_KERN_OFFSET(kvm);
 	kvm->arch.kern_guest_start = host_to_guest_flat(kvm, pos);
-	if (read_image(fd_kernel, &pos, limit) == -ENOMEM)
-		die("kernel image too big to contain in guest memory.");
+	file_size = read_file(fd_kernel, pos, limit - pos);
+	if (file_size < 0) {
+		if (errno == ENOMEM)
+			die("kernel image too big to contain in guest memory.");
+
+		die_perror("kernel read");
+	}
+	kernel_end = pos + file_size;
 
-	kernel_end = pos;
-	pr_info("Loaded kernel to 0x%llx (%llu bytes)",
-		kvm->arch.kern_guest_start,
-		host_to_guest_flat(kvm, pos) - kvm->arch.kern_guest_start);
+	pr_info("Loaded kernel to 0x%llx (%zd bytes)",
+		kvm->arch.kern_guest_start, file_size);
 
 	/*
 	 * Now load backwards from the end of memory so the kernel
@@ -160,11 +152,17 @@ bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
 			die("initrd overlaps with kernel image.");
 
 		initrd_start = guest_addr;
-		if (read_image(fd_initrd, &pos, limit) == -ENOMEM)
-			die("initrd too big to contain in guest memory.");
+
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
2.3.5


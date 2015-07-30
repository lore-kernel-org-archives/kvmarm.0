From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 02/14] arm/powerpc: remove unneeded seeks in kernel loading
Date: Thu, 30 Jul 2015 11:52:19 +0100
Message-ID: <1438253551-2378-3-git-send-email-andre.przywara@arm.com>
References: <1438253551-2378-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1438253551-2378-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: will.deacon@arm.com, kvm@vger.kernel.org
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, kvm-ppc@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

With the introduction of kvm__arch_load_kernel_image() we are sure
that nobody peeks at the kernel image files before, so rewinding
the file to its beginning is unnecessary.
Remove those seeks in the arm and powerpc implementations.
This allows to use a pipe instead of a regular file for the kernel
image, enabling on-the-fly uncompression or downloading via the
command line.
$ lkvm run -k <(zcat zImage.gz) ...
$ lkvm run -k <(wget -O - http://foo.com/guest.zImage) ...

This is limited to the kernel images for the arm/arm64 and powerpc
architectures for now, other architectures and initrds need more work.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/fdt.c     | 3 ---
 powerpc/kvm.c | 3 ---
 2 files changed, 6 deletions(-)

diff --git a/arm/fdt.c b/arm/fdt.c
index ec7453f..cb4f00d 100644
--- a/arm/fdt.c
+++ b/arm/fdt.c
@@ -245,9 +245,6 @@ bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
 	void *pos, *kernel_end, *limit;
 	unsigned long guest_addr;
 
-	if (lseek(fd_kernel, 0, SEEK_SET) < 0)
-		die_perror("lseek");
-
 	/*
 	 * Linux requires the initrd and dtb to be mapped inside lowmem,
 	 * so we can't just place them at the top of memory.
diff --git a/powerpc/kvm.c b/powerpc/kvm.c
index 13bba30..87d0f9e 100644
--- a/powerpc/kvm.c
+++ b/powerpc/kvm.c
@@ -165,9 +165,6 @@ bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
 	void *i_start;
 	int nr;
 
-	if (lseek(fd_kernel, 0, SEEK_SET) < 0)
-		die_perror("lseek");
-
 	p = k_start = guest_flat_to_host(kvm, KERNEL_LOAD_ADDR);
 
 	while ((nr = read(fd_kernel, p, 65536)) > 0)
-- 
2.3.5


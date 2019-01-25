From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH kvmtool 1/6] arm: turn pr_info() into pr_debug() messages
Date: Fri, 25 Jan 2019 18:07:56 +0000
Message-ID: <20190125180801.209910-2-andre.przywara@arm.com>
References: <20190125180801.209910-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D2474A3EB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Jan 2019 13:08:12 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kIvFK8PY371d for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Jan 2019 13:08:09 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 157C14A3C8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Jan 2019 13:08:09 -0500 (EST)
In-Reply-To: <20190125180801.209910-1-andre.przywara@arm.com>
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
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

For whatever reason on ARM/arm64 machines kvmtool greets us with quite
some elaborate messages:
  Info: Loaded kernel to 0x80080000 (18704896 bytes)
  Info: Placing fdt at 0x8fe00000 - 0x8fffffff
  Info: virtio-mmio.devices=0x200@0x10000:36

  Info: virtio-mmio.devices=0x200@0x10200:37

  Info: virtio-mmio.devices=0x200@0x10400:38

This is not really useful information for the casual user, so change
those lines to use pr_debug().
This also fixes the long standing line ending issue for the mmio output.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/fdt.c     |  2 +-
 arm/kvm.c     | 16 ++++++++--------
 virtio/mmio.c |  3 ++-
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/arm/fdt.c b/arm/fdt.c
index 980015b4..28ba1c2c 100644
--- a/arm/fdt.c
+++ b/arm/fdt.c
@@ -36,7 +36,7 @@ static void dump_fdt(const char *dtb_file, void *fdt)
 	if (count < 0)
 		die_perror("Failed to dump dtb");
 
-	pr_info("Wrote %d bytes to dtb %s\n", count, dtb_file);
+	pr_debug("Wrote %d bytes to dtb %s", count, dtb_file);
 	close(fd);
 }
 
diff --git a/arm/kvm.c b/arm/kvm.c
index b824f637..8dc6989c 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -113,8 +113,8 @@ bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
 		die_perror("kernel read");
 	}
 	kernel_end = pos + file_size;
-	pr_info("Loaded kernel to 0x%llx (%zd bytes)",
-		kvm->arch.kern_guest_start, file_size);
+	pr_debug("Loaded kernel to 0x%llx (%zd bytes)",
+		 kvm->arch.kern_guest_start, file_size);
 
 	/*
 	 * Now load backwards from the end of memory so the kernel
@@ -129,9 +129,9 @@ bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
 		die("fdt overlaps with kernel image.");
 
 	kvm->arch.dtb_guest_start = guest_addr;
-	pr_info("Placing fdt at 0x%llx - 0x%llx",
-		kvm->arch.dtb_guest_start,
-		host_to_guest_flat(kvm, limit));
+	pr_debug("Placing fdt at 0x%llx - 0x%llx",
+		 kvm->arch.dtb_guest_start,
+		 host_to_guest_flat(kvm, limit));
 	limit = pos;
 
 	/* ... and finally the initrd, if we have one. */
@@ -159,9 +159,9 @@ bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
 
 		kvm->arch.initrd_guest_start = initrd_start;
 		kvm->arch.initrd_size = file_size;
-		pr_info("Loaded initrd to 0x%llx (%llu bytes)",
-			kvm->arch.initrd_guest_start,
-			kvm->arch.initrd_size);
+		pr_debug("Loaded initrd to 0x%llx (%llu bytes)",
+			 kvm->arch.initrd_guest_start,
+			 kvm->arch.initrd_size);
 	} else {
 		kvm->arch.initrd_size = 0;
 	}
diff --git a/virtio/mmio.c b/virtio/mmio.c
index 8c0f1cc1..9e0cd05d 100644
--- a/virtio/mmio.c
+++ b/virtio/mmio.c
@@ -307,7 +307,8 @@ int virtio_mmio_init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 	 *
 	 * virtio_mmio.devices=0x200@0xd2000000:5,0x200@0xd2000200:6
 	 */
-	pr_info("virtio-mmio.devices=0x%x@0x%x:%d\n", VIRTIO_MMIO_IO_SIZE, vmmio->addr, vmmio->irq);
+	pr_debug("virtio-mmio.devices=0x%x@0x%x:%d", VIRTIO_MMIO_IO_SIZE,
+		 vmmio->addr, vmmio->irq);
 
 	return 0;
 }
-- 
2.17.1

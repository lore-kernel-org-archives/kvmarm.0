From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 08/14] MIPS: remove seeks from load_flat_binary()
Date: Thu, 30 Jul 2015 11:52:25 +0100
Message-ID: <1438253551-2378-9-git-send-email-andre.przywara@arm.com>
References: <1438253551-2378-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D02BF596F8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2015 06:40:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id n1omMdJd9aIG for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jul 2015 06:40:06 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D4171596E9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2015 06:40:04 -0400 (EDT)
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

Remove the need to rewind the kernel image file if loading it as a
flat binary by re-using the already read portion of the file passed
in as a buffer.
This allows the MIPS flat binary kernel image to be read from a pipe.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 mips/kvm.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/mips/kvm.c b/mips/kvm.c
index ed81a02..d970ee0 100644
--- a/mips/kvm.c
+++ b/mips/kvm.c
@@ -164,24 +164,26 @@ static void kvm__mips_install_cmdline(struct kvm *kvm)
 /* Load at the 1M point. */
 #define KERNEL_LOAD_ADDR 0x1000000
 
-static bool load_flat_binary(struct kvm *kvm, int fd_kernel)
+static bool load_flat_binary(struct kvm *kvm, int fd_kernel, const void *buf,
+			     int buflen)
 {
 	void *p;
 	void *k_start;
 	int nr;
 
-	if (lseek(fd_kernel, 0, SEEK_SET) < 0)
-		die_perror("lseek");
-
 	p = k_start = guest_flat_to_host(kvm, KERNEL_LOAD_ADDR);
 
+	memcpy(p, buf, buflen);
+	p += buflen;
+
 	while ((nr = read(fd_kernel, p, 65536)) > 0)
 		p += nr;
 
 	kvm->arch.is64bit = true;
 	kvm->arch.entry_point = 0xffffffff81000000ull;
 
-	pr_info("Loaded kernel to 0x%x (%ld bytes)", KERNEL_LOAD_ADDR, (long int)(p - k_start));
+	pr_info("Loaded kernel to 0x%x (%ld bytes)", KERNEL_LOAD_ADDR,
+		(long int)(p - k_start));
 
 	return true;
 }
@@ -357,7 +359,7 @@ bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
 		return true;
 	}
 
-	return load_flat_binary(kvm, fd_kernel);
+	return load_flat_binary(kvm, fd_kernel, &eh, sizeof(eh));
 }
 
 void ioport__map_irq(u8 *irq)
-- 
2.3.5

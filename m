From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 03/14] x86: allow pipes for bzImage kernel images
Date: Thu, 30 Jul 2015 11:52:20 +0100
Message-ID: <1438253551-2378-4-git-send-email-andre.przywara@arm.com>
References: <1438253551-2378-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CF2205969D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2015 06:39:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SQRLcczhGofc for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jul 2015 06:39:59 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 16462596A0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2015 06:39:57 -0400 (EDT)
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

Streamline the x86 kernel loading implementation by removing unneeded
seeks and thus allow an x86 bzImage to be loaded from a pipe.
"Flat binaries" are taken care of in a separate patch.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 x86/kvm.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/x86/kvm.c b/x86/kvm.c
index a0204b8..8fe5585 100644
--- a/x86/kvm.c
+++ b/x86/kvm.c
@@ -245,9 +245,6 @@ static bool load_bzimage(struct kvm *kvm, int fd_kernel, int fd_initrd,
 	 * memory layout.
 	 */
 
-	if (lseek(fd_kernel, 0, SEEK_SET) < 0)
-		die_perror("lseek");
-
 	if (read(fd_kernel, &boot, sizeof(boot)) != sizeof(boot))
 		return false;
 
@@ -257,9 +254,6 @@ static bool load_bzimage(struct kvm *kvm, int fd_kernel, int fd_initrd,
 	if (boot.hdr.version < BOOT_PROTOCOL_REQUIRED)
 		die("Too old kernel");
 
-	if (lseek(fd_kernel, 0, SEEK_SET) < 0)
-		die_perror("lseek");
-
 	if (!boot.hdr.setup_sects)
 		boot.hdr.setup_sects = BZ_DEFAULT_SETUP_SECTS;
 	setup_sects = boot.hdr.setup_sects + 1;
@@ -267,7 +261,10 @@ static bool load_bzimage(struct kvm *kvm, int fd_kernel, int fd_initrd,
 	setup_size = setup_sects << 9;
 	p = guest_real_to_host(kvm, BOOT_LOADER_SELECTOR, BOOT_LOADER_IP);
 
-	/* copy setup.bin to mem*/
+	/* copy setup.bin to mem */
+	memcpy(p, &boot, sizeof(boot));
+	p += sizeof(boot);
+	setup_size -= sizeof(boot);
 	if (read(fd_kernel, p, setup_size) != setup_size)
 		die_perror("read");
 
-- 
2.3.5

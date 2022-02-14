Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E868AC43217
	for <kvmarm@archiver.kernel.org>; Mon, 14 Feb 2022 16:58:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A47949F15;
	Mon, 14 Feb 2022 11:58:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1vBdLfA76st4; Mon, 14 Feb 2022 11:58:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EC75D49F54;
	Mon, 14 Feb 2022 11:58:27 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 02DA949ECB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 11:58:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cudhMPsFdu5r for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Feb 2022 11:58:24 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA4CB49EFE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 11:58:24 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2497C1476;
 Mon, 14 Feb 2022 08:58:24 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CB4203F70D;
 Mon, 14 Feb 2022 08:58:22 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org, julien.thierry.kdev@gmail.com, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, andre.przywara@arm.com,
 pierre.gondois@arm.com
Subject: [PATCH kvmtool 1/3] Remove initrd magic check
Date: Mon, 14 Feb 2022 16:58:28 +0000
Message-Id: <20220214165830.69207-2-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214165830.69207-1-alexandru.elisei@arm.com>
References: <20220214165830.69207-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Linux, besides CPIO, supports 7 different compressed formats for the initrd
(gzip, bzip2, LZMA, XZ, LZO, LZ4, ZSTD), but kvmtool only recognizes one of
them.

Remove the initrd magic check because:

1. It doesn't bring much to the end user, as the Linux kernel still
   complains if the initrd is in an unknown format.

2. --kernel can be used to load something that is not a Linux kernel (like
   a kvm-unit-tests test), in which case a format which is not supported by
   a Linux kernel can still be perfectly valid. For example, kvm-unit-tests
   load the test environment as an initrd in plain ASCII format.

3. It cuts down on the maintenance effort when new formats are added to
   the Linux kernel. Not a big deal, since that doesn't happen very often,
   but it's still an effort with very little gain (see point #1 above).

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 kvm.c | 22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/kvm.c b/kvm.c
index 5bc66c8be82a..952ef1fbb41c 100644
--- a/kvm.c
+++ b/kvm.c
@@ -512,25 +512,6 @@ err:
 }
 core_init(kvm__init);
 
-/* RFC 1952 */
-#define GZIP_ID1		0x1f
-#define GZIP_ID2		0x8b
-#define CPIO_MAGIC		"0707"
-/* initrd may be gzipped, or a plain cpio */
-static bool initrd_check(int fd)
-{
-	unsigned char id[4];
-
-	if (read_in_full(fd, id, ARRAY_SIZE(id)) < 0)
-		return false;
-
-	if (lseek(fd, 0, SEEK_SET) < 0)
-		die_perror("lseek");
-
-	return (id[0] == GZIP_ID1 && id[1] == GZIP_ID2) ||
-		!memcmp(id, CPIO_MAGIC, 4);
-}
-
 bool kvm__load_kernel(struct kvm *kvm, const char *kernel_filename,
 		const char *initrd_filename, const char *kernel_cmdline)
 {
@@ -545,9 +526,6 @@ bool kvm__load_kernel(struct kvm *kvm, const char *kernel_filename,
 		fd_initrd = open(initrd_filename, O_RDONLY);
 		if (fd_initrd < 0)
 			die("Unable to open initrd %s", initrd_filename);
-
-		if (!initrd_check(fd_initrd))
-			die("%s is not an initrd", initrd_filename);
 	}
 
 	ret = kvm__arch_load_kernel_image(kvm, fd_kernel, fd_initrd,
-- 
2.31.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

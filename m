Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71F33C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 25 May 2022 11:23:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D350D4B2EF;
	Wed, 25 May 2022 07:23:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id M2YbAeTsaGpG; Wed, 25 May 2022 07:23:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D1844B2EB;
	Wed, 25 May 2022 07:23:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 756294B2EB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 May 2022 07:23:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kCSTD0a3As9V for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 May 2022 07:23:42 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DECBC4B2E6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 May 2022 07:23:41 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 629401FB;
 Wed, 25 May 2022 04:23:41 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D1EF23F70D;
 Wed, 25 May 2022 04:23:39 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org,
 suzuki.poulose@arm.com, julien@xen.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 james.morse@arm.com, andre.przywara@arm.com
Subject: [PATCH v3 kvmtool 02/13] sizes.h: Make all sizes 64bit
Date: Wed, 25 May 2022 12:23:34 +0100
Message-Id: <20220525112345.121321-3-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220525112345.121321-1-alexandru.elisei@arm.com>
References: <20220525112345.121321-1-alexandru.elisei@arm.com>
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

Append ULL to all of the size definitions to make them 64bit and avoid
overflows.

Reported-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 include/linux/sizes.h | 64 +++++++++++++++++++++----------------------
 1 file changed, 32 insertions(+), 32 deletions(-)

diff --git a/include/linux/sizes.h b/include/linux/sizes.h
index ce3e8150c174..b2b5c457cf1c 100644
--- a/include/linux/sizes.h
+++ b/include/linux/sizes.h
@@ -8,40 +8,40 @@
 #ifndef __LINUX_SIZES_H__
 #define __LINUX_SIZES_H__
 
-#define SZ_1				0x00000001
-#define SZ_2				0x00000002
-#define SZ_4				0x00000004
-#define SZ_8				0x00000008
-#define SZ_16				0x00000010
-#define SZ_32				0x00000020
-#define SZ_64				0x00000040
-#define SZ_128				0x00000080
-#define SZ_256				0x00000100
-#define SZ_512				0x00000200
+#define SZ_1				0x00000001ULL
+#define SZ_2				0x00000002ULL
+#define SZ_4				0x00000004ULL
+#define SZ_8				0x00000008ULL
+#define SZ_16				0x00000010ULL
+#define SZ_32				0x00000020ULL
+#define SZ_64				0x00000040ULL
+#define SZ_128				0x00000080ULL
+#define SZ_256				0x00000100ULL
+#define SZ_512				0x00000200ULL
 
-#define SZ_1K				0x00000400
-#define SZ_2K				0x00000800
-#define SZ_4K				0x00001000
-#define SZ_8K				0x00002000
-#define SZ_16K				0x00004000
-#define SZ_32K				0x00008000
-#define SZ_64K				0x00010000
-#define SZ_128K				0x00020000
-#define SZ_256K				0x00040000
-#define SZ_512K				0x00080000
+#define SZ_1K				0x00000400ULL
+#define SZ_2K				0x00000800ULL
+#define SZ_4K				0x00001000ULL
+#define SZ_8K				0x00002000ULL
+#define SZ_16K				0x00004000ULL
+#define SZ_32K				0x00008000ULL
+#define SZ_64K				0x00010000ULL
+#define SZ_128K				0x00020000ULL
+#define SZ_256K				0x00040000ULL
+#define SZ_512K				0x00080000ULL
 
-#define SZ_1M				0x00100000
-#define SZ_2M				0x00200000
-#define SZ_4M				0x00400000
-#define SZ_8M				0x00800000
-#define SZ_16M				0x01000000
-#define SZ_32M				0x02000000
-#define SZ_64M				0x04000000
-#define SZ_128M				0x08000000
-#define SZ_256M				0x10000000
-#define SZ_512M				0x20000000
+#define SZ_1M				0x00100000ULL
+#define SZ_2M				0x00200000ULL
+#define SZ_4M				0x00400000ULL
+#define SZ_8M				0x00800000ULL
+#define SZ_16M				0x01000000ULL
+#define SZ_32M				0x02000000ULL
+#define SZ_64M				0x04000000ULL
+#define SZ_128M				0x08000000ULL
+#define SZ_256M				0x10000000ULL
+#define SZ_512M				0x20000000ULL
 
-#define SZ_1G				0x40000000
-#define SZ_2G				0x80000000
+#define SZ_1G				0x40000000ULL
+#define SZ_2G				0x80000000ULL
 
 #endif /* __LINUX_SIZES_H__ */
-- 
2.36.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

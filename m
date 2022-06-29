Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 112FCC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 29 Jun 2022 10:38:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 776994B5D9;
	Wed, 29 Jun 2022 06:38:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fvSuMZ0t7yzt; Wed, 29 Jun 2022 06:38:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BCBD4B5AC;
	Wed, 29 Jun 2022 06:38:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FD324B5AB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Jun 2022 06:38:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id npACMb14Tv4r for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Jun 2022 06:38:51 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DD414B5A9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Jun 2022 06:38:51 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CA90B152B;
 Wed, 29 Jun 2022 03:38:50 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1E3523F792;
 Wed, 29 Jun 2022 03:38:48 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 andre.przywara@arm.com, pierre.gondois@arm.com, sebastianene@google.com
Subject: [PATCH kvmtool] arm64: pvtime: Use correct region size
Date: Wed, 29 Jun 2022 11:39:05 +0100
Message-Id: <20220629103905.24480-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.36.1
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

pvtime uses ARM_PVTIME_BASE instead of ARM_PVTIME_SIZE for the size of the
memory region given to the guest, which causes to the following error when
creating a flash device (via the -F/--flash command line argument):

  Error: RAM (read-only) region [2000000-27fffff] would overlap RAM region [1020000-203ffff]

The read-only region represents the guest memory where the flash image is
copied by kvmtool. The region starting at 0x102_0000 (ARM_PVTIME_BASE) is
the pvtime region, which should be 64K in size. kvmtool erroneously creates
the region to be ARM_PVTIME_BASE in size instead, and the last address
becomes:

ARM_PVTIME_BASE + ARM_PVTIME_BASE - 1 = 0x102_0000 + 0x102_0000 - 1 = 0x203_ffff

which corresponds to the end of the region from the error message.

Do the right thing and make the pvtime memory region ARM_PVTIME_SIZE = 64K
bytes, as it was intended.

Fixes: 7d4671e5d372 ("aarch64: Add stolen time support")
Reported-by: Pierre Gondois <pierre.gondois@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/aarch64/pvtime.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arm/aarch64/pvtime.c b/arm/aarch64/pvtime.c
index a49cf3ed5478..2933ac7ca959 100644
--- a/arm/aarch64/pvtime.c
+++ b/arm/aarch64/pvtime.c
@@ -14,15 +14,15 @@ static int pvtime__alloc_region(struct kvm *kvm)
 	char *mem;
 	int ret = 0;
 
-	mem = mmap(NULL, ARM_PVTIME_BASE, PROT_RW,
+	mem = mmap(NULL, ARM_PVTIME_SIZE, PROT_RW,
 		   MAP_ANON_NORESERVE, -1, 0);
 	if (mem == MAP_FAILED)
 		return -errno;
 
 	ret = kvm__register_ram(kvm, ARM_PVTIME_BASE,
-				ARM_PVTIME_BASE, mem);
+				ARM_PVTIME_SIZE, mem);
 	if (ret) {
-		munmap(mem, ARM_PVTIME_BASE);
+		munmap(mem, ARM_PVTIME_SIZE);
 		return ret;
 	}
 
@@ -36,8 +36,8 @@ static int pvtime__teardown_region(struct kvm *kvm)
 		return 0;
 
 	kvm__destroy_mem(kvm, ARM_PVTIME_BASE,
-			 ARM_PVTIME_BASE, usr_mem);
-	munmap(usr_mem, ARM_PVTIME_BASE);
+			 ARM_PVTIME_SIZE, usr_mem);
+	munmap(usr_mem, ARM_PVTIME_SIZE);
 	usr_mem = NULL;
 	return 0;
 }
-- 
2.36.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

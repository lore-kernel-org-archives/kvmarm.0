Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01B2EC433EF
	for <kvmarm@archiver.kernel.org>; Wed,  9 Mar 2022 16:20:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F6F449F24;
	Wed,  9 Mar 2022 11:20:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pVEf7B18BHfm; Wed,  9 Mar 2022 11:20:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D56D411C7;
	Wed,  9 Mar 2022 11:20:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A00F7411C7
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2022 11:20:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hbPoChtviXKY for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2022 11:20:54 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 68CA0412FC
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2022 11:20:54 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BD673168F;
 Wed,  9 Mar 2022 08:20:53 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BF9B33F7F5;
 Wed,  9 Mar 2022 08:20:52 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: drjones@redhat.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 pbonzini@redhat.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH 1/2] arm: Change text base address for 32 bit
 tests when running under kvmtool
Date: Wed,  9 Mar 2022 16:21:16 +0000
Message-Id: <20220309162117.56681-2-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309162117.56681-1-alexandru.elisei@arm.com>
References: <20220309162117.56681-1-alexandru.elisei@arm.com>
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

The 32 bit tests do not have relocation support and rely on the build
system to set the text base address to 0x4001_0000, which is the memory
location where the test is placed by qemu. However, kvmtool loads a payload
at a different address, 0x8000_8000, when loading a test with --kernel.
When using --firmware, the default is 0x8000_0000, but that can be changed
with the --firmware-address comand line option.

When 32 bit tests are configured to run under kvmtool, set the text base
address to 0x8000_8000.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/Makefile.arm | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arm/Makefile.arm b/arm/Makefile.arm
index 3a4cc6b26234..01fd4c7bb6e2 100644
--- a/arm/Makefile.arm
+++ b/arm/Makefile.arm
@@ -14,7 +14,13 @@ CFLAGS += $(machine)
 CFLAGS += -mcpu=$(PROCESSOR)
 CFLAGS += -mno-unaligned-access
 
+ifeq ($(TARGET),qemu)
 arch_LDFLAGS = -Ttext=40010000
+else ifeq ($(TARGET),kvmtool)
+arch_LDFLAGS = -Ttext=80008000
+else
+$(error Unknown target $(TARGET))
+endif
 
 define arch_elf_check =
 endef
-- 
2.35.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

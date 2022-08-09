Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9BE8C25B06
	for <kvmarm@archiver.kernel.org>; Tue,  9 Aug 2022 09:15:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 457344C47F;
	Tue,  9 Aug 2022 05:15:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WCEX11eStofp; Tue,  9 Aug 2022 05:15:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 48E264C4EE;
	Tue,  9 Aug 2022 05:15:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B640F4C497
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 05:15:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id A3o9Aw3EsTJn for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Aug 2022 05:15:29 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 256FD4C47F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 05:15:29 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1B5B1ED1;
 Tue,  9 Aug 2022 02:15:29 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 386313F67D;
 Tue,  9 Aug 2022 02:15:27 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: pbonzini@redhat.com, thuth@redhat.com, andrew.jones@linux.dev,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, nikos.nikoleris@arm.com
Subject: [kvm-unit-tests RFC PATCH 01/19] Makefile: Define __ASSEMBLY__ for
 assembly files
Date: Tue,  9 Aug 2022 10:15:40 +0100
Message-Id: <20220809091558.14379-2-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809091558.14379-1-alexandru.elisei@arm.com>
References: <20220809091558.14379-1-alexandru.elisei@arm.com>
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

There are 25 header files today (found with grep -r "#ifndef __ASSEMBLY__)
with functionality relies on the __ASSEMBLY__ prepocessor constant being
correctly defined to work correctly. So far, kvm-unit-tests has relied on
the assembly files to define the constant before including any header
files which depend on it.

Let's make sure that nobody gets this wrong and define it as a compiler
constant when compiling assembly files. __ASSEMBLY__ is now defined for all
.S files, even those that didn't set it explicitely before.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 Makefile           | 5 ++++-
 arm/cstart.S       | 1 -
 arm/cstart64.S     | 1 -
 powerpc/cstart64.S | 1 -
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Makefile b/Makefile
index 6ed5deaccb41..42c61aa45d50 100644
--- a/Makefile
+++ b/Makefile
@@ -94,6 +94,9 @@ CFLAGS += $(wmissing_parameter_type)
 CFLAGS += $(wold_style_declaration)
 CFLAGS += -Woverride-init -Wmissing-prototypes -Wstrict-prototypes
 
+AFLAGS  = $(CFLAGS)
+AFLAGS += -D__ASSEMBLY__
+
 autodepend-flags = -MMD -MF $(dir $*).$(notdir $*).d
 
 LDFLAGS += $(CFLAGS)
@@ -117,7 +120,7 @@ directories:
 	@mkdir -p $(OBJDIRS)
 
 %.o: %.S
-	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
+	$(CC) $(AFLAGS) -c -nostdlib -o $@ $<
 
 -include */.*.d */*/.*.d
 
diff --git a/arm/cstart.S b/arm/cstart.S
index 7036e67fc0d8..39260e0fa470 100644
--- a/arm/cstart.S
+++ b/arm/cstart.S
@@ -5,7 +5,6 @@
  *
  * This work is licensed under the terms of the GNU LGPL, version 2.
  */
-#define __ASSEMBLY__
 #include <auxinfo.h>
 #include <asm/assembler.h>
 #include <asm/thread_info.h>
diff --git a/arm/cstart64.S b/arm/cstart64.S
index e4ab7d06251e..d62360cf3859 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -5,7 +5,6 @@
  *
  * This work is licensed under the terms of the GNU GPL, version 2.
  */
-#define __ASSEMBLY__
 #include <auxinfo.h>
 #include <asm/asm-offsets.h>
 #include <asm/assembler.h>
diff --git a/powerpc/cstart64.S b/powerpc/cstart64.S
index 972851f9ed65..1a823385fd0f 100644
--- a/powerpc/cstart64.S
+++ b/powerpc/cstart64.S
@@ -5,7 +5,6 @@
  *
  * This work is licensed under the terms of the GNU LGPL, version 2.
  */
-#define __ASSEMBLY__
 #include <asm/hcall.h>
 #include <asm/ppc_asm.h>
 #include <asm/rtas.h>
-- 
2.37.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

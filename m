Return-Path: <SRS0=EkBd=A4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A13FC433E2
	for <kvmarm@archiver.kernel.org>; Fri, 17 Jul 2020 16:46:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 630E520704
	for <kvmarm@archiver.kernel.org>; Fri, 17 Jul 2020 16:46:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 630E520704
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D954F4B1A7;
	Fri, 17 Jul 2020 12:46:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3sP9lF8Ju6ET; Fri, 17 Jul 2020 12:46:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC16C4B1A8;
	Fri, 17 Jul 2020 12:46:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 334C24B1A6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2020 12:46:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gaJAHULdEbFN for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jul 2020 12:46:44 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B84A4B1A5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2020 12:46:44 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A2E3612FC;
 Fri, 17 Jul 2020 09:46:43 -0700 (PDT)
Received: from monolith.arm.com (unknown [10.37.8.27])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B06213F68F;
 Fri, 17 Jul 2020 09:46:42 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH] arm64: Compile with -mno-outline-atomics for
 GCC >= 10
Date: Fri, 17 Jul 2020 17:47:27 +0100
Message-Id: <20200717164727.75580-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Cc: pbonzini@redhat.com
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

GCC 10.1.0 introduced the -m{,no-}outline-atomics flags which, according to
man 1 gcc:

"Enable or disable calls to out-of-line helpers to implement atomic
operations.  These helpers will, at runtime, determine if the LSE
instructions from ARMv8.1-A can be used; if not, they will use the
load/store-exclusive instructions that are present in the base ARMv8.0 ISA.
[..] This option is on by default."

Unfortunately the option causes the following error at compile time:

aarch64-linux-gnu-ld -nostdlib -pie -n -o arm/spinlock-test.elf -T /path/to/kvm-unit-tests/arm/flat.lds \
	arm/spinlock-test.o arm/cstart64.o lib/libcflat.a lib/libfdt/libfdt.a /usr/lib/gcc/aarch64-linux-gnu/10.1.0/libgcc.a lib/arm/libeabi.a arm/spinlock-test.aux.o
aarch64-linux-gnu-ld: /usr/lib/gcc/aarch64-linux-gnu/10.1.0/libgcc.a(lse-init.o): in function `init_have_lse_atomics':
lse-init.c:(.text.startup+0xc): undefined reference to `__getauxval'

This is happening because we are linking against our own libcflat which
doesn't implement the function __getauxval().

Disable the use of the out-of-line functions by compiling with
-mno-outline-atomics if we detect a GCC version greater than 10.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---

Tested with gcc versions 10.1.0 and 5.4.0 (cross-compilation), 9.3.0
(native).

I've been able to suss out the reason for the build failure from this
rejected gcc patch [1].

[1] https://patches.openembedded.org/patch/172460/

 arm/Makefile.arm64 | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index dfd0c56fe8fb..3223cb966789 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -9,6 +9,12 @@ ldarch = elf64-littleaarch64
 arch_LDFLAGS = -pie -n
 CFLAGS += -mstrict-align
 
+# The -mno-outline-atomics flag is only valid for GCC versions 10 and greater.
+GCC_MAJOR_VERSION=$(shell $(CC) -dumpversion 2> /dev/null | cut -f1 -d.)
+ifeq ($(shell expr "$(GCC_MAJOR_VERSION)" ">=" "10"), 1)
+CFLAGS += -mno-outline-atomics
+endif
+
 define arch_elf_check =
 	$(if $(shell ! $(OBJDUMP) -R $(1) >&/dev/null && echo "nok"),
 		$(error $(shell $(OBJDUMP) -R $(1) 2>&1)))
-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

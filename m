Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDB74C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 26 May 2022 15:31:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 40DCC4B32E;
	Thu, 26 May 2022 11:31:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GsbHqOpOGh73; Thu, 26 May 2022 11:30:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EF2F94B275;
	Thu, 26 May 2022 11:30:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3059A49EDF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 May 2022 11:30:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3wtEJ3PbPtbZ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 May 2022 11:30:56 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E534C4B203
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 May 2022 11:30:56 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 489E01688;
 Thu, 26 May 2022 08:30:56 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7B00D3F66F;
 Thu, 26 May 2022 08:30:54 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org,
 andre.przywara@arm.com, suzuki.poulose@arm.com, james.morse@arm.com,
 vladimir.murzin@arm.com, anup@brainfault.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Subject: [PATCH kvmtool 2/2] INSTALL: Remove all mentions of libfdt
Date: Thu, 26 May 2022 16:30:58 +0100
Message-Id: <20220526153058.123290-3-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220526153058.123290-1-alexandru.elisei@arm.com>
References: <20220526153058.123290-1-alexandru.elisei@arm.com>
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

kvmtool doesn't have a dependency on the external libfdt library anymore,
remove the instructions to compile and install it.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 INSTALL | 27 +--------------------------
 1 file changed, 1 insertion(+), 26 deletions(-)

diff --git a/INSTALL b/INSTALL
index 951b12339887..db51c0fa8db6 100644
--- a/INSTALL
+++ b/INSTALL
@@ -26,11 +26,6 @@ For Fedora based systems:
 For OpenSUSE based systems:
 	# zypper install glibc-devel-static
 
-Architectures which require device tree (PowerPC, ARM, ARM64, RISC-V) also
-require libfdt.
-	deb: $ sudo apt-get install libfdt-dev
-	Fedora: # yum install libfdt-devel
-	OpenSUSE: # zypper install libfdt1-devel
 Also see "Cross compiling" below.
 
 Optional libraries
@@ -77,24 +72,4 @@ Missing libraries when cross-compiling
 The cross-compiler will look for target libraries in its SYSROOT directory,
 so you need to put the header and library files (.so) there.
 While most cross compiler packages come with the target's glibc already
-installed, optional libraries (or libfdt) maybe not.
-On multiarch system you should be able to install those be appending
-the architecture name after the package (example for ARM64):
-$ sudo apt-get install libfdt-dev:arm64
-
-PowerPC, ARM/ARM64 and RISC-V require libfdt to be installed. If you cannot use
-precompiled mulitarch packages, you could either copy the required header and
-library files from an installed target system into the SYSROOT (you will need
-/usr/include/*fdt*.h and /usr/lib64/libfdt-v.v.v.so and its symlinks), or you
-can cross-compile the libfdt library yourself:
-
-$ git clone git://git.kernel.org/pub/scm/utils/dtc/dtc.git
-$ cd dtc
-$ export CC=${CROSS_COMPILE}gcc
-$ TRIPLET=$($CC -dumpmachine)
-$ SYSROOT=$($CC -print-sysroot)
-$ make libfdt
-$ sudo make DESTDIR=$SYSROOT PREFIX=/usr LIBDIR=/usr/lib/$TRIPLET install-lib install-includes
-
-This assumes a multiarch-enabled system, if there is no per-arch directory for
-libraries, replace the LIBDIR paths above with LIBDIR=/usr/lib or /usr/lib64.
+installed, optional libraries may not be present.
-- 
2.36.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

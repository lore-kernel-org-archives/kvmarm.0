Return-Path: <SRS0=5lJd=ZN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7562C432C0
	for <kvmarm@archiver.kernel.org>; Thu, 21 Nov 2019 03:20:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2077B208CC
	for <kvmarm@archiver.kernel.org>; Thu, 21 Nov 2019 03:20:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qfh0Brqg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2077B208CC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A001D4AEAA;
	Wed, 20 Nov 2019 22:20:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lrKAPSCp6Usm; Wed, 20 Nov 2019 22:20:27 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 773134AEAB;
	Wed, 20 Nov 2019 22:20:27 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A0A954AEA3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Nov 2019 22:20:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EN70x1wdqrOQ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Nov 2019 22:20:25 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7312F4A578
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Nov 2019 22:20:25 -0500 (EST)
Received: from PC-kkoz.proceq.com (unknown [213.160.61.66])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 76B19208CC;
 Thu, 21 Nov 2019 03:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1574306424;
 bh=ICtU3L2SGCxL5d13ilpqPvEB+MBDUd3UY3pWS7CJXr8=;
 h=From:To:Cc:Subject:Date:From;
 b=Qfh0BrqgN2Sy9wxcIiZHCkTPtNpWZNn7gC6G3huJi7Rk/QV/pi+qc4faZ1ocDVp8C
 A8vqTqeBi8mhKLq8xB0nWzTcg6ULzkWJImhdDHyT9GrXu5vNPaaVfoOveJmnvrDgCS
 WUKeWg1tY95otr4qGw7m2TNN+/9lZ6k5V73nAXT0=
From: Krzysztof Kozlowski <krzk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH v2] arm64: Fix Kconfig indentation
Date: Thu, 21 Nov 2019 04:20:20 +0100
Message-Id: <1574306420-23985-1-git-send-email-krzk@kernel.org>
X-Mailer: git-send-email 2.7.4
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Krzysztof Kozlowski <krzk@kernel.org>, linux-arm-kernel@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Adjust indentation from spaces to tab (+optional two spaces) as in
coding style with command like:
	$ sed -e 's/^        /\t/' -i */Kconfig

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

---

Changes since v1:
1. Fix also 7-space and tab+1 space indentation issues.
---
 arch/arm64/Kconfig     | 42 +++++++++++++++++++++---------------------
 arch/arm64/kvm/Kconfig |  2 +-
 2 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index c4d6d8d6b6c4..d31bf024830f 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -209,31 +209,31 @@ config ARM64_CONT_SHIFT
 	default 4
 
 config ARCH_MMAP_RND_BITS_MIN
-       default 14 if ARM64_64K_PAGES
-       default 16 if ARM64_16K_PAGES
-       default 18
+	default 14 if ARM64_64K_PAGES
+	default 16 if ARM64_16K_PAGES
+	default 18
 
 # max bits determined by the following formula:
 #  VA_BITS - PAGE_SHIFT - 3
 config ARCH_MMAP_RND_BITS_MAX
-       default 19 if ARM64_VA_BITS=36
-       default 24 if ARM64_VA_BITS=39
-       default 27 if ARM64_VA_BITS=42
-       default 30 if ARM64_VA_BITS=47
-       default 29 if ARM64_VA_BITS=48 && ARM64_64K_PAGES
-       default 31 if ARM64_VA_BITS=48 && ARM64_16K_PAGES
-       default 33 if ARM64_VA_BITS=48
-       default 14 if ARM64_64K_PAGES
-       default 16 if ARM64_16K_PAGES
-       default 18
+	default 19 if ARM64_VA_BITS=36
+	default 24 if ARM64_VA_BITS=39
+	default 27 if ARM64_VA_BITS=42
+	default 30 if ARM64_VA_BITS=47
+	default 29 if ARM64_VA_BITS=48 && ARM64_64K_PAGES
+	default 31 if ARM64_VA_BITS=48 && ARM64_16K_PAGES
+	default 33 if ARM64_VA_BITS=48
+	default 14 if ARM64_64K_PAGES
+	default 16 if ARM64_16K_PAGES
+	default 18
 
 config ARCH_MMAP_RND_COMPAT_BITS_MIN
-       default 7 if ARM64_64K_PAGES
-       default 9 if ARM64_16K_PAGES
-       default 11
+	default 7 if ARM64_64K_PAGES
+	default 9 if ARM64_16K_PAGES
+	default 11
 
 config ARCH_MMAP_RND_COMPAT_BITS_MAX
-       default 16
+	default 16
 
 config NO_IOPORT_MAP
 	def_bool y if !PCI
@@ -263,7 +263,7 @@ config GENERIC_HWEIGHT
 	def_bool y
 
 config GENERIC_CSUM
-        def_bool y
+	def_bool y
 
 config GENERIC_CALIBRATE_DELAY
 	def_bool y
@@ -886,8 +886,8 @@ choice
 	  that is selected here.
 
 config CPU_BIG_ENDIAN
-       bool "Build big-endian kernel"
-       help
+	bool "Build big-endian kernel"
+	help
 	  Say Y if you plan on running a kernel with a big-endian userspace.
 
 config CPU_LITTLE_ENDIAN
@@ -1670,7 +1670,7 @@ config EFI
 	help
 	  This option provides support for runtime services provided
 	  by UEFI firmware (such as non-volatile variables, realtime
-          clock, and platform reset). A UEFI stub is also provided to
+	  clock, and platform reset). A UEFI stub is also provided to
 	  allow the kernel to be booted as an EFI application. This
 	  is only useful on systems that have UEFI firmware.
 
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index a475c68cbfec..1b10785bc75a 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -62,7 +62,7 @@ config KVM_ARM_PMU
 	  virtual machines.
 
 config KVM_INDIRECT_VECTORS
-       def_bool KVM && (HARDEN_BRANCH_PREDICTOR || HARDEN_EL2_VECTORS)
+	def_bool KVM && (HARDEN_BRANCH_PREDICTOR || HARDEN_EL2_VECTORS)
 
 source "drivers/vhost/Kconfig"
 
-- 
2.7.4

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

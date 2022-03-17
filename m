Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 854EBC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 17 Mar 2022 16:55:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D48F149F28;
	Thu, 17 Mar 2022 12:55:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Pb5smnAnnOUf; Thu, 17 Mar 2022 12:55:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC02449F21;
	Thu, 17 Mar 2022 12:55:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 165FB49F21
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Mar 2022 12:55:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IYVsrqIv2nql for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Mar 2022 12:55:43 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B460B49F05
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Mar 2022 12:55:43 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 34B161682;
 Thu, 17 Mar 2022 09:55:43 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 797993F7B4;
 Thu, 17 Mar 2022 09:55:42 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: drjones@redhat.com,
	kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH] arm/run: Use TCG with qemu-system-arm on arm64
 systems
Date: Thu, 17 Mar 2022 16:56:01 +0000
Message-Id: <20220317165601.356466-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.35.1
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

From: Andrew Jones <drjones@redhat.com>

If the user sets QEMU=qemu-system-arm on arm64 systems, the tests can only
be run by using the TCG accelerator. In this case use TCG instead of KVM.

Signed-off-by: Andrew Jones <drjones@redhat.com>
[ Alex E: Added commit message ]
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/run | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arm/run b/arm/run
index 28a0b4ad2729..128489125dcb 100755
--- a/arm/run
+++ b/arm/run
@@ -10,16 +10,24 @@ if [ -z "$KUT_STANDALONE" ]; then
 fi
 processor="$PROCESSOR"
 
-ACCEL=$(get_qemu_accelerator) ||
+accel=$(get_qemu_accelerator) ||
 	exit $?
 
-if [ "$ACCEL" = "kvm" ]; then
+if [ "$accel" = "kvm" ]; then
 	QEMU_ARCH=$HOST
 fi
 
 qemu=$(search_qemu_binary) ||
 	exit $?
 
+if [ "$QEMU" ] && [ -z "$ACCEL" ] &&
+   [ "$HOST" = "aarch64" ] && [ "$ARCH" = "arm" ] &&
+   [ "$(basename $QEMU)" = "qemu-system-arm" ]; then
+	accel=tcg
+fi
+
+ACCEL=$accel
+
 if ! $qemu -machine '?' 2>&1 | grep 'ARM Virtual Machine' > /dev/null; then
 	echo "$qemu doesn't support mach-virt ('-machine virt'). Exiting."
 	exit 2
-- 
2.35.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

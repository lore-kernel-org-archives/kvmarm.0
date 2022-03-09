Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C42D9C433FE
	for <kvmarm@archiver.kernel.org>; Wed,  9 Mar 2022 16:20:59 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C49849F16;
	Wed,  9 Mar 2022 11:20:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id olp3SxDqbxyI; Wed,  9 Mar 2022 11:20:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3BA0E49F38;
	Wed,  9 Mar 2022 11:20:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 01F6143C96
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2022 11:20:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IkLWxsqgCd6m for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2022 11:20:55 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C46CF412FC
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2022 11:20:55 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 09B8B1691;
 Wed,  9 Mar 2022 08:20:55 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0C0933F7F5;
 Wed,  9 Mar 2022 08:20:53 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: drjones@redhat.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 pbonzini@redhat.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH 2/2] arm/run: Fix using qemu-system-aarch64 to
 run aarch32 tests on aarch64
Date: Wed,  9 Mar 2022 16:21:17 +0000
Message-Id: <20220309162117.56681-3-alexandru.elisei@arm.com>
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

From: Andrew Jones <drjones@redhat.com>

KVM on arm64 can create 32 bit and 64 bit VMs. kvm-unit-tests tries to
take advantage of this by setting the aarch64=off -cpu option. However,
get_qemu_accelerator() isn't aware that KVM on arm64 can run both types
of VMs and it selects qemu-system-arm instead of qemu-system-aarch64.
This leads to an error in premature_failure() and the test is marked as
skipped:

$ ./run_tests.sh selftest-setup
SKIP selftest-setup (qemu-system-arm: -accel kvm: invalid accelerator kvm)

Fix this by setting QEMU to the correct qemu binary before calling
get_qemu_accelerator().

Signed-off-by: Andrew Jones <drjones@redhat.com>
[ Alex E: Added commit message, changed the logic to make it clearer ]
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/run | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arm/run b/arm/run
index 2153bd320751..5fe0a45c4820 100755
--- a/arm/run
+++ b/arm/run
@@ -13,6 +13,11 @@ processor="$PROCESSOR"
 ACCEL=$(get_qemu_accelerator) ||
 	exit $?
 
+# KVM for arm64 can create a VM in either aarch32 or aarch64 modes.
+if [ "$ACCEL" = kvm ] && [ -z "$QEMU" ] && [ "$HOST" = "aarch64" ]; then
+	QEMU=qemu-system-aarch64
+fi
+
 qemu=$(search_qemu_binary) ||
 	exit $?
 
-- 
2.35.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B53E3C433FE
	for <kvmarm@archiver.kernel.org>; Mon, 14 Feb 2022 16:58:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 33C2B49F56;
	Mon, 14 Feb 2022 11:58:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kJbobPU9WjTw; Mon, 14 Feb 2022 11:58:26 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C88BB49F14;
	Mon, 14 Feb 2022 11:58:26 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA11649ECB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 11:58:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mldzm7BCLo9i for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Feb 2022 11:58:23 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2526249E27
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 11:58:23 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8974213D5;
 Mon, 14 Feb 2022 08:58:22 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 577363F70D;
 Mon, 14 Feb 2022 08:58:21 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org, julien.thierry.kdev@gmail.com, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, andre.przywara@arm.com,
 pierre.gondois@arm.com
Subject: [PATCH kvmtool 0/3] Misc fixes
Date: Mon, 14 Feb 2022 16:58:27 +0000
Message-Id: <20220214165830.69207-1-alexandru.elisei@arm.com>
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

These are a handful of small fixes for random stuff which I found while
using kvmtool.

Patch #1 is actually needed to use kvmtool as a test runner for
kvm-unit-tests (more detailed explanation in the commit message).

Patch #2 is more like a quality of life improvement for users.

Patch #3 is for something that I found when a Linux guest complained that
"msi-parent" was referencing an invalid phandle (I don't remember the
kernel version, defconfig and VM configuration that I used, couldn't
reproduce it with a v5.16 guest); it was also reported to me by Pierre, so
I figured it deserves a fix.

Alexandru Elisei (3):
  Remove initrd magic check
  arm: Use pr_debug() to print memory layout when loading a firmware
    image
  arm: pci: Generate "msi-parent" property only with a MSI controller

 arm/fdt.c                    |  2 +-
 arm/include/arm-common/pci.h |  3 ++-
 arm/kvm.c                    |  8 +++++---
 arm/pci.c                    |  8 ++++++--
 kvm.c                        | 22 ----------------------
 5 files changed, 14 insertions(+), 29 deletions(-)

-- 
2.31.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

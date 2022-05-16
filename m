Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEB2FC433F5
	for <kvmarm@archiver.kernel.org>; Mon, 16 May 2022 15:55:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A8434B297;
	Mon, 16 May 2022 11:55:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yqaYMvi3PPQA; Mon, 16 May 2022 11:55:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 082AB4B299;
	Mon, 16 May 2022 11:55:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2046B4B28B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 11:55:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qIBvQQ9kiK8o for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 May 2022 11:55:24 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CB8E24B200
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 11:55:24 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 67A7411FB;
 Mon, 16 May 2022 08:55:24 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 03D2B3F73D;
 Mon, 16 May 2022 08:55:22 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org,
 suzuki.poulose@arm.com, julien@xen.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 james.morse@arm.com
Subject: [PATCH v2 kvmtool 01/12] Use MB for megabytes consistently
Date: Mon, 16 May 2022 16:55:15 +0100
Message-Id: <20220516155526.181694-2-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516155526.181694-1-alexandru.elisei@arm.com>
References: <20220516155526.181694-1-alexandru.elisei@arm.com>
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

The help text for the -m/--mem argument states that the guest memory size
is in MiB (mebibyte). MiB is the same thing as MB (megabyte), and indeed
this is how MB is used throughout kvmtool.

Replace MiB with MB, so people don't get the wrong idea and start
believing that for kvmtool a MB is 10^6 bytes instead of 2^20.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 Documentation/kvmtool.1 | 4 ++--
 builtin-run.c           | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/kvmtool.1 b/Documentation/kvmtool.1
index 2b8c274dc3ff..25d46f8f51f9 100644
--- a/Documentation/kvmtool.1
+++ b/Documentation/kvmtool.1
@@ -10,7 +10,7 @@ kvmtool is a userland tool for creating and controlling KVM guests.
 .SH "KVMTOOL COMMANDS"
 .sp
 .PP
-.B run -k <kernel\-image> [\-c <cores>] [\-m <MiB>] [\-p <command line>]
+.B run -k <kernel\-image> [\-c <cores>] [\-m <MB>] [\-p <command line>]
 .br
 .B [\-i <initrd>] [\-d <image file>] [\-\-console serial|virtio|hv]
 .br
@@ -30,7 +30,7 @@ The number of virtual CPUs to run.
 .sp
 .B \-m, \-\-mem <n>
 .RS 4
-Virtual machine memory size in MiB.
+Virtual machine memory size in MB.
 .RE
 .sp
 .B \-p, \-\-params <parameters>
diff --git a/builtin-run.c b/builtin-run.c
index 9a1a0c1fa6fb..0126c9fbcba6 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -97,7 +97,7 @@ void kvm_run_set_wrapper_sandbox(void)
 			"A name for the guest"),			\
 	OPT_INTEGER('c', "cpus", &(cfg)->nrcpus, "Number of CPUs"),	\
 	OPT_U64('m', "mem", &(cfg)->ram_size, "Virtual machine memory"	\
-		" size in MiB."),					\
+		" size in MB."),					\
 	OPT_CALLBACK('d', "disk", kvm, "image or rootfs_dir", "Disk "	\
 			" image or rootfs directory", img_name_parser,	\
 			kvm),						\
-- 
2.36.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

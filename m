Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C5E5C43334
	for <kvmarm@archiver.kernel.org>; Thu, 16 Jun 2022 13:48:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F4534B1EF;
	Thu, 16 Jun 2022 09:48:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ayr5oixFdvXI; Thu, 16 Jun 2022 09:48:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B0FF4B2B8;
	Thu, 16 Jun 2022 09:48:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5359B410F6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 09:48:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id llGc0CNEKPA8 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Jun 2022 09:48:39 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E958B49E3C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 09:48:38 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 88FF212FC;
 Thu, 16 Jun 2022 06:48:38 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E03E33F7F5;
 Thu, 16 Jun 2022 06:48:36 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org,
 suzuki.poulose@arm.com, julien@xen.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 james.morse@arm.com, andre.przywara@arm.com
Subject: [PATCH v4 kvmtool 08/12] builtin_run: Allow standard size specifiers
 for memory
Date: Thu, 16 Jun 2022 14:48:24 +0100
Message-Id: <20220616134828.129006-9-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220616134828.129006-1-alexandru.elisei@arm.com>
References: <20220616134828.129006-1-alexandru.elisei@arm.com>
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

From: Suzuki K Poulose <suzuki.poulose@arm.com>

Allow the user to use the standard B (bytes), K (kilobytes), M (megabytes),
G (gigabytes), T (terabytes) and P (petabytes) suffixes for memory size.
When none are specified, the default is megabytes.

Also raise an error if the guest specifies 0 as the memory size, instead
of treating it as uninitialized, as kvmtool has done so far.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 builtin-run.c | 59 ++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 54 insertions(+), 5 deletions(-)

diff --git a/builtin-run.c b/builtin-run.c
index dcd08f739469..8b4e865f0a0e 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -49,9 +49,11 @@
 #include <ctype.h>
 #include <stdio.h>
 
-#define MB_SHIFT		(20)
 #define KB_SHIFT		(10)
+#define MB_SHIFT		(20)
 #define GB_SHIFT		(30)
+#define TB_SHIFT		(40)
+#define PB_SHIFT		(50)
 
 __thread struct kvm_cpu *current_kvm_cpu;
 
@@ -87,6 +89,54 @@ void kvm_run_set_wrapper_sandbox(void)
 	kvm_run_wrapper = KVM_RUN_SANDBOX;
 }
 
+static int parse_mem_unit(char **next)
+{
+	switch (**next) {
+	case 'B': case 'b': (*next)++; return 0;
+	case 'K': case 'k': (*next)++; return KB_SHIFT;
+	case 'M': case 'm': (*next)++; return MB_SHIFT;
+	case 'G': case 'g': (*next)++; return GB_SHIFT;
+	case 'T': case 't': (*next)++; return TB_SHIFT;
+	case 'P': case 'p': (*next)++; return PB_SHIFT;
+	}
+
+	return MB_SHIFT;
+}
+
+static u64 parse_mem_option(const char *nptr, char **next)
+{
+	u64 shift;
+	u64 val;
+
+	errno = 0;
+	val = strtoull(nptr, next, 10);
+	if (errno == ERANGE)
+		die("Memory too large: %s", nptr);
+	if (*next == nptr)
+		die("Invalid memory specifier: %s", nptr);
+
+	shift = parse_mem_unit(next);
+	if ((val << shift) < val)
+		die("Memory too large: %s", nptr);
+
+	return val << shift;
+}
+
+static int mem_parser(const struct option *opt, const char *arg, int unset)
+{
+	struct kvm *kvm = opt->ptr;
+	char *next;
+
+	kvm->cfg.ram_size = parse_mem_option(arg, &next);
+	if (kvm->cfg.ram_size == 0)
+		die("Invalid RAM size: %s", arg);
+
+	if (*next != '\0')
+		die("Invalid memory specifier: %s", arg);
+
+	return 0;
+}
+
 #ifndef OPT_ARCH_RUN
 #define OPT_ARCH_RUN(...)
 #endif
@@ -97,8 +147,9 @@ void kvm_run_set_wrapper_sandbox(void)
 	OPT_STRING('\0', "name", &(cfg)->guest_name, "guest name",	\
 			"A name for the guest"),			\
 	OPT_INTEGER('c', "cpus", &(cfg)->nrcpus, "Number of CPUs"),	\
-	OPT_U64('m', "mem", &(cfg)->ram_size, "Virtual machine memory"	\
-		" size in MB."),					\
+	OPT_CALLBACK('m', "mem", NULL, "size[BKMGTP]",			\
+		     "Virtual machine memory size, by default measured"	\
+		     " in megabytes (M)", mem_parser, kvm),		\
 	OPT_CALLBACK('d', "disk", kvm, "image or rootfs_dir", "Disk "	\
 			" image or rootfs directory", img_name_parser,	\
 			kvm),						\
@@ -522,8 +573,6 @@ static void kvm_run_validate_cfg(struct kvm *kvm)
 		pr_warning("Ignoring initrd file when loading a firmware image");
 
 	if (kvm->cfg.ram_size) {
-		/* User specifies RAM size in megabytes. */
-		kvm->cfg.ram_size <<= MB_SHIFT;
 		available_ram = host_ram_size();
 		if (available_ram && kvm->cfg.ram_size > available_ram) {
 			pr_warning("Guest memory size %lluMB exceeds host physical RAM size %lluMB",
-- 
2.36.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

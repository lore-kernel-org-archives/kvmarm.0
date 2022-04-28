Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFA4FC433F5
	for <kvmarm@archiver.kernel.org>; Thu, 28 Apr 2022 15:56:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D0794B293;
	Thu, 28 Apr 2022 11:56:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Kd38CqxEkomq; Thu, 28 Apr 2022 11:56:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 34F804B284;
	Thu, 28 Apr 2022 11:56:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 360154B25C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Apr 2022 11:56:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rAa7WMJCieRw for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Apr 2022 11:56:13 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 21FD54B26D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Apr 2022 11:56:12 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BF2861474;
 Thu, 28 Apr 2022 08:56:11 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5A1763F774;
 Thu, 28 Apr 2022 08:56:10 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: julien.thierry.kdev@gmail.com, will@kernel.org, maz@kernel.org,
 suzuki.poulose@arm.com, julien@xen.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 james.morse@arm.com
Subject: [PATCH kvmtool 03/15] builtin-run: Rework RAM size validation
Date: Thu, 28 Apr 2022 16:55:50 +0100
Message-Id: <20220428155602.29445-4-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220428155602.29445-1-alexandru.elisei@arm.com>
References: <20220428155602.29445-1-alexandru.elisei@arm.com>
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

host_ram_size() uses sysconf() to calculate the available ram, and
sysconf() can fail. When that happens, host_ram_size() returns 0. kvmtool
warns the user when the configured VM ram size exceeds the size of the
host's memory, but doesn't take into account that host_ram_size() can
return 0. If the function returns zero, skip the warning.

Since this can only happen when the user sets the memory size (via the
-m/--mem command line argument), skip the check entirely if the user hasn't
set it. Move the check to kvm_run_validate_cfg(), as it checks for valid
user configuration.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 builtin-run.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/builtin-run.c b/builtin-run.c
index 236c59d2f86f..4491fd244f8c 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -509,6 +509,8 @@ static void kvm_run_set_real_cmdline(struct kvm *kvm)
 
 static void kvm_run_validate_cfg(struct kvm *kvm)
 {
+	u64 available_ram;
+
 	if (kvm->cfg.kernel_filename && kvm->cfg.firmware_filename)
 		die("Only one of --kernel or --firmware can be specified");
 
@@ -518,6 +520,17 @@ static void kvm_run_validate_cfg(struct kvm *kvm)
 
 	if (kvm->cfg.firmware_filename && kvm->cfg.initrd_filename)
 		pr_warning("Ignoring initrd file when loading a firmware image");
+
+	if (kvm->cfg.ram_size) {
+		/* User specifies RAM size in megabytes. */
+		kvm->cfg.ram_size <<= MB_SHIFT;
+		available_ram = host_ram_size();
+		if (available_ram && kvm->cfg.ram_size > available_ram) {
+			pr_warning("Guest memory size %lluMB exceeds host physical RAM size %lluMB",
+				(unsigned long long)kvm->cfg.ram_size >> MB_SHIFT,
+				(unsigned long long)available_ram >> MB_SHIFT);
+		}
+	}
 }
 
 static struct kvm *kvm_cmd_run_init(int argc, const char **argv)
@@ -596,13 +609,6 @@ static struct kvm *kvm_cmd_run_init(int argc, const char **argv)
 
 	if (!kvm->cfg.ram_size)
 		kvm->cfg.ram_size = get_ram_size(kvm->cfg.nrcpus);
-	else
-		kvm->cfg.ram_size <<= MB_SHIFT;
-
-	if (kvm->cfg.ram_size > host_ram_size())
-		pr_warning("Guest memory size %lluMB exceeds host physical RAM size %lluMB",
-			(unsigned long long)kvm->cfg.ram_size >> MB_SHIFT,
-			(unsigned long long)host_ram_size() >> MB_SHIFT);
 
 	if (!kvm->cfg.dev)
 		kvm->cfg.dev = DEFAULT_KVM_DEV;
-- 
2.36.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

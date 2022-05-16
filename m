Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E57CC433EF
	for <kvmarm@archiver.kernel.org>; Mon, 16 May 2022 15:55:32 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9EE514B28D;
	Mon, 16 May 2022 11:55:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tkTkvRUH2TIo; Mon, 16 May 2022 11:55:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F9DA4B29C;
	Mon, 16 May 2022 11:55:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D5904B296
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 11:55:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3fUpeljYfXwd for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 May 2022 11:55:27 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C8B904B293
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 11:55:26 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6777212FC;
 Mon, 16 May 2022 08:55:26 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 03DFE3F73D;
 Mon, 16 May 2022 08:55:24 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org,
 suzuki.poulose@arm.com, julien@xen.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 james.morse@arm.com
Subject: [PATCH v2 kvmtool 02/12] builtin-run: Always use RAM size in bytes
Date: Mon, 16 May 2022 16:55:16 +0100
Message-Id: <20220516155526.181694-3-alexandru.elisei@arm.com>
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

The user can specify the virtual machine memory size in MB, which is saved
in cfg->ram_size. kvmtool validates it against the host memory size,
converted from bytes to MB. ram_size is then converted to bytes, and this
is how it is used throughout the rest of kvmtool.

To avoid any confusion about the unit of measurement, especially once the
user is allowed to specify the unit of measurement, always use ram_size in
bytes.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 builtin-run.c            | 19 ++++++++++---------
 include/kvm/kvm-config.h |  7 ++++---
 include/kvm/kvm.h        |  2 +-
 3 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/builtin-run.c b/builtin-run.c
index 0126c9fbcba6..236c59d2f86f 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -36,6 +36,7 @@
 
 #include <linux/types.h>
 #include <linux/err.h>
+#include <linux/sizes.h>
 
 #include <sys/utsname.h>
 #include <sys/types.h>
@@ -264,7 +265,7 @@ static u64 host_ram_size(void)
 		return 0;
 	}
 
-	return (nr_pages * page_size) >> MB_SHIFT;
+	return nr_pages * page_size;
 }
 
 /*
@@ -278,11 +279,11 @@ static u64 get_ram_size(int nr_cpus)
 	u64 available;
 	u64 ram_size;
 
-	ram_size	= 64 * (nr_cpus + 3);
+	ram_size	= SZ_64M * (nr_cpus + 3);
 
 	available	= host_ram_size() * RAM_SIZE_RATIO;
 	if (!available)
-		available = MIN_RAM_SIZE_MB;
+		available = MIN_RAM_SIZE;
 
 	if (ram_size > available)
 		ram_size	= available;
@@ -595,13 +596,13 @@ static struct kvm *kvm_cmd_run_init(int argc, const char **argv)
 
 	if (!kvm->cfg.ram_size)
 		kvm->cfg.ram_size = get_ram_size(kvm->cfg.nrcpus);
+	else
+		kvm->cfg.ram_size <<= MB_SHIFT;
 
 	if (kvm->cfg.ram_size > host_ram_size())
 		pr_warning("Guest memory size %lluMB exceeds host physical RAM size %lluMB",
-			(unsigned long long)kvm->cfg.ram_size,
-			(unsigned long long)host_ram_size());
-
-	kvm->cfg.ram_size <<= MB_SHIFT;
+			(unsigned long long)kvm->cfg.ram_size >> MB_SHIFT,
+			(unsigned long long)host_ram_size() >> MB_SHIFT);
 
 	if (!kvm->cfg.dev)
 		kvm->cfg.dev = DEFAULT_KVM_DEV;
@@ -676,12 +677,12 @@ static struct kvm *kvm_cmd_run_init(int argc, const char **argv)
 	if (kvm->cfg.kernel_filename) {
 		printf("  # %s run -k %s -m %Lu -c %d --name %s\n", KVM_BINARY_NAME,
 		       kvm->cfg.kernel_filename,
-		       (unsigned long long)kvm->cfg.ram_size / 1024 / 1024,
+		       (unsigned long long)kvm->cfg.ram_size >> MB_SHIFT,
 		       kvm->cfg.nrcpus, kvm->cfg.guest_name);
 	} else if (kvm->cfg.firmware_filename) {
 		printf("  # %s run --firmware %s -m %Lu -c %d --name %s\n", KVM_BINARY_NAME,
 		       kvm->cfg.firmware_filename,
-		       (unsigned long long)kvm->cfg.ram_size / 1024 / 1024,
+		       (unsigned long long)kvm->cfg.ram_size >> MB_SHIFT,
 		       kvm->cfg.nrcpus, kvm->cfg.guest_name);
 	}
 
diff --git a/include/kvm/kvm-config.h b/include/kvm/kvm-config.h
index 6a5720c4c7d4..31bc89520d52 100644
--- a/include/kvm/kvm-config.h
+++ b/include/kvm/kvm-config.h
@@ -5,6 +5,8 @@
 #include "kvm/vfio.h"
 #include "kvm/kvm-config-arch.h"
 
+#include <linux/sizes.h>
+
 #define DEFAULT_KVM_DEV		"/dev/kvm"
 #define DEFAULT_CONSOLE		"serial"
 #define DEFAULT_NETWORK		"user"
@@ -15,14 +17,13 @@
 #define DEFAULT_SCRIPT		"none"
 #define DEFAULT_SANDBOX_FILENAME "guest/sandbox.sh"
 
-#define MIN_RAM_SIZE_MB		(64ULL)
-#define MIN_RAM_SIZE_BYTE	(MIN_RAM_SIZE_MB << MB_SHIFT)
+#define MIN_RAM_SIZE		SZ_64M
 
 struct kvm_config {
 	struct kvm_config_arch arch;
 	struct disk_image_params disk_image[MAX_DISK_IMAGES];
 	struct vfio_device_params *vfio_devices;
-	u64 ram_size;
+	u64 ram_size;		/* Guest memory size, in bytes */
 	u8 num_net_devices;
 	u8 num_vfio_devices;
 	u64 vsock_cid;
diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
index ad732e56f5ed..7b14b33b50ca 100644
--- a/include/kvm/kvm.h
+++ b/include/kvm/kvm.h
@@ -87,7 +87,7 @@ struct kvm {
 	struct kvm_cpu		**cpus;
 
 	u32			mem_slots;	/* for KVM_SET_USER_MEMORY_REGION */
-	u64			ram_size;
+	u64			ram_size;	/* Guest memory size, in bytes */
 	void			*ram_start;
 	u64			ram_pagesize;
 	struct mutex		mem_banks_lock;
-- 
2.36.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

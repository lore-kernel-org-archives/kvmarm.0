Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 665A2C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 16 Jun 2022 13:48:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C2A44A014;
	Thu, 16 Jun 2022 09:48:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MwV9TI622m9t; Thu, 16 Jun 2022 09:48:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 00B2849F6C;
	Thu, 16 Jun 2022 09:48:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CE804B1F3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 09:48:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0MyRr4Ae7juN for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Jun 2022 09:48:47 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 470834B1ED
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 09:48:46 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 15A4E12FC;
 Thu, 16 Jun 2022 06:48:46 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 69FC63F7F5;
 Thu, 16 Jun 2022 06:48:44 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org,
 suzuki.poulose@arm.com, julien@xen.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 james.morse@arm.com, andre.przywara@arm.com
Subject: [PATCH v4 kvmtool 12/12] arm64: Allow the user to specify the RAM
 base address
Date: Thu, 16 Jun 2022 14:48:28 +0100
Message-Id: <20220616134828.129006-13-alexandru.elisei@arm.com>
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

Allow the user to specify the RAM base address by using -m/--mem size@addr
command line argument. The base address must be above 2GB, as to not
overlap with the MMIO I/O region.

Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/aarch64/include/kvm/kvm-arch.h |  2 ++
 arm/aarch64/kvm.c                  | 14 ++++++++----
 arm/kvm.c                          |  7 ++++--
 builtin-run.c                      | 36 ++++++++++++++++++++++++++----
 include/kvm/kvm-config.h           |  1 +
 include/kvm/kvm.h                  | 12 ++++++++++
 include/linux/sizes.h              |  2 ++
 7 files changed, 64 insertions(+), 10 deletions(-)

diff --git a/arm/aarch64/include/kvm/kvm-arch.h b/arm/aarch64/include/kvm/kvm-arch.h
index ff857ca6e7b4..02d09a413831 100644
--- a/arm/aarch64/include/kvm/kvm-arch.h
+++ b/arm/aarch64/include/kvm/kvm-arch.h
@@ -10,6 +10,8 @@ void kvm__arch_enable_mte(struct kvm *kvm);
 
 #define MAX_PAGE_SIZE	SZ_64K
 
+#define ARCH_HAS_CFG_RAM_ADDRESS	1
+
 #include "arm-common/kvm-arch.h"
 
 #endif /* KVM__KVM_ARCH_H */
diff --git a/arm/aarch64/kvm.c b/arm/aarch64/kvm.c
index 357936844046..54200c9eec9d 100644
--- a/arm/aarch64/kvm.c
+++ b/arm/aarch64/kvm.c
@@ -4,6 +4,7 @@
 
 #include <linux/byteorder.h>
 #include <linux/cpumask.h>
+#include <linux/sizes.h>
 
 #include <kvm/util.h>
 
@@ -39,10 +40,15 @@ int vcpu_affinity_parser(const struct option *opt, const char *arg, int unset)
 
 void kvm__arch_validate_cfg(struct kvm *kvm)
 {
+
+	if (kvm->cfg.ram_addr < ARM_MEMORY_AREA) {
+		die("RAM address is below the I/O region ending at %luGB",
+		    ARM_MEMORY_AREA >> 30);
+	}
+
 	if (kvm->cfg.arch.aarch32_guest &&
-	    kvm->cfg.ram_size > ARM_LOMAP_MAX_MEMORY) {
-		die("RAM size 0x%llx exceeds maximum allowed 0x%llx",
-		    kvm->cfg.ram_size, ARM_LOMAP_MAX_MEMORY);
+	    kvm->cfg.ram_addr + kvm->cfg.ram_size > SZ_4G) {
+		die("RAM extends above 4GB");
 	}
 }
 
@@ -117,7 +123,7 @@ int kvm__get_vm_type(struct kvm *kvm)
 		return 0;
 
 	/* Otherwise, compute the minimal required IPA size */
-	max_ipa = ARM_MEMORY_AREA + kvm->cfg.ram_size - 1;
+	max_ipa = kvm->cfg.ram_addr + kvm->cfg.ram_size - 1;
 	ipa_bits = max(32, fls_long(max_ipa));
 	pr_debug("max_ipa %lx ipa_bits %d max_ipa_bits %d",
 		 max_ipa, ipa_bits, max_ipa_bits);
diff --git a/arm/kvm.c b/arm/kvm.c
index abcccfabf59e..d51cc15d8b1c 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -55,7 +55,7 @@ void kvm__init_ram(struct kvm *kvm)
 	madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
 		MADV_HUGEPAGE);
 
-	phys_start	= ARM_MEMORY_AREA;
+	phys_start	= kvm->cfg.ram_addr;
 	phys_size	= kvm->ram_size;
 	host_mem	= kvm->ram_start;
 
@@ -65,6 +65,9 @@ void kvm__init_ram(struct kvm *kvm)
 		    "address 0x%llx [err %d]", phys_size, phys_start, err);
 
 	kvm->arch.memory_guest_start = phys_start;
+
+	pr_debug("RAM created at 0x%llx - 0x%llx",
+		 phys_start, phys_start + phys_size - 1);
 }
 
 void kvm__arch_delete_ram(struct kvm *kvm)
@@ -201,7 +204,7 @@ bool kvm__load_firmware(struct kvm *kvm, const char *firmware_filename)
 
 	/* For default firmware address, lets load it at the begining of RAM */
 	if (fw_addr == 0)
-		fw_addr = ARM_MEMORY_AREA;
+		fw_addr = kvm->arch.memory_guest_start;
 
 	if (!validate_fw_addr(kvm, fw_addr))
 		die("Bad firmware destination: 0x%016llx", fw_addr);
diff --git a/builtin-run.c b/builtin-run.c
index 8b4e865f0a0e..87023e390e73 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -125,12 +125,21 @@ static u64 parse_mem_option(const char *nptr, char **next)
 static int mem_parser(const struct option *opt, const char *arg, int unset)
 {
 	struct kvm *kvm = opt->ptr;
-	char *next;
+	char *next, *nptr;
 
 	kvm->cfg.ram_size = parse_mem_option(arg, &next);
 	if (kvm->cfg.ram_size == 0)
 		die("Invalid RAM size: %s", arg);
 
+	if (kvm__arch_has_cfg_ram_address() && *next == '@') {
+		next++;
+		if (*next == '\0')
+			die("Missing memory address: %s", arg);
+
+		nptr = next;
+		kvm->cfg.ram_addr = parse_mem_option(nptr, &next);
+	}
+
 	if (*next != '\0')
 		die("Invalid memory specifier: %s", arg);
 
@@ -141,15 +150,26 @@ static int mem_parser(const struct option *opt, const char *arg, int unset)
 #define OPT_ARCH_RUN(...)
 #endif
 
+#ifdef ARCH_HAS_CFG_RAM_ADDRESS
+#define MEM_OPT_HELP_SHORT	"size[BKMGTP][@addr[BKMGTP]]"
+#define MEM_OPT_HELP_LONG						\
+	"Virtual machine memory size and optional base address, both"	\
+	" measured by default in megabytes (M)"
+#else
+#define MEM_OPT_HELP_SHORT	"size[BKMGTP]"
+#define MEM_OPT_HELP_LONG						\
+	"Virtual machine memory size, by default measured in"		\
+	" in megabytes (M)"
+#endif
+
 #define BUILD_OPTIONS(name, cfg, kvm)					\
 	struct option name[] = {					\
 	OPT_GROUP("Basic options:"),					\
 	OPT_STRING('\0', "name", &(cfg)->guest_name, "guest name",	\
 			"A name for the guest"),			\
 	OPT_INTEGER('c', "cpus", &(cfg)->nrcpus, "Number of CPUs"),	\
-	OPT_CALLBACK('m', "mem", NULL, "size[BKMGTP]",			\
-		     "Virtual machine memory size, by default measured"	\
-		     " in megabytes (M)", mem_parser, kvm),		\
+	OPT_CALLBACK('m', "mem", NULL, MEM_OPT_HELP_SHORT,		\
+		     MEM_OPT_HELP_LONG, mem_parser, kvm),		\
 	OPT_CALLBACK('d', "disk", kvm, "image or rootfs_dir", "Disk "	\
 			" image or rootfs directory", img_name_parser,	\
 			kvm),						\
@@ -595,6 +615,14 @@ static struct kvm *kvm_cmd_run_init(int argc, const char **argv)
 
 	nr_online_cpus = sysconf(_SC_NPROCESSORS_ONLN);
 	kvm->cfg.custom_rootfs_name = "default";
+	/*
+	 * An architecture can allow the user to set the RAM base address to
+	 * zero. Initialize the address before parsing the command line
+	 * arguments, otherwise it will be impossible to distinguish between the
+	 * user setting the base address to zero or letting it unset and using
+	 * the default value.
+	 */
+	kvm->cfg.ram_addr = kvm__arch_default_ram_address();
 
 	while (argc != 0) {
 		BUILD_OPTIONS(options, &kvm->cfg, kvm);
diff --git a/include/kvm/kvm-config.h b/include/kvm/kvm-config.h
index 31bc89520d52..45fe1caaebce 100644
--- a/include/kvm/kvm-config.h
+++ b/include/kvm/kvm-config.h
@@ -23,6 +23,7 @@ struct kvm_config {
 	struct kvm_config_arch arch;
 	struct disk_image_params disk_image[MAX_DISK_IMAGES];
 	struct vfio_device_params *vfio_devices;
+	u64 ram_addr;		/* Guest memory physical base address, in bytes */
 	u64 ram_size;		/* Guest memory size, in bytes */
 	u8 num_net_devices;
 	u8 num_vfio_devices;
diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
index 360430b78b1e..eb23e2f77310 100644
--- a/include/kvm/kvm.h
+++ b/include/kvm/kvm.h
@@ -197,6 +197,18 @@ int kvm__arch_free_firmware(struct kvm *kvm);
 bool kvm__arch_cpu_supports_vm(void);
 void kvm__arch_read_term(struct kvm *kvm);
 
+#ifdef ARCH_HAS_CFG_RAM_ADDRESS
+static inline bool kvm__arch_has_cfg_ram_address(void)
+{
+	return true;
+}
+#else
+static inline bool kvm__arch_has_cfg_ram_address(void)
+{
+	return false;
+}
+#endif
+
 void *guest_flat_to_host(struct kvm *kvm, u64 offset);
 u64 host_to_guest_flat(struct kvm *kvm, void *ptr);
 
diff --git a/include/linux/sizes.h b/include/linux/sizes.h
index ce3e8150c174..bc621db852d9 100644
--- a/include/linux/sizes.h
+++ b/include/linux/sizes.h
@@ -44,4 +44,6 @@
 #define SZ_1G				0x40000000
 #define SZ_2G				0x80000000
 
+#define SZ_4G				0x100000000ULL
+
 #endif /* __LINUX_SIZES_H__ */
-- 
2.36.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

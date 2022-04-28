Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CDFDC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 28 Apr 2022 15:56:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E4D7A4B2A3;
	Thu, 28 Apr 2022 11:56:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OC0kjsGdsgNp; Thu, 28 Apr 2022 11:56:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 889724B2B1;
	Thu, 28 Apr 2022 11:56:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A9CB4B25C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Apr 2022 11:56:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oN6udhYT5zQI for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Apr 2022 11:56:28 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D0C244B29E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Apr 2022 11:56:28 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9A27E1477;
 Thu, 28 Apr 2022 08:56:28 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3884A3F774;
 Thu, 28 Apr 2022 08:56:27 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: julien.thierry.kdev@gmail.com, will@kernel.org, maz@kernel.org,
 suzuki.poulose@arm.com, julien@xen.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 james.morse@arm.com
Subject: [PATCH kvmtool 13/15] arm/arm64: Allow standard size specifiers for
 firmware address
Date: Thu, 28 Apr 2022 16:56:00 +0100
Message-Id: <20220428155602.29445-14-alexandru.elisei@arm.com>
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

The arm and arm64 permit the user to specify the load address, in RAM, for
the firmware image. Make it possible to use the standard size specifiers
(B/K/M/G/P/T) when doing so.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/include/arm-common/kvm-config-arch.h |  7 +++++--
 arm/kvm.c                                | 13 +++++++++++++
 builtin-run.c                            |  2 +-
 include/kvm/kvm.h                        |  1 +
 4 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/arm/include/arm-common/kvm-config-arch.h b/arm/include/arm-common/kvm-config-arch.h
index cdcbf235ac4e..9306608cbe4e 100644
--- a/arm/include/arm-common/kvm-config-arch.h
+++ b/arm/include/arm-common/kvm-config-arch.h
@@ -17,6 +17,7 @@ struct kvm_config_arch {
 };
 
 int irqchip_parser(const struct option *opt, const char *arg, int unset);
+int fw_addr_parser(const struct option *opt, const char *arg, int unset);
 
 #define OPT_ARCH_RUN(pfx, cfg)							\
 	pfx,									\
@@ -34,7 +35,9 @@ int irqchip_parser(const struct option *opt, const char *arg, int unset);
 		     "[gicv2|gicv2m|gicv3|gicv3-its]",				\
 		     "Type of interrupt controller to emulate in the guest",	\
 		     irqchip_parser, NULL),					\
-	OPT_U64('\0', "firmware-address", &(cfg)->fw_addr,			\
-		"Address where firmware should be loaded"),
+	OPT_CALLBACK('\0', "firmware-address", NULL, "addr[BKMGTP]",		\
+		     "Address where firmware should be loaded. The default unit"\
+		     " of measurement is megabytes (M)",			\
+		     fw_addr_parser, kvm),
 
 #endif /* ARM_COMMON__KVM_CONFIG_ARCH_H */
diff --git a/arm/kvm.c b/arm/kvm.c
index d51cc15d8b1c..83df1c9a0cde 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -18,6 +18,19 @@ struct kvm_ext kvm_req_ext[] = {
 	{ 0, 0 },
 };
 
+int fw_addr_parser(const struct option *opt, const char *arg, int unset)
+{
+	struct kvm *kvm = opt->ptr;
+	char *next;
+
+	kvm->cfg.arch.fw_addr = parse_mem_option(arg, &next);
+
+	if (*next != '\0')
+		die("Invalid firmware address: %s", arg);
+
+	return 0;
+}
+
 bool kvm__arch_cpu_supports_vm(void)
 {
 	/* The KVM capability check is enough. */
diff --git a/builtin-run.c b/builtin-run.c
index 1eef1ffd0afc..710080f1831c 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -112,7 +112,7 @@ static int parse_mem_unit(char **next)
 	return shift;
 }
 
-static u64 parse_mem_option(const char *nptr, char **next)
+u64 parse_mem_option(const char *nptr, char **next)
 {
 	u64 shift;
 	u64 val;
diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
index eb23e2f77310..af3441156725 100644
--- a/include/kvm/kvm.h
+++ b/include/kvm/kvm.h
@@ -211,6 +211,7 @@ static inline bool kvm__arch_has_cfg_ram_address(void)
 
 void *guest_flat_to_host(struct kvm *kvm, u64 offset);
 u64 host_to_guest_flat(struct kvm *kvm, void *ptr);
+u64 parse_mem_option(const char *nptr, char **next);
 
 bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
 				 const char *kernel_cmdline);
-- 
2.36.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

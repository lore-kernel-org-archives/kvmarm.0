Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 881CAC433EF
	for <kvmarm@archiver.kernel.org>; Mon, 16 May 2022 15:55:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 316FB4B291;
	Mon, 16 May 2022 11:55:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LwCNhqq9ZaPw; Mon, 16 May 2022 11:55:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B4354B296;
	Mon, 16 May 2022 11:55:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F0A84B205
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 11:55:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nmJI4oDo2dNP for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 May 2022 11:55:30 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 18CFD4B29A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 11:55:30 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BD0E711FB;
 Mon, 16 May 2022 08:55:29 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 572CC3F73D;
 Mon, 16 May 2022 08:55:28 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org,
 suzuki.poulose@arm.com, julien@xen.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 james.morse@arm.com
Subject: [PATCH v2 kvmtool 04/12] builtin-run: Add arch hook to validate VM
 configuration
Date: Mon, 16 May 2022 16:55:18 +0100
Message-Id: <20220516155526.181694-5-alexandru.elisei@arm.com>
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

Architectures are free to set their own command line options. Add an
architecture specific hook to validate these options.

For now, the hook does nothing, but it will be used in later patches.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 Makefile          | 1 +
 arm/aarch32/kvm.c | 5 +++++
 arm/aarch64/kvm.c | 4 ++++
 builtin-run.c     | 2 ++
 include/kvm/kvm.h | 1 +
 mips/kvm.c        | 4 ++++
 powerpc/kvm.c     | 4 ++++
 riscv/kvm.c       | 4 ++++
 x86/kvm.c         | 4 ++++
 9 files changed, 29 insertions(+)
 create mode 100644 arm/aarch32/kvm.c

diff --git a/Makefile b/Makefile
index 9e67c7637b1e..25d79637b561 100644
--- a/Makefile
+++ b/Makefile
@@ -168,6 +168,7 @@ ifeq ($(ARCH), arm)
 	OBJS		+= $(OBJS_ARM_COMMON)
 	OBJS		+= arm/aarch32/arm-cpu.o
 	OBJS		+= arm/aarch32/kvm-cpu.o
+	OBJS		+= arm/aarch32/kvm.o
 	ARCH_INCLUDE	:= $(HDRS_ARM_COMMON)
 	ARCH_INCLUDE	+= -Iarm/aarch32/include
 	CFLAGS		+= -march=armv7-a
diff --git a/arm/aarch32/kvm.c b/arm/aarch32/kvm.c
new file mode 100644
index 000000000000..ae33ac92479a
--- /dev/null
+++ b/arm/aarch32/kvm.c
@@ -0,0 +1,5 @@
+#include "kvm/kvm.h"
+
+void kvm__arch_validate_cfg(struct kvm *kvm)
+{
+}
diff --git a/arm/aarch64/kvm.c b/arm/aarch64/kvm.c
index 1b992dd592d4..46f20e5a5a86 100644
--- a/arm/aarch64/kvm.c
+++ b/arm/aarch64/kvm.c
@@ -37,6 +37,10 @@ int vcpu_affinity_parser(const struct option *opt, const char *arg, int unset)
 	return 0;
 }
 
+void kvm__arch_validate_cfg(struct kvm *kvm)
+{
+}
+
 /*
  * Return the TEXT_OFFSET value that the guest kernel expects. Note
  * that pre-3.17 kernels expose this value using the native endianness
diff --git a/builtin-run.c b/builtin-run.c
index 4491fd244f8c..2c37b91b6574 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -531,6 +531,8 @@ static void kvm_run_validate_cfg(struct kvm *kvm)
 				(unsigned long long)available_ram >> MB_SHIFT);
 		}
 	}
+
+	kvm__arch_validate_cfg(kvm);
 }
 
 static struct kvm *kvm_cmd_run_init(int argc, const char **argv)
diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
index 7b14b33b50ca..9f7b2fb26e95 100644
--- a/include/kvm/kvm.h
+++ b/include/kvm/kvm.h
@@ -187,6 +187,7 @@ int kvm__get_sock_by_instance(const char *name);
 int kvm__enumerate_instances(int (*callback)(const char *name, int pid));
 void kvm__remove_socket(const char *name);
 
+void kvm__arch_validate_cfg(struct kvm *kvm);
 void kvm__arch_set_cmdline(char *cmdline, bool video);
 void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64 ram_size);
 void kvm__arch_delete_ram(struct kvm *kvm);
diff --git a/mips/kvm.c b/mips/kvm.c
index 3470dbb2e433..f5b137f46dff 100644
--- a/mips/kvm.c
+++ b/mips/kvm.c
@@ -12,6 +12,10 @@ struct kvm_ext kvm_req_ext[] = {
 	{ 0, 0 }
 };
 
+void kvm__arch_validate_cfg(struct kvm *kvm)
+{
+}
+
 void kvm__arch_read_term(struct kvm *kvm)
 {
 	virtio_console__inject_interrupt(kvm);
diff --git a/powerpc/kvm.c b/powerpc/kvm.c
index 702d67dca614..3215b579f5dc 100644
--- a/powerpc/kvm.c
+++ b/powerpc/kvm.c
@@ -48,6 +48,10 @@ struct kvm_ext kvm_req_ext[] = {
 	{ 0, 0 }
 };
 
+void kvm__arch_validate_cfg(struct kvm *kvm)
+{
+}
+
 static uint32_t mfpvr(void)
 {
 	uint32_t r;
diff --git a/riscv/kvm.c b/riscv/kvm.c
index 84e02779a91c..7fb496282f4c 100644
--- a/riscv/kvm.c
+++ b/riscv/kvm.c
@@ -13,6 +13,10 @@ struct kvm_ext kvm_req_ext[] = {
 	{ 0, 0 },
 };
 
+void kvm__arch_validate_cfg(struct kvm *kvm)
+{
+}
+
 bool kvm__arch_cpu_supports_vm(void)
 {
 	/* The KVM capability check is enough. */
diff --git a/x86/kvm.c b/x86/kvm.c
index 3e0f0b743f8c..6683a5c81d49 100644
--- a/x86/kvm.c
+++ b/x86/kvm.c
@@ -35,6 +35,10 @@ struct kvm_ext kvm_req_ext[] = {
 	{ 0, 0 }
 };
 
+void kvm__arch_validate_cfg(struct kvm *kvm)
+{
+}
+
 bool kvm__arch_cpu_supports_vm(void)
 {
 	struct cpuid_regs regs;
-- 
2.36.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

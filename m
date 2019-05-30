Return-Path: <SRS0=SFjg=T6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7967C28CC0
	for <kvmarm@archiver.kernel.org>; Thu, 30 May 2019 15:14:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8CB0A25C8C
	for <kvmarm@archiver.kernel.org>; Thu, 30 May 2019 15:14:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8CB0A25C8C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 44CB14A4AA;
	Thu, 30 May 2019 11:14:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ipU7soH-KXh7; Thu, 30 May 2019 11:14:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FAC24A50C;
	Thu, 30 May 2019 11:14:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 66C684A4C2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 May 2019 11:14:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Xeoxx7SVFQdR for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 May 2019 11:14:21 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F23024A4F7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 May 2019 11:14:20 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 74780341;
 Thu, 30 May 2019 08:14:20 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.72.51.249])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id CA8013F59C;
 Thu, 30 May 2019 08:14:18 -0700 (PDT)
From: Dave Martin <Dave.Martin@arm.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH kvmtool v3 9/9] arm64: Select SVE vector lengths via the
 command line
Date: Thu, 30 May 2019 16:13:14 +0100
Message-Id: <1559229194-3036-10-git-send-email-Dave.Martin@arm.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1559229194-3036-1-git-send-email-Dave.Martin@arm.com>
References: <1559229194-3036-1-git-send-email-Dave.Martin@arm.com>
Cc: Christoffer Dall <cdall@kernel.org>, Marc Zyngier <marc.zyngier@arm.com>,
 Andre Przywara <andre.przywara@arm.com>, Will Deacon <will.deacon@arm.com>,
 Kristina Martsenko <kristina.martsenko@arm.com>,
 Zhang Lei <zhang.lei@jp.fujitsu.com>,
 Amit Daniel Kachhap <amit.kachhap@arm.com>,
 linux-arm-kernel@lists.infradead.org
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

In order to support use cases such as migration, it may be
important in some situations to restrict the set of SVE vector
lengths available to the guest.  It can also be useful to observe
the behaviour of guest OSes with different vector lengths.

To enable testing and experimentation for such configurations, this
patch adds a command-line option to allow setting of the set of
vector lengths to be made available to the guest.

For now, the setting is global: no means is offered to configure
individual guest vcpus independently of each other.

By default all vector lengths that the host can support are given
to the guest, as before.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arm/aarch64/include/kvm/kvm-config-arch.h |  8 +++-
 arm/aarch64/kvm-cpu.c                     | 80 ++++++++++++++++++++++++++++++-
 arm/include/arm-common/kvm-config-arch.h  |  1 +
 3 files changed, 87 insertions(+), 2 deletions(-)

diff --git a/arm/aarch64/include/kvm/kvm-config-arch.h b/arm/aarch64/include/kvm/kvm-config-arch.h
index 41e9d05..a996612 100644
--- a/arm/aarch64/include/kvm/kvm-config-arch.h
+++ b/arm/aarch64/include/kvm/kvm-config-arch.h
@@ -1,6 +1,8 @@
 #ifndef KVM__KVM_CONFIG_ARCH_H
 #define KVM__KVM_CONFIG_ARCH_H
 
+int sve_vls_parser(const struct option *opt, const char *arg, int unset);
+
 #define ARM_OPT_ARCH_RUN(cfg)						\
 	OPT_BOOLEAN('\0', "aarch32", &(cfg)->aarch32_guest,		\
 			"Run AArch32 guest"),				\
@@ -16,7 +18,11 @@
 	OPT_BOOLEAN('\0', "enable-sve", &(cfg)->enable_sve,		\
 			"Enable SVE for the guest"),			\
 	OPT_BOOLEAN('\0', "disable-sve", &(cfg)->disable_sve,		\
-			"Disable SVE for the guest"),
+			"Disable SVE for the guest"),			\
+	OPT_CALLBACK('\0', "sve-vls", &(cfg)->sve_vqs,			\
+		     "comma-separated list of vector lengths, in 128-bit units", \
+		     "Set of vector lengths to enable for the guest",	\
+		     sve_vls_parser, NULL),
 
 #include "arm-common/kvm-config-arch.h"
 
diff --git a/arm/aarch64/kvm-cpu.c b/arm/aarch64/kvm-cpu.c
index cdfb22e..2c624c3 100644
--- a/arm/aarch64/kvm-cpu.c
+++ b/arm/aarch64/kvm-cpu.c
@@ -1,8 +1,13 @@
+#include <errno.h>
+#include <stdio.h>
+#include <string.h>
+
 #include "kvm/kvm-cpu.h"
 #include "kvm/kvm.h"
 #include "kvm/virtio.h"
 
 #include <asm/ptrace.h>
+#include <asm/sigcontext.h>
 
 #define COMPAT_PSR_F_BIT	0x00000040
 #define COMPAT_PSR_I_BIT	0x00000080
@@ -12,6 +17,65 @@
 #define SCTLR_EL1_E0E_MASK	(1 << 24)
 #define SCTLR_EL1_EE_MASK	(1 << 25)
 
+/*
+ * Work around old kernel headers that lack these definitions in
+ * <asm/sigcontext.h>:
+ */
+#ifndef SVE_VQ_MIN
+#define SVE_VQ_MIN 1
+#endif
+
+#ifndef SVE_VQ_MAX
+#define SVE_VQ_MAX 512
+#endif
+
+int sve_vls_parser(const struct option *opt, const char *arg, int unset)
+{
+	size_t offset = 0;
+	int vq, n, t;
+	u64 (*vqs)[(SVE_VQ_MAX + 1 - SVE_VQ_MIN + 63) / 64];
+	u64 **cfg_vqs = opt->value;
+
+	if (*cfg_vqs) {
+		pr_err("sve-vls: SVE vector lengths set may only be specified once");
+		return -1;
+	}
+
+	vqs = calloc(1, sizeof *vqs);
+	if (!vqs)
+		die("%s", strerror(ENOMEM));
+
+	offset = 0;
+	while (arg[offset]) {
+		n = -1;
+
+		t = sscanf(arg + offset,
+			   offset == 0 ? "%i%n" : ",%i%n",
+			   &vq, &n);
+		if (t == EOF || t < 1 || n <= 0) {
+			pr_err("sve-vls: Comma-separated list of vector lengths required");
+			goto error;
+		}
+
+		if (vq < SVE_VQ_MIN || vq > SVE_VQ_MAX) {
+			pr_err("sve-vls: Invalid vector length %d", vq);
+			goto error;
+		}
+
+		vq -= SVE_VQ_MIN;
+		(*vqs)[vq / 64] |= (u64)1 << (vq % 64);
+
+		offset += n;
+	}
+
+	*cfg_vqs = *vqs;
+	return 0;
+
+error:
+	free(vqs);
+	return -1;
+}
+
 static __u64 __core_reg_id(__u64 offset)
 {
 	__u64 id = KVM_REG_ARM64 | KVM_REG_ARM_CORE | offset;
@@ -180,6 +244,16 @@ void kvm_cpu__select_features(struct kvm *kvm, struct kvm_vcpu_init *init)
 static int configure_sve(struct kvm_cpu *vcpu)
 {
 	int feature = KVM_ARM_VCPU_SVE;
+	struct kvm_one_reg r = {
+		.id = KVM_REG_ARM64_SVE_VLS,
+		.addr = (u64)vcpu->kvm->cfg.arch.sve_vqs,
+	};
+
+	if (vcpu->kvm->cfg.arch.sve_vqs)
+		if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &r)) {
+			pr_err("Cannot set requested SVE vector lengths");
+			return -1;
+		}
 
 	if (ioctl(vcpu->vcpu_fd, KVM_ARM_VCPU_FINALIZE, &feature)) {
 		pr_err("KVM_ARM_VCPU_FINALIZE: %s", strerror(errno));
@@ -191,9 +265,13 @@ static int configure_sve(struct kvm_cpu *vcpu)
 
 int kvm_cpu__configure_features(struct kvm_cpu *vcpu)
 {
-	if (vcpu->kvm->cfg.arch.enable_sve)
+	if (vcpu->kvm->cfg.arch.enable_sve) {
 		if (configure_sve(vcpu))
 			return -1;
+	} else {
+		if (vcpu->kvm->cfg.arch.sve_vqs)
+			pr_warning("SVE vector lengths ignored");
+	}
 
 	return 0;
 }
diff --git a/arm/include/arm-common/kvm-config-arch.h b/arm/include/arm-common/kvm-config-arch.h
index 40e3d1f..b45201f 100644
--- a/arm/include/arm-common/kvm-config-arch.h
+++ b/arm/include/arm-common/kvm-config-arch.h
@@ -12,6 +12,7 @@ struct kvm_config_arch {
 	u64		kaslr_seed;
 	bool		enable_sve;
 	bool		disable_sve;
+	u64		*sve_vqs;
 	bool		enable_ptrauth;
 	bool		disable_ptrauth;
 	enum irqchip_type irqchip;
-- 
2.1.4

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

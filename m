From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH kvmtool v2 3/3] arm64: Add command-line option to set the
 guest's SVE vector lengths
Date: Wed, 20 Mar 2019 12:07:28 +0000
Message-ID: <1553083648-5345-4-git-send-email-Dave.Martin@arm.com>
References: <1553083648-5345-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DAAA14A3B3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Mar 2019 08:08:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QnIVZTC1Av-V for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Mar 2019 08:08:23 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 885DA49F94
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Mar 2019 08:08:23 -0400 (EDT)
In-Reply-To: <1553083648-5345-1-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <Julien.Grall@arm.com>, Andre Przywara <andre.przywara@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

In order to support use cases such as migration, it may be
important in some situations to restrict the set of SVE vector
lengths available to the guest.  It can also be usefule to observe
the behaviour of guest OSes with different vector lengths.

To enable testing and experimentation for such configurations, this
patch adds a command-line option to allow setting of the set of
vector lengths to be made available to the guest.

For now, the setting is global: no means is offered to configure
individual guest vcpus independently of each other.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---

It wasn't clear to me what the most user-friendly form for the
 --sve-vls parameter would be.  Possibilities include:

	--sve-max-vl=<n>	# all host vector lengths not exceeding <n>
	--sve-vls=16,32,64	# i.e., byte ("vl") units, not 128-bit
	--sve-vls=1-2,4		# i.e., similar syntax to taskset -c etc.
	--sve-vls=16-32,64	# combination of the above
	--sve-vqs=1,2,4		# for more consistent terminology

In the end, to avoid premature overengineering, I went with the
easiest choice.  (--sve-vls=1,2,4)

There's also the question of how to specify different features and
configurations per-vcpu.  I don't currently attempt this, but it would
be useful for KVM testing and development.  I think that any solution
to this shouldn't be SVE-specific: we should aim for a common approach
that can be reused for other features too.

---
 arm/aarch64/include/kvm/kvm-config-arch.h |  8 +++-
 arm/aarch64/kvm-cpu.c                     | 80 ++++++++++++++++++++++++++++++-
 arm/include/arm-common/kvm-config-arch.h  |  1 +
 3 files changed, 87 insertions(+), 2 deletions(-)

diff --git a/arm/aarch64/include/kvm/kvm-config-arch.h b/arm/aarch64/include/kvm/kvm-config-arch.h
index 50b7aae..1eb8cfc 100644
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
@@ -10,7 +12,11 @@
 			"Specify random seed for Kernel Address Space "	\
 			"Layout Randomization (KASLR)"),		\
 	OPT_BOOLEAN('\0', "sve", &(cfg)->has_sve,			\
-			"Enable SVE for the guest"),
+			"Enable SVE for the guest"),			\
+	OPT_CALLBACK('\0', "sve-vls", &(cfg)->sve_vqs,			\
+		     "comma-separated list of vector lengths, in 128-bit units", \
+		     "Set of vector lengths to enable for the guest",	\
+		     sve_vls_parser, NULL),
 
 #include "arm-common/kvm-config-arch.h"
 
diff --git a/arm/aarch64/kvm-cpu.c b/arm/aarch64/kvm-cpu.c
index 43eb69e..d917c8b 100644
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
+		die("%s", strerror(errno));
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
@@ -131,6 +195,16 @@ static void reset_vcpu_aarch64(struct kvm_cpu *vcpu)
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
 
 	if (ioctl(vcpu->vcpu_fd, KVM_ARM_VCPU_FINALIZE, &feature))
 		return -1;
@@ -140,9 +214,13 @@ static int configure_sve(struct kvm_cpu *vcpu)
 
 int kvm_cpu__configure_features(struct kvm_cpu *vcpu)
 {
-	if (vcpu->kvm->cfg.arch.has_sve)
+	if (vcpu->kvm->cfg.arch.has_sve) {
 		if (configure_sve(vcpu))
 			return -1;
+	} else { /* !vcpu->kvm->cfg.arch.has_sve */
+		if (vcpu->kvm->cfg.arch.sve_vqs)
+			pr_warning("SVE vector lengths ignored");
+	}
 
 	return 0;
 }
diff --git a/arm/include/arm-common/kvm-config-arch.h b/arm/include/arm-common/kvm-config-arch.h
index bdab680..ca11e55 100644
--- a/arm/include/arm-common/kvm-config-arch.h
+++ b/arm/include/arm-common/kvm-config-arch.h
@@ -13,6 +13,7 @@ struct kvm_config_arch {
 	enum irqchip_type irqchip;
 	u64		fw_addr;
 	bool		has_sve;
+	u64		*sve_vqs;
 };
 
 int irqchip_parser(const struct option *opt, const char *arg, int unset);
-- 
2.1.4

From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH 10/12] arm64: [HACK] Allow configuration of the guest's
 set of SVE vector lengths
Date: Fri, 18 Jan 2019 16:14:19 +0000
Message-ID: <1547828061-20462-11-git-send-email-Dave.Martin@arm.com>
References: <1547828061-20462-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 973824A3C9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jan 2019 11:15:39 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sCVVSUyGF+E3 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Jan 2019 11:15:38 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E1684A3BC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jan 2019 11:15:37 -0500 (EST)
In-Reply-To: <1547828061-20462-1-git-send-email-Dave.Martin@arm.com>
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
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andre Przywara <andre.przywara@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

By default, for each vcpu KVM enabled the same set of SVE vector
as supported by the host.

In order to allow a different set of vector lengths permitted (to
the extent supported by the SVE architecture), an option --sve-vqs
is added, which accepts a comma-separated list of vector lengths to
enable.

This options follows the "vq" convention, describing the vector
length as a multiple of 128-bit quadwords.  This is largely for
developer convenience and may be confusing for users.

Although KVM supports a different set of vector lengths to be
enabled on each vcpu, this patch provides no means to request such
a configuration for now.  Support could be added later, if desired.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arm/aarch64/include/kvm/kvm-config-arch.h |  5 ++
 arm/kvm-cpu.c                             | 80 +++++++++++++++++++++++++++++++
 2 files changed, 85 insertions(+)

diff --git a/arm/aarch64/include/kvm/kvm-config-arch.h b/arm/aarch64/include/kvm/kvm-config-arch.h
index 7710f14..f0a7934 100644
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
@@ -10,6 +12,9 @@
 		    "Enable SVE for the guest"),			\
 	OPT_BOOLEAN('\0', "show-reg-list", &(cfg)->show_reg_list,	\
 		    "Show the list of KVM register IDs on startup"),	\
+	OPT_CALLBACK('\0', "sve-vqs", NULL, "comma-separated list",	\
+		     "Override the SVE vector lengths supported",	\
+		     sve_vls_parser, NULL),				\
 	OPT_U64('\0', "kaslr-seed", &(cfg)->kaslr_seed,			\
 			"Specify random seed for Kernel Address Space "	\
 			"Layout Randomization (KASLR)"),
diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
index 80e7b79..d3dfe2d 100644
--- a/arm/kvm-cpu.c
+++ b/arm/kvm-cpu.c
@@ -6,6 +6,72 @@
 #include "kvm/kvm.h"
 #include "kvm/kvm-cpu.h"
 
+static int vqs_set;
+static u64 sve_vq_map[8];
+
+static int add_vq(int vq)
+{
+	if (vq < 1 || vq > 512) {
+		fprintf(stderr, "%d: VQ out of range\n", vq);
+		return -1;
+	}
+
+	--vq;
+	sve_vq_map[vq / 64] |= (u64)1 << vq;
+	return 0;
+}
+
+int sve_vls_parser(const struct option *opt, const char *arg, int unset)
+{
+	int n = -1, val;
+	size_t offset = 0;
+
+	if (sscanf(arg + offset, "%i%n", &val, &n) < 1 || n < 0)
+		goto mismatch;
+
+	if (add_vq(val))
+		return -1;
+
+	offset += n;
+	while (1) {
+		n = -1;
+		if (sscanf(arg + offset, ",%i%n", &val, &n) < 1 && n < 0)
+			break;
+
+		if (add_vq(val))
+			return -1;
+
+		offset += n;
+	}
+
+mismatch:
+	if (arg[offset]) {
+		fprintf(stderr, "Bad set of vector lengths: %s\n", arg);
+		return -1;
+	}
+
+	vqs_set = -1;
+
+	return 0;
+}
+
+static int try_to_set_vqs(struct kvm_cpu const *vcpu)
+{
+	struct kvm_one_reg reg;
+
+	if (!vqs_set)
+		return 0; /* nothing to do */
+
+	reg.addr = (u64)&sve_vq_map;
+	reg.id = KVM_REG_ARM64_SVE_VLS;
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg)) {
+		perror("KVM_SET_ONE_REG(KVM_REG_ARM64_SVE_VLS)");
+		return -1;
+	}
+
+	return 0;
+}
+
 static int kvm_show_reg_list(struct kvm_cpu const *vcpu)
 {
 	int ret = -1;
@@ -263,9 +329,23 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 	if (err || target->init(vcpu))
 		die("Unable to initialise vcpu");
 
+	if (kvm->cfg.arch.show_reg_list)
+		kvm_show_sve_info(vcpu);
+
+	if (try_to_set_vqs(vcpu))
+		die("SVE vector length configuration failed");
+
 	if (kvm->cfg.arch.show_reg_list) {
+		puts("After setting SVE vector lengths:");
 		kvm_show_sve_info(vcpu);
+
 		kvm_show_reg_list(vcpu);
+
+		if (!try_to_set_vqs(vcpu)) {
+			if (vqs_set)
+				die("SVE vector length configuration after KVM_GET_REG_LIST succeeded unexpectedly");
+		} else
+			puts("(as expected)");
 	}
 
 	coalesced_offset = ioctl(kvm->sys_fd, KVM_CHECK_EXTENSION,
-- 
2.1.4

From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH 09/12] arm64: [HACK] Show extra info about SVE with
 --show-reg-list
Date: Fri, 18 Jan 2019 16:14:18 +0000
Message-ID: <1547828061-20462-10-git-send-email-Dave.Martin@arm.com>
References: <1547828061-20462-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 483CB4A391
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jan 2019 11:15:41 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Lt2I+j7l-Q82 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Jan 2019 11:15:37 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 239924A3EA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jan 2019 11:15:35 -0500 (EST)
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

This patch prints out some information about the SVE configuration
when --show-reg=list is passed.

This is development hack only (as well as being an abuse of the
purpose of that option).

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arm/kvm-cpu.c | 111 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 110 insertions(+), 1 deletion(-)

diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
index 38a071b..80e7b79 100644
--- a/arm/kvm-cpu.c
+++ b/arm/kvm-cpu.c
@@ -1,3 +1,4 @@
+#include <assert.h>
 #include <errno.h>
 #include <stddef.h>
 #include <stdio.h>
@@ -48,6 +49,112 @@ error:
 	return ret;
 }
 
+static int kvm_show_sve_info(struct kvm_cpu const *vcpu)
+{
+	int ret = 0;
+	u64 val;
+	struct kvm_one_reg r;
+	int have_sve;
+	u64 vls[9];
+	unsigned int i;
+
+	r.addr = (u64)&val;
+
+	r.id = ARM64_SYS_REG(3, 0, 0, 4, 0); /* ID_AA64PFR0_EL1 */
+	assert((r.id & KVM_REG_SIZE_MASK) == KVM_REG_SIZE_U64);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &r)) {
+		perror("KVM_GET_ONE_REG(ID_AA64PFR0_EL1)");
+		goto error;
+	}
+
+	printf("ID_AA64PFR0_EL1:\t0x%lx\n", (unsigned long)val);
+
+	have_sve = !!((val >> 32) & 0xf);
+
+	r.id = ARM64_SYS_REG(3, 0, 0, 4, 4);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &r)) {
+		if (errno != ENOENT || have_sve) {
+			perror("KVM_GET_ONE_REG(ID_AA64ZFR0_EL1)");
+			ret = -1;
+		}
+	} else {
+		if (!have_sve) {
+			puts("ID_AA64ZFR0_EL1 unexpectedly present");
+			ret = -1;
+		}
+
+		printf("ID_AA64ZFR0_EL1:\t0x%lx\n", (unsigned long)val);
+	}
+
+	r.id = ARM64_SYS_REG(3, 0, 1, 2, 0);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &r)) {
+		if (errno != ENOENT || have_sve) {
+			perror("KVM_GET_ONE_REG(ZCR_EL1)");
+			ret = -1;
+		}
+	} else {
+		if (!have_sve) {
+			puts("ZCR_EL1 unexpectedly present");
+			ret = -1;
+		}
+
+		printf("ZCR_EL1:\t0x%lx\n", (unsigned long)val);
+	}
+
+	r.addr = (u64)&vls;
+	r.id = KVM_REG_ARM64_SVE_VLS;
+	assert(8 * (sizeof(vls) - sizeof(*vls)) == 512 &&
+	       (r.id & KVM_REG_SIZE_MASK) == KVM_REG_SIZE_U512);
+
+	/*
+	 * Write some canary data so we can see that the kernel writes
+	 * the expected amount:
+	 */
+	for (i = 0; i < sizeof(vls) / sizeof(*vls); ++i)
+		vls[i] = -7;
+
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &r)) {
+		if (errno != ENOENT || have_sve) {
+			perror("KVM_GET_ONE_REG(KVM_REG_ARM64_SVE_VLS)");
+			ret = -1;
+		}
+	} else {
+		char const *prefix = "";
+
+		if (!have_sve) {
+			puts("KVM_REG_ARM64_SVE_VLS unexpectedly present");
+			ret = -1;
+		}
+
+		if (vls[7] == (u64)-7) {
+			puts("KVM_REG_ARM64_SVE_VLS short read?");
+			ret = -1;
+		}
+
+		if (vls[8] != (u64)-7) {
+			puts("KVM_REG_ARM64_SVE_VLS overrun?");
+			ret = -1;
+		}
+
+		fputs("SVE VQs: ", stdout);
+
+		for (i = 0; i < 512; ++i)
+			if ((vls[i / 64] >> (i % 64)) & 1) {
+				printf("%s%lu", prefix, (unsigned long)i + 1);
+				prefix = ",";
+			}
+
+		putchar('\n');
+	}
+
+	fflush(stdout);
+
+	return ret;
+
+error:
+	return -1;
+}
+
 static int debug_fd;
 
 void kvm_cpu__set_debug_fd(int fd)
@@ -156,8 +263,10 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 	if (err || target->init(vcpu))
 		die("Unable to initialise vcpu");
 
-	if (kvm->cfg.arch.show_reg_list)
+	if (kvm->cfg.arch.show_reg_list) {
+		kvm_show_sve_info(vcpu);
 		kvm_show_reg_list(vcpu);
+	}
 
 	coalesced_offset = ioctl(kvm->sys_fd, KVM_CHECK_EXTENSION,
 				 KVM_CAP_COALESCED_MMIO);
-- 
2.1.4

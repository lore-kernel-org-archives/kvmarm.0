Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9227C1B3723
	for <kvmarm@lists.linux.dev>; Thu, 20 Jun 2024 16:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718902754; cv=none; b=sYQIuUweblkREev+WpaN01aXjwLHlkZ2JaNIYIBPjpQHO8m7hnpm5xlK1ig5vxNv4BzY5IIyw5d9mixZvae+kxhrtTR8yxjTUfCxA/3nWz4eREy1lYNsVvViD5+CMDfqYtJcT7/+plYNXYlQgvUrInT6AEyoUNooqHBghN+tQgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718902754; c=relaxed/simple;
	bh=9ihLzQ88GtvNOexb/fP1B2IZi3zffR9a5V+ezYsNm3U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=m1RJLIbzKGbJwHxBx5vbWlbIOC2lzaDw7goLMj0t93ylMgGP5gWk2ueC4DjhEZfbbudr3cjwGXIhRV2Thngrma8QpJlzcdo2b7mpRcFWDTIbDRmtUrW0fJWnDedtrNMd8P2YcWoZAhAmc/xZOiHM1zubZBJ0JBmp5ZLE40wmsxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rPHlLmJB; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rPHlLmJB"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718902750;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=c5d0W1pusnuf6Ixn+Dj1BS1msyFMZSKZn9rIr5tZMFk=;
	b=rPHlLmJBf8hGA/QTiBl2NXaJ4MtyJ7H4e5bYWKynKsSU8fuxly/IpzJ+B6MxEih4RtEFim
	B82hNB3w5ey/CJnKTWvMm7Q1+q0bxpWAQRCJK8m+x5mvzHPX0g/RCT4b3id0N3EGuytpM+
	x24cAYoOTlBgq9iKlhrKKBA9n4MECBA=
X-Envelope-To: maz@kernel.org
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: tabba@google.com
X-Envelope-To: will@kernel.org
X-Envelope-To: julien.thierry.kdev@gmail.com
X-Envelope-To: oliver.upton@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	kvm@vger.kernel.org,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH kvmtool] arm64: Allow the user to select the max SVE vector length
Date: Thu, 20 Jun 2024 16:57:03 +0000
Message-ID: <20240620165702.1134918-2-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add a new flag, --sve-max-vl, which allows the user to specify an SVE
vector length for the VM. Just zero out unsupported VLs from what KVM
supports rather than cooking up the bitmap from scratch.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arm/aarch64/include/kvm/kvm-config-arch.h |  6 ++-
 arm/aarch64/kvm-cpu.c                     | 65 ++++++++++++++++++++---
 arm/include/arm-common/kvm-config-arch.h  |  3 +-
 3 files changed, 65 insertions(+), 9 deletions(-)

diff --git a/arm/aarch64/include/kvm/kvm-config-arch.h b/arm/aarch64/include/kvm/kvm-config-arch.h
index eae8080d3fd9..642fe672d833 100644
--- a/arm/aarch64/include/kvm/kvm-config-arch.h
+++ b/arm/aarch64/include/kvm/kvm-config-arch.h
@@ -2,6 +2,7 @@
 #define KVM__KVM_CONFIG_ARCH_H
 
 int vcpu_affinity_parser(const struct option *opt, const char *arg, int unset);
+int sve_vl_parser(const struct option *opt, const char *arg, int unset);
 
 #define ARM_OPT_ARCH_RUN(cfg)						\
 	OPT_BOOLEAN('\0', "aarch32", &(cfg)->aarch32_guest,		\
@@ -19,7 +20,10 @@ int vcpu_affinity_parser(const struct option *opt, const char *arg, int unset);
 			"Specify random seed for Kernel Address Space "	\
 			"Layout Randomization (KASLR)"),		\
 	OPT_BOOLEAN('\0', "no-pvtime", &(cfg)->no_pvtime, "Disable"	\
-			" stolen time"),
+			" stolen time"),				\
+	OPT_CALLBACK('\0', "sve-max-vl", NULL, "vector length",		\
+		     "Specify the max SVE vector length (in bits) for "	\
+		     "all vCPUs", sve_vl_parser, kvm),
 #include "arm-common/kvm-config-arch.h"
 
 #endif /* KVM__KVM_CONFIG_ARCH_H */
diff --git a/arm/aarch64/kvm-cpu.c b/arm/aarch64/kvm-cpu.c
index c8be10b3ca94..7b6061af00e6 100644
--- a/arm/aarch64/kvm-cpu.c
+++ b/arm/aarch64/kvm-cpu.c
@@ -3,6 +3,7 @@
 #include "kvm/virtio.h"
 
 #include <asm/ptrace.h>
+#include <linux/bitops.h>
 
 #define COMPAT_PSR_F_BIT	0x00000040
 #define COMPAT_PSR_I_BIT	0x00000080
@@ -154,17 +155,67 @@ void kvm_cpu__select_features(struct kvm *kvm, struct kvm_vcpu_init *init)
 		init->features[0] |= 1UL << KVM_ARM_VCPU_SVE;
 }
 
-int kvm_cpu__configure_features(struct kvm_cpu *vcpu)
+int sve_vl_parser(const struct option *opt, const char *arg, int unset)
 {
-	if (kvm__supports_extension(vcpu->kvm, KVM_CAP_ARM_SVE)) {
-		int feature = KVM_ARM_VCPU_SVE;
+	struct kvm *kvm = opt->ptr;
+	unsigned long val;
+	unsigned int vq;
+
+	errno = 0;
+	val = strtoull(arg, NULL, 10);
+	if (errno == ERANGE)
+		die("SVE vector length too large: %s", arg);
+
+	if (!val || (val & (val - 1)))
+		die("SVE vector length isn't power of 2: %s", arg);
+
+	vq = val / 128;
+	if (vq > KVM_ARM64_SVE_VQ_MAX || vq < KVM_ARM64_SVE_VQ_MIN)
+		die("SVE vector length out of range: %s", arg);
+
+	kvm->cfg.arch.sve_max_vq = vq;
+	return 0;
+}
+
+static int vcpu_configure_sve(struct kvm_cpu *vcpu)
+{
+	unsigned int max_vq = vcpu->kvm->cfg.arch.sve_max_vq;
+	int feature = KVM_ARM_VCPU_SVE;
+
+	if (max_vq) {
+		unsigned long vls[KVM_ARM64_SVE_VLS_WORDS];
+		struct kvm_one_reg reg = {
+			.id	= KVM_REG_ARM64_SVE_VLS,
+			.addr	= (u64)&vls,
+		};
+		unsigned int vq;
+
+		if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg))
+			die_perror("KVM_GET_ONE_REG failed (KVM_ARM64_SVE_VLS)");
 
-		if (ioctl(vcpu->vcpu_fd, KVM_ARM_VCPU_FINALIZE, &feature)) {
-			pr_err("KVM_ARM_VCPU_FINALIZE: %s", strerror(errno));
-			return -1;
-		}
+		if (!test_bit(max_vq - KVM_ARM64_SVE_VQ_MIN, vls))
+			die("SVE vector length (%u) not supported", max_vq * 128);
+
+		for (vq = KVM_ARM64_SVE_VQ_MAX; vq > max_vq; vq--)
+			clear_bit(vq - KVM_ARM64_SVE_VQ_MIN, vls);
+
+		if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg))
+			die_perror("KVM_SET_ONE_REG failed (KVM_ARM64_SVE_VLS)");
 	}
 
+	if (ioctl(vcpu->vcpu_fd, KVM_ARM_VCPU_FINALIZE, &feature)) {
+		pr_err("KVM_ARM_VCPU_FINALIZE: %s", strerror(errno));
+		return -1;
+	}
+
+	return 0;
+}
+
+int kvm_cpu__configure_features(struct kvm_cpu *vcpu)
+{
+	if (kvm__supports_extension(vcpu->kvm, KVM_CAP_ARM_SVE))
+		return vcpu_configure_sve(vcpu);
+
 	return 0;
 }
 
diff --git a/arm/include/arm-common/kvm-config-arch.h b/arm/include/arm-common/kvm-config-arch.h
index 23a74867a474..4722d8f8acf7 100644
--- a/arm/include/arm-common/kvm-config-arch.h
+++ b/arm/include/arm-common/kvm-config-arch.h
@@ -13,7 +13,8 @@ struct kvm_config_arch {
 	u64		kaslr_seed;
 	enum irqchip_type irqchip;
 	u64		fw_addr;
-	bool no_pvtime;
+	unsigned int	sve_max_vq;
+	bool		no_pvtime;
 };
 
 int irqchip_parser(const struct option *opt, const char *arg, int unset);

base-commit: da4cfc3e540341b84c4bbad705b5a15865bc1f80
-- 
2.45.2.741.gdbec12cfda-goog


Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02377283151
	for <kvmarm@lists.linux.dev>; Fri, 14 Nov 2025 16:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763136481; cv=none; b=TCMbBszp7r6INwnEyx2juayWwu5sisDBsmdo4Efb0xHEoRS9C7SYCHNrULLzXI+mvQcSmPKReqL7fjiqlCFDC7i/OUwc/W5lWhia5tfQefyBegpY7xAeW+dE6vVt3cR9R5z5IXbY3YYwmizgamsjBC1b7TSX+8LF+l2MZb/f24U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763136481; c=relaxed/simple;
	bh=UTM4N9FjSClcVgR/6oeSO4XnZPoY6lByp8Fyb6blvGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mMPurufODGlkGUGO2ysPi167FvTVtPANqr+bkMn+ZZ/n6ieH3VwAEDJn/TZ5N7tqWrsNvGju76GZthp4zXAcqBPurmI4U7lJtUuoGRqE0cwi4jFW8ERW9Wv9JTUAmoRdYR1ZRyHvbAoN2BqgjNuRC5L7M/K4khrlT6tx8Zu0CjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E72DB1BC0;
	Fri, 14 Nov 2025 08:07:51 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4272A3F73B;
	Fri, 14 Nov 2025 08:07:57 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	will@kernel.org,
	catalin.marinas@arm.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: james.clark@linaro.org,
	mark.rutland@arm.com,
	james.morse@arm.com,
	Sudeep Holla <sudeep.holla@arm.com>
Subject: [RFC PATCH v6 10/35] KVM: arm64: Add a new VCPU device control group for SPE
Date: Fri, 14 Nov 2025 16:06:51 +0000
Message-ID: <20251114160717.163230-11-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251114160717.163230-1-alexandru.elisei@arm.com>
References: <20251114160717.163230-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sudeep Holla <sudeep.holla@arm.com>

Add a new VCPU device control group to control various aspects of KVM's SPE
emulation. Functionality will be added in later patches.

[ Alexandru E: Major rework ]

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 Documentation/virt/kvm/devices/vcpu.rst |  5 +++++
 arch/arm64/include/asm/kvm_spe.h        | 17 +++++++++++++++++
 arch/arm64/include/uapi/asm/kvm.h       |  1 +
 arch/arm64/kvm/guest.c                  | 10 ++++++++++
 arch/arm64/kvm/spe.c                    | 15 +++++++++++++++
 5 files changed, 48 insertions(+)

diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
index 60bf205cb373..8c5208ccd107 100644
--- a/Documentation/virt/kvm/devices/vcpu.rst
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -291,3 +291,8 @@ From the destination VMM process:
 
 7. Write the KVM_VCPU_TSC_OFFSET attribute for every vCPU with the
    respective value derived in the previous step.
+
+5. GROUP: KVM_ARM_VCPU_SPE_CTRL
+===============================
+
+:Architectures: ARM64
diff --git a/arch/arm64/include/asm/kvm_spe.h b/arch/arm64/include/asm/kvm_spe.h
index 8e8a5c6f7971..7c8268f6f507 100644
--- a/arch/arm64/include/asm/kvm_spe.h
+++ b/arch/arm64/include/asm/kvm_spe.h
@@ -16,9 +16,26 @@ static __always_inline bool kvm_supports_spe(void)
 
 #define vcpu_has_spe(vcpu)					\
 	(vcpu_has_feature(vcpu, KVM_ARM_VCPU_SPE))
+
+int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
+int kvm_spe_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
+int kvm_spe_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 #else
 #define kvm_supports_spe()	false
 #define vcpu_has_spe(vcpu)	false
+
+static inline int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
+{
+	return -ENXIO;
+}
+static inline int kvm_spe_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
+{
+	return -ENXIO;
+}
+static inline int kvm_spe_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
+{
+	return -ENXIO;
+}
 #endif /* CONFIG_KVM_ARM_SPE */
 
 #endif /* __ARM64_KVM_SPE_H__ */
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 5bdfe1f6d565..5e2d47572136 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -444,6 +444,7 @@ enum {
 #define   KVM_ARM_VCPU_TIMER_IRQ_HPTIMER	3
 #define KVM_ARM_VCPU_PVTIME_CTRL	2
 #define   KVM_ARM_VCPU_PVTIME_IPA	0
+#define KVM_ARM_VCPU_SPE_CTRL		3
 
 /* KVM_IRQ_LINE irq field index values */
 #define KVM_ARM_IRQ_VCPU2_SHIFT		28
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 1c87699fd886..d1bf8b154a31 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -25,6 +25,7 @@
 #include <asm/kvm.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_nested.h>
+#include <asm/kvm_spe.h>
 #include <asm/sigcontext.h>
 
 #include "trace.h"
@@ -918,6 +919,9 @@ int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
 	case KVM_ARM_VCPU_PVTIME_CTRL:
 		ret = kvm_arm_pvtime_set_attr(vcpu, attr);
 		break;
+	case KVM_ARM_VCPU_SPE_CTRL:
+		ret = kvm_spe_set_attr(vcpu, attr);
+		break;
 	default:
 		ret = -ENXIO;
 		break;
@@ -941,6 +945,9 @@ int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
 	case KVM_ARM_VCPU_PVTIME_CTRL:
 		ret = kvm_arm_pvtime_get_attr(vcpu, attr);
 		break;
+	case KVM_ARM_VCPU_SPE_CTRL:
+		ret = kvm_spe_get_attr(vcpu, attr);
+		break;
 	default:
 		ret = -ENXIO;
 		break;
@@ -964,6 +971,9 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
 	case KVM_ARM_VCPU_PVTIME_CTRL:
 		ret = kvm_arm_pvtime_has_attr(vcpu, attr);
 		break;
+	case KVM_ARM_VCPU_SPE_CTRL:
+		ret = kvm_spe_has_attr(vcpu, attr);
+		break;
 	default:
 		ret = -ENXIO;
 		break;
diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
index 101258b55053..4d635e881620 100644
--- a/arch/arm64/kvm/spe.c
+++ b/arch/arm64/kvm/spe.c
@@ -40,3 +40,18 @@ void kvm_host_spe_init(struct arm_spe_pmu *arm_spu)
 	if (list_is_singular(&arm_spus))
 		static_branch_enable(&kvm_spe_available);
 }
+
+int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
+{
+	return -ENXIO;
+}
+
+int kvm_spe_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
+{
+	return -ENXIO;
+}
+
+int kvm_spe_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
+{
+	return -ENXIO;
+}
-- 
2.51.2


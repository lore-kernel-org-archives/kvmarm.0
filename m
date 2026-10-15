Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 306B9498933
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 20:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792094965; cv=none; b=El8M7AqY89wpqo0dmTFuE5y/fs0VVAmw1mL9rr+4hFbwDIbitHsV9w/fah3aIOeYFlzhkdsLT2Qc5NFh/sjcTFpLuiG6FzT06TaO5uTgy3gmsmSXt2OxdUAEILiJCR8HqPehv3G4PKyuSdjd8wSNT90X5BIBhRg6ORcIB3R29lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792094965; c=relaxed/simple;
	bh=OEBJ9jBwoh3u5ibQYjsm3jERzX/nBiVFHAkhW2sQFQs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EEC25AMFs0AeTueGmy6/gLBH7Lh1jXiQwS7Jn7uOUWL/OOsWk2DaQd7sE/epsJbvyj5dUr4tEO0Mvq/Thm+ZFaMpa5tjdz+uu4WJf/bBhicMapcq7FdVHkzGoKOMuFllKamKm9XmjyEUwa4YSv+tY+D0XnmJfu8TqXXRuH3USRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MyLzitmE; arc=none smtp.client-ip=209.85.208.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MyLzitmE"
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-6b1ef6bffb2so2771140a12.3
        for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 13:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792094958; x=1792699758; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SPgM8pFySMpBzoU0tQSRtWXbtV3WXjZpxKdn14a2X+Q=;
        b=MyLzitmEGO9tM7dTyIyyr/kjN3Yp3ofmVMj6diKUWlkIvOpZ3DkWM+AGZoZK4Cb+WK
         br3clUEOpG7l+D5nf9Y64S24qvP0WglfQvHrc7zoV6+EpZwAdISHStGg9K61lXzfGlWG
         g8+bLF13/rSm0D7SaBd+rulPDevR16Jwgxd7CnvP1bqzsa8SIKr6rmCtuiuxQ7epsCo4
         oN0uN23xCWjFbfgB2NaWyNPb27o74YRhy6zdjZOtctNYVcpWgpIuxYW4Mxe0XSNIHfrK
         ckwbjNSFzM9kf8Xl5YEGk97d9VhrpJWZENd1Rum1r0brTMkV+lz6n20w+3YDZy9WhZOH
         P0DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792094958; x=1792699758;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SPgM8pFySMpBzoU0tQSRtWXbtV3WXjZpxKdn14a2X+Q=;
        b=dgbtrSKWkthq1sq31Yji1NQ1uqt6e+TrQ7QEKk2HCcqTl7tMv3pdITfrXNTAONdalj
         NKj05KNQo5/8UHq7rg+L3jrFT05vShNTBVSxZ6wbL88Bjm5xlmiW30WcFA9Ic+fy5LB9
         QW3JiFidbUrZp34CO94ghMA17Q5xPVX/zS+Y4KNF+XGkaMfYT5IprjHcbeBu6Cm0LF8U
         S4RUaIfKI06Sht63yDk/LXyNH+aacG29WW+fZsDcsV5R/ZTYL89Ute2Xul86tp/hCGOF
         ET74+sESn809VOEBgerHwfOWobP432A0h1ZL7ziahuRMe2149XNbN2XNmQ4hI7wdFB8S
         V84g==
X-Forwarded-Encrypted: i=1; AKwUvByGMLMqiqvf0w4n8XPOea2fdeDPnd9sE4QUTVyiRkLMu6gJCU/QaxG6rgaqU/zYgnUO436ULGw=@lists.linux.dev
X-Gm-Message-State: AFq9FYLDwQdR9vAYFCZYHzvU9Mj5MHuTvJJfixCeqxS0tVku9QUOrQAq
	akwz+viqeWgYwmZwFRjDD9rGY5t5JAR4MVV5NqqcO7lFP75gWl2uVPkugZxGqxDfqlTDDHu9EM4
	SO5nbWs1z2yR9hw==
X-Received: from edv13.prod.google.com ([2002:a05:6402:15cd:b0:6ac:bd3a:5051])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:2489:b0:6ac:8dce:5a8a with SMTP id 4fb4d7f45d1cf-6b17c25d1dbmr16505883a12.9.1792094957800;
 Thu, 15 Oct 2026 13:09:17 -0700 (PDT)
Date: Thu, 15 Oct 2026 20:08:37 +0000
In-Reply-To: <20261015200903.2735565-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20261015200903.2735565-1-smostafa@google.com>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
Message-ID: <20261015200903.2735565-7-smostafa@google.com>
Subject: [PATCH v9 06/25] KVM: arm64: iommu: Introduce IOMMU driver infrastructure
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca, mark.rutland@arm.com, 
	qperret@google.com, tabba@google.com, vdonnefort@google.com, 
	nicolinc@nvidia.com, Mostafa Saleh <smostafa@google.com>, 
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Content-Type: text/plain; charset="UTF-8"

To establish DMA isolation, pKVM needs an IOMMU driver that provides
ops implemented at EL2.

Only one driver can be used. It is registered before KVM initialises
with pkvm_iommu_register_driver().
Registration must come from an initcall between core_initcall() and
fs_initcall(): earlier and the CPU capabilities are not finalised,
later and kvm_arm_init() at device_initcall level has already consumed
the ops.

The hypervisor calls the driver's init last in __pkvm_init_finalise(),
so that no step that can fail runs after it, as drivers have no
teardown. DMA isolation stays optional: without a registered driver
pKVM initialises as before.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/include/asm/kvm_host.h       |  7 +++++
 arch/arm64/kvm/Makefile                 |  2 +-
 arch/arm64/kvm/hyp/include/nvhe/iommu.h | 13 +++++++++
 arch/arm64/kvm/hyp/nvhe/Makefile        |  3 ++-
 arch/arm64/kvm/hyp/nvhe/iommu.c         | 19 ++++++++++++++
 arch/arm64/kvm/hyp/nvhe/setup.c         | 10 +++++++
 arch/arm64/kvm/iommu.c                  | 35 +++++++++++++++++++++++++
 7 files changed, 87 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/iommu.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/iommu.c
 create mode 100644 arch/arm64/kvm/iommu.c

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index cd9b9d2462f9..0c7fb6fa24f5 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1717,4 +1717,11 @@ static __always_inline enum fgt_group_id __fgt_reg_to_group_id(enum vcpu_sysreg
 
 long kvm_get_cap_for_kvm_ioctl(unsigned int ioctl, long *ext);
 
+struct pkvm_iommu_ops;
+extern struct pkvm_iommu_ops *kvm_nvhe_sym(pkvm_iommu_ops);
+
+#ifndef __KVM_NVHE_HYPERVISOR__
+int __init pkvm_iommu_register_driver(struct pkvm_iommu_ops *hyp_ops);
+#endif
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 59612d2f277c..0ddef54f7434 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -24,7 +24,7 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
 	 vgic/vgic-mmio.o vgic/vgic-mmio-v2.o \
 	 vgic/vgic-mmio-v3.o vgic/vgic-kvm-device.o \
 	 vgic/vgic-its.o vgic/vgic-debug.o vgic/vgic-v3-nested.o \
-	 vgic/vgic-v5.o
+	 vgic/vgic-v5.o iommu.o
 
 kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu.o
 kvm-$(CONFIG_ARM64_PTR_AUTH)  += pauth.o
diff --git a/arch/arm64/kvm/hyp/include/nvhe/iommu.h b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
new file mode 100644
index 000000000000..df3d0cc5d4db
--- /dev/null
+++ b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ARM64_KVM_NVHE_IOMMU_H__
+#define __ARM64_KVM_NVHE_IOMMU_H__
+
+#include <asm/kvm_host.h>
+
+struct pkvm_iommu_ops {
+	int (*init)(void);
+};
+
+int pkvm_iommu_init(void);
+
+#endif /* __ARM64_KVM_NVHE_IOMMU_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index f57450ebcb49..7cb79db9bc47 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -24,7 +24,8 @@ CFLAGS_switch.nvhe.o += -Wno-override-init
 
 hyp-obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
 	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o page_alloc.o \
-	 cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o stacktrace.o ffa.o
+	 cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o stacktrace.o ffa.o \
+	 iommu.o
 hyp-obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../hyp-entry.o ../exception.o ../pgtable.o ../vgic-v5-sr.o
 hyp-obj-y += ../../../kernel/smccc-call.o
diff --git a/arch/arm64/kvm/hyp/nvhe/iommu.c b/arch/arm64/kvm/hyp/nvhe/iommu.c
new file mode 100644
index 000000000000..f4572b2dba76
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/iommu.c
@@ -0,0 +1,19 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * IOMMU operations for pKVM
+ *
+ * Copyright (C) 2022 Linaro Ltd.
+ */
+#include <nvhe/iommu.h>
+
+/* Only one set of ops supported */
+struct pkvm_iommu_ops *pkvm_iommu_ops __ro_after_init;
+
+int pkvm_iommu_init(void)
+{
+	/* Keep DMA isolation optional. */
+	if (!pkvm_iommu_ops || !pkvm_iommu_ops->init)
+		return 0;
+
+	return pkvm_iommu_ops->init();
+}
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 45ac5f2ba4f7..620b05c2799a 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -13,6 +13,7 @@
 #include <nvhe/early_alloc.h>
 #include <nvhe/ffa.h>
 #include <nvhe/gfp.h>
+#include <nvhe/iommu.h>
 #include <nvhe/memory.h>
 #include <nvhe/mem_protect.h>
 #include <nvhe/mm.h>
@@ -342,6 +343,15 @@ void __noreturn __pkvm_init_finalise(void)
 	if (ret)
 		goto out;
 
+	/*
+	 * IOMMU init is done at the end, as it sets up and initializes many
+	 * resources that would be leaked if the hypervisor fails after as there
+	 * is no remove_iommu_driver() at the moment.
+	 */
+	ret = pkvm_iommu_init();
+	if (ret)
+		goto out;
+
 	pkvm_hyp_vm_table_init(vm_table_base);
 
 	pkvm_ownership_selftest(selftest_base);
diff --git a/arch/arm64/kvm/iommu.c b/arch/arm64/kvm/iommu.c
new file mode 100644
index 000000000000..ab3f37d61579
--- /dev/null
+++ b/arch/arm64/kvm/iommu.c
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025 Google LLC
+ * Author: Mostafa Saleh <smostafa@google.com>
+ */
+
+#include <linux/kvm_host.h>
+
+#include <asm/kvm_mmu.h>
+
+static DEFINE_MUTEX(pkvm_iommu_reg_lock);
+
+/**
+ * pkvm_iommu_register_driver() - Register the hypervisor IOMMU driver
+ * @hyp_ops: Kernel address of the ops, which live in the hypervisor image,
+ *           i.e. &kvm_nvhe_sym(ops).
+ *
+ * Only one driver can be registered. Call from an initcall between
+ * core_initcall() and fs_initcall().
+ *
+ * Return: 0 on success.
+ */
+int __init pkvm_iommu_register_driver(struct pkvm_iommu_ops *hyp_ops)
+{
+	guard(mutex)(&pkvm_iommu_reg_lock);
+
+	if (!is_protected_kvm_enabled() || is_kvm_arm_initialised())
+		return -EPERM;
+
+	if (kvm_nvhe_sym(pkvm_iommu_ops))
+		return -EBUSY;
+
+	kvm_nvhe_sym(pkvm_iommu_ops) = kern_hyp_va(kvm_ksym_ref(hyp_ops));
+	return 0;
+}
-- 
2.56.0.176.g3575e65682-goog


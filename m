Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C0A22A809
	for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 18:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734026714; cv=none; b=PmxIgylHIhliB7EpfuH/0Iv9DYH1Bdcr/LDsSDSayxWBEcOsbNfOoOh9vtttE5xDrFMB1ZJRjTooXjXUTfKT3KiY8gpToHPPXdBuSfOAfXO7ggAb3iUwlLRVGOhE1kllcDDlaYGWMbcEZBGC0Hfb60I+fzhwkHa/lUm2ApXHsLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734026714; c=relaxed/simple;
	bh=a/JQMVUSO4WSIOgI0iyk5RsJwLOyAIeGYUISnRCOPz4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=c2rFuxwAtqc9m8ScdXby5XqcRLlAGXmOe3+JtCzUaiZqesMv3CUNO5fnKBSEXrB5BNSJ4bDNUlMnCNnRgW5ibERgR6v6e1mP7ngqZpKtliP0A5l2tl7c1VJYEoxbtSiRCT63dJBbih0gj5Fu60kkpX1LgTvgig+677aqgpf72Jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fISD3vTY; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fISD3vTY"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43623bf2a83so8394165e9.0
        for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 10:05:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734026711; x=1734631511; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RS8qlDlci8/4Bym+8sOq6f7pGooq251OZRMaf+SOEgY=;
        b=fISD3vTYqc0jPCtL+9sGKXI00eKImvdzMmdv/4cgVCJ3teTEknyA/mqJpr//GadPdS
         39pnaA3j7apK0j+7ncL8HhEmFvapTX4CFyYL1gJqyjc3H+LVYnONqHi4hqnXRoeZfSSj
         IHGjw9jeIxGTb4jDNhv2DIUr7BHCfOziEit6urp4TiWfy0ZC1ELPzbhGAZvOD8IFClqG
         uasNDXAw/vIiHuGfid1g+ZRrLY4jGVv3zLXYtms+J7IFSTHruD0NQHX9P6NXz86/QtNh
         OJFEd5UQF3lE9amkrZhvde/dLhmHBCFpBP8FvEiJMyGNZiEVOgIPGaRJQColZNyQsC1m
         jHog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734026711; x=1734631511;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RS8qlDlci8/4Bym+8sOq6f7pGooq251OZRMaf+SOEgY=;
        b=hsE//BpBUUy3SGk364f7Rum43gQ/6RoK5UEyAcL4DjhK61y4FB7XtG7rm6e7J3hSFq
         n6hLHKaPyKQyZTHJu7s/pow736t60hqR4GXO87DzmN9GfvPIapP9xR/WfE8ILhq1UwBn
         AVfYmAUsPpcuFQp6KdeB3XFewg43/aCYwVXKWki81zwaU0CMqAAlZtLxhinvv0ywBVk7
         Q9Ux2cv/yxrX4eoR61+dpP22//Gil92dxNMq/o4dbKy9hg3zOC+g537yVg3L2B4eSTNP
         eFvm5XaLd1HRvfl4ssPbz1VkHJb8iDy6Z6+/1gPMxsTE2KkF96MXymjQ0N4xuvWX+28l
         B+QQ==
X-Forwarded-Encrypted: i=1; AJvYcCX50pR1OpsEZ04YyGqCwsIa6oFQxpEaE0VZ0Vbhft+XtZJ4L02P8K6CzaEjuxPBgr5bbXskEMk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx7dRp3oobuCywdkIlhgnVp7CPfYJH8rgl4LYA5Ex2qciYIWOPj
	HLmiyUyqZvb6dNlfSELY86TipNqXTlbQcCMdn9SiTyi608jV+o9Wgr1D60fiCEBGWtyN8LVv2Q0
	6uejBrfeUKg==
X-Google-Smtp-Source: AGHT+IEXzXpQhlLFADFsSKXZo9irA4liP3Y9eVpRtNsKhNXeGfOrD877Mo3P2mHA18Npm95BG/JFoGOJUDSq9w==
X-Received: from wmbd18.prod.google.com ([2002:a05:600c:58d2:b0:434:a98d:6a1c])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:cc7:b0:434:f753:600f with SMTP id 5b1f17b1804b1-4361c3a6062mr66983595e9.19.1734026711336;
 Thu, 12 Dec 2024 10:05:11 -0800 (PST)
Date: Thu, 12 Dec 2024 18:03:37 +0000
In-Reply-To: <20241212180423.1578358-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241212180423.1578358-1-smostafa@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241212180423.1578358-14-smostafa@google.com>
Subject: [RFC PATCH v2 13/58] KVM: arm64: Introduce IOMMU driver infrastructure
From: Mostafa Saleh <smostafa@google.com>
To: iommu@lists.linux.dev, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, robdclark@gmail.com, joro@8bytes.org, 
	robin.murphy@arm.com, jean-philippe@linaro.org, jgg@ziepe.ca, 
	nicolinc@nvidia.com, vdonnefort@google.com, qperret@google.com, 
	tabba@google.com, danielmentz@google.com, tzukui@google.com, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

To establish DMA isolation, KVM needs an IOMMU driver which provide
certain ops, these ops are defined outside of the iommu_ops,
and has 2 components:
- kvm_iommu_driver (kernel): Implements simple interaction with
  the kernel (init, remove,...)
- kvm_iommu_ops (hypervisor): Implements paravirtual interface
  (map, unmap, attach, detach,...)

Only one driver can be used and is registered with
kvm_iommu_register_driver() by passing pointers to both ops.

KVM will initialise the driver after it initialises and before the
de-privilege point, which is a suitable point to establish trusted
interaction between the host and the hypervisor, this also allows
the host kernel to do one initialization from the kernel and avoid
such complexity in the hypervisor as the kernel is still trusted at
this point.

Also, during the registration call, the pointer for the hypervisor
ops will be initialised.

The hypervisor init part is called from the finalise hypercall which
is executed after the kernel kvm IOMMU driver init.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 arch/arm64/include/asm/kvm_host.h       | 11 ++++++
 arch/arm64/kvm/Makefile                 |  2 +-
 arch/arm64/kvm/arm.c                    |  8 ++++-
 arch/arm64/kvm/hyp/include/nvhe/iommu.h | 13 +++++++
 arch/arm64/kvm/hyp/nvhe/Makefile        |  2 +-
 arch/arm64/kvm/hyp/nvhe/iommu/iommu.c   | 18 ++++++++++
 arch/arm64/kvm/hyp/nvhe/setup.c         |  5 +++
 arch/arm64/kvm/iommu.c                  | 47 +++++++++++++++++++++++++
 8 files changed, 103 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/iommu.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
 create mode 100644 arch/arm64/kvm/iommu.c

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 53916a7f0def..54416cfea573 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1628,4 +1628,15 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
 
 unsigned long __pkvm_reclaim_hyp_alloc_mgt(unsigned long nr_pages);
 
+struct kvm_iommu_driver {
+	int (*init_driver)(void);
+	void (*remove_driver)(void);
+};
+
+struct kvm_iommu_ops;
+int kvm_iommu_register_driver(struct kvm_iommu_driver *kern_ops,
+			      struct kvm_iommu_ops *el2_ops);
+int kvm_iommu_init_driver(void);
+void kvm_iommu_remove_driver(void);
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index f9e208273031..440897366e88 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -23,7 +23,7 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
 	 vgic/vgic-v3.o vgic/vgic-v4.o \
 	 vgic/vgic-mmio.o vgic/vgic-mmio-v2.o \
 	 vgic/vgic-mmio-v3.o vgic/vgic-kvm-device.o \
-	 vgic/vgic-its.o vgic/vgic-debug.o
+	 vgic/vgic-its.o vgic/vgic-debug.o iommu.o
 
 kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu.o
 kvm-$(CONFIG_ARM64_PTR_AUTH)  += pauth.o
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 94b210f36573..4b486323c0c9 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2510,9 +2510,15 @@ static int __init kvm_hyp_init_protection(u32 hyp_va_bits)
 	if (ret)
 		return ret;
 
+	ret = kvm_iommu_init_driver();
+	if (ret < 0)
+		return ret;
+
 	ret = do_pkvm_init(hyp_va_bits);
-	if (ret)
+	if (ret) {
+		kvm_iommu_remove_driver();
 		return ret;
+	}
 
 	free_hyp_pgds();
 
diff --git a/arch/arm64/kvm/hyp/include/nvhe/iommu.h b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
new file mode 100644
index 000000000000..1ac70cc28a9e
--- /dev/null
+++ b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ARM64_KVM_NVHE_IOMMU_H__
+#define __ARM64_KVM_NVHE_IOMMU_H__
+
+#include <asm/kvm_host.h>
+
+struct kvm_iommu_ops {
+	int (*init)(void);
+};
+
+int kvm_iommu_init(void);
+
+#endif /* __ARM64_KVM_NVHE_IOMMU_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 415cc51fe391..9e1b74c661d2 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -8,7 +8,7 @@ CFLAGS_switch.nvhe.o += -Wno-override-init
 hyp-obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
 	 hyp-main.o hyp-smp.o psci-relay.o alloc.o early_alloc.o page_alloc.o \
 	 cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o stacktrace.o ffa.o \
-	 serial.o alloc_mgt.o
+	 serial.o alloc_mgt.o iommu/iommu.o
 hyp-obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o
 hyp-obj-$(CONFIG_LIST_HARDENED) += list_debug.o
diff --git a/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c b/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
new file mode 100644
index 000000000000..3bd87d2084e9
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * IOMMU operations for pKVM
+ *
+ * Copyright (C) 2022 Linaro Ltd.
+ */
+#include <nvhe/iommu.h>
+
+/* Only one set of ops supported, similary to the kernel */
+struct kvm_iommu_ops *kvm_iommu_ops;
+
+int kvm_iommu_init(void)
+{
+	if (!kvm_iommu_ops || !kvm_iommu_ops->init)
+		return -ENODEV;
+
+	return kvm_iommu_ops->init();
+}
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 9d09f5f471b9..4d36616a7f02 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -14,6 +14,7 @@
 #include <nvhe/early_alloc.h>
 #include <nvhe/ffa.h>
 #include <nvhe/gfp.h>
+#include <nvhe/iommu.h>
 #include <nvhe/memory.h>
 #include <nvhe/mem_protect.h>
 #include <nvhe/mm.h>
@@ -360,6 +361,10 @@ void __noreturn __pkvm_init_finalise(void)
 	if (ret)
 		goto out;
 
+	ret = kvm_iommu_init();
+	if (ret)
+		goto out;
+
 	ret = fix_host_ownership();
 	if (ret)
 		goto out;
diff --git a/arch/arm64/kvm/iommu.c b/arch/arm64/kvm/iommu.c
new file mode 100644
index 000000000000..ed77ea0d12bb
--- /dev/null
+++ b/arch/arm64/kvm/iommu.c
@@ -0,0 +1,47 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2023 Google LLC
+ * Author: Mostafa Saleh <smostafa@google.com>
+ */
+
+#include <asm/kvm_mmu.h>
+#include <linux/kvm_host.h>
+
+struct kvm_iommu_driver *iommu_driver;
+extern struct kvm_iommu_ops *kvm_nvhe_sym(kvm_iommu_ops);
+
+int kvm_iommu_register_driver(struct kvm_iommu_driver *kern_ops, struct kvm_iommu_ops *el2_ops)
+{
+	int ret;
+
+	if (WARN_ON(!kern_ops || !el2_ops))
+		return -EINVAL;
+
+	/*
+	 * Paired with smp_load_acquire(&iommu_driver)
+	 * Ensure memory stores happening during a driver
+	 * init are observed before executing kvm iommu callbacks.
+	 */
+	ret = cmpxchg_release(&iommu_driver, NULL, kern_ops) ? -EBUSY : 0;
+	if (ret)
+		return ret;
+
+	kvm_nvhe_sym(kvm_iommu_ops) = el2_ops;
+	return 0;
+}
+
+int kvm_iommu_init_driver(void)
+{
+	if (WARN_ON(!smp_load_acquire(&iommu_driver))) {
+		kvm_err("pKVM enabled without an IOMMU driver, do not run confidential workloads in virtual machines\n");
+		return -ENODEV;
+	}
+
+	return iommu_driver->init_driver();
+}
+
+void kvm_iommu_remove_driver(void)
+{
+	if (smp_load_acquire(&iommu_driver))
+		iommu_driver->remove_driver();
+}
-- 
2.47.0.338.g60cca15819-goog


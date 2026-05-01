Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3EC039EF1E
	for <kvmarm@lists.linux.dev>; Fri,  1 May 2026 11:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777634410; cv=none; b=YqDf4g4k7o7LMA2zcE09jXasE/uVnAzhAGAIerGRscEl/U0Sln2SVJSxXyy3nKuQRHxm/wtowXu/rlI48lZFmd93dhM2kSqkozh/RJMAmBBUedFAkNxZB7Y5rGPCLCmE3n9z9h+sMi7P1mHW0mf/kw3QwvypcV53geojrble0os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777634410; c=relaxed/simple;
	bh=7BiQeDIdExKTrYvjjivfx/XCGpvMdX1OxrkfqO2/Rss=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ulmfE76ujgp3DOeTLQtDPYobZAcUQvCt3I1jbJLLLD+R10c/X7sUPq0Ual065V4zSPwqBKnJD3KB1N04ylTaCTX+ZEpcuat3mceaCaosc9Yq18cbqpJkOJsKy4bcUsY3L970MPCs/8phgSZe3Ev2F2PSiz8qo+dwYvGv/OeVpWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=McTyjgxJ; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="McTyjgxJ"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-488d1b5bca0so9939925e9.2
        for <kvmarm@lists.linux.dev>; Fri, 01 May 2026 04:20:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777634407; x=1778239207; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PcUXILApPYbJmZVAe9rvUD8ScMEsBCpayhLYZpcyGpA=;
        b=McTyjgxJk7rgpTtRd7khxzCeJ9ZZGbiV6zj5n+JZ8rCZAGbcM8gStxLvvoVIu/864t
         29Ti1s7BiLzKTncyC9NI0WAvFrsdTZcy4OCutF4seFc2HDZJ0XoJxiMBGhAQvTCUE7E2
         /YCGLM8HCjiaYQWZUrwsFL/FRH8RjLXVA5lLzLyl9lV1FBGxEj+6GftdsXGoQQAXgF45
         +V+9vyDU1h1EfApFSDmn3UsauxxfyaPkNs6OTTthgfVPcl17P9mr+/TqWdSPez7OOLjn
         86SMrvUGG/Va8+3I0ZBXGE6PI5l45U9TJhDMphZcpBsWd4QDPB1sY9H/jiEjnoo/Mn8a
         H//w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777634407; x=1778239207;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PcUXILApPYbJmZVAe9rvUD8ScMEsBCpayhLYZpcyGpA=;
        b=QeQkob8g7ELvkFCLdqWIy+XnjZ5bO8LkRSzIDl6enXJU+u6IFGhm3Xtq6DBuoPdKdL
         V+cpti6/6h9RiqSPYw3unuwondZ2O7jjM9yPkjhq1uyaJE/4Fe/67mE1CRd/dbbL3WFO
         qGLPXpDE9k9YYXNen8hvkG/GUyV3IATDjFWKgt77A9rWBMJGEddyGiPg//TmEHONng+r
         wc+KG+M7dmDUE+DxS1IyA9lb2EO2isqdTCI8UDQhD5HCWh/j4F14rrjG2zItszZUcrNd
         hOpbzfIJFUt7DCcWRXvGU24OgtjzPZrdSVRFKGa/ShIUj/34xI7wKMVQ0YRwfqRqSNY4
         PaXw==
X-Forwarded-Encrypted: i=1; AFNElJ8rM6NtGjLBaF9M5NEhAWkJoroQRgYhek4Yobw/zDAQzObLOUcYACkF4KMMhnNYV6fewMmNFVc=@lists.linux.dev
X-Gm-Message-State: AOJu0YymZTlh4+VzxjBL5wLHTflneF8w8K3OSyDDth781/tNjeZ6gMHq
	lNO3QKQhQqEkvZz+Vdh9jMo4dirWlVdhX9LXH47huswwExrm8pthVXYP0xBL/ce1hbr9p1BntZ7
	HelQYfRnMSjIdOw==
X-Received: from wmrk4.prod.google.com ([2002:a05:600c:b44:b0:48a:6a1b:6c3b])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600d:a:b0:489:1d74:56d with SMTP id 5b1f17b1804b1-48a84532792mr89794945e9.29.1777634406991;
 Fri, 01 May 2026 04:20:06 -0700 (PDT)
Date: Fri,  1 May 2026 11:19:09 +0000
In-Reply-To: <20260501111928.259252-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260501111928.259252-1-smostafa@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260501111928.259252-8-smostafa@google.com>
Subject: [PATCH v6 07/25] KVM: arm64: iommu: Introduce IOMMU driver infrastructure
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org, jgg@ziepe.ca, 
	mark.rutland@arm.com, qperret@google.com, tabba@google.com, 
	vdonnefort@google.com, sebastianene@google.com, keirf@google.com, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

To establish DMA isolation, KVM needs an IOMMU driver which provides
ops implemented at EL2.

Only one driver can be used and is registered with
kvm_iommu_register_driver() by passing pointer to the ops.

This must be called before module_init() which is the point KVM
initializes.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/include/asm/kvm_host.h       |  5 +++++
 arch/arm64/kvm/Makefile                 |  2 +-
 arch/arm64/kvm/hyp/include/nvhe/iommu.h | 13 +++++++++++++
 arch/arm64/kvm/hyp/nvhe/Makefile        |  3 ++-
 arch/arm64/kvm/hyp/nvhe/iommu/iommu.c   | 20 +++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/setup.c         |  5 +++++
 arch/arm64/kvm/iommu.c                  | 26 +++++++++++++++++++++++++
 7 files changed, 72 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/iommu.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
 create mode 100644 arch/arm64/kvm/iommu.c

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 851f6171751c..52898d2a3ec6 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1733,4 +1733,9 @@ static __always_inline enum fgt_group_id __fgt_reg_to_group_id(enum vcpu_sysreg
 
 long kvm_get_cap_for_kvm_ioctl(unsigned int ioctl, long *ext);
 
+#ifndef __KVM_NVHE_HYPERVISOR__
+struct kvm_iommu_ops;
+int kvm_iommu_register_driver(struct kvm_iommu_ops *hyp_ops);
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
index 89d0533921f9..606c0e1b7bd0 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -24,7 +24,8 @@ CFLAGS_switch.nvhe.o += -Wno-override-init
 
 hyp-obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
 	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o page_alloc.o \
-	 cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o stacktrace.o ffa.o
+	 cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o stacktrace.o ffa.o \
+	 iommu/iommu.o
 hyp-obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o ../vgic-v5-sr.o clock.o
 hyp-obj-y += ../../../kernel/smccc-call.o
diff --git a/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c b/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
new file mode 100644
index 000000000000..406c8fb9b3b9
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
@@ -0,0 +1,20 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * IOMMU operations for pKVM
+ *
+ * Copyright (C) 2022 Linaro Ltd.
+ */
+#include <nvhe/iommu.h>
+
+/* Only one set of ops supported */
+struct kvm_iommu_ops *kvm_iommu_ops;
+
+
+int kvm_iommu_init(void)
+{
+	/* Keep DMA isolation optional. */
+	if (!kvm_iommu_ops || !kvm_iommu_ops->init)
+		return 0;
+
+	return kvm_iommu_ops->init();
+}
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 8041f6e80cd1..1f6b221db9a0 100644
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
@@ -329,6 +330,10 @@ void __noreturn __pkvm_init_finalise(void)
 	if (ret)
 		goto out;
 
+	ret = kvm_iommu_init();
+	if (ret)
+		goto out;
+
 	ret = hyp_ffa_init(ffa_proxy_pages);
 	if (ret)
 		goto out;
diff --git a/arch/arm64/kvm/iommu.c b/arch/arm64/kvm/iommu.c
new file mode 100644
index 000000000000..f247384fa193
--- /dev/null
+++ b/arch/arm64/kvm/iommu.c
@@ -0,0 +1,26 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025 Google LLC
+ * Author: Mostafa Saleh <smostafa@google.com>
+ */
+
+#include <linux/kvm_host.h>
+
+extern struct kvm_iommu_ops *kvm_nvhe_sym(kvm_iommu_ops);
+
+static DEFINE_MUTEX(kvm_iommu_reg_lock);
+
+int kvm_iommu_register_driver(struct kvm_iommu_ops *hyp_ops)
+{
+	guard(mutex)(&kvm_iommu_reg_lock);
+
+	/* Only protected KVM before de-privilege. */
+	if (!is_protected_kvm_enabled() || is_kvm_arm_initialised())
+		return -EINVAL;
+
+	if (kvm_nvhe_sym(kvm_iommu_ops))
+		return -EBUSY;
+
+	kvm_nvhe_sym(kvm_iommu_ops) = hyp_ops;
+	return 0;
+}
-- 
2.54.0.545.g6539524ca2-goog


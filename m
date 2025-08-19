Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F304350851
	for <kvmarm@lists.linux.dev>; Tue, 19 Aug 2025 21:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755640356; cv=none; b=qVmwmg/dtE71HU78d1JUgdRKBZsm6hLaEFNbuKZQcX/HRKgWrHalQ3LaxhOJqSxzuRKo2d4BCrOjr19aqm2CxOZpMQeNQVSniL52bWdsJOPZY5bi00/tqBfmh9UyOqnE4232aJoMFwc+4FeDRJ5XG/BTodkiXX3X3YrPECuLX2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755640356; c=relaxed/simple;
	bh=OOUKzEIINv62+Nr69ONVix62Znh1FqiJp+D0GMg+n1Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kaMssaDd7NhiyFDGNFJgbhPQ9JdvP43b6oFfH1hYdIqAleRa2WcIReR2Y9sgcBALgfEMPyiP84iUx7jEaMA+5BlPT2s2SH6UG/Ir0jIzJRCkhBnaJ0g90KqFsY+HG2Nt2zfB8CYBI8+ntbyAwtkwXHlh0yMDqEXBN27DYe/z4YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fZdr7di/; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fZdr7di/"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-afcb78d3b3cso505300766b.1
        for <kvmarm@lists.linux.dev>; Tue, 19 Aug 2025 14:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755640353; x=1756245153; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uZD73D+JnG1A66Ldv7Bw9STsd96Djsc0CQybPNL1eTI=;
        b=fZdr7di/T08jBGBoI79vTZ3X3BNekU/s+qcfr86hqO/697dQvkDYtu3Gr3+N+bdtOg
         4zovLgnRBeu197EgEe3mzKjtDJEviBFW8hwKRtQosSKgMqLwDdTJ6PS+I7aTCcrfF9rn
         4p/NEJcVHV4c/GrOT4t9kQ8Z3vnpQ8+PbBroFWKgFxOkTHVdqhjqAAnpNFiusGIKwTds
         27AhbGUSffQBNVdvpgMXQQVoj3mxVO9DTLUQGv5YHjodVDmEIT98akLoYX5BBYjhCQn7
         9w0hnhod1D6NMYouLoyvchj1ZMAiEXNJlcF9nDmraJ+A97/U82Sx+tM9WWzgt66FlGzO
         NzjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755640353; x=1756245153;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uZD73D+JnG1A66Ldv7Bw9STsd96Djsc0CQybPNL1eTI=;
        b=m6g/jIGvH03aBlnbHooWYtIDG6tkiMjpw+IFn8zA5vb7pOEmZo14eVJm6XOlSmp5XY
         AZtY+7DuuQhEW1VFUy2FdVrVv3KEkzZgW1eRgiFjnYD2kZtNzNJrYgXmsHEW2gYor/50
         fVkstqV4gzOPut0a8tjly/b6NcqtmjU8sixQA5wFlU1uTiIVkapmJ2iFB7QrW0dq2n9L
         hohjQsknqe1sxk44xl4pKRxdeD6xVZAGUiNQP1y0F+Y1nOgeh4hJhwckjgCgrbxN4TIr
         ul7ZMM7dEIta1OHFKF22c7ktLl5qVDK+pxhppxZU5n1fCkmzgdeIFoBH/HhhDf6zV9Or
         EoNA==
X-Forwarded-Encrypted: i=1; AJvYcCU1hPkIYaAEZM3OcOr8Gv46y8u1efD+edqYjQpMTtZp9tNXwt1f7HEeNEHfYFWzRsTwvZ9Hipo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy+L9dDKn7mj3FajHjcWMH8EvioDX3NjAqsjEQjno6IrQO4TCuw
	qHnn5eydnAvC8q7dM0g69p0nByPGpLjR5a5KZn+OodW7GaJcAX8uyerxxCD3u9MUbdlGofpM1C3
	289t8x24C0XOh6A==
X-Google-Smtp-Source: AGHT+IFhsc1uRSTsRRSTrrAPTUS/dsYG6n2qlV2ToNbhyhl/dxgu7ubhyCt6NPAyXCFtBe4NKVRTeRDOa40fsg==
X-Received: from edo2.prod.google.com ([2002:a05:6402:52c2:b0:618:7f6:4f8a])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:9621:b0:afa:f1:ff98 with SMTP id a640c23a62f3a-afdf01bfe1amr42142466b.37.1755640352647;
 Tue, 19 Aug 2025 14:52:32 -0700 (PDT)
Date: Tue, 19 Aug 2025 21:51:37 +0000
In-Reply-To: <20250819215156.2494305-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250819215156.2494305-1-smostafa@google.com>
X-Mailer: git-send-email 2.51.0.rc1.167.g924127e9c0-goog
Message-ID: <20250819215156.2494305-10-smostafa@google.com>
Subject: [PATCH v4 09/28] KVM: arm64: iommu: Introduce IOMMU driver infrastructure
From: Mostafa Saleh <smostafa@google.com>
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, robin.murphy@arm.com, jean-philippe@linaro.org, 
	qperret@google.com, tabba@google.com, jgg@ziepe.ca, mark.rutland@arm.com, 
	praan@google.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

To establish DMA isolation, KVM needs an IOMMU driver which provide
ops implemented at EL2.

Only one driver can be used and is registered with
kvm_iommu_register_driver() by passing pointer to the ops.

This must be called before module_init() which is the point KVM
initializes.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 arch/arm64/include/asm/kvm_host.h       |  2 ++
 arch/arm64/kvm/Makefile                 |  3 ++-
 arch/arm64/kvm/hyp/include/nvhe/iommu.h | 13 +++++++++++++
 arch/arm64/kvm/hyp/nvhe/Makefile        |  3 ++-
 arch/arm64/kvm/hyp/nvhe/iommu/iommu.c   | 18 ++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/setup.c         |  5 +++++
 arch/arm64/kvm/iommu.c                  | 15 +++++++++++++++
 7 files changed, 57 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/iommu.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
 create mode 100644 arch/arm64/kvm/iommu.c

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 3e41a880b062..1a08066eaf7e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1674,5 +1674,7 @@ void compute_fgu(struct kvm *kvm, enum fgt_group_id fgt);
 void get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg, u64 *res0, u64 *res1);
 void check_feature_map(void);
 
+struct kvm_iommu_ops;
+int kvm_iommu_register_driver(struct kvm_iommu_ops *hyp_ops);
 
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 7c329e01c557..5528704bfd72 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -23,7 +23,8 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
 	 vgic/vgic-v3.o vgic/vgic-v4.o \
 	 vgic/vgic-mmio.o vgic/vgic-mmio-v2.o \
 	 vgic/vgic-mmio-v3.o vgic/vgic-kvm-device.o \
-	 vgic/vgic-its.o vgic/vgic-debug.o vgic/vgic-v3-nested.o
+	 vgic/vgic-its.o vgic/vgic-debug.o vgic/vgic-v3-nested.o \
+	 iommu.o
 
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
index a76522d63c3e..393ff143f0be 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -24,7 +24,8 @@ CFLAGS_switch.nvhe.o += -Wno-override-init
 
 hyp-obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
 	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o page_alloc.o \
-	 cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o stacktrace.o ffa.o
+	 cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o stacktrace.o ffa.o \
+	 iommu/iommu.o
 hyp-obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o
 hyp-obj-$(CONFIG_LIST_HARDENED) += list_debug.o
diff --git a/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c b/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
new file mode 100644
index 000000000000..a01c036c55be
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
+/* Only one set of ops supported */
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
index ee6435473204..bdbc77395e03 100644
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
@@ -320,6 +321,10 @@ void __noreturn __pkvm_init_finalise(void)
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
index 000000000000..926a1a94698f
--- /dev/null
+++ b/arch/arm64/kvm/iommu.c
@@ -0,0 +1,15 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2023 Google LLC
+ * Author: Mostafa Saleh <smostafa@google.com>
+ */
+
+#include <linux/kvm_host.h>
+
+extern struct kvm_iommu_ops *kvm_nvhe_sym(kvm_iommu_ops);
+
+int kvm_iommu_register_driver(struct kvm_iommu_ops *hyp_ops)
+{
+	kvm_nvhe_sym(kvm_iommu_ops) = hyp_ops;
+	return 0;
+}
-- 
2.51.0.rc1.167.g924127e9c0-goog


Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0931D44B675
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 11:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784116764; cv=none; b=T1IxY8jyKu1OzUEm1Ft7b1Gm0XfB2gN2/qx18UZuAzSzaWVDamqKb0TeKORcFRMryYjPIoVqO5D+mhmYMuVSsvDXFC+TeXPB0rYxwL15Lc3u7o8vUeKZSPI55XQKY2vHFZpefAVWQ+2rj7KCbwATUL4IpSbS7tEBT3zsRLbL4u0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784116764; c=relaxed/simple;
	bh=l7xNH1sdHkX9F6VuAunb+LNEI8y2Y/WCTnyY4t5In2c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dOF0kheGfAjfns5SsoKTIge+fa1eGijkyUKqOKxYsMKtakceROTjIx11LtgHJERcNjtBmNORkMMRg80WS9LhVnGRH1IkHZRu0Oll6X8MqvNWpNjRqLnbD9IVdJyRoBiSwRNZxoHgw2dhrkUiREeOAWCJqsxYpomw0lKwCun9W2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=clcvb4Ai; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="clcvb4Ai"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-493dc8408fdso16995755e9.1
        for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 04:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784116760; x=1784721560; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gLKA5ZqrCoYNFtJDAb4FxTuJKcFNr0bWkCPJJJzFwTU=;
        b=clcvb4AieO2Y0D+Bcez8L9RjLt5pvYZlgoD9ICj4a3iEKCaxb7o1hT+itzB/5QDLJw
         Pl1NXmG205xRSK43SbYBjKe98ZCKn5u/r2Af96DCJ9/G5jMStTOBMvLMt5GucQn+haLP
         pMZD3cboHzmkVf9upN3vRsvfg5NjDgLGUYPRQdg5KJApAjM/N5hXkgs9QNOh/IcwggaZ
         Bq8vuVw8nRj9JUzZht/3CYT1Uv3GKESjN/gV9yAlJN95aj/AaYvIsnm9rFkGGuk/JYVh
         uuCq10kGaACQXNJWjF3mM2fC0LtH9zdx9QG/tzAqERB9Pza7mPvkUs+x8I/uqiQ+lDPn
         fKHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784116760; x=1784721560;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gLKA5ZqrCoYNFtJDAb4FxTuJKcFNr0bWkCPJJJzFwTU=;
        b=pSucb9/NupKyg87gqOQpGL6OZOFgR/Yzi+QANfjYmnwZxVyDLu+5WGhnohAnobA7GN
         b78D6/LEG0GlLJTZJrMiNLujGXwha2PC7NIE9X+unS5cNgNAUMpQWWw0peATCbXep/jB
         xSnXo/B4YlqQIuxg6Zs8/W9VuWBfBwMrQ2Le5QEGRndXqaWEyP2wQ7sBpyKIRKgk5onW
         tXleapHm8q+I9LduiCqUxHLjmy/DL+CT5+IRm5spZyAB8QaT4cEMm0pW46xngyjMXszA
         370Re3be5WUgQiVYsv7ryy5+pSbCVd7/Q+LtjyyOeXiHqTQAFTLe3qLjteYZ4aYVaa1M
         eZ+g==
X-Forwarded-Encrypted: i=1; AHgh+RqNwKBU0R2p5ta0OA7ToOFzwXqRMUQxEFZ/CUKWemn0MXOLd1kCFDcdkkx7cRzyfXThCKn1fXc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzIOVaxtOh7JmZOsMbmsxjU57vHtjf/VfEPri0ABBfC8nKxA+0u
	3iaAY5co4B5E3qAvsztCXBfilBODutgpGH7nmmy91tb/zuQtPuQBszBdRTa1Y8x3cBE5JmNP+Qi
	J04CeXGv4E1murw==
X-Received: from wmrc3.prod.google.com ([2002:a05:600c:ac3:b0:493:b91c:52cb])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4205:b0:493:f7bc:26e4 with SMTP id 5b1f17b1804b1-493f8829970mr106991555e9.31.1784116760105;
 Wed, 15 Jul 2026 04:59:20 -0700 (PDT)
Date: Wed, 15 Jul 2026 11:58:47 +0000
In-Reply-To: <20260715115906.2664882-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260715115906.2664882-1-smostafa@google.com>
X-Mailer: git-send-email 2.55.0.141.g00534a21ce-goog
Message-ID: <20260715115906.2664882-7-smostafa@google.com>
Subject: [PATCH v7 06/24] KVM: arm64: iommu: Introduce IOMMU driver infrastructure
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca, mark.rutland@arm.com, 
	qperret@google.com, tabba@google.com, vdonnefort@google.com, 
	sebastianene@google.com, keirf@google.com, 
	Mostafa Saleh <smostafa@google.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>
Content-Type: text/plain; charset="UTF-8"

To establish DMA isolation, KVM needs an IOMMU driver which provides
ops implemented at EL2.

Only one driver can be used and is registered with
pkvm_iommu_register_driver() by passing pointer to the ops.

This must be called before module_init() which is the point KVM
initializes.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/include/asm/kvm_host.h       |  5 +++++
 arch/arm64/kvm/Makefile                 |  2 +-
 arch/arm64/kvm/hyp/include/nvhe/iommu.h | 13 +++++++++++++
 arch/arm64/kvm/hyp/nvhe/Makefile        |  3 ++-
 arch/arm64/kvm/hyp/nvhe/iommu.c         | 19 +++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/setup.c         | 10 ++++++++++
 arch/arm64/kvm/iommu.c                  | 25 +++++++++++++++++++++++++
 7 files changed, 75 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/iommu.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/iommu.c
 create mode 100644 arch/arm64/kvm/iommu.c

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index bae2c4f92ef5..43821767ccab 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1711,4 +1711,9 @@ static __always_inline enum fgt_group_id __fgt_reg_to_group_id(enum vcpu_sysreg
 
 long kvm_get_cap_for_kvm_ioctl(unsigned int ioctl, long *ext);
 
+#ifndef __KVM_NVHE_HYPERVISOR__
+struct pkvm_iommu_ops;
+int pkvm_iommu_register_driver(struct pkvm_iommu_ops *hyp_ops);
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
index 7c879292974d..b3e7473f18d2 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -24,7 +24,8 @@ CFLAGS_switch.nvhe.o += -Wno-override-init
 
 hyp-obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
 	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o page_alloc.o \
-	 cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o stacktrace.o ffa.o
+	 cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o stacktrace.o ffa.o \
+	 iommu.o
 hyp-obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../hyp-entry.o ../exception.o ../pgtable.o ../vgic-v5-sr.o clock.o
 hyp-obj-y += ../../../kernel/smccc-call.o
diff --git a/arch/arm64/kvm/hyp/nvhe/iommu.c b/arch/arm64/kvm/hyp/nvhe/iommu.c
new file mode 100644
index 000000000000..ef456eff42d2
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
+struct pkvm_iommu_ops *pkvm_iommu_ops;
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
index 970c5cf342f5..c6698ecea4a2 100644
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
@@ -333,6 +334,15 @@ void __noreturn __pkvm_init_finalise(void)
 	if (ret)
 		goto out;
 
+	/*
+	 * IOMMU init is done at the the end as it setups and initializes many resources
+	 * that would be leaked if the hypervisor fails after as there is no
+	 * remove_iommu_driver() ops at the moment, that can be added later if necessary.
+	 */
+	ret = pkvm_iommu_init();
+	if (ret)
+		goto out;
+
 	pkvm_hyp_vm_table_init(vm_table_base);
 
 	pkvm_ownership_selftest(selftest_base);
diff --git a/arch/arm64/kvm/iommu.c b/arch/arm64/kvm/iommu.c
new file mode 100644
index 000000000000..6492285012a4
--- /dev/null
+++ b/arch/arm64/kvm/iommu.c
@@ -0,0 +1,25 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025 Google LLC
+ * Author: Mostafa Saleh <smostafa@google.com>
+ */
+
+#include <linux/kvm_host.h>
+
+extern struct pkvm_iommu_ops *kvm_nvhe_sym(pkvm_iommu_ops);
+
+static DEFINE_MUTEX(pkvm_iommu_reg_lock);
+
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
+	kvm_nvhe_sym(pkvm_iommu_ops) = hyp_ops;
+	return 0;
+}
-- 
2.55.0.141.g00534a21ce-goog


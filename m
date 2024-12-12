Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02683223E7B
	for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 18:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734026730; cv=none; b=KpE/AlSd/yETKu/PD/8G/LDqxlsleHB5bwA1oVz94D3Gh39Mur/ZNPSQACyRXkW2pd7WknAGC3B6xF2YCqX/Rv+jAPSj4lANWN0XBMU/CCBzrYcKsuuw6G/hVFNMiW2K7zCfA4yGSoa7FfdlGYUVpqmPP8z1VUNTBot7mX5mOSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734026730; c=relaxed/simple;
	bh=bRcvub80rx4C3PI7vztkfCku189v3L3VAbJCJAIthps=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Wm8pSQRnrjG8TgoOWfrVBfuYCIYiWMJMOA6wvWM/pc5a0vvEPkZooK2hKv4fLvGFzmeWhDtoeGidpfQmvjN20xOmCxldQ4+Ch1LEvj6amuYjT/QIRaFQWXdFUy8rwu+5628vxgjHMOQEz71EG8QRUjGgWMf/0Wp7deUGc1sqbR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CZNLx9j8; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CZNLx9j8"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4361efc9d1fso8314695e9.2
        for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 10:05:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734026725; x=1734631525; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=S7kpsgAhVH2bN/fIbcV7TDao/OohnNe7nMaqWp62Lyo=;
        b=CZNLx9j8Sz1ziH/eF5CUPPl7K729Iy0tVIraz525QUouSGBPa9qJ0z8h4Kjrlz2am8
         +0wkygoDoQTIGaIv4Ub2r2CI07A9JAh+ROGYKF4mnpY6aXSf0613Lta2jOFZA6BERPKE
         SX0b90AvIvF820OnYV+tBcs9DRtQ0jHPjGWoyyoVpZ06mHiKBwK3pHq2wawlwuy8S4Jg
         BuWQhYKwP44Hpu7J/gPFtgj8bqY0QgP6t+ZnlDCGPkFyNshCe6Cv/sxx2dcy5rWsQqYq
         H8Ff74PEDKCY/6KhKZ4F/zCzXByXSvUhCkBMdTuAp9aVRvJmlBioZL85ZKttQyA9wnJd
         8Xzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734026725; x=1734631525;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S7kpsgAhVH2bN/fIbcV7TDao/OohnNe7nMaqWp62Lyo=;
        b=Ntr9ZDIAYcUIspwFxBZkUnGtNlSZGI9lF1xdRgxeDrfF0d5/QCBYhjm8+y4iwAr4d8
         o5xkK25amLDxBIl95v7H9iKrMAgUe0G9GfORA/56pay+l3QPGOzN3SfSVcYkWQTztYpA
         7FpcGwuX7YjTN4m8UQAJFv9F+UVgoiTO1ONQYZKxnPaiTcm93rR92ioa6T2k99+JRc3B
         Ztz4vA37YmC2QnGMnljtUlb7vP9FLPrzWjIv4zsB4yFJPDwGqyyNOJgEA8WAHYtvLAzK
         iPp4Xeg8EhODerWkW+N25DRMsNHUCbH5WPKwTbsq//OxYVZm0HPWI6Rv9TOm5prBtMzz
         0yFw==
X-Forwarded-Encrypted: i=1; AJvYcCUA7IucyayOSFYkr3xGJvb7DuTw6A+WQCWPeke9zD3Iw4DNHuITPKWFMoKSQC1o53fa5h09lyQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YyQ8g9fP5AOiZi6c4/xmlfKd24WgirU7hmd1kzxeHVhLf/CTznZ
	/EcBa8+WtIptAtWpx5N3r3XzQH1Te1eWrVXvAHcYfoG+6luCv3HPS8FF5aXDiTY1OCGHdor+Iqc
	3d8LO6DMXOA==
X-Google-Smtp-Source: AGHT+IF25HMr2bpcyIuNUAnWweDO42iRimcWzqAUfJd/l3fGaSIRxPPS2WBm0GYXtXtdeE6P3qMiQCbNAneVug==
X-Received: from wmpr23.prod.google.com ([2002:a05:600c:3217:b0:434:f5f3:3314])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:35c9:b0:434:e9ee:c2d with SMTP id 5b1f17b1804b1-4361c401531mr58358885e9.26.1734026725379;
 Thu, 12 Dec 2024 10:05:25 -0800 (PST)
Date: Thu, 12 Dec 2024 18:03:44 +0000
In-Reply-To: <20241212180423.1578358-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241212180423.1578358-1-smostafa@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241212180423.1578358-21-smostafa@google.com>
Subject: [RFC PATCH v2 20/58] KVM: arm64: Support power domains
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

Unfortunately, as power management is not widely standardized we have
to work around that.

One implementation we can support is HOST_HVC, where the host
is in control of the power management and it notifies the
hypervisor about the updates.

This adds extra constraints to the IOMMUs, as they must reset to
blocking DMA traffic to be able to use this PD interface.

Unfortunately again, for SMMUv3 which is the only IOMMU currently
supported, there is no architectural way to discover this, so we
rely on enabling this driver when it fits the constraints, also
the driver sets GBPA and assumes that the SMMU retains across
power cycling.

In the next patch SCMI support is added.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 arch/arm64/include/asm/kvm_asm.h       |  1 +
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h | 30 ++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/Makefile       |  2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c     |  9 +++++
 arch/arm64/kvm/hyp/nvhe/power/hvc.c    | 47 ++++++++++++++++++++++++++
 include/kvm/power_domain.h             | 17 ++++++++++
 6 files changed, 105 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/kvm/hyp/nvhe/power/hvc.c
 create mode 100644 include/kvm/power_domain.h

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 9ea155a04332..3dbf30cd10f3 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -114,6 +114,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_iommu_map_pages,
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_iommu_unmap_pages,
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_iommu_iova_to_phys,
+	__KVM_HOST_SMCCC_FUNC___pkvm_host_hvc_pd,
 
 	/*
 	 * Start of the dynamically registered hypercalls. Start a bit
diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index 8a5554615e40..e4a94696b10e 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -8,6 +8,7 @@
 #define __ARM64_KVM_NVHE_PKVM_H__
 
 #include <asm/kvm_pkvm.h>
+#include <kvm/power_domain.h>
 
 #include <nvhe/gfp.h>
 #include <nvhe/spinlock.h>
@@ -146,4 +147,33 @@ void pkvm_poison_pvmfw_pages(void);
 int pkvm_timer_init(void);
 void pkvm_udelay(unsigned long usecs);
 
+#define MAX_POWER_DOMAINS		32
+
+struct kvm_power_domain_ops {
+	int (*power_on)(struct kvm_power_domain *pd);
+	int (*power_off)(struct kvm_power_domain *pd);
+};
+
+int pkvm_init_hvc_pd(struct kvm_power_domain *pd,
+		     const struct kvm_power_domain_ops *ops);
+
+int pkvm_host_hvc_pd(u64 device_id, u64 on);
+
+/*
+ * Register a power domain. When the hypervisor catches power requests from the
+ * host for this power domain, it calls the power ops with @pd as argument.
+ */
+static inline int pkvm_init_power_domain(struct kvm_power_domain *pd,
+					 const struct kvm_power_domain_ops *ops)
+{
+	switch (pd->type) {
+	case KVM_POWER_DOMAIN_NONE:
+		return 0;
+	case KVM_POWER_DOMAIN_HOST_HVC:
+		return pkvm_init_hvc_pd(pd, ops);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 #endif /* __ARM64_KVM_NVHE_PKVM_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 9e1b74c661d2..950d34ba6e50 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -8,7 +8,7 @@ CFLAGS_switch.nvhe.o += -Wno-override-init
 hyp-obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
 	 hyp-main.o hyp-smp.o psci-relay.o alloc.o early_alloc.o page_alloc.o \
 	 cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o stacktrace.o ffa.o \
-	 serial.o alloc_mgt.o iommu/iommu.o
+	 serial.o alloc_mgt.o iommu/iommu.o power/hvc.o
 hyp-obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o
 hyp-obj-$(CONFIG_LIST_HARDENED) += list_debug.o
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 9b224842c487..5df98bf04ef4 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -1674,6 +1674,14 @@ static void handle___pkvm_host_iommu_iova_to_phys(struct kvm_cpu_context *host_c
 	cpu_reg(host_ctxt, 1) = kvm_iommu_iova_to_phys(domain, iova);
 }
 
+static void handle___pkvm_host_hvc_pd(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(u64, device_id, host_ctxt, 1);
+	DECLARE_REG(u64, on, host_ctxt, 2);
+
+	cpu_reg(host_ctxt, 1) = pkvm_host_hvc_pd(device_id, on);
+}
+
 typedef void (*hcall_t)(struct kvm_cpu_context *);
 
 #define HANDLE_FUNC(x)	[__KVM_HOST_SMCCC_FUNC_##x] = (hcall_t)handle_##x
@@ -1738,6 +1746,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_host_iommu_map_pages),
 	HANDLE_FUNC(__pkvm_host_iommu_unmap_pages),
 	HANDLE_FUNC(__pkvm_host_iommu_iova_to_phys),
+	HANDLE_FUNC(__pkvm_host_hvc_pd),
 };
 
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp/nvhe/power/hvc.c b/arch/arm64/kvm/hyp/nvhe/power/hvc.c
new file mode 100644
index 000000000000..f4d811847e73
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/power/hvc.c
@@ -0,0 +1,47 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2023 Google LLC
+ * Author: Mostafa Saleh <smostafa@google.com>
+ */
+
+#include <nvhe/pkvm.h>
+
+struct hvc_power_domain {
+	struct kvm_power_domain			*pd;
+	const struct kvm_power_domain_ops	*ops;
+};
+
+struct hvc_power_domain handlers[MAX_POWER_DOMAINS];
+
+int pkvm_init_hvc_pd(struct kvm_power_domain *pd,
+		     const struct kvm_power_domain_ops *ops)
+{
+	if (pd->device_id >= MAX_POWER_DOMAINS)
+		return -E2BIG;
+
+	handlers[pd->device_id].ops = ops;
+	handlers[pd->device_id].pd = pd;
+
+	return 0;
+}
+
+int pkvm_host_hvc_pd(u64 device_id, u64 on)
+{
+	struct hvc_power_domain *pd;
+
+	if (device_id >= MAX_POWER_DOMAINS)
+		return -E2BIG;
+
+	device_id = array_index_nospec(device_id, MAX_POWER_DOMAINS);
+	pd = &handlers[device_id];
+
+	if (!pd->ops)
+		return -ENOENT;
+
+	if (on)
+		pd->ops->power_on(pd->pd);
+	else
+		pd->ops->power_off(pd->pd);
+
+	return 0;
+}
diff --git a/include/kvm/power_domain.h b/include/kvm/power_domain.h
new file mode 100644
index 000000000000..f6a9c5cdfebb
--- /dev/null
+++ b/include/kvm/power_domain.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __KVM_POWER_DOMAIN_H
+#define __KVM_POWER_DOMAIN_H
+
+enum kvm_power_domain_type {
+	KVM_POWER_DOMAIN_NONE,
+	KVM_POWER_DOMAIN_HOST_HVC,
+};
+
+struct kvm_power_domain {
+	enum kvm_power_domain_type	type;
+	union {
+		u64 device_id; /* HOST_HVC device ID*/
+	};
+};
+
+#endif /* __KVM_POWER_DOMAIN_H */
-- 
2.47.0.338.g60cca15819-goog


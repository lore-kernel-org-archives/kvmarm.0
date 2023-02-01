Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9B52F5B
	for <kvmarm@lists.linux.dev>; Wed,  1 Feb 2023 12:59:33 +0000 (UTC)
Received: by mail-wr1-f46.google.com with SMTP id q5so17271742wrv.0
        for <kvmarm@lists.linux.dev>; Wed, 01 Feb 2023 04:59:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G6BgqxwA1odPYdBAEqyReTKBcBbq6uXa1i9UbGB0ybQ=;
        b=EazViK8yxWcKpkfVJNZvJueBnGPM/oDDtabRBujMKyDPbeL0qHofs5atHNkRfT7ZiU
         GBuVLO9C1Fk47FFTq3HCr9mFCKmydVB5P6rX97/5Xtg/kAMRS1RZ0FX2vl28SkEYVfrJ
         YiuL7MJGeWHqiBYDgEEdOuwSZ0CCMU+BClA+bPMo1zID0tLRHnZL0T+r1q9jrnKqXU3I
         nXj8TywAhKFMQDgfxc/I/7CtKyutv6Sr+W8F1Lb4C31r4cawdlYagCo7y2mUp51vJx0v
         yeGknEWXUoptphB5+UzpJTwC0eL67LtRl+lcDuc/pKhLYmUXZqXscPy+Hm0AF3nRBIty
         TSSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G6BgqxwA1odPYdBAEqyReTKBcBbq6uXa1i9UbGB0ybQ=;
        b=7Y3qG/T+m6o6cPEHP1bFnV0LAdBcw8OSmCuYq6LvJnPmJOMPFsil87iNsTuBVCUXNj
         rRhnV7cE0qUajUikDkeyCEJ+GY6jcZFs0thoAGHPafC/oaXDuys+xR/vPodPpyTO87tk
         mHh+ZFJlz9ZwuGIdGtvtzVU8gUaOUxxq/ddLjCZHrne/DEy8qTxYxnDIXZqMGm/neqsQ
         BBbxz+d0EBEIe54EGLjWMTKyJPCA7sgCqFWkQJ9HPNKNqLzupuad/V/kdHJbNdlSaLg7
         F8P7AhFip+o6t8taLlhUezrQxcPR/EfCsnaAAR5KcNfyQ7pap9oKy07qUScN7iVZnzng
         KyIQ==
X-Gm-Message-State: AO0yUKXHq4dAGvQ+QHghUQZXfuctOu1JUKiaNwtRCreA//OHs86Fiwls
	Ytrv3ltEM5m19AwPihmuYk7vrg==
X-Google-Smtp-Source: AK7set81aKvdcQaLewXl1g1lgIZu1YK6jk5mNmi1mVBmg+yjTMjafMe+mt3JWLOK122eqlFgCHcvQQ==
X-Received: by 2002:adf:e702:0:b0:2bf:b765:7a13 with SMTP id c2-20020adfe702000000b002bfb7657a13mr5780615wrm.5.1675256372070;
        Wed, 01 Feb 2023 04:59:32 -0800 (PST)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id m15-20020a056000024f00b002bfae16ee2fsm17972811wrz.111.2023.02.01.04.59.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 04:59:31 -0800 (PST)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: maz@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	joro@8bytes.org
Cc: robin.murphy@arm.com,
	james.morse@arm.com,
	suzuki.poulose@arm.com,
	oliver.upton@linux.dev,
	yuzenghui@huawei.com,
	smostafa@google.com,
	dbrazdil@google.com,
	ryan.roberts@arm.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	iommu@lists.linux.dev,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [RFC PATCH 16/45] KVM: arm64: Introduce IOMMU driver infrastructure
Date: Wed,  1 Feb 2023 12:53:00 +0000
Message-Id: <20230201125328.2186498-17-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230201125328.2186498-1-jean-philippe@linaro.org>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Brazdil <dbrazdil@google.com>

Bootstrap infrastructure for IOMMU drivers by introducing kvm_iommu_ops
struct in EL2 that is populated based on a iommu_driver parameter to
__pkvm_init hypercall and selected in EL1 early init.

An 'init' operation is called in __pkvm_init_finalise, giving the driver
an opportunity to initialize itself in EL2 and create any EL2 mappings
that it will need. 'init' is specifically called before
'finalize_host_mappings' so that:
  (a) pages mapped by the driver change owner to hyp,
  (b) ownership changes in 'finalize_host_mappings' get reflected in
      IOMMU mappings (added in a future patch).

Signed-off-by: David Brazdil <dbrazdil@google.com>
[JPB: add remove(), move to include/nvhe]
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 arch/arm64/include/asm/kvm_host.h       |  4 ++++
 arch/arm64/include/asm/kvm_hyp.h        |  3 ++-
 arch/arm64/kvm/hyp/include/nvhe/iommu.h | 11 +++++++++++
 arch/arm64/kvm/arm.c                    | 25 +++++++++++++++++++++----
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      |  6 +++++-
 arch/arm64/kvm/hyp/nvhe/setup.c         | 24 +++++++++++++++++++++++-
 6 files changed, 66 insertions(+), 7 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/iommu.h

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 02850cf3f0de..b8e032bda022 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -377,6 +377,10 @@ extern s64 kvm_nvhe_sym(hyp_physvirt_offset);
 extern u64 kvm_nvhe_sym(hyp_cpu_logical_map)[NR_CPUS];
 #define hyp_cpu_logical_map CHOOSE_NVHE_SYM(hyp_cpu_logical_map)
 
+enum kvm_iommu_driver {
+	KVM_IOMMU_DRIVER_NONE,
+};
+
 struct vcpu_reset_state {
 	unsigned long	pc;
 	unsigned long	r0;
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 1b597b7db99b..0226a719e28f 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -114,7 +114,8 @@ void __noreturn __hyp_do_panic(struct kvm_cpu_context *host_ctxt, u64 spsr,
 void __pkvm_init_switch_pgd(phys_addr_t phys, unsigned long size,
 			    phys_addr_t pgd, void *sp, void *cont_fn);
 int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long nr_cpus,
-		unsigned long *per_cpu_base, u32 hyp_va_bits);
+		unsigned long *per_cpu_base, u32 hyp_va_bits,
+		enum kvm_iommu_driver iommu_driver);
 void __noreturn __host_enter(struct kvm_cpu_context *host_ctxt);
 #endif
 
diff --git a/arch/arm64/kvm/hyp/include/nvhe/iommu.h b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
new file mode 100644
index 000000000000..c728c8e913da
--- /dev/null
+++ b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
@@ -0,0 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ARM64_KVM_NVHE_IOMMU_H__
+#define __ARM64_KVM_NVHE_IOMMU_H__
+
+struct kvm_iommu_ops {
+	int (*init)(void);
+};
+
+extern struct kvm_iommu_ops kvm_iommu_ops;
+
+#endif /* __ARM64_KVM_NVHE_IOMMU_H__ */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index c96fd7deea14..31faae76d519 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1899,6 +1899,15 @@ static bool init_psci_relay(void)
 	return true;
 }
 
+static int init_stage2_iommu(void)
+{
+	return KVM_IOMMU_DRIVER_NONE;
+}
+
+static void remove_stage2_iommu(enum kvm_iommu_driver iommu)
+{
+}
+
 static int init_subsystems(void)
 {
 	int err = 0;
@@ -1957,7 +1966,7 @@ static void teardown_hyp_mode(void)
 	}
 }
 
-static int do_pkvm_init(u32 hyp_va_bits)
+static int do_pkvm_init(u32 hyp_va_bits, enum kvm_iommu_driver iommu_driver)
 {
 	void *per_cpu_base = kvm_ksym_ref(kvm_nvhe_sym(kvm_arm_hyp_percpu_base));
 	int ret;
@@ -1966,7 +1975,7 @@ static int do_pkvm_init(u32 hyp_va_bits)
 	cpu_hyp_init_context();
 	ret = kvm_call_hyp_nvhe(__pkvm_init, hyp_mem_base, hyp_mem_size,
 				num_possible_cpus(), kern_hyp_va(per_cpu_base),
-				hyp_va_bits);
+				hyp_va_bits, iommu_driver);
 	cpu_hyp_init_features();
 
 	/*
@@ -1996,15 +2005,23 @@ static void kvm_hyp_init_symbols(void)
 static int kvm_hyp_init_protection(u32 hyp_va_bits)
 {
 	void *addr = phys_to_virt(hyp_mem_base);
+	enum kvm_iommu_driver iommu;
 	int ret;
 
 	ret = create_hyp_mappings(addr, addr + hyp_mem_size, PAGE_HYP);
 	if (ret)
 		return ret;
 
-	ret = do_pkvm_init(hyp_va_bits);
-	if (ret)
+	ret = init_stage2_iommu();
+	if (ret < 0)
 		return ret;
+	iommu = ret;
+
+	ret = do_pkvm_init(hyp_va_bits, iommu);
+	if (ret) {
+		remove_stage2_iommu(iommu);
+		return ret;
+	}
 
 	free_hyp_pgds();
 
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 29ce7b09edbb..37e308337fec 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -14,6 +14,7 @@
 #include <asm/kvm_host.h>
 #include <asm/kvm_hyp.h>
 
+#include <nvhe/iommu.h>
 #include <nvhe/mem_protect.h>
 #include <nvhe/mm.h>
 #include <nvhe/pkvm.h>
@@ -34,6 +35,8 @@ static DEFINE_PER_CPU(struct user_fpsimd_state, loaded_host_fpsimd_state);
 
 DEFINE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
 
+struct kvm_iommu_ops kvm_iommu_ops;
+
 void __kvm_hyp_host_forward_smc(struct kvm_cpu_context *host_ctxt);
 
 typedef void (*hyp_entry_exit_handler_fn)(struct pkvm_hyp_vcpu *);
@@ -958,6 +961,7 @@ static void handle___pkvm_init(struct kvm_cpu_context *host_ctxt)
 	DECLARE_REG(unsigned long, nr_cpus, host_ctxt, 3);
 	DECLARE_REG(unsigned long *, per_cpu_base, host_ctxt, 4);
 	DECLARE_REG(u32, hyp_va_bits, host_ctxt, 5);
+	DECLARE_REG(enum kvm_iommu_driver, iommu_driver, host_ctxt, 6);
 
 	/*
 	 * __pkvm_init() will return only if an error occurred, otherwise it
@@ -965,7 +969,7 @@ static void handle___pkvm_init(struct kvm_cpu_context *host_ctxt)
 	 * with the host context directly.
 	 */
 	cpu_reg(host_ctxt, 1) = __pkvm_init(phys, size, nr_cpus, per_cpu_base,
-					    hyp_va_bits);
+					    hyp_va_bits, iommu_driver);
 }
 
 static void handle___pkvm_cpu_set_vector(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index de7d60c3c20b..3e73c066d560 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -11,6 +11,7 @@
 
 #include <nvhe/early_alloc.h>
 #include <nvhe/gfp.h>
+#include <nvhe/iommu.h>
 #include <nvhe/memory.h>
 #include <nvhe/mem_protect.h>
 #include <nvhe/mm.h>
@@ -288,6 +289,16 @@ static int fix_hyp_pgtable_refcnt(void)
 				&walker);
 }
 
+static int select_iommu_ops(enum kvm_iommu_driver driver)
+{
+	switch (driver) {
+	case KVM_IOMMU_DRIVER_NONE:
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
 void __noreturn __pkvm_init_finalise(void)
 {
 	struct kvm_host_data *host_data = this_cpu_ptr(&kvm_host_data);
@@ -321,6 +332,12 @@ void __noreturn __pkvm_init_finalise(void)
 	if (ret)
 		goto out;
 
+	if (kvm_iommu_ops.init) {
+		ret = kvm_iommu_ops.init();
+		if (ret)
+			goto out;
+	}
+
 	ret = fix_host_ownership();
 	if (ret)
 		goto out;
@@ -345,7 +362,8 @@ void __noreturn __pkvm_init_finalise(void)
 }
 
 int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long nr_cpus,
-		unsigned long *per_cpu_base, u32 hyp_va_bits)
+		unsigned long *per_cpu_base, u32 hyp_va_bits,
+		enum kvm_iommu_driver iommu_driver)
 {
 	struct kvm_nvhe_init_params *params;
 	void *virt = hyp_phys_to_virt(phys);
@@ -368,6 +386,10 @@ int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long nr_cpus,
 	if (ret)
 		return ret;
 
+	ret = select_iommu_ops(iommu_driver);
+	if (ret)
+		return ret;
+
 	update_nvhe_init_params();
 
 	/* Jump in the idmap page to switch to the new page-tables */
-- 
2.39.0


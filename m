Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1844538AC6D
	for <kvmarm@lists.linux.dev>; Tue, 10 Mar 2026 12:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773146989; cv=none; b=WUcchAeLpgLifQeULh69zUXtTmOFxq0vHJn4Ylpd73U9j8PKCsIx6TtbYFU16TfdYdS5NbJiyPf/laux75fhncF9n3XG9LsLAbe8FCh4DNH6vYXBHyYqlT8wI05CSIBRBkGKbpYMFCh9Runfv0a3H419plnbIYJR/q+MKXS1I6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773146989; c=relaxed/simple;
	bh=14KappcwlVf4yuTAUqr072Clw0Dq8rqsTruC9Z7bLgk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=n1XNg8lfQd/yd6d0vUXCS2AcvOIxDBa6D13vNuJ80eKgvjwfxSy2iA49uIFce17HKB1qME/wcDdTbXmiTI44omGUUnBgMcz70Yrm0MpuneLOwfFh+zTZ9sTwp8BsMPUlKNpCDR30gXZXnlnFzCxVE6OvVmIUc0xtxiK85sejhRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=k4pJNVjI; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k4pJNVjI"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4836abfc742so107762225e9.0
        for <kvmarm@lists.linux.dev>; Tue, 10 Mar 2026 05:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773146987; x=1773751787; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=l6n5Y9iqY7rq1n5Q/lgdkU3SuBp6Rv+RQlbX0vgQT/A=;
        b=k4pJNVjInLdmlX716h59OIRHS8+PTIYZCvE70Pn4ujKHUGmRyz7bxve3IURSinQQGy
         +qho0DYb4IjfSRJTr4n8mtxfNMgvO1ldaExjMvJma8UIMVC56gCcaQl8JB1g84vnRPyc
         baAwBb71scg+yChvfvkpUCzntUPwKtSR08dUJsaZ7KMz36LCZ7sY+sgCcSC4xB1tczcQ
         c2gAE5c83Gq+SJgm076suSi+kSWCfkLnFQxkgwhVyFujBmaKIi62vJB9KRx8WZwDf8Yp
         v6TLNcK4jWTLz+nO3QrOyCloTWrG06nEmX1eazrXrXwIEFJ0JM5louAT2N2Y/gZH+tHM
         Tp8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773146987; x=1773751787;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l6n5Y9iqY7rq1n5Q/lgdkU3SuBp6Rv+RQlbX0vgQT/A=;
        b=DZkOnpynu4+WeCQo5TvnIYGUDowjh/kIS44Us8tWrU9q5YaXzvhgeMErnjJ/tLd0MD
         usEZ3QzBGotGn4HgiF0neihDmG+6ESTiodHy4h8yrBQABllmBgakmr7rShyddktnyvw6
         s2TyxOEgFTiwOyl3obJSzet6Zyai4Vxb8CY7StUwZ8ozg2jLKGBXoHW+cHE93ufjm0OJ
         f9xWsCtqaMaAy7vNHAuOTlQlI6WWfU5hKQf/qeAArXiJ5m3FAkzFS/CO8L1JlyeK+4/z
         4R5Vm/Thy4X+QnbtAsbtUz21MhxwDW53T9KtmbkuVM9+xAEsFddvFaYH1NRa4m+sipxU
         o7Sg==
X-Forwarded-Encrypted: i=1; AJvYcCWYeMB8+eVdCm3Rfb/HZZtpXv8ujEYK5f0LkVb1jrfruqv6ZNO9bVxcYXCqlBvsuSzKahJc7mI=@lists.linux.dev
X-Gm-Message-State: AOJu0YwSzH4+E0csPmscuGlA7vpWVeHnGhHcNVksoMQdbra8V516wCTz
	ITKL7/W5PoY1Kg32Tm0dYHz54PcidhNYCQmPwhGhKWhaDuYk157HnGlFX6EiKt5OHbxrctcGWiG
	4Df7Q31tlb2AfTFuTYb12MP4ElWMvtA==
X-Received: from wmby21.prod.google.com ([2002:a05:600c:c055:b0:485:343f:9fb3])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:138a:b0:477:7ae0:cd6e with SMTP id 5b1f17b1804b1-485269196ffmr271672925e9.5.1773146986648;
 Tue, 10 Mar 2026 05:49:46 -0700 (PDT)
Date: Tue, 10 Mar 2026 12:49:23 +0000
In-Reply-To: <20260310124933.830025-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260310124933.830025-1-sebastianene@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260310124933.830025-5-sebastianene@google.com>
Subject: [PATCH 04/14] KVM: arm64: Mediate host access to GIC/ITS MMIO via unmapping
From: Sebastian Ene <sebastianene@google.com>
To: alexandru.elisei@arm.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com
Cc: catalin.marinas@arm.com, dbrazdil@google.com, joey.gouly@arm.com, 
	kees@kernel.org, mark.rutland@arm.com, maz@kernel.org, oupton@kernel.org, 
	perlarsen@google.com, qperret@google.com, rananta@google.com, 
	sebastianene@google.com, smostafa@google.com, suzuki.poulose@arm.com, 
	tabba@google.com, tglx@kernel.org, vdonnefort@google.com, bgrzesik@google.com, 
	will@kernel.org, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Unmap the ITS MMIO region from the host address space to enforce
hypervisor mediation.
Identify the ITS base address from the device tree and store it in a
protected region. A callback is registered to handle host accesses to
this region; currently, the handler simply forwards all MMIO requests
to the physical hardware. This provides the infrastructure for future
hardware state validation without changing current behavior.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/include/asm/kvm_pkvm.h     |  2 ++
 arch/arm64/kvm/hyp/nvhe/Makefile      |  3 ++-
 arch/arm64/kvm/hyp/nvhe/its_emulate.c | 23 ++++++++++++++++
 arch/arm64/kvm/pkvm.c                 | 38 +++++++++++++++++++++++++++
 4 files changed, 65 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/kvm/hyp/nvhe/its_emulate.c

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 5321ced2f50a..ef00c1bf7d00 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -32,6 +32,8 @@ struct pkvm_protected_reg {
 
 extern struct pkvm_protected_reg kvm_nvhe_sym(pkvm_protected_regs)[];
 extern unsigned int kvm_nvhe_sym(num_protected_reg);
+extern void kvm_nvhe_sym(pkvm_handle_forward_req)(struct pkvm_protected_reg *region, u64 offset,
+						  bool write, u64 *reg, u8 reg_size);
 
 int pkvm_init_host_vm(struct kvm *kvm);
 int pkvm_create_hyp_vm(struct kvm *kvm);
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index a244ec25f8c5..eb43269fbac2 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -24,7 +24,8 @@ CFLAGS_switch.nvhe.o += -Wno-override-init
 
 hyp-obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
 	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o page_alloc.o \
-	 cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o stacktrace.o ffa.o
+	 cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o stacktrace.o ffa.o \
+	 its_emulate.o
 hyp-obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o
 hyp-obj-y += ../../../kernel/smccc-call.o
diff --git a/arch/arm64/kvm/hyp/nvhe/its_emulate.c b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
new file mode 100644
index 000000000000..0eecbb011898
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
@@ -0,0 +1,23 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <asm/kvm_pkvm.h>
+#include <nvhe/mem_protect.h>
+
+
+void pkvm_handle_forward_req(struct pkvm_protected_reg *region, u64 offset, bool write,
+			     u64 *reg, u8 reg_size)
+{
+	void __iomem *addr = __hyp_va((region->start_pfn << PAGE_SHIFT) + offset);
+
+	if (reg_size == sizeof(u32)) {
+		if (!write)
+			*reg = readl_relaxed(addr);
+		else
+			writel_relaxed(*reg, addr);
+	} else if (reg_size == sizeof(u64)) {
+		if (!write)
+			*reg = readq_relaxed(addr);
+		else
+			writeq_relaxed(*reg, addr);
+	}
+}
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index d7a0f69a9982..a766be6de735 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -11,6 +11,9 @@
 #include <asm/kvm_mmu.h>
 #include <linux/memblock.h>
 #include <linux/mutex.h>
+#include <linux/of_address.h>
+#include <linux/of_reserved_mem.h>
+#include <linux/platform_device.h>
 
 #include <asm/kvm_pkvm.h>
 
@@ -18,6 +21,7 @@
 
 DEFINE_STATIC_KEY_FALSE(kvm_protected_mode_initialized);
 
+static struct pkvm_protected_reg *pkvm_protected_regs = kvm_nvhe_sym(pkvm_protected_regs);
 static struct memblock_region *hyp_memory = kvm_nvhe_sym(hyp_memory);
 static unsigned int *hyp_memblock_nr_ptr = &kvm_nvhe_sym(hyp_memblock_nr);
 
@@ -39,6 +43,34 @@ static int __init register_memblock_regions(void)
 	return 0;
 }
 
+static int __init register_protected_regions(void)
+{
+	int i = 0, ret;
+	struct device_node *np;
+	struct resource res;
+
+	for_each_compatible_node(np, NULL, "arm,gic-v3-its") {
+		ret = of_address_to_resource(np, i, &res);
+		if (ret)
+			return ret;
+
+		if (i >= PKVM_PROTECTED_REGS_NUM)
+			return -ENOMEM;
+
+		if (!PAGE_ALIGNED(res.start) || !PAGE_ALIGNED(resource_size(&res)))
+			return -EINVAL;
+
+		pkvm_protected_regs[i].start_pfn = res.start >> PAGE_SHIFT;
+		pkvm_protected_regs[i].num_pages = resource_size(&res) >> PAGE_SHIFT;
+		pkvm_protected_regs[i].cb = lm_alias(&kvm_nvhe_sym(pkvm_handle_forward_req));
+		i++;
+	}
+
+	kvm_nvhe_sym(num_protected_reg) = i;
+
+	return 0;
+}
+
 void __init kvm_hyp_reserve(void)
 {
 	u64 hyp_mem_pages = 0;
@@ -57,6 +89,12 @@ void __init kvm_hyp_reserve(void)
 		return;
 	}
 
+	ret = register_protected_regions();
+	if (ret) {
+		kvm_err("Failed to register protected reg: %d\n", ret);
+		return;
+	}
+
 	hyp_mem_pages += hyp_s1_pgtable_pages();
 	hyp_mem_pages += host_s2_pgtable_pages();
 	hyp_mem_pages += hyp_vm_table_pages();
-- 
2.53.0.473.g4a7958ca14-goog


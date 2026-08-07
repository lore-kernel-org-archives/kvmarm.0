Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D564756C1
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 16:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786121028; cv=none; b=XhCXkZEL176NX+LIY+SaZRXHaWxa1ICtKZk5tHYhGPxhlcWlzkmRxG17tN3XdOPPLIzuH2v448h/pTgqJlw2chuA9z5L5+0bV3OlasilyaZ07fbvFY70pRkF17HJ6pPtT15oNro6GJmyG+YcStkUIlz22kHRdFyXqM6F9wtO83g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786121028; c=relaxed/simple;
	bh=XILxJKy12TWaQHFCLBTQsYLQR5jF/oISDfaILeGY1YQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=k4GQaww5MQ728t3qTcPjhTsc6H2NUCWNsiwtM3i4chYe+6Vx0eO/0jFDEa1jnm6bePDsLJZRXf6mDTCy0WhPQBsQ58U49uGI7WYdORtMecPMzrDxGVW9HFioiWxsg80kOISgt4pry+L3jgELrSGgTfL9s4ww+5fgjIldUIv/L5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TIr/tNyZ; arc=none smtp.client-ip=209.85.218.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TIr/tNyZ"
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c15ddb61f13so290347066b.0
        for <kvmarm@lists.linux.dev>; Fri, 07 Aug 2026 09:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786121024; x=1786725824; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ubeHaXbMbCOzTTinYD2VelpFhUrhVALfoKhm+KzrKis=;
        b=TIr/tNyZvFJkB7ieThxfGzvcn3D8FrHZchA7LvpWWK5LnvKy/RZQE+Zq+Huz4GjrXd
         aOWD2wYM3h4Xi1Ld5QIOKsIPxr2eqM0B8V1HhnQ7Qpz5AbJzpmja7knOtw5LuL/ct4XT
         AdVl2io/3UXBtVz9fqXXLCCWp64OaDrB7zkHMp9YNVgz3QzNUezJK9cWqBPRV4/gT+tc
         WDWeFnihYixNA5uNdNWUmMXfZ7hYjWF7yUzMvNZOsLXQLUZBL+ostuaCRudeZVkxQb70
         OHgZn/xEOo1dve1xAt0G+wPogssCjakSo1cSejDCdS/uG5k99Cfy7TDASUxzU9MptZc+
         p1IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786121024; x=1786725824;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ubeHaXbMbCOzTTinYD2VelpFhUrhVALfoKhm+KzrKis=;
        b=MzOjCHvbR1zdZ24W5iISxmMs1juE0hUJx/tZsdyneqwF7n7jQqJvGBV7K3uiUgYPj9
         vkD8NFsnYJN8dCWilrYvpl+6c8WTyM8o3jR/XLb82Y1vzp3Q5SZm0GFeoqw6xbQ+cieF
         u8d/oH2zOIf0vGXFJ9ix7i909c6610H5W9eGfDoiz5/qTn5WUo0RyhmKyGrnajSR8XOH
         KOgG3U6/Eg8e9PL+yoKgMauOq7uRSedZ+0+Ruwok7AfJ/Pmewi2KIZI4Iw3QgkOyJqfI
         XlMLuPGw/tbX1pAw4aaAxjaZDyz2rR79+4KVdc2WdzvCmgz4mI5UtY9T0rXTx4HG3UgY
         E3Pw==
X-Gm-Message-State: AOJu0YxYRJbznl99pcu7gHKW6Te4xUl25Ep7P99/dRsh4/OZBA2R9nzB
	P4p7oQRgNqNex17zcMmL764wP4LQncnpRbnygbnVrriaD6pWyk/nyhiE6efl6gFr4QQs/xn2VXL
	At1oBSDLEtaAyFk44HGkp0Wf5mK4vpA==
X-Received: from ejfv7.prod.google.com ([2002:a17:906:3bc7:b0:c12:8ea1:b062])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:1b24:b0:c12:8b1c:454f with SMTP id a640c23a62f3a-c2039c0264bmr1298937866b.2.1786121023739;
 Fri, 07 Aug 2026 09:43:43 -0700 (PDT)
Date: Fri,  7 Aug 2026 16:43:14 +0000
In-Reply-To: <20260807164322.2970811-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260807164322.2970811-2-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.654.g21b8a5bc05-goog
Message-ID: <20260807164322.2970811-6-sebastianene@google.com>
Subject: [PATCH v2 04/13] KVM: Parse the device tree and register the ITS
 region with pKVM
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, fuad.tabba@linux.dev, joey.gouly@arm.com, 
	mark.rutland@arm.com, maz@kernel.org, oupton@kernel.org, rananta@google.com, 
	Sascha.Bischoff@arm.com, suzuki.poulose@arm.com, will@kernel.org
Cc: kvmarm@lists.linux.dev, android-kvm@google.com, bgrzesik@google.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	nathan@kernel.org, perlarsen@google.com, sebastianene@google.com, 
	seiden@linux.ibm.com, smostafa@google.com, tglx@kernel.org, 
	vdonnefort@google.com, vladimir.murzin@arm.com, yuzenghui@huawei.com, 
	zenghui.yu@linux.dev
Content-Type: text/plain; charset="UTF-8"

Identify the ITS base address from the device tree and store it in the
pkvm_protected_regs array so that it will be unmapped from the host
address space.
Register a callback to forward all the MMIO requests to the device to
prevent breaking ITS functionality in this patch. The patch by itself
shouldn't break any existing functionality even though all the accesses
from the gic-ITS driver are now mediated inside pKVM.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/include/asm/kvm_pkvm.h     |  2 ++
 arch/arm64/kvm/hyp/nvhe/Makefile      |  3 +-
 arch/arm64/kvm/hyp/nvhe/its_emulate.c | 37 +++++++++++++++++++
 arch/arm64/kvm/pkvm.c                 | 52 +++++++++++++++++++++++++++
 4 files changed, 93 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/kvm/hyp/nvhe/its_emulate.c

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 0a471564be00..370225f0e72c 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -31,6 +31,8 @@ struct pkvm_protected_reg {
 
 extern struct pkvm_protected_reg kvm_nvhe_sym(pkvm_protected_regs)[];
 extern unsigned int kvm_nvhe_sym(num_protected_reg);
+extern void kvm_nvhe_sym(its_emulate_forward_req)(struct pkvm_protected_reg *region, u64 offset,
+						  bool write, u64 *reg, u8 reg_size);
 
 int pkvm_init_host_vm(struct kvm *kvm, unsigned long type);
 int pkvm_create_hyp_vm(struct kvm *kvm);
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index f57450ebcb49..70fbca325852 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -24,7 +24,8 @@ CFLAGS_switch.nvhe.o += -Wno-override-init
 
 hyp-obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
 	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o page_alloc.o \
-	 cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o stacktrace.o ffa.o
+	 cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o stacktrace.o ffa.o \
+	 its_emulate.o
 hyp-obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../hyp-entry.o ../exception.o ../pgtable.o ../vgic-v5-sr.o
 hyp-obj-y += ../../../kernel/smccc-call.o
diff --git a/arch/arm64/kvm/hyp/nvhe/its_emulate.c b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
new file mode 100644
index 000000000000..63a42f520ed2
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
@@ -0,0 +1,37 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <asm/kvm_pkvm.h>
+#include <nvhe/mem_protect.h>
+
+void its_emulate_forward_req(struct pkvm_protected_reg *region, u64 offset, bool write, u64 *reg,
+			     u8 reg_size)
+{
+	void __iomem *addr = __hyp_va(PFN_PHYS(region->pfn) + offset);
+
+	switch (reg_size) {
+	case 1:
+		if (!write)
+			*reg = readb_relaxed(addr);
+		else
+			writeb_relaxed(*reg, addr);
+		break;
+	case 2:
+		if (!write)
+			*reg = readw_relaxed(addr);
+		else
+			writew_relaxed(*reg, addr);
+		break;
+	case 4:
+		if (!write)
+			*reg = readl_relaxed(addr);
+		else
+			writel_relaxed(*reg, addr);
+		break;
+	case 8:
+		if (!write)
+			*reg = readq_relaxed(addr);
+		else
+			writeq_relaxed(*reg, addr);
+		break;
+	}
+}
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 428723b1b0f5..4bfffbedac4c 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -9,8 +9,13 @@
 #include <linux/kmemleak.h>
 #include <linux/kvm_host.h>
 #include <asm/kvm_mmu.h>
+#include <asm/kvm_pkvm.h>
 #include <linux/memblock.h>
 #include <linux/mutex.h>
+#include <linux/of_address.h>
+#include <linux/of_reserved_mem.h>
+#include <linux/platform_device.h>
+#include <linux/irqchip/arm-gic-v3.h>
 
 #include <asm/kvm_pkvm.h>
 
@@ -39,6 +44,47 @@ static int __init register_memblock_regions(void)
 	return 0;
 }
 
+static int __init register_its_emulated_region(void)
+{
+	struct device_node *np;
+	struct resource res;
+	int i = 0;
+	int ret;
+
+	for_each_compatible_node(np, NULL, "arm,gic-v3-its") {
+		ret = of_address_to_resource(np, 0, &res);
+		if (ret)
+			goto out_fail;
+
+		if (i >= PKVM_PROTECTED_REGS_NUM) {
+			kvm_err("Out of protected region slots\n");
+			ret = -ENOSPC;
+			goto out_fail;
+		}
+
+		/*
+		 * Note: don't unmap the entire animal from the host because devices need
+		 * to be able to access GITS_TRANSLATER to raise MSIs. If the
+		 * page where GITS_TRANSLATER is given to HYP, devices won't be
+		 * able to map it in their IOMMU when the IOMMU is managed by
+		 * pKVM.
+		 */
+		kvm_nvhe_sym(pkvm_protected_regs)[i].pfn = PHYS_PFN(res.start);
+		kvm_nvhe_sym(pkvm_protected_regs)[i].cb =
+			lm_alias(&kvm_nvhe_sym(its_emulate_forward_req));
+		kvm_nvhe_sym(pkvm_protected_regs)[i].nr_pages =
+			PFN_DOWN(min_t(u64, resource_size(&res), PAGE_ALIGN_DOWN(GITS_TRANSLATER)));
+
+		i++;
+	}
+
+	kvm_nvhe_sym(num_protected_reg) = i;
+	return 0;
+out_fail:
+	of_node_put(np);
+	return ret;
+}
+
 void __init kvm_hyp_reserve(void)
 {
 	u64 hyp_mem_pages = 0;
@@ -57,6 +103,12 @@ void __init kvm_hyp_reserve(void)
 		return;
 	}
 
+	ret = register_its_emulated_region();
+	if (ret) {
+		kvm_err("Failed to register ITS region %d\n", ret);
+		return;
+	}
+
 	hyp_mem_pages += hyp_s1_pgtable_pages();
 	hyp_mem_pages += host_s2_pgtable_pages();
 	hyp_mem_pages += hyp_vm_table_pages();
-- 
2.55.0.654.g21b8a5bc05-goog


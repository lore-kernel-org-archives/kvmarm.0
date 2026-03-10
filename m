Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EAA12D978B
	for <kvmarm@lists.linux.dev>; Tue, 10 Mar 2026 12:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773146988; cv=none; b=jSog8TrvqNXV6hoKFqrpMIoJQ/gCBh+GodlsRFlvOwnFhFckx7Q1m0EqFBqN9u3BZJTy8oKlzTqz5uzrTFl3xX4dCYDzrWadqkGbVIZYg++BM57wsfokOIAfwi0QiGvMx0SygjCDG8QnNkMUuRU93dGqaoDyXrnaf8bcSXRGw74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773146988; c=relaxed/simple;
	bh=da9sGRb1sXtZYbXldYQiInn/poIF06gS77aMtCUZDOs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iboMrnUt75+Ct4MiWgPAS7rlGs4fERHvNy2uGxFA0eHQaF1a+4KA7ise4XF12H3kcSMNK2EFdUPQAHLhXlj0UrvD49xu18aLDodOu1wflKr/fZofnABuqFIbTczQaOrWzI24PfR2BwWUb8gdQlRaG3B4IPbQs2M1NUN6wU02OA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=up4y4a2E; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="up4y4a2E"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-439b8858b0cso7514996f8f.0
        for <kvmarm@lists.linux.dev>; Tue, 10 Mar 2026 05:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773146986; x=1773751786; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ToBQfETgLJjiDxh0mdZ0jWyVKcLeeqGXYElZ0/3fbdc=;
        b=up4y4a2EC2RK5d7QrLU3uqEgUbGAjoNpy69hDG3bSdiurDOa515MGiBSs5hGYuvkGP
         7302dTJIxyI9Vo1NKyuTSwLFR5O/hzg19aOx0wxnsf1lmYh259njk2Yvuh2bJUbp9CJT
         Ttbdv/V+kMBI+HkqFY6QF60StCVoVSQZXW7DlL15VjgVSpASiM5AaXd+DflXFC/UTDFj
         8d8MDZQ3f3Zk8cxQg6lB1tbiSlfXRXiF6np0db43dRmSja5VE8IbrY5pAmRQPuPo4eUD
         h2TegLKg6quMJ9zSTok/OxpFjKHU4OpOrrtOVzEfBFHnYBMz15EZgI2AFcplDvXnqZoy
         +Ucw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773146986; x=1773751786;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ToBQfETgLJjiDxh0mdZ0jWyVKcLeeqGXYElZ0/3fbdc=;
        b=e6Ws+l1e7CRX75vTib8apI0Z81oeJPOju9knoPisgyIxNpMeKfuLvMTAny1mgl+1fV
         WOMAkzrMG/L6pb5FI7YCisgtTyUEzgbdoz9co+TpYZGn2o3aPA+ZWR+W+XQXtVawXG+2
         x3geYG7bbZBtFNghDoTRBNC4Hf+WV4QZ0FYRoLgAiEnYfi2mlG37CZAttftLaBLfNq9j
         H7PMtIxNj9iFiLRfS48rx86nd6CJ7RdGAchK2VJ2lij0QMFCt2KLLEV3Kzb2JmsY+G5F
         XOdS3A1gB8deJQhCXfybNE4TJ6sGKiVhPWhiTS+UTwnreCJT3jS3RTlqmUVH66Hb+dae
         JiLA==
X-Forwarded-Encrypted: i=1; AJvYcCUA6Roe8OVpCbzS+Bw9dVF/ucnM2qCFCFJJMVlbbFD6w+IFCTOKyGC5HLSpR2zenT+L3eMwZQc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz/SQSEXs0Pv2AR0pOjjL+n6Ep7p1Oqcrt42vA8WMKKNgmcSVl/
	vIt5NYfj2EaYsDtwA5xPaWYF7A7KAQg5lyfSvVPymPUxW4s0BOPXHS44RCVMSDPicMw009CSvne
	glMvMcEOvUDOUSC+sS+rFfDqvbfuqLQ==
X-Received: from wrdf12.prod.google.com ([2002:a5d:58ec:0:b0:439:b20b:f16a])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2285:b0:439:ba69:101d with SMTP id ffacd0b85a97d-439da354ccbmr25716640f8f.1.1773146985467;
 Tue, 10 Mar 2026 05:49:45 -0700 (PDT)
Date: Tue, 10 Mar 2026 12:49:22 +0000
In-Reply-To: <20260310124933.830025-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260310124933.830025-1-sebastianene@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260310124933.830025-4-sebastianene@google.com>
Subject: [PATCH 03/14] KVM: arm64: Support host MMIO trap handlers for
 unmapped devices
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

Introduce a mechanism to register callbacks for MMIO accesses to regions
unmapped from the host Stage-2 page tables.

This infrastructure allows the hypervisor to intercept host accesses to
protected or emulated devices. When a Stage-2 fault occurs on a
registered device region, the hypervisor will invoke the associated
callback to emulate the access.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/include/asm/kvm_arm.h      |  3 ++
 arch/arm64/include/asm/kvm_pkvm.h     |  6 ++++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 41 +++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/setup.c       |  3 ++
 4 files changed, 53 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 3f9233b5a130..8fe1e80ab3f4 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -304,6 +304,9 @@
 
 /* Hyp Prefetch Fault Address Register (HPFAR/HDFAR) */
 #define HPFAR_MASK	(~UL(0xf))
+
+#define FAR_MASK	GENMASK_ULL(11, 0)
+
 /*
  * We have
  *	PAR	[PA_Shift - 1	: 12] = PA	[PA_Shift - 1 : 12]
diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 48ec7d519399..5321ced2f50a 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -19,9 +19,15 @@
 
 #define PKVM_PROTECTED_REGS_NUM	8
 
+struct pkvm_protected_reg;
+
+typedef void (pkvm_emulate_handler)(struct pkvm_protected_reg *region, u64 offset, bool write,
+				    u64 *reg, u8 reg_size);
+
 struct pkvm_protected_reg {
 	u64 start_pfn;
 	size_t num_pages;
+	pkvm_emulate_handler *cb;
 };
 
 extern struct pkvm_protected_reg kvm_nvhe_sym(pkvm_protected_regs)[];
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 7c125836b533..f405d2fbd88f 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -13,6 +13,7 @@
 #include <asm/stage2_pgtable.h>
 
 #include <hyp/fault.h>
+#include <hyp/adjust_pc.h>
 
 #include <nvhe/gfp.h>
 #include <nvhe/memory.h>
@@ -608,6 +609,41 @@ static int host_stage2_idmap(u64 addr)
 	return ret;
 }
 
+static bool handle_host_mmio_trap(struct kvm_cpu_context *host_ctxt, u64 esr, u64 addr)
+{
+	u64 offset, reg_value = 0, start, end;
+	u8 reg_size, reg_index;
+	bool write;
+	int i;
+
+	for (i = 0; i < num_protected_reg; i++) {
+		start = pkvm_protected_regs[i].start_pfn << PAGE_SHIFT;
+		end = start + (pkvm_protected_regs[i].num_pages << PAGE_SHIFT);
+
+		if (start > addr || addr > end)
+			continue;
+
+		reg_size = BIT((esr & ESR_ELx_SAS) >> ESR_ELx_SAS_SHIFT);
+		reg_index = (esr & ESR_ELx_SRT_MASK) >> ESR_ELx_SRT_SHIFT;
+		write = (esr & ESR_ELx_WNR) == ESR_ELx_WNR;
+		offset = addr - start;
+
+		if (write)
+			reg_value = host_ctxt->regs.regs[reg_index];
+
+		pkvm_protected_regs[i].cb(&pkvm_protected_regs[i], offset, write,
+					  &reg_value, reg_size);
+
+		if (!write)
+			host_ctxt->regs.regs[reg_index] = reg_value;
+
+		kvm_skip_host_instr();
+		return true;
+	}
+
+	return false;
+}
+
 void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
 {
 	struct kvm_vcpu_fault_info fault;
@@ -630,6 +666,11 @@ void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
 	 */
 	BUG_ON(!(fault.hpfar_el2 & HPFAR_EL2_NS));
 	addr = FIELD_GET(HPFAR_EL2_FIPA, fault.hpfar_el2) << 12;
+	addr |= fault.far_el2 & FAR_MASK;
+
+	if (ESR_ELx_EC(esr) == ESR_ELx_EC_DABT_LOW && !addr_is_memory(addr) &&
+	    handle_host_mmio_trap(host_ctxt, esr, addr))
+		return;
 
 	ret = host_stage2_idmap(addr);
 	BUG_ON(ret && ret != -EAGAIN);
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index ad5b96085e1b..f91dfebe9980 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -296,6 +296,9 @@ static int unmap_protected_regions(void)
 			if (ret)
 				goto err_setup;
 		}
+
+		if (reg->cb)
+			reg->cb = kern_hyp_va(reg->cb);
 	}
 
 	return 0;
-- 
2.53.0.473.g4a7958ca14-goog


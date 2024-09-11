Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D451AB6CB
	for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 14:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726065487; cv=none; b=ZxkZFSpaXGu4I9cD5KWcki/DN3NjF4y+jS/ouHtij+LWntBxiAlUku7M2qLa8XwiVqXHZT3xYzwXgTLl0m6sV9JSyvbPyOwOGr+Gi+6rlbRs2POG92OuQWPN0QUfkZ9nKn/x6/N6lI1JDk6ufIS1/qeuUrK78poClZjSxyn2IS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726065487; c=relaxed/simple;
	bh=bcE5zfmXJa4poSgksIzijifRjEkiDBngz9LK8nPfx6g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LtdROhXaIqt/GYFih0AQoWUU8+lyJlBoA2qhSiCC4Rk5EgNjTuPt1z6M1nsfaOhdf67UOdSn2Qrjaz7gu7qLR/v6N9d4MQVxeEIwrL1tw7u9W+woLRTRaC38J6E0+TB57963CdXjg4bMnkOjwWCJUIkMB+I31ZObWoDPq5dACTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (1024-bit key) header.d=amazon.de header.i=@amazon.de header.b=gF2Df1yP; arc=none smtp.client-ip=99.78.197.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.de header.i=@amazon.de header.b="gF2Df1yP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1726065485; x=1757601485;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Hqkci3dj0GUqOn7J4NBabiUfpbZVZgBkN05sOca7hnY=;
  b=gF2Df1yPfZ7Th3kcqBzgCRzqU9NQ9p2PfOHxIUPRwjeRda/6lRFTIzqX
   2eyd40Vcq0n2XL1hzeJ/t5GCA9zBaqV5oedVhlPwrgEfQP5ny4xU6mScb
   NUFSXZsw+6A63f3wmAH7UtbSj55cBEda3TGjWSiJZQIVvgdGB6s4AB40B
   U=;
X-IronPort-AV: E=Sophos;i="6.10,220,1719878400"; 
   d="scan'208";a="329956973"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2024 14:38:05 +0000
Received: from EX19MTAEUC001.ant.amazon.com [10.0.17.79:41644]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.25.181:2525] with esmtp (Farcaster)
 id 4f621809-6571-476e-b300-f14101ba8a55; Wed, 11 Sep 2024 14:38:03 +0000 (UTC)
X-Farcaster-Flow-ID: 4f621809-6571-476e-b300-f14101ba8a55
Received: from EX19D007EUA001.ant.amazon.com (10.252.50.133) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 11 Sep 2024 14:38:00 +0000
Received: from EX19MTAUEC001.ant.amazon.com (10.252.135.222) by
 EX19D007EUA001.ant.amazon.com (10.252.50.133) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.35;
 Wed, 11 Sep 2024 14:37:59 +0000
Received: from dev-dsk-faresx-1b-27755bf1.eu-west-1.amazon.com (10.253.79.181)
 by mail-relay.amazon.com (10.252.135.200) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34
 via Frontend Transport; Wed, 11 Sep 2024 14:37:56 +0000
From: Fares Mehanna <faresx@amazon.de>
To: 
CC: <nh-open-source@amazon.com>, Fares Mehanna <faresx@amazon.de>, "Marc
 Zyngier" <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, James Morse
	<james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
	<yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, "Will
 Deacon" <will@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, =?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=
	<ptosi@google.com>, Ard Biesheuvel <ardb@kernel.org>, Mark Rutland
	<mark.rutland@arm.com>, Javier Martinez Canillas <javierm@redhat.com>, "Arnd
 Bergmann" <arnd@arndb.de>, Fuad Tabba <tabba@google.com>, Mark Brown
	<broonie@kernel.org>, Joey Gouly <joey.gouly@arm.com>, Kristina Martsenko
	<kristina.martsenko@arm.com>, Randy Dunlap <rdunlap@infradead.org>, "Bjorn
 Helgaas" <bhelgaas@google.com>, Jean-Philippe Brucker
	<jean-philippe@linaro.org>, "Mike Rapoport (IBM)" <rppt@kernel.org>, "David
 Hildenbrand" <david@redhat.com>, Roman Kagan <rkagan@amazon.de>, "moderated
 list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)"
	<linux-arm-kernel@lists.infradead.org>, "open list:KERNEL VIRTUAL MACHINE FOR
 ARM64 (KVM/arm64)" <kvmarm@lists.linux.dev>, open list
	<linux-kernel@vger.kernel.org>, "open list:MEMORY MANAGEMENT"
	<linux-mm@kvack.org>
Subject: [RFC PATCH 7/7] arm64: KVM: Allocate vCPU fp-regs dynamically on VHE and KERNEL_SECRETMEM enabled systems
Date: Wed, 11 Sep 2024 14:34:06 +0000
Message-ID: <20240911143421.85612-8-faresx@amazon.de>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240911143421.85612-1-faresx@amazon.de>
References: <20240911143421.85612-1-faresx@amazon.de>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Similar to what was done in this commit:
  "arm64: KVM: Allocate vCPU gp-regs dynamically on VHE and KERNEL_SECRETMEM enabled systems"

We're moving fp-regs to dynamic memory for systems supporting VHE and compiled
with KERNEL_SECRETMEM support. Otherwise, we will use the "fp_regs_storage"
struct embedded in the vCPU context.

Accessing fp-regs embedded in the vCPU context without de-reference is done as:
add     \regs, \ctxt, #offsetof(struct kvm_cpu_context, fp_regs_storage)

Accessing the dynamically allocated fp-regs with de-reference is done as:
ldr     \regs, [\ctxt, #offsetof(struct kvm_cpu_context, fp_regs)]

Signed-off-by: Fares Mehanna <faresx@amazon.de>
---
 arch/arm64/include/asm/kvm_host.h | 16 ++++++++++++++--
 arch/arm64/kernel/image-vars.h    |  1 +
 arch/arm64/kvm/arm.c              | 29 +++++++++++++++++++++++++++--
 arch/arm64/kvm/va_layout.c        | 23 +++++++++++++++++++----
 4 files changed, 61 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e8ed2c12479f..4132c57d7e69 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -550,7 +550,9 @@ struct kvm_cpu_context {
 	u64	spsr_irq;
 	u64	spsr_fiq;
 
-	struct user_fpsimd_state fp_regs;
+	struct user_fpsimd_state *fp_regs;
+	struct user_fpsimd_state fp_regs_storage;
+	struct secretmem_area *fp_regs_area;
 
 	u64 sys_regs[NR_SYS_REGS];
 
@@ -968,7 +970,17 @@ static __always_inline struct user_pt_regs *ctxt_gp_regs(const struct kvm_cpu_co
 	return regs;
 }
 #define vcpu_gp_regs(v)		(ctxt_gp_regs(&(v)->arch.ctxt))
-#define ctxt_fp_regs(ctxt)	(&(ctxt).fp_regs)
+
+static __always_inline struct user_fpsimd_state *ctxt_fp_regs(const struct kvm_cpu_context *ctxt)
+{
+	struct user_fpsimd_state *fp_regs = (void *) ctxt;
+	asm volatile(ALTERNATIVE_CB("add %0, %0, %1\n",
+				    ARM64_HAS_VIRT_HOST_EXTN,
+				    kvm_update_ctxt_fp_regs)
+		    : "+r" (fp_regs)
+		    : "I" (offsetof(struct kvm_cpu_context, fp_regs_storage)));
+	return fp_regs;
+}
 #define vcpu_fp_regs(v)		(ctxt_fp_regs(&(v)->arch.ctxt))
 
 /*
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index e3bb626e299c..904573598e0f 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -87,6 +87,7 @@ KVM_NVHE_ALIAS(kvm_update_va_mask);
 KVM_NVHE_ALIAS(kvm_get_kimage_voffset);
 KVM_NVHE_ALIAS(kvm_compute_final_ctr_el0);
 KVM_NVHE_ALIAS(kvm_update_ctxt_gp_regs);
+KVM_NVHE_ALIAS(kvm_update_ctxt_fp_regs);
 KVM_NVHE_ALIAS(spectre_bhb_patch_loop_iter);
 KVM_NVHE_ALIAS(spectre_bhb_patch_loop_mitigation_enable);
 KVM_NVHE_ALIAS(spectre_bhb_patch_wa3);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 7542af3f766a..17b42e9099c3 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -477,6 +477,14 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 		if (!vcpu->arch.ctxt.regs_area)
 			return -ENOMEM;
 		vcpu->arch.ctxt.regs = vcpu->arch.ctxt.regs_area->ptr;
+
+		pages_needed = (sizeof(*vcpu_fp_regs(vcpu)) + PAGE_SIZE - 1) / PAGE_SIZE;
+		vcpu->arch.ctxt.fp_regs_area = secretmem_allocate_pages(fls(pages_needed - 1));
+		if (!vcpu->arch.ctxt.fp_regs_area) {
+			err = -ENOMEM;
+			goto free_vcpu_ctxt;
+		}
+		vcpu->arch.ctxt.fp_regs = vcpu->arch.ctxt.fp_regs_area->ptr;
 	}
 
 	/* Set up the timer */
@@ -504,8 +512,10 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	return kvm_share_hyp(vcpu, vcpu + 1);
 
 free_vcpu_ctxt:
-	if (kvm_use_dynamic_regs())
+	if (kvm_use_dynamic_regs()) {
 		secretmem_release_pages(vcpu->arch.ctxt.regs_area);
+		secretmem_release_pages(vcpu->arch.ctxt.fp_regs_area);
+	}
 	return err;
 }
 
@@ -524,8 +534,10 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	kvm_vgic_vcpu_destroy(vcpu);
 	kvm_arm_vcpu_destroy(vcpu);
 
-	if (kvm_use_dynamic_regs())
+	if (kvm_use_dynamic_regs()) {
 		secretmem_release_pages(vcpu->arch.ctxt.regs_area);
+		secretmem_release_pages(vcpu->arch.ctxt.fp_regs_area);
+	}
 }
 
 void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
@@ -2729,12 +2741,25 @@ static int init_hyp_hve_mode(void)
 		per_cpu(kvm_host_data, cpu).host_ctxt.regs = kvm_host_data_regs;
 	}
 
+	/* Allocate fp-regs */
+	for_each_possible_cpu(cpu) {
+		void *kvm_host_data_regs;
+
+		kvm_host_data_regs = kzalloc(sizeof(struct user_fpsimd_state), GFP_KERNEL);
+		if (!kvm_host_data_regs) {
+			err = -ENOMEM;
+			goto free_regs;
+		}
+		per_cpu(kvm_host_data, cpu).host_ctxt.fp_regs = kvm_host_data_regs;
+	}
+
 	return 0;
 
 free_regs:
 	for_each_possible_cpu(cpu) {
 		kfree(per_cpu(kvm_hyp_ctxt, cpu).regs);
 		kfree(per_cpu(kvm_host_data, cpu).host_ctxt.regs);
+		kfree(per_cpu(kvm_host_data, cpu).host_ctxt.fp_regs);
 	}
 
 	return err;
diff --git a/arch/arm64/kvm/va_layout.c b/arch/arm64/kvm/va_layout.c
index fcef7e89d042..ba1030fa5b08 100644
--- a/arch/arm64/kvm/va_layout.c
+++ b/arch/arm64/kvm/va_layout.c
@@ -185,10 +185,12 @@ void __init kvm_update_va_mask(struct alt_instr *alt,
 	}
 }
 
-void __init kvm_update_ctxt_gp_regs(struct alt_instr *alt,
-				    __le32 *origptr, __le32 *updptr, int nr_inst)
+static __always_inline void __init kvm_update_ctxt_regs(struct alt_instr *alt,
+							__le32 *origptr,
+							__le32 *updptr,
+							int nr_inst, u32 imm)
 {
-	u32 rd, rn, imm, insn, oinsn;
+	u32 rd, rn, insn, oinsn;
 
 	BUG_ON(nr_inst != 1);
 
@@ -198,7 +200,6 @@ void __init kvm_update_ctxt_gp_regs(struct alt_instr *alt,
 	oinsn = le32_to_cpu(origptr[0]);
 	rd = aarch64_insn_decode_register(AARCH64_INSN_REGTYPE_RD, oinsn);
 	rn = aarch64_insn_decode_register(AARCH64_INSN_REGTYPE_RN, oinsn);
-	imm = offsetof(struct kvm_cpu_context, regs);
 
 	insn = aarch64_insn_gen_load_store_imm(rd, rn, imm,
 					       AARCH64_INSN_SIZE_64,
@@ -208,6 +209,20 @@ void __init kvm_update_ctxt_gp_regs(struct alt_instr *alt,
 	updptr[0] = cpu_to_le32(insn);
 }
 
+void __init kvm_update_ctxt_gp_regs(struct alt_instr *alt,
+				    __le32 *origptr, __le32 *updptr, int nr_inst)
+{
+	u32 offset = offsetof(struct kvm_cpu_context, regs);
+	kvm_update_ctxt_regs(alt, origptr, updptr, nr_inst, offset);
+}
+
+void __init kvm_update_ctxt_fp_regs(struct alt_instr *alt,
+				    __le32 *origptr, __le32 *updptr, int nr_inst)
+{
+	u32 offset = offsetof(struct kvm_cpu_context, fp_regs);
+	kvm_update_ctxt_regs(alt, origptr, updptr, nr_inst, offset);
+}
+
 void kvm_patch_vector_branch(struct alt_instr *alt,
 			     __le32 *origptr, __le32 *updptr, int nr_inst)
 {
-- 
2.40.1




Amazon Web Services Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


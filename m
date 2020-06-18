Return-Path: <SRS0=nOLV=77=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACDD8C433E0
	for <kvmarm@archiver.kernel.org>; Thu, 18 Jun 2020 12:26:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5F1C82085B
	for <kvmarm@archiver.kernel.org>; Thu, 18 Jun 2020 12:26:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="j6rqhLs+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5F1C82085B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 150154B172;
	Thu, 18 Jun 2020 08:26:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ueqt0dKMY8Uk; Thu, 18 Jun 2020 08:26:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 98C0F4B18E;
	Thu, 18 Jun 2020 08:26:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E9A244B172
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jun 2020 08:26:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HtSCAlLQvJCA for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Jun 2020 08:26:01 -0400 (EDT)
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com
 [209.85.128.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 629AB4B190
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jun 2020 08:26:00 -0400 (EDT)
Received: by mail-wm1-f66.google.com with SMTP id b82so5008190wmb.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jun 2020 05:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=SyJVc4e+GoUAEUncaRu7Abitq8XUwuB4SemkCGVL7hU=;
 b=j6rqhLs+9os6IUKzcc97SvmbzHvnm7iqekCNBV594Zz30SPAzzCrDgd66fUViZUI2O
 K8z74PXDmGJBAuIgnxkGg4mCcAmULENp3iY4u++w/w6LgKk9ZACdhRBzvItmpMrPQKF+
 R+/nF1ktCKfoT7htrA46PeHuWXPobMcsq7yu1TnjnM8f2rI+Qasb3LcxvkSwHbwQTsn3
 gKyDSsnPYr2uut1d01KbynGrj2nuWCBCFM/pK3RcJZxQv16IA4IQoySJVSG9PXxkksHe
 QbccuKwjmDkQcSY+6ZwqLpcDDD5yAsnzn6vXNg1M0Ch0YZ/IcuFacuxZ02lQ4Sw+QAwR
 4gSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=SyJVc4e+GoUAEUncaRu7Abitq8XUwuB4SemkCGVL7hU=;
 b=mU2ez6tPmLDfsPBsV/hmVJR5hU2VZyg//9dClryUBdbS5v4kobmHeEFN35wHGM5CRV
 nqQ2MZYj4HLUHc5OVdtPsEI6J/9+6EGqQh5zm38SgopRNtqxO0jJPN8FTCbMHVp35DqT
 UJrqwCRAQleTF+0ew23W2grUvmf4Z5ZxuJWOiCaUMivrTyMnxbvE4Nrd30iqXyPvTz6P
 Ft7bJOnZ/ZIrvpBK5PgCHaxxrZUUzCNM/RPkH3lR13dMfM6jsXGd6DC16Ehkbe0+xUMx
 s4LyBlQyy9DpvRnh/Pbu5fWTw5rSc0loJ75kNWgHeU0c8pB5qFLC82q1K1tjD6YM0oSK
 XIyg==
X-Gm-Message-State: AOAM531je5C9MsCI8PTVAkUT7U6cgEUzNc/VAZceaTgkhvPQbBbFBeaM
 303fq2cLf98Q0txM4F11Px8Ccw==
X-Google-Smtp-Source: ABdhPJxpr4HRSO92YDjrRYPnbc5L3TTKiVCvuPbkGpjbaCdfcJuGc2VlZl8Wnwp1JTVFdgXjnGyXRQ==
X-Received: by 2002:a1c:1fc2:: with SMTP id f185mr3791350wmf.4.1592483159389; 
 Thu, 18 Jun 2020 05:25:59 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:c1af:c724:158a:e200])
 by smtp.gmail.com with ESMTPSA id q13sm3400341wrn.84.2020.06.18.05.25.58
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 18 Jun 2020 05:25:58 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v3 06/15] arm64: kvm: Move hyp-init.S to nVHE
Date: Thu, 18 Jun 2020 13:25:28 +0100
Message-Id: <20200618122537.9625-7-dbrazdil@google.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200618122537.9625-1-dbrazdil@google.com>
References: <20200618122537.9625-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: android-kvm@google.com, linux-kernel@vger.kernel.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

From: Andrew Scull <ascull@google.com>

This patch is part of a series which builds KVM's non-VHE hyp code
separately from VHE and the rest of the kernel.

hyp-init.S contains the identity mapped initialisation code for the
non-VHE code that runs at EL2. It is only used for non-VHE.

Adjust code that calls into this to use the prefixed symbol name.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/include/asm/kvm_asm.h         | 4 +---
 arch/arm64/kernel/image-vars.h           | 3 ++-
 arch/arm64/kvm/Makefile                  | 2 +-
 arch/arm64/kvm/hyp/nvhe/Makefile         | 2 +-
 arch/arm64/kvm/{ => hyp/nvhe}/hyp-init.S | 0
 arch/arm64/kvm/mmu.c                     | 2 +-
 6 files changed, 6 insertions(+), 7 deletions(-)
 rename arch/arm64/kvm/{ => hyp/nvhe}/hyp-init.S (100%)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 2baa69324cc9..bab14b64c4fc 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -73,9 +73,7 @@
 struct kvm;
 struct kvm_vcpu;
 
-extern char __kvm_hyp_init[];
-extern char __kvm_hyp_init_end[];
-
+DECLARE_KVM_NVHE_SYM(__kvm_hyp_init);
 DECLARE_KVM_HYP_SYM(__kvm_hyp_vector);
 
 #ifdef CONFIG_KVM_INDIRECT_VECTORS
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index dc7ee85531f5..4dc969ccda9e 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -62,10 +62,10 @@ __efistub__ctype		= _ctype;
  */
 
 __kvm_nvhe___guest_exit = __guest_exit;
+__kvm_nvhe___hyp_stub_vectors = __hyp_stub_vectors;
 __kvm_nvhe___kvm_enable_ssbs = __kvm_enable_ssbs;
 __kvm_nvhe___kvm_flush_vm_context = __kvm_flush_vm_context;
 __kvm_nvhe___kvm_get_mdcr_el2 = __kvm_get_mdcr_el2;
-__kvm_nvhe___kvm_handle_stub_hvc = __kvm_handle_stub_hvc;
 __kvm_nvhe___kvm_timer_set_cntvoff = __kvm_timer_set_cntvoff;
 __kvm_nvhe___kvm_tlb_flush_local_vmid = __kvm_tlb_flush_local_vmid;
 __kvm_nvhe___kvm_tlb_flush_vmid = __kvm_tlb_flush_vmid;
@@ -82,6 +82,7 @@ __kvm_nvhe_abort_guest_exit_start = abort_guest_exit_start;
 __kvm_nvhe_arm64_enable_wa2_handling = arm64_enable_wa2_handling;
 __kvm_nvhe_arm64_ssbd_callback_required = arm64_ssbd_callback_required;
 __kvm_nvhe_hyp_panic = hyp_panic;
+__kvm_nvhe_idmap_t0sz = idmap_t0sz;
 __kvm_nvhe_kimage_voffset = kimage_voffset;
 __kvm_nvhe_kvm_host_data = kvm_host_data;
 __kvm_nvhe_kvm_patch_vector_branch = kvm_patch_vector_branch;
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 8d3d9513cbfe..152d8845a1a2 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -13,7 +13,7 @@ obj-$(CONFIG_KVM) += hyp/
 kvm-y := $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o \
 	 $(KVM)/vfio.o $(KVM)/irqchip.o \
 	 arm.o mmu.o mmio.o psci.o perf.o hypercalls.o pvtime.o \
-	 inject_fault.o regmap.o va_layout.o hyp.o hyp-init.o handle_exit.o \
+	 inject_fault.o regmap.o va_layout.o hyp.o handle_exit.o \
 	 guest.o debug.o reset.o sys_regs.o sys_regs_generic_v8.o \
 	 vgic-sys-reg-v3.o fpsimd.o pmu.o \
 	 aarch32.o arch_timer.o \
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index c68801e24950..fef6f1881765 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -7,7 +7,7 @@ asflags-y := -D__KVM_NVHE_HYPERVISOR__
 ccflags-y := -D__KVM_NVHE_HYPERVISOR__ -fno-stack-protector \
 	     -DDISABLE_BRANCH_PROFILING $(DISABLE_STACKLEAK_PLUGIN)
 
-obj-y := ../hyp-entry.o
+obj-y := hyp-init.o ../hyp-entry.o
 
 obj-y := $(patsubst %.o,%.hyp.o,$(obj-y))
 extra-y := $(patsubst %.hyp.o,%.hyp.tmp.o,$(obj-y))
diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
similarity index 100%
rename from arch/arm64/kvm/hyp-init.S
rename to arch/arm64/kvm/hyp/nvhe/hyp-init.S
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 8c0035cab6b6..592afe5e7003 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2346,7 +2346,7 @@ int kvm_mmu_init(void)
 	hyp_idmap_start = ALIGN_DOWN(hyp_idmap_start, PAGE_SIZE);
 	hyp_idmap_end = __pa_symbol(__hyp_idmap_text_end);
 	hyp_idmap_end = ALIGN(hyp_idmap_end, PAGE_SIZE);
-	hyp_idmap_vector = __pa_symbol(__kvm_hyp_init);
+	hyp_idmap_vector = __pa_symbol(kvm_nvhe_sym(__kvm_hyp_init));
 
 	/*
 	 * We rely on the linker script to ensure at build time that the HYP
-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

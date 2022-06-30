Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81270C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jun 2022 13:59:04 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 38C644B378;
	Thu, 30 Jun 2022 09:59:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uojZrdbu6-bp; Thu, 30 Jun 2022 09:59:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1227C4B496;
	Thu, 30 Jun 2022 09:59:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DA0D4B0C2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2022 09:59:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hTUKy5P1MUF8 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jun 2022 09:59:00 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B3FE441175
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2022 09:59:00 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id BE7FDB82AEF;
 Thu, 30 Jun 2022 13:58:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E616C34115;
 Thu, 30 Jun 2022 13:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1656597538;
 bh=ZveGRgYhfySF35odUPkFs+MNL1f3DyIjjBE7MoE4TyY=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=r+1n+DWBniNKsEpzWDzTdUKWl3EUJfZu7PvHRXt9V8WZDDGGsltKsc9x09zvhUb7O
 biqrgnBhO0oFce9EdmYiK3bjLqYwkdIAn1UaSFQFjcy5EFiJ7sQ4VzBlU9XnfK2N7V
 jA1flOAivVlcxxI1QQmOHMnDun2ooKzaPPZc56nLTFBPk3Ch1s9IxeRH+yUV/CxlQ+
 2+Co0Z54uTIIB7eAmQ/DwjJINyJFpcufqeBwINwsYHjD3PCECyJc6eZjTu2mpedJ/d
 xG9mub5UMR8D2FbwPKQJolcf3Kfs4SbBaDGJHUvNuHSo3wij8XPAC9GiWMyHMWofUy
 abYxdUbMFKDzA==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 16/24] KVM: arm64: Provide I-cache invalidation by VA at EL2
Date: Thu, 30 Jun 2022 14:57:39 +0100
Message-Id: <20220630135747.26983-17-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220630135747.26983-1-will@kernel.org>
References: <20220630135747.26983-1-will@kernel.org>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Andy Lutomirski <luto@amacapital.net>, linux-arm-kernel@lists.infradead.org,
 Michael Roth <michael.roth@amd.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Will Deacon <will@kernel.org>
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

In preparation for handling cache maintenance of guest pages at EL2,
introduce an EL2 copy of icache_inval_pou() which will later be plumbed
into the stage-2 page-table cache maintenance callbacks.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_hyp.h |  1 +
 arch/arm64/kernel/image-vars.h   |  3 ---
 arch/arm64/kvm/arm.c             |  1 +
 arch/arm64/kvm/hyp/nvhe/cache.S  | 11 +++++++++++
 arch/arm64/kvm/hyp/nvhe/pkvm.c   |  3 +++
 5 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index aa7fa2a08f06..fd99cf09972d 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -123,4 +123,5 @@ extern u64 kvm_nvhe_sym(id_aa64mmfr0_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64mmfr1_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64mmfr2_el1_sys_val);
 
+extern unsigned long kvm_nvhe_sym(__icache_flags);
 #endif /* __ARM64_KVM_HYP_H__ */
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 241c86b67d01..4e3b6d618ac1 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -80,9 +80,6 @@ KVM_NVHE_ALIAS(nvhe_hyp_panic_handler);
 /* Vectors installed by hyp-init on reset HVC. */
 KVM_NVHE_ALIAS(__hyp_stub_vectors);
 
-/* Kernel symbol used by icache_is_vpipt(). */
-KVM_NVHE_ALIAS(__icache_flags);
-
 /* VMID bits set by the KVM VMID allocator */
 KVM_NVHE_ALIAS(kvm_arm_vmid_bits);
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a2343640c73c..90e0e7f38bb5 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1901,6 +1901,7 @@ static void kvm_hyp_init_symbols(void)
 	kvm_nvhe_sym(id_aa64mmfr0_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
 	kvm_nvhe_sym(id_aa64mmfr1_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
 	kvm_nvhe_sym(id_aa64mmfr2_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64MMFR2_EL1);
+	kvm_nvhe_sym(__icache_flags) = __icache_flags;
 }
 
 static int kvm_hyp_init_protection(u32 hyp_va_bits)
diff --git a/arch/arm64/kvm/hyp/nvhe/cache.S b/arch/arm64/kvm/hyp/nvhe/cache.S
index 0c367eb5f4e2..85936c17ae40 100644
--- a/arch/arm64/kvm/hyp/nvhe/cache.S
+++ b/arch/arm64/kvm/hyp/nvhe/cache.S
@@ -12,3 +12,14 @@ SYM_FUNC_START(__pi_dcache_clean_inval_poc)
 	ret
 SYM_FUNC_END(__pi_dcache_clean_inval_poc)
 SYM_FUNC_ALIAS(dcache_clean_inval_poc, __pi_dcache_clean_inval_poc)
+
+SYM_FUNC_START(__pi_icache_inval_pou)
+alternative_if ARM64_HAS_CACHE_DIC
+	isb
+	ret
+alternative_else_nop_endif
+
+	invalidate_icache_by_line x0, x1, x2, x3
+	ret
+SYM_FUNC_END(__pi_icache_inval_pou)
+SYM_FUNC_ALIAS(icache_inval_pou, __pi_icache_inval_pou)
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 77aeb787670b..114c5565de7d 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -12,6 +12,9 @@
 #include <nvhe/pkvm.h>
 #include <nvhe/trap_handler.h>
 
+/* Used by icache_is_vpipt(). */
+unsigned long __icache_flags;
+
 /*
  * Set trap register values based on features in ID_AA64PFR0.
  */
-- 
2.37.0.rc0.161.g10f37bed90-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

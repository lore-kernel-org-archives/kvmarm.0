Return-Path: <SRS0=OpMx=BP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16DDCC433DF
	for <kvmarm@archiver.kernel.org>; Wed,  5 Aug 2020 18:27:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C3ED023104
	for <kvmarm@archiver.kernel.org>; Wed,  5 Aug 2020 18:27:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="1ZIQ9A6Z"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C3ED023104
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8085B4B67A;
	Wed,  5 Aug 2020 14:27:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id h5BXIwhKTciK; Wed,  5 Aug 2020 14:27:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9205C4B67E;
	Wed,  5 Aug 2020 14:27:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BC0E4B560
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Aug 2020 14:27:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id C3mzy21CCden for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Aug 2020 14:27:09 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9F8964B5AA
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Aug 2020 14:27:08 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id B9B1122EBD;
 Wed,  5 Aug 2020 18:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1596652027;
 bh=ObyvKEKZYF0tiHEd8xlZlpuDoXoetFaGeELOokvwPnI=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=1ZIQ9A6Z5GWe+s0AI3MT3ZNTVqe86F0LbwSnMiKqsd4adDMP6HDzaBaxghdqw4Ixl
 NSafYkv0M3WBbatU2i/pJeEGUxmGQtuOnlJyemqUsZCTJN0s7VO1pKVzTOa704QKQ2
 ywrcV8JJC5RoA1vRVAxFMD/bhdypDaVCUtB985Gc=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1k3Nfc-0004w9-2X; Wed, 05 Aug 2020 18:57:44 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 25/56] KVM: arm64: Compile remaining hyp/ files for both
 VHE/nVHE
Date: Wed,  5 Aug 2020 18:56:29 +0100
Message-Id: <20200805175700.62775-26-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200805175700.62775-1-maz@kernel.org>
References: <20200805175700.62775-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, graf@amazon.com,
 alexandru.elisei@arm.com, ascull@google.com, catalin.marinas@arm.com,
 christoffer.dall@arm.com, dbrazdil@google.com, eric.auger@redhat.com,
 gshan@redhat.com, james.morse@arm.com, mark.rutland@arm.com,
 richard.peng@oppo.com, qperret@google.com, will@kernel.org,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Peng Hao <richard.peng@oppo.com>, kernel-team@android.com,
 kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Alexander Graf <graf@amazon.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

From: David Brazdil <dbrazdil@google.com>

The following files in hyp/ contain only code shared by VHE/nVHE:
  vgic-v3-sr.c, aarch32.c, vgic-v2-cpuif-proxy.c, entry.S, fpsimd.S
Compile them under both configurations. Deletions in image-vars.h reflect
eliminated dependencies of nVHE code on the rest of the kernel.

Signed-off-by: David Brazdil <dbrazdil@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200625131420.71444-14-dbrazdil@google.com
---
 arch/arm64/kernel/image-vars.h   | 29 -----------------------------
 arch/arm64/kvm/hyp/Makefile      | 13 +------------
 arch/arm64/kvm/hyp/nvhe/Makefile |  5 +++--
 arch/arm64/kvm/hyp/vhe/Makefile  |  4 +++-
 4 files changed, 7 insertions(+), 44 deletions(-)

diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 2757d3512704..9e897c500237 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -63,35 +63,6 @@ __efistub__ctype		= _ctype;
 
 #define KVM_NVHE_ALIAS(sym) __kvm_nvhe_##sym = sym;
 
-/* Symbols defined in aarch32.c (not yet compiled with nVHE build rules). */
-KVM_NVHE_ALIAS(kvm_skip_instr32);
-
-/* Symbols defined in entry.S (not yet compiled with nVHE build rules). */
-KVM_NVHE_ALIAS(__guest_enter);
-KVM_NVHE_ALIAS(__guest_exit);
-KVM_NVHE_ALIAS(abort_guest_exit_end);
-KVM_NVHE_ALIAS(abort_guest_exit_start);
-
-/* Symbols defined in fpsimd.S (not yet compiled with nVHE build rules). */
-KVM_NVHE_ALIAS(__fpsimd_restore_state);
-KVM_NVHE_ALIAS(__fpsimd_save_state);
-
-/* Symbols defined in vgic-v2-cpuif-proxy.c (not yet compiled with nVHE build rules). */
-KVM_NVHE_ALIAS(__vgic_v2_perform_cpuif_access);
-
-/* Symbols defined in vgic-v3-sr.c (not yet compiled with nVHE build rules). */
-KVM_NVHE_ALIAS(__vgic_v3_activate_traps);
-KVM_NVHE_ALIAS(__vgic_v3_deactivate_traps);
-KVM_NVHE_ALIAS(__vgic_v3_get_ich_vtr_el2);
-KVM_NVHE_ALIAS(__vgic_v3_init_lrs);
-KVM_NVHE_ALIAS(__vgic_v3_perform_cpuif_access);
-KVM_NVHE_ALIAS(__vgic_v3_read_vmcr);
-KVM_NVHE_ALIAS(__vgic_v3_restore_aprs);
-KVM_NVHE_ALIAS(__vgic_v3_restore_state);
-KVM_NVHE_ALIAS(__vgic_v3_save_aprs);
-KVM_NVHE_ALIAS(__vgic_v3_save_state);
-KVM_NVHE_ALIAS(__vgic_v3_write_vmcr);
-
 /* Alternative callbacks for init-time patching of nVHE hyp code. */
 KVM_NVHE_ALIAS(arm64_enable_wa2_handling);
 KVM_NVHE_ALIAS(kvm_patch_vector_branch);
diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
index ef1aa7fe8f5a..f54f0e89a71c 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -10,16 +10,5 @@ subdir-ccflags-y := -I$(incdir)				\
 		    -DDISABLE_BRANCH_PROFILING		\
 		    $(DISABLE_STACKLEAK_PLUGIN)
 
-obj-$(CONFIG_KVM) += hyp.o vhe/ nvhe/
+obj-$(CONFIG_KVM) += vhe/ nvhe/
 obj-$(CONFIG_KVM_INDIRECT_VECTORS) += smccc_wa.o
-
-hyp-y := vgic-v3-sr.o aarch32.o vgic-v2-cpuif-proxy.o entry.o \
-	 fpsimd.o
-
-# KVM code is run at a different exception code with a different map, so
-# compiler instrumentation that inserts callbacks or checks into the code may
-# cause crashes. Just disable it.
-GCOV_PROFILE	:= n
-KASAN_SANITIZE	:= n
-UBSAN_SANITIZE	:= n
-KCOV_INSTRUMENT	:= n
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 0f4c544f07db..ad8729f5e814 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -6,8 +6,9 @@
 asflags-y := -D__KVM_NVHE_HYPERVISOR__
 ccflags-y := -D__KVM_NVHE_HYPERVISOR__
 
-obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o \
-	 ../hyp-entry.o
+obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o
+obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
+	 ../fpsimd.o ../hyp-entry.o
 
 obj-y := $(patsubst %.o,%.hyp.o,$(obj-y))
 extra-y := $(patsubst %.hyp.o,%.hyp.tmp.o,$(obj-y))
diff --git a/arch/arm64/kvm/hyp/vhe/Makefile b/arch/arm64/kvm/hyp/vhe/Makefile
index a1dbbc5409bd..090fd1e14be2 100644
--- a/arch/arm64/kvm/hyp/vhe/Makefile
+++ b/arch/arm64/kvm/hyp/vhe/Makefile
@@ -6,7 +6,9 @@
 asflags-y := -D__KVM_VHE_HYPERVISOR__
 ccflags-y := -D__KVM_VHE_HYPERVISOR__
 
-obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o ../hyp-entry.o
+obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o
+obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
+	 ../fpsimd.o ../hyp-entry.o
 
 # KVM code is run at a different exception code with a different map, so
 # compiler instrumentation that inserts callbacks or checks into the code may
-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

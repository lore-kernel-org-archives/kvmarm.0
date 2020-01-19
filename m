Return-Path: <SRS0=D0fm=3I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4F1EC33CB1
	for <kvmarm@archiver.kernel.org>; Sun, 19 Jan 2020 18:11:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6175620679
	for <kvmarm@archiver.kernel.org>; Sun, 19 Jan 2020 18:11:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="2sxAUSdL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6175620679
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A86B4AEB2;
	Sun, 19 Jan 2020 13:11:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZQSY3p535mG6; Sun, 19 Jan 2020 13:11:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A63A4AE92;
	Sun, 19 Jan 2020 13:11:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6AF5B4ACFA
 for <kvmarm@lists.cs.columbia.edu>; Sun, 19 Jan 2020 13:11:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YcabrqZluJ3T for <kvmarm@lists.cs.columbia.edu>;
 Sun, 19 Jan 2020 13:11:29 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B7A3B4ACF5
 for <kvmarm@lists.cs.columbia.edu>; Sun, 19 Jan 2020 13:11:29 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 8578920679;
 Sun, 19 Jan 2020 18:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1579457488;
 bh=YPUa4t1yHP+68PMUXQz60+tcZLNJOSQXuWd7TftDZdQ=;
 h=From:To:Cc:Subject:Date:From;
 b=2sxAUSdLdA7kZbuj+BmeD+72LFe1YbOBVMCoYfHHShizYSXpi3S0709VOSRlaENf5
 jyT3D4IwGiLG7wxWUHOUhEbWoHdhSfASVYBPj1MT79JqXrgAjJVEodQb7Gi+7RgoFc
 jG82ZgIxBW76n4ykUoHEspo4pi4pOR2FJlJcFAaw=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1itF2k-0004L8-O5; Sun, 19 Jan 2020 18:11:26 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH] KVM: arm/arm64: Cleanup MMIO handling
Date: Sun, 19 Jan 2020 18:11:16 +0000
Message-Id: <20200119181116.374-1-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, Christoffer.Dall@arm.com, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
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

Our MMIO handling is a bit odd, in the sense that it uses an
intermediate per-vcpu structure to store the various decoded
information that describe the access.

But the same information is readily available in the HSR/ESR_EL2
field, and we actually use this field to populate the structure.

Let's simplify the whole thing by getting rid of the superfluous
structure and save a (tiny) bit of space in the vcpu structure.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm/include/asm/kvm_emulate.h   |  5 +-
 arch/arm/include/asm/kvm_host.h      |  9 +++-
 arch/arm/include/asm/kvm_mmio.h      | 28 -----------
 arch/arm64/include/asm/kvm_emulate.h |  3 +-
 arch/arm64/include/asm/kvm_host.h    | 12 +++--
 arch/arm64/include/asm/kvm_mmio.h    | 27 -----------
 virt/kvm/arm/mmio.c                  | 70 +++++++++-------------------
 virt/kvm/arm/mmu.c                   |  1 -
 8 files changed, 41 insertions(+), 114 deletions(-)
 delete mode 100644 arch/arm/include/asm/kvm_mmio.h
 delete mode 100644 arch/arm64/include/asm/kvm_mmio.h

diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
index 08d9805f613b..3944305e81df 100644
--- a/arch/arm/include/asm/kvm_emulate.h
+++ b/arch/arm/include/asm/kvm_emulate.h
@@ -9,7 +9,6 @@
 
 #include <linux/kvm_host.h>
 #include <asm/kvm_asm.h>
-#include <asm/kvm_mmio.h>
 #include <asm/kvm_arm.h>
 #include <asm/cputype.h>
 
@@ -220,7 +219,7 @@ static inline bool kvm_vcpu_dabt_is_cm(struct kvm_vcpu *vcpu)
 }
 
 /* Get Access Size from a data abort */
-static inline int kvm_vcpu_dabt_get_as(struct kvm_vcpu *vcpu)
+static inline unsigned int kvm_vcpu_dabt_get_as(struct kvm_vcpu *vcpu)
 {
 	switch ((kvm_vcpu_get_hsr(vcpu) >> 22) & 0x3) {
 	case 0:
@@ -231,7 +230,7 @@ static inline int kvm_vcpu_dabt_get_as(struct kvm_vcpu *vcpu)
 		return 4;
 	default:
 		kvm_err("Hardware is weird: SAS 0b11 is reserved\n");
-		return -EFAULT;
+		return 4;
 	}
 }
 
diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 556cd818eccf..acf4c87e8321 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -14,7 +14,6 @@
 #include <asm/cputype.h>
 #include <asm/kvm.h>
 #include <asm/kvm_asm.h>
-#include <asm/kvm_mmio.h>
 #include <asm/fpstate.h>
 #include <kvm/arm_arch_timer.h>
 
@@ -300,6 +299,14 @@ int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 static inline void handle_exit_early(struct kvm_vcpu *vcpu, struct kvm_run *run,
 				     int exception_index) {}
 
+/* MMIO helpers */
+void kvm_mmio_write_buf(void *buf, unsigned int len, unsigned long data);
+unsigned long kvm_mmio_read_buf(const void *buf, unsigned int len);
+
+int kvm_handle_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run);
+int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
+		 phys_addr_t fault_ipa);
+
 static inline void __cpu_init_hyp_mode(phys_addr_t pgd_ptr,
 				       unsigned long hyp_stack_ptr,
 				       unsigned long vector_ptr)
diff --git a/arch/arm/include/asm/kvm_mmio.h b/arch/arm/include/asm/kvm_mmio.h
deleted file mode 100644
index 32fbf82e3ebc..000000000000
--- a/arch/arm/include/asm/kvm_mmio.h
+++ /dev/null
@@ -1,28 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * Copyright (C) 2012 - Virtual Open Systems and Columbia University
- * Author: Christoffer Dall <c.dall@virtualopensystems.com>
- */
-
-#ifndef __ARM_KVM_MMIO_H__
-#define __ARM_KVM_MMIO_H__
-
-#include <linux/kvm_host.h>
-#include <asm/kvm_asm.h>
-#include <asm/kvm_arm.h>
-
-struct kvm_decode {
-	unsigned long rt;
-	bool sign_extend;
-	/* Not used on 32-bit arm */
-	bool sixty_four;
-};
-
-void kvm_mmio_write_buf(void *buf, unsigned int len, unsigned long data);
-unsigned long kvm_mmio_read_buf(const void *buf, unsigned int len);
-
-int kvm_handle_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run);
-int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
-		 phys_addr_t fault_ipa);
-
-#endif	/* __ARM_KVM_MMIO_H__ */
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 53ea7637b7b2..688c63412cc2 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -17,7 +17,6 @@
 #include <asm/esr.h>
 #include <asm/kvm_arm.h>
 #include <asm/kvm_hyp.h>
-#include <asm/kvm_mmio.h>
 #include <asm/ptrace.h>
 #include <asm/cputype.h>
 #include <asm/virt.h>
@@ -341,7 +340,7 @@ static inline bool kvm_vcpu_dabt_is_cm(const struct kvm_vcpu *vcpu)
 	return !!(kvm_vcpu_get_hsr(vcpu) & ESR_ELx_CM);
 }
 
-static inline int kvm_vcpu_dabt_get_as(const struct kvm_vcpu *vcpu)
+static inline unsigned int kvm_vcpu_dabt_get_as(const struct kvm_vcpu *vcpu)
 {
 	return 1 << ((kvm_vcpu_get_hsr(vcpu) & ESR_ELx_SAS) >> ESR_ELx_SAS_SHIFT);
 }
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index c61260cf63c5..f6a77ddab956 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -24,7 +24,6 @@
 #include <asm/fpsimd.h>
 #include <asm/kvm.h>
 #include <asm/kvm_asm.h>
-#include <asm/kvm_mmio.h>
 #include <asm/thread_info.h>
 
 #define __KVM_HAVE_ARCH_INTC_INITIALIZED
@@ -325,9 +324,6 @@ struct kvm_vcpu_arch {
 	/* Don't run the guest (internal implementation need) */
 	bool pause;
 
-	/* IO related fields */
-	struct kvm_decode mmio_decode;
-
 	/* Cache some mmu pages needed inside spinlock regions */
 	struct kvm_mmu_memory_cache mmu_page_cache;
 
@@ -491,6 +487,14 @@ int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 void handle_exit_early(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		       int exception_index);
 
+/* MMIO helpers */
+void kvm_mmio_write_buf(void *buf, unsigned int len, unsigned long data);
+unsigned long kvm_mmio_read_buf(const void *buf, unsigned int len);
+
+int kvm_handle_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run);
+int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
+		 phys_addr_t fault_ipa);
+
 int kvm_perf_init(void);
 int kvm_perf_teardown(void);
 
diff --git a/arch/arm64/include/asm/kvm_mmio.h b/arch/arm64/include/asm/kvm_mmio.h
deleted file mode 100644
index b204501a0c39..000000000000
--- a/arch/arm64/include/asm/kvm_mmio.h
+++ /dev/null
@@ -1,27 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * Copyright (C) 2012 - Virtual Open Systems and Columbia University
- * Author: Christoffer Dall <c.dall@virtualopensystems.com>
- */
-
-#ifndef __ARM64_KVM_MMIO_H__
-#define __ARM64_KVM_MMIO_H__
-
-#include <linux/kvm_host.h>
-#include <asm/kvm_arm.h>
-
-struct kvm_decode {
-	unsigned long rt;
-	bool sign_extend;
-	/* Witdth of the register accessed by the faulting instruction is 64-bits */
-	bool sixty_four;
-};
-
-void kvm_mmio_write_buf(void *buf, unsigned int len, unsigned long data);
-unsigned long kvm_mmio_read_buf(const void *buf, unsigned int len);
-
-int kvm_handle_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run);
-int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
-		 phys_addr_t fault_ipa);
-
-#endif	/* __ARM64_KVM_MMIO_H__ */
diff --git a/virt/kvm/arm/mmio.c b/virt/kvm/arm/mmio.c
index 1bb71acd53f2..aedfcff99ac5 100644
--- a/virt/kvm/arm/mmio.c
+++ b/virt/kvm/arm/mmio.c
@@ -5,7 +5,6 @@
  */
 
 #include <linux/kvm_host.h>
-#include <asm/kvm_mmio.h>
 #include <asm/kvm_emulate.h>
 #include <trace/events/kvm.h>
 
@@ -92,26 +91,23 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 	vcpu->mmio_needed = 0;
 
-	if (!run->mmio.is_write) {
-		len = run->mmio.len;
-		if (len > sizeof(unsigned long))
-			return -EINVAL;
-
+	if (!kvm_vcpu_dabt_iswrite(vcpu)) {
+		len = kvm_vcpu_dabt_get_as(vcpu);
 		data = kvm_mmio_read_buf(run->mmio.data, len);
 
-		if (vcpu->arch.mmio_decode.sign_extend &&
+		if (kvm_vcpu_dabt_issext(vcpu) &&
 		    len < sizeof(unsigned long)) {
 			mask = 1U << ((len * 8) - 1);
 			data = (data ^ mask) - mask;
 		}
 
-		if (!vcpu->arch.mmio_decode.sixty_four)
+		if (!kvm_vcpu_dabt_issf(vcpu))
 			data = data & 0xffffffff;
 
 		trace_kvm_mmio(KVM_TRACE_MMIO_READ, len, run->mmio.phys_addr,
 			       &data);
 		data = vcpu_data_host_to_guest(vcpu, data, len);
-		vcpu_set_reg(vcpu, vcpu->arch.mmio_decode.rt, data);
+		vcpu_set_reg(vcpu, kvm_vcpu_dabt_get_rd(vcpu), data);
 	}
 
 	/*
@@ -123,36 +119,6 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	return 0;
 }
 
-static int decode_hsr(struct kvm_vcpu *vcpu, bool *is_write, int *len)
-{
-	unsigned long rt;
-	int access_size;
-	bool sign_extend;
-	bool sixty_four;
-
-	if (kvm_vcpu_dabt_iss1tw(vcpu)) {
-		/* page table accesses IO mem: tell guest to fix its TTBR */
-		kvm_inject_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
-		return 1;
-	}
-
-	access_size = kvm_vcpu_dabt_get_as(vcpu);
-	if (unlikely(access_size < 0))
-		return access_size;
-
-	*is_write = kvm_vcpu_dabt_iswrite(vcpu);
-	sign_extend = kvm_vcpu_dabt_issext(vcpu);
-	sixty_four = kvm_vcpu_dabt_issf(vcpu);
-	rt = kvm_vcpu_dabt_get_rd(vcpu);
-
-	*len = access_size;
-	vcpu->arch.mmio_decode.sign_extend = sign_extend;
-	vcpu->arch.mmio_decode.rt = rt;
-	vcpu->arch.mmio_decode.sixty_four = sixty_four;
-
-	return 0;
-}
-
 int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		 phys_addr_t fault_ipa)
 {
@@ -164,15 +130,10 @@ int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	u8 data_buf[8];
 
 	/*
-	 * Prepare MMIO operation. First decode the syndrome data we get
-	 * from the CPU. Then try if some in-kernel emulation feels
-	 * responsible, otherwise let user space do its magic.
+	 * No valid syndrome? Ask userspace for help if it has
+	 * voluntered to do so, and bail out otherwise.
 	 */
-	if (kvm_vcpu_dabt_isvalid(vcpu)) {
-		ret = decode_hsr(vcpu, &is_write, &len);
-		if (ret)
-			return ret;
-	} else {
+	if (!kvm_vcpu_dabt_isvalid(vcpu)) {
 		if (vcpu->kvm->arch.return_nisv_io_abort_to_user) {
 			run->exit_reason = KVM_EXIT_ARM_NISV;
 			run->arm_nisv.esr_iss = kvm_vcpu_dabt_iss_nisv_sanitized(vcpu);
@@ -184,7 +145,20 @@ int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		return -ENOSYS;
 	}
 
-	rt = vcpu->arch.mmio_decode.rt;
+	/* Page table accesses IO mem: tell guest to fix its TTBR */
+	if (kvm_vcpu_dabt_iss1tw(vcpu)) {
+		kvm_inject_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
+		return 1;
+	}
+
+	/*
+	 * Prepare MMIO operation. First decode the syndrome data we get
+	 * from the CPU. Then try if some in-kernel emulation feels
+	 * responsible, otherwise let user space do its magic.
+	 */
+	is_write = kvm_vcpu_dabt_iswrite(vcpu);
+	len = kvm_vcpu_dabt_get_as(vcpu);
+	rt = kvm_vcpu_dabt_get_rd(vcpu);
 
 	if (is_write) {
 		data = vcpu_data_guest_to_host(vcpu, vcpu_get_reg(vcpu, rt),
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index e3ad95013192..a4fa81d75e84 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -14,7 +14,6 @@
 #include <asm/cacheflush.h>
 #include <asm/kvm_arm.h>
 #include <asm/kvm_mmu.h>
-#include <asm/kvm_mmio.h>
 #include <asm/kvm_ras.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

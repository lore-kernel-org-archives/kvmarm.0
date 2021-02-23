Return-Path: <SRS0=rfx0=HZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2249C433DB
	for <kvmarm@archiver.kernel.org>; Tue, 23 Feb 2021 09:49:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 62AB764E5C
	for <kvmarm@archiver.kernel.org>; Tue, 23 Feb 2021 09:49:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 62AB764E5C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E9CC24B1F0;
	Tue, 23 Feb 2021 04:49:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aMKrFoWDwpKF; Tue, 23 Feb 2021 04:49:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C87494B1EB;
	Tue, 23 Feb 2021 04:49:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 59CFC4B1C0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Feb 2021 04:49:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id d8dslYJwEsEA for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Feb 2021 04:49:39 -0500 (EST)
Received: from mail-qk1-f201.google.com (mail-qk1-f201.google.com
 [209.85.222.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4C5134B1B1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Feb 2021 04:49:39 -0500 (EST)
Received: by mail-qk1-f201.google.com with SMTP id k2so6800711qkh.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Feb 2021 01:49:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=7C3tkJ6qIqYWp/7tEC4IjuJsnJ0m8o0qtdgiU4uDjW4=;
 b=JTe4QRC6SezgQLyxeZsVXcnipeAHg9rDiU2TqvUWkCdwzBIT2fB1+Jc39ZDc3HsQuy
 UqeAz7JIcmF45TO2EWrgqvZAvBw0iXAQsQHpVh/dlWSdNwXzx53M6du62CpNY6Mj4PGA
 XaznytJCUXBm4M1LCZRrH7qNk15H8KcKPlYQX7FOe7jhRv0Dm2zDSstRK+2HqB0KD0xr
 ISveSk+YilRqPOVs7Bdu3zDUWmdy1zl6Jgg2z5ac0jZ3TJ33quGrQkkWQL+itspeKUu/
 CcliShFUCAQ1Gi+bC0ZukIkOWDFyr7n7xVrDDfLhSAXuKfyPyxyIKaWiZgjQaeikth4V
 LgZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=7C3tkJ6qIqYWp/7tEC4IjuJsnJ0m8o0qtdgiU4uDjW4=;
 b=bjL7AnbG/4LK/H+knpiZ7tp9wyYj8t287M/GFVieowe46ZefOYqCZDALXFJfbj0AI3
 8fIuD8zYvUSWVX3zhXLGYJU22v5PAHYXFKcJuSbEDU6JL09fShqflMPf66k3SDs1FOkZ
 nbry1lxowJ/O6etrjhddTeUOMXKwyQOMLFU6lOip6D9Jg2e735QzkJQB3aG4Ia+KiwtR
 KpeK4i3aVjMibu1T73eWe6uyDIjsMiSUfiPlZ7zKCUD7tVtpr4b5WHJ5ky18WfOppvcF
 EsSmqJ8T3eJn44vC69fv0TJx01K4dFYnoI+VN3oukd1K4Lq+DJe5BdwGn1S1sfQIQETI
 M/lg==
X-Gm-Message-State: AOAM5323vaIPRh0PEbPIUxSkvj0QZ7P8LkFKFDGVvYxEHzOoMkQDNJlb
 D7wvCLfLNOk1xElvaCdvuHpQ2xrAnuwrHvUYgFgNjkPDItB731kPmPBiB+iiLzcwfVoRXtD4ol/
 qtgo7kf0ogT6htOjSM+ekf2mWLNsMRLP7YiJG0IW0K+q2AZ/7w3Z57pDF4Kro5XVQYiuayQ==
X-Google-Smtp-Source: ABdhPJwS3l/WQ8RayqR/FhY+tz3XrtHvICnsGPJqNcrlJC76DKh9cuzaL7MGO1fKFBdHbtg4+sIX3TFLbUw=
X-Received: from ascull.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1510])
 (user=ascull job=sendgmr) by 2002:ad4:4e10:: with SMTP id
 dl16mr5331793qvb.10.1614073778725; 
 Tue, 23 Feb 2021 01:49:38 -0800 (PST)
Date: Tue, 23 Feb 2021 09:49:27 +0000
In-Reply-To: <20210223094927.766572-1-ascull@google.com>
Message-Id: <20210223094927.766572-3-ascull@google.com>
Mime-Version: 1.0
References: <20210223094927.766572-1-ascull@google.com>
X-Mailer: git-send-email 2.30.0.617.g56c4b15f3c-goog
Subject: [PATCH 2/2] KVM: arm64: Log source when panicking from nVHE hyp
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, maz@kernel.org, catalin.marinas@arm.com,
 will@kernel.org
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

To aid with debugging, add details of the source of a panic. This is
done by having nVHE hyp exit to nvhe_hyp_panic_handler() rather than
directly to panic(). The handler will then add the extra details for
debugging before panicking the kernel.

If the panic was due to a BUG(), look up the metadata to log the file
and line, if available, otherwise log the kimg address that can be
looked up in vmlinux.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/include/asm/kvm_mmu.h        |  2 ++
 arch/arm64/kernel/image-vars.h          |  3 +-
 arch/arm64/kvm/handle_exit.c            | 38 +++++++++++++++++++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h |  2 --
 arch/arm64/kvm/hyp/nvhe/host.S          | 18 ++++++------
 arch/arm64/kvm/hyp/nvhe/psci-relay.c    |  2 --
 6 files changed, 49 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index e52d82aeadca..f07c55f9dd1e 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -130,6 +130,8 @@ void kvm_update_va_mask(struct alt_instr *alt,
 			__le32 *origptr, __le32 *updptr, int nr_inst);
 void kvm_compute_layout(void);
 
+#define __hyp_pa(x) ((phys_addr_t)((x)) + hyp_physvirt_offset)
+
 static __always_inline unsigned long __kern_hyp_va(unsigned long v)
 {
 	asm volatile(ALTERNATIVE_CB("and %0, %0, #1\n"
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index f676243abac6..cf12b0d6441e 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -71,8 +71,7 @@ KVM_NVHE_ALIAS(kvm_get_kimage_voffset);
 KVM_NVHE_ALIAS(kvm_vgic_global_state);
 
 /* Kernel symbols used to call panic() from nVHE hyp code (via ERET). */
-KVM_NVHE_ALIAS(__hyp_panic_string);
-KVM_NVHE_ALIAS(panic);
+KVM_NVHE_ALIAS(nvhe_hyp_panic_handler);
 
 /* Vectors installed by hyp-init on reset HVC. */
 KVM_NVHE_ALIAS(__hyp_stub_vectors);
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index cebe39f3b1b6..5e0d9a5152e5 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -291,3 +291,41 @@ void handle_exit_early(struct kvm_vcpu *vcpu, int exception_index)
 	if (exception_index == ARM_EXCEPTION_EL1_SERROR)
 		kvm_handle_guest_serror(vcpu, kvm_vcpu_get_esr(vcpu));
 }
+
+void __noreturn __cold nvhe_hyp_panic_handler(bool hyp, u64 spsr, u64 elr,
+					      u64 par, uintptr_t vcpu,
+					      u64 far, u64 hpfar, u64 esr) {
+	extern const char __hyp_panic_string[];
+	u64 elr_in_kimg = __phys_to_kimg(__hyp_pa(elr));
+
+	if (!hyp) {
+		kvm_err("Invalid host exception to nVHE hyp!\n");
+	} else if (ESR_ELx_EC(esr) == ESR_ELx_EC_BRK64 &&
+		   (esr & ESR_ELx_BRK64_ISS_COMMENT_MASK) == BUG_BRK_IMM) {
+		struct bug_entry *bug = find_bug(elr_in_kimg);
+		const char *file = NULL;
+		unsigned line = 0;
+
+		/* All hyp bugs, including warnings, are treated as fatal. */
+		if (bug) {
+#ifdef CONFIG_DEBUG_BUGVERBOSE
+#ifndef CONFIG_GENERIC_BUG_RELATIVE_POINTERS
+			file = bug->file;
+#else
+			file = (const char *)bug + bug->file_disp;
+#endif
+			line = bug->line;
+#endif
+		}
+
+		if (file) {
+			kvm_err("nVHE hyp BUG at: %s:%u!\n", file, line);
+		} else {
+			kvm_err("nVHE hyp BUG at: %016llx!\n", elr_in_kimg);
+		}
+	} else {
+		kvm_err("nVHE hyp panic at: %016llx!\n", elr_in_kimg);
+	}
+
+	panic(__hyp_panic_string, spsr, elr, esr, far, hpfar, par, vcpu);
+}
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 84473574c2e7..f9e8bb97d199 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -30,8 +30,6 @@
 #include <asm/processor.h>
 #include <asm/thread_info.h>
 
-extern const char __hyp_panic_string[];
-
 extern struct exception_table_entry __start___kvm_ex_table;
 extern struct exception_table_entry __stop___kvm_ex_table;
 
diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index 3dc5a9f3e575..d9a9dd66b1a2 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -77,21 +77,19 @@ SYM_FUNC_END(__host_enter)
 SYM_FUNC_START(__hyp_do_panic)
 	mov	x29, x0
 
-	/* Load the format string into x0 and arguments into x1-7 */
-	ldr	x0, =__hyp_panic_string
-
-	mov	x6, x3
-	get_vcpu_ptr x7, x3
-
-	mrs	x3, esr_el2
-	mrs	x4, far_el2
-	mrs	x5, hpfar_el2
+	/* Load the panic arguments into x0-7 */
+	cmp	x0, xzr
+	cset	x0, ne
+	get_vcpu_ptr x4, x5
+	mrs	x5, far_el2
+	mrs	x6, hpfar_el2
+	mrs	x7, esr_el2
 
 	/* Prepare and exit to the host's panic funciton. */
 	mov	lr, #(PSR_F_BIT | PSR_I_BIT | PSR_A_BIT | PSR_D_BIT |\
 		      PSR_MODE_EL1h)
 	msr	spsr_el2, lr
-	ldr	lr, =panic
+	ldr	lr, =nvhe_hyp_panic_handler
 	msr	elr_el2, lr
 
 	/* Enter the host, restoring the host context if it was provided. */
diff --git a/arch/arm64/kvm/hyp/nvhe/psci-relay.c b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
index 8e7128cb7667..54b70189229b 100644
--- a/arch/arm64/kvm/hyp/nvhe/psci-relay.c
+++ b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
@@ -22,8 +22,6 @@ void __noreturn __host_enter(struct kvm_cpu_context *host_ctxt);
 struct kvm_host_psci_config __ro_after_init kvm_host_psci_config;
 s64 __ro_after_init hyp_physvirt_offset;
 
-#define __hyp_pa(x) ((phys_addr_t)((x)) + hyp_physvirt_offset)
-
 #define INVALID_CPU_ID	UINT_MAX
 
 struct psci_boot_args {
-- 
2.30.0.617.g56c4b15f3c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

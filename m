Return-Path: <SRS0=n474=OM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31B29C433FE
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 12:47:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CB0CD61181
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 12:47:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CB0CD61181
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CDA84B0B8;
	Wed, 22 Sep 2021 08:47:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XdWKdLBthjXZ; Wed, 22 Sep 2021 08:47:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 703734B0E7;
	Wed, 22 Sep 2021 08:47:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FEE94B0E2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 08:47:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lu4W0nbgtikE for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Sep 2021 08:47:32 -0400 (EDT)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2FD134B0C3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 08:47:30 -0400 (EDT)
Received: by mail-qv1-f74.google.com with SMTP id
 w10-20020a0cb54a000000b0037a9848b92fso13149037qvd.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 05:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=fhuyzDrWVkEjtHzFzN+Fx6ExKEiC8uquGig/dbG3Bns=;
 b=nC1xPUxkO/dCfs8FVpTPJ8s8ewk2VV5qT2a4qephLr4t+EZ5A/JCaPLQIOMf+T4A/F
 HD3I6c8yXTN2Z1GmvjAB9kHrih+iGQhAnSj1eKpqqyjbYMxx5FzYKn/LNr25KlV8WOU7
 CcDVOxXpkPE/wH4yhdOaoYTeBKhVu3k7Xpbf8LOWTzYwQTU5G11agDQnhZ993/d6nOuo
 e1Zutmt0OI78WrqGYEv1VInt2IpLFMQGCTIjv7vJxx231AmMFGbcOlYGjkTYsksFY5tn
 byC+9fZxDfQkQ2z8VdC1X5jVwHcf9KuiWm1qDyHW9xbjqQ1JBPkX9mywJExzn54KfSYI
 j6kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=fhuyzDrWVkEjtHzFzN+Fx6ExKEiC8uquGig/dbG3Bns=;
 b=mQgPBAY/fBOjfEOH7xCcb1N3CuHA2xR5Ss34hbkjGZlKK6Mpp11TgaRki48l95pkcr
 SIsEuF0nOGqQ9ZnC/aFD/2RTZiCNwGsmIG7CJBJjd/LG13ect+V0NUsUUlGf9mZK2UxA
 oJIGtbsCv6zNP8KVHpvc66wdyqt4k080dLI5jDBJ1LMY9iKmNyDhs6XKK8Ej099i2Ct5
 5cMJj6CtgYUJrMlh96SVqLhlaPpKWdGVIkX2IMnFUB3Otn5q9LIjZslXfXS5s6r5RMG7
 55JxQ+vl6p9VPjSIvqiiOTUv/Eq1md8LxxIFTxCbaBJMMh6w2aG8ivu1RnsfgT9dZTbk
 GHeA==
X-Gm-Message-State: AOAM532G3lZMS39QvyrHJRFXTLKCTGij2v3FhPAqy/AmIbBGvW2vIEL3
 jT/iMwqpvdc35SBoCOC0z8A0YKyONq597BVPXVemGhHAvQwUx5svN/Iwm1BUxqpmZ+1y58sf7At
 wvhEnjFQreeiCJnw4QNTtLiAvtQGwjclzrzZ6/hhAqOdoQ2c3VxuDXN6iEWTt82PGsEE=
X-Google-Smtp-Source: ABdhPJxbrBtZRxlrZyFXhw9pE2+iVlXS5BSDuMMG1cQhJ1gtaZoBRAu5TJ0pEsjLM6ux6doDiNfYq5ulMg==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:ad4:556d:: with SMTP id
 w13mr8188690qvy.4.1632314849777; 
 Wed, 22 Sep 2021 05:47:29 -0700 (PDT)
Date: Wed, 22 Sep 2021 13:47:03 +0100
In-Reply-To: <20210922124704.600087-1-tabba@google.com>
Message-Id: <20210922124704.600087-12-tabba@google.com>
Mime-Version: 1.0
References: <20210922124704.600087-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v6 11/12] KVM: arm64: Trap access to pVM restricted features
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, will@kernel.org, linux-arm-kernel@lists.infradead.org
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

Trap accesses to restricted features for VMs running in protected
mode.

Access to feature registers are emulated, and only supported
features are exposed to protected VMs.

Accesses to restricted registers as well as restricted
instructions are trapped, and an undefined exception is injected
into the protected guests, i.e., with EC = 0x0 (unknown reason).
This EC is the one used, according to the Arm Architecture
Reference Manual, for unallocated or undefined system registers
or instructions.

Only affects the functionality of protected VMs. Otherwise,
should not affect non-protected VMs when KVM is running in
protected mode.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/switch.c | 60 ++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 49080c607838..2bf5952f651b 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -20,6 +20,7 @@
 #include <asm/kprobes.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
+#include <asm/kvm_fixed_config.h>
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 #include <asm/fpsimd.h>
@@ -28,6 +29,7 @@
 #include <asm/thread_info.h>
 
 #include <nvhe/mem_protect.h>
+#include <nvhe/sys_regs.h>
 
 /* Non-VHE specific context */
 DEFINE_PER_CPU(struct kvm_host_data, kvm_host_data);
@@ -158,6 +160,49 @@ static void __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
 		write_sysreg(pmu->events_host, pmcntenset_el0);
 }
 
+/**
+ * Handler for protected VM restricted exceptions.
+ *
+ * Inject an undefined exception into the guest and return true to indicate that
+ * the hypervisor has handled the exit, and control should go back to the guest.
+ */
+static bool kvm_handle_pvm_restricted(struct kvm_vcpu *vcpu, u64 *exit_code)
+{
+	__inject_undef64(vcpu);
+	return true;
+}
+
+/**
+ * Handler for protected VM MSR, MRS or System instruction execution in AArch64.
+ *
+ * Returns true if the hypervisor has handled the exit, and control should go
+ * back to the guest, or false if it hasn't.
+ */
+static bool kvm_handle_pvm_sys64(struct kvm_vcpu *vcpu, u64 *exit_code)
+{
+	if (kvm_handle_pvm_sysreg(vcpu, exit_code))
+		return true;
+	else
+		return kvm_hyp_handle_sysreg(vcpu, exit_code);
+}
+
+/**
+ * Handler for protected floating-point and Advanced SIMD accesses.
+ *
+ * Returns true if the hypervisor has handled the exit, and control should go
+ * back to the guest, or false if it hasn't.
+ */
+static bool kvm_handle_pvm_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
+{
+	/* Linux guests assume support for floating-point and Advanced SIMD. */
+	BUILD_BUG_ON(!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_FP),
+				PVM_ID_AA64PFR0_ALLOW));
+	BUILD_BUG_ON(!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_ASIMD),
+				PVM_ID_AA64PFR0_ALLOW));
+
+	return kvm_hyp_handle_fpsimd(vcpu, exit_code);
+}
+
 static const exit_handler_fn hyp_exit_handlers[] = {
 	[0 ... ESR_ELx_EC_MAX]		= NULL,
 	[ESR_ELx_EC_CP15_32]		= kvm_hyp_handle_cp15,
@@ -170,8 +215,23 @@ static const exit_handler_fn hyp_exit_handlers[] = {
 	[ESR_ELx_EC_PAC]		= kvm_hyp_handle_ptrauth,
 };
 
+static const exit_handler_fn pvm_exit_handlers[] = {
+	[0 ... ESR_ELx_EC_MAX]		= NULL,
+	[ESR_ELx_EC_CP15_32]		= kvm_hyp_handle_cp15,
+	[ESR_ELx_EC_CP15_64]		= kvm_hyp_handle_cp15,
+	[ESR_ELx_EC_SYS64]		= kvm_handle_pvm_sys64,
+	[ESR_ELx_EC_SVE]		= kvm_handle_pvm_restricted,
+	[ESR_ELx_EC_FP_ASIMD]		= kvm_handle_pvm_fpsimd,
+	[ESR_ELx_EC_IABT_LOW]		= kvm_hyp_handle_iabt_low,
+	[ESR_ELx_EC_DABT_LOW]		= kvm_hyp_handle_dabt_low,
+	[ESR_ELx_EC_PAC]		= kvm_hyp_handle_ptrauth,
+};
+
 static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm *kvm)
 {
+	if (unlikely(kvm_vm_is_protected(kvm)))
+		return pvm_exit_handlers;
+
 	return hyp_exit_handlers;
 }
 
-- 
2.33.0.464.g1972c5931b-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <SRS0=jphx=NS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56635C432BE
	for <kvmarm@archiver.kernel.org>; Fri, 27 Aug 2021 07:50:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 01AE160F92
	for <kvmarm@archiver.kernel.org>; Fri, 27 Aug 2021 07:50:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 01AE160F92
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C3E94B11B;
	Fri, 27 Aug 2021 03:50:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3rFks3HauHP9; Fri, 27 Aug 2021 03:50:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 68F424B186;
	Fri, 27 Aug 2021 03:49:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DD0F4B0CB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Aug 2021 20:57:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gYomWH40Q6Qn for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Aug 2021 20:57:52 -0400 (EDT)
Received: from mail-qt1-f201.google.com (mail-qt1-f201.google.com
 [209.85.160.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 778F64B0E8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Aug 2021 20:57:52 -0400 (EDT)
Received: by mail-qt1-f201.google.com with SMTP id
 e6-20020ac84e46000000b0029baad9aaa0so1036022qtw.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Aug 2021 17:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=APlw6FoeYyjS3BPQZoCRIAf0ql6GYvWTuNomlW8snXU=;
 b=LuT11C5Peh4krF2EeyCdRCxcbNvhcakRbKzYpV3qZ6O2Z4PVpX/pEIk2oLYVzCzATI
 LirVe+4RAAMNQA5oiT6FeR7Vf9UzP3TZBQ1RW6eIIDw0eYoqjBIHJCOb3m7m1RgUcZdn
 bOJ3i8Ik5ehFXpmB//AMa+N0DT/avx0k1s6Bh0Z4wQ47vO3Y5BHzjhy1obtH40imLbdg
 1DczFHZq/wmvU1GEirxYMIFLIuwM5dyIeEobru75ofGyf5WLMEq8/LlYDYJwN2l4QhOG
 8GED2Mpk3QJ4QR32vEcxwTxNC2AHBjbOsMdxCn7mUPHsS1u7SGXczKvCreOLUwK7WywP
 dKgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=APlw6FoeYyjS3BPQZoCRIAf0ql6GYvWTuNomlW8snXU=;
 b=um4NFGJnyXPGHVpr9SvvL6cifktUDr5jAC7iuR/3/RGcwFdqVgf9fufPcfxRiCgpCN
 YWWchpbopqa+DvO1kif60XoCyBg40LvgBcK5UsyOe77tcQxVvo14gWw2ekw+Nw2Ndxwv
 SsJiJvyELywUh5D4ZILpA4sBCxEEQ+vQQf3pN2fROV0cKZwGYm4jRpopvenyxLJJf/G7
 RY2odToT8FDN5pF9TGNCkKJnbfZrIwElUKcwLrAKQ8Kq3XGD2KSbVECiQDSXzIc8LSzP
 66OkLlLRalDqRwYoY18Vi4QGty2umDM3y8bXUKer3ACw0JjgEI4qCJxQX7d+g245+wBg
 KeWQ==
X-Gm-Message-State: AOAM530nr9VMLjuv72eVsZxqgoX9tn+6EtQba77QPI593LIFXjXsC7qM
 i9+t7MBj+Kbrj22AxcrWIV85zbNC8S8=
X-Google-Smtp-Source: ABdhPJxV8SLmQ7eQT1AmY1MtULBcvEHZk3qClIQX5AbSsyjIRBSmPH3McGvB8qU+Qq94IjkJESGPvkRvUxQ=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:c16c:db05:96b2:1475])
 (user=seanjc job=sendgmr) by 2002:a05:6214:2465:: with SMTP id
 im5mr7220558qvb.46.1630025871976; Thu, 26 Aug 2021 17:57:51 -0700 (PDT)
Date: Thu, 26 Aug 2021 17:57:13 -0700
In-Reply-To: <20210827005718.585190-1-seanjc@google.com>
Message-Id: <20210827005718.585190-11-seanjc@google.com>
Mime-Version: 1.0
References: <20210827005718.585190-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [PATCH 10/15] KVM: Move x86's perf guest info callbacks to generic KVM
From: Sean Christopherson <seanjc@google.com>
To: Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>, 
 Guo Ren <guoren@kernel.org>, Nick Hu <nickhu@andestech.com>, 
 Greentime Hu <green.hu@gmail.com>, Vincent Chen <deanbo422@gmail.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Thomas Gleixner <tglx@linutronix.de>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, 
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>
X-Mailman-Approved-At: Fri, 27 Aug 2021 03:49:31 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, linux-riscv@lists.infradead.org,
 Jiri Olsa <jolsa@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Stefano Stabellini <sstabellini@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 linux-csky@vger.kernel.org, xen-devel@lists.xenproject.org,
 Zhu Lingshan <lingshan.zhu@intel.com>, Namhyung Kim <namhyung@kernel.org>,
 Artem Kashkanov <artem.kashkanov@intel.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Like Xu <like.xu.linux@gmail.com>, Sean Christopherson <seanjc@google.com>,
 linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 Vitaly Kuznetsov <vkuznets@redhat.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Sean Christopherson <seanjc@google.com>
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

Move x86's perf guest callbacks into common KVM, as they are semantically
identical to arm64's callbacks (the only other such KVM callbacks).
arm64 will convert to the common versions in a future patch.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/x86.c              | 48 +++++----------------------------
 arch/x86/kvm/x86.h              |  6 -----
 include/linux/kvm_host.h        | 12 +++++++++
 virt/kvm/kvm_main.c             | 46 +++++++++++++++++++++++++++++++
 5 files changed, 66 insertions(+), 47 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 465b35736d9b..63553a1f43ee 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -36,6 +36,7 @@
 #include <asm/hyperv-tlfs.h>
 
 #define __KVM_HAVE_ARCH_VCPU_DEBUGFS
+#define __KVM_WANT_PERF_CALLBACKS
 
 #define KVM_MAX_VCPUS 288
 #define KVM_SOFT_MAX_VCPUS 240
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e337aef60793..7cb0f04e24ee 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8264,32 +8264,6 @@ static void kvm_timer_init(void)
 			  kvmclock_cpu_online, kvmclock_cpu_down_prep);
 }
 
-static int kvm_is_in_guest(void)
-{
-	/* x86's callbacks are registered only when handling a guest NMI. */
-	return true;
-}
-
-static int kvm_is_user_mode(void)
-{
-	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
-
-	if (WARN_ON_ONCE(!vcpu))
-		return 0;
-
-	return static_call(kvm_x86_get_cpl)(vcpu) != 0;
-}
-
-static unsigned long kvm_get_guest_ip(void)
-{
-	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
-
-	if (WARN_ON_ONCE(!vcpu))
-		return 0;
-
-	return kvm_rip_read(vcpu);
-}
-
 static void kvm_handle_intel_pt_intr(void)
 {
 	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
@@ -8302,19 +8276,6 @@ static void kvm_handle_intel_pt_intr(void)
 			(unsigned long *)&vcpu->arch.pmu.global_status);
 }
 
-static struct perf_guest_info_callbacks kvm_guest_cbs = {
-	.is_in_guest		= kvm_is_in_guest,
-	.is_user_mode		= kvm_is_user_mode,
-	.get_guest_ip		= kvm_get_guest_ip,
-	.handle_intel_pt_intr	= NULL,
-};
-
-void kvm_register_perf_callbacks(void)
-{
-	__perf_register_guest_info_callbacks(&kvm_guest_cbs);
-}
-EXPORT_SYMBOL_GPL(kvm_register_perf_callbacks);
-
 #ifdef CONFIG_X86_64
 static void pvclock_gtod_update_fn(struct work_struct *work)
 {
@@ -11069,7 +11030,7 @@ int kvm_arch_hardware_setup(void *opaque)
 	kvm_ops_static_call_update();
 
 	if (ops->intel_pt_intr_in_guest && ops->intel_pt_intr_in_guest())
-		kvm_guest_cbs.handle_intel_pt_intr = kvm_handle_intel_pt_intr;
+		kvm_set_intel_pt_intr_handler(kvm_handle_intel_pt_intr);
 
 	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
 		supported_xss = 0;
@@ -11098,7 +11059,7 @@ int kvm_arch_hardware_setup(void *opaque)
 
 void kvm_arch_hardware_unsetup(void)
 {
-	kvm_guest_cbs.handle_intel_pt_intr = NULL;
+	kvm_set_intel_pt_intr_handler(NULL);
 
 	static_call(kvm_x86_hardware_unsetup)();
 }
@@ -11725,6 +11686,11 @@ bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
 	return vcpu->arch.preempted_in_kernel;
 }
 
+unsigned long kvm_arch_vcpu_get_ip(struct kvm_vcpu *vcpu)
+{
+	return kvm_rip_read(vcpu);
+}
+
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 {
 	return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index f13f15d2fab8..e1fe738c3827 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -387,12 +387,6 @@ static inline bool kvm_cstate_in_guest(struct kvm *kvm)
 	return kvm->arch.cstate_in_guest;
 }
 
-void kvm_register_perf_callbacks(void);
-static inline void kvm_unregister_perf_callbacks(void)
-{
-	__perf_unregister_guest_info_callbacks();
-}
-
 static inline void kvm_before_interrupt(struct kvm_vcpu *vcpu, bool is_nmi)
 {
 	WRITE_ONCE(vcpu->arch.handling_nmi_from_guest, is_nmi);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e4d712e9f760..0db9af0b628c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1163,6 +1163,18 @@ static inline bool kvm_arch_intc_initialized(struct kvm *kvm)
 }
 #endif
 
+#ifdef __KVM_WANT_PERF_CALLBACKS
+
+void kvm_set_intel_pt_intr_handler(void (*handler)(void));
+unsigned long kvm_arch_vcpu_get_ip(struct kvm_vcpu *vcpu);
+
+void kvm_register_perf_callbacks(void);
+static inline void kvm_unregister_perf_callbacks(void)
+{
+	__perf_unregister_guest_info_callbacks();
+}
+#endif
+
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type);
 void kvm_arch_destroy_vm(struct kvm *kvm);
 void kvm_arch_sync_events(struct kvm *kvm);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3e67c93ca403..13c4f58a75e5 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5460,6 +5460,52 @@ struct kvm_vcpu * __percpu *kvm_get_running_vcpus(void)
         return &kvm_running_vcpu;
 }
 
+#ifdef __KVM_WANT_PERF_CALLBACKS
+static int kvm_is_in_guest(void)
+{
+	/* Registration of KVM's callback signifies "in guest". */
+	return true;
+}
+
+static int kvm_is_user_mode(void)
+{
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
+
+	if (WARN_ON_ONCE(!vcpu))
+		return 0;
+
+	return !kvm_arch_vcpu_in_kernel(vcpu);
+}
+
+static unsigned long kvm_get_guest_ip(void)
+{
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
+
+	if (WARN_ON_ONCE(!vcpu))
+		return 0;
+
+	return kvm_arch_vcpu_get_ip(vcpu);
+}
+
+static struct perf_guest_info_callbacks kvm_guest_cbs = {
+	.is_in_guest		= kvm_is_in_guest,
+	.is_user_mode		= kvm_is_user_mode,
+	.get_guest_ip		= kvm_get_guest_ip,
+	.handle_intel_pt_intr	= NULL,
+};
+
+void kvm_set_intel_pt_intr_handler(void (*handler)(void))
+{
+	kvm_guest_cbs.handle_intel_pt_intr = handler;
+}
+
+void kvm_register_perf_callbacks(void)
+{
+	__perf_register_guest_info_callbacks(&kvm_guest_cbs);
+}
+EXPORT_SYMBOL_GPL(kvm_register_perf_callbacks);
+#endif
+
 struct kvm_cpu_compat_check {
 	void *opaque;
 	int *ret;
-- 
2.33.0.259.gc128427fd7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

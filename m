Return-Path: <SRS0=jphx=NS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54EA7C432BE
	for <kvmarm@archiver.kernel.org>; Fri, 27 Aug 2021 07:50:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 068EC60FD8
	for <kvmarm@archiver.kernel.org>; Fri, 27 Aug 2021 07:50:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 068EC60FD8
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B1A3E4B134;
	Fri, 27 Aug 2021 03:50:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id N8w91Y-H0y0L; Fri, 27 Aug 2021 03:50:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5193A4B17D;
	Fri, 27 Aug 2021 03:49:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D4A14B0CB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Aug 2021 20:57:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nTs5RQA0UFVq for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Aug 2021 20:57:50 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 47A214B110
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Aug 2021 20:57:50 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 c63-20020a25e5420000b0290580b26e708aso4878804ybh.12
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Aug 2021 17:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=URtT+dB+jST+gZg2WrKoRMxEnnvOGJ2KoTQrrGCl7oY=;
 b=QMyMyW8S+UdMR+QA1dMUWcj1nvV4awF9BhU25l5pymBfzXZEUMcpGdZL0BxhsVUTrH
 wwnMpXfbLu54yCHCCtgV2+evWSEDbv+dXSyufVgmFg3L3pcb8KjT8SWqp9r8G6c8kSxp
 pLoenRdXaSghZld5WzFyBNBLJKTOW1nT55C2Sva+2Zv2/tE3SOwtK+UMfx8kFjDDzDJK
 t9N4Z7NvWPgoYl3X+kWUq4jXGlgLXhzG/pWtR82HNRigu9ZhzdlUBMpgi1gtDf4WrxBF
 kafWIVt0+yu4zS7kftTHzy2ydn7SjePf/9Jkus2cGK2V680+vkX5sdV4/U0/KQUCmBkV
 IaMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=URtT+dB+jST+gZg2WrKoRMxEnnvOGJ2KoTQrrGCl7oY=;
 b=JcjQUQpwgK6KJQC+Un1Bb2bp8c8eH67wfQgkvkJHHjaCfM2jgrNYIEPEuPoIE3+Rkn
 R/N1eBbl8C3FvwSSI1XvM3Nwe+BGewbHLYMzo2EXBXRoMIIjarZYAxIFCiZrvaXy10gF
 jBMFEPyW+h+fc6qgOdN+944cDWGCtR8RVZElYJ9GezKfUzYnLofjCgD33ucYSsUVIYEF
 S9ysPduocm6Ac0I+TIRJJ81J6ivujY1PX09qM8yKJxt6OlwiiXvwFgnTsPbIDaYIcNB/
 5kPCcEnza+nPZWzl2MvOOmSdBHDtWrfDeKmEImNlTei4p51qwWBpwyVwHP856hwWqxqv
 JQRA==
X-Gm-Message-State: AOAM5334VYCC8+DnleRvUk0ux9yTzXB/zfR+szpV6U6b1j9qzQLMb6N/
 AGoHFm9CxM97gou7NG7j68utRZLH91o=
X-Google-Smtp-Source: ABdhPJx9DS89m5L71YrEHQukjJpAjWUrBsdJUeHGSEcBnJIrikQ0Z8d/TNTUFittLfnOlgJyGEhI291z6yw=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:c16c:db05:96b2:1475])
 (user=seanjc job=sendgmr) by 2002:a25:afcd:: with SMTP id
 d13mr1863343ybj.504.1630025869822; 
 Thu, 26 Aug 2021 17:57:49 -0700 (PDT)
Date: Thu, 26 Aug 2021 17:57:12 -0700
In-Reply-To: <20210827005718.585190-1-seanjc@google.com>
Message-Id: <20210827005718.585190-10-seanjc@google.com>
Mime-Version: 1.0
References: <20210827005718.585190-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [PATCH 09/15] KVM: arm64: Register/unregister perf callbacks at vcpu
 load/put
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

Register/unregister perf callbacks at vcpu_load()/vcpu_put() instead of
keeping the callbacks registered for all eternity after loading KVM.
This will allow future cleanups and optimizations as the registration
of the callbacks signifies "in guest".  This will also allow moving the
callbacks into common KVM as they arm64 and x86 now have semantically
identical callback implementations.

Note, KVM could likely be more precise in its registration, but that's a
cleanup for the future.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 12 ++++++++++-
 arch/arm64/kvm/arm.c              |  5 ++++-
 arch/arm64/kvm/perf.c             | 36 ++++++++++++++-----------------
 3 files changed, 31 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index ed940aec89e0..007c38d77fd9 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -671,7 +671,17 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu);
 int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa);
 
 void kvm_perf_init(void);
-void kvm_perf_teardown(void);
+
+#ifdef CONFIG_PERF_EVENTS
+void kvm_register_perf_callbacks(void);
+static inline void kvm_unregister_perf_callbacks(void)
+{
+	__perf_unregister_guest_info_callbacks();
+}
+#else
+static inline void kvm_register_perf_callbacks(void) {}
+static inline void kvm_unregister_perf_callbacks(void) {}
+#endif
 
 long kvm_hypercall_pv_features(struct kvm_vcpu *vcpu);
 gpa_t kvm_init_stolen_time(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e9a2b8f27792..ec386971030d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -429,10 +429,13 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	if (vcpu_has_ptrauth(vcpu))
 		vcpu_ptrauth_disable(vcpu);
 	kvm_arch_vcpu_load_debug_state_flags(vcpu);
+
+	kvm_register_perf_callbacks();
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
+	kvm_unregister_perf_callbacks();
 	kvm_arch_vcpu_put_debug_state_flags(vcpu);
 	kvm_arch_vcpu_put_fp(vcpu);
 	if (has_vhe())
@@ -2155,7 +2158,7 @@ int kvm_arch_init(void *opaque)
 /* NOP: Compiling as a module not supported */
 void kvm_arch_exit(void)
 {
-	kvm_perf_teardown();
+
 }
 
 static int __init early_kvm_mode_cfg(char *arg)
diff --git a/arch/arm64/kvm/perf.c b/arch/arm64/kvm/perf.c
index 039fe59399a2..2556b0a3b096 100644
--- a/arch/arm64/kvm/perf.c
+++ b/arch/arm64/kvm/perf.c
@@ -13,33 +13,30 @@
 
 DEFINE_STATIC_KEY_FALSE(kvm_arm_pmu_available);
 
+#ifdef CONFIG_PERF_EVENTS
 static int kvm_is_in_guest(void)
 {
-        return kvm_get_running_vcpu() != NULL;
+	return true;
 }
 
 static int kvm_is_user_mode(void)
 {
-	struct kvm_vcpu *vcpu;
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 
-	vcpu = kvm_get_running_vcpu();
+	if (WARN_ON_ONCE(!vcpu))
+		return 0;
 
-	if (vcpu)
-		return !vcpu_mode_priv(vcpu);
-
-	return 0;
+	return !vcpu_mode_priv(vcpu);
 }
 
 static unsigned long kvm_get_guest_ip(void)
 {
-	struct kvm_vcpu *vcpu;
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 
-	vcpu = kvm_get_running_vcpu();
+	if (WARN_ON_ONCE(!vcpu))
+		return 0;
 
-	if (vcpu)
-		return *vcpu_pc(vcpu);
-
-	return 0;
+	return *vcpu_pc(vcpu);
 }
 
 static struct perf_guest_info_callbacks kvm_guest_cbs = {
@@ -48,15 +45,14 @@ static struct perf_guest_info_callbacks kvm_guest_cbs = {
 	.get_guest_ip	= kvm_get_guest_ip,
 };
 
+void kvm_register_perf_callbacks(void)
+{
+	__perf_register_guest_info_callbacks(&kvm_guest_cbs);
+}
+#endif /* CONFIG_PERF_EVENTS*/
+
 void kvm_perf_init(void)
 {
 	if (kvm_pmu_probe_pmuver() != 0xf && !is_protected_kvm_enabled())
 		static_branch_enable(&kvm_arm_pmu_available);
-
-	perf_register_guest_info_callbacks(&kvm_guest_cbs);
-}
-
-void kvm_perf_teardown(void)
-{
-	perf_unregister_guest_info_callbacks();
 }
-- 
2.33.0.259.gc128427fd7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <SRS0=jphx=NS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 225DDC43214
	for <kvmarm@archiver.kernel.org>; Fri, 27 Aug 2021 07:50:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C559160FD8
	for <kvmarm@archiver.kernel.org>; Fri, 27 Aug 2021 07:49:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C559160FD8
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 79B6D4B103;
	Fri, 27 Aug 2021 03:49:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wcwUl9hPwZfw; Fri, 27 Aug 2021 03:49:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 235824B173;
	Fri, 27 Aug 2021 03:49:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D7DB64B0F7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Aug 2021 20:57:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8A4AYjSrdoxa for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Aug 2021 20:57:45 -0400 (EDT)
Received: from mail-qk1-f202.google.com (mail-qk1-f202.google.com
 [209.85.222.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C201E4B0F4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Aug 2021 20:57:45 -0400 (EDT)
Received: by mail-qk1-f202.google.com with SMTP id
 o4-20020ae9f504000000b003d39d97b227so2847831qkg.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Aug 2021 17:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=ruUdABYeGOxk9Wbic5Hd5odsewNKbNWoYU61ZxyE/gg=;
 b=vndU5Ssx1OSDPC9rhyF45w6Pl7KtF0HVdGcu07QMxr8hS7zmZr27FOwtaxJ1tTTkEv
 TjbpCl/yYOXwwbt+SfzpzW3C6DQ9IlXFMA5KyM2L5I/ODQXruJ5mMmlo2GULJ15xapc7
 DFo1XzvZHNjyXnPyzThDoBjBnUJ1S5bL2Zix9AnTvvwdLOZpELvTqnih27/JdGkMAZoP
 quXkeM9af9v2IYqphIzmnDdaHD0J50WGHw7/sBwRcQXuQNUtKrPYoGQP0EI8s8Bwn6H5
 0rtanzqf7O/zwFamcAeVErwzbLq+HxNe55hWM4yl7reqNOj5UMfQohDiN9UF2ESzt0l+
 hATA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=ruUdABYeGOxk9Wbic5Hd5odsewNKbNWoYU61ZxyE/gg=;
 b=XhZ+jpMTnJRPKgcLAF7mcMHeQst1oMy5wUCDb4azTtjJH5R4bCw63VAAsHAyS9wbg8
 W6Oo7vKZa2IWDycKErtMCmBTR78pVxi1ZoxLw05XWfHoh+TD3Xm4t0gMCd0kLRPc4JEH
 5UDZ/vhdGStsqr3J5jfjOmCRheT2oGAa1ZNbpP1999fqGoiQGDbq7TMfWXRtspB84Qyk
 txNzsMrDR1rbIe4ZjCT1XO5W+mYSu9QC8iTPQCYTYVPB6EohTzpqMsG3pZ28957oxlKD
 /JEw6BdpcgTsM3w3aB2q9pi1VRpzLFYJ6wZEhbb7o5fABTW3twdvFeh2n1M3I1Uz73N5
 ZgfQ==
X-Gm-Message-State: AOAM533rGfgkMpfokLG6U0ieK6EywXJQAK9VvWMwBqfQ6JOepLzcm+jJ
 L3e6c1WL72F04PBcil7cFJmREpND588=
X-Google-Smtp-Source: ABdhPJxmVIKT1CgaTJnI3PKNih3UzXPOYiYk1l24a+ud0Vw4EBZOBMMmsnAtkB7iXZi5aG3MALLptO9xIv4=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:c16c:db05:96b2:1475])
 (user=seanjc job=sendgmr) by 2002:a05:6214:14f2:: with SMTP id
 k18mr7332294qvw.19.1630025865337; Thu, 26 Aug 2021 17:57:45 -0700 (PDT)
Date: Thu, 26 Aug 2021 17:57:10 -0700
In-Reply-To: <20210827005718.585190-1-seanjc@google.com>
Message-Id: <20210827005718.585190-8-seanjc@google.com>
Mime-Version: 1.0
References: <20210827005718.585190-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [PATCH 07/15] KVM: Use dedicated flag to track if KVM is handling an
 NMI from guest
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

Add a dedicated flag to detect the case where KVM's PMC overflow
callback was originally invoked in response to an NMI that arrived while
the guest was running.  Using current_vcpu is less precise as IRQs also
set current_vcpu (though presumably KVM's callback should not be reached
in that case), and more importantly, this will allow dropping
current_vcpu as the perf callbacks can switch to kvm_running_vcpu now
that the perf callbacks are precisely registered, i.e. kvm_running_vcpu
doesn't need to be used to detect if a PMI arrived in the guest.

Fixes: dd60d217062f ("KVM: x86: Fix perf timer mode IP reporting")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 3 +--
 arch/x86/kvm/pmu.c              | 2 +-
 arch/x86/kvm/svm/svm.c          | 2 +-
 arch/x86/kvm/vmx/vmx.c          | 2 +-
 arch/x86/kvm/x86.c              | 4 ++--
 arch/x86/kvm/x86.h              | 4 +++-
 6 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1ea4943a73d7..465b35736d9b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -763,6 +763,7 @@ struct kvm_vcpu_arch {
 	unsigned nmi_pending; /* NMI queued after currently running handler */
 	bool nmi_injected;    /* Trying to inject an NMI this entry */
 	bool smi_pending;    /* SMI queued after currently running handler */
+	bool handling_nmi_from_guest;
 
 	struct kvm_mtrr mtrr_state;
 	u64 pat;
@@ -1874,8 +1875,6 @@ int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu);
 int kvm_complete_insn_gp(struct kvm_vcpu *vcpu, int err);
 void __kvm_request_immediate_exit(struct kvm_vcpu *vcpu);
 
-int kvm_is_in_guest(void);
-
 void __user *__x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa,
 				     u32 size);
 bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 0772bad9165c..2b8934b452ea 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -87,7 +87,7 @@ static void kvm_perf_overflow_intr(struct perf_event *perf_event,
 		 * woken up. So we should wake it, but this is impossible from
 		 * NMI context. Do it from irq work instead.
 		 */
-		if (!kvm_is_in_guest())
+		if (!pmc->vcpu->arch.handling_nmi_from_guest)
 			irq_work_queue(&pmc_to_pmu(pmc)->irq_work);
 		else
 			kvm_make_request(KVM_REQ_PMI, pmc->vcpu);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1a70e11f0487..3fc6767e5fd8 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3843,7 +3843,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	}
 
 	if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
-		kvm_before_interrupt(vcpu);
+		kvm_before_interrupt(vcpu, true);
 
 	kvm_load_host_xsave_state(vcpu);
 	stgi();
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f19d72136f77..f08980ef7c44 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6344,7 +6344,7 @@ void vmx_do_interrupt_nmi_irqoff(unsigned long entry);
 static void handle_interrupt_nmi_irqoff(struct kvm_vcpu *vcpu,
 					unsigned long entry)
 {
-	kvm_before_interrupt(vcpu);
+	kvm_before_interrupt(vcpu, entry == (unsigned long)asm_exc_nmi_noist);
 	vmx_do_interrupt_nmi_irqoff(entry);
 	kvm_after_interrupt(vcpu);
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bc4ee6ea7752..d4d91944fde7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8267,7 +8267,7 @@ static void kvm_timer_init(void)
 DEFINE_PER_CPU(struct kvm_vcpu *, current_vcpu);
 EXPORT_PER_CPU_SYMBOL_GPL(current_vcpu);
 
-int kvm_is_in_guest(void)
+static int kvm_is_in_guest(void)
 {
 	return __this_cpu_read(current_vcpu) != NULL;
 }
@@ -9678,7 +9678,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	 * interrupts on processors that implement an interrupt shadow, the
 	 * stat.exits increment will do nicely.
 	 */
-	kvm_before_interrupt(vcpu);
+	kvm_before_interrupt(vcpu, false);
 	local_irq_enable();
 	++vcpu->stat.exits;
 	local_irq_disable();
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 5cedc0e8a5d5..4c5ba4128b38 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -395,9 +395,10 @@ static inline void kvm_unregister_perf_callbacks(void)
 
 DECLARE_PER_CPU(struct kvm_vcpu *, current_vcpu);
 
-static inline void kvm_before_interrupt(struct kvm_vcpu *vcpu)
+static inline void kvm_before_interrupt(struct kvm_vcpu *vcpu, bool is_nmi)
 {
 	__this_cpu_write(current_vcpu, vcpu);
+	WRITE_ONCE(vcpu->arch.handling_nmi_from_guest, is_nmi);
 
 	kvm_register_perf_callbacks();
 }
@@ -406,6 +407,7 @@ static inline void kvm_after_interrupt(struct kvm_vcpu *vcpu)
 {
 	kvm_unregister_perf_callbacks();
 
+	WRITE_ONCE(vcpu->arch.handling_nmi_from_guest, false);
 	__this_cpu_write(current_vcpu, NULL);
 }
 
-- 
2.33.0.259.gc128427fd7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

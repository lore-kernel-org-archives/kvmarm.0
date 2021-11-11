Return-Path: <SRS0=nF4w=P6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E30BC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 11 Nov 2021 02:07:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 07D3C61A4E
	for <kvmarm@archiver.kernel.org>; Thu, 11 Nov 2021 02:07:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 07D3C61A4E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AF8A74B1EF;
	Wed, 10 Nov 2021 21:07:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XZGqJLJz3cn7; Wed, 10 Nov 2021 21:07:56 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B15874B22B;
	Wed, 10 Nov 2021 21:07:55 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 435CF4B20B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 21:07:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VVCD0qkVjEOo for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Nov 2021 21:07:52 -0500 (EST)
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com
 [209.85.210.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C4F424B223
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 21:07:51 -0500 (EST)
Received: by mail-pf1-f202.google.com with SMTP id
 k63-20020a628442000000b004812ea67c34so3074612pfd.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 18:07:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=Apml5USbtNBNJWAvbbh8XFiyHgbDn3HxurxzTvY68aY=;
 b=rhYQ3kFE6KXMC4z2oCjpsBUhZh8QPd91Te2BBg6hppGmpAYWnod92usQwhqE1PHqNy
 Qld6bdflJylY5QfrRw78JqW10v6SrgdHXD0DLzzuo0mZQeGOKNMxrno8yrpJhT+8UcHm
 N53GcQhAbZkRVhoJpL+siLsuUbu94zleiKRSCPgYgDPDUTac0CjxivJw2PnvrQJGDbff
 QshPZ0fKvljsCWjx/ruRlMDS8ggjyVLQATeLToiTGYm4QnLcjqHseFr7Ub6IVui0++IH
 hRdPcpIVxGDM7LuWsGJsT3gyESzsSdVLxJN4KCqTV7xOr0X86Kr7ewQxn+1Z4UbDPFcB
 GnYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=Apml5USbtNBNJWAvbbh8XFiyHgbDn3HxurxzTvY68aY=;
 b=BL+qlLiXxFMN3mCQZ4me8maltF9s/isP23z4MEki5fMEfA+9rXic29awly+c7PM+2z
 mqY/v1vz2LLjDxgGdDxHgeIauaSfJl61unafWYVoMotVvGCjcAtBIuRK/Ndqw2KTygPv
 9NzrllyArJI5n/3HaxeOFavtCdWBzmRx16VZZ/AKAEJsX7VLoJOrhiAIwvEEA139XoC8
 zXJ18kwleAr2SaYqS3fTUepp7mljvRrqqKmE0V6I/3r5Oz/cGzDyuSJ/qwKjYOsoZMkz
 n/CjX49CwQCNr4LwmzKwfebOi/E1zSA+FUt8uzKKOm26aGxfhkN1EY1+Q2xzUhiOXbHd
 IUYw==
X-Gm-Message-State: AOAM532YnTSsG+Irs5Z+60X0NkNE1huoSfLr8L4DCaPZ1wKCIhbZbHVC
 urT49nf3KfdkUrtm/GOH/33SuPR8CCI=
X-Google-Smtp-Source: ABdhPJxBzNsPLY8AxAvZLIxLbhKZwdFhZqffL4IBnUtCd6ZihI2BNbkC+QMK4Jjyy7JxJSfimd7zSjX02Zg=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:9dca:: with SMTP id
 x10mr22330561pjv.170.1636596470963; Wed, 10 Nov 2021 18:07:50 -0800 (PST)
Date: Thu, 11 Nov 2021 02:07:27 +0000
In-Reply-To: <20211111020738.2512932-1-seanjc@google.com>
Message-Id: <20211111020738.2512932-7-seanjc@google.com>
Mime-Version: 1.0
References: <20211111020738.2512932-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH v4 06/17] perf/core: Rework guest callbacks to prepare for
 static_call support
From: Sean Christopherson <seanjc@google.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, 
 Russell King <linux@armlinux.org.uk>, Marc Zyngier <maz@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, Guo Ren <guoren@kernel.org>, 
 Nick Hu <nickhu@andestech.com>, Greentime Hu <green.hu@gmail.com>, 
 Vincent Chen <deanbo422@gmail.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 Paolo Bonzini <pbonzini@redhat.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, 
 Juergen Gross <jgross@suse.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, linux-riscv@lists.infradead.org,
 Jiri Olsa <jolsa@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Stefano Stabellini <sstabellini@kernel.org>, Like Xu <like.xu@linux.intel.com>,
 Joerg Roedel <joro@8bytes.org>, linux-csky@vger.kernel.org,
 xen-devel@lists.xenproject.org, Zhu Lingshan <lingshan.zhu@intel.com>,
 Namhyung Kim <namhyung@kernel.org>,
 Artem Kashkanov <artem.kashkanov@intel.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Like Xu <like.xu.linux@gmail.com>, linux-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>
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

From: Like Xu <like.xu@linux.intel.com>

To prepare for using static_calls to optimize perf's guest callbacks,
replace ->is_in_guest and ->is_user_mode with a new multiplexed hook
->state, tweak ->handle_intel_pt_intr to play nice with being called when
there is no active guest, and drop "guest" from ->get_guest_ip.

Return '0' from ->state and ->handle_intel_pt_intr to indicate "not in
guest" so that DEFINE_STATIC_CALL_RET0 can be used to define the static
calls, i.e. no callback == !guest.

Suggested-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Originally-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
[sean: extracted from static_call patch, fixed get_ip() bug, wrote changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/arm64/kernel/perf_callchain.c | 13 +++++-----
 arch/arm64/kvm/perf.c              | 35 +++++++++++---------------
 arch/x86/events/core.c             | 13 +++++-----
 arch/x86/events/intel/core.c       |  5 +---
 arch/x86/include/asm/kvm_host.h    |  2 +-
 arch/x86/kvm/pmu.c                 |  2 +-
 arch/x86/kvm/x86.c                 | 40 ++++++++++++++++--------------
 arch/x86/xen/pmu.c                 | 32 ++++++++++--------------
 include/linux/perf_event.h         | 10 +++++---
 9 files changed, 73 insertions(+), 79 deletions(-)

diff --git a/arch/arm64/kernel/perf_callchain.c b/arch/arm64/kernel/perf_callchain.c
index 86d9f2013172..274dc3e11b6d 100644
--- a/arch/arm64/kernel/perf_callchain.c
+++ b/arch/arm64/kernel/perf_callchain.c
@@ -104,7 +104,7 @@ void perf_callchain_user(struct perf_callchain_entry_ctx *entry,
 {
 	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
 
-	if (guest_cbs && guest_cbs->is_in_guest()) {
+	if (guest_cbs && guest_cbs->state()) {
 		/* We don't support guest os callchain now */
 		return;
 	}
@@ -152,7 +152,7 @@ void perf_callchain_kernel(struct perf_callchain_entry_ctx *entry,
 	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
 	struct stackframe frame;
 
-	if (guest_cbs && guest_cbs->is_in_guest()) {
+	if (guest_cbs && guest_cbs->state()) {
 		/* We don't support guest os callchain now */
 		return;
 	}
@@ -165,8 +165,8 @@ unsigned long perf_instruction_pointer(struct pt_regs *regs)
 {
 	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
 
-	if (guest_cbs && guest_cbs->is_in_guest())
-		return guest_cbs->get_guest_ip();
+	if (guest_cbs && guest_cbs->state())
+		return guest_cbs->get_ip();
 
 	return instruction_pointer(regs);
 }
@@ -174,10 +174,11 @@ unsigned long perf_instruction_pointer(struct pt_regs *regs)
 unsigned long perf_misc_flags(struct pt_regs *regs)
 {
 	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
+	unsigned int guest_state = guest_cbs ? guest_cbs->state() : 0;
 	int misc = 0;
 
-	if (guest_cbs && guest_cbs->is_in_guest()) {
-		if (guest_cbs->is_user_mode())
+	if (guest_state) {
+		if (guest_state & PERF_GUEST_USER)
 			misc |= PERF_RECORD_MISC_GUEST_USER;
 		else
 			misc |= PERF_RECORD_MISC_GUEST_KERNEL;
diff --git a/arch/arm64/kvm/perf.c b/arch/arm64/kvm/perf.c
index a0d660cf889e..dfa9bce8559e 100644
--- a/arch/arm64/kvm/perf.c
+++ b/arch/arm64/kvm/perf.c
@@ -13,39 +13,34 @@
 
 DEFINE_STATIC_KEY_FALSE(kvm_arm_pmu_available);
 
-static int kvm_is_in_guest(void)
+static unsigned int kvm_guest_state(void)
 {
-        return kvm_get_running_vcpu() != NULL;
-}
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
+	unsigned int state;
 
-static int kvm_is_user_mode(void)
-{
-	struct kvm_vcpu *vcpu;
-
-	vcpu = kvm_get_running_vcpu();
+	if (!vcpu)
+		return 0;
 
-	if (vcpu)
-		return !vcpu_mode_priv(vcpu);
+	state = PERF_GUEST_ACTIVE;
+	if (!vcpu_mode_priv(vcpu))
+		state |= PERF_GUEST_USER;
 
-	return 0;
+	return state;
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
-	.is_in_guest	= kvm_is_in_guest,
-	.is_user_mode	= kvm_is_user_mode,
-	.get_guest_ip	= kvm_get_guest_ip,
+	.state		= kvm_guest_state,
+	.get_ip		= kvm_get_guest_ip,
 };
 
 void kvm_perf_init(void)
diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 32cec290d3ad..e29312a1003a 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2772,7 +2772,7 @@ perf_callchain_kernel(struct perf_callchain_entry_ctx *entry, struct pt_regs *re
 	struct unwind_state state;
 	unsigned long addr;
 
-	if (guest_cbs && guest_cbs->is_in_guest()) {
+	if (guest_cbs && guest_cbs->state()) {
 		/* TODO: We don't support guest os callchain now */
 		return;
 	}
@@ -2876,7 +2876,7 @@ perf_callchain_user(struct perf_callchain_entry_ctx *entry, struct pt_regs *regs
 	struct stack_frame frame;
 	const struct stack_frame __user *fp;
 
-	if (guest_cbs && guest_cbs->is_in_guest()) {
+	if (guest_cbs && guest_cbs->state()) {
 		/* TODO: We don't support guest os callchain now */
 		return;
 	}
@@ -2955,8 +2955,8 @@ unsigned long perf_instruction_pointer(struct pt_regs *regs)
 {
 	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
 
-	if (guest_cbs && guest_cbs->is_in_guest())
-		return guest_cbs->get_guest_ip();
+	if (guest_cbs && guest_cbs->state())
+		return guest_cbs->get_ip();
 
 	return regs->ip + code_segment_base(regs);
 }
@@ -2964,10 +2964,11 @@ unsigned long perf_instruction_pointer(struct pt_regs *regs)
 unsigned long perf_misc_flags(struct pt_regs *regs)
 {
 	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
+	unsigned int guest_state = guest_cbs ? guest_cbs->state() : 0;
 	int misc = 0;
 
-	if (guest_cbs && guest_cbs->is_in_guest()) {
-		if (guest_cbs->is_user_mode())
+	if (guest_state) {
+		if (guest_state & PERF_GUEST_USER)
 			misc |= PERF_RECORD_MISC_GUEST_USER;
 		else
 			misc |= PERF_RECORD_MISC_GUEST_KERNEL;
diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index cde29bd5bb53..24adbd6282d4 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2906,10 +2906,7 @@ static int handle_pmi_common(struct pt_regs *regs, u64 status)
 		handled++;
 
 		guest_cbs = perf_get_guest_cbs();
-		if (unlikely(guest_cbs && guest_cbs->is_in_guest() &&
-			     guest_cbs->handle_intel_pt_intr))
-			guest_cbs->handle_intel_pt_intr();
-		else
+		if (likely(!guest_cbs || !guest_cbs->handle_intel_pt_intr()))
 			intel_pt_interrupt();
 	}
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index bf0a9ce53750..112ffb355552 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1893,7 +1893,7 @@ int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu);
 int kvm_complete_insn_gp(struct kvm_vcpu *vcpu, int err);
 void __kvm_request_immediate_exit(struct kvm_vcpu *vcpu);
 
-int kvm_is_in_guest(void);
+unsigned int kvm_guest_state(void);
 
 void __user *__x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa,
 				     u32 size);
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 0772bad9165c..5b68d4188de0 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -87,7 +87,7 @@ static void kvm_perf_overflow_intr(struct perf_event *perf_event,
 		 * woken up. So we should wake it, but this is impossible from
 		 * NMI context. Do it from irq work instead.
 		 */
-		if (!kvm_is_in_guest())
+		if (!kvm_guest_state())
 			irq_work_queue(&pmc_to_pmu(pmc)->irq_work);
 		else
 			kvm_make_request(KVM_REQ_PMI, pmc->vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 021d3f5364b2..ceb09d78277e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8413,44 +8413,48 @@ static void kvm_timer_init(void)
 DEFINE_PER_CPU(struct kvm_vcpu *, current_vcpu);
 EXPORT_PER_CPU_SYMBOL_GPL(current_vcpu);
 
-int kvm_is_in_guest(void)
+unsigned int kvm_guest_state(void)
 {
-	return __this_cpu_read(current_vcpu) != NULL;
-}
+	struct kvm_vcpu *vcpu = __this_cpu_read(current_vcpu);
+	unsigned int state;
 
-static int kvm_is_user_mode(void)
-{
-	int user_mode = 3;
+	if (!vcpu)
+		return 0;
 
-	if (__this_cpu_read(current_vcpu))
-		user_mode = static_call(kvm_x86_get_cpl)(__this_cpu_read(current_vcpu));
+	state = PERF_GUEST_ACTIVE;
+	if (static_call(kvm_x86_get_cpl)(vcpu))
+		state |= PERF_GUEST_USER;
 
-	return user_mode != 0;
+	return state;
 }
 
-static unsigned long kvm_get_guest_ip(void)
+static unsigned long kvm_guest_get_ip(void)
 {
-	unsigned long ip = 0;
+	struct kvm_vcpu *vcpu = __this_cpu_read(current_vcpu);
 
-	if (__this_cpu_read(current_vcpu))
-		ip = kvm_rip_read(__this_cpu_read(current_vcpu));
+	if (WARN_ON_ONCE(!vcpu))
+		return 0;
 
-	return ip;
+	return kvm_rip_read(vcpu);
 }
 
-static void kvm_handle_intel_pt_intr(void)
+static unsigned int kvm_handle_intel_pt_intr(void)
 {
 	struct kvm_vcpu *vcpu = __this_cpu_read(current_vcpu);
 
+	/* '0' on failure so that the !PT case can use a RET0 static call. */
+	if (!vcpu)
+		return 0;
+
 	kvm_make_request(KVM_REQ_PMI, vcpu);
 	__set_bit(MSR_CORE_PERF_GLOBAL_OVF_CTRL_TRACE_TOPA_PMI_BIT,
 			(unsigned long *)&vcpu->arch.pmu.global_status);
+	return 1;
 }
 
 static struct perf_guest_info_callbacks kvm_guest_cbs = {
-	.is_in_guest		= kvm_is_in_guest,
-	.is_user_mode		= kvm_is_user_mode,
-	.get_guest_ip		= kvm_get_guest_ip,
+	.state			= kvm_guest_state,
+	.get_ip			= kvm_guest_get_ip,
 	.handle_intel_pt_intr	= NULL,
 };
 
diff --git a/arch/x86/xen/pmu.c b/arch/x86/xen/pmu.c
index e13b0b49fcdf..89dd6b1708b0 100644
--- a/arch/x86/xen/pmu.c
+++ b/arch/x86/xen/pmu.c
@@ -413,34 +413,29 @@ int pmu_apic_update(uint32_t val)
 }
 
 /* perf callbacks */
-static int xen_is_in_guest(void)
+static unsigned int xen_guest_state(void)
 {
 	const struct xen_pmu_data *xenpmu_data = get_xenpmu_data();
+	unsigned int state = 0;
 
 	if (!xenpmu_data) {
 		pr_warn_once("%s: pmudata not initialized\n", __func__);
-		return 0;
+		return state;
 	}
 
 	if (!xen_initial_domain() || (xenpmu_data->domain_id >= DOMID_SELF))
-		return 0;
+		return state;
 
-	return 1;
-}
+	state |= PERF_GUEST_ACTIVE;
 
-static int xen_is_user_mode(void)
-{
-	const struct xen_pmu_data *xenpmu_data = get_xenpmu_data();
-
-	if (!xenpmu_data) {
-		pr_warn_once("%s: pmudata not initialized\n", __func__);
-		return 0;
+	if (xenpmu_data->pmu.pmu_flags & PMU_SAMPLE_PV) {
+		if (xenpmu_data->pmu.pmu_flags & PMU_SAMPLE_USER)
+			state |= PERF_GUEST_USER;
+	} else if (xenpmu_data->pmu.r.regs.cpl & 3) {
+		state |= PERF_GUEST_USER;
 	}
 
-	if (xenpmu_data->pmu.pmu_flags & PMU_SAMPLE_PV)
-		return (xenpmu_data->pmu.pmu_flags & PMU_SAMPLE_USER);
-	else
-		return !!(xenpmu_data->pmu.r.regs.cpl & 3);
+	return state;
 }
 
 static unsigned long xen_get_guest_ip(void)
@@ -456,9 +451,8 @@ static unsigned long xen_get_guest_ip(void)
 }
 
 static struct perf_guest_info_callbacks xen_guest_cbs = {
-	.is_in_guest            = xen_is_in_guest,
-	.is_user_mode           = xen_is_user_mode,
-	.get_guest_ip           = xen_get_guest_ip,
+	.state                  = xen_guest_state,
+	.get_ip			= xen_get_guest_ip,
 };
 
 /* Convert registers from Xen's format to Linux' */
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 98c204488496..5e6b346d62a7 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -26,11 +26,13 @@
 # include <asm/local64.h>
 #endif
 
+#define PERF_GUEST_ACTIVE	0x01
+#define PERF_GUEST_USER	0x02
+
 struct perf_guest_info_callbacks {
-	int				(*is_in_guest)(void);
-	int				(*is_user_mode)(void);
-	unsigned long			(*get_guest_ip)(void);
-	void				(*handle_intel_pt_intr)(void);
+	unsigned int			(*state)(void);
+	unsigned long			(*get_ip)(void);
+	unsigned int			(*handle_intel_pt_intr)(void);
 };
 
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
-- 
2.34.0.rc0.344.g81b53c2807-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

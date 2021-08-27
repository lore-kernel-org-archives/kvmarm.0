Return-Path: <SRS0=jphx=NS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FB3DC4320A
	for <kvmarm@archiver.kernel.org>; Fri, 27 Aug 2021 07:50:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CB25360FD9
	for <kvmarm@archiver.kernel.org>; Fri, 27 Aug 2021 07:50:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CB25360FD9
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C6834B0DB;
	Fri, 27 Aug 2021 03:50:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CNCOvhtxtbUD; Fri, 27 Aug 2021 03:50:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 89B244B13B;
	Fri, 27 Aug 2021 03:49:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 728AA4B0E9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Aug 2021 20:57:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Bija+WdRXXze for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Aug 2021 20:57:54 -0400 (EDT)
Received: from mail-qt1-f202.google.com (mail-qt1-f202.google.com
 [209.85.160.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 752B24B0C9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Aug 2021 20:57:54 -0400 (EDT)
Received: by mail-qt1-f202.google.com with SMTP id
 v28-20020a05622a189cb029028e697f617dso1576593qtc.20
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Aug 2021 17:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=OS7MVkT771frXb6OZKHkckOWNoVo4LUEGjOz8sBcugE=;
 b=OVx3FLznsGaUkZj9+ODRTi7whGbzE/8kn7Gal8CUtZIaL/dYJc2rmQ1qkPOZL3Jkfh
 8LrJ1TSXuykV5OnsMsKzeh/lnCTo7ULEJtk/Ma+pEhnmcr7eVxSmsrJbyuf0LZfHK3mC
 5cTNBxdLyQmksw12D/CFGAYGi8YZhA+2t1yMTfPnInjGwKU/m4C6BX/DXEkZZQHXEg9c
 FER1Z6XZJ/+zGzGlv/1Hbj3FXGvMNEUSscvb2WcAhhf/HSakavpwMxtthLnpWQGFfmMn
 TA2CoC7TInFFLn+Y2y/FwxaHi5RRS6sJJCd4Q8o94I87M30cSUgn5q03sEpbFayyiZ4I
 iPxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=OS7MVkT771frXb6OZKHkckOWNoVo4LUEGjOz8sBcugE=;
 b=qPZT9cXmDOwlPuWFYxBuMH49hCm9+qIaVsKdnTkWA9Yd+Gf72ciotP674RTG6IG12A
 5rwDP1zSe7p7fhrCFujHA4spt6pmVuqmhCqrM7pEhmSynhryIfUMPvBj+3hJuYZMeQfj
 ntFxBZ9YFS9vggRxNThO4F6eqzkZ145X2qXUBrThK/J8w3WvCjQLYC9ZGj0x7Aa4q14H
 JYdYYEP+DrMy5JgSn0CguqXz1bFHLZUX7xxGnj/1uoszhprjkleNMBuOg1/bhN7ldoEM
 BPFAElnih6ecy7fhGzD2idhd8WGaspOzlGRtNtc9SyTtQte3S+7wtUMNeU47mKMwFwM6
 E5ew==
X-Gm-Message-State: AOAM530KY/cfsT4K1/TUExpZng5wgTFZfYntl13yb3Yla7Smk+gmnWig
 K41+eM0cTqj7f0T5lKSydqtbvynSKeQ=
X-Google-Smtp-Source: ABdhPJyQjCRgdbSS93/ZAW+G0XqSUQSjYqI1rf3Efd9pEAO4+ceiCBacRxi/URQ0QYmIDPRPY3Rt4DKN9BU=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:c16c:db05:96b2:1475])
 (user=seanjc job=sendgmr) by 2002:a05:6214:c3:: with SMTP id
 f3mr7297288qvs.1.1630025873996; Thu, 26 Aug 2021 17:57:53 -0700 (PDT)
Date: Thu, 26 Aug 2021 17:57:14 -0700
In-Reply-To: <20210827005718.585190-1-seanjc@google.com>
Message-Id: <20210827005718.585190-12-seanjc@google.com>
Mime-Version: 1.0
References: <20210827005718.585190-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [PATCH 11/15] KVM: x86: Move Intel Processor Trace interrupt handler
 to vmx.c
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

Now that all state needed for VMX's PT interrupt handler is exposed to
vmx.c (specifically the currently running vCPU), move the handler into
vmx.c where it belongs.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/vmx/vmx.c          | 24 +++++++++++++++++++++---
 arch/x86/kvm/x86.c              | 17 -----------------
 virt/kvm/kvm_main.c             |  1 +
 4 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 63553a1f43ee..daa33147650a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1496,7 +1496,6 @@ struct kvm_x86_init_ops {
 	int (*disabled_by_bios)(void);
 	int (*check_processor_compatibility)(void);
 	int (*hardware_setup)(void);
-	bool (*intel_pt_intr_in_guest)(void);
 
 	struct kvm_x86_ops *runtime_ops;
 };
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f08980ef7c44..4665a272249a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7535,6 +7535,8 @@ static void vmx_migrate_timers(struct kvm_vcpu *vcpu)
 
 static void hardware_unsetup(void)
 {
+	kvm_set_intel_pt_intr_handler(NULL);
+
 	if (nested)
 		nested_vmx_hardware_unsetup();
 
@@ -7685,6 +7687,18 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
 };
 
+static void vmx_handle_intel_pt_intr(void)
+{
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
+
+	if (WARN_ON_ONCE(!vcpu))
+		return;
+
+	kvm_make_request(KVM_REQ_PMI, vcpu);
+	__set_bit(MSR_CORE_PERF_GLOBAL_OVF_CTRL_TRACE_TOPA_PMI_BIT,
+			(unsigned long *)&vcpu->arch.pmu.global_status);
+}
+
 static __init void vmx_setup_user_return_msrs(void)
 {
 
@@ -7886,9 +7900,14 @@ static __init int hardware_setup(void)
 	vmx_set_cpu_caps();
 
 	r = alloc_kvm_area();
-	if (r)
+	if (r) {
 		nested_vmx_hardware_unsetup();
-	return r;
+		return r;
+	}
+
+	if (pt_mode == PT_MODE_HOST_GUEST)
+		kvm_set_intel_pt_intr_handler(vmx_handle_intel_pt_intr);
+	return 0;
 }
 
 static struct kvm_x86_init_ops vmx_init_ops __initdata = {
@@ -7896,7 +7915,6 @@ static struct kvm_x86_init_ops vmx_init_ops __initdata = {
 	.disabled_by_bios = vmx_disabled_by_bios,
 	.check_processor_compatibility = vmx_check_processor_compat,
 	.hardware_setup = hardware_setup,
-	.intel_pt_intr_in_guest = vmx_pt_mode_is_host_guest,
 
 	.runtime_ops = &vmx_x86_ops,
 };
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7cb0f04e24ee..11c7a02f839c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8264,18 +8264,6 @@ static void kvm_timer_init(void)
 			  kvmclock_cpu_online, kvmclock_cpu_down_prep);
 }
 
-static void kvm_handle_intel_pt_intr(void)
-{
-	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
-
-	if (WARN_ON_ONCE(!vcpu))
-		return;
-
-	kvm_make_request(KVM_REQ_PMI, vcpu);
-	__set_bit(MSR_CORE_PERF_GLOBAL_OVF_CTRL_TRACE_TOPA_PMI_BIT,
-			(unsigned long *)&vcpu->arch.pmu.global_status);
-}
-
 #ifdef CONFIG_X86_64
 static void pvclock_gtod_update_fn(struct work_struct *work)
 {
@@ -11029,9 +11017,6 @@ int kvm_arch_hardware_setup(void *opaque)
 	memcpy(&kvm_x86_ops, ops->runtime_ops, sizeof(kvm_x86_ops));
 	kvm_ops_static_call_update();
 
-	if (ops->intel_pt_intr_in_guest && ops->intel_pt_intr_in_guest())
-		kvm_set_intel_pt_intr_handler(kvm_handle_intel_pt_intr);
-
 	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
 		supported_xss = 0;
 
@@ -11059,8 +11044,6 @@ int kvm_arch_hardware_setup(void *opaque)
 
 void kvm_arch_hardware_unsetup(void)
 {
-	kvm_set_intel_pt_intr_handler(NULL);
-
 	static_call(kvm_x86_hardware_unsetup)();
 }
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 13c4f58a75e5..e0b1c9386926 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5498,6 +5498,7 @@ void kvm_set_intel_pt_intr_handler(void (*handler)(void))
 {
 	kvm_guest_cbs.handle_intel_pt_intr = handler;
 }
+EXPORT_SYMBOL_GPL(kvm_set_intel_pt_intr_handler);
 
 void kvm_register_perf_callbacks(void)
 {
-- 
2.33.0.259.gc128427fd7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

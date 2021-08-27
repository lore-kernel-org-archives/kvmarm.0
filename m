Return-Path: <SRS0=jphx=NS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C73FC432BE
	for <kvmarm@archiver.kernel.org>; Fri, 27 Aug 2021 07:50:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2E4C360F42
	for <kvmarm@archiver.kernel.org>; Fri, 27 Aug 2021 07:50:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2E4C360F42
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D590B4B103;
	Fri, 27 Aug 2021 03:50:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id k4RfyzJ61XWQ; Fri, 27 Aug 2021 03:50:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C4C494B19D;
	Fri, 27 Aug 2021 03:49:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A4434B10F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Aug 2021 20:58:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2Y2NyNCJCk72 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Aug 2021 20:58:01 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 707BB4B10C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Aug 2021 20:58:01 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id
 h14-20020a0cffce000000b00372ea3f12a5so4836158qvv.9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Aug 2021 17:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=2c1oAfv2K1kK887vDwje5mKOKCy671YkzEKzr6O0AXU=;
 b=dPpwJxjFAEvKqBeQTsJ+sGnKoHCUDoZpaVXefCBRLWJYEAXtYCk1jNkAx1AH1WF/eG
 KIy8x+/4sLPr4zdnDE2egBaEDODhNuwDeZz/fiGkGQbMwDhPfxlGMgiZv4nxwzKTONNP
 w48weamcMEaBWOvZvU5f0I92nygzL+xaBLQUBWTiwbOYY93Mwf2WxDnJ3W/MWHuZSFBN
 ySHOeq9MvFBM04dVoDNrkz77+gPtaH+dN9os6JcQtf1EK0v/gyWblqEXuz9BFALfpRnH
 6isQHkETZn28aDBmE0AV+m14demqlHfQTlvzBRY5XUHPrqkELuVFpgUnkCWViVAkwntu
 hboQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=2c1oAfv2K1kK887vDwje5mKOKCy671YkzEKzr6O0AXU=;
 b=Lb9uZK2N7yGogTgcF4jVxlwUQYMvSaKfh0/uH5Ob3TSmp8VVGQX27cKeINwxeIuLYk
 lHdO/5I9hY3clLNJe41yi/DDckAzFtUokPqL5E34pp/OS+6FeXF2P4toLJxrnHA/TLhD
 O+ZlBfhNZDXZk0EncIWDsr5DK++dc623LoOCcGhEVUY6AuEnt9PtCoi9+l04UYUN0NS3
 ZYaR+73Qh5ah0Z2iZzjJQCyzkPJu5U3BS6IvcyZqiOsg0xBEmwvfNwqQe+iswueq/EcB
 7NQ0o2lb44GE3Ops3vYR6RYwtNsNM/isKc5sR5FQkXp1CKisSPjF2+7Rzb11Ewoy4Aa4
 bu6Q==
X-Gm-Message-State: AOAM533eMQZ/nMdyEw39tw0NCtHiS9JKih+GOe84rjUTHU5DX4s7LAfj
 PgPhTRH8UQJUAf5Nz/XM1z6yIZYYamk=
X-Google-Smtp-Source: ABdhPJyRfoK4Sj+uUxToLmh3g94becc3It6jH8S/y/rUNMio/2OXitmqg6SKQMU8b0uN77qihKZhErMmOqs=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:c16c:db05:96b2:1475])
 (user=seanjc job=sendgmr) by 2002:a0c:aa55:: with SMTP id
 e21mr7179445qvb.41.1630025880952; 
 Thu, 26 Aug 2021 17:58:00 -0700 (PDT)
Date: Thu, 26 Aug 2021 17:57:17 -0700
In-Reply-To: <20210827005718.585190-1-seanjc@google.com>
Message-Id: <20210827005718.585190-15-seanjc@google.com>
Mime-Version: 1.0
References: <20210827005718.585190-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [PATCH 14/15] perf: Disallow bulk unregistering of guest callbacks
 and do cleanup
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

Drop the helper that allows bulk unregistering of the per-CPU callbacks
now that KVM, the only entity that actually unregisters callbacks, uses
the per-CPU helpers.  Bulk unregistering is inherently unsafe as there
are no protections against nullifying a pointer for a CPU that is using
said pointer in a PMI handler.

Opportunistically tweak names to better reflect reality.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/xen/pmu.c         |  2 +-
 include/linux/kvm_host.h   |  2 +-
 include/linux/perf_event.h |  9 +++------
 kernel/events/core.c       | 31 +++++++++++--------------------
 virt/kvm/kvm_main.c        |  2 +-
 5 files changed, 17 insertions(+), 29 deletions(-)

diff --git a/arch/x86/xen/pmu.c b/arch/x86/xen/pmu.c
index e13b0b49fcdf..57834de043c3 100644
--- a/arch/x86/xen/pmu.c
+++ b/arch/x86/xen/pmu.c
@@ -548,7 +548,7 @@ void xen_pmu_init(int cpu)
 	per_cpu(xenpmu_shared, cpu).flags = 0;
 
 	if (cpu == 0) {
-		perf_register_guest_info_callbacks(&xen_guest_cbs);
+		perf_register_guest_info_callbacks_all_cpus(&xen_guest_cbs);
 		xen_pmu_arch_init();
 	}
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 0db9af0b628c..d68a49d5fc53 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1171,7 +1171,7 @@ unsigned long kvm_arch_vcpu_get_ip(struct kvm_vcpu *vcpu);
 void kvm_register_perf_callbacks(void);
 static inline void kvm_unregister_perf_callbacks(void)
 {
-	__perf_unregister_guest_info_callbacks();
+	perf_unregister_guest_info_callbacks();
 }
 #endif
 
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 7a367bf1b78d..db701409a62f 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1238,10 +1238,9 @@ extern void perf_event_bpf_event(struct bpf_prog *prog,
 
 #ifdef CONFIG_HAVE_GUEST_PERF_EVENTS
 DECLARE_PER_CPU(struct perf_guest_info_callbacks *, perf_guest_cbs);
-extern void __perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *cbs);
-extern void __perf_unregister_guest_info_callbacks(void);
-extern void perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *callbacks);
+extern void perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *cbs);
 extern void perf_unregister_guest_info_callbacks(void);
+extern void perf_register_guest_info_callbacks_all_cpus(struct perf_guest_info_callbacks *cbs);
 #endif /* CONFIG_HAVE_GUEST_PERF_EVENTS */
 
 extern void perf_event_exec(void);
@@ -1486,9 +1485,7 @@ static inline void
 perf_bp_event(struct perf_event *event, void *data)			{ }
 
 #ifdef CONFIG_HAVE_GUEST_PERF_EVENTS
-static inline void perf_register_guest_info_callbacks
-(struct perf_guest_info_callbacks *callbacks)				{ }
-static inline void perf_unregister_guest_info_callbacks(void)		{ }
+extern void perf_register_guest_info_callbacks_all_cpus(struct perf_guest_info_callbacks *cbs);
 #endif
 
 static inline void perf_event_mmap(struct vm_area_struct *vma)		{ }
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 2f28d9d8dc94..f1964096c4c2 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6485,35 +6485,26 @@ static void perf_pending_event(struct irq_work *entry)
 #ifdef CONFIG_HAVE_GUEST_PERF_EVENTS
 DEFINE_PER_CPU(struct perf_guest_info_callbacks *, perf_guest_cbs);
 
-void __perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
-{
-	__this_cpu_write(perf_guest_cbs, cbs);
-}
-EXPORT_SYMBOL_GPL(__perf_register_guest_info_callbacks);
-
-void __perf_unregister_guest_info_callbacks(void)
-{
-	__this_cpu_write(perf_guest_cbs, NULL);
-}
-EXPORT_SYMBOL_GPL(__perf_unregister_guest_info_callbacks);
-
 void perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
 {
-	int cpu;
-
-	for_each_possible_cpu(cpu)
-		per_cpu(perf_guest_cbs, cpu) = cbs;
+	__this_cpu_write(perf_guest_cbs, cbs);
 }
 EXPORT_SYMBOL_GPL(perf_register_guest_info_callbacks);
 
 void perf_unregister_guest_info_callbacks(void)
 {
-	int cpu;
-
-	for_each_possible_cpu(cpu)
-		per_cpu(perf_guest_cbs, cpu) = NULL;
+	__this_cpu_write(perf_guest_cbs, NULL);
 }
 EXPORT_SYMBOL_GPL(perf_unregister_guest_info_callbacks);
+
+void perf_register_guest_info_callbacks_all_cpus(struct perf_guest_info_callbacks *cbs)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		per_cpu(perf_guest_cbs, cpu) = cbs;
+}
+EXPORT_SYMBOL_GPL(perf_register_guest_info_callbacks_all_cpus);
 #endif
 
 static void
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e0b1c9386926..1bcc3eab510b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5502,7 +5502,7 @@ EXPORT_SYMBOL_GPL(kvm_set_intel_pt_intr_handler);
 
 void kvm_register_perf_callbacks(void)
 {
-	__perf_register_guest_info_callbacks(&kvm_guest_cbs);
+	perf_register_guest_info_callbacks(&kvm_guest_cbs);
 }
 EXPORT_SYMBOL_GPL(kvm_register_perf_callbacks);
 #endif
-- 
2.33.0.259.gc128427fd7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

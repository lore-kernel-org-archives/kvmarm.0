Return-Path: <SRS0=nF4w=P6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 614A6C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 11 Nov 2021 02:08:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F020161073
	for <kvmarm@archiver.kernel.org>; Thu, 11 Nov 2021 02:08:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org F020161073
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A51574B239;
	Wed, 10 Nov 2021 21:08:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id b66CkhU4pYIG; Wed, 10 Nov 2021 21:08:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 02E034B259;
	Wed, 10 Nov 2021 21:07:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C52314B1E4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 21:07:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id b7wVGUc96kKn for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Nov 2021 21:07:55 -0500 (EST)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 17B224B220
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 21:07:55 -0500 (EST)
Received: by mail-pf1-f201.google.com with SMTP id
 z187-20020a6233c4000000b0047c2090f1abso2998591pfz.23
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 18:07:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=Qts44yZaW6qsc605OlT7Zz8eai+zBrqGoLbFoG4wiuw=;
 b=Zfi8DY3ovwoiH8lfWrxLb/W+rRSaGWbn2rFa446dfUQXHgUbfdUKYMOyW1lpuH1MR+
 xW8LXXYpKTlc7ug96G/Ee8ToPnPuFjZ6+ZvcCvMBWtEmqhdQ3/vNbJyBdjGJwYQJnBZp
 eg5ocwliNalXx19wDw7gg6hx7kfIvpSxscV8PzvnOb5EfIXw0M0nS4wd8cy4vSyQ7D8r
 47B+6iKMQq7yLKce9j9o6wFmrE8KChMVlSCYvT0NoUscJKcLP0B0byJ9BhCQP5AmwJDt
 Xn99jo+MhAsbr7g8NKvRMpjQUhyAw5fqNt4uJCKa9oaEyT74/pPuTXuqJFQjVL14748I
 xNkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=Qts44yZaW6qsc605OlT7Zz8eai+zBrqGoLbFoG4wiuw=;
 b=6IN+vlGHlivvryKP8G9750BVPDgFEu6exTeeUaSRM37iWUMY0Aj6qV17XWezyfICw4
 jHHrMyaZtHGgrZAdvWuGx8CrIRVMIEtyH1EvBaFGdp7Txy8e8qEs2VTTu9nBf3wgcDf6
 cJlVGSrgX7Gc3EI6rDylWCYr2+M4YfGYVzdFrcXp67fQMrgKP9wO34rBuWH0KTaVDyVy
 suAnVexkwu6GN5aqaGQ5h13zbG/Aozx9fLAlzlPhIfG+ap3MiexGaiSGfsSS5OpNNrex
 z4nY/NU8J+ilE2IOHyyobDZwdE1hEKnZvJIeie/6Rhb/OZ2imR1DdvTxDVlDX3NkpgUI
 LKPg==
X-Gm-Message-State: AOAM530sw/st3fqz37MB4ToKu4UtudFHSN40V2Qqx1rS6S5BloVfuCzt
 XJGZ8ssmCKtEw+l+hIl9OELsqkOcLPo=
X-Google-Smtp-Source: ABdhPJzzaoFWeNToP2f/V/MLS8kOItNfusQJva0ujL0AlnvrfyJ7uCasThKDANgj3halkP9yaN2IQPCiXvk=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:8544:b0:142:66e7:afbb
 with SMTP id
 d4-20020a170902854400b0014266e7afbbmr3818315plo.62.1636596474245; Wed, 10 Nov
 2021 18:07:54 -0800 (PST)
Date: Thu, 11 Nov 2021 02:07:29 +0000
In-Reply-To: <20211111020738.2512932-1-seanjc@google.com>
Message-Id: <20211111020738.2512932-9-seanjc@google.com>
Mime-Version: 1.0
References: <20211111020738.2512932-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH v4 08/17] perf: Force architectures to opt-in to guest
 callbacks
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

Introduce GUEST_PERF_EVENTS and require architectures to select it to
allow registering and using guest callbacks in perf.  This will hopefully
make it more difficult for new architectures to add useless "support" for
guest callbacks, e.g. via copy+paste.

Stubbing out the helpers has the happy bonus of avoiding a load of
perf_guest_cbs when GUEST_PERF_EVENTS=n on arm64/x86.

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/Kconfig     | 1 +
 arch/x86/kvm/Kconfig       | 1 +
 arch/x86/xen/Kconfig       | 1 +
 include/linux/perf_event.h | 6 ++++++
 init/Kconfig               | 4 ++++
 kernel/events/core.c       | 2 ++
 6 files changed, 15 insertions(+)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 8ffcbe29395e..e9761d84f982 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -39,6 +39,7 @@ menuconfig KVM
 	select HAVE_KVM_IRQ_BYPASS
 	select HAVE_KVM_VCPU_RUN_PID_CHANGE
 	select SCHED_INFO
+	select GUEST_PERF_EVENTS if PERF_EVENTS
 	help
 	  Support hosting virtualized guest machines.
 
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 619186138176..47bdbe705a76 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -36,6 +36,7 @@ config KVM
 	select KVM_MMIO
 	select SCHED_INFO
 	select PERF_EVENTS
+	select GUEST_PERF_EVENTS
 	select HAVE_KVM_MSI
 	select HAVE_KVM_CPU_RELAX_INTERCEPT
 	select HAVE_KVM_NO_POLL
diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
index 6bcd3d8ca6ac..85246dd9faa1 100644
--- a/arch/x86/xen/Kconfig
+++ b/arch/x86/xen/Kconfig
@@ -23,6 +23,7 @@ config XEN_PV
 	select PARAVIRT_XXL
 	select XEN_HAVE_PVMMU
 	select XEN_HAVE_VPMU
+	select GUEST_PERF_EVENTS
 	help
 	  Support running as a Xen PV guest.
 
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 346d5aff5804..ea47ef616ee0 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1242,6 +1242,7 @@ extern void perf_event_bpf_event(struct bpf_prog *prog,
 				 enum perf_bpf_event_type type,
 				 u16 flags);
 
+#ifdef CONFIG_GUEST_PERF_EVENTS
 extern struct perf_guest_info_callbacks __rcu *perf_guest_cbs;
 static inline struct perf_guest_info_callbacks *perf_get_guest_cbs(void)
 {
@@ -1280,6 +1281,11 @@ static inline unsigned int perf_guest_handle_intel_pt_intr(void)
 }
 extern void perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *cbs);
 extern void perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *cbs);
+#else
+static inline unsigned int perf_guest_state(void)		 { return 0; }
+static inline unsigned long perf_guest_get_ip(void)		 { return 0; }
+static inline unsigned int perf_guest_handle_intel_pt_intr(void) { return 0; }
+#endif /* CONFIG_GUEST_PERF_EVENTS */
 
 extern void perf_event_exec(void);
 extern void perf_event_comm(struct task_struct *tsk, bool exec);
diff --git a/init/Kconfig b/init/Kconfig
index 21b1f4870c80..6bc5c56d669b 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1799,6 +1799,10 @@ config HAVE_PERF_EVENTS
 	help
 	  See tools/perf/design.txt for details.
 
+config GUEST_PERF_EVENTS
+	bool
+	depends on HAVE_PERF_EVENTS
+
 config PERF_USE_VMALLOC
 	bool
 	help
diff --git a/kernel/events/core.c b/kernel/events/core.c
index eb6b9cfd0054..1c8d341ecc77 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6521,6 +6521,7 @@ static void perf_pending_event(struct irq_work *entry)
 		perf_swevent_put_recursion_context(rctx);
 }
 
+#ifdef CONFIG_GUEST_PERF_EVENTS
 struct perf_guest_info_callbacks __rcu *perf_guest_cbs;
 
 void perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
@@ -6541,6 +6542,7 @@ void perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
 	synchronize_rcu();
 }
 EXPORT_SYMBOL_GPL(perf_unregister_guest_info_callbacks);
+#endif
 
 static void
 perf_output_sample_regs(struct perf_output_handle *handle,
-- 
2.34.0.rc0.344.g81b53c2807-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

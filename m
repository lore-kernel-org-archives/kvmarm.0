Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04126241696
	for <kvmarm@lists.linux.dev>; Sat,  6 Dec 2025 00:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764980265; cv=none; b=AG80wjwodia36topLlvd5b2sGDxSfxrzZNFb81K5L01itG4lRluwX/4NMI4nK0X3w7vK2Fn/edMtKD5S35/shos+CdoqQ/LGivvU9NHi9KgJzGsBbNIJrYEcq27L1aPL8IRxQ/xVZciaRpADyYc5a2mLrmLghdCnQhySPd6Pt6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764980265; c=relaxed/simple;
	bh=B07Fi36gCg2XTPk4IcpSxpRfsJ0d9shcamMYXeoKIbg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=M36n7/01E+nWwvamlmGp3UPZuKdYJvazxjnbfBiaYHaDywkHzoSbA+PRii4oBqwSDA6gBaMQ9ylTQ+RuDkeiIWGBewVXWvs17PHBLAxnwls6RhVFNLa+kO4+AsvCbC4m7oZpYOSHGXiCDYISWmLlGGdhBEcO1540amX27eCx9CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kri/TXwT; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kri/TXwT"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2958a134514so38064115ad.2
        for <kvmarm@lists.linux.dev>; Fri, 05 Dec 2025 16:17:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764980262; x=1765585062; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=PaAEczJn56g6j7l3T/bJJIloWLF69FMD1cy8Jo+0lXA=;
        b=kri/TXwTN7qlfBRdlshlS3Zy531VxVzyJgn6rhb6T4ymJLowcxrJbXIzmVUzk9pmdL
         E+dYZGOitlKQXqNswJ4EtTNnBIFie3StxyyijQszclhE/bKMtpdioIg9m+/n2zcJGOAA
         GQ8Bln9kFg4+JCyHEQBr/LvzCHkkaQsRQQkzgfbxiprQiTXaKSxMIfBTzhpJCe9vwUfP
         AUqIflFioBtJZT2xEm5lxKVq3BA9YFmRjm5j+kyRRgrGIS4MuzagF/Ie5gqg/4cG3RuD
         CtXTt6ARGxcS/qtjk6oyu1dC6G8ZPpB+ST+0AQUci0PEKNRKfUT5eMWJZDE45P/HPGm9
         EXkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764980262; x=1765585062;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PaAEczJn56g6j7l3T/bJJIloWLF69FMD1cy8Jo+0lXA=;
        b=sntArqArkqdIBAkOEyegdWPD9aRyMgiIyPf78iwxb8mFK6XCzOni4f99iMr4vq/acN
         /GZDZq0JcqCH5bbrvEk8eryMDrYtUBS+F6skcd8rfJr8/r+XuRf+9UX77xN8QNBnrMpS
         Qi66leCHbwIJLMRIkB/EgtxG/UR8d2lLEPD7lbh1iTR1Pu0ta7NIQep97M88UmYHaaCV
         g7XREq0JcA40hb1AxsSWhKUMB46A+4rLwyhTZxx0YfGHOeawsfxgN6ldptw5VqVkIU0+
         oAApTt1+LsW52zHJAfzIlwsDT9ugcWOPwnpuOfpoWjlyjcqrPjFLUgaAbCSFaDQI0nnS
         EGLw==
X-Forwarded-Encrypted: i=1; AJvYcCWwbN6hQ7gDeWe+guzWPKlBdF5lBMhvZwthu9Lqld+R66loGeJ6zpYZRxrTTyEhIY+AEXTrmmM=@lists.linux.dev
X-Gm-Message-State: AOJu0YwVsGTbutt9JzK3mp0z7E7243VbuHgFXmDAfCRuiunC/J5Fg2uD
	x7rnwUn2AoyZ1jyTTlF1sL2pGgF8fjI6x/H8JllfyFO4jcf2iqG4vnqKHlm57dRL727r7qBKnxl
	XqyP2lA==
X-Google-Smtp-Source: AGHT+IE66BT/6tJmA7onHYrZQVP4Upgb8o2eySO9j5HzT7TCLlKWVMyzuwZuW9b+NVrzVgC1varHiz4graE=
X-Received: from plbmf12.prod.google.com ([2002:a17:902:fc8c:b0:295:2d28:1242])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ef4d:b0:299:e031:173
 with SMTP id d9443c01a7336-29df610f3f7mr7047655ad.35.1764980262067; Fri, 05
 Dec 2025 16:17:42 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 16:16:44 -0800
In-Reply-To: <20251206001720.468579-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251206001720.468579-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251206001720.468579-9-seanjc@google.com>
Subject: [PATCH v6 08/44] perf/x86/core: Register a new vector for handling
 mediated guest PMIs
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, Mingwei Zhang <mizhang@google.com>, 
	Xudong Hao <xudong.hao@intel.com>, Sandipan Das <sandipan.das@amd.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Wire up system vector 0xf5 for handling PMIs (i.e. interrupts delivered
through the LVTPC) while running KVM guests with a mediated PMU.  Perf
currently delivers all PMIs as NMIs, e.g. so that events that trigger while
IRQs are disabled aren't delayed and generate useless records, but due to
the multiplexing of NMIs throughout the system, correctly identifying NMIs
for a mediated PMU is practically infeasible.

To (greatly) simplify identifying guest mediated PMU PMIs, perf will
switch the CPU's LVTPC between PERF_GUEST_MEDIATED_PMI_VECTOR and NMI when
guest PMU context is loaded/put.  I.e. PMIs that are generated by the CPU
while the guest is active will be identified purely based on the IRQ
vector.

Route the vector through perf, e.g. as opposed to letting KVM attach a
handler directly a la posted interrupt notification vectors, as perf owns
the LVTPC and thus is the rightful owner of PERF_GUEST_MEDIATED_PMI_VECTOR.
Functionally, having KVM directly own the vector would be fine (both KVM
and perf will be completely aware of when a mediated PMU is active), but
would lead to an undesirable split in ownership: perf would be responsible
for installing the vector, but not handling the resulting IRQs.

Add a new perf_guest_info_callbacks hook (and static call) to allow KVM to
register its handler with perf when running guests with mediated PMUs.

Note, because KVM always runs guests with host IRQs enabled, there is no
danger of a PMI being delayed from the guest's perspective due to using a
regular IRQ instead of an NMI.

Tested-by: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/entry/entry_fred.c                   |  1 +
 arch/x86/include/asm/hardirq.h                |  3 +++
 arch/x86/include/asm/idtentry.h               |  6 ++++++
 arch/x86/include/asm/irq_vectors.h            |  4 +++-
 arch/x86/kernel/idt.c                         |  3 +++
 arch/x86/kernel/irq.c                         | 19 +++++++++++++++++++
 include/linux/perf_event.h                    |  8 ++++++++
 kernel/events/core.c                          |  9 +++++++--
 .../beauty/arch/x86/include/asm/irq_vectors.h |  3 ++-
 virt/kvm/kvm_main.c                           |  3 +++
 10 files changed, 55 insertions(+), 4 deletions(-)

diff --git a/arch/x86/entry/entry_fred.c b/arch/x86/entry/entry_fred.c
index f004a4dc74c2..d80861a4cd00 100644
--- a/arch/x86/entry/entry_fred.c
+++ b/arch/x86/entry/entry_fred.c
@@ -114,6 +114,7 @@ static idtentry_t sysvec_table[NR_SYSTEM_VECTORS] __ro_after_init = {
 
 	SYSVEC(IRQ_WORK_VECTOR,			irq_work),
 
+	SYSVEC(PERF_GUEST_MEDIATED_PMI_VECTOR,	perf_guest_mediated_pmi_handler),
 	SYSVEC(POSTED_INTR_VECTOR,		kvm_posted_intr_ipi),
 	SYSVEC(POSTED_INTR_WAKEUP_VECTOR,	kvm_posted_intr_wakeup_ipi),
 	SYSVEC(POSTED_INTR_NESTED_VECTOR,	kvm_posted_intr_nested_ipi),
diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index 6b6d472baa0b..9314642ae93c 100644
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -18,6 +18,9 @@ typedef struct {
 	unsigned int kvm_posted_intr_ipis;
 	unsigned int kvm_posted_intr_wakeup_ipis;
 	unsigned int kvm_posted_intr_nested_ipis;
+#endif
+#ifdef CONFIG_GUEST_PERF_EVENTS
+	unsigned int perf_guest_mediated_pmis;
 #endif
 	unsigned int x86_platform_ipis;	/* arch dependent */
 	unsigned int apic_perf_irqs;
diff --git a/arch/x86/include/asm/idtentry.h b/arch/x86/include/asm/idtentry.h
index abd637e54e94..e64294c906bc 100644
--- a/arch/x86/include/asm/idtentry.h
+++ b/arch/x86/include/asm/idtentry.h
@@ -746,6 +746,12 @@ DECLARE_IDTENTRY_SYSVEC(POSTED_INTR_NESTED_VECTOR,	sysvec_kvm_posted_intr_nested
 # define fred_sysvec_kvm_posted_intr_nested_ipi		NULL
 #endif
 
+# ifdef CONFIG_GUEST_PERF_EVENTS
+DECLARE_IDTENTRY_SYSVEC(PERF_GUEST_MEDIATED_PMI_VECTOR,	sysvec_perf_guest_mediated_pmi_handler);
+#else
+# define fred_sysvec_perf_guest_mediated_pmi_handler	NULL
+#endif
+
 # ifdef CONFIG_X86_POSTED_MSI
 DECLARE_IDTENTRY_SYSVEC(POSTED_MSI_NOTIFICATION_VECTOR,	sysvec_posted_msi_notification);
 #else
diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 47051871b436..85253fc8e384 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -77,7 +77,9 @@
  */
 #define IRQ_WORK_VECTOR			0xf6
 
-/* 0xf5 - unused, was UV_BAU_MESSAGE */
+/* IRQ vector for PMIs when running a guest with a mediated PMU. */
+#define PERF_GUEST_MEDIATED_PMI_VECTOR	0xf5
+
 #define DEFERRED_ERROR_VECTOR		0xf4
 
 /* Vector on which hypervisor callbacks will be delivered */
diff --git a/arch/x86/kernel/idt.c b/arch/x86/kernel/idt.c
index f445bec516a0..260456588756 100644
--- a/arch/x86/kernel/idt.c
+++ b/arch/x86/kernel/idt.c
@@ -158,6 +158,9 @@ static const __initconst struct idt_data apic_idts[] = {
 	INTG(POSTED_INTR_WAKEUP_VECTOR,		asm_sysvec_kvm_posted_intr_wakeup_ipi),
 	INTG(POSTED_INTR_NESTED_VECTOR,		asm_sysvec_kvm_posted_intr_nested_ipi),
 # endif
+#ifdef CONFIG_GUEST_PERF_EVENTS
+	INTG(PERF_GUEST_MEDIATED_PMI_VECTOR,	asm_sysvec_perf_guest_mediated_pmi_handler),
+#endif
 # ifdef CONFIG_IRQ_WORK
 	INTG(IRQ_WORK_VECTOR,			asm_sysvec_irq_work),
 # endif
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 10721a125226..e9050e69717e 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -191,6 +191,13 @@ int arch_show_interrupts(struct seq_file *p, int prec)
 			   irq_stats(j)->kvm_posted_intr_wakeup_ipis);
 	seq_puts(p, "  Posted-interrupt wakeup event\n");
 #endif
+#ifdef CONFIG_GUEST_PERF_EVENTS
+	seq_printf(p, "%*s: ", prec, "VPMI");
+	for_each_online_cpu(j)
+		seq_printf(p, "%10u ",
+			   irq_stats(j)->perf_guest_mediated_pmis);
+	seq_puts(p, " Perf Guest Mediated PMI\n");
+#endif
 #ifdef CONFIG_X86_POSTED_MSI
 	seq_printf(p, "%*s: ", prec, "PMN");
 	for_each_online_cpu(j)
@@ -348,6 +355,18 @@ DEFINE_IDTENTRY_SYSVEC(sysvec_x86_platform_ipi)
 }
 #endif
 
+#ifdef CONFIG_GUEST_PERF_EVENTS
+/*
+ * Handler for PERF_GUEST_MEDIATED_PMI_VECTOR.
+ */
+DEFINE_IDTENTRY_SYSVEC(sysvec_perf_guest_mediated_pmi_handler)
+{
+	 apic_eoi();
+	 inc_irq_stat(perf_guest_mediated_pmis);
+	 perf_guest_handle_mediated_pmi();
+}
+#endif
+
 #if IS_ENABLED(CONFIG_KVM)
 static void dummy_handler(void) {}
 static void (*kvm_posted_intr_wakeup_handler)(void) = dummy_handler;
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index cfc8cd86c409..9abfca6cf655 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1677,6 +1677,8 @@ struct perf_guest_info_callbacks {
 	unsigned int			(*state)(void);
 	unsigned long			(*get_ip)(void);
 	unsigned int			(*handle_intel_pt_intr)(void);
+
+	void				(*handle_mediated_pmi)(void);
 };
 
 #ifdef CONFIG_GUEST_PERF_EVENTS
@@ -1686,6 +1688,7 @@ extern struct perf_guest_info_callbacks __rcu *perf_guest_cbs;
 DECLARE_STATIC_CALL(__perf_guest_state, *perf_guest_cbs->state);
 DECLARE_STATIC_CALL(__perf_guest_get_ip, *perf_guest_cbs->get_ip);
 DECLARE_STATIC_CALL(__perf_guest_handle_intel_pt_intr, *perf_guest_cbs->handle_intel_pt_intr);
+DECLARE_STATIC_CALL(__perf_guest_handle_mediated_pmi, *perf_guest_cbs->handle_mediated_pmi);
 
 static inline unsigned int perf_guest_state(void)
 {
@@ -1702,6 +1705,11 @@ static inline unsigned int perf_guest_handle_intel_pt_intr(void)
 	return static_call(__perf_guest_handle_intel_pt_intr)();
 }
 
+static inline void perf_guest_handle_mediated_pmi(void)
+{
+	static_call(__perf_guest_handle_mediated_pmi)();
+}
+
 extern void perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *cbs);
 extern void perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *cbs);
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 81c35859e6ea..c6368c64b866 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7645,6 +7645,7 @@ struct perf_guest_info_callbacks __rcu *perf_guest_cbs;
 DEFINE_STATIC_CALL_RET0(__perf_guest_state, *perf_guest_cbs->state);
 DEFINE_STATIC_CALL_RET0(__perf_guest_get_ip, *perf_guest_cbs->get_ip);
 DEFINE_STATIC_CALL_RET0(__perf_guest_handle_intel_pt_intr, *perf_guest_cbs->handle_intel_pt_intr);
+DEFINE_STATIC_CALL_RET0(__perf_guest_handle_mediated_pmi, *perf_guest_cbs->handle_mediated_pmi);
 
 void perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
 {
@@ -7659,6 +7660,10 @@ void perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
 	if (cbs->handle_intel_pt_intr)
 		static_call_update(__perf_guest_handle_intel_pt_intr,
 				   cbs->handle_intel_pt_intr);
+
+	if (cbs->handle_mediated_pmi)
+		static_call_update(__perf_guest_handle_mediated_pmi,
+				   cbs->handle_mediated_pmi);
 }
 EXPORT_SYMBOL_GPL(perf_register_guest_info_callbacks);
 
@@ -7670,8 +7675,8 @@ void perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
 	rcu_assign_pointer(perf_guest_cbs, NULL);
 	static_call_update(__perf_guest_state, (void *)&__static_call_return0);
 	static_call_update(__perf_guest_get_ip, (void *)&__static_call_return0);
-	static_call_update(__perf_guest_handle_intel_pt_intr,
-			   (void *)&__static_call_return0);
+	static_call_update(__perf_guest_handle_intel_pt_intr, (void *)&__static_call_return0);
+	static_call_update(__perf_guest_handle_mediated_pmi, (void *)&__static_call_return0);
 	synchronize_rcu();
 }
 EXPORT_SYMBOL_GPL(perf_unregister_guest_info_callbacks);
diff --git a/tools/perf/trace/beauty/arch/x86/include/asm/irq_vectors.h b/tools/perf/trace/beauty/arch/x86/include/asm/irq_vectors.h
index 47051871b436..6e1d5b955aae 100644
--- a/tools/perf/trace/beauty/arch/x86/include/asm/irq_vectors.h
+++ b/tools/perf/trace/beauty/arch/x86/include/asm/irq_vectors.h
@@ -77,7 +77,8 @@
  */
 #define IRQ_WORK_VECTOR			0xf6
 
-/* 0xf5 - unused, was UV_BAU_MESSAGE */
+#define PERF_GUEST_MEDIATED_PMI_VECTOR	0xf5
+
 #define DEFERRED_ERROR_VECTOR		0xf4
 
 /* Vector on which hypervisor callbacks will be delivered */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f1f6a71b2b5f..4954cbbb05e8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -6471,11 +6471,14 @@ static struct perf_guest_info_callbacks kvm_guest_cbs = {
 	.state			= kvm_guest_state,
 	.get_ip			= kvm_guest_get_ip,
 	.handle_intel_pt_intr	= NULL,
+	.handle_mediated_pmi	= NULL,
 };
 
 void kvm_register_perf_callbacks(unsigned int (*pt_intr_handler)(void))
 {
 	kvm_guest_cbs.handle_intel_pt_intr = pt_intr_handler;
+	kvm_guest_cbs.handle_mediated_pmi = NULL;
+
 	perf_register_guest_info_callbacks(&kvm_guest_cbs);
 }
 void kvm_unregister_perf_callbacks(void)
-- 
2.52.0.223.gf5cc29aaa4-goog


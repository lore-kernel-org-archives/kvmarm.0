Return-Path: <SRS0=n474=OM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BC56C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 13:12:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D52D2611C6
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 13:12:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D52D2611C6
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 856E34B13D;
	Wed, 22 Sep 2021 09:12:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jkGzfHyi7Dm7; Wed, 22 Sep 2021 09:12:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 23DC24B1C7;
	Wed, 22 Sep 2021 09:11:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B8BEF402DB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 20:06:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BxGDlCqlFU8n for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Sep 2021 20:06:05 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AD9EF40573
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 20:06:05 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id
 h9-20020a05621413a900b0037a2d3eaf8fso7928475qvz.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 17:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=AVVcTJjDaboxmrWd01mlihP+thyDmwt+Wb6UJcWJ0SA=;
 b=qnB3SQiaaF6WC9mC3PxEeBeR+5lv1WF2OZ5dAEYuga9do3ZxizL42FhUWbNnGQsLJy
 kFlr7gl1wrMF1pi+KoC28DCxMnwiq7dfm7LkdmgwbfFIj+yZF87g+RiucCIIlaGk9z2L
 ul3JXkYMG1M7a8Mo36cpf3Rry/Wo1HIBeW17Zi62PJjYFnKdmXhaubK0jiBQ5d6UqeTU
 1+L7Uftzwd0fGoYUuho0kFZqMWYiIl8q0A+4IRcVGFEDRYPi1z57sEg8moGTEmHEg6dI
 5vqXyNGrS9ZLp2cByIwk1QgXLXs643+yydpAgPnozKp/YE6+BzivoiQrohhBs0bP0EIW
 FUEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=AVVcTJjDaboxmrWd01mlihP+thyDmwt+Wb6UJcWJ0SA=;
 b=TdGOLh9zbGUc9wiJZPowwAIgmANeeIgL3gw+JMqbCROgEz6iQ7N7evVFrBUa9VQ89j
 cSRaxcXY13WhCROLShydhQJIlojrc1bDRX4vGlXbe7UAdVoTEf0wM4VaK2mvx6E9TS1j
 BkzxknekP2s3j9hOzLRAMPnkGdThz9YC8zeSWgnr6V5c1yFisykuJtdVTTE42lWGmsiE
 9Oh+koDjerkYKDFLjmdXjprAFJTfnHxX8Pn4/mjGv2AGaSdnO8zT44Ozv3ocy925AKSp
 U1VSqWS+8ioW2vRKWCYC0waMxoVHYAvisYBM0DRWPVKnF+HP/b5QKoMsPniwIYU1qFh0
 rvvQ==
X-Gm-Message-State: AOAM533VOdpdXMrtO5mV+RLvIAnvOzfaMbR5Qptyq+zNQqtGmtm7KxAJ
 AXpE0tqxWJORb/tEeWZv2MihPJbZPVI=
X-Google-Smtp-Source: ABdhPJx1BhnGeS4TuFK4bgjBOJbTLeLAb6P4HGUosvLJGU/FqZfGimhs446IdcpbQjbCIE0AbY4YgA9+Mxg=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:b022:92d6:d37b:686c])
 (user=seanjc job=sendgmr) by 2002:a05:6214:1430:: with SMTP id
 o16mr30643490qvx.66.1632269165263; Tue, 21 Sep 2021 17:06:05 -0700 (PDT)
Date: Tue, 21 Sep 2021 17:05:27 -0700
In-Reply-To: <20210922000533.713300-1-seanjc@google.com>
Message-Id: <20210922000533.713300-11-seanjc@google.com>
Mime-Version: 1.0
References: <20210922000533.713300-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v3 10/16] KVM: x86: Drop current_vcpu for kvm_running_vcpu +
 kvm_arch_vcpu variable
From: Sean Christopherson <seanjc@google.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, 
 Marc Zyngier <maz@kernel.org>, Guo Ren <guoren@kernel.org>,
 Nick Hu <nickhu@andestech.com>, 
 Greentime Hu <green.hu@gmail.com>, Vincent Chen <deanbo422@gmail.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Paolo Bonzini <pbonzini@redhat.com>, 
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>
X-Mailman-Approved-At: Wed, 22 Sep 2021 09:11:52 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 linux-riscv@lists.infradead.org, Jiri Olsa <jolsa@redhat.com>,
 kvmarm@lists.cs.columbia.edu, Stefano Stabellini <sstabellini@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, linux-csky@vger.kernel.org,
 xen-devel@lists.xenproject.org, Zhu Lingshan <lingshan.zhu@intel.com>,
 Namhyung Kim <namhyung@kernel.org>,
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

Use the generic kvm_running_vcpu plus a new 'handling_intr_from_guest'
variable in kvm_arch_vcpu instead of the semi-redundant current_vcpu.
kvm_before/after_interrupt() must be called while the vCPU is loaded,
(which protects against preemption), thus kvm_running_vcpu is guaranteed
to be non-NULL when handling_intr_from_guest is non-zero.

Switching to kvm_get_running_vcpu() will allows moving KVM's perf
callbacks to generic code, and the new flag will be used in a future
patch to more precisely identify the "NMI from guest" case.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  3 +--
 arch/x86/kvm/pmu.c              |  2 +-
 arch/x86/kvm/x86.c              | 21 ++++++++++++---------
 arch/x86/kvm/x86.h              | 10 ++++++----
 4 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1080166fc0cf..2d86a2dfc775 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -763,6 +763,7 @@ struct kvm_vcpu_arch {
 	unsigned nmi_pending; /* NMI queued after currently running handler */
 	bool nmi_injected;    /* Trying to inject an NMI this entry */
 	bool smi_pending;    /* SMI queued after currently running handler */
+	u8 handling_intr_from_guest;
 
 	struct kvm_mtrr mtrr_state;
 	u64 pat;
@@ -1874,8 +1875,6 @@ int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu);
 int kvm_complete_insn_gp(struct kvm_vcpu *vcpu, int err);
 void __kvm_request_immediate_exit(struct kvm_vcpu *vcpu);
 
-unsigned int kvm_guest_state(void);
-
 void __user *__x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa,
 				     u32 size);
 bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 5b68d4188de0..eef48258e50f 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -87,7 +87,7 @@ static void kvm_perf_overflow_intr(struct perf_event *perf_event,
 		 * woken up. So we should wake it, but this is impossible from
 		 * NMI context. Do it from irq work instead.
 		 */
-		if (!kvm_guest_state())
+		if (!kvm_handling_nmi_from_guest(pmc->vcpu))
 			irq_work_queue(&pmc_to_pmu(pmc)->irq_work);
 		else
 			kvm_make_request(KVM_REQ_PMI, pmc->vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6cc66466f301..24a6faa07442 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8264,15 +8264,17 @@ static void kvm_timer_init(void)
 			  kvmclock_cpu_online, kvmclock_cpu_down_prep);
 }
 
-DEFINE_PER_CPU(struct kvm_vcpu *, current_vcpu);
-EXPORT_PER_CPU_SYMBOL_GPL(current_vcpu);
+static inline bool kvm_pmi_in_guest(struct kvm_vcpu *vcpu)
+{
+	return vcpu && vcpu->arch.handling_intr_from_guest;
+}
 
-unsigned int kvm_guest_state(void)
+static unsigned int kvm_guest_state(void)
 {
-	struct kvm_vcpu *vcpu = __this_cpu_read(current_vcpu);
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 	unsigned int state;
 
-	if (!vcpu)
+	if (!kvm_pmi_in_guest(vcpu))
 		return 0;
 
 	state = PERF_GUEST_ACTIVE;
@@ -8284,9 +8286,10 @@ unsigned int kvm_guest_state(void)
 
 static unsigned long kvm_guest_get_ip(void)
 {
-	struct kvm_vcpu *vcpu = __this_cpu_read(current_vcpu);
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 
-	if (WARN_ON_ONCE(!vcpu))
+	/* Retrieving the IP must be guarded by a call to kvm_guest_state(). */
+	if (WARN_ON_ONCE(!kvm_pmi_in_guest(vcpu)))
 		return 0;
 
 	return kvm_rip_read(vcpu);
@@ -8294,10 +8297,10 @@ static unsigned long kvm_guest_get_ip(void)
 
 static unsigned int kvm_handle_intel_pt_intr(void)
 {
-	struct kvm_vcpu *vcpu = __this_cpu_read(current_vcpu);
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 
 	/* '0' on failure so that the !PT case can use a RET0 static call. */
-	if (!vcpu)
+	if (!kvm_pmi_in_guest(vcpu))
 		return 0;
 
 	kvm_make_request(KVM_REQ_PMI, vcpu);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 7d66d63dc55a..a9c107e7c907 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -387,18 +387,20 @@ static inline bool kvm_cstate_in_guest(struct kvm *kvm)
 	return kvm->arch.cstate_in_guest;
 }
 
-DECLARE_PER_CPU(struct kvm_vcpu *, current_vcpu);
-
 static inline void kvm_before_interrupt(struct kvm_vcpu *vcpu)
 {
-	__this_cpu_write(current_vcpu, vcpu);
+	WRITE_ONCE(vcpu->arch.handling_intr_from_guest, 1);
 }
 
 static inline void kvm_after_interrupt(struct kvm_vcpu *vcpu)
 {
-	__this_cpu_write(current_vcpu, NULL);
+	WRITE_ONCE(vcpu->arch.handling_intr_from_guest, 0);
 }
 
+static inline bool kvm_handling_nmi_from_guest(struct kvm_vcpu *vcpu)
+{
+	return !!vcpu->arch.handling_intr_from_guest;
+}
 
 static inline bool kvm_pat_valid(u64 data)
 {
-- 
2.33.0.464.g1972c5931b-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

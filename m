Return-Path: <SRS0=zOpf=C7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DE02C4727D
	for <kvmarm@archiver.kernel.org>; Tue, 22 Sep 2020 20:49:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9D03623600
	for <kvmarm@archiver.kernel.org>; Tue, 22 Sep 2020 20:49:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="kalQYUbl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9D03623600
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 426F24B2EB;
	Tue, 22 Sep 2020 16:49:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id J6lD9YCosy2P; Tue, 22 Sep 2020 16:49:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F3EF4B2F3;
	Tue, 22 Sep 2020 16:49:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C14E4A5A0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Sep 2020 16:49:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id npT1l4jmDON2 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Sep 2020 16:49:28 -0400 (EDT)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 293484B330
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Sep 2020 16:49:27 -0400 (EDT)
Received: by mail-wr1-f65.google.com with SMTP id z1so18575599wrt.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Sep 2020 13:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=1rHTFW5rdnwNPkO0qZp4oITZRDyqAQinUAgBdaQ8tp0=;
 b=kalQYUblEqzof6n5+3kB3C09e8ev9Ebep+vBVKL782wiN80eC9tP1G2VIE0jWPHQzN
 n4TQZjQbk4X3eY4tTZWKBk+aqcFf2qMBvTZ6XsH+W22iQVMsYmPhQ9zRJ297u9n+KkLI
 Nw2YKHQB9tFNTbeflwMquStSC79mi7sDW5sOuIDdV25nJyLEsJGVgjjoLvpzsns5nKDd
 yCyrAXUldtliHhzbqzyi1BPTCSXvXBBxoKWeQSZhfqw0oY1MS3/qfD20MoXT70jarlME
 /qCnY8R20gcfo6rohBs16PU3PTZfsTc2OaMZ6ea8FxvBTYuqWnM1vkILI+rZO9oyYB4F
 SaFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=1rHTFW5rdnwNPkO0qZp4oITZRDyqAQinUAgBdaQ8tp0=;
 b=I7Wi3aOzO5b6r22MxiasH3qOaP6mO2js/T/qI+1t7wHW9LNnWmaM5ruq0y/7kHCre7
 05ehZaOiK3xnVXvzT50WDtXhSJmfvj47G4Pu7g79bR9QVCaXUicLmGZWxplFYVh5lQdT
 Zug7XLrMUtMmqgWrrBrWzjuAuA3F28u9eT5PSUrPqFwozmmAIFwjXd6UcLSty+8k7EnM
 WiHbnM7w74SgLTEpjn/pawI8YYCY+zjsYCnl0TKaV0xFLheMXJuiKddjL06IKhcwm6uk
 CU4AlHxgAmOReKY1RKkQV9LKU9BSx+veZ3POVekPh/JVRwmo78M3H076iNLWbJ2lDoDe
 YeUg==
X-Gm-Message-State: AOAM531IznW0dJ4ySok6GLoxoC6ETzy/mgtPVvbHVSiIs/nbME7aZ0pp
 42tEhMDl2UPfwa/M3lx6vk/LTbydJnPrPjEm
X-Google-Smtp-Source: ABdhPJzMMJcRrUvd3XFcfDGRULRpg8/1O6KScA62zwKHLmyvkzsWlxVBiqPz5suOgQYkcQDkdNdqAA==
X-Received: by 2002:adf:fd01:: with SMTP id e1mr6976683wrr.44.1600807765905;
 Tue, 22 Sep 2020 13:49:25 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:1105:630f:e990:272f])
 by smtp.gmail.com with ESMTPSA id b64sm6112266wmh.13.2020.09.22.13.49.25
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 22 Sep 2020 13:49:25 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v4 08/10] kvm: arm64: Create separate instances of
 kvm_host_data for VHE/nVHE
Date: Tue, 22 Sep 2020 21:49:08 +0100
Message-Id: <20200922204910.7265-9-dbrazdil@google.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200922204910.7265-1-dbrazdil@google.com>
References: <20200922204910.7265-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>,
 Will Deacon <will@kernel.org>
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

Host CPU context is stored in a global per-cpu variable `kvm_host_data`.
In preparation for introducing independent per-CPU region for nVHE hyp,
create two separate instances of `kvm_host_data`, one for VHE and one
for nVHE.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 2 +-
 arch/arm64/kernel/image-vars.h    | 1 -
 arch/arm64/kvm/arm.c              | 5 ++---
 arch/arm64/kvm/hyp/nvhe/switch.c  | 3 +++
 arch/arm64/kvm/hyp/vhe/switch.c   | 3 +++
 arch/arm64/kvm/pmu.c              | 8 ++++----
 6 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 905c2b87e05a..5d8c63f5e97e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -565,7 +565,7 @@ void kvm_set_sei_esr(struct kvm_vcpu *vcpu, u64 syndrome);
 
 struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
 
-DECLARE_PER_CPU(kvm_host_data_t, kvm_host_data);
+DECLARE_KVM_HYP_PER_CPU(kvm_host_data_t, kvm_host_data);
 
 static inline void kvm_init_host_cpu_context(struct kvm_cpu_context *cpu_ctxt)
 {
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 59d12a0b4622..80da861b8180 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -67,7 +67,6 @@ KVM_NVHE_ALIAS(kvm_patch_vector_branch);
 KVM_NVHE_ALIAS(kvm_update_va_mask);
 
 /* Global kernel state accessed by nVHE hyp code. */
-KVM_NVHE_ALIAS(kvm_host_data);
 KVM_NVHE_ALIAS(kvm_vgic_global_state);
 
 /* Kernel constant needed to compute idmap addresses. */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 76be11d31e5d..0424667c4c0a 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -46,7 +46,6 @@
 __asm__(".arch_extension	virt");
 #endif
 
-DEFINE_PER_CPU(kvm_host_data_t, kvm_host_data);
 static DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
 
 /* The VMID used in the VTTBR */
@@ -1311,7 +1310,7 @@ static void cpu_hyp_reset(void)
 
 static void cpu_hyp_reinit(void)
 {
-	kvm_init_host_cpu_context(&this_cpu_ptr(&kvm_host_data)->host_ctxt);
+	kvm_init_host_cpu_context(&this_cpu_ptr_hyp_sym(kvm_host_data)->host_ctxt);
 
 	cpu_hyp_reset();
 
@@ -1546,7 +1545,7 @@ static int init_hyp_mode(void)
 	for_each_possible_cpu(cpu) {
 		kvm_host_data_t *cpu_data;
 
-		cpu_data = per_cpu_ptr(&kvm_host_data, cpu);
+		cpu_data = per_cpu_ptr_hyp_sym(kvm_host_data, cpu);
 		err = create_hyp_mappings(cpu_data, cpu_data + 1, PAGE_HYP);
 
 		if (err) {
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 4662df6330d7..a7e9b03bd9d1 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -30,6 +30,9 @@
 /* Non-VHE copy of the kernel symbol. */
 DEFINE_PER_CPU_READ_MOSTLY(u64, arm64_ssbd_callback_required);
 
+/* Non-VHE instance of kvm_host_data. */
+DEFINE_PER_CPU(kvm_host_data_t, kvm_host_data);
+
 static void __activate_traps(struct kvm_vcpu *vcpu)
 {
 	u64 val;
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 575e8054f116..0949fc97bf03 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -28,6 +28,9 @@
 
 const char __hyp_panic_string[] = "HYP panic:\nPS:%08llx PC:%016llx ESR:%08llx\nFAR:%016llx HPFAR:%016llx PAR:%016llx\nVCPU:%p\n";
 
+/* VHE instance of kvm_host_data. */
+DEFINE_PER_CPU(kvm_host_data_t, kvm_host_data);
+
 static void __activate_traps(struct kvm_vcpu *vcpu)
 {
 	u64 val;
diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 3c224162b3dd..c869c851d2dd 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -31,7 +31,7 @@ static bool kvm_pmu_switch_needed(struct perf_event_attr *attr)
  */
 void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr)
 {
-	struct kvm_host_data *ctx = this_cpu_ptr(&kvm_host_data);
+	struct kvm_host_data *ctx = this_cpu_ptr_hyp_sym(kvm_host_data);
 
 	if (!kvm_pmu_switch_needed(attr))
 		return;
@@ -47,7 +47,7 @@ void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr)
  */
 void kvm_clr_pmu_events(u32 clr)
 {
-	struct kvm_host_data *ctx = this_cpu_ptr(&kvm_host_data);
+	struct kvm_host_data *ctx = this_cpu_ptr_hyp_sym(kvm_host_data);
 
 	ctx->pmu_events.events_host &= ~clr;
 	ctx->pmu_events.events_guest &= ~clr;
@@ -173,7 +173,7 @@ void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu)
 		return;
 
 	preempt_disable();
-	host = this_cpu_ptr(&kvm_host_data);
+	host = this_cpu_ptr_hyp_sym(kvm_host_data);
 	events_guest = host->pmu_events.events_guest;
 	events_host = host->pmu_events.events_host;
 
@@ -193,7 +193,7 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu)
 	if (!has_vhe())
 		return;
 
-	host = this_cpu_ptr(&kvm_host_data);
+	host = this_cpu_ptr_hyp_sym(kvm_host_data);
 	events_guest = host->pmu_events.events_guest;
 	events_host = host->pmu_events.events_host;
 
-- 
2.28.0.681.g6f77f65b4e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

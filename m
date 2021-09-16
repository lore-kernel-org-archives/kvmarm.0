Return-Path: <SRS0=sbHD=OG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83427C433FE
	for <kvmarm@archiver.kernel.org>; Thu, 16 Sep 2021 18:15:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3585A60F51
	for <kvmarm@archiver.kernel.org>; Thu, 16 Sep 2021 18:15:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3585A60F51
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DEBF64B090;
	Thu, 16 Sep 2021 14:15:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Jv8ZXnc0p81A; Thu, 16 Sep 2021 14:15:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 812F54B18F;
	Thu, 16 Sep 2021 14:15:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B6534B0B8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Sep 2021 14:15:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RBBlvU6izE1R for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Sep 2021 14:15:43 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 123C44B090
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Sep 2021 14:15:43 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id
 p12-20020ad4496c000000b0037a535cb8b2so63307359qvy.15
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Sep 2021 11:15:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=EqfJ4nsZ26w2OY+w0/ZRQGVHhFarrWqQ77C9H9qe4wk=;
 b=jCgTfuzY3Xi/FfyO0lx2uvq5fA0lVuB+u2I9budg5JdSmdUW6fkucj/6Iswn5+9u81
 S5Hii45+Igo8DnjUigtICHwVREClRsu6Tt94jvAfHqx/W4EdvzOWJfxyBJRSO/PtALZt
 511OJi7qp+hjaP2T2gNjcMes9QckyDHsJh+2BGWhGKw0M1JamoY1Gp59mcwwonYWw3jo
 YzlI/iWllIFsVn66gc/48kc2LhIAYzj4gD09j2aRz8ifMS/+7cKghKSzkamlf41sDmLH
 xwJx2x4VOpX8THrVq3tJaaLDKzBQd47kw3OExONFC73ii1Dcr8WZjUXHO6zWaFv0mYYj
 2w9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=EqfJ4nsZ26w2OY+w0/ZRQGVHhFarrWqQ77C9H9qe4wk=;
 b=37YTQypti87NMhobYFav1JOm8XpK2Nw/Qg5cBNe+O9mawzzdJyNkZn3xt7Fn42zbJW
 7mCt6uYNGs+NafD1eqettt0u+ro/Elw00/LGXL63WAxgjLk/Lbnoz4rj7tGtsvvPwjt+
 7jGqnTAr5OK94t2ueiaM8q7Y3w1Ra/5XHA7UHo/jorELrdZdB9iLGNngoiiKKtnirq4q
 6cbf5lh2JSooOXn2Tvo2NwGqKwNMr9SMTzxWy/EVWWVONzB01aRiElzOtAKb7TgWw4hA
 wl2s8FUs1Lapri3Z3GLVNoZZR9uxtaDzBSca9Jo7MS0Ge4LefAhDrBOIZcak1sfC9fS6
 kbYQ==
X-Gm-Message-State: AOAM5336OYLdjx1fqe7XMq+QWCBMNzRZ1bMYT7SH/8uzRwYbYjrmIx9y
 6iBhx3XMlykaxhS8Rp+HvRITauEHjKk=
X-Google-Smtp-Source: ABdhPJzJVShjUP9eV6I0zKA9rrR+wmqb3KVny8yYAxYLYNtJU8sisB/xFAD1ErUlrDRx7ismNi4ONuO4ygA=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6214:431:: with SMTP id
 a17mr6549014qvy.48.1631816142691; Thu, 16 Sep 2021 11:15:42 -0700 (PDT)
Date: Thu, 16 Sep 2021 18:15:32 +0000
In-Reply-To: <20210916181538.968978-1-oupton@google.com>
Message-Id: <20210916181538.968978-2-oupton@google.com>
Mime-Version: 1.0
References: <20210916181538.968978-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v8 1/7] kvm: x86: abstract locking around
 pvclock_update_vm_gtod_copy
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 Sean Christopherson <seanjc@google.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>
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

From: Paolo Bonzini <pbonzini@redhat.com>

Updates to the kvmclock parameters needs to do a complicated dance of
KVM_REQ_MCLOCK_INPROGRESS and KVM_REQ_CLOCK_UPDATE in addition to taking
pvclock_gtod_sync_lock.  Place that in two functions that can be called
on all of master clock update, KVM_SET_CLOCK, and Hyper-V reenlightenment.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/x86.c              | 62 +++++++++++++++------------------
 2 files changed, 29 insertions(+), 34 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f8f48a7ec577..be6805fc0260 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1866,7 +1866,6 @@ u64 kvm_calc_nested_tsc_multiplier(u64 l1_multiplier, u64 l2_multiplier);
 unsigned long kvm_get_linear_rip(struct kvm_vcpu *vcpu);
 bool kvm_is_linear_rip(struct kvm_vcpu *vcpu, unsigned long linear_rip);
 
-void kvm_make_mclock_inprogress_request(struct kvm *kvm);
 void kvm_make_scan_ioapic_request(struct kvm *kvm);
 void kvm_make_scan_ioapic_request_mask(struct kvm *kvm,
 				       unsigned long *vcpu_bitmap);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 28ef14155726..1082b48418c3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2755,35 +2755,42 @@ static void pvclock_update_vm_gtod_copy(struct kvm *kvm)
 #endif
 }
 
-void kvm_make_mclock_inprogress_request(struct kvm *kvm)
+static void kvm_make_mclock_inprogress_request(struct kvm *kvm)
 {
 	kvm_make_all_cpus_request(kvm, KVM_REQ_MCLOCK_INPROGRESS);
 }
 
-static void kvm_gen_update_masterclock(struct kvm *kvm)
+static void kvm_start_pvclock_update(struct kvm *kvm)
 {
-#ifdef CONFIG_X86_64
-	int i;
-	struct kvm_vcpu *vcpu;
 	struct kvm_arch *ka = &kvm->arch;
-	unsigned long flags;
-
-	kvm_hv_invalidate_tsc_page(kvm);
 
 	kvm_make_mclock_inprogress_request(kvm);
 
 	/* no guest entries from this point */
-	spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
-	pvclock_update_vm_gtod_copy(kvm);
-	spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
+	spin_lock_irq(&ka->pvclock_gtod_sync_lock);
+}
 
+static void kvm_end_pvclock_update(struct kvm *kvm)
+{
+	struct kvm_arch *ka = &kvm->arch;
+	struct kvm_vcpu *vcpu;
+	int i;
+
+	spin_unlock_irq(&ka->pvclock_gtod_sync_lock);
 	kvm_for_each_vcpu(i, vcpu, kvm)
 		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 
 	/* guest entries allowed */
 	kvm_for_each_vcpu(i, vcpu, kvm)
 		kvm_clear_request(KVM_REQ_MCLOCK_INPROGRESS, vcpu);
-#endif
+}
+
+static void kvm_update_masterclock(struct kvm *kvm)
+{
+	kvm_hv_invalidate_tsc_page(kvm);
+	kvm_start_pvclock_update(kvm);
+	pvclock_update_vm_gtod_copy(kvm);
+	kvm_end_pvclock_update(kvm);
 }
 
 u64 get_kvmclock_ns(struct kvm *kvm)
@@ -6079,12 +6086,10 @@ long kvm_arch_vm_ioctl(struct file *filp,
 			goto out;
 
 		r = 0;
-		/*
-		 * TODO: userspace has to take care of races with VCPU_RUN, so
-		 * kvm_gen_update_masterclock() can be cut down to locked
-		 * pvclock_update_vm_gtod_copy().
-		 */
-		kvm_gen_update_masterclock(kvm);
+
+		kvm_hv_invalidate_tsc_page(kvm);
+		kvm_start_pvclock_update(kvm);
+		pvclock_update_vm_gtod_copy(kvm);
 
 		/*
 		 * This pairs with kvm_guest_time_update(): when masterclock is
@@ -6093,15 +6098,12 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		 * is slightly ahead) here we risk going negative on unsigned
 		 * 'system_time' when 'user_ns.clock' is very small.
 		 */
-		spin_lock_irq(&ka->pvclock_gtod_sync_lock);
 		if (kvm->arch.use_master_clock)
 			now_ns = ka->master_kernel_ns;
 		else
 			now_ns = get_kvmclock_base_ns();
 		ka->kvmclock_offset = user_ns.clock - now_ns;
-		spin_unlock_irq(&ka->pvclock_gtod_sync_lock);
-
-		kvm_make_all_cpus_request(kvm, KVM_REQ_CLOCK_UPDATE);
+		kvm_end_pvclock_update(kvm);
 		break;
 	}
 	case KVM_GET_CLOCK: {
@@ -8107,14 +8109,13 @@ static void tsc_khz_changed(void *data)
 static void kvm_hyperv_tsc_notifier(void)
 {
 	struct kvm *kvm;
-	struct kvm_vcpu *vcpu;
 	int cpu;
-	unsigned long flags;
 
 	mutex_lock(&kvm_lock);
 	list_for_each_entry(kvm, &vm_list, vm_list)
 		kvm_make_mclock_inprogress_request(kvm);
 
+	/* no guest entries from this point */
 	hyperv_stop_tsc_emulation();
 
 	/* TSC frequency always matches when on Hyper-V */
@@ -8125,16 +8126,11 @@ static void kvm_hyperv_tsc_notifier(void)
 	list_for_each_entry(kvm, &vm_list, vm_list) {
 		struct kvm_arch *ka = &kvm->arch;
 
-		spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
+		spin_lock_irq(&ka->pvclock_gtod_sync_lock);
 		pvclock_update_vm_gtod_copy(kvm);
-		spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
-
-		kvm_for_each_vcpu(cpu, vcpu, kvm)
-			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
-
-		kvm_for_each_vcpu(cpu, vcpu, kvm)
-			kvm_clear_request(KVM_REQ_MCLOCK_INPROGRESS, vcpu);
+		kvm_end_pvclock_update(kvm);
 	}
+
 	mutex_unlock(&kvm_lock);
 }
 #endif
@@ -9418,7 +9414,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		if (kvm_check_request(KVM_REQ_MIGRATE_TIMER, vcpu))
 			__kvm_migrate_timers(vcpu);
 		if (kvm_check_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu))
-			kvm_gen_update_masterclock(vcpu->kvm);
+			kvm_update_masterclock(vcpu->kvm);
 		if (kvm_check_request(KVM_REQ_GLOBAL_CLOCK_UPDATE, vcpu))
 			kvm_gen_kvmclock_update(vcpu);
 		if (kvm_check_request(KVM_REQ_CLOCK_UPDATE, vcpu)) {
-- 
2.33.0.309.g3052b89438-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <SRS0=FNOB=O5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57DCBC433FE
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:14:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EBB7A60FD9
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:14:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org EBB7A60FD9
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E9124B093;
	Fri,  8 Oct 2021 22:14:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0XyO675RdaDu; Fri,  8 Oct 2021 22:14:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 78FC34B1B2;
	Fri,  8 Oct 2021 22:14:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F3E94B12E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:14:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fK9y4zarUs2c for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Oct 2021 22:13:59 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DEC254B12C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:13:58 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 b5-20020a251b05000000b005b575f23711so15170709ybb.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Oct 2021 19:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=74r31OpU8NW+MC737KW2OyC4MoV5BxluWFmZ0wIUFwQ=;
 b=V7r7iotGGXSpwOyFo/5GOSk0OYL1h+1pOxbdC4LI5JCruGlrPLbnqn07EuCdfIwu0T
 Zmfvn9BWul9wSaR03Y4GuJvuRpvNM9GPW0g8UZ0ASJVKDvY1XN6qije5YFCYzLqWb0Ox
 h3h1UTdUfkhi0wg9KFd4+tuAGLSbiGpDis/Fr3m+vTeTPIUcLtSpmxnQfkRh0/DaszXp
 5H2ib25eMzRVYEc2xmrqf1JeyB/szEhAI8rd7GzbDU3qhiUT2F4XMkp8BugwIMIM3gvJ
 6+HChgOgvy/ayjdP2z8uJHXP2yKvQDdpl8X6zrmbCa91OqEywPOyHAZcF4Fpf43IvF27
 jXqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=74r31OpU8NW+MC737KW2OyC4MoV5BxluWFmZ0wIUFwQ=;
 b=WKl/IwjieydSV8WTheIrSZiOo9bGst6z0hwmi6ESjIxgvOvkdHiCg8RFyvGfymnvz6
 GLMAD7iTWmxihXHQLC0wnGeFpfcJcHONtz58CGKxMs3sNyhEZZb3BholCxkuF9ab6fIV
 OBrDXy+qiXon5LWRDRKzhYRcgQmc/jL7IUsnfo2RkCFgwJjkMrzgiyqhn3s+VNqUf3z4
 pEuuDsVuAOZ6qmTodbUNVFtrbofWRAAzk+sr39su0/lt8GxgyEHV9nnHLkE18NoVgM1S
 XFhN+mSLjYFtUmaivM7Y8D/y2AiKgTgLEKixutawkVy6lqS2KUBorhCm9MO7uVBgVGzM
 d06g==
X-Gm-Message-State: AOAM5325Bz90flvILEJm4bEi4RWWP2YXGqNTilYpT6zdvKJc677V9jDF
 EfnJ0FfgewB7L5mDbbzHKsESFA2obuQ=
X-Google-Smtp-Source: ABdhPJwgbsSdnQrzbzPUJKulJyChRLEDriPJWDBbVXRDLiiDF8J2h2Ck1mesLvf0H4KXpFh8QBnQHKs2rsM=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:a25:1b56:: with SMTP id
 b83mr7086955ybb.327.1633745638422; 
 Fri, 08 Oct 2021 19:13:58 -0700 (PDT)
Date: Fri,  8 Oct 2021 19:12:24 -0700
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Message-Id: <20211009021236.4122790-32-seanjc@google.com>
Mime-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2 31/43] KVM: Move x86 VMX's posted interrupt list_head to
 vcpu_vmx
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>, 
 Anup Patel <anup.patel@wdc.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Atish Patra <atish.patra@wdc.com>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Joerg Roedel <joro@8bytes.org>, kvm-ppc@vger.kernel.org,
 David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
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

Move the seemingly generic block_vcpu_list from kvm_vcpu to vcpu_vmx, and
rename the list and all associated variables to clarify that it tracks
the set of vCPU that need to be poked on a posted interrupt to the wakeup
vector.  The list is not used to track _all_ vCPUs that are blocking, and
the term "blocked" can be misleading as it may refer to a blocking
condition in the host or the guest, where as the PI wakeup case is
specifically for the vCPUs that are actively blocking from within the
guest.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/posted_intr.c | 39 +++++++++++++++++-----------------
 arch/x86/kvm/vmx/vmx.c         |  2 ++
 arch/x86/kvm/vmx/vmx.h         |  3 +++
 include/linux/kvm_host.h       |  2 --
 virt/kvm/kvm_main.c            |  2 --
 5 files changed, 25 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index d2b3d75c57d1..f1bcf8c32b6d 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -18,7 +18,7 @@
  * wake the target vCPUs.  vCPUs are removed from the list and the notification
  * vector is reset when the vCPU is scheduled in.
  */
-static DEFINE_PER_CPU(struct list_head, blocked_vcpu_on_cpu);
+static DEFINE_PER_CPU(struct list_head, wakeup_vcpus_on_cpu);
 /*
  * Protect the per-CPU list with a per-CPU spinlock to handle task migration.
  * When a blocking vCPU is awakened _and_ migrated to a different pCPU, the
@@ -26,7 +26,7 @@ static DEFINE_PER_CPU(struct list_head, blocked_vcpu_on_cpu);
  * CPU.  IRQs must be disabled when taking this lock, otherwise deadlock will
  * occur if a wakeup IRQ arrives and attempts to acquire the lock.
  */
-static DEFINE_PER_CPU(spinlock_t, blocked_vcpu_on_cpu_lock);
+static DEFINE_PER_CPU(spinlock_t, wakeup_vcpus_on_cpu_lock);
 
 static inline struct pi_desc *vcpu_to_pi_desc(struct kvm_vcpu *vcpu)
 {
@@ -36,6 +36,7 @@ static inline struct pi_desc *vcpu_to_pi_desc(struct kvm_vcpu *vcpu)
 void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct pi_desc old, new;
 	unsigned long flags;
 	unsigned int dest;
@@ -71,9 +72,9 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 	 * current pCPU if the task was migrated.
 	 */
 	if (pi_desc->nv == POSTED_INTR_WAKEUP_VECTOR) {
-		spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->cpu));
-		list_del(&vcpu->blocked_vcpu_list);
-		spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->cpu));
+		spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
+		list_del(&vmx->pi_wakeup_list);
+		spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
 	}
 
 	dest = cpu_physical_id(cpu);
@@ -121,15 +122,16 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 static void pi_enable_wakeup_handler(struct kvm_vcpu *vcpu)
 {
 	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct pi_desc old, new;
 	unsigned long flags;
 
 	local_irq_save(flags);
 
-	spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->cpu));
-	list_add_tail(&vcpu->blocked_vcpu_list,
-		      &per_cpu(blocked_vcpu_on_cpu, vcpu->cpu));
-	spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->cpu));
+	spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
+	list_add_tail(&vmx->pi_wakeup_list,
+		      &per_cpu(wakeup_vcpus_on_cpu, vcpu->cpu));
+	spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
 
 	WARN(pi_desc->sn, "PI descriptor SN field set before blocking");
 
@@ -182,24 +184,23 @@ void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu)
  */
 void pi_wakeup_handler(void)
 {
-	struct kvm_vcpu *vcpu;
 	int cpu = smp_processor_id();
+	struct vcpu_vmx *vmx;
 
-	spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, cpu));
-	list_for_each_entry(vcpu, &per_cpu(blocked_vcpu_on_cpu, cpu),
-			blocked_vcpu_list) {
-		struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
+	spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, cpu));
+	list_for_each_entry(vmx, &per_cpu(wakeup_vcpus_on_cpu, cpu),
+			    pi_wakeup_list) {
 
-		if (pi_test_on(pi_desc))
-			kvm_vcpu_kick(vcpu);
+		if (pi_test_on(&vmx->pi_desc))
+			kvm_vcpu_kick(&vmx->vcpu);
 	}
-	spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, cpu));
+	spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, cpu));
 }
 
 void __init pi_init_cpu(int cpu)
 {
-	INIT_LIST_HEAD(&per_cpu(blocked_vcpu_on_cpu, cpu));
-	spin_lock_init(&per_cpu(blocked_vcpu_on_cpu_lock, cpu));
+	INIT_LIST_HEAD(&per_cpu(wakeup_vcpus_on_cpu, cpu));
+	spin_lock_init(&per_cpu(wakeup_vcpus_on_cpu_lock, cpu));
 }
 
 bool pi_has_pending_interrupt(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 26ed8cd1a1f2..b3bb2031a7ac 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6848,6 +6848,8 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 	BUILD_BUG_ON(offsetof(struct vcpu_vmx, vcpu) != 0);
 	vmx = to_vmx(vcpu);
 
+	INIT_LIST_HEAD(&vmx->pi_wakeup_list);
+
 	err = -ENOMEM;
 
 	vmx->vpid = allocate_vpid();
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 592217fd7d92..d1a720be9a64 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -298,6 +298,9 @@ struct vcpu_vmx {
 	/* Posted interrupt descriptor */
 	struct pi_desc pi_desc;
 
+	/* Used if this vCPU is waiting for PI notification wakeup. */
+	struct list_head pi_wakeup_list;
+
 	/* Support for a guest hypervisor (nested VMX) */
 	struct nested_vmx nested;
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 87996b22e681..c5961a361c73 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -304,8 +304,6 @@ struct kvm_vcpu {
 	u64 requests;
 	unsigned long guest_debug;
 
-	struct list_head blocked_vcpu_list;
-
 	struct mutex mutex;
 	struct kvm_run *run;
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2bbf5c9d410f..c1850b60f38b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -426,8 +426,6 @@ static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 #endif
 	kvm_async_pf_vcpu_init(vcpu);
 
-	INIT_LIST_HEAD(&vcpu->blocked_vcpu_list);
-
 	kvm_vcpu_set_in_spin_loop(vcpu, false);
 	kvm_vcpu_set_dy_eligible(vcpu, false);
 	vcpu->preempted = false;
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <SRS0=FNOB=O5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6527FC43217
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:12:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1C38D6109E
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:12:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1C38D6109E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C44244B10C;
	Fri,  8 Oct 2021 22:12:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZIC9DfvCZgpt; Fri,  8 Oct 2021 22:12:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 94CF24B108;
	Fri,  8 Oct 2021 22:12:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 41C904B0D9
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:12:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HSyypuWgfzRZ for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Oct 2021 22:12:52 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3FBEF4B0CB
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:12:52 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 v70-20020a256149000000b005ba4d61ea0fso11138843ybb.22
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Oct 2021 19:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=cmY3ciYgK0Pw7Nc3yQ2tKxt4RfIVgRouhF9jfsbApsU=;
 b=QbQVaw+LEXAnvKqqBqFc88s4xq502vqu1GE3XpXsagKgQF+sSH5oy9ZN3Riurg0uam
 NboPaoBoD+NTvzrr76ut0oSCAr/dobocjfxXDCgfKREM1WgGlcHv/XKBbx+8XlSywjl9
 v6gbyQ/DSMA6ibdL//jX5ac88VgPO68Yar5tSoyOjvQU7DWuLyOGlTMs1EcHp6GBd7t8
 zDaqFcWWP1eS2XcbCz8YiWyZQMO7D8kVYM83EyYLTsNWw/FWNJEOnWDm+n66w3yiKT4b
 k4mJC2lWsO+wgHdIF9UIkXA7mXBDmZvdXGiRS4k0umncgko4hmVixQMSV1g0v0Xm3Xav
 bXww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=cmY3ciYgK0Pw7Nc3yQ2tKxt4RfIVgRouhF9jfsbApsU=;
 b=uCOL0RYJ1BZ6J+jSi1/XYJGiH8N30L5lSDXSQ6psBBf9+dANYyeKZrd0CBIJCEynbG
 YdsnVyUZz0YlShlAGgPT3x7EOPdHsJ2rQ5e/y5wLTCbcYRH3Qq9KflBMqnUvzVFEvXUr
 f1/K0XPg74JzljwEc2g8TFuQqe7cYr9Jof/n4d0a5KlXS1FNYLdrRvBmzS0l+VdBfqM/
 G6GdvGQ/dzPhvwuvw6wfzhR7gEx+VI5Zu4/SqX0wTMdGmodFKHIFedrMolh47xCCITo/
 WHf/P3xYXIO/iyHHYx1z0QWLc0sRzwyNa85ImuaKotFRMIGBZSiI0B8kizyHPgUDhEwr
 cS5Q==
X-Gm-Message-State: AOAM5328tlgieXKKSuUu3/9AyypVEfW40aHBYQqsRaef9DtkZs8Qs9BZ
 ElMmXDcmntkWRp8rB6+icL6T4/vgi4Y=
X-Google-Smtp-Source: ABdhPJxDfkHFA9j3YHwNecv1+8g7k+RRNV2EAtanrld0mWMeRHqp+zJFBO4S5rRqjxsoT4caGrG4+Mlfzmc=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:a25:bc0e:: with SMTP id
 i14mr6935877ybh.324.1633745571812; 
 Fri, 08 Oct 2021 19:12:51 -0700 (PDT)
Date: Fri,  8 Oct 2021 19:11:57 -0700
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Message-Id: <20211009021236.4122790-5-seanjc@google.com>
Mime-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2 04/43] KVM: Force PPC to define its own rcuwait object
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

Do not define/reference kvm_vcpu.wait if __KVM_HAVE_ARCH_WQP is true, and
instead force the architecture (PPC) to define its own rcuwait object.
Allowing common KVM to directly access vcpu->wait without a guard makes
it all too easy to introduce potential bugs, e.g. kvm_vcpu_block(),
kvm_vcpu_on_spin(), and async_pf_execute() all operate on vcpu->wait, not
the result of kvm_arch_vcpu_get_wait(), and so may do the wrong thing for
PPC.

Due to PPC's shenanigans with respect to callbacks and waits (it switches
to the virtual core's wait object at KVM_RUN!?!?), it's not clear whether
or not this fixes any bugs.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/powerpc/include/asm/kvm_host.h | 1 +
 arch/powerpc/kvm/powerpc.c          | 3 ++-
 include/linux/kvm_host.h            | 2 ++
 virt/kvm/async_pf.c                 | 2 +-
 virt/kvm/kvm_main.c                 | 9 ++++++---
 5 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 59cb38b04ede..876c10803cda 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -749,6 +749,7 @@ struct kvm_vcpu_arch {
 	u8 irq_pending; /* Used by XIVE to signal pending guest irqs */
 	u32 last_inst;
 
+	struct rcuwait wait;
 	struct rcuwait *waitp;
 	struct kvmppc_vcore *vcore;
 	int ret;
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 8ab90ce8738f..be22da157569 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -762,7 +762,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	if (err)
 		goto out_vcpu_uninit;
 
-	vcpu->arch.waitp = &vcpu->wait;
+	rcuwait_init(&vcpu->arch.wait);
+	vcpu->arch.waitp = &vcpu->arch.wait;
 	kvmppc_create_vcpu_debugfs(vcpu, vcpu->vcpu_id);
 	return 0;
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 60a35d9fe259..1ced2914d9ca 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -310,7 +310,9 @@ struct kvm_vcpu {
 	struct mutex mutex;
 	struct kvm_run *run;
 
+#ifndef __KVM_HAVE_ARCH_WQP
 	struct rcuwait wait;
+#endif
 	struct pid __rcu *pid;
 	int sigset_active;
 	sigset_t sigset;
diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index dd777688d14a..ccb35c22785e 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -85,7 +85,7 @@ static void async_pf_execute(struct work_struct *work)
 
 	trace_kvm_async_pf_completed(addr, cr2_or_gpa);
 
-	rcuwait_wake_up(&vcpu->wait);
+	rcuwait_wake_up(kvm_arch_vcpu_get_wait(vcpu));
 
 	mmput(mm);
 	kvm_put_kvm(vcpu->kvm);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7bc38549487e..5d4a90032277 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -421,7 +421,9 @@ static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 	vcpu->kvm = kvm;
 	vcpu->vcpu_id = id;
 	vcpu->pid = NULL;
+#ifndef __KVM_HAVE_ARCH_WQP
 	rcuwait_init(&vcpu->wait);
+#endif
 	kvm_async_pf_vcpu_init(vcpu);
 
 	vcpu->pre_pcpu = -1;
@@ -3213,6 +3215,7 @@ update_halt_poll_stats(struct kvm_vcpu *vcpu, u64 poll_ns, bool waited)
  */
 void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 {
+	struct rcuwait *wait = kvm_arch_vcpu_get_wait(vcpu);
 	bool halt_poll_allowed = !kvm_arch_no_poll(vcpu);
 	ktime_t start, cur, poll_end;
 	bool waited = false;
@@ -3251,7 +3254,7 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	}
 
 
-	prepare_to_rcuwait(&vcpu->wait);
+	prepare_to_rcuwait(wait);
 	for (;;) {
 		set_current_state(TASK_INTERRUPTIBLE);
 
@@ -3261,7 +3264,7 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 		waited = true;
 		schedule();
 	}
-	finish_rcuwait(&vcpu->wait);
+	finish_rcuwait(wait);
 	cur = ktime_get();
 	if (waited) {
 		vcpu->stat.generic.halt_wait_ns +=
@@ -3460,7 +3463,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
 				continue;
 			if (vcpu == me)
 				continue;
-			if (rcuwait_active(&vcpu->wait) &&
+			if (rcuwait_active(kvm_arch_vcpu_get_wait(vcpu)) &&
 			    !vcpu_dy_runnable(vcpu))
 				continue;
 			if (READ_ONCE(vcpu->preempted) && yield_to_kernel_mode &&
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

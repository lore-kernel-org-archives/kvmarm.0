Return-Path: <SRS0=FNOB=O5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C613C433FE
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:13:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9DD8161038
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:13:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9DD8161038
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DF004B093;
	Fri,  8 Oct 2021 22:13:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EOEOTso9MATz; Fri,  8 Oct 2021 22:13:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 185FA4B12E;
	Fri,  8 Oct 2021 22:13:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 286FD4B099
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:13:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OrSsgXT1EGVx for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Oct 2021 22:13:52 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2C5ED4B191
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:13:51 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 81-20020a251254000000b005b6220d81efso14971942ybs.12
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Oct 2021 19:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=55YfyLhMwNaRUScBeXWYLQcHUBDZGdNHeb4QvoQSFyE=;
 b=C9t4uCApsnS68i3KeThREaZe1Om+7Tp6CUDNf13J8E2BemfJEmkFtqcFwUAJufMVG0
 3WOLQFovIcCgHqQjc76I/Bb0RIN+B8Z777pX6m6sLBFwdTtCa87oR4HWw8W6pADqeqG2
 QgUYUEV3xUzi5O46w1OCtmTdfddkVtZfkufO6ZAREf4t4CTBbAXPgnb7eruajoxMEvZx
 gCBjUgNPJ65sSMFZJJ8LojLsxPquqyHqOv0DC5H3uJyc2iDg6eA0A7oeegQMAdRUi/Aw
 WUM3JuhaNVZIdEjfnGeX3lFU5I9xVxnDQhJTwRYwm4Q6N5wAp2zXvscnBr8P/79r34/t
 9KlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=55YfyLhMwNaRUScBeXWYLQcHUBDZGdNHeb4QvoQSFyE=;
 b=cMB3hEjJis8qfuqrmWXG15/ArX8a5EwF1zwoc4Bu6qNtJmHu+fsy72QNBTM0HrtAgZ
 W8APHCxB5EK8iqpPicMAn1NY19GMk8PERWuU0gs9LIRsQslJ57JVvpz1ZQsmq1UQjmok
 RfiEVcgXnNHoQvN9du5SSw+WKzxpp+Y6vTu4KvfFg2SdruPii8kCGgtM2QYQ0+7zWM0Q
 /nIrSlL0a2gR/2uXg+b8Qli2NvmHgL6r8CaZ3pVGO9y49mGgwSUJWE98Yo6o+MFeOLGt
 wICQRTLRDc73v5/Wsz52NyuVobRMz6KslUtUundbZIN43v9i59KQrEHD3iZR8IO2FG31
 QHUg==
X-Gm-Message-State: AOAM531S++1M+xU/5z+IHw6dTt0vI7t3McTduVA1MmYhDVXnfHmV6LoB
 BttnNcWWQ/Kxf2ZxD8Nl0b2inn2YPwY=
X-Google-Smtp-Source: ABdhPJxjSI94TgUwx52krVH0O+S/pIZKhRKzmwxzVW6y/1e67T6fOupN9aoHyYhZTK7KMTNPYcyhb6P2J28=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:a25:5545:: with SMTP id
 j66mr6891804ybb.288.1633745630724; 
 Fri, 08 Oct 2021 19:13:50 -0700 (PDT)
Date: Fri,  8 Oct 2021 19:12:21 -0700
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Message-Id: <20211009021236.4122790-29-seanjc@google.com>
Mime-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2 28/43] KVM: VMX: Remove vCPU from PI wakeup list before
 updating PID.NV
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

Remove the vCPU from the wakeup list before updating the notification
vector in the posted interrupt post-block helper.  There is no need to
wake the current vCPU as it is by definition not blocking.  Practically
speaking this is a nop as it only shaves a few meager cycles in the
unlikely case that the vCPU was migrated and the previous pCPU gets a
wakeup IRQ right before PID.NV is updated.  The real motivation is to
allow for more readable code in the future, when post-block is merged
with vmx_vcpu_pi_load(), at which point removal from the list will be
conditional on the old notification vector.

Opportunistically add comments to document why KVM has a per-CPU spinlock
that, at first glance, appears to be taken only on the owning CPU.
Explicitly call out that the spinlock must be taken with IRQs disabled, a
detail that was "lost" when KVM switched from spin_lock_irqsave() to
spin_lock(), with IRQs disabled for the entirety of the relevant path.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/posted_intr.c | 49 +++++++++++++++++++++++-----------
 1 file changed, 33 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 2b2206339174..901b7a5f7777 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -10,10 +10,22 @@
 #include "vmx.h"
 
 /*
- * We maintain a per-CPU linked-list of vCPU, so in wakeup_handler() we
- * can find which vCPU should be waken up.
+ * Maintain a per-CPU list of vCPUs that need to be awakened by wakeup_handler()
+ * when a WAKEUP_VECTOR interrupted is posted.  vCPUs are added to the list when
+ * the vCPU is scheduled out and is blocking (e.g. in HLT) with IRQs enabled.
+ * The vCPUs posted interrupt descriptor is updated at the same time to set its
+ * notification vector to WAKEUP_VECTOR, so that posted interrupt from devices
+ * wake the target vCPUs.  vCPUs are removed from the list and the notification
+ * vector is reset when the vCPU is scheduled in.
  */
 static DEFINE_PER_CPU(struct list_head, blocked_vcpu_on_cpu);
+/*
+ * Protect the per-CPU list with a per-CPU spinlock to handle task migration.
+ * When a blocking vCPU is awakened _and_ migrated to a different pCPU, the
+ * ->sched_in() path will need to take the vCPU off the list of the _previous_
+ * CPU.  IRQs must be disabled when taking this lock, otherwise deadlock will
+ * occur if a wakeup IRQ arrives and attempts to acquire the lock.
+ */
 static DEFINE_PER_CPU(spinlock_t, blocked_vcpu_on_cpu_lock);
 
 static inline struct pi_desc *vcpu_to_pi_desc(struct kvm_vcpu *vcpu)
@@ -101,23 +113,28 @@ static void __pi_post_block(struct kvm_vcpu *vcpu)
 	WARN(pi_desc->nv != POSTED_INTR_WAKEUP_VECTOR,
 	     "Wakeup handler not enabled while the vCPU was blocking");
 
-	dest = cpu_physical_id(vcpu->cpu);
-	if (!x2apic_mode)
-		dest = (dest << 8) & 0xFF00;
-
-	do {
-		old.control = new.control = READ_ONCE(pi_desc->control);
-
-		new.ndst = dest;
-
-		/* set 'NV' to 'notification vector' */
-		new.nv = POSTED_INTR_VECTOR;
-	} while (cmpxchg64(&pi_desc->control, old.control,
-			   new.control) != old.control);
-
+	/*
+	 * Remove the vCPU from the wakeup list of the _previous_ pCPU, which
+	 * will not be the same as the current pCPU if the task was migrated.
+	 */
 	spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
 	list_del(&vcpu->blocked_vcpu_list);
 	spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
+
+	dest = cpu_physical_id(vcpu->cpu);
+	if (!x2apic_mode)
+		dest = (dest << 8) & 0xFF00;
+
+	do {
+		old.control = new.control = READ_ONCE(pi_desc->control);
+
+		new.ndst = dest;
+
+		/* set 'NV' to 'notification vector' */
+		new.nv = POSTED_INTR_VECTOR;
+	} while (cmpxchg64(&pi_desc->control, old.control,
+			   new.control) != old.control);
+
 	vcpu->pre_pcpu = -1;
 }
 
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

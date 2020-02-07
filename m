Return-Path: <SRS0=EEll=33=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 274F4C2BA83
	for <kvmarm@archiver.kernel.org>; Fri,  7 Feb 2020 16:34:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 94CED217BA
	for <kvmarm@archiver.kernel.org>; Fri,  7 Feb 2020 16:34:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="gQsHJwOF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 94CED217BA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 30AE44A542;
	Fri,  7 Feb 2020 11:34:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4ZmEHB0cQa4h; Fri,  7 Feb 2020 11:34:29 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 18A204A389;
	Fri,  7 Feb 2020 11:34:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A37F64A389
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Feb 2020 11:34:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XOsEr9WxtNTz for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Feb 2020 11:34:26 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 588424A319
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Feb 2020 11:34:26 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 2BB9C22314;
 Fri,  7 Feb 2020 16:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1581093265;
 bh=GN1tdZxHd8F0WGBBeyp6PW/4IYqx0usfkvEwY2P3jF4=;
 h=From:To:Cc:Subject:Date:From;
 b=gQsHJwOFLrBtOGkqDs0dTVfyUCCd4XMI1BZPMd42SCm46NR5s0ZuwKEzZsQf4uV7w
 hXFxsWknPm9x6aQNT9YCAEr2yTPGAB1asqO22dYqMOBS+rXVpFQKyrvezanCO9OA2q
 q9ku9GPjvY1iAFObNpqTMRnn4fbwgJ6S2fOhRT7w=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1j06aF-003Zb1-Gi; Fri, 07 Feb 2020 16:34:23 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org
Subject: [PATCH] KVM: Disable preemption in kvm_get_running_vcpu()
Date: Fri,  7 Feb 2020 16:34:10 +0000
Message-Id: <20200207163410.31276-1-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 peterx@redhat.com, pbonzini@redhat.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Paolo Bonzini <pbonzini@redhat.com>
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

Accessing a per-cpu variable only makes sense when preemption is
disabled (and the kernel does check this when the right debug options
are switched on).

For kvm_get_running_vcpu(), it is fine to return the value after
re-enabling preemption, as the preempt notifiers will make sure that
this is kept consistent across task migration (the comment above the
function hints at it, but lacks the crucial preemption management).

While we're at it, move the comment from the ARM code, which explains
why the whole thing works.

Fixes: 7495e22bb165 ("KVM: Move running VCPU from ARM to common code").
Cc: Peter Xu <peterx@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Reported-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/318984f6-bc36-33a3-abc6-bf2295974b06@huawei.com
---
 virt/kvm/arm/vgic/vgic-mmio.c | 12 ------------
 virt/kvm/kvm_main.c           | 16 +++++++++++++---
 2 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index d656ebd5f9d4..97fb2a40e6ba 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -179,18 +179,6 @@ unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
 	return value;
 }
 
-/*
- * This function will return the VCPU that performed the MMIO access and
- * trapped from within the VM, and will return NULL if this is a userspace
- * access.
- *
- * We can disable preemption locally around accessing the per-CPU variable,
- * and use the resolved vcpu pointer after enabling preemption again, because
- * even if the current thread is migrated to another CPU, reading the per-CPU
- * value later will give us the same value as we update the per-CPU variable
- * in the preempt notifier handlers.
- */
-
 /* Must be called with irq->irq_lock held */
 static void vgic_hw_irq_spending(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
 				 bool is_uaccess)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 67ae2d5c37b2..70f03ce0e5c1 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4409,12 +4409,22 @@ static void kvm_sched_out(struct preempt_notifier *pn,
 
 /**
  * kvm_get_running_vcpu - get the vcpu running on the current CPU.
- * Thanks to preempt notifiers, this can also be called from
- * preemptible context.
+ *
+ * We can disable preemption locally around accessing the per-CPU variable,
+ * and use the resolved vcpu pointer after enabling preemption again,
+ * because even if the current thread is migrated to another CPU, reading
+ * the per-CPU value later will give us the same value as we update the
+ * per-CPU variable in the preempt notifier handlers.
  */
 struct kvm_vcpu *kvm_get_running_vcpu(void)
 {
-        return __this_cpu_read(kvm_running_vcpu);
+	struct kvm_vcpu *vcpu;
+
+	preempt_disable();
+	vcpu = __this_cpu_read(kvm_running_vcpu);
+	preempt_enable();
+
+	return vcpu;
 }
 
 /**
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

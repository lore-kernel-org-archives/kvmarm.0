Return-Path: <SRS0=FNOB=O5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86735C433EF
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:13:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 03DC461040
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:13:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 03DC461040
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D8414B168;
	Fri,  8 Oct 2021 22:13:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 77jXcsgbYWvD; Fri,  8 Oct 2021 22:13:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B4D44B195;
	Fri,  8 Oct 2021 22:13:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 881604B18A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:13:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tzt3aRWT2I0y for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Oct 2021 22:13:43 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7C1934B178
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:13:41 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 x15-20020a056902102f00b005ba71cd7dbfso4954099ybt.8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Oct 2021 19:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=p2AXaXCXfG3zJ1FL308pQbveOpDqWTdi8iqec5R3ilA=;
 b=ghMBthmudSXs+6+p6LKZCK4H0OHszDcUTjjC8eI9oFe5NKEBgV82EMdibCOuqO9Vxj
 RdWrTXr3jIuis42ImlAoRzWDoHFdmCVkvhr7Ak9ohTH6uYw/wAChiBME+5gVCVNAgppx
 Bau/vxHhIQUy9RpDE2jA3YK9PywakgEEGvf08OG/9sd3zh0sXBu7t3verDPFwVmZOBV6
 6EvsyuVx5W4cXQ42SL97ee8aY4sDaFqLd/c+4qYy3T18FOiClCY3egvkUGNfWDUIncUQ
 g+5hQtAw8uYrvtob8ZWh/HS1msNf2yq2NMlMufCxgAu3+fQ5cHcaqEQ/AFlCCc3jp+BF
 /aSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=p2AXaXCXfG3zJ1FL308pQbveOpDqWTdi8iqec5R3ilA=;
 b=SZhdDVej7AfdPMLux/Ok79JqVr8ikKBoebUmurPZRIgIwoJaKZriqgaYjr4CgbvxT3
 1atKJaK9HESMnpvcUALDMEjLppjfVTPAAmwJpiO9+8VKe2tnrNfwMq1W9nvhhOKD/XTR
 59Q4K+qeHoxA2tVC5lDTSdScylaefw7ivMtgKgs/SyjLdN3BiiLpSlCG37bbgXifVte0
 BrAKdwHbOqrkMrjptGEZVxwS8fkVaya1pDAjU+jvuQKCZ3KzfISTilL8jxnQNcVLEYAN
 h98Gi+hJ7XmIdUJVCD6saQHKO6IPggqQq6wROqga6QcWt2jY8XiUUyyS9GGs+UveDhxQ
 Tshw==
X-Gm-Message-State: AOAM530UYvalebTxstqsm9h+TZX2JuZZu1H79jCaliOTWGQP2TNLo1du
 cos8xgXpZ3DBzEuwRKkj0WRcu+47i04=
X-Google-Smtp-Source: ABdhPJx6Bv/qxNdoBxYiPnsjWrMq4fbR1wONeQsZ0IiCsamqBbWFWlGuin3sFq5D1af73AaAZ7aulEVU00Y=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:a25:8b06:: with SMTP id
 i6mr7491785ybl.427.1633745621082; 
 Fri, 08 Oct 2021 19:13:41 -0700 (PDT)
Date: Fri,  8 Oct 2021 19:12:17 -0700
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Message-Id: <20211009021236.4122790-25-seanjc@google.com>
Mime-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2 24/43] KVM: VMX: Drop pointless PI.NDST update when blocking
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

Don't update Posted Interrupt's NDST, a.k.a. the target pCPU, in the
pre-block path, as NDST is guaranteed to be up-to-date.  The comment
about the vCPU being preempted during the update is simply wrong, as the
update path runs with IRQs disabled (from before snapshotting vcpu->cpu,
until after the update completes).

The vCPU can get preempted _before_ the update starts, but not during.
And if the vCPU is preempted before, vmx_vcpu_pi_load() is responsible
for updating NDST when the vCPU is scheduled back in.  In that case, the
check against the wakeup vector in vmx_vcpu_pi_load() cannot be true as
that would require the notification vector to have been set to the wakeup
vector _before_ blocking.

Opportunistically switch to using vcpu->cpu for the list/lock lookups,
which presumably used pre_pcpu only for some phantom preemption logic.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/posted_intr.c | 23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 1688f8dc535a..239e0e72a0dd 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -130,7 +130,6 @@ static void __pi_post_block(struct kvm_vcpu *vcpu)
  * - Store the vCPU to the wakeup list, so when interrupts happen
  *   we can find the right vCPU to wake up.
  * - Change the Posted-interrupt descriptor as below:
- *      'NDST' <-- vcpu->pre_pcpu
  *      'NV' <-- POSTED_INTR_WAKEUP_VECTOR
  * - If 'ON' is set during this process, which means at least one
  *   interrupt is posted for this vCPU, we cannot block it, in
@@ -139,7 +138,6 @@ static void __pi_post_block(struct kvm_vcpu *vcpu)
  */
 int pi_pre_block(struct kvm_vcpu *vcpu)
 {
-	unsigned int dest;
 	struct pi_desc old, new;
 	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
 
@@ -153,10 +151,10 @@ int pi_pre_block(struct kvm_vcpu *vcpu)
 	local_irq_disable();
 
 	vcpu->pre_pcpu = vcpu->cpu;
-	spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
+	spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->cpu));
 	list_add_tail(&vcpu->blocked_vcpu_list,
-		      &per_cpu(blocked_vcpu_on_cpu, vcpu->pre_pcpu));
-	spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
+		      &per_cpu(blocked_vcpu_on_cpu, vcpu->cpu));
+	spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->cpu));
 
 	WARN(pi_desc->sn == 1,
 	     "Posted Interrupt Suppress Notification set before blocking");
@@ -164,21 +162,6 @@ int pi_pre_block(struct kvm_vcpu *vcpu)
 	do {
 		old.control = new.control = pi_desc->control;
 
-		/*
-		 * Since vCPU can be preempted during this process,
-		 * vcpu->cpu could be different with pre_pcpu, we
-		 * need to set pre_pcpu as the destination of wakeup
-		 * notification event, then we can find the right vCPU
-		 * to wakeup in wakeup handler if interrupts happen
-		 * when the vCPU is in blocked state.
-		 */
-		dest = cpu_physical_id(vcpu->pre_pcpu);
-
-		if (x2apic_mode)
-			new.ndst = dest;
-		else
-			new.ndst = (dest << 8) & 0xFF00;
-
 		/* set 'NV' to 'wakeup vector' */
 		new.nv = POSTED_INTR_WAKEUP_VECTOR;
 	} while (cmpxchg64(&pi_desc->control, old.control,
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <SRS0=FNOB=O5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFDC3C433EF
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:13:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 64C3961027
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:13:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 64C3961027
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 177094B13A;
	Fri,  8 Oct 2021 22:13:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rjNDywAk1N-O; Fri,  8 Oct 2021 22:13:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B8E7E4B165;
	Fri,  8 Oct 2021 22:13:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E497C4B160
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:13:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id t8SNtvn5iQMn for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Oct 2021 22:13:29 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E743F4B15B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:13:28 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 t7-20020a258387000000b005b6d7220c79so14965221ybk.16
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Oct 2021 19:13:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=32RMiV4r6xip6o15c8bJUTQW2O8kilnMCGQHEfTTYKM=;
 b=Xt+/sD+qL3dmnz376HBxoxNqvIltpU6YZ2LmJMV7IG0i/AZpV1I3dHKqo0HOrsKWoV
 hup6zyRQlIvRk2f+k/Qkt86T31RCpT38q9CZOLd0NEkYhf/DCHHeIuZ1i0z6SSH1w4cv
 87MWNVLb1sk7RMghhTpyh4WMDZEaUB+V4TpFad0hlvVcDNeQ+heTvz7zCw9Q6hUzXDcW
 /ziydy33Gp8JyWZI/IdgaBh5D3MRLdWQtryxN8AojNQ5w7dlpnIsNjMOhg+dVszK8ar5
 MqYtV5N/ZK2vm/4Y4Y5DUZ+fplCVDBqxMgjwSR/fWfam+q2Mo19ZYpN7bZlBF6OLjTAN
 rPAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=32RMiV4r6xip6o15c8bJUTQW2O8kilnMCGQHEfTTYKM=;
 b=Spns2z5ZbJNqYUgSAw4pMsyrojsMymHFGEdeEjoOLvm8G7+18dFjuufeYWyKeIK3FW
 TNyRzb4gkCDAVfXqX+nNgZ3x6ogGM8rnoZb3v47N9Yt8duL2Nvks5znb1wFXpibzYtL9
 dfqD/+MYd56k1xjXdH+jclpEVCUFUEzhTZBsKmeBBsyUU3gK/tpYeyU14FUK+uDTRV5N
 ZdfYB9dfuLk8eCh+vXbm8WUsCmUkE66ZFnzSPQ3PFUhk0juks71jcalgzeNEjZZ2dBEW
 OoPA7JQPkQ4hyvyR7HIa/I6gDv3osYSlWNa2P4Pqzgf2F/+gEtNBoE3Y4QXT+w8ayEIJ
 DwKQ==
X-Gm-Message-State: AOAM533j+qxp+p9gZRGoRdi12EsFMqpgpABduS8koNi/DR6wm0900cYz
 U7Ib1wV4NeolDvbi4jhJYCsZzNTK1+k=
X-Google-Smtp-Source: ABdhPJw4j9hWuJPsOcM61WVS3IQVTDinA25rMFFzafcSSpwgKm0gpmkD5FDPpiAeFmHa2qG4NwAmC1D9m2Q=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:a25:6584:: with SMTP id
 z126mr6683601ybb.156.1633745608458; 
 Fri, 08 Oct 2021 19:13:28 -0700 (PDT)
Date: Fri,  8 Oct 2021 19:12:12 -0700
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Message-Id: <20211009021236.4122790-20-seanjc@google.com>
Mime-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2 19/43] KVM: Add helpers to wake/query blocking vCPU
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

Add helpers to wake and query a blocking vCPU.  In addition to providing
nice names, the helpers reduce the probability of KVM neglecting to use
kvm_arch_vcpu_get_wait().

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/arch_timer.c |  3 +--
 arch/arm64/kvm/arm.c        |  2 +-
 arch/x86/kvm/lapic.c        |  2 +-
 include/linux/kvm_host.h    | 14 ++++++++++++++
 virt/kvm/async_pf.c         |  2 +-
 virt/kvm/kvm_main.c         |  8 ++------
 6 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 7e8396f74010..addd53b6eba6 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -649,7 +649,6 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = vcpu_timer(vcpu);
 	struct timer_map map;
-	struct rcuwait *wait = kvm_arch_vcpu_get_wait(vcpu);
 
 	if (unlikely(!timer->enabled))
 		return;
@@ -672,7 +671,7 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
 	if (map.emul_ptimer)
 		soft_timer_cancel(&map.emul_ptimer->hrtimer);
 
-	if (rcuwait_active(wait))
+	if (kvm_vcpu_is_blocking(vcpu))
 		kvm_timer_blocking(vcpu);
 
 	/*
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 268b1e7bf700..9ff0e85a9f16 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -622,7 +622,7 @@ void kvm_arm_resume_guest(struct kvm *kvm)
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		vcpu->arch.pause = false;
-		rcuwait_wake_up(kvm_arch_vcpu_get_wait(vcpu));
+		__kvm_vcpu_wake_up(vcpu);
 	}
 }
 
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 76fb00921203..0cd7ed21b205 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1931,7 +1931,7 @@ void kvm_lapic_expired_hv_timer(struct kvm_vcpu *vcpu)
 	/* If the preempt notifier has already run, it also called apic_timer_expired */
 	if (!apic->lapic_timer.hv_timer_in_use)
 		goto out;
-	WARN_ON(rcuwait_active(&vcpu->wait));
+	WARN_ON(kvm_vcpu_is_blocking(vcpu));
 	apic_timer_expired(apic, false);
 	cancel_hv_timer(apic);
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index bdaa0e70b060..1fa38dc00b87 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1151,6 +1151,20 @@ static inline struct rcuwait *kvm_arch_vcpu_get_wait(struct kvm_vcpu *vcpu)
 #endif
 }
 
+/*
+ * Wake a vCPU if necessary, but don't do any stats/metadata updates.  Returns
+ * true if the vCPU was blocking and was awakened, false otherwise.
+ */
+static inline bool __kvm_vcpu_wake_up(struct kvm_vcpu *vcpu)
+{
+	return !!rcuwait_wake_up(kvm_arch_vcpu_get_wait(vcpu));
+}
+
+static inline bool kvm_vcpu_is_blocking(struct kvm_vcpu *vcpu)
+{
+	return rcuwait_active(kvm_arch_vcpu_get_wait(vcpu));
+}
+
 #ifdef __KVM_HAVE_ARCH_INTC_INITIALIZED
 /*
  * returns true if the virtual interrupt controller is initialized and
diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index ccb35c22785e..9bfe1d6f6529 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -85,7 +85,7 @@ static void async_pf_execute(struct work_struct *work)
 
 	trace_kvm_async_pf_completed(addr, cr2_or_gpa);
 
-	rcuwait_wake_up(kvm_arch_vcpu_get_wait(vcpu));
+	__kvm_vcpu_wake_up(vcpu);
 
 	mmput(mm);
 	kvm_put_kvm(vcpu->kvm);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 481e8178b43d..c870cae7e776 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3332,10 +3332,7 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_halt);
 
 bool kvm_vcpu_wake_up(struct kvm_vcpu *vcpu)
 {
-	struct rcuwait *waitp;
-
-	waitp = kvm_arch_vcpu_get_wait(vcpu);
-	if (rcuwait_wake_up(waitp)) {
+	if (__kvm_vcpu_wake_up(vcpu)) {
 		WRITE_ONCE(vcpu->ready, true);
 		++vcpu->stat.generic.halt_wakeup;
 		return true;
@@ -3490,8 +3487,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
 				continue;
 			if (vcpu == me)
 				continue;
-			if (rcuwait_active(kvm_arch_vcpu_get_wait(vcpu)) &&
-			    !vcpu_dy_runnable(vcpu))
+			if (kvm_vcpu_is_blocking(vcpu) && !vcpu_dy_runnable(vcpu))
 				continue;
 			if (READ_ONCE(vcpu->preempted) && yield_to_kernel_mode &&
 			    !kvm_arch_dy_has_pending_interrupt(vcpu) &&
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

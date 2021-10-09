Return-Path: <SRS0=FNOB=O5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A89FC433EF
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:14:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 00FF860F5E
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:14:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 00FF860F5E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AACC24B10E;
	Fri,  8 Oct 2021 22:14:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xh0FmnMmXZkT; Fri,  8 Oct 2021 22:14:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9EED04B1AF;
	Fri,  8 Oct 2021 22:14:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5637D4B093
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:14:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id N9EZpEgeJsro for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Oct 2021 22:14:01 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 522FA4B12E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:14:01 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 v70-20020a256149000000b005ba4d61ea0fso11140892ybb.22
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Oct 2021 19:14:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=b2NFNOmcSkF8bnqGQwOgX6HnOIy2SSUQ2D5ginVhVO0=;
 b=IRLCbLMzdCb5UchOOv+Z0PtnZNSSoLW6N5YOs8Rf0ByvWkZw9fnrXDff7+K/1lsj6B
 NqqIJpk8pE4GidDTxI/LosWoSgWzx3bzDSM/n8KN7DTXuN2T17CPaZXkgIYzDMTtYTRb
 lzcpdr5xg4vfvZJBl69uVsKH5UNXjyyhFo8HAy7LJRDbUM63L3M5Gxx882mRoBUHmman
 GjJKxe2tvpIReuijhcU3M4KaZ5D41tl+LVTPtXRV7z3IcuqwUUZuaoObrBjmhydK/TA3
 cbKULKY59/B6tcCWrJFg3N/GGr3AkBsO6Nwaaye8gGjJSjaELsGsbRMT7ru8tM6UfG9M
 F3tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=b2NFNOmcSkF8bnqGQwOgX6HnOIy2SSUQ2D5ginVhVO0=;
 b=Yga09GarF74JNNfdSB2VNclyduQFiVxqTf40JrioCsYmqqmCY+KovR3DxdEPRda1JH
 iLpCaO5cojnAi/n+DWo81izbVQ7wG0j+kpRuLB+HBooBiWzg2CNeAOMnHEOEIkqRAo5i
 XiyUuu5t7cw/YuNkPnwZZwMhIvaR6AItrV/ow9mtFeswYasRDMlY2oYFR7AYvxX5TO4T
 L4gl/N7EDuCdK+e+YURgR8FW/NL7o6fZ2fiFeOFf7oe6uCpEMPrPQnVX37cgeNe/qtED
 j5dkNuci9FWJ1oECQMKaBi9yOXuD8H/pJ8tWKMXEw00oDOwlmvXbI9AguAJzfczdbqlf
 ODwA==
X-Gm-Message-State: AOAM5313lguh5Zmq3pBQS0KwkXzYrBoztWCDMSaEhmSxNx9X9nS7Eti+
 XN3H918qQYwoj+zQfOqOPbYgjaYDkRI=
X-Google-Smtp-Source: ABdhPJy92pUNk0vuThAHgG1KxnUNqELL/2Mc4x65Hyxv1JIWcnbmS+hS8GZ8i+88Ll6DtaYL/pxizDjGj2U=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:a25:d607:: with SMTP id
 n7mr8053144ybg.96.1633745640889; 
 Fri, 08 Oct 2021 19:14:00 -0700 (PDT)
Date: Fri,  8 Oct 2021 19:12:25 -0700
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Message-Id: <20211009021236.4122790-33-seanjc@google.com>
Mime-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2 32/43] KVM: VMX: Move preemption timer <=> hrtimer dance to
 common x86
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

Handle the switch to/from the hypervisor/software timer when a vCPU is
blocking in common x86 instead of in VMX.  Even though VMX is the only
user of a hypervisor timer, the logic and all functions involved are
generic x86 (unless future CPUs do something completely different and
implement a hypervisor timer that runs regardless of mode).

Handling the switch in common x86 will allow for the elimination of the
pre/post_blocks hooks, and also lets KVM switch back to the hypervisor
timer if and only if it was in use (without additional params).  Add a
comment explaining why the switch cannot be deferred to kvm_sched_out()
or kvm_vcpu_block().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c |  6 +-----
 arch/x86/kvm/x86.c     | 21 +++++++++++++++++++++
 2 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b3bb2031a7ac..a24f19874716 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7464,16 +7464,12 @@ void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
 
 static int vmx_pre_block(struct kvm_vcpu *vcpu)
 {
-	if (kvm_lapic_hv_timer_in_use(vcpu))
-		kvm_lapic_switch_to_sw_timer(vcpu);
-
 	return 0;
 }
 
 static void vmx_post_block(struct kvm_vcpu *vcpu)
 {
-	if (kvm_x86_ops.set_hv_timer)
-		kvm_lapic_switch_to_hv_timer(vcpu);
+
 }
 
 static void vmx_setup_mce(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e0219acfd9cf..909e932a7ae7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9896,8 +9896,21 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
 {
+	bool hv_timer;
+
 	if (!kvm_arch_vcpu_runnable(vcpu) &&
 	    (!kvm_x86_ops.pre_block || static_call(kvm_x86_pre_block)(vcpu) == 0)) {
+		/*
+		 * Switch to the software timer before halt-polling/blocking as
+		 * the guest's timer may be a break event for the vCPU, and the
+		 * hypervisor timer runs only when the CPU is in guest mode.
+		 * Switch before halt-polling so that KVM recognizes an expired
+		 * timer before blocking.
+		 */
+		hv_timer = kvm_lapic_hv_timer_in_use(vcpu);
+		if (hv_timer)
+			kvm_lapic_switch_to_sw_timer(vcpu);
+
 		srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
 		if (vcpu->arch.mp_state == KVM_MP_STATE_HALTED)
 			kvm_vcpu_halt(vcpu);
@@ -9905,6 +9918,9 @@ static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
 			kvm_vcpu_block(vcpu);
 		vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
 
+		if (hv_timer)
+			kvm_lapic_switch_to_hv_timer(vcpu);
+
 		if (kvm_x86_ops.post_block)
 			static_call(kvm_x86_post_block)(vcpu);
 
@@ -10136,6 +10152,11 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 			r = -EINTR;
 			goto out;
 		}
+		/*
+		 * It should be impossible for the hypervisor timer to be in
+		 * use before KVM has ever run the vCPU.
+		 */
+		WARN_ON_ONCE(kvm_lapic_hv_timer_in_use(vcpu));
 		kvm_vcpu_block(vcpu);
 		if (kvm_apic_accept_events(vcpu) < 0) {
 			r = 0;
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

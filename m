Return-Path: <SRS0=FNOB=O5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50245C433EF
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:13:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 03B0960FD7
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:13:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 03B0960FD7
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AAB184B133;
	Fri,  8 Oct 2021 22:13:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zgivJ9IBrtY1; Fri,  8 Oct 2021 22:13:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DD174B120;
	Fri,  8 Oct 2021 22:13:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1384B4B11E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:13:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dsCRhMTCSNHt for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Oct 2021 22:13:07 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EF3AA4B108
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:13:06 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 x16-20020a25b910000000b005b6b7f2f91cso15202570ybj.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Oct 2021 19:13:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=7UfiFA3j2+6I2+nAWNhD8/i07R8fVsAS1/w0N/aa090=;
 b=aR3og+oc7PMwu8Forg7HYvRnh8xW7rVTXkNeNN4GEdGb9eMQr0BxriYw1WCEWH/rps
 CzI5rGwFNvewdmiYYfcjmrHJ37omSwRaaK67pX54nsvHJAX1QmuyS8m7A3T8srDuMpEq
 INyVvjKgNRHRhfke+WD+WgtgVp7aMSP1M/d2iLvOmKfjBg4cec31at7qrXlRe57r1WT/
 UsDhrANY7t02k9VZy8hnTd7ysR/TwUt+OFlZh1HvACIu+5QAPMNvmCZ5hIypKdufBScF
 7Y9CJreS/iw7TnDZqwI7dewLqo50Fs3ke9ye+sR1ax5lX0kayCH6nt5LFfkuoh7frLyk
 0n3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=7UfiFA3j2+6I2+nAWNhD8/i07R8fVsAS1/w0N/aa090=;
 b=h/nixriI3IJMTegXhpU53ut/Ady4vkUlqCQZD8XKTyT5d8WBYngmOAk84f7w/IbQuD
 eG51pEuZw/EGzPcno2qFgySyI/dtxgQfGgEnAu2X6qimX0P1N2DsZATKRdDyHKcqRZzq
 FIWODB7V/9sIs0P/MnTKj/EiVE0fvqPqjhVWnWOOH6DZ6KvYSmp7wGjhTM81qv5DWAU1
 S0V/Qjtna+70sSTH0ZyrCnY+sdFw8O7mU8huOXRoIWFqOp13Hig6+iJ7JadFTNIKZHmo
 5vhHuwUCiLzOEl/dJoWsmK1Xd2F85zaVhmO4yDQPcxrskIylc9e8xiD+BQBVPGpcdNx0
 yvmg==
X-Gm-Message-State: AOAM531JhDL1QfyAgwTSAykteCOVvE80LY1ZkDzDjcIDDqaHy9z1dU03
 seLZ4+NZVgtqn/+bv22vXMjlOxW391k=
X-Google-Smtp-Source: ABdhPJx5tQAxYIWw/UxfnO+GS3ZmVIvpanbA+F5BzOK+h+G2iaAxrnXRERnnpv1JgyJw5hk8wtX6cvBcEV4=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:a5b:110:: with SMTP id
 16mr7306011ybx.392.1633745586492; 
 Fri, 08 Oct 2021 19:13:06 -0700 (PDT)
Date: Fri,  8 Oct 2021 19:12:03 -0700
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Message-Id: <20211009021236.4122790-11-seanjc@google.com>
Mime-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2 10/43] KVM: arm64: Move vGIC v4 handling for WFI out arch
 callback hook
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

Move the put and reload of the vGIC out of the block/unblock callbacks
and into a dedicated WFI helper.  Functionally, this is nearly a nop as
the block hook is called at the very beginning of kvm_vcpu_block(), and
the only code in kvm_vcpu_block() after the unblock hook is to update the
halt-polling controls, i.e. can only affect the next WFI.

Back when the arch (un)blocking hooks were added by commits 3217f7c25bca
("KVM: Add kvm_arch_vcpu_{un}blocking callbacks) and d35268da6687
("arm/arm64: KVM: arch_timer: Only schedule soft timer on vcpu_block"),
the hooks were invoked only when KVM was about to "block", i.e. schedule
out the vCPU.  The use case at the time was to schedule a timer in the
host based on the earliest timer in the guest in order to wake the
blocking vCPU when the emulated guest timer fired.  Commit accb99bcd0ca
("KVM: arm/arm64: Simplify bg_timer programming") reworked the timer
logic to be even more precise, by waiting until the vCPU was actually
scheduled out, and so move the timer logic from the (un)blocking hooks to
vcpu_load/put.

In the meantime, the hooks gained usage for enabling vGIC v4 doorbells in
commit df9ba95993b9 ("KVM: arm/arm64: GICv4: Use the doorbell interrupt
as an unblocking source"), and added related logic for the VMCR in commit
5eeaf10eec39 ("KVM: arm/arm64: Sync ICH_VMCR_EL2 back when about to block").

Finally, commit 07ab0f8d9a12 ("KVM: Call kvm_arch_vcpu_blocking early
into the blocking sequence") hoisted the (un)blocking hooks so that they
wrapped KVM's halt-polling logic in addition to the core "block" logic.

In other words, the original need for arch hooks to take action _only_
in the block path is long since gone.

Cc: Oliver Upton <oupton@google.com>
Cc: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/include/asm/kvm_emulate.h |  2 ++
 arch/arm64/kvm/arm.c                 | 52 +++++++++++++++++++---------
 arch/arm64/kvm/handle_exit.c         |  3 +-
 3 files changed, 38 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index fd418955e31e..de8b4f5922b7 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -41,6 +41,8 @@ void kvm_inject_vabt(struct kvm_vcpu *vcpu);
 void kvm_inject_dabt(struct kvm_vcpu *vcpu, unsigned long addr);
 void kvm_inject_pabt(struct kvm_vcpu *vcpu, unsigned long addr);
 
+void kvm_vcpu_wfi(struct kvm_vcpu *vcpu);
+
 static __always_inline bool vcpu_el1_is_32bit(struct kvm_vcpu *vcpu)
 {
 	return !(vcpu->arch.hcr_el2 & HCR_RW);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 7838e9fb693e..1346f81b34df 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -359,27 +359,12 @@ int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 
 void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
 {
-	/*
-	 * If we're about to block (most likely because we've just hit a
-	 * WFI), we need to sync back the state of the GIC CPU interface
-	 * so that we have the latest PMR and group enables. This ensures
-	 * that kvm_arch_vcpu_runnable has up-to-date data to decide
-	 * whether we have pending interrupts.
-	 *
-	 * For the same reason, we want to tell GICv4 that we need
-	 * doorbells to be signalled, should an interrupt become pending.
-	 */
-	preempt_disable();
-	kvm_vgic_vmcr_sync(vcpu);
-	vgic_v4_put(vcpu, true);
-	preempt_enable();
+
 }
 
 void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
 {
-	preempt_disable();
-	vgic_v4_load(vcpu);
-	preempt_enable();
+
 }
 
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
@@ -662,6 +647,39 @@ static void vcpu_req_sleep(struct kvm_vcpu *vcpu)
 	smp_rmb();
 }
 
+/**
+ * kvm_vcpu_wfi - emulate Wait-For-Interrupt behavior
+ * @vcpu:	The VCPU pointer
+ *
+ * Suspend execution of a vCPU until a valid wake event is detected, i.e. until
+ * the vCPU is runnable.  The vCPU may or may not be scheduled out, depending
+ * on when a wake event arrives, e.g. there may already be a pending wake event.
+ */
+void kvm_vcpu_wfi(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * Sync back the state of the GIC CPU interface so that we have
+	 * the latest PMR and group enables. This ensures that
+	 * kvm_arch_vcpu_runnable has up-to-date data to decide whether
+	 * we have pending interrupts, e.g. when determining if the
+	 * vCPU should block.
+	 *
+	 * For the same reason, we want to tell GICv4 that we need
+	 * doorbells to be signalled, should an interrupt become pending.
+	 */
+	preempt_disable();
+	kvm_vgic_vmcr_sync(vcpu);
+	vgic_v4_put(vcpu, true);
+	preempt_enable();
+
+	kvm_vcpu_block(vcpu);
+	kvm_clear_request(KVM_REQ_UNHALT, vcpu);
+
+	preempt_disable();
+	vgic_v4_load(vcpu);
+	preempt_enable();
+}
+
 static int kvm_vcpu_initialized(struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.target >= 0;
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 275a27368a04..4794563a506b 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -95,8 +95,7 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu)
 	} else {
 		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), false);
 		vcpu->stat.wfi_exit_stat++;
-		kvm_vcpu_block(vcpu);
-		kvm_clear_request(KVM_REQ_UNHALT, vcpu);
+		kvm_vcpu_wfi(vcpu);
 	}
 
 	kvm_incr_pc(vcpu);
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

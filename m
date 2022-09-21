Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92BA1C6FA92
	for <kvmarm@archiver.kernel.org>; Wed, 21 Sep 2022 00:32:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 28C6F4B731;
	Tue, 20 Sep 2022 20:32:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id t9pJJgN930ew; Tue, 20 Sep 2022 20:32:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DCD764B752;
	Tue, 20 Sep 2022 20:32:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DE8CD4B73E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 20:32:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hnWJ57V0OO7C for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2022 20:32:50 -0400 (EDT)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 182BA4B712
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 20:32:50 -0400 (EDT)
Received: by mail-pf1-f201.google.com with SMTP id
 cg5-20020a056a00290500b0053511889856so2557608pfb.18
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 17:32:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc:subject:date;
 bh=v7YHpsXihO1IGC0K/PKlA8GEkrI37lPnwhd36LF7pVk=;
 b=T4Pq1vwhu58JKk9S6MS0EL1IJhE9KPvx6f3kP5213oRycLCnCPGalTsox3aAjnkBY+
 bvrARzyrfMnXa376luKHrUSUC3r41vDBz/363U0/GCT1m+sgrmqVasY3fcU9OUU8ZnQr
 fGLzK1tbOFeQ4wKJzJP+i1caYDQsEDEbwf5IEBhf8mxzB0P/PeEP0jzwrUt5tUlgn1vs
 khV0dI6DS92WUbMb+SK3UCu6WG61MT61dVs3It8NhZZ7b/6/vq2QNm9LhdsajCmXKYhu
 RM5VBfvag1jIjc/ktzcq5owOd+kKUM+xzeu/Nh4l3/G9+HsymuEMfqdrfo6zFFuJfavG
 EM4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
 bh=v7YHpsXihO1IGC0K/PKlA8GEkrI37lPnwhd36LF7pVk=;
 b=iwBPQ/TD1vCXQmT3p+zzuMo6m1huERhVbxgFUjawU59nZsyGT3ubRXHund9FPSpTGy
 gUaEW/YP06Mj97rfXnmCnLHFNlzxN3YQgauKM0fr3oggXfFdm2vIhc3WkSdMAM0/duj0
 SDAUSK8nfgB9wVT5cyHnCyZqTMD5ujs/bAKlmZ32EDAXi/TZDj4ZWhla9CNjbDi655gX
 nvIxlJSXJ6xzx0B8HszSrw8GMNofAlszFndEyfie9NtICby6zpGIx+InLlJNEFul5kYk
 yjEJGLHvwGx5VYh+58HqkyUNxN4ftyQR7ir3lhev6zYG2lPJh9M47AUxrR7lXQa9nm10
 hMbQ==
X-Gm-Message-State: ACrzQf2NM/OQyJzdazCp9gc4zXtkD0DBTulyhif1URBqpOSzd5o0hAOm
 B9+xYsgARuJ019OcmwOvn7wCRFcFmpM=
X-Google-Smtp-Source: AMsMyM7sgUnowEJxKriF2nS2mMYPc53K7RWElo5y1ug5fX5KhtVWX0U//x1MzIKxCHK8PGNETQVSyl6SEZ4=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f644:b0:172:b074:d1f5 with SMTP id
 m4-20020a170902f64400b00172b074d1f5mr2177656plg.29.1663720369344; Tue, 20 Sep
 2022 17:32:49 -0700 (PDT)
Date: Wed, 21 Sep 2022 00:31:50 +0000
In-Reply-To: <20220921003201.1441511-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220921003201.1441511-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220921003201.1441511-2-seanjc@google.com>
Subject: [PATCH v4 01/12] KVM: x86: make vendor code check for all nested
 events
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
 Huacai Chen <chenhuacai@kernel.org>, 
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Anup Patel <anup@brainfault.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 linuxppc-dev@lists.ozlabs.org, linux-mips@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Atish Patra <atishp@atishpatra.org>, linux-riscv@lists.infradead.org,
 Maxim Levitsky <mlevitsk@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

From: Paolo Bonzini <pbonzini@redhat.com>

Interrupts, NMIs etc. sent while in guest mode are already handled
properly by the *_interrupt_allowed callbacks, but other events can
cause a vCPU to be runnable that are specific to guest mode.

In the case of VMX there are two, the preemption timer and the
monitor trap.  The VMX preemption timer is already special cased via
the hv_timer_pending callback, but the purpose of the callback can be
easily extended to MTF or in fact any other event that can occur only
in guest mode.

Rename the callback and add an MTF check; kvm_arch_vcpu_runnable()
now can return true if an MTF is pending, without relying on
kvm_vcpu_running()'s call to kvm_check_nested_events().  Until that call
is removed, however, the patch introduces no functional change.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 arch/x86/kvm/vmx/nested.c       | 8 +++++++-
 arch/x86/kvm/x86.c              | 8 ++++----
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ee940c4c0f64..c03590d1c5e1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1649,7 +1649,7 @@ struct kvm_x86_nested_ops {
 	bool (*is_exception_vmexit)(struct kvm_vcpu *vcpu, u8 vector,
 				    u32 error_code);
 	int (*check_events)(struct kvm_vcpu *vcpu);
-	bool (*hv_timer_pending)(struct kvm_vcpu *vcpu);
+	bool (*has_events)(struct kvm_vcpu *vcpu);
 	void (*triple_fault)(struct kvm_vcpu *vcpu);
 	int (*get_state)(struct kvm_vcpu *vcpu,
 			 struct kvm_nested_state __user *user_kvm_nested_state,
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 4da0558943ce..85318d803f4f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3929,6 +3929,12 @@ static bool nested_vmx_preemption_timer_pending(struct kvm_vcpu *vcpu)
 	       to_vmx(vcpu)->nested.preemption_timer_expired;
 }
 
+static bool vmx_has_nested_events(struct kvm_vcpu *vcpu)
+{
+	return nested_vmx_preemption_timer_pending(vcpu) ||
+	       to_vmx(vcpu)->nested.mtf_pending;
+}
+
 /*
  * Per the Intel SDM's table "Priority Among Concurrent Events", with minor
  * edits to fill in missing examples, e.g. #DB due to split-lock accesses,
@@ -6971,7 +6977,7 @@ struct kvm_x86_nested_ops vmx_nested_ops = {
 	.leave_nested = vmx_leave_nested,
 	.is_exception_vmexit = nested_vmx_is_exception_vmexit,
 	.check_events = vmx_check_nested_events,
-	.hv_timer_pending = nested_vmx_preemption_timer_pending,
+	.has_events = vmx_has_nested_events,
 	.triple_fault = nested_vmx_triple_fault,
 	.get_state = vmx_get_nested_state,
 	.set_state = vmx_set_nested_state,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5b8328cb6c14..e1a25e46dbf7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9966,8 +9966,8 @@ static int kvm_check_and_inject_events(struct kvm_vcpu *vcpu,
 	}
 
 	if (is_guest_mode(vcpu) &&
-	    kvm_x86_ops.nested_ops->hv_timer_pending &&
-	    kvm_x86_ops.nested_ops->hv_timer_pending(vcpu))
+	    kvm_x86_ops.nested_ops->has_events &&
+	    kvm_x86_ops.nested_ops->has_events(vcpu))
 		*req_immediate_exit = true;
 
 	WARN_ON(kvm_is_exception_pending(vcpu));
@@ -12792,8 +12792,8 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
 		return true;
 
 	if (is_guest_mode(vcpu) &&
-	    kvm_x86_ops.nested_ops->hv_timer_pending &&
-	    kvm_x86_ops.nested_ops->hv_timer_pending(vcpu))
+	    kvm_x86_ops.nested_ops->has_events &&
+	    kvm_x86_ops.nested_ops->has_events(vcpu))
 		return true;
 
 	if (kvm_xen_has_pending_events(vcpu))
-- 
2.37.3.968.ga6b4b080e4-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

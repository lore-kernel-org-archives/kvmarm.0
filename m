Return-Path: <SRS0=nF4w=P6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1CC4C4332F
	for <kvmarm@archiver.kernel.org>; Thu, 11 Nov 2021 02:08:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 634D0619E1
	for <kvmarm@archiver.kernel.org>; Thu, 11 Nov 2021 02:08:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 634D0619E1
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 152FB4B25B;
	Wed, 10 Nov 2021 21:08:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jxo18AGvrEJS; Wed, 10 Nov 2021 21:08:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4219F4B260;
	Wed, 10 Nov 2021 21:08:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A86DD4B15A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 21:08:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wnmVy1jfxNoy for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Nov 2021 21:08:01 -0500 (EST)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BDCE24B25C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 21:07:59 -0500 (EST)
Received: by mail-pf1-f201.google.com with SMTP id
 k63-20020a628442000000b004812ea67c34so3074787pfd.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 18:07:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=BFR/1q5iLt3yf5kWLtXoY89YerPRd53Fbf8elisWPU4=;
 b=EyJdNG55YlgiJw0AhwmBWiBKFN2bqclVs6tFme/MMuM8bhcjKJQBF0OcoJBKQN4Yga
 axZl4D8H01llZcE+B1lMipS7te9ff2VOp7tm63SOZ0bYgRPgOvv7dz7am2CWgxpg0t7P
 MNRfZq3ijQaVJG2uCad7xkxWh1HPBFRFulQ+NTiiERVK6s/+qvvEEXRWQscxLcYr8ons
 RAPjBHbZ9nw0KZopTSMI8rlJItEVAXh71vLtMjT3aiL6FIEsbFQlPdO+7CY5ZUb3d8zc
 4THP+pE5BT9GJwVdJXE8nIpJ82zKI4sbu9siyG5CLHKeyWKTSNq0cqo3I766dA0RjB8y
 OjyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=BFR/1q5iLt3yf5kWLtXoY89YerPRd53Fbf8elisWPU4=;
 b=nvVpG3mPPs3j5WhV90L5+uRJi2JjFrwLL6ocDCoarVxsCA2lI43b7wipJh+sd4RrFl
 PT59DhTWGdI9e1lRULwdVMZYP22468QwsF1UNltM1CPKakdk4ktBra8L5nPngu0fHwJJ
 s7OhAujIalM/bBgKNxOmgzhIMm4appfaMEDir5kYY+IKT6l7UVX7MIkTYottjWsS4U64
 cKJh9xNRO3olXfzmfun7ne+MyL7b99eWyf+ost0zUUr9dkOIc6HpsI3hHzdHgOgvFvJL
 dKBhZsBdTkWSOv+oY1VksveHb95VrLQTxvTDFjwQYSt3sk29GHftW9sKCDqLn3s78LNA
 F11Q==
X-Gm-Message-State: AOAM531USy0hnKmChedKrkqsp6+pe8QFDPIhQ18lhGFYcO9xTg0rDQlh
 BxWs9Fx+Jw+3XOZkTwQ2bwVaGCxAGRw=
X-Google-Smtp-Source: ABdhPJzd8hxvmP15QQtACiUYvwIBDjhv9tE00/OdnnHyX3h6LjesiRmUGTAqyb2RSiJlII09jv6jyEbG1Qo=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:c403:: with SMTP id
 i3mr23027931pjt.203.1636596478856; Wed, 10 Nov 2021 18:07:58 -0800 (PST)
Date: Thu, 11 Nov 2021 02:07:32 +0000
In-Reply-To: <20211111020738.2512932-1-seanjc@google.com>
Message-Id: <20211111020738.2512932-12-seanjc@google.com>
Mime-Version: 1.0
References: <20211111020738.2512932-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH v4 11/17] KVM: x86: More precisely identify NMI from guest
 when handling PMI
From: Sean Christopherson <seanjc@google.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, 
 Russell King <linux@armlinux.org.uk>, Marc Zyngier <maz@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, Guo Ren <guoren@kernel.org>, 
 Nick Hu <nickhu@andestech.com>, Greentime Hu <green.hu@gmail.com>, 
 Vincent Chen <deanbo422@gmail.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 Paolo Bonzini <pbonzini@redhat.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, 
 Juergen Gross <jgross@suse.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, linux-riscv@lists.infradead.org,
 Jiri Olsa <jolsa@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Stefano Stabellini <sstabellini@kernel.org>, Like Xu <like.xu@linux.intel.com>,
 Joerg Roedel <joro@8bytes.org>, linux-csky@vger.kernel.org,
 xen-devel@lists.xenproject.org, Zhu Lingshan <lingshan.zhu@intel.com>,
 Namhyung Kim <namhyung@kernel.org>,
 Artem Kashkanov <artem.kashkanov@intel.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Like Xu <like.xu.linux@gmail.com>, linux-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>
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

Differentiate between IRQ and NMI for KVM's PMC overflow callback, which
was originally invoked in response to an NMI that arrived while the guest
was running, but was inadvertantly changed to fire on IRQs as well when
support for perf without PMU/NMI was added to KVM.  In practice, this
should be a nop as the PMC overflow callback shouldn't be reached, but
it's a cheap and easy fix that also better documents the situation.

Note, this also doesn't completely prevent false positives if perf
somehow ends up calling into KVM, e.g. an NMI can arrive in host after
KVM sets its flag.

Fixes: dd60d217062f ("KVM: x86: Fix perf timer mode IP reporting")
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c |  2 +-
 arch/x86/kvm/vmx/vmx.c |  4 +++-
 arch/x86/kvm/x86.c     |  2 +-
 arch/x86/kvm/x86.h     | 13 ++++++++++---
 4 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b36ca4e476c2..df6a3e0bdcde 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3936,7 +3936,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	}
 
 	if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
-		kvm_before_interrupt(vcpu);
+		kvm_before_interrupt(vcpu, KVM_HANDLING_NMI);
 
 	kvm_load_host_xsave_state(vcpu);
 	stgi();
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0927d07b2efb..36098eb9a7f9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6371,7 +6371,9 @@ void vmx_do_interrupt_nmi_irqoff(unsigned long entry);
 static void handle_interrupt_nmi_irqoff(struct kvm_vcpu *vcpu,
 					unsigned long entry)
 {
-	kvm_before_interrupt(vcpu);
+	bool is_nmi = entry == (unsigned long)asm_exc_nmi_noist;
+
+	kvm_before_interrupt(vcpu, is_nmi ? KVM_HANDLING_NMI : KVM_HANDLING_IRQ);
 	vmx_do_interrupt_nmi_irqoff(entry);
 	kvm_after_interrupt(vcpu);
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c8ef49385c99..e9e1a4bb1d00 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9837,7 +9837,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	 * interrupts on processors that implement an interrupt shadow, the
 	 * stat.exits increment will do nicely.
 	 */
-	kvm_before_interrupt(vcpu);
+	kvm_before_interrupt(vcpu, KVM_HANDLING_IRQ);
 	local_irq_enable();
 	++vcpu->stat.exits;
 	local_irq_disable();
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index d070043fd2e8..f8d2c58feadc 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -385,9 +385,16 @@ static inline bool kvm_cstate_in_guest(struct kvm *kvm)
 	return kvm->arch.cstate_in_guest;
 }
 
-static inline void kvm_before_interrupt(struct kvm_vcpu *vcpu)
+enum kvm_intr_type {
+	/* Values are arbitrary, but must be non-zero. */
+	KVM_HANDLING_IRQ = 1,
+	KVM_HANDLING_NMI,
+};
+
+static inline void kvm_before_interrupt(struct kvm_vcpu *vcpu,
+					enum kvm_intr_type intr)
 {
-	WRITE_ONCE(vcpu->arch.handling_intr_from_guest, 1);
+	WRITE_ONCE(vcpu->arch.handling_intr_from_guest, (u8)intr);
 }
 
 static inline void kvm_after_interrupt(struct kvm_vcpu *vcpu)
@@ -397,7 +404,7 @@ static inline void kvm_after_interrupt(struct kvm_vcpu *vcpu)
 
 static inline bool kvm_handling_nmi_from_guest(struct kvm_vcpu *vcpu)
 {
-	return !!vcpu->arch.handling_intr_from_guest;
+	return vcpu->arch.handling_intr_from_guest == KVM_HANDLING_NMI;
 }
 
 static inline bool kvm_pat_valid(u64 data)
-- 
2.34.0.rc0.344.g81b53c2807-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <SRS0=1o63=IY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1641C433E1
	for <kvmarm@archiver.kernel.org>; Fri, 26 Mar 2021 13:54:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8E0CC61A1D
	for <kvmarm@archiver.kernel.org>; Fri, 26 Mar 2021 13:54:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8E0CC61A1D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CB0D4B448;
	Fri, 26 Mar 2021 09:54:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WO+sjU1BDizE; Fri, 26 Mar 2021 09:54:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D13C4B4C2;
	Fri, 26 Mar 2021 09:54:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 901964B488
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Mar 2021 22:20:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IyA63MgPpEcQ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Mar 2021 22:20:29 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 87E684B1E6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Mar 2021 22:20:29 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id f75so8101825yba.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Mar 2021 19:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=TJ1NUSk1GLSfqgDLwJHTOvG8sJKDNqf4viNk18VjKYo=;
 b=EdH+MQMlq9K3NZE/QJpnecrIsQDbVa65LdQms8OUGXWWpfpYFJnuhWs2rq7TcHjpDq
 pCYtvjmoUxEHpN+E1h9PLwkdrJ1ALR7vaQ8K9DXsdjSZh2YseC5DINhzQQjMqaQmuGTA
 OtpKaXL9Fco/djGBD992n9sq6fKLeJ6eS4tl43w1X11oUNO4qUTS5nV8NpYLJopqKtBP
 JY+TUDHqJjicrZujGxNk5mBb6AgYo+xnomEiIKjkry8Rud1FrliNZgfyW9VqpygR6q4o
 askVlrUa0FZQhLta15P0aW9vXCsEoYuJLlz+qNgb18Lf5rX6GFjh/gWYd+LcigWG7nHX
 IWeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=TJ1NUSk1GLSfqgDLwJHTOvG8sJKDNqf4viNk18VjKYo=;
 b=ErwJcQYugjTHVqy1ReGcfN/eGJ6EQKwnwqed9e68QJLuzkf07UC95VdUQrQ50KX4j0
 S3s5HxVufGfmeKDa31M259THGGgWEF9chUymolM83zKffKpprhbcK00yzPUmWfCTO4CU
 eFubuvQ/qHnc56HWaApbCCdHbc1K2yzBFJw2QmxDrp8IBg5Uh1Q0/otYJDY18e6gixep
 NVJoh3Jc1AD6TKeb42C3+fzoVK7lznK5zQzXmS8HPGKfgD7+98uDc3jhGZX6hPtFGs4w
 Gpqf1mb0ImHwbRuH8GafQLhyEaijMDHNitI0JZU6poL6gURMqoigb4ZIodnQpcB/kjHb
 sgEw==
X-Gm-Message-State: AOAM531h0306gt6x31tsP8n2bzQ8+tyf72iZazoqWcKu1z3DhOXpREOS
 lmsh0BhntOOlw/Jo1AeF1Aq58oFQoUg=
X-Google-Smtp-Source: ABdhPJyjTzhMUsvBcDeO5HnO1o8pMJu/Pf6cqTV1gYjxP6rrgfWVB7Wh+dDzlNrLO5iiBOh2qPwlx8SGkDg=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:f:10:b1bb:fab2:7ef5:fc7d])
 (user=seanjc job=sendgmr) by 2002:a25:d44f:: with SMTP id
 m76mr17466319ybf.101.1616725229004; 
 Thu, 25 Mar 2021 19:20:29 -0700 (PDT)
Date: Thu, 25 Mar 2021 19:19:47 -0700
In-Reply-To: <20210326021957.1424875-1-seanjc@google.com>
Message-Id: <20210326021957.1424875-9-seanjc@google.com>
Mime-Version: 1.0
References: <20210326021957.1424875-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH 08/18] KVM: Move prototypes for MMU notifier callbacks to
 generic code
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>, Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Fri, 26 Mar 2021 09:54:23 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Sean Christopherson <seanjc@google.com>, Joerg Roedel <joro@8bytes.org>,
 linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Ben Gardon <bgardon@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 kvmarm@lists.cs.columbia.edu, Jim Mattson <jmattson@google.com>
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

Move the prototypes for the MMU notifier callbacks out of arch code and
into common code.  There is no benefit to having each arch replicate the
prototypes since any deviation from the invocation in common code will
explode.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/include/asm/kvm_host.h   | 5 -----
 arch/mips/include/asm/kvm_host.h    | 5 -----
 arch/powerpc/include/asm/kvm_host.h | 7 -------
 arch/x86/include/asm/kvm_host.h     | 6 +-----
 include/linux/kvm_host.h            | 8 ++++++++
 5 files changed, 9 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 3d10e6527f7d..72e6b4600264 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -582,11 +582,6 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
 			      struct kvm_vcpu_events *events);
 
 #define KVM_ARCH_WANT_MMU_NOTIFIER
-int kvm_unmap_hva_range(struct kvm *kvm,
-			unsigned long start, unsigned long end, unsigned flags);
-int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
-int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
-int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
 
 void kvm_arm_halt_guest(struct kvm *kvm);
 void kvm_arm_resume_guest(struct kvm *kvm);
diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index 3a5612e7304c..feaa77036b67 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -967,11 +967,6 @@ enum kvm_mips_fault_result kvm_trap_emul_gva_fault(struct kvm_vcpu *vcpu,
 						   bool write);
 
 #define KVM_ARCH_WANT_MMU_NOTIFIER
-int kvm_unmap_hva_range(struct kvm *kvm,
-			unsigned long start, unsigned long end, unsigned flags);
-int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
-int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
-int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
 
 /* Emulation */
 int kvm_get_inst(u32 *opc, struct kvm_vcpu *vcpu, u32 *out);
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 05fb00d37609..1e83359f286b 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -56,13 +56,6 @@
 
 #define KVM_ARCH_WANT_MMU_NOTIFIER
 
-extern int kvm_unmap_hva_range(struct kvm *kvm,
-			       unsigned long start, unsigned long end,
-			       unsigned flags);
-extern int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
-extern int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
-extern int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
-
 #define HPTEG_CACHE_NUM			(1 << 15)
 #define HPTEG_HASH_BITS_PTE		13
 #define HPTEG_HASH_BITS_PTE_LONG	12
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a52f973bdff6..99778ac51243 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1718,11 +1718,7 @@ asmlinkage void kvm_spurious_fault(void);
 	_ASM_EXTABLE(666b, 667b)
 
 #define KVM_ARCH_WANT_MMU_NOTIFIER
-int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end,
-			unsigned flags);
-int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
-int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
-int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
+
 int kvm_cpu_has_injectable_intr(struct kvm_vcpu *v);
 int kvm_cpu_has_interrupt(struct kvm_vcpu *vcpu);
 int kvm_cpu_has_extint(struct kvm_vcpu *v);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 1b65e7204344..e6d77353025c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -218,6 +218,14 @@ bool kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
 #endif
 
+#ifdef KVM_ARCH_WANT_MMU_NOTIFIER
+int kvm_unmap_hva_range(struct kvm *kvm,
+			unsigned long start, unsigned long end, unsigned flags);
+int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
+int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
+int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
+#endif
+
 enum {
 	OUTSIDE_GUEST_MODE,
 	IN_GUEST_MODE,
-- 
2.31.0.291.g576ba9dcdaf-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

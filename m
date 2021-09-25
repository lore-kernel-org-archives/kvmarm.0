Return-Path: <SRS0=Rd7Q=OP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50E85C433EF
	for <kvmarm@archiver.kernel.org>; Sat, 25 Sep 2021 00:55:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 07D556125F
	for <kvmarm@archiver.kernel.org>; Sat, 25 Sep 2021 00:55:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 07D556125F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A6D6E4B116;
	Fri, 24 Sep 2021 20:55:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vy+HyAkSQgCr; Fri, 24 Sep 2021 20:55:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 42FC34B13A;
	Fri, 24 Sep 2021 20:55:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EAA54B15A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 20:55:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id disS+BaKVtc0 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Sep 2021 20:55:44 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 526724B13A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 20:55:44 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 v66-20020a25abc8000000b0059ef57c3386so5834786ybi.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 17:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=g5w58E3IGKbXWYSiPvVnlhcj+7GlkHG6CZrKZkT3vP0=;
 b=I4e5kehhED/KRR7N2cidXMqEex8CTCjyKcS2GmlIqby43yZ8ILGKXc2f8gJK+B0Mak
 qsHzsvvWsCOKQJyUk1JPfK+IGXjf6HCaHUL0FUfUcIrbIXa51o8WuFSJxvxfe1GsH4Uq
 4wkMnXqEXE0T8fqaBiVS5RKDJvfyHZounlDt3fdqbzenS67IcSjNvXGEUIO65DT9UowY
 0WWolyDLxEo23l06ilRvVvGf7N+Xj5mOiB69dEn6Jh/LGqqKzS/fLSd5iYeTHh7nJpAh
 FQSoKxIi7LGL9zafzLlsSFp9qcFmRpB1uVn56AcQPu/0zXKKSrucn7vuTNN4MAZ8uLSx
 Kfxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=g5w58E3IGKbXWYSiPvVnlhcj+7GlkHG6CZrKZkT3vP0=;
 b=6XO/jwjBFug0eJYLlRyvWu4lurNBjZYpKX89t3xzAGOGxz9M3vy9KRgJ0lqObZRxlt
 mjJX0ew+vgz6Vdpx2J1h/kOVAjnNt4Ok3duu/N7kw+vHU0RKNv4Uu0g3cxgHjaV4xa83
 UE1yO4oGRanwuf1Hs6VaN/3ffdZAE5m3iV13yQU6ERmKr14xPcu4/2Lk1yBcuwpT+BtU
 hQ7sgng9xaO4esO5ql7PLqgGuK2c31/3/7ygo1BeIaFET4DC/Vh5u9xDLlui2/ngalhS
 puBOMcSNrB1n/Cqorp4VGdUKXBlIgRpJPTMeWMRhI6et+b+xJuOVWfxvSrHzvCleUl7U
 BnwA==
X-Gm-Message-State: AOAM533f2DUx8mYyf/b28N4N4eg3QQMBeRz8+7T4AZrzSDH2isWRulcG
 4buunOITBzyL6P7ZLGloRlUH8eq3Z7Q=
X-Google-Smtp-Source: ABdhPJyiTN53g148rAgVoj1ICII7m79WO7ugJdd/HLrJy3M0TecyAbb/0CT74AaOvmAyzC41vJkVDTyrGUg=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:4c72:89be:dba3:2bcb])
 (user=seanjc job=sendgmr) by 2002:a25:2789:: with SMTP id
 n131mr9633757ybn.440.1632531343946; 
 Fri, 24 Sep 2021 17:55:43 -0700 (PDT)
Date: Fri, 24 Sep 2021 17:55:20 -0700
In-Reply-To: <20210925005528.1145584-1-seanjc@google.com>
Message-Id: <20210925005528.1145584-7-seanjc@google.com>
Mime-Version: 1.0
References: <20210925005528.1145584-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH 06/14] KVM: Drop obsolete kvm_arch_vcpu_block_finish()
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>, 
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Joerg Roedel <joro@8bytes.org>,
 Cornelia Huck <cohuck@redhat.com>, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, David Matlack <dmatlack@google.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Jim Mattson <jmattson@google.com>
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

Drop kvm_arch_vcpu_block_finish() now that all arch implementations are
nops.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/include/asm/kvm_host.h   | 1 -
 arch/mips/include/asm/kvm_host.h    | 1 -
 arch/powerpc/include/asm/kvm_host.h | 1 -
 arch/s390/include/asm/kvm_host.h    | 2 --
 arch/s390/kvm/kvm-s390.c            | 5 -----
 arch/x86/include/asm/kvm_host.h     | 2 --
 virt/kvm/kvm_main.c                 | 1 -
 7 files changed, 13 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f8be56d5342b..4e0ad0fff540 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -716,7 +716,6 @@ void kvm_arm_vcpu_ptrauth_trap(struct kvm_vcpu *vcpu);
 static inline void kvm_arch_hardware_unsetup(void) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
-static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
 
 void kvm_arm_init_debug(void);
 void kvm_arm_vcpu_init_debug(struct kvm_vcpu *vcpu);
diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index 696f6b009377..72b90d45a46e 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -897,7 +897,6 @@ static inline void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
-static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
 
 #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLB
 int kvm_arch_flush_remote_tlb(struct kvm *kvm);
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 59cb38b04ede..8a84448d77a6 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -864,6 +864,5 @@ static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_exit(void) {}
 static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
-static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
 
 #endif /* __POWERPC_KVM_HOST_H__ */
diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index a604d51acfc8..a22c9266ea05 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -1010,6 +1010,4 @@ static inline void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
 
-void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu);
-
 #endif
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 08ed68639a21..17fabb260c35 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -5080,11 +5080,6 @@ static inline unsigned long nonhyp_mask(int i)
 	return 0x0000ffffffffffffUL >> (nonhyp_fai << 4);
 }
 
-void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu)
-{
-
-}
-
 static int __init kvm_s390_init(void)
 {
 	int i;
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1e0e909b98b2..4e8c21083bdb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1916,8 +1916,6 @@ static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
 	static_call_cond(kvm_x86_vcpu_unblocking)(vcpu);
 }
 
-static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
-
 static inline int kvm_cpu_get_apicid(int mps_cpu)
 {
 #ifdef CONFIG_X86_LOCAL_APIC
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2ba22b68af3b..2015a1f532ce 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3301,7 +3301,6 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	}
 
 	trace_kvm_vcpu_wakeup(block_ns, waited, vcpu_valid_wakeup(vcpu));
-	kvm_arch_vcpu_block_finish(vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_block);
 
-- 
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

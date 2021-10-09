Return-Path: <SRS0=FNOB=O5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1287C433EF
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:14:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 803F061038
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:14:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 803F061038
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 36ABD4B1BF;
	Fri,  8 Oct 2021 22:14:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xNvY6+E4qzCx; Fri,  8 Oct 2021 22:14:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 260A94B1BC;
	Fri,  8 Oct 2021 22:14:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 150924B1B5
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:14:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SoDOYbBa628X for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Oct 2021 22:14:11 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CAEB34B199
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:14:10 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 z130-20020a256588000000b005b6b4594129so15101150ybb.15
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Oct 2021 19:14:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=6xwGp+yCPRNZeLMFXXBjBMcyDDhJc3kOdh7+GdwoBtU=;
 b=O3uyycCB0m4rETPo/2EXg7KzDS0Kxxd5QSMOgN5++pIlRXIKx8d0yrsAd7IRsknDXU
 jfPpfSaBpR+vzVZLfe2k/aYazJeb1V2OYVJeM9zHGQGZhxYlUVKxD+cBCI62fGJRZVEl
 yp3sVQ08Q330CkbJTchqmDuBifPyeL6Ww3QjU3eQOha0KDm0IBJuDzOMnyesSyo+q+I/
 lJ8xG8ZB8d3AYNpLPtB4eWA/pyqYaGmh5tBZ/8rId9AshkSUfwuM0AAs41HY+kSD+IsV
 W4/ngk/MxUvX4B342qXh08T69yL8VAymitYL9u6x/enfR2SkDRVs3Yd1g27SdUPXsZPn
 0GRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=6xwGp+yCPRNZeLMFXXBjBMcyDDhJc3kOdh7+GdwoBtU=;
 b=8Odi2119LWpR0wcX/ltQwIbZoHl+TGr3pCWTjKsaLV0T1xr+E0Ks5Y4XV0w0ZjzN+G
 9j68iMzMBoOl/omD5YM3fgUgpPOuJufCbemfsIdfSzNP3sAYiHDHGplbGONo4I4HXSZ/
 cSTt3UwVemt820rYJGMj8IFurwB2XyLbqQ4zNE8T2LvwSlbqYvQDfe6COd6AjPQKQDgs
 TSmvaAotCudBVIM2v3kkjti37Q73RBuYH+rywHKy8xYXI2d7R843kT4GT/Lh/PqbDsdx
 QZ65m3chgqipgvCO5LhHZQSSxOPcqeVO+7gjAj/aJcmvsagIuoRixuOxoNUA2MkGCSnN
 cGXg==
X-Gm-Message-State: AOAM533k5/CwzjWZqSUQzmqG1pDNnL20SAEaysuDyRE57m+AkT83H3NG
 JLRYUth0tTVR9I4CLXaOA++ozVf3TYw=
X-Google-Smtp-Source: ABdhPJxGMQ2uf1Tp63zXiZ9a6+eAt9/mXxTl51gnqbi9PaWar+CNyJX66rPwqvsO9Gv4EvKTMkdMfFkjiGQ=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:a05:6902:154f:: with SMTP id
 r15mr8259463ybu.379.1633745650411; Fri, 08 Oct 2021 19:14:10 -0700 (PDT)
Date: Fri,  8 Oct 2021 19:12:29 -0700
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Message-Id: <20211009021236.4122790-37-seanjc@google.com>
Mime-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2 36/43] KVM: SVM: Don't bother checking for "running" AVIC
 when kicking for IPIs
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

Drop the avic_vcpu_is_running() check when waking vCPUs in response to a
VM-Exit due to incomplete IPI delivery.  The check isn't wrong per se, but
it's not 100% accurate in the sense that it doesn't guarantee that the vCPU
was one of the vCPUs that didn't receive the IPI.

The check isn't required for correctness as blocking == !running in this
context.

From a performance perspective, waking a live task is not expensive as the
only moderately costly operation is a locked operation to temporarily
disable preemption.  And if that is indeed a performance issue,
kvm_vcpu_is_blocking() would be a better check than poking into the AVIC.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 15 +++++++++------
 arch/x86/kvm/svm/svm.h  | 11 -----------
 2 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index cbf02e7e20d0..b43b05610ade 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -295,13 +295,16 @@ static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
 	struct kvm_vcpu *vcpu;
 	int i;
 
+	/*
+	 * Wake any target vCPUs that are blocking, i.e. waiting for a wake
+	 * event.  There's no need to signal doorbells, as hardware has handled
+	 * vCPUs that were in guest at the time of the IPI, and vCPUs that have
+	 * since entered the guest will have processed pending IRQs at VMRUN.
+	 */
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-		bool m = kvm_apic_match_dest(vcpu, source,
-					     icrl & APIC_SHORT_MASK,
-					     GET_APIC_DEST_FIELD(icrh),
-					     icrl & APIC_DEST_MASK);
-
-		if (m && !avic_vcpu_is_running(vcpu))
+		if (kvm_apic_match_dest(vcpu, source, icrl & APIC_SHORT_MASK,
+					GET_APIC_DEST_FIELD(icrh),
+					icrl & APIC_DEST_MASK))
 			kvm_vcpu_wake_up(vcpu);
 	}
 }
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 0d7bbe548ac3..7f5b01bbee29 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -509,17 +509,6 @@ extern struct kvm_x86_nested_ops svm_nested_ops;
 
 #define VMCB_AVIC_APIC_BAR_MASK		0xFFFFFFFFFF000ULL
 
-static inline bool avic_vcpu_is_running(struct kvm_vcpu *vcpu)
-{
-	struct vcpu_svm *svm = to_svm(vcpu);
-	u64 *entry = svm->avic_physical_id_cache;
-
-	if (!entry)
-		return false;
-
-	return (READ_ONCE(*entry) & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
-}
-
 int avic_ga_log_notifier(u32 ga_tag);
 void avic_vm_destroy(struct kvm *kvm);
 int avic_vm_init(struct kvm *kvm);
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

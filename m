Return-Path: <SRS0=FNOB=O5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D476C433EF
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:13:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 21C2E61261
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:13:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 21C2E61261
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CADA24B14D;
	Fri,  8 Oct 2021 22:13:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MjQVciXUJuS5; Fri,  8 Oct 2021 22:13:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9739A4B11C;
	Fri,  8 Oct 2021 22:13:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A7904B10C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:13:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KYrtAuWSvuDO for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Oct 2021 22:13:09 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7C7A44B11C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:13:09 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 x16-20020a25b910000000b005b6b7f2f91cso15202650ybj.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Oct 2021 19:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=crdXztg9++vBF99WovoTawrTDZAMlepONlGnGeI4yW0=;
 b=poNGQMstvhEww3j/q+Ew2K+kNGbRr43AknFTBRh6WmHfINYVTEZ8xwMCg3y/Oe0NTr
 JtR7XEPh6F0hNfpa7j0f0RwTpV2urRBu3LMP+OKFGJcSZrESErjqFnLHWoSw1ikwE0o1
 UkxXXzg8yn/8yoLlIGTWwkwNWIU3bDlweiuiVGKXvNbXpeSJbXUFTmJ78JXoB8GBPJw2
 Mxj9q9UdsBWYyWx2wIwXfPBkBDNwtFvcrIvOy5n8ZO7r3niACNa+V6HpFHN56wIysh/P
 Cwz5E66bxfbW3Pz3Ruv8j5UfmgJXe5yN635GAZ7qZZ8Qx3Cc9Yvo9ZcfDICQydkTtIEI
 6A4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=crdXztg9++vBF99WovoTawrTDZAMlepONlGnGeI4yW0=;
 b=KeYWP/UscyPuYDB6trhdZuZTpBfCaGNNl9+iwz6JQ2ukmltmD5tml2NRC2jnzqmbKY
 5rsF858nFIr34o7R1QIrRpDMN6mZDDWxWoqRVrrhE8r+Pk39WHomoobD0W7gOS5sRzBc
 RQYN45gKzF9aUd/YQMXH7G9afPPuXS0z83i5wqu4sP6SRekStLlU3H5OdD5X8V3Em8ue
 V+QRH5m36BiwyckFG0lBkVIISoIvMZkSRg3+ARw7LuKUL9GfSiGZOD0YexoEra9HNTPe
 KtGZatsiD6XQTLMHMWxTMV3N+wYevlaByVrBVlMThidEJm8x+NLuVR8oxY+MP4QbzrJ/
 joiA==
X-Gm-Message-State: AOAM530ebgLINf7geBJoZdpQ/Qy2Hxy37BD+fNN9HorTqdx8y32CIXZS
 Eh6eXsr5jFJ+qIcE+nvv1DPB/ZMXHCY=
X-Google-Smtp-Source: ABdhPJzcfIZ1Zv0b5dqnBIvzfvXq4ARXDnmY1mzl0GCln9fUNJg9VNZGpZvCwHJXJWz2rm5XencR2U5y0mk=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:a05:6902:100f:: with SMTP id
 w15mr7392080ybt.259.1633745589050; Fri, 08 Oct 2021 19:13:09 -0700 (PDT)
Date: Fri,  8 Oct 2021 19:12:04 -0700
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Message-Id: <20211009021236.4122790-12-seanjc@google.com>
Mime-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2 11/43] KVM: Don't block+unblock when halt-polling is
 successful
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

Invoke the arch hooks for block+unblock if and only if KVM actually
attempts to block the vCPU.  The only non-nop implementation is on x86,
specifically SVM's AVIC, and there is no need to put the AVIC prior to
halt-polling as KVM x86's kvm_vcpu_has_events() will scour the full vIRR
to find pending IRQs regardless of whether the AVIC is loaded/"running".

The primary motivation is to allow future cleanup to split out "block"
from "halt", but this is also likely a small performance boost on x86 SVM
when halt-polling is successful.

Adjust the post-block path to update "cur" after unblocking, i.e. include
AVIC load time in halt_wait_ns and halt_wait_hist, so that the behavior
is consistent.  Moving just the pre-block arch hook would result in only
the AVIC put latency being included in the halt_wait stats.  There is no
obvious evidence that one way or the other is correct, so just ensure KVM
is consistent.

Note, x86 has two separate paths for handling APICv with respect to vCPU
blocking.  VMX uses hooks in x86's vcpu_block(), while SVM uses the arch
hooks in kvm_vcpu_block().  Prior to this path, the two paths were more
or less functionally identical.  That is very much not the case after
this patch, as the hooks used by VMX _must_ fire before halt-polling.
x86's entire mess will be cleaned up in future patches.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f90b3ed05628..227f6bbe0716 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3235,8 +3235,6 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	bool waited = false;
 	u64 block_ns;
 
-	kvm_arch_vcpu_blocking(vcpu);
-
 	start = cur = poll_end = ktime_get();
 	if (do_halt_poll) {
 		ktime_t stop = ktime_add_ns(ktime_get(), vcpu->halt_poll_ns);
@@ -3253,6 +3251,7 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 		} while (kvm_vcpu_can_poll(cur, stop));
 	}
 
+	kvm_arch_vcpu_blocking(vcpu);
 
 	prepare_to_rcuwait(wait);
 	for (;;) {
@@ -3265,6 +3264,9 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 		schedule();
 	}
 	finish_rcuwait(wait);
+
+	kvm_arch_vcpu_unblocking(vcpu);
+
 	cur = ktime_get();
 	if (waited) {
 		vcpu->stat.generic.halt_wait_ns +=
@@ -3273,7 +3275,6 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 				ktime_to_ns(cur) - ktime_to_ns(poll_end));
 	}
 out:
-	kvm_arch_vcpu_unblocking(vcpu);
 	block_ns = ktime_to_ns(cur) - ktime_to_ns(start);
 
 	/*
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

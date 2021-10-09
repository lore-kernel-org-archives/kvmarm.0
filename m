Return-Path: <SRS0=FNOB=O5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5AEFC433EF
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:14:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 77BDF60FD9
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:14:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 77BDF60FD9
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C3A94B121;
	Fri,  8 Oct 2021 22:14:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6fKHc+VLg7TP; Fri,  8 Oct 2021 22:14:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0449C4B1B6;
	Fri,  8 Oct 2021 22:14:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C145E4B1B5
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:14:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VhW9d6c65Hbc for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Oct 2021 22:14:08 -0400 (EDT)
Received: from mail-qk1-f201.google.com (mail-qk1-f201.google.com
 [209.85.222.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 44DB74B11E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:14:08 -0400 (EDT)
Received: by mail-qk1-f201.google.com with SMTP id
 r5-20020a05620a298500b0045dac5fb940so9784622qkp.17
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Oct 2021 19:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=vARluonyUKpRy8G9DjKrfNHNdAc1HGSYAf2sHJRtsxE=;
 b=dDNQpdZfL83I4Xoa9PZ3E5EsYnabe1TnFcUqC0GiE/0/lo3YBI4SgbGlytEWdsCvOf
 LL61F+TPG4wVAi+hBDwL0hYJr0Sf/hDhYBcY7jqTws2bL+a5fPjX5OLlspq9+auO8uLB
 LlWM6ttM2AIBOgSzLaGHfzimLEgh21na9pO5BUmiCsH43tkGQwDiPq/uFgoyBvKjufM1
 qqm6SRzQMrUy4KCFfX/YOo+AIQIUXaJKY/DR/AD2RJh1k/DEWqufdKKiBjO5+vKlBr1h
 rts7eeL0kCC8yhrzj1lM+laL06N4oAUmGKJnSLoqoH7hEPeImUfW3S7INsYE4a0g/dn5
 bbFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=vARluonyUKpRy8G9DjKrfNHNdAc1HGSYAf2sHJRtsxE=;
 b=4KHawSwSC5TF0exiCyGfLMp6K14Bkmux7Joofw8kbaaQ1ixmZ/j0pFO60U1slqGR6m
 U8U8U/aKSQ0FV4fqeDVgspdCEBY0LbwUkywbDZ6XAhJU2YohH7gaHUPDe7coIARIwBOl
 GSWbhm8B05DTb7iSVTGBBT2sJ1Zq7UV+13tNReNkopa+HpV8sTXvlt7mGCoA4UTRR8A9
 6oav/LCAUfDIz08XPI2LXQuptkClsADT9mF1q2KZCNUmuhj8y0A1GJUeCvU88aSPkLA9
 hSOzwCuzQcw7KMxZYAhnA8oYXVuc9czOeBFjEBf2/K1Uq87SsiYibn/Y7BYzmqFPMD+E
 6Fbw==
X-Gm-Message-State: AOAM531d1ZNwJCRQ6NClpKbauxeotrNypjI2b1209Otw9+ih3CyXX17k
 zSOfib7gPnwxRaUzTtcgrSmU001OfCo=
X-Google-Smtp-Source: ABdhPJz6N4BKMo0pT3bkNnK0CxX1fpn8ACkILDo1YTK4hK+oppBaD3kzEAa1dfJV1AQiV4D0k1Eht0uMACM=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:ac8:7010:: with SMTP id
 x16mr1970027qtm.136.1633745647867; 
 Fri, 08 Oct 2021 19:14:07 -0700 (PDT)
Date: Fri,  8 Oct 2021 19:12:28 -0700
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Message-Id: <20211009021236.4122790-36-seanjc@google.com>
Mime-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2 35/43] KVM: SVM: Signal AVIC doorbell iff vCPU is in guest
 mode
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

Signal the AVIC doorbell iff the vCPU is running in the guest.  If the vCPU
is not IN_GUEST_MODE, it's guaranteed to pick up any pending IRQs on the
next VMRUN, which unconditionally processes the vIRR.

Add comments to document the logic.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 208c5c71e827..cbf02e7e20d0 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -674,7 +674,12 @@ int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec)
 	kvm_lapic_set_irr(vec, vcpu->arch.apic);
 	smp_mb__after_atomic();
 
-	if (avic_vcpu_is_running(vcpu)) {
+	/*
+	 * Signal the doorbell to tell hardware to inject the IRQ if the vCPU
+	 * is in the guest.  If the vCPU is not in the guest, hardware will
+	 * automatically process AVIC interrupts at VMRUN.
+	 */
+	if (vcpu->mode == IN_GUEST_MODE) {
 		int cpu = READ_ONCE(vcpu->cpu);
 
 		/*
@@ -687,8 +692,13 @@ int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec)
 		if (cpu != get_cpu())
 			wrmsrl(SVM_AVIC_DOORBELL, kvm_cpu_get_apicid(cpu));
 		put_cpu();
-	} else
+	} else {
+		/*
+		 * Wake the vCPU if it was blocking.  KVM will then detect the
+		 * pending IRQ when checking if the vCPU has a wake event.
+		 */
 		kvm_vcpu_wake_up(vcpu);
+	}
 
 	return 0;
 }
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

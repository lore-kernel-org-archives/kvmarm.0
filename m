Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 076DEC6FA82
	for <kvmarm@archiver.kernel.org>; Wed, 21 Sep 2022 00:33:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AAAAC4B782;
	Tue, 20 Sep 2022 20:33:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id d32NivZ+docz; Tue, 20 Sep 2022 20:32:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6544B4B7F0;
	Tue, 20 Sep 2022 20:32:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3151E4B5F5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 20:32:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Z-I4hQznP1jl for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2022 20:32:55 -0400 (EDT)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2C8234B797
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 20:32:55 -0400 (EDT)
Received: by mail-pj1-f74.google.com with SMTP id
 js4-20020a17090b148400b0020061aa46d7so2366369pjb.9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 17:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc:subject:date;
 bh=in1e99LU0Ccpw/X/GIRYkJpr4V5oHdTaxBm51ABK8Zw=;
 b=fxdaQ36wvXASTDMSCMzYP+4owRlpPpJcqJ4F20fEjNf3NkP/XvFqT6xHl6n3ymucfl
 wAkGHRzbnCmY2sRlXf6ZWxdMJOLwsB9akqzNsLJ63vLPgpDdP/+uiqDwiJPNyKPaW9d7
 W2gxRWjRcioAK5oyxgmQ+mvd8Xlfcqcs1FkpQ/Oqp1HeXyhy4RotzrvhRKtqe8D+3zPD
 +CkxhFgpHhUHVq6NWMedQTZChQMs8Bwl5AD6kmQ5xMId+9oxitQlXRTCf8+K4ilieGZt
 o5dYeYoVYv1Nk//INpmg7k40TTkb2qfPNYErptOcyucxi9O7dxpRl/MDPplYtfBX3bMF
 AtFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
 bh=in1e99LU0Ccpw/X/GIRYkJpr4V5oHdTaxBm51ABK8Zw=;
 b=OQodbnvWHtB3Ay5Z7whPGrA0itkU+R0RnI5dIuwANf980ub4f8Ps0OU0H2aZdk85Aw
 0cIUHvpxwwEC31K5nWM/gWgDxoYR1PvaOB51+tzK084Mqb/bsUEi9bJEYLepp2O9k5u9
 fpD2ofYujBkJQfJ/JSiWlc9z5txARKzqsBfYNmjQQ5XIqIIe026jNvi/xMxVGcw/aHvb
 FXw0axhk25vOBOrQjS4TyTAu8o5ZB447FJMVD+Kujg7+hXUv77QEVDD1k1AvcH/KFbfZ
 hA08GSozcASgmarSUal3JbNVWSDYigqnSBTP1X9c0zNpJ9Fyi/VfJbvmPOdBDKOBccTp
 QCGw==
X-Gm-Message-State: ACrzQf20tiJUpHO5bIleW9iBfiUrdmEa4fWC1/Sqfk2z19a0IEs2riBt
 404gTohbmwmhiyPIF3+xJOA5lYPWJlM=
X-Google-Smtp-Source: AMsMyM5mvx4Hh7HCt8EQDTkIMloT3kDTM73/Oxb6s3/QbBaMaLHOT1W35eSuZRH5DC184c70ddSZg22LA4I=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:cf11:b0:178:29d7:4fbd with SMTP id
 i17-20020a170902cf1100b0017829d74fbdmr2199821plg.174.1663720374306; Tue, 20
 Sep 2022 17:32:54 -0700 (PDT)
Date: Wed, 21 Sep 2022 00:31:53 +0000
In-Reply-To: <20220921003201.1441511-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220921003201.1441511-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220921003201.1441511-5-seanjc@google.com>
Subject: [PATCH v4 04/12] KVM: x86: Rename kvm_apic_has_events() to make it
 INIT/SIPI specific
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

Rename kvm_apic_has_events() to kvm_apic_has_pending_init_or_sipi() so
that it's more obvious that "events" really just means "INIT or SIPI".

Opportunistically clean up a weirdly worded comment that referenced
kvm_apic_has_events() instead of kvm_apic_accept_events().

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.h | 2 +-
 arch/x86/kvm/x86.c   | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index c3ce6b0b1ea3..a5ac4a5a5179 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -224,7 +224,7 @@ static inline bool kvm_vcpu_apicv_active(struct kvm_vcpu *vcpu)
 	return lapic_in_kernel(vcpu) && vcpu->arch.apic->apicv_active;
 }
 
-static inline bool kvm_apic_has_events(struct kvm_vcpu *vcpu)
+static inline bool kvm_apic_has_pending_init_or_sipi(struct kvm_vcpu *vcpu)
 {
 	return lapic_in_kernel(vcpu) && vcpu->arch.apic->pending_events;
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 59be7b16b92f..16a24dd28f26 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11920,8 +11920,8 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 		struct fpstate *fpstate = vcpu->arch.guest_fpu.fpstate;
 
 		/*
-		 * To avoid have the INIT path from kvm_apic_has_events() that be
-		 * called with loaded FPU and does not let userspace fix the state.
+		 * All paths that lead to INIT are required to load the guest's
+		 * FPU state (because most paths are buried in KVM_RUN).
 		 */
 		if (init_event)
 			kvm_put_guest_fpu(vcpu);
@@ -12765,7 +12765,7 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
 	if (!list_empty_careful(&vcpu->async_pf.done))
 		return true;
 
-	if (kvm_apic_has_events(vcpu))
+	if (kvm_apic_has_pending_init_or_sipi(vcpu))
 		return true;
 
 	if (vcpu->arch.pv.pv_unhalted)
-- 
2.37.3.968.ga6b4b080e4-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

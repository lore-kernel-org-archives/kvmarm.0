Return-Path: <SRS0=FNOB=O5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46F16C433EF
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:14:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EBAD660F51
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:14:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org EBAD660F51
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A034F4B1DD;
	Fri,  8 Oct 2021 22:14:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pC8+3q4BfTeW; Fri,  8 Oct 2021 22:14:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8329E4B1BC;
	Fri,  8 Oct 2021 22:14:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4317E4B10E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:14:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QHufWlHyPl+T for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Oct 2021 22:14:18 -0400 (EDT)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D20BE4B10D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:14:17 -0400 (EDT)
Received: by mail-qv1-f74.google.com with SMTP id
 ey7-20020a0562140b6700b00382cf3eb480so10264523qvb.22
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Oct 2021 19:14:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=60FaGe3jHfzi2vANN4FyfF/i5oEKd4JaFx8/SVEFBNk=;
 b=Z1P8991nqO/keHHcPNDLRVMsJotsLW7zCMS8prAeIixKQ9mUd7DFllwUbuaHgVSrWZ
 FkvVrJgBJx0hc4CnzRBKZSR1hitB3Pk7jqHRDt0WmtqyCKKVVvm7gD0Q9FoIUaVCRIyp
 YiCXIJxWnPrhfp4kvu9z8/hF1gQOGdE7O7cz6QeTcYuVmieoH7ELJCd7UMv/HDJr1lHI
 JdSdjZZTm0cDCLqT8cUYvWrMLcAK8JU652nI2ulS+DYSnd22rQAqVDPjiZw3qVcCjDi0
 GqTi9TAncXe+Iuc9CVjDDeSGYGD369tFbR8wEt1kGo66QnpkLVtv3NIEb5UQVw6604Ie
 3W8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=60FaGe3jHfzi2vANN4FyfF/i5oEKd4JaFx8/SVEFBNk=;
 b=5KXIAOtJ3xxqOD+4hOl0idYcEwe7yUqEV55plb+IMuNM0SVcG1SU0nXHJh5P9AsXRo
 TPSQbLEKOO2FJu2fqiX38OPzpFBr09hOlmjKWattYzxafSs4M4ObZ9ZjXcrSi769/9mc
 UkBI0cq8kAd362ODqsgFpoHugjYibELgiS1HU0vNu2wc6CI0KwtCfpfD3q559BZG66ZK
 aHBQMQoFzXAnDqLE+s4jVyCMQ3QndrNphhdO4Y/NE/wSmr0WgePKBF9eAxBQKiO/4Mzq
 ub4IruPX/g0NxodyBavkkT+Z3xR5IshNv7zq4FwPf3P0nmID5IVIRxnKV18GavHdx88f
 qaaA==
X-Gm-Message-State: AOAM530akkOprlTb3rMblu2ZTMWWQeNPwxfd3Dt97hg8wyD14vMRtzqF
 Rhr4H9kEDQcl/NvZCBUEfidLz5lO7IE=
X-Google-Smtp-Source: ABdhPJzz4hkmJ133tsw9efdKVMZh6wi7X37BBmBb9YEFsyE1x8BdZiU7lUBQl0qiUIYV4wWlbCGAte9NXc4=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:ac8:42da:: with SMTP id
 g26mr1839130qtm.368.1633745657436; 
 Fri, 08 Oct 2021 19:14:17 -0700 (PDT)
Date: Fri,  8 Oct 2021 19:12:32 -0700
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Message-Id: <20211009021236.4122790-40-seanjc@google.com>
Mime-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2 39/43] KVM: VMX: Don't do full kick when triggering posted
 interrupt "fails"
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

Replace the full "kick" with just the "wake" in the fallback path when
triggering a virtual interrupt via a posted interrupt fails because the
guest is not IN_GUEST_MODE.  If the guest transitions into guest mode
between the check and the kick, then it's guaranteed to see the pending
interrupt as KVM syncs the PIR to IRR (and onto GUEST_RVI) after setting
IN_GUEST_MODE.  Kicking the guest in this case is nothing more than an
unnecessary VM-Exit (and host IRQ).

Opportunistically update comments to explain the various ordering rules
and barriers at play.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 16 ++++++++++++++--
 arch/x86/kvm/x86.c     |  5 +++--
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 13e732a818f3..44d760dde0f9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3978,10 +3978,16 @@ static int vmx_deliver_nested_posted_interrupt(struct kvm_vcpu *vcpu,
 		 * we will accomplish it in the next vmentry.
 		 */
 		vmx->nested.pi_pending = true;
+		/*
+		 * The smp_wmb() in kvm_make_request() pairs with the smp_mb_*()
+		 * after setting vcpu->mode in vcpu_enter_guest(), thus the vCPU
+		 * is guaranteed to see the event request if triggering a posted
+		 * interrupt "fails" because vcpu->mode != IN_GUEST_MODE.
+		 */
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
 		/* the PIR and ON have been set by L1. */
 		if (!kvm_vcpu_trigger_posted_interrupt(vcpu, true))
-			kvm_vcpu_kick(vcpu);
+			kvm_vcpu_wake_up(vcpu);
 		return 0;
 	}
 	return -1;
@@ -4012,9 +4018,15 @@ static int vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
 	if (pi_test_and_set_on(&vmx->pi_desc))
 		return 0;
 
+	/*
+	 * The implied barrier in pi_test_and_set_on() pairs with the smp_mb_*()
+	 * after setting vcpu->mode in vcpu_enter_guest(), thus the vCPU is
+	 * guaranteed to see PID.ON=1 and sync the PIR to IRR if triggering a
+	 * posted interrupt "fails" because vcpu->mode != IN_GUEST_MODE.
+	 */
 	if (vcpu != kvm_get_running_vcpu() &&
 	    !kvm_vcpu_trigger_posted_interrupt(vcpu, false))
-		kvm_vcpu_kick(vcpu);
+		kvm_vcpu_wake_up(vcpu);
 
 	return 0;
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9643f23c28c7..274d295cabfb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9752,8 +9752,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	smp_mb__after_srcu_read_unlock();
 
 	/*
-	 * This handles the case where a posted interrupt was
-	 * notified with kvm_vcpu_kick.
+	 * Process pending posted interrupts to handle the case where the
+	 * notification IRQ arrived in the host, or was never sent (because the
+	 * target vCPU wasn't running).
 	 */
 	if (kvm_lapic_enabled(vcpu) && vcpu->arch.apicv_active)
 		static_call(kvm_x86_sync_pir_to_irr)(vcpu);
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

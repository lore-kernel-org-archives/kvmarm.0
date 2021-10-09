Return-Path: <SRS0=FNOB=O5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9130CC433EF
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:13:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 46DF961027
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:13:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 46DF961027
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EBE284B0EC;
	Fri,  8 Oct 2021 22:13:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id av6X1iI+pvW4; Fri,  8 Oct 2021 22:13:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B98754B0E6;
	Fri,  8 Oct 2021 22:13:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DAEA94B11E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:13:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VuAfsMkYpUeU for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Oct 2021 22:13:12 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E9C354B13D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:13:11 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 124-20020a251182000000b005a027223ed9so14952419ybr.13
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Oct 2021 19:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=mx/LClvEah9U/ujSRD+kU2QZC8VI4YcZ2y85zUuGTJg=;
 b=NMczBrFGG+ZqD7XEJJZ0zVbsooqsKx7UCDFGdMakqEpsjihKxjQp1x7rBosSZj6oy3
 ZJbqFgmvbwEN8b/asiLsOJ45um4feisiVzJqUdRa700dyb3I3gjiNRJYHmFXs8fELHpz
 KZaubfYaFQk/NJUpMGGU5LErf+qMcFSnPhlW+wd6SSzyqBJvHECi4FXpwxESoAqsPGvw
 wfWtQWmiPSvw7zrFTRzKuuITt8jRt1JtmEbQqNMhufsJW14OMSbwxnzqQ/pLUX5m6wke
 +DtTEbAYwmAztWnXM1bPsj7c9e5t3FnTb6fZ0MBiecuAVVKjMgiuobo4/lrvrTPsEZLf
 R+sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=mx/LClvEah9U/ujSRD+kU2QZC8VI4YcZ2y85zUuGTJg=;
 b=CLCNaNorWxg0/7Qde0sXbda7vzEfQQ8mZCW5aMYQUFePnPT1o351cIsN8UMNxV3w3W
 wQO0UhVJwMftVXkgz+dK2z+Pr2vGArLsPNJgIpbVrfwg3g9I83rpwrXqbPv3oo80eJ7O
 VxVWNK/bcfW+YVYmyf2qAR5Odu4ThlyKP92oecEwYYVPQ60Yp3AEinbDutS3olLuHsY5
 /p5KgLqdPncxnMsp5HF7dJts0qdVxlEuNxWWEWEgKcRxELdTtNrlH+93X4ykAyitlzjj
 qIPdCzMP3BMQi4XiOsHDdVzWDUxjtuKmff76VcY/3NNiaqr0+Zo33CmA9ADszMFq/u8f
 XZiQ==
X-Gm-Message-State: AOAM531o1h72IwGyAfb1hQaYThO41plLSRKfqFcl8rqphVn+I3LS5iKD
 Sh1XpZ4sz4KqaJCBCEXO+Qm56DUwoYo=
X-Google-Smtp-Source: ABdhPJxejCbihGBgy3LVPfOgjAc3dy8xh0iCSgNtnKJhEvr9JNPLSKIyX+Ts6QvnlifutcHJPzG1e+Du0lg=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:a25:bb08:: with SMTP id
 z8mr7478243ybg.306.1633745591524; 
 Fri, 08 Oct 2021 19:13:11 -0700 (PDT)
Date: Fri,  8 Oct 2021 19:12:05 -0700
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Message-Id: <20211009021236.4122790-13-seanjc@google.com>
Mime-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2 12/43] KVM: x86: Tweak halt emulation helper names to free
 up kvm_vcpu_halt()
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

Rename a variety of HLT-related helpers to free up the function name
"kvm_vcpu_halt" for future use in generic KVM code, e.g. to differentiate
between "block" and "halt".

No functional change intended.

Reviewed-by: David Matlack <dmatlack@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/vmx/nested.c       |  2 +-
 arch/x86/kvm/vmx/vmx.c          |  4 ++--
 arch/x86/kvm/x86.c              | 13 +++++++------
 4 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7aafc27ce7a9..328103a520d3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1689,7 +1689,7 @@ int kvm_emulate_monitor(struct kvm_vcpu *vcpu);
 int kvm_fast_pio(struct kvm_vcpu *vcpu, int size, unsigned short port, int in);
 int kvm_emulate_cpuid(struct kvm_vcpu *vcpu);
 int kvm_emulate_halt(struct kvm_vcpu *vcpu);
-int kvm_vcpu_halt(struct kvm_vcpu *vcpu);
+int kvm_emulate_halt_noskip(struct kvm_vcpu *vcpu);
 int kvm_emulate_ap_reset_hold(struct kvm_vcpu *vcpu);
 int kvm_emulate_wbinvd(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index af1bbb73430a..d0237a441feb 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3619,7 +3619,7 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 		    !(nested_cpu_has(vmcs12, CPU_BASED_INTR_WINDOW_EXITING) &&
 		      (vmcs12->guest_rflags & X86_EFLAGS_IF))) {
 			vmx->nested.nested_run_pending = 0;
-			return kvm_vcpu_halt(vcpu);
+			return kvm_emulate_halt_noskip(vcpu);
 		}
 		break;
 	case GUEST_ACTIVITY_WAIT_SIPI:
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1c8b2b6e7ed9..5517893f12fc 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4741,7 +4741,7 @@ static int handle_rmode_exception(struct kvm_vcpu *vcpu,
 		if (kvm_emulate_instruction(vcpu, 0)) {
 			if (vcpu->arch.halt_request) {
 				vcpu->arch.halt_request = 0;
-				return kvm_vcpu_halt(vcpu);
+				return kvm_emulate_halt_noskip(vcpu);
 			}
 			return 1;
 		}
@@ -5415,7 +5415,7 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 
 		if (vcpu->arch.halt_request) {
 			vcpu->arch.halt_request = 0;
-			return kvm_vcpu_halt(vcpu);
+			return kvm_emulate_halt_noskip(vcpu);
 		}
 
 		/*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4a52a08707de..9c23ae1d483d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8649,7 +8649,7 @@ void kvm_arch_exit(void)
 #endif
 }
 
-static int __kvm_vcpu_halt(struct kvm_vcpu *vcpu, int state, int reason)
+static int __kvm_emulate_halt(struct kvm_vcpu *vcpu, int state, int reason)
 {
 	++vcpu->stat.halt_exits;
 	if (lapic_in_kernel(vcpu)) {
@@ -8661,11 +8661,11 @@ static int __kvm_vcpu_halt(struct kvm_vcpu *vcpu, int state, int reason)
 	}
 }
 
-int kvm_vcpu_halt(struct kvm_vcpu *vcpu)
+int kvm_emulate_halt_noskip(struct kvm_vcpu *vcpu)
 {
-	return __kvm_vcpu_halt(vcpu, KVM_MP_STATE_HALTED, KVM_EXIT_HLT);
+	return __kvm_emulate_halt(vcpu, KVM_MP_STATE_HALTED, KVM_EXIT_HLT);
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_halt);
+EXPORT_SYMBOL_GPL(kvm_emulate_halt_noskip);
 
 int kvm_emulate_halt(struct kvm_vcpu *vcpu)
 {
@@ -8674,7 +8674,7 @@ int kvm_emulate_halt(struct kvm_vcpu *vcpu)
 	 * TODO: we might be squashing a GUESTDBG_SINGLESTEP-triggered
 	 * KVM_EXIT_DEBUG here.
 	 */
-	return kvm_vcpu_halt(vcpu) && ret;
+	return kvm_emulate_halt_noskip(vcpu) && ret;
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_halt);
 
@@ -8682,7 +8682,8 @@ int kvm_emulate_ap_reset_hold(struct kvm_vcpu *vcpu)
 {
 	int ret = kvm_skip_emulated_instruction(vcpu);
 
-	return __kvm_vcpu_halt(vcpu, KVM_MP_STATE_AP_RESET_HOLD, KVM_EXIT_AP_RESET_HOLD) && ret;
+	return __kvm_emulate_halt(vcpu, KVM_MP_STATE_AP_RESET_HOLD,
+					KVM_EXIT_AP_RESET_HOLD) && ret;
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_ap_reset_hold);
 
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

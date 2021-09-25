Return-Path: <SRS0=Rd7Q=OP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C8A6C433F5
	for <kvmarm@archiver.kernel.org>; Sat, 25 Sep 2021 00:55:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3030061261
	for <kvmarm@archiver.kernel.org>; Sat, 25 Sep 2021 00:55:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3030061261
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CFE384B153;
	Fri, 24 Sep 2021 20:55:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7PEQvU8fb5sa; Fri, 24 Sep 2021 20:55:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DE8B4B0CB;
	Fri, 24 Sep 2021 20:55:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FBFD4B121
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 20:55:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cH4tHg7Sb+qc for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Sep 2021 20:55:49 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D911D4B136
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 20:55:48 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 v16-20020a256110000000b005b23a793d77so5835117ybb.15
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 17:55:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=ah8BjXPWllLk7CuVOQDBnnkjluI1bAcWQEy7hqnXFdI=;
 b=LH0fEQWiB4eDpGtf5hQ32ngY9GD9n7/7byCfmfVAytc4CKzgNHw+3wzIXFXa/o5bjL
 2I8Eux8FnK1n3Iopqot3X1OQnjmh9TXn5kbxaAIGqSl+9CT/5AZsgzAsrWdmxrS6mlrW
 dx+aaDSPBdScsR191c0lwGAUmjnCNBA+1XrB67IkhS4U9E2OhMxPrheuqrJo04xzwB0N
 XAS0I23+EYToVad3pLc9+Altu8hz2KVdmKC0N6gwn8kCYuyHcyl1sb/GxSbWhO/S13/S
 czeNRHxyY1pa57ENB4tByagarGXZrQ657lOxch4brq39vjJlp224VHM9XKZnUh7GAMXk
 zEKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=ah8BjXPWllLk7CuVOQDBnnkjluI1bAcWQEy7hqnXFdI=;
 b=Y8afem5tikhsGM+6MRtPVhnI0UYilrrMZrr5eRZVc34Pnjca2FBGZHuz1gvc61N3fk
 VZoQgbvF7l3R/iwFX1TT6ZzV5Y0Eq+C1nDcSW1nvL/0JfMxNua9g6AvRX/B0Xprc61Qz
 +jkCa/5CIjME3ILErVPTl65j8IJBiFSr96NRXWtb8NuXxw/7qFwYPUJyqsRoMsJyQwE3
 iWOhvNc4JuVthke8ldo+IRvkrUenQtXEGcjt5QTWNuMt4JlWlSB5CXkWao/W7oN/MIei
 PG6vMO/1LwdRoly9OQxaoemwOgkgb0mXthcEX1qcz1++7AGXuyTUDyqQRq0qnWDpSNv3
 geBQ==
X-Gm-Message-State: AOAM531iWhchjmyoRwdksj7j6xWxTyXX/Ua5/5eL4Tu6wmoxE3Nvvx3G
 CiD8rH237QGT8O6+jlhSC0KUsOje/64=
X-Google-Smtp-Source: ABdhPJxp5JGS1M0N56DHKiumu5prHduzDpf9Ztz1q5ePOF80kOqklxBqHGGBpfEM+YrqrhVUO4t7wkRniPM=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:4c72:89be:dba3:2bcb])
 (user=seanjc job=sendgmr) by 2002:a25:1d09:: with SMTP id
 d9mr16059645ybd.140.1632531348364; 
 Fri, 24 Sep 2021 17:55:48 -0700 (PDT)
Date: Fri, 24 Sep 2021 17:55:22 -0700
In-Reply-To: <20210925005528.1145584-1-seanjc@google.com>
Message-Id: <20210925005528.1145584-9-seanjc@google.com>
Mime-Version: 1.0
References: <20210925005528.1145584-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH 08/14] KVM: x86: Tweak halt emulation helper names to free up
 kvm_vcpu_halt()
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

Rename a variety of HLT-related helpers to free up the function name
"kvm_vcpu_halt" for future use in generic KVM code, e.g. to differentiate
between "block" and "halt".

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/vmx/nested.c       |  2 +-
 arch/x86/kvm/vmx/vmx.c          |  4 ++--
 arch/x86/kvm/x86.c              | 13 +++++++------
 4 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4e8c21083bdb..cfebef10b89c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1679,7 +1679,7 @@ int kvm_emulate_monitor(struct kvm_vcpu *vcpu);
 int kvm_fast_pio(struct kvm_vcpu *vcpu, int size, unsigned short port, int in);
 int kvm_emulate_cpuid(struct kvm_vcpu *vcpu);
 int kvm_emulate_halt(struct kvm_vcpu *vcpu);
-int kvm_vcpu_halt(struct kvm_vcpu *vcpu);
+int kvm_emulate_halt_noskip(struct kvm_vcpu *vcpu);
 int kvm_emulate_ap_reset_hold(struct kvm_vcpu *vcpu);
 int kvm_emulate_wbinvd(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index eedcebf58004..f689e463b678 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3618,7 +3618,7 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 		    !(nested_cpu_has(vmcs12, CPU_BASED_INTR_WINDOW_EXITING) &&
 		      (vmcs12->guest_rflags & X86_EFLAGS_IF))) {
 			vmx->nested.nested_run_pending = 0;
-			return kvm_vcpu_halt(vcpu);
+			return kvm_emulate_halt_noskip(vcpu);
 		}
 		break;
 	case GUEST_ACTIVITY_WAIT_SIPI:
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d118daed0530..858f5f1f1273 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4740,7 +4740,7 @@ static int handle_rmode_exception(struct kvm_vcpu *vcpu,
 		if (kvm_emulate_instruction(vcpu, 0)) {
 			if (vcpu->arch.halt_request) {
 				vcpu->arch.halt_request = 0;
-				return kvm_vcpu_halt(vcpu);
+				return kvm_emulate_halt_noskip(vcpu);
 			}
 			return 1;
 		}
@@ -5414,7 +5414,7 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 
 		if (vcpu->arch.halt_request) {
 			vcpu->arch.halt_request = 0;
-			return kvm_vcpu_halt(vcpu);
+			return kvm_emulate_halt_noskip(vcpu);
 		}
 
 		/*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b0c21d42f453..eade8a2bdccf 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8643,7 +8643,7 @@ void kvm_arch_exit(void)
 #endif
 }
 
-static int __kvm_vcpu_halt(struct kvm_vcpu *vcpu, int state, int reason)
+static int __kvm_emulate_halt(struct kvm_vcpu *vcpu, int state, int reason)
 {
 	++vcpu->stat.halt_exits;
 	if (lapic_in_kernel(vcpu)) {
@@ -8655,11 +8655,11 @@ static int __kvm_vcpu_halt(struct kvm_vcpu *vcpu, int state, int reason)
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
@@ -8668,7 +8668,7 @@ int kvm_emulate_halt(struct kvm_vcpu *vcpu)
 	 * TODO: we might be squashing a GUESTDBG_SINGLESTEP-triggered
 	 * KVM_EXIT_DEBUG here.
 	 */
-	return kvm_vcpu_halt(vcpu) && ret;
+	return kvm_emulate_halt_noskip(vcpu) && ret;
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_halt);
 
@@ -8676,7 +8676,8 @@ int kvm_emulate_ap_reset_hold(struct kvm_vcpu *vcpu)
 {
 	int ret = kvm_skip_emulated_instruction(vcpu);
 
-	return __kvm_vcpu_halt(vcpu, KVM_MP_STATE_AP_RESET_HOLD, KVM_EXIT_AP_RESET_HOLD) && ret;
+	return __kvm_emulate_halt(vcpu, KVM_MP_STATE_AP_RESET_HOLD,
+					KVM_EXIT_AP_RESET_HOLD) && ret;
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_ap_reset_hold);
 
-- 
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

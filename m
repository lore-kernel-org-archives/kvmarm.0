Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D4B9C54EE9
	for <kvmarm@archiver.kernel.org>; Wed, 21 Sep 2022 00:33:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 078BD4B808;
	Tue, 20 Sep 2022 20:33:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EaucAqnk1xpc; Tue, 20 Sep 2022 20:33:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C7EC84B7F5;
	Tue, 20 Sep 2022 20:33:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EAEC64B7E8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 20:33:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id O89OxdONOl8M for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2022 20:33:02 -0400 (EDT)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 37D3E4B712
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 20:33:00 -0400 (EDT)
Received: by mail-pg1-f202.google.com with SMTP id
 k16-20020a635a50000000b0042986056df6so2519706pgm.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 17:33:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc:subject:date;
 bh=qOL17Oc8lfNiT6vI1N2DgBeo2oQr9pvN4OAUhg4HlfA=;
 b=ARUifQn8X722qfUwF91vggFYXNpMmdld6jHGucJn9mYIHgePg3e3ltjHazRJ7WJQIY
 w+6+dDv/mxautN/CuWkRVIzUB4MM0mFVqAUofjmwyaRB9E3nNhDZAx6ZDYK3UkIvlcW3
 K9NzDWtr9CpQ/CIsHl9VDcl9eNecHkOQ3A4eAV1FpyXScQBTQQwiNPVxGPrxUtBQTP6V
 AEpBQWZgYOtijs1937kE9A8HMcoOQ+ZcnStpwMSDNJZXDvCTzuIS4CNbetfFaKrPYBbF
 SNyUEVo0ACy2TKSphVy9cWwOnuMGoqVKl4ZpNYYdwpjQNgZOx/k9BLzDCMUkycF0nN5P
 tZKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
 bh=qOL17Oc8lfNiT6vI1N2DgBeo2oQr9pvN4OAUhg4HlfA=;
 b=J4aNKPy4/DFwKtCWf6EgkGng0hySivE7rheOcS1NFoE6Si8KlMArMdgmVc0RKJPxmA
 hAugOJ3I5VnwGapW7gUQBVd2ry0A9VdCq1/BKGcQhqE3PeMOkdYdA0WNZ2zy6Q4SxuPM
 bpFKHKKbn3PSvo5sK0WH+yv6SR3ecFcY847zj76lcXvTcsx0oyFQIeQZz5mFRzyz/eOZ
 iafqV7uYLufU02e3o78LHUIdmjbw4ex43rg4o9EILMf1FAiXLUZLLGvDEp+9g0ddv2yF
 2vWC3obmjbt6gcRPwSAT5y3iGk2IE6rJBxqMNEtlhKFI+dSJhVvKf/YGpwDpuSIH5OzS
 l3rA==
X-Gm-Message-State: ACrzQf1WHT66lcWlYdqeHcGBQ1CLmX3Ic9idQjhM1aU/R5UIcKgShMAc
 fFMnpKnF3vcVRt/8+Pskt2ZA5Y4FpaQ=
X-Google-Smtp-Source: AMsMyM6CB910qkp43a3cP5VNkh9ZvqTlylmwVUImF03qdsZIEcBH6bFWk0KDb4437+crJl7uEogrf6c2DIk=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:26d4:b0:178:8de:fb5f with SMTP id
 jg20-20020a17090326d400b0017808defb5fmr2230591plb.45.1663720379233; Tue, 20
 Sep 2022 17:32:59 -0700 (PDT)
Date: Wed, 21 Sep 2022 00:31:56 +0000
In-Reply-To: <20220921003201.1441511-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220921003201.1441511-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220921003201.1441511-8-seanjc@google.com>
Subject: [PATCH v4 07/12] KVM: nVMX: Make an event request if INIT or SIPI is
 pending on VM-Enter
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

Evaluate interrupts, i.e. set KVM_REQ_EVENT, if INIT or SIPI is pending
when emulating nested VM-Enter.  INIT is blocked while the CPU is in VMX
root mode, but not in VMX non-root, i.e. becomes unblocked on VM-Enter.
This bug has been masked by KVM calling ->check_nested_events() in the
core run loop, but that hack will be fixed in the near future.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 3a080051a4ec..5922531f6c52 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3377,6 +3377,8 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 		(CPU_BASED_INTR_WINDOW_EXITING | CPU_BASED_NMI_WINDOW_EXITING);
 	if (likely(!evaluate_pending_interrupts) && kvm_vcpu_apicv_active(vcpu))
 		evaluate_pending_interrupts |= vmx_has_apicv_interrupt(vcpu);
+	if (!evaluate_pending_interrupts)
+		evaluate_pending_interrupts |= kvm_apic_has_pending_init_or_sipi(vcpu);
 
 	if (!vmx->nested.nested_run_pending ||
 	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS))
@@ -3457,18 +3459,10 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	}
 
 	/*
-	 * If L1 had a pending IRQ/NMI until it executed
-	 * VMLAUNCH/VMRESUME which wasn't delivered because it was
-	 * disallowed (e.g. interrupts disabled), L0 needs to
-	 * evaluate if this pending event should cause an exit from L2
-	 * to L1 or delivered directly to L2 (e.g. In case L1 don't
-	 * intercept EXTERNAL_INTERRUPT).
-	 *
-	 * Usually this would be handled by the processor noticing an
-	 * IRQ/NMI window request, or checking RVI during evaluation of
-	 * pending virtual interrupts.  However, this setting was done
-	 * on VMCS01 and now VMCS02 is active instead. Thus, we force L0
-	 * to perform pending event evaluation by requesting a KVM_REQ_EVENT.
+	 * Re-evaluate pending events if L1 had a pending IRQ/NMI/INIT/SIPI
+	 * when it executed VMLAUNCH/VMRESUME, as entering non-root mode can
+	 * effectively unblock various events, e.g. INIT/SIPI cause VM-Exit
+	 * unconditionally.
 	 */
 	if (unlikely(evaluate_pending_interrupts))
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
-- 
2.37.3.968.ga6b4b080e4-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

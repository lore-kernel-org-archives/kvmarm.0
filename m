Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC6E9C6FA82
	for <kvmarm@archiver.kernel.org>; Wed, 21 Sep 2022 00:33:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 99EFD4B7BE;
	Tue, 20 Sep 2022 20:33:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6xGIPKeDW9jt; Tue, 20 Sep 2022 20:33:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E88DC4B7F6;
	Tue, 20 Sep 2022 20:33:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B99984B7ED
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 20:33:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lL6pMdYh2GzF for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2022 20:33:05 -0400 (EDT)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EE9BC4B7F8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 20:33:04 -0400 (EDT)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-34514a7105eso38058877b3.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 17:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc:subject:date;
 bh=6n3oC51LepjybeCO/G1gnLj/7i8/kZTfCzCfh49ZsFY=;
 b=W1Ft16I2z4KyotR0zf9JcaxskVjiFIoTSvcCvM9GzqpfMZjOnkUbTlyR/YK2GifRmv
 QrwJq8VMURYEAE2WuDaeBV1lpmfmiUr9qttHXPB25xmfj0zo/Rm8dS6hBczWKfely1To
 iBZYJPxQgEmeTx4V8oSgxXgoc7fmc8jL0B2eJu/Yc6c7NQPqonrY7m5HwsjgveG5t8/q
 DMeMlr+fihRcdrCqNFWVENW4RNE2K4oabECK0hGgUMWhs07ZJGDjNFB5aD/IHo4M7B6i
 xV1aDtVsD/LclbxQq81QXFA9WSGbWt0X054O++Zklv0EWWKP7bGtdKwjb1syoi10fSBt
 trFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
 bh=6n3oC51LepjybeCO/G1gnLj/7i8/kZTfCzCfh49ZsFY=;
 b=zmVqzs9SCKQBFnUZm8dT//3KY2MP4oIyoVLD1fA7xLS9181IsHA8TGKRioJCkUha6b
 kssSgBnLEYSmKQ9wrZwiiRTmC19dX4D+/Cbn5r/UuYwPiDzou9l1HCW1yrbtE+9V2qet
 BskxjO8F75n68q4xuYNV0NchHJZWhTpC7quwrZ4Aj7mISYUalUMo+htv28Vd5kmJfLNY
 MSAUwDoUWy5oYmElHBmvfoFil//y5lgcoRo8oN9yNJKeAFWgzzrqmIgI/VhO0q1m/B7X
 CZm7jnrZzEF4DHAYpZAZC68B0Z9wBOHbPIVNi0AlkC5Xuov7NIADdt3vAArBcEigKC9D
 uyPg==
X-Gm-Message-State: ACrzQf0nufYcZ3bbpJ6D58dIezJ+b/BjX9cikuokV7fUS19MJ/PI6u8P
 QNT8azqecav84C8yFSAENAiRtdlc1h0=
X-Google-Smtp-Source: AMsMyM6ajbNthck8O3WF1o+1c/8Kt+/LZ69NQ6nvF17LZv5xSYaJvw/YRsOuqwhN87Jz4vl4Gma5UjnRyp0=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:c04f:0:b0:6ae:96ac:ac2d with SMTP id
 c76-20020a25c04f000000b006ae96acac2dmr21142783ybf.227.1663720384571; Tue, 20
 Sep 2022 17:33:04 -0700 (PDT)
Date: Wed, 21 Sep 2022 00:31:59 +0000
In-Reply-To: <20220921003201.1441511-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220921003201.1441511-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220921003201.1441511-11-seanjc@google.com>
Subject: [PATCH v4 10/12] KVM: x86: never write to memory from
 kvm_vcpu_check_block()
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

From: Paolo Bonzini <pbonzini@redhat.com>

kvm_vcpu_check_block() is called while not in TASK_RUNNING, and therefore
it cannot sleep.  Writing to guest memory is therefore forbidden, but it
can happen on AMD processors if kvm_check_nested_events() causes a vmexit.

Fortunately, all events that are caught by kvm_check_nested_events() are
also recognized by kvm_vcpu_has_events() through vendor callbacks such as
kvm_x86_interrupt_allowed() or kvm_x86_ops.nested_ops->has_events(), so
remove the call and postpone the actual processing to vcpu_block().

Opportunistically honor the return of kvm_check_nested_events().  KVM
punted on the check in kvm_vcpu_running() because the only error path is
if vmx_complete_nested_posted_interrupt() fails, in which case KVM exits
to userspace with "internal error" i.e. the VM is likely dead anyways so
it wasn't worth overloading the return of kvm_vcpu_running().

Add the check mostly so that KVM is consistent with itself; the return of
the call via kvm_apic_accept_events()=>kvm_check_nested_events() that
immediately follows  _is_ checked.

Reported-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[sean: check and handle return of kvm_check_nested_events()]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index dcc675d4e44b..8aeacbc2bff9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10815,6 +10815,17 @@ static inline int vcpu_block(struct kvm_vcpu *vcpu)
 			return 1;
 	}
 
+	/*
+	 * Evaluate nested events before exiting the halted state.  This allows
+	 * the halt state to be recorded properly in the VMCS12's activity
+	 * state field (AMD does not have a similar field and a VM-Exit always
+	 * causes a spurious wakeup from HLT).
+	 */
+	if (is_guest_mode(vcpu)) {
+		if (kvm_check_nested_events(vcpu) < 0)
+			return 0;
+	}
+
 	if (kvm_apic_accept_events(vcpu) < 0)
 		return 0;
 	switch(vcpu->arch.mp_state) {
@@ -10837,9 +10848,6 @@ static inline int vcpu_block(struct kvm_vcpu *vcpu)
 
 static inline bool kvm_vcpu_running(struct kvm_vcpu *vcpu)
 {
-	if (is_guest_mode(vcpu))
-		kvm_check_nested_events(vcpu);
-
 	return (vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE &&
 		!vcpu->arch.apf.halted);
 }
-- 
2.37.3.968.ga6b4b080e4-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <SRS0=FNOB=O5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49A92C433F5
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:13:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E2C1C610CE
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:13:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E2C1C610CE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 988254B16C;
	Fri,  8 Oct 2021 22:13:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PFBq5TGAlSIX; Fri,  8 Oct 2021 22:13:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C1DF4B177;
	Fri,  8 Oct 2021 22:13:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B1D04B15D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:13:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R7eqwivwmIFE for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Oct 2021 22:13:39 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0BC274B160
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:13:39 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 x15-20020a056902102f00b005ba71cd7dbfso4954036ybt.8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Oct 2021 19:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=U1tiLVYe+uI6GynZ+KQaLRA7FrCZBu6OMUfWvRALpKY=;
 b=a0dUiDnuPYQQeQR8jjKdumWe754GISZ9QQg3r88Y9DPMivvvQMFzh5ozOn9lgZsXNq
 EANJ0517a1qk3IJoQbDKT/HbLrXOUwIqcNyu7+dfgeXxAYoz4kpH6adSQnkUxJfAgZaH
 UPUzp5K5Wp61nwf9+BQC7R2+G4acKBHUtHtY2hEJqpIlphtwlmsMneENvaDHUPfYIfWA
 ce641KOEb7G5/eE8IiwGpPr2d3hjmLvvlL+U/IoLXhsAHo2ay+SC7X4AbXIrGRjqgSKf
 IvYRZoNRXUDoSssc3WxQQYPxSY6c1N4ujAzz18+PUihtVJsRky6YFUvr+8O4bpS4z7of
 nYOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=U1tiLVYe+uI6GynZ+KQaLRA7FrCZBu6OMUfWvRALpKY=;
 b=htP0IMT1cUM7sku2waq7lelanJNVAio1M6jcMkm461vD8xoEhg+AoagJcRi1ubSPnK
 pNYVqpMWMiKa3Tw8XsojxOynhHFbLPnvQMjYeHN/yLe/H34RswN0kDjTnrc407WZctmX
 S66ZBXmFpP6GqKnnTJBY4LhTm3f6vAYdA+aWRIQk+Hz4buQq7MfalIw1yOh0PAuMXUOQ
 HcuZ/6oX8wxdIF7I8vqKVZwj/iln3gOTSNQPLmtQMggGE09yYquhrsM66yYPME/nEbMA
 fKs5Q8VHNfaCjtYmxIGbZy6f0GSYmvZ6uHrmKyfQmXP389fzMxobJdOhVRW70uZSyByc
 aurw==
X-Gm-Message-State: AOAM5314z4nv8fhkzPVw9lejQaK/36hZpeqWIyljB8rnpOOmiIjAHS3w
 ow3QKvL608DogqkGDI3iWdrn+srK5KI=
X-Google-Smtp-Source: ABdhPJxgCS3VlMfHSnl5qi0AADkiPF1Y5hzLatGiCcOeklrDazrBVCyGloG341BJ/seTJPIOJhGhWWtHs4E=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:a5b:145:: with SMTP id
 c5mr7344586ybp.60.1633745618610; 
 Fri, 08 Oct 2021 19:13:38 -0700 (PDT)
Date: Fri,  8 Oct 2021 19:12:16 -0700
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Message-Id: <20211009021236.4122790-24-seanjc@google.com>
Mime-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2 23/43] KVM: VMX: Use boolean returns for Posted Interrupt
 "test" helpers
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

Return bools instead of ints for the posted interrupt "test" helpers.
The bit position of the flag being test does not matter to the callers,
and is in fact lost by virtue of test_bit() itself returning a bool.

Returning ints is potentially dangerous, e.g. "pi_test_on(pi_desc) == 1"
is safe-ish because ON is bit 0 and thus any sane implementation of
pi_test_on() will work, but for SN (bit 1), checking "== 1" would rely on
pi_test_on() to return 0 or 1, a.k.a. bools, as opposed to 0 or 2 (the
positive bit position).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/posted_intr.c | 4 ++--
 arch/x86/kvm/vmx/posted_intr.h | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 6c2110d91b06..1688f8dc535a 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -185,7 +185,7 @@ int pi_pre_block(struct kvm_vcpu *vcpu)
 			   new.control) != old.control);
 
 	/* We should not block the vCPU if an interrupt is posted for it.  */
-	if (pi_test_on(pi_desc) == 1)
+	if (pi_test_on(pi_desc))
 		__pi_post_block(vcpu);
 
 	local_irq_enable();
@@ -216,7 +216,7 @@ void pi_wakeup_handler(void)
 			blocked_vcpu_list) {
 		struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
 
-		if (pi_test_on(pi_desc) == 1)
+		if (pi_test_on(pi_desc))
 			kvm_vcpu_kick(vcpu);
 	}
 	spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, cpu));
diff --git a/arch/x86/kvm/vmx/posted_intr.h b/arch/x86/kvm/vmx/posted_intr.h
index 7f7b2326caf5..36ae035f14aa 100644
--- a/arch/x86/kvm/vmx/posted_intr.h
+++ b/arch/x86/kvm/vmx/posted_intr.h
@@ -40,7 +40,7 @@ static inline bool pi_test_and_clear_on(struct pi_desc *pi_desc)
 			(unsigned long *)&pi_desc->control);
 }
 
-static inline int pi_test_and_set_pir(int vector, struct pi_desc *pi_desc)
+static inline bool pi_test_and_set_pir(int vector, struct pi_desc *pi_desc)
 {
 	return test_and_set_bit(vector, (unsigned long *)pi_desc->pir);
 }
@@ -74,13 +74,13 @@ static inline void pi_clear_sn(struct pi_desc *pi_desc)
 		(unsigned long *)&pi_desc->control);
 }
 
-static inline int pi_test_on(struct pi_desc *pi_desc)
+static inline bool pi_test_on(struct pi_desc *pi_desc)
 {
 	return test_bit(POSTED_INTR_ON,
 			(unsigned long *)&pi_desc->control);
 }
 
-static inline int pi_test_sn(struct pi_desc *pi_desc)
+static inline bool pi_test_sn(struct pi_desc *pi_desc)
 {
 	return test_bit(POSTED_INTR_SN,
 			(unsigned long *)&pi_desc->control);
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

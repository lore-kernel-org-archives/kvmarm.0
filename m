Return-Path: <SRS0=FNOB=O5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BFA2C433F5
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:14:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4E5E361038
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:14:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4E5E361038
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 03F894B12F;
	Fri,  8 Oct 2021 22:14:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WJl9TvOdO501; Fri,  8 Oct 2021 22:14:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A0A404B1BC;
	Fri,  8 Oct 2021 22:14:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E7004B10E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:14:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HHfADo0zKCWP for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Oct 2021 22:14:20 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3F7854B1C1
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:14:20 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 z130-20020a256588000000b005b6b4594129so15101438ybb.15
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Oct 2021 19:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=aUX8Y2YLswKDqX/BLpfoyrV2JucXQRAbXeQDlXSPSss=;
 b=G5MbwU8BdaMQMjcxHC7wzAGcbCLg0J9TahLf26928bNhrSUGxee3WK+qIWNauLjJc2
 4Xwq4k9z0Bcozkgdo9UuN8pYL/McLuokdYERF6AjYJpP9DVrzz7LcHr5xQ7YSRGHDf83
 C4d2MTdybZ7qs6+Hvzz4omoXgx38bBowhcmbmBEmcHJcWdglD0Yhc1MiEuFt9Fw1KjYf
 IU8Si/NujuJeGl73mPfUyvTbrfWHQuWcYsMeCz7hSroDRTTwybjhxVWqi9JvGgqv6GdE
 c2z6JfVm7zV7RLMtNOh0ttQMOfVO1eAL7gbGkhhf3GzhLAQDASqkrGGTf6PyZKaDC4wn
 ItTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=aUX8Y2YLswKDqX/BLpfoyrV2JucXQRAbXeQDlXSPSss=;
 b=LviI40hkDRbgaAPQuIHL+Y6hxabaB0yO8MWZihC2bN81+ZyPponUTuo0TU9nJ2ph6Q
 bptrOO/mUfufesI/wIh7gWppNK0ohoHex4WxuWeQgLr/xg+duOcHv78E/O+3RDQIb0C5
 N2XbQrjywJRa1jGIimNu9evk6K/AIr74Qqp8GF9xFfZn6eT4ZLx38TlxGJkP5C0kNkyE
 JyJXUxNOWnFc3fkmtEEXLNAZQzNGFYKnt5xr9Yffd45ez6KK5CFSWGQy4paB6+i2xarA
 Cw6lKCplUTbtfQ6XNWCHfxUnXsR4DecmRbsUL1eu3Vmg6onMDHzOu/Zu9J5SKC1e1Xsz
 o1EA==
X-Gm-Message-State: AOAM531W9bTRe6jt9tM6MUWei0PZQt6f4udtZs4m65kPG9RuONFq5fn+
 vSR1ML1e+0YWtCpz1tWxqfKAfBR2Hfw=
X-Google-Smtp-Source: ABdhPJy/0bkpOZiIEUh7mp5zb57qYvZdonB+LQ1epmXddUZkHwIyS3cnCQFog4XmODRYh0Rav6GUeBBi44w=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:a25:2209:: with SMTP id
 i9mr7632692ybi.52.1633745659766; 
 Fri, 08 Oct 2021 19:14:19 -0700 (PDT)
Date: Fri,  8 Oct 2021 19:12:33 -0700
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Message-Id: <20211009021236.4122790-41-seanjc@google.com>
Mime-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2 40/43] KVM: VMX: Wake vCPU when delivering posted IRQ even
 if vCPU == this vCPU
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

Drop a check that guards triggering a posted interrupt on the currently
running vCPU, and more importantly guards waking the target vCPU if
triggering a posted interrupt fails because the vCPU isn't IN_GUEST_MODE.
The "do nothing" logic when "vcpu == running_vcpu" works only because KVM
doesn't have a path to ->deliver_posted_interrupt() from asynchronous
context, e.g. if apic_timer_expired() were changed to always go down the
posted interrupt path for APICv, or if the IN_GUEST_MODE check in
kvm_use_posted_timer_interrupt() were dropped, and the hrtimer fired in
kvm_vcpu_block() after the final kvm_vcpu_check_block() check, the vCPU
would be scheduled() out without being awakened, i.e. would "miss" the
timer interrupt.

One could argue that invoking kvm_apic_local_deliver() from (soft) IRQ
context for the current running vCPU should be illegal, but nothing in
KVM actually enforces that rules.  There's also no strong obvious benefit
to making such behavior illegal, e.g. checking IN_GUEST_MODE and calling
kvm_vcpu_wake_up() is at worst marginally more costly than querying the
current running vCPU.

Lastly, this aligns the non-nested and nested usage of triggering posted
interrupts, and will allow for additional cleanups.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 44d760dde0f9..78c8bc7f1b3b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4024,8 +4024,7 @@ static int vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
 	 * guaranteed to see PID.ON=1 and sync the PIR to IRR if triggering a
 	 * posted interrupt "fails" because vcpu->mode != IN_GUEST_MODE.
 	 */
-	if (vcpu != kvm_get_running_vcpu() &&
-	    !kvm_vcpu_trigger_posted_interrupt(vcpu, false))
+	if (!kvm_vcpu_trigger_posted_interrupt(vcpu, false))
 		kvm_vcpu_wake_up(vcpu);
 
 	return 0;
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

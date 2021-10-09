Return-Path: <SRS0=FNOB=O5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72882C433F5
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:13:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 26C1A61038
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:13:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 26C1A61038
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D09734B0ED;
	Fri,  8 Oct 2021 22:13:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hdc6ZoDAstnK; Fri,  8 Oct 2021 22:13:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 86E204B163;
	Fri,  8 Oct 2021 22:13:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 343DD4B0CE
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:13:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id azGaS1fjGXtF for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Oct 2021 22:13:26 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 416DD4A98B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:13:26 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id
 gm12-20020a056214268c00b003830d91ceabso10255105qvb.19
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Oct 2021 19:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=qbaTmooIqpw2scwWIPvYnbgTG8gkipCw/gcnfpltSGY=;
 b=FuJT0BM9dDnYucltpEKN/3PIbfdvyXmexJqecK3YzG4d74UzCBAUJzNpfna5d3hhf9
 CThoB+q3zbECmvBpsVwSPC65vqE3PC/pyRXG3MptW0vOaTjGmTNfFzi4I7G//ciy+nJL
 p2SrF4m156i96jaV+xzdhT+w6QkXcy0HHxtm4YS01i3rZ/GAWxIlxZ4cG090KNqUoG+F
 MZ7IfesCmYwBPSKodHNoD1ZFOQvtV8bnYcdLR84ii1K0oqwvG/i2DqC+H4C9C8AdNE7S
 NtI/ovPQV920bh3qJxqxqTJF2XHwSs9PcFYmvUBVFETjJlGAhfkCawm/pDGPWqba98m2
 bBYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=qbaTmooIqpw2scwWIPvYnbgTG8gkipCw/gcnfpltSGY=;
 b=iUelGWUt8J0NpcB1yPR7gJUNgnNtjqxTbThN+/K8Pv8U9ET+2a6FN6+6cm5fu3DPqF
 3ogaFxMt6KfnoXKfRBBv1XNpbky1tni4BAE/VUAew3J+njjfUl0UOxVI5tAcjmjlHfua
 jfis+ayNY/AhtHCzu3HoAmwrI0ju+mobNRXCAm1c43dgy/EL9jgjvTKTOiX6qrom//Ca
 fgT9fndaq75pK/rqUcn/xPYtfGqu7WvB714NWJTMK8l/L0OdboOmNTiwfQaT3DPf/TDR
 skmcYPkco5851MLG7Zu27lqNHSaEpqwXgm2mHapdQ3xRIV/tk0sK+2Qo+NazlmiG+WP2
 dd+g==
X-Gm-Message-State: AOAM531hriMv9vFppZKWUTiZ+y4zO2Bp/3hxDbYTqBj9LDP3DeNvQ3ZA
 5SjJucAIyzz+Q/Xby7bm4gOr+jHdrM4=
X-Google-Smtp-Source: ABdhPJzmsEVzPU7/MqwbML2H7/jnReeletG9BCOCcGkMjuKkxZyo31ypELMFzY3g7cKF9pg0VOLbDRLLOow=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:ac8:4e11:: with SMTP id
 c17mr1903866qtw.400.1633745605808; 
 Fri, 08 Oct 2021 19:13:25 -0700 (PDT)
Date: Fri,  8 Oct 2021 19:12:11 -0700
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Message-Id: <20211009021236.4122790-19-seanjc@google.com>
Mime-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2 18/43] KVM: x86: Invoke kvm_vcpu_block() directly for
 non-HALTED wait states
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

Call kvm_vcpu_block() directly for all wait states except HALTED so that
kvm_vcpu_halt() is no longer a misnomer on x86.

Functionally, this means KVM will never attempt halt-polling or adjust
vcpu->halt_poll_ns for INIT_RECEIVED (a.k.a. Wait-For-SIPI (WFS)) or
AP_RESET_HOLD; UNINITIALIZED is handled in kvm_arch_vcpu_ioctl_run(),
and x86 doesn't use any other "wait" states.

As mentioned above, the motivation of this is purely so that "halt" isn't
overloaded on x86, e.g. in KVM's stats.  Skipping halt-polling for WFS
(and RESET_HOLD) has no meaningful effect on guest performance as there
are typically single-digit numbers of INIT-SIPI sequences per AP vCPU,
per boot, versus thousands of HLTs just to boot to console.

Reviewed-by: David Matlack <dmatlack@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cd51f100e906..e0219acfd9cf 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9899,7 +9899,10 @@ static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
 	if (!kvm_arch_vcpu_runnable(vcpu) &&
 	    (!kvm_x86_ops.pre_block || static_call(kvm_x86_pre_block)(vcpu) == 0)) {
 		srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
-		kvm_vcpu_halt(vcpu);
+		if (vcpu->arch.mp_state == KVM_MP_STATE_HALTED)
+			kvm_vcpu_halt(vcpu);
+		else
+			kvm_vcpu_block(vcpu);
 		vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
 
 		if (kvm_x86_ops.post_block)
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

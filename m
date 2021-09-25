Return-Path: <SRS0=Rd7Q=OP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3C4FC433F5
	for <kvmarm@archiver.kernel.org>; Sat, 25 Sep 2021 00:56:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 669376125F
	for <kvmarm@archiver.kernel.org>; Sat, 25 Sep 2021 00:56:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 669376125F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 12B064B14C;
	Fri, 24 Sep 2021 20:56:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id n6K9JjuOIjGu; Fri, 24 Sep 2021 20:56:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FBE14B166;
	Fri, 24 Sep 2021 20:56:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F35F4B0C0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 20:56:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id C1oEee99NKkR for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Sep 2021 20:56:01 -0400 (EDT)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 638344B154
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 20:56:01 -0400 (EDT)
Received: by mail-qv1-f74.google.com with SMTP id
 p75-20020a0c90d1000000b0037efc8547d4so42815175qvp.16
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 17:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=tGZGtRLoZzNRBWuDX4atzZ2k0Ip4ycJYdNIYDqARGnc=;
 b=q8E3mpn27/Pass6ib5GcuNokaZJD0e7qJsR4kNTZjxo9jjWSI+mPtm05xarcRKasl1
 eiFJZIt6Waa+VtYIE206wV5Amydeo2kxEZobGt+H4Q7ebAG/VEzonmVr8CFk6YXe+jXN
 W06JSJIyK8g02iwbmqnvaWK7HXlJE0p7Kr92YW24blQoLluhFcvm1UzWcfdHx6Mdh9E3
 XOOQzUfJHlMrFgWO0gIitekddWDl9aJ5BQBVyiZFtwCnwmzu20R18ovjRC2G+D/w+g99
 M1FfmCuusJk2YNOkp6OkdVHAMCjUZdoms1MR0veWZuhlJz5kL9fGMpAA8u0K0cmeYPze
 HHkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=tGZGtRLoZzNRBWuDX4atzZ2k0Ip4ycJYdNIYDqARGnc=;
 b=lNpu3r5y0Un0yIrx6vL9j3irh20imbYsnqw0Efcg6gxyAZ1mMm5fRVLjPqY4BpZj+g
 qR4+3uUiKDWiUpdMhx66LbWZAo3VZ9LMJf+cFp5F1Wd69aBKbdUSokGMrYOzWV1bXKnI
 2kmacH2UiOqENre+ViYkWnrhJXKz5MZQhOBpDjM7LcLCq6RhNmjBgUd7Nh2w+XS+ioW3
 joWwCGzXeGAQYpqU+QOwgt1y+gEcKDjowOaCFVCd0naT+vPOnarOBku4YAUnj5YqR0j+
 SdA3YjG3P9u+eqz5uwOaPEaio8qLks7VjPqK3diVFnhTvs/sJwZ9peSEIl/PMA3MVtoB
 mKDw==
X-Gm-Message-State: AOAM533XCqkbDkZxIcdwfr57G0qwWccRA047qty+pqpdr8hhR2Ng+II5
 /wp90cbCetdkLkp6r7p8QfZfA/+G2Mc=
X-Google-Smtp-Source: ABdhPJyQYJ0x7OvSRpcYmAQ5BRWQd9bkmRh9jP0168EXXRbBHlQe+/VA1c8Ui0BDQ2o8LiZTwir9hfGFAMI=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:4c72:89be:dba3:2bcb])
 (user=seanjc job=sendgmr) by 2002:a05:6214:2ec:: with SMTP id
 h12mr13351238qvu.1.1632531361061; Fri, 24 Sep 2021 17:56:01 -0700 (PDT)
Date: Fri, 24 Sep 2021 17:55:28 -0700
In-Reply-To: <20210925005528.1145584-1-seanjc@google.com>
Message-Id: <20210925005528.1145584-15-seanjc@google.com>
Mime-Version: 1.0
References: <20210925005528.1145584-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH 14/14] KVM: x86: Invoke kvm_vcpu_block() directly for
 non-HALTED wait states
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

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b444f9315766..a0f313c4bc49 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9893,7 +9893,10 @@ static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
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
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

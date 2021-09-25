Return-Path: <SRS0=Rd7Q=OP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD7D8C433FE
	for <kvmarm@archiver.kernel.org>; Sat, 25 Sep 2021 00:55:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8266C61260
	for <kvmarm@archiver.kernel.org>; Sat, 25 Sep 2021 00:55:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8266C61260
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 35AEC4B164;
	Fri, 24 Sep 2021 20:55:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MC6X64QgPCwV; Fri, 24 Sep 2021 20:55:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 176E14B102;
	Fri, 24 Sep 2021 20:55:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 924744B130
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 20:55:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id C+fB83u25m1Z for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Sep 2021 20:55:43 -0400 (EDT)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1B0C34B10E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 20:55:42 -0400 (EDT)
Received: by mail-qv1-f74.google.com with SMTP id
 h25-20020a0cab19000000b0037a49d15c93so42561999qvb.22
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 17:55:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=uLdmTcdOYtZZFn/MuvyFluHWXgJOTY2/q4ao2KO0G1s=;
 b=gPL1+MSjD+xrjkXRcOmwNqC67Mmvr7RuwzpFUcjOcMddzQt5ApvpYmHx9XRbluCLBL
 Yg1nvCEit3T0YJNXit7IRIoK7VGM0aOPR2LyM5Quj71xnW24SDpghbthAKdIVpkpkzRd
 X6gkLqVFB0i84k54sjonsicOkdWeYV2sQavG8Mv3aAQIe9i53EotyhPSycXboSC/o/x4
 nIX64OghkAl/Sc0vGnSXFuQP7lt0994oRwNLKAlZQBXOCXCEC6YhE0vIEN6r/f82ulAH
 xcNqf+D9f3lARXxv2SfegpANARLuOHGy1ceCMn8cGGb9ki40BxZxld2KVYTLW7PXUDEk
 tT2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=uLdmTcdOYtZZFn/MuvyFluHWXgJOTY2/q4ao2KO0G1s=;
 b=HcnhyCalF/07bjT3lWGsl1ULRyNiyRVORMm90FNynr7mfezjk2tZt8oHF4spG7OnZo
 R8uqTcU04S6ffuEA1cJ0Lkt5IicKkcYBstwQeQasG/UGT8m4t1A+nHxR7pGvo1xwiYH4
 UtXRHUraJiSW7gtauVtTgv6xjbcB3Hunc9vD+YTF1DaqakWbOexfjNsclm9ty1v9UwL0
 SfkaJa3863YdUay/6JN9BoYhviL6WpkpPgNOMp286oArdO0pF0O9NZE3p1gomHKvgXIv
 AcgKxSchLg1gyy9HXmcWa/sHpMgb5nKb8gdoPRVjWd3zSGfgcm0yNO8oQKd7fu3/O6dC
 8ILg==
X-Gm-Message-State: AOAM533B99+mAIfIpjWR/q/g27HD1q5dr1IFACKNfXm5WjXRixRzfVrQ
 SLrW9UQIYBc/fFy/dCdviVV7a0NKHYc=
X-Google-Smtp-Source: ABdhPJyVJB4HLPJhBHC7Pbe0078HVzq+2LEwo+Z0/uFPixWTHq0eCSAqgxL/c3TZhIqWciWqG/9d+DXnsIA=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:4c72:89be:dba3:2bcb])
 (user=seanjc job=sendgmr) by 2002:a05:6214:54f:: with SMTP id
 ci15mr12992188qvb.29.1632531341625; Fri, 24 Sep 2021 17:55:41 -0700 (PDT)
Date: Fri, 24 Sep 2021 17:55:19 -0700
In-Reply-To: <20210925005528.1145584-1-seanjc@google.com>
Message-Id: <20210925005528.1145584-6-seanjc@google.com>
Mime-Version: 1.0
References: <20210925005528.1145584-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH 05/14] KVM: s390: Clear valid_wakeup in kvm_s390_handle_wait(), 
 not in arch hook
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

Move the clearing of valid_wakeup out of kvm_arch_vcpu_block_finish() so
that a future patch can drop said arch hook.  Unlike the other blocking-
related arch hooks (vcpu_blocking/unblocking()), vcpu_block_finish() needs
to be called even if the KVM doesn't actually block the vCPU.  This will
allow future patches to differentiate between truly blocking the vCPU and
emulating a halt condition without introducing a contradiction.

Alternatively, the hook could be renamed to kvm_arch_vcpu_halt_finish(),
but there's literally one call site in s390, and future cleanup can also
be done to handle valid_wakeup fully within kvm_s390_handle_wait() and
allow generic KVM to drop vcpu_valid_wakeup().

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/s390/kvm/interrupt.c | 1 +
 arch/s390/kvm/kvm-s390.c  | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 10722455fd02..520450a7956f 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -1336,6 +1336,7 @@ int kvm_s390_handle_wait(struct kvm_vcpu *vcpu)
 no_timer:
 	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
 	kvm_vcpu_block(vcpu);
+	vcpu->valid_wakeup = false;
 	__unset_cpu_idle(vcpu);
 	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
 
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 7cabe6778b1b..08ed68639a21 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -5082,7 +5082,7 @@ static inline unsigned long nonhyp_mask(int i)
 
 void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu)
 {
-	vcpu->valid_wakeup = false;
+
 }
 
 static int __init kvm_s390_init(void)
-- 
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <SRS0=Rd7Q=OP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97131C433F5
	for <kvmarm@archiver.kernel.org>; Sat, 25 Sep 2021 00:55:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3BEE961260
	for <kvmarm@archiver.kernel.org>; Sat, 25 Sep 2021 00:55:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3BEE961260
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D5FC44B12C;
	Fri, 24 Sep 2021 20:55:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id U+D9V8UDgjCq; Fri, 24 Sep 2021 20:55:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B0EC84B130;
	Fri, 24 Sep 2021 20:55:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 891F14B0DB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 20:55:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4-jzp4T6f4hA for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Sep 2021 20:55:39 -0400 (EDT)
Received: from mail-qt1-f202.google.com (mail-qt1-f202.google.com
 [209.85.160.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C3ED24B136
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 20:55:37 -0400 (EDT)
Received: by mail-qt1-f202.google.com with SMTP id
 90-20020aed3163000000b002a6bd958077so31349095qtg.6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 17:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=1tsfKS32dF2lOop6Q8UszZBRwEC1JoDP5uy22kEXik0=;
 b=tJRFGMXxcfK7pjn1+YX8rDDAthpdiwDmAlAoR2O4LLVHkl7MoFkfnuCmTDY6MHO1AC
 aU5DlddWuaqvJAQ2CEADWDeGHvUIp0FI39I8iy3P4amF9cNUWQNgM57HmTykWDcy+8dY
 Mvu71xxPYDUZ2+A3pWrg86E9wAuN+QDmT67xFTEgcecgyMJgcjVmXEjzTnAcaMkNUYaw
 /ZRnegcxQxaUe1Qca+BGV3DDCVscs5r4gu+tlHzecUaMdV03kKXd/csNW6uPtiB/uByL
 0CzeZSzGROfkTu8PuYQOHZZQRRU/J1vbhU3wMhBJTHe4WQm7fS0zEQ9aK+6AU0nSmeBC
 32Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=1tsfKS32dF2lOop6Q8UszZBRwEC1JoDP5uy22kEXik0=;
 b=aTZe6/QCj6CtY24LwkEuUGzLQsFTgBVP9zEHsIGmJUtXiIjAHC7kQnIfo+SaLQv4g8
 7H8/p10rsklC5pL5+Ds1wuvkEH25lx4j23AjRmmOuVXm7rDaEjaa5Lk2aop+sFgnatuz
 rzVfOUoGeiQnKdaV75FAYK+47l3sxwBZkbUx3nDC2f4zqGF5CL2HH2HJ/vOI0mIRu1vV
 xXDLOUbrHent9pcTof68sp27efxYwykC+YXpyS02W+2nwMSAPFETzAoNNUx9HS3xOmzO
 4Nki8u6WT7vf8+hBdAcschYzvwczuqrZFZigCNV/Ce9v6UCvGixfxjPtvUxbIDBn48Md
 cHAw==
X-Gm-Message-State: AOAM531HENGlbdikJDAjk1DrgnajckAFbmbbzhYKWPe2NombwUeVXA5p
 pfHTYpsfNlDqocydBfEWxqUW8Elbczg=
X-Google-Smtp-Source: ABdhPJwPQKNSl/89/W6mMga+Zk98xyYbngE63RzqoPcRph2DGAKR41ssH/CZTrknnPOD67N3xW0Inpq3BFE=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:4c72:89be:dba3:2bcb])
 (user=seanjc job=sendgmr) by 2002:a05:6214:1593:: with SMTP id
 m19mr13005135qvw.36.1632531337323; Fri, 24 Sep 2021 17:55:37 -0700 (PDT)
Date: Fri, 24 Sep 2021 17:55:17 -0700
In-Reply-To: <20210925005528.1145584-1-seanjc@google.com>
Message-Id: <20210925005528.1145584-4-seanjc@google.com>
Mime-Version: 1.0
References: <20210925005528.1145584-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH 03/14] KVM: Refactor and document halt-polling stats update
 helper
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

Add a comment to document that halt-polling is considered successful even
if the polling loop itself didn't detect a wake event, i.e. if a wake
event was detect in the final kvm_vcpu_check_block().  Invert the param
to the update helper so that the helper is a dumb function that is "told"
whether or not polling was successful, as opposed to having it determinine
success/failure based on blocking behavior.

Opportunistically tweak the params to the update helper to reduce the
line length for the call site so that it fits on a single line, and so
that the prototype conforms to the more traditional kernel style.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8b33f5045b4d..12fe91a0a4c8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3199,13 +3199,15 @@ static int kvm_vcpu_check_block(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
-static inline void
-update_halt_poll_stats(struct kvm_vcpu *vcpu, u64 poll_ns, bool waited)
+static inline void update_halt_poll_stats(struct kvm_vcpu *vcpu, ktime_t start,
+					  ktime_t end, bool success)
 {
-	if (waited)
-		vcpu->stat.generic.halt_poll_fail_ns += poll_ns;
-	else
+	u64 poll_ns = ktime_to_ns(ktime_sub(end, start));
+
+	if (success)
 		vcpu->stat.generic.halt_poll_success_ns += poll_ns;
+	else
+		vcpu->stat.generic.halt_poll_fail_ns += poll_ns;
 }
 
 /*
@@ -3274,9 +3276,13 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	kvm_arch_vcpu_unblocking(vcpu);
 	block_ns = ktime_to_ns(cur) - ktime_to_ns(start);
 
+	/*
+	 * Note, halt-polling is considered successful so long as the vCPU was
+	 * never actually scheduled out, i.e. even if the wake event arrived
+	 * after of the halt-polling loop itself, but before the full wait.
+	 */
 	if (do_halt_poll)
-		update_halt_poll_stats(
-			vcpu, ktime_to_ns(ktime_sub(poll_end, start)), waited);
+		update_halt_poll_stats(vcpu, start, poll_end, !waited);
 
 	if (halt_poll_allowed) {
 		if (!vcpu_valid_wakeup(vcpu)) {
-- 
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

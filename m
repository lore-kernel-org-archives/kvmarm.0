Return-Path: <SRS0=Rd7Q=OP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B797FC433F5
	for <kvmarm@archiver.kernel.org>; Sat, 25 Sep 2021 00:56:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6D81C61260
	for <kvmarm@archiver.kernel.org>; Sat, 25 Sep 2021 00:56:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6D81C61260
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F11F4B0E2;
	Fri, 24 Sep 2021 20:56:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tSfc5+z9T6m8; Fri, 24 Sep 2021 20:56:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F1954B0CB;
	Fri, 24 Sep 2021 20:56:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 20CB14B0E2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 20:55:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id d2MwuqHdOFoi for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Sep 2021 20:55:58 -0400 (EDT)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 59A4A4B149
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 20:55:57 -0400 (EDT)
Received: by mail-qv1-f74.google.com with SMTP id
 da19-20020a05621408d300b00382307badfeso13463591qvb.10
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 17:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=5cNFroYBSThqqpJCYxzBjAkytlwovA+rbtWpXsyqDeo=;
 b=SfLacDGDPv0O+ce1feGYy7BDlJVOIPkrwFpJqoWdePykloL2O82WlaKRzOwLeffojV
 WekB5mzNRTsRAE7CDSxzp55a5GlHpqh/h04E/0Cqn+9co39zSHc1rwlgwjHIm0Eq+/g1
 rLsDyI7TI6ImRbwiTwKX0t1Q8ZQyoCYrzRYyQ4Xqwn0rlAUNh8TrYEq/em7hwrNonrfc
 Au70p/9HXYWVD3oyP35n9WXZarKqfxjjLGSen8K95241TMcO649zTLMZSD1UsjUAj//k
 JNR5GrbIoX2CF5HqJzqUR8/mcVQlOI2NUabeIFYhUNE1yZiL3ZPJAKN3+lQsuLE7ow/b
 sO3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=5cNFroYBSThqqpJCYxzBjAkytlwovA+rbtWpXsyqDeo=;
 b=QYVVRz6F1VZL2XFs+uEKKj7+foPHSeUOiYdq5iQPON/Gg8Dio78GQ+1+kwYLd2kaPK
 +NzjsuRaaMqUPxKGfbyukxzbKTrlZcXqsN6x4Fuhv+Zr6nPKisqJ2ogO7Cx2algSJhtf
 Mu6R1zssBWPzEYDOqCcIZFI6DhL5BalyROccg92CWg5utBzLb62Jex/H7Qmltdd46qYd
 SQxnp5NjrjdpCmO6mXt5ey1Eyml9QC13hZRGOTsXxv0UF+S+4l1+9ibLK18p3X2QtFMz
 Mg4hHJ6cRs5dHZND6l+Wvs27yYNg7vgi892LmvS3HJ55zMmvUhSugpbxA8q3x5WAw1ET
 BPeg==
X-Gm-Message-State: AOAM531efpSQ2ROTS6pREUhml3EFr0SielYj6c3mtqTVF7E/+oidRgpD
 o96sP28HWvpiZPdTte7Qvv+QdbuVe1Y=
X-Google-Smtp-Source: ABdhPJwTW1UybwFgg5M8F4nzh531Ub5JbtN0jF/yWxCBJfUYuvXgy/++XZQV+BSuMlLfxb0INGVd0hW95rg=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:4c72:89be:dba3:2bcb])
 (user=seanjc job=sendgmr) by 2002:a05:6214:148b:: with SMTP id
 bn11mr13269187qvb.67.1632531356963; Fri, 24 Sep 2021 17:55:56 -0700 (PDT)
Date: Fri, 24 Sep 2021 17:55:26 -0700
In-Reply-To: <20210925005528.1145584-1-seanjc@google.com>
Message-Id: <20210925005528.1145584-13-seanjc@google.com>
Mime-Version: 1.0
References: <20210925005528.1145584-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH 12/14] KVM: Don't redo ktime_get() when calculating
 halt-polling stop/deadline
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

Calculate the halt-polling "stop" time using "cur" instead of redoing
ktime_get().  In the happy case where hardware correctly predicts
do_halt_poll, "cur" is only a few cycles old.  And if the branch is
mispredicted, arguably that extra latency should count toward the
halt-polling time.

In all likelihood, the numbers involved are in the noise and either
approach is perfectly ok.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2980d2b88559..80f78daa6b8d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3267,7 +3267,7 @@ void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
 
 	start = cur = poll_end = ktime_get();
 	if (do_halt_poll) {
-		ktime_t stop = ktime_add_ns(ktime_get(), vcpu->halt_poll_ns);
+		ktime_t stop = ktime_add_ns(cur, vcpu->halt_poll_ns);
 
 		do {
 			/*
-- 
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

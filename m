Return-Path: <SRS0=Rd7Q=OP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE839C433FE
	for <kvmarm@archiver.kernel.org>; Sat, 25 Sep 2021 00:55:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 53B936125F
	for <kvmarm@archiver.kernel.org>; Sat, 25 Sep 2021 00:55:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 53B936125F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F20A34B149;
	Fri, 24 Sep 2021 20:55:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wpuIDImM4Sth; Fri, 24 Sep 2021 20:55:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CF9C84B139;
	Fri, 24 Sep 2021 20:55:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 911384B126
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 20:55:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GkSVlsGVILui for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Sep 2021 20:55:39 -0400 (EDT)
Received: from mail-qk1-f202.google.com (mail-qk1-f202.google.com
 [209.85.222.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A63664B131
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 20:55:35 -0400 (EDT)
Received: by mail-qk1-f202.google.com with SMTP id
 h10-20020a05620a284a00b003d30e8c8cb5so44218718qkp.11
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 17:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=2ksHGqIX50byEw/B/i+4MAj6IHSuI0V9Re6S49u78QE=;
 b=Cv4b8gw7+pQzNKHQ+8lMUi5KSfKwZImP0gbOdovtDY21Pa+DbRVpLf0FX3Ny/GtGV+
 l0V69NsBIy1juCTYkrc+ZecGEpb/+2U0I7btvRRB/j7TbeGomRTqALuS7CRNK3ZK77rs
 I8jAXLs2069h1QaDqdwGdc7NdArdNnk8SOx0Kbb5tZimbUbkp1AE++ltJXqt239HcPIt
 7iiqQhvEA6upugk00ug/jEN4lU79fHpjgvTEj2CtM3woq//N0ZgH8t2jvtwzT+D/nuL5
 Y0Urz5Yiku+Wb2J8tPb6U/TZ8fP2oxfPADDLSPy+boqaGEopEHKI+QAne2jnc9ignY3J
 8/fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=2ksHGqIX50byEw/B/i+4MAj6IHSuI0V9Re6S49u78QE=;
 b=qil5MZ6A0zBkY8xsv1NrkPS0Or9lXg3xWjctB1WNpAhXmg+yqVde/xOjT286Hr9K7K
 /KAAHLx62dP9rl5LwsfEyQzKfldB5PZH2wBa6+k5sj78i8E4zUCagvZcsC57tX1yoLXA
 P6ecCNcJfN1FLWR6dOnrbXJ5hWgvFFMsgsDL0FhdtZE359gRqmdFl+pfwV/TZkB/p1SG
 OD/BV7vhNJFqusrVn8nhiYfa8Rdxc60uHnNwjcrjE/ZK9fV/zCeXsGcJG+UppKPJB4eu
 HcC5bzOwyQApxmSNYHa2tZYvGfQgPHpDC53IApyE5tricq4lkl9I9vntH37ZSPIMyNkb
 V8bw==
X-Gm-Message-State: AOAM530/r6GYrvo3Z0jCwOtJdV+6fWPcYnqXsRh4z13W2HMJUv5WEl24
 9/nyOb3tpOeP0ktvrAxWWWqfupsRKfY=
X-Google-Smtp-Source: ABdhPJyoBfybYr+VTcT30KA/5NRI2oATafpveFnKITvJxQlG0tfUXjcoc8CvFJgJOt3i4NZOnBOTLU/4h4Y=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:4c72:89be:dba3:2bcb])
 (user=seanjc job=sendgmr) by 2002:a05:6214:44e:: with SMTP id
 cc14mr13352413qvb.19.1632531335232; Fri, 24 Sep 2021 17:55:35 -0700 (PDT)
Date: Fri, 24 Sep 2021 17:55:16 -0700
In-Reply-To: <20210925005528.1145584-1-seanjc@google.com>
Message-Id: <20210925005528.1145584-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210925005528.1145584-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH 02/14] KVM: Update halt-polling stats if and only if
 halt-polling was attempted
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

Don't update halt-polling stats if halt-polling wasn't attempted.  This
is a nop as @poll_ns is guaranteed to be '0' (poll_end == start), but it
will allow a future patch to move the histogram stats into the helper to
resolve a discrepancy in what is considered a "successful" halt-poll.

No functional change intended.

Cc: David Matlack <dmatlack@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 768a4cbb26a6..8b33f5045b4d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3214,6 +3214,7 @@ update_halt_poll_stats(struct kvm_vcpu *vcpu, u64 poll_ns, bool waited)
 void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 {
 	bool halt_poll_allowed = !kvm_arch_no_poll(vcpu);
+	bool do_halt_poll = halt_poll_allowed && vcpu->halt_poll_ns;
 	ktime_t start, cur, poll_end;
 	bool waited = false;
 	u64 block_ns;
@@ -3221,7 +3222,7 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	kvm_arch_vcpu_blocking(vcpu);
 
 	start = cur = poll_end = ktime_get();
-	if (vcpu->halt_poll_ns && halt_poll_allowed) {
+	if (do_halt_poll) {
 		ktime_t stop = ktime_add_ns(ktime_get(), vcpu->halt_poll_ns);
 
 		++vcpu->stat.generic.halt_attempted_poll;
@@ -3273,8 +3274,9 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	kvm_arch_vcpu_unblocking(vcpu);
 	block_ns = ktime_to_ns(cur) - ktime_to_ns(start);
 
-	update_halt_poll_stats(
-		vcpu, ktime_to_ns(ktime_sub(poll_end, start)), waited);
+	if (do_halt_poll)
+		update_halt_poll_stats(
+			vcpu, ktime_to_ns(ktime_sub(poll_end, start)), waited);
 
 	if (halt_poll_allowed) {
 		if (!vcpu_valid_wakeup(vcpu)) {
-- 
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

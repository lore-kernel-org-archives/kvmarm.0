Return-Path: <SRS0=Rd7Q=OP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 605D7C433F5
	for <kvmarm@archiver.kernel.org>; Sat, 25 Sep 2021 00:55:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DE99F610EA
	for <kvmarm@archiver.kernel.org>; Sat, 25 Sep 2021 00:55:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DE99F610EA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 897004B102;
	Fri, 24 Sep 2021 20:55:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hALrsrgLoVnX; Fri, 24 Sep 2021 20:55:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 85C5A4B10E;
	Fri, 24 Sep 2021 20:55:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B615E4B0C0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 20:55:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TSjK4R+NiEBx for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Sep 2021 20:55:33 -0400 (EDT)
Received: from mail-qt1-f202.google.com (mail-qt1-f202.google.com
 [209.85.160.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 90DD34B0D7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 20:55:33 -0400 (EDT)
Received: by mail-qt1-f202.google.com with SMTP id
 c21-20020ac85195000000b002a540bbf1caso42682614qtn.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 17:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=s8Ef8GFuvQfnF9BDar9o1LMsjHo/kVSjkp6RQOizXjk=;
 b=G61LH4mFxuFNSPc8dYANo1eT4LoYTtllF8CmUigAVUwE47niN3IxCLvz7gdu3kXJ4p
 ZQGRUPxd6lVd1pie3osAQPOxmbLJto1U72TFRKzU7SrEeLnRgNzwFM67EhN9OMHtfLK4
 0P8CpLo4DBhmRIO3KNivDhM66x7e790LPKbt1kMUUoaEFJ8BrQ0kHU4SkwA9CnUG4ZvG
 NOgccEjti04droRcKSejfuWWOI2KRU0PMG/o1TrFggkFEC3/F7K7dtkErqqSnuV7wQju
 UsaZQRj+Ze+2OUu3FUTytK0ap4L7DtgKMjJqvpn6WamsAAvTkNWZ6Fzz7ReqK7CQj28q
 kOig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=s8Ef8GFuvQfnF9BDar9o1LMsjHo/kVSjkp6RQOizXjk=;
 b=7vpuiNUD1K+Z1tcoV/y29m7W0aBvcb7Ml4DJmuGVWvVTqSjfTkRzQR0yei3/3OdNbe
 b+FzaBhRQK2l3im30YKiU8qW7Me4xk9RoCQmmwcuoaKhmDfrotWObjs9w+VQkmDBgBrv
 WVm+OgJNTOmxB2mdrG5LP6vD0tp3jMKCjbTYlKs7aLRJxbeMQtAeL70rBwd75TAREWMT
 Cibx5mi97p0eiXvHspudg7QmXHIokuWaLZKycZi28PGxMtHWqa9hN4XXfFKHzxxJbB7I
 F53oOdj3N81lWJ+J3HwFYdZSUo8vhtsZBN11DNwIjAPmbIYrgIw+Ne36ktaI3eyWurwj
 yxNg==
X-Gm-Message-State: AOAM530g4Ltqtro/7JJAdHGJpyMSjgYAfz6zyFFTXaumppmFrSo0NRGG
 6JCd3ikpdFPxjazRcFFzixkvI8HZACo=
X-Google-Smtp-Source: ABdhPJz4KlXw4aFKDakmak5VHFe0t/03Im2jas/e5lfzq06w+q+oBXLEOxDY5zwYzZ40nGkko5J4YoUheek=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:4c72:89be:dba3:2bcb])
 (user=seanjc job=sendgmr) by 2002:a05:6214:2d1:: with SMTP id
 g17mr13106407qvu.63.1632531332975; Fri, 24 Sep 2021 17:55:32 -0700 (PDT)
Date: Fri, 24 Sep 2021 17:55:15 -0700
In-Reply-To: <20210925005528.1145584-1-seanjc@google.com>
Message-Id: <20210925005528.1145584-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210925005528.1145584-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH 01/14] KVM: s390: Ensure kvm_arch_no_poll() is read once when
 blocking vCPU
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

Wrap s390's halt_poll_max_steal with READ_ONCE and snapshot the result of
kvm_arch_no_poll() in kvm_vcpu_block() to avoid a mostly-theoretical,
largely benign bug on s390 where the result of kvm_arch_no_poll() could
change due to userspace modifying halt_poll_max_steal while the vCPU is
blocking.  The bug is largely benign as it will either cause KVM to skip
updating halt-polling times (no_poll toggles false=>true) or to update
halt-polling times with a slightly flawed block_ns.

Note, READ_ONCE is unnecessary in the current code, add it in case the
arch hook is ever inlined, and to provide a hint that userspace can
change the param at will.

Fixes: 8b905d28ee17 ("KVM: s390: provide kvm_arch_no_poll function")
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/s390/kvm/kvm-s390.c | 2 +-
 virt/kvm/kvm_main.c      | 5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 6a6dd5e1daf6..7cabe6778b1b 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3446,7 +3446,7 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
 {
 	/* do not poll with more than halt_poll_max_steal percent of steal time */
 	if (S390_lowcore.avg_steal_timer * 100 / (TICK_USEC << 12) >=
-	    halt_poll_max_steal) {
+	    READ_ONCE(halt_poll_max_steal)) {
 		vcpu->stat.halt_no_poll_steal++;
 		return true;
 	}
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 191dac6b1bed..768a4cbb26a6 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3213,6 +3213,7 @@ update_halt_poll_stats(struct kvm_vcpu *vcpu, u64 poll_ns, bool waited)
  */
 void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 {
+	bool halt_poll_allowed = !kvm_arch_no_poll(vcpu);
 	ktime_t start, cur, poll_end;
 	bool waited = false;
 	u64 block_ns;
@@ -3220,7 +3221,7 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	kvm_arch_vcpu_blocking(vcpu);
 
 	start = cur = poll_end = ktime_get();
-	if (vcpu->halt_poll_ns && !kvm_arch_no_poll(vcpu)) {
+	if (vcpu->halt_poll_ns && halt_poll_allowed) {
 		ktime_t stop = ktime_add_ns(ktime_get(), vcpu->halt_poll_ns);
 
 		++vcpu->stat.generic.halt_attempted_poll;
@@ -3275,7 +3276,7 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	update_halt_poll_stats(
 		vcpu, ktime_to_ns(ktime_sub(poll_end, start)), waited);
 
-	if (!kvm_arch_no_poll(vcpu)) {
+	if (halt_poll_allowed) {
 		if (!vcpu_valid_wakeup(vcpu)) {
 			shrink_halt_poll_ns(vcpu);
 		} else if (vcpu->kvm->max_halt_poll_ns) {
-- 
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

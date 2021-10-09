Return-Path: <SRS0=FNOB=O5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15AC4C433F5
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:13:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C17D460FD7
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:13:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C17D460FD7
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 76BE24B0E6;
	Fri,  8 Oct 2021 22:13:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yX4kExJ0TaII; Fri,  8 Oct 2021 22:13:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CD1E4B11A;
	Fri,  8 Oct 2021 22:13:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E30D4B08E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:13:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EMeHwBT4BX6T for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Oct 2021 22:13:22 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A36264B121
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:13:21 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 x16-20020a25b910000000b005b6b7f2f91cso15203058ybj.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Oct 2021 19:13:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=iENfBAERukntPY2X5QGQTh9qzr8Td2a/eMmZN0gkPVI=;
 b=DzCx6d3mDseqABvdcGbaVVyn1eWP9DyM0ptlZC0Av6M11xsmwM4hDygp2I9SRsOTlD
 CaLslZ/5tpgFn7ZGK8Q+oAp/z+7Kry0ksTb1JHhzjTahq7Wh+o5eGwzQrJzYlowAOZ48
 VNCB+jXgqhl1lAdIBlzi52PfjMMWOIp8/GrzMp+AjpBgmC/UstMbkG/AsaR/Zi/J2Jar
 o4OtrA3m//aakuHjWV9VK3H1BLYWwyP3onVfEMCmc4KxgicKakfGDgJSztgcePWQk2I1
 bTHWhpYvVB73G/ZnG29ntm8kUxVEF6vAxFCPnskmCGo64vtpSvX8eFpV4pMmLiFClOgf
 jaMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=iENfBAERukntPY2X5QGQTh9qzr8Td2a/eMmZN0gkPVI=;
 b=EB1HNaWNzqwJ88samC86NnX88ZcFNgITbEFwqQEy0rusCRbX6xrtnyJh1mUYwEZ3Yg
 4vF4GmtzecCw6OOKfD7/ZRq1aeiFGwM0yhnG6pQaTIhklOC5piN71t5am0e84BypOKoJ
 J89x3xsfl9qM5pbCp1UdbawNboCWCInkgBC+RIkjdSoXmmti2wxWXYFR838kAuyWorn6
 XfPE0TdTuWniJZG9mMIiOFlX7Ma8nTusvXyCzoN7MJmZ86cqDk7gvARbCrlnX1OpHiTR
 KNhU+62JzqxJjYtZOy5dYRMhO+bNrWbJllhTn1iQLpgoNS74FJG4Ow8Od2cat13gmVXq
 dyuw==
X-Gm-Message-State: AOAM532AGQ5vuMQtjemcCrMzEnulCufREKzmyThQTW5og1XTGr3UVM1e
 McDQirXcYQxZ3yNQ4HG5XjiKtdoEKjY=
X-Google-Smtp-Source: ABdhPJzWNw6k/Tym0AlNYDL00dpB0fqVjcBxlLLKgA5wVnQqHXg+hyQOuiK3gpCLlIvGNpb1Xv6thLhfBP8=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:a25:bb93:: with SMTP id
 y19mr7661688ybg.266.1633745601224; 
 Fri, 08 Oct 2021 19:13:21 -0700 (PDT)
Date: Fri,  8 Oct 2021 19:12:09 -0700
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Message-Id: <20211009021236.4122790-17-seanjc@google.com>
Mime-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2 16/43] KVM: Don't redo ktime_get() when calculating
 halt-polling stop/deadline
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

Calculate the halt-polling "stop" time using "cur" instead of redoing
ktime_get().  In the happy case where hardware correctly predicts
do_halt_poll, "cur" is only a few cycles old.  And if the branch is
mispredicted, arguably that extra latency should count toward the
halt-polling time.

In all likelihood, the numbers involved are in the noise and either
approach is perfectly ok.

Reviewed-by: David Matlack <dmatlack@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a36ccdc93a72..481e8178b43d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3272,7 +3272,7 @@ void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
 
 	start = cur = poll_end = ktime_get();
 	if (do_halt_poll) {
-		ktime_t stop = ktime_add_ns(ktime_get(), vcpu->halt_poll_ns);
+		ktime_t stop = ktime_add_ns(cur, vcpu->halt_poll_ns);
 
 		do {
 			/*
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

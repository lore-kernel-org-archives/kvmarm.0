Return-Path: <SRS0=FNOB=O5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2736C433F5
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:13:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 57A4060F51
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:13:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 57A4060F51
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D20B4B166;
	Fri,  8 Oct 2021 22:13:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RRdyghGndIVV; Fri,  8 Oct 2021 22:13:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FF624B15E;
	Fri,  8 Oct 2021 22:13:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 35AA74B156
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:13:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vMh-L8V+Qkq5 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Oct 2021 22:13:34 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2E2124B0D7
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:13:34 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 b9-20020a5b07890000b0290558245b7eabso15004256ybq.10
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Oct 2021 19:13:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=pLGnZNeCj1eofs1Tna8HvgfHGGH+OqNXhSkcDhwkBIw=;
 b=VRo08TCu54WXCeWvaUHt/sk2e0vGE+t23O2jGFtKJrC8szlW29PyUVg9qa1gFeA7l/
 xEskdCWXRSlglDPxzwJpI+hnS34D4TzLDKLZZJDH+vXneZUjJrJ2p6jMQ4+6yNusBF7P
 6CJ8/rSwneH/NW0dEbzJkjR/ZnaiFW04wA6ydEJsYBVq9hwfsxkAk8UtewwAEpUXkOH2
 gElF5Vx854/uDHSVGxe/9WkMnKTFMH6pK6EPC77dq53/WUYVeZkuMvVYcngIplHzpqzD
 mk15NWKmGwkAbgPYO3UA0b2d7qx8J738ZHLocYz+9s5CV0wLJv0e5T4wx+Q9y63P5xIW
 pwMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=pLGnZNeCj1eofs1Tna8HvgfHGGH+OqNXhSkcDhwkBIw=;
 b=2LdkJGMhnIEpAGyuG13DIxk+YOxmphtgn6iPdRxK7EVTzcEXKV99khat8WHlL+YlcG
 gc2J8cmpXmelB8N/olAbtVd2ILoihhyrgWRfah181UjvI13idnR/iG4HPDwQwHS5Rm+p
 J+doJhJ5rAJl8kVuSAtDOsGUFf428g7We8reWXesNtWL39yRZO5vcShAVkQwj9e6lCXw
 nU0CIbIC2k6aPngpbvUKvaaC1RPKGC4ZNG+ZkutTtGo1dYX6CviBO2qRpAqQEa28bWsL
 mUZrFR/gLSrCbqMi+9tetEgRHEyi0BOp/kMfZ98YcWXi5d7VbEK9sizaSxUdKjASuPUa
 J15g==
X-Gm-Message-State: AOAM530hEMG9UZDyBNhq02QWz/dc+zItxh/mHlNFrNJQ/KOaXirLsRjk
 KFvPvCrx9K931Y8RzqU2xbwWRS/T0r4=
X-Google-Smtp-Source: ABdhPJz4iSAfPQRljp1PNlRsP2+bvwjiNJU4qxRXVZchtwSA9sdFFYFZ7ZvHA8l7ONDMJR0uzV+kR3cYKVg=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:a25:1b86:: with SMTP id
 b128mr7765690ybb.20.1633745613685; 
 Fri, 08 Oct 2021 19:13:33 -0700 (PDT)
Date: Fri,  8 Oct 2021 19:12:14 -0700
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Message-Id: <20211009021236.4122790-22-seanjc@google.com>
Mime-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2 21/43] KVM: VMX: Clean up PI pre/post-block WARNs
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

Move the WARN sanity checks out of the PI descriptor update loop so as
not to spam the kernel log if the condition is violated and the update
takes multiple attempts due to another writer.  This also eliminates a
few extra uops from the retry path.

Technically not checking every attempt could mean KVM will now fail to
WARN in a scenario that would have failed before, but any such failure
would be inherently racy as some other agent (CPU or device) would have
to concurrent modify the PI descriptor.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/posted_intr.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 351666c41bbc..67cbe6ab8f66 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -100,10 +100,11 @@ static void __pi_post_block(struct kvm_vcpu *vcpu)
 	struct pi_desc old, new;
 	unsigned int dest;
 
+	WARN(pi_desc->nv != POSTED_INTR_WAKEUP_VECTOR,
+	     "Wakeup handler not enabled while the vCPU was blocking");
+
 	do {
 		old.control = new.control = pi_desc->control;
-		WARN(old.nv != POSTED_INTR_WAKEUP_VECTOR,
-		     "Wakeup handler not enabled while the VCPU is blocked\n");
 
 		dest = cpu_physical_id(vcpu->cpu);
 
@@ -161,13 +162,12 @@ int pi_pre_block(struct kvm_vcpu *vcpu)
 		spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
 	}
 
+	WARN(pi_desc->sn == 1,
+	     "Posted Interrupt Suppress Notification set before blocking");
+
 	do {
 		old.control = new.control = pi_desc->control;
 
-		WARN((pi_desc->sn == 1),
-		     "Warning: SN field of posted-interrupts "
-		     "is set before blocking\n");
-
 		/*
 		 * Since vCPU can be preempted during this process,
 		 * vcpu->cpu could be different with pre_pcpu, we
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

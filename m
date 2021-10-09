Return-Path: <SRS0=FNOB=O5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF1F7C433FE
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:13:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9286760FD9
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:13:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9286760FD9
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 480FC4B168;
	Fri,  8 Oct 2021 22:13:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yAeb9MWLB6Wt; Fri,  8 Oct 2021 22:13:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F7084B18A;
	Fri,  8 Oct 2021 22:13:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E6B374B15D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:13:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fCcdQJssc0mk for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Oct 2021 22:13:37 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 67E254B154
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:13:36 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 b5-20020a251b05000000b005b575f23711so15170011ybb.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Oct 2021 19:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=SdOYPzkyfZrBWx1GJeur2Vwb7zEvl7JYNbVbQ0SB2Gg=;
 b=aUvGN/4AFgJcKIBF9LBWgDwhCHQZYEJ03JrconxIXHeAq0mSobvx5eFsN2IhEk7hMF
 07jWDFM9e+ezgnVy0PqTHsU8wjkF0Sq/uHjyc0w84aIFVqAcJRuuc8LQH3WxNpDQiA8J
 1gOwXo6k1Mjhlm2dzNYz4rr2omGOTIv9FMsD0TA3lqfU/1iEz7W8Tub84Aqukc87X1xM
 piXJImDfP3oyBzKVi6TuZiCoM21cARPSFti7XJOcRw2PuPbisGedjpLV+YL9vQi2purC
 N3om2H5mKJxeus7ZcbgIF+EPMNOHqwS7dYW8kbDAw9PWlIpsbYSk0g7cYENwS5oOjCiw
 mX3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=SdOYPzkyfZrBWx1GJeur2Vwb7zEvl7JYNbVbQ0SB2Gg=;
 b=iPvbg+U+ldagX0cbC1Wftq25Q4nqGkMcXRQ9J+mp3DNKg1VUg/ZOfxQJ0qfg6Zf1MO
 1gEl5iVc3CioqnsBfM3Wit4P1BcTBr6lABDDeamzsXAVw38qdr/cvJE2DD7o7D54EHer
 F4Q1VyLED5AVWD9smbbgvVjTn+pFcXYwggTcon+h2QPVCk5CC8psNnT6LrF+5+E2iZZI
 T4XOF0HdjXBRfMS6gr5pkg5lZV4/1tgNj6qnfRvf5/ergHvFVnku+byf1u2KMliZnGLW
 Tg4xS9CfTx8WpxKoa0GxTLPX+9kNNgEaUqz1gz3jTIvRgVb39up3mnGygm+w2G3Fo2Np
 N+Jg==
X-Gm-Message-State: AOAM530o3579qJFsdQPhm3O8koWCzz1onpmWzSQB8eazg+mH8r3hOyxh
 +xZFidLTIJ/71zumisxWqQ8Z3VFvSvk=
X-Google-Smtp-Source: ABdhPJxYoBKdyJNsrFu59iAPxlEnyIVO9cffUZpeFin68SfrlNt2dK+2hwMzncpFoR3FTBopTnOtfheDhwY=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:a25:6e06:: with SMTP id
 j6mr7636609ybc.311.1633745615988; 
 Fri, 08 Oct 2021 19:13:35 -0700 (PDT)
Date: Fri,  8 Oct 2021 19:12:15 -0700
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Message-Id: <20211009021236.4122790-23-seanjc@google.com>
Mime-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2 22/43] KVM: VMX: Drop unnecessary PI logic to handle
 impossible conditions
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

Drop sanity checks on the validity of the previous pCPU when handling
vCPU block/unlock for posted interrupts.  Barring a code bug or memory
corruption, the sanity checks will never fire, and any code bug that does
trip the WARN is all but guaranteed to completely break posted interrupts,
i.e. should never get anywhere near production.

This is the first of several steps toward eliminating kvm_vcpu.pre_cpu.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/posted_intr.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 67cbe6ab8f66..6c2110d91b06 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -118,12 +118,10 @@ static void __pi_post_block(struct kvm_vcpu *vcpu)
 	} while (cmpxchg64(&pi_desc->control, old.control,
 			   new.control) != old.control);
 
-	if (!WARN_ON_ONCE(vcpu->pre_pcpu == -1)) {
-		spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
-		list_del(&vcpu->blocked_vcpu_list);
-		spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
-		vcpu->pre_pcpu = -1;
-	}
+	spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
+	list_del(&vcpu->blocked_vcpu_list);
+	spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
+	vcpu->pre_pcpu = -1;
 }
 
 /*
@@ -153,14 +151,12 @@ int pi_pre_block(struct kvm_vcpu *vcpu)
 
 	WARN_ON(irqs_disabled());
 	local_irq_disable();
-	if (!WARN_ON_ONCE(vcpu->pre_pcpu != -1)) {
-		vcpu->pre_pcpu = vcpu->cpu;
-		spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
-		list_add_tail(&vcpu->blocked_vcpu_list,
-			      &per_cpu(blocked_vcpu_on_cpu,
-				       vcpu->pre_pcpu));
-		spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
-	}
+
+	vcpu->pre_pcpu = vcpu->cpu;
+	spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
+	list_add_tail(&vcpu->blocked_vcpu_list,
+		      &per_cpu(blocked_vcpu_on_cpu, vcpu->pre_pcpu));
+	spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
 
 	WARN(pi_desc->sn == 1,
 	     "Posted Interrupt Suppress Notification set before blocking");
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <SRS0=FNOB=O5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B59D0C433F5
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:13:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6C42260FD9
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:13:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6C42260FD9
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F7804B168;
	Fri,  8 Oct 2021 22:13:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UUTVmnrLV354; Fri,  8 Oct 2021 22:13:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C67554B16F;
	Fri,  8 Oct 2021 22:13:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FD314B190
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:13:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J0e0gyHm9jCq for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Oct 2021 22:13:47 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 67E7F4B11B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:13:46 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 s6-20020a254506000000b005b6b6434cd6so14971831yba.9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Oct 2021 19:13:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=va765MwNV8lkPK+fPa+/nQPV7Q6ICFe76wXLuhKBR7k=;
 b=B5oLyIOK5DCmxdgNe+Nl5/eUZ+1dZvr28zFbfb0yUmRDrQAn6gFu0meDWGbooWcwf+
 l+waGmWoLOHDfWujUlJgTIfXQBGxvJYpWrTevNrJNk5M8uz1livq3G0CbLqGnwGl0JPm
 sNTwBIZ8vWCCI3dUoTv7AkcFha93KYIamIUHSTRqHBmzceqRPtYmNYOCGYVyZvVn3Np/
 TL6ymtR5bZm6u0h37kbtwh2/3um/F6VSleLNBRjXkJxQwQ6Tl5usknG2mBtpFmrzjKYA
 RfxJYCWymoaofgRtrejK3tfUhsfLqLitFSkmp9z1zLeMTRzswrj10R8lRDFv/A07PTzr
 ihYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=va765MwNV8lkPK+fPa+/nQPV7Q6ICFe76wXLuhKBR7k=;
 b=HW0avurLET9MrGPKmowjiVcer15y/URUBPNUMK59haje0Dk/X2c/YpJ2uhuyzgw+M4
 sAtOOQ8Zqpy2hf1WLt78uJ6g/6acSeF4noLIz/q96vUVqKDscoAuSPPu3hrKTk9xljAF
 AT22iYFsME7OvZhnHnIa6mXNlY2gV6X6VpekmVSoUfZxxgkA3tgHNWQ7p1iJMCj+On2n
 vjGBPCJ/8KmfCCOJzahwKppBSf0BssY1R2MoC1hyAxAf7JdXGDo1G8wcobtzraGqcszS
 oOqrWUG4ArWDLCyjr8OzHRIuDCSaUt4Pc43UIf8g0E2z77zlxIq8wXkoOB+4vzow68jw
 WyLg==
X-Gm-Message-State: AOAM531UFIZOpOwMl0JKIu7qtVjDCABqApTN2C07f1epmdkp3uNWksff
 aU8XFo5VXAt2N5grcKSBt0jXxdRfEJk=
X-Google-Smtp-Source: ABdhPJxNwqY1vJaMvOgnvL3+QcSM5HrN4+PYEJxKTsdN858kzlppD8XZ0WLvzzYX6ErETJg0fQvQs2GFQ5w=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:a25:69c7:: with SMTP id
 e190mr6678164ybc.334.1633745625928; 
 Fri, 08 Oct 2021 19:13:45 -0700 (PDT)
Date: Fri,  8 Oct 2021 19:12:19 -0700
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Message-Id: <20211009021236.4122790-27-seanjc@google.com>
Mime-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2 26/43] KVM: VMX: Read Posted Interrupt "control" exactly
 once per loop iteration
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

Use READ_ONCE() when loading the posted interrupt descriptor control
field to ensure "old" and "new" have the same base value.  If the
compiler emits separate loads, and loads into "new" before "old", KVM
could theoretically drop the ON bit if it were set between the loads.

Fixes: 28b835d60fcc ("KVM: Update Posted-Interrupts Descriptor when vCPU is preempted")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/posted_intr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 414ea6972b5c..fea343dcc011 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -53,7 +53,7 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 
 	/* The full case.  */
 	do {
-		old.control = new.control = pi_desc->control;
+		old.control = new.control = READ_ONCE(pi_desc->control);
 
 		dest = cpu_physical_id(cpu);
 
@@ -104,7 +104,7 @@ static void __pi_post_block(struct kvm_vcpu *vcpu)
 	     "Wakeup handler not enabled while the vCPU was blocking");
 
 	do {
-		old.control = new.control = pi_desc->control;
+		old.control = new.control = READ_ONCE(pi_desc->control);
 
 		dest = cpu_physical_id(vcpu->cpu);
 
@@ -160,7 +160,7 @@ int pi_pre_block(struct kvm_vcpu *vcpu)
 	     "Posted Interrupt Suppress Notification set before blocking");
 
 	do {
-		old.control = new.control = pi_desc->control;
+		old.control = new.control = READ_ONCE(pi_desc->control);
 
 		/* set 'NV' to 'wakeup vector' */
 		new.nv = POSTED_INTR_WAKEUP_VECTOR;
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

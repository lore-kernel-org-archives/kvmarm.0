Return-Path: <SRS0=FNOB=O5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9AEBC433EF
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:14:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 72DCA60FD9
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:14:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 72DCA60FD9
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 27EBA4B17C;
	Fri,  8 Oct 2021 22:14:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Me337Lg623Bi; Fri,  8 Oct 2021 22:14:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 288744B099;
	Fri,  8 Oct 2021 22:14:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C48574B1DF
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:14:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wGExc9J4BZbe for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Oct 2021 22:14:28 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D2E514A534
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:14:27 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 s66-20020a252c45000000b005ba35261459so14460577ybs.7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Oct 2021 19:14:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=DNh7SHjv27CkTpVQ6UDQfpazfFfU/7m49a7OyCmxJ04=;
 b=OmBEyvgBxrWmm+DnEXtUY5SGJEDJ8rfSRexcZ/sLohcuuuU8wRBxtkVvWgAcEXTtDu
 CSHWkz3NrHAP8CQWDZPjwrNyXQv8t3ZVqtgnkJTeroV4I4ofTpUhF08tAgeFlhHpdjz5
 DSzs4995JQ4bvC8+hT2zhEZx03XMTSTWwaAlUhES+GMR0I/ltEGK03OtIT6xjHVnTBjL
 MK1iAMhumx1HDCHEN7Q0/UoppdBB6U1GwAdJ4EO2l1vq2DEjW94MHM8qR3/RmALo617b
 gz6KYIdYwOM9rgqP7AeVSQ/Il0lIODnMHAbfZnMNEpK7JCaMpNzkLfJZPqdAxx+LfqzC
 +uFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=DNh7SHjv27CkTpVQ6UDQfpazfFfU/7m49a7OyCmxJ04=;
 b=DLEtxOti9EkMzbcfTu0ZHibkihGr9U/hTjw9p0cdE1y3xglFc7rqNRXrkEBkoJ830f
 CGOvoGUM1JVLlQBWSmDKr4rJdhQO28mRcuTYZc2SgfMO8c9radRjcWKlEzyFk1KHv2hn
 vh0A+wjILBhtCdseLf3VB6K5m9xqWuhjP6mdigizKID+70GzF4L9YthOvsYjnbuX9ZTQ
 Ymqn0lWZQDZv1eKskNpu+DN9gZ0TwzQfGM6vEmztIuCR90dhS/LCW6rbbPcNNE9e1mRk
 77nyGq/d8kZ+MIqLFDTD+9XuLngIXDK57B93sBAc7ZNnRloJ5ks7q55IWzDEmyicMta6
 AdUw==
X-Gm-Message-State: AOAM533CujpsfeXcEqC4vpXKlAiTrh++J/LzE/HmyTquV+E7RxerEqKK
 z9chfWDvPI++W0mMK/6OXUjS/Zo+09o=
X-Google-Smtp-Source: ABdhPJwFBTWTsWfiioDi0mhoc4HC7I+aMeFu459xFpIEzn2YdCstAMDsfKMjJFSfY3skCf0Gp9GZ4fuQR4M=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:a25:77d6:: with SMTP id
 s205mr6993283ybc.529.1633745667357; 
 Fri, 08 Oct 2021 19:14:27 -0700 (PDT)
Date: Fri,  8 Oct 2021 19:12:36 -0700
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Message-Id: <20211009021236.4122790-44-seanjc@google.com>
Mime-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2 43/43] KVM: VMX: Don't do full kick when handling posted
 interrupt wakeup
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

When waking vCPUs in the posted interrupt wakeup handling, do exactly
that and no more.  There is no need to kick the vCPU as the wakeup
handler just need to get the vCPU task running, and if it's in the guest
then it's definitely running.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/posted_intr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index f1bcf8c32b6d..06eb9c950760 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -192,7 +192,7 @@ void pi_wakeup_handler(void)
 			    pi_wakeup_list) {
 
 		if (pi_test_on(&vmx->pi_desc))
-			kvm_vcpu_kick(&vmx->vcpu);
+			kvm_vcpu_wake_up(&vmx->vcpu);
 	}
 	spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, cpu));
 }
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

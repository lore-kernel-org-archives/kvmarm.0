Return-Path: <SRS0=Rd7Q=OP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E745EC433FE
	for <kvmarm@archiver.kernel.org>; Sat, 25 Sep 2021 00:56:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9F97361261
	for <kvmarm@archiver.kernel.org>; Sat, 25 Sep 2021 00:56:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9F97361261
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 537A94B13D;
	Fri, 24 Sep 2021 20:56:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TXd7pA1wYYhY; Fri, 24 Sep 2021 20:56:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CE454B15E;
	Fri, 24 Sep 2021 20:56:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 75D2B4B154
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 20:56:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c+h-m5f9S6Pn for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Sep 2021 20:55:59 -0400 (EDT)
Received: from mail-qt1-f201.google.com (mail-qt1-f201.google.com
 [209.85.160.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 632D04B0E2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 20:55:59 -0400 (EDT)
Received: by mail-qt1-f201.google.com with SMTP id
 b20-20020ac87fd4000000b002a69ee90efbso42020873qtk.11
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 17:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=AVRxITHRgpiea0PQRu71hObIdpCCXd1tddFTuoKEd5M=;
 b=AmZZR6+/WobaV3d/KTMW3XEm+/mJU1HTP/alrco2LxeX8sPbzL7l8R5VIEq9wXYyp7
 P31gfDlcRexYcYK12mPrGpQSHiwq1+7jjMKOfcgumO3thuYh7379U579a8VXzaHynz/c
 Q3KQVXVmXyM9LNzIQGRL46YsUVsNUTTA436JsJh3i+G14dKyyalUZ6UHTH5GdEZXjP9r
 IiNGv+ok9CwUCbLkrQ6KhkOVblpqSFVi+lqel510DljUqO6ykZ33BWRlVYKAV98E9Pb3
 w2kY0mdXtU63LGRjV1zY+2LpQRo0iJs3knGrr124qdmj7QQ2lJ+zuHgXzPFrmiw1XkSd
 zSxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=AVRxITHRgpiea0PQRu71hObIdpCCXd1tddFTuoKEd5M=;
 b=JvnGuYQtM+tcaH0FmFHY/DotK2jRwWXBQsExoRrMnYkfzFg4ECiNGIEbEFcPQqKhTG
 Q2PhXb2CMtMSHiDmnPCLUQD+7QcjVXIbebhxnb3y95l+mFhVKNaFG818vjEsLPBuikWB
 xBn9BNVMbyuM+pP1GHEKxu7jR3b6QJjKpfoTQfd6ixYBnNv+DeTkH8p6+IACSJfhrUpZ
 LNaKoF5AehFyS0hgKVFcV+zKbaCYd7NQuDN6EZImk0ICvrWOhKoAMXWusMNTznm0+GJR
 Ev9y/novcH4U1rQtZ0+DAhhO+Gu74sMq0zlQkoBtPCLQZ3vU23XY36aq3Vy4kefG/b1U
 ISBw==
X-Gm-Message-State: AOAM531n2c2Q2w9WblEHQiP0wzD8aW8brDdBbi2oFZNMSwpx5ZwkSh8U
 QhsaELtF6bEuEcvq+gl/yvyiFhBNhXU=
X-Google-Smtp-Source: ABdhPJxx8SkwYvYT9fuqd8J8/D25/GRV4ipTe+x7gxZbCgpsQNDucApI5+ArqZrudVFBp8cYqIvrEUF3+SY=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:4c72:89be:dba3:2bcb])
 (user=seanjc job=sendgmr) by 2002:a05:6214:4c9:: with SMTP id
 ck9mr13433509qvb.52.1632531359011; Fri, 24 Sep 2021 17:55:59 -0700 (PDT)
Date: Fri, 24 Sep 2021 17:55:27 -0700
In-Reply-To: <20210925005528.1145584-1-seanjc@google.com>
Message-Id: <20210925005528.1145584-14-seanjc@google.com>
Mime-Version: 1.0
References: <20210925005528.1145584-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH 13/14] KVM: x86: Directly block (instead of "halting")
 UNINITIALIZED vCPUs
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

Go directly to kvm_vcpu_block() when handling the case where userspace
attempts to run an UNINITIALIZED vCPU.  The vCPU isn't halted and its time
spent in limbo arguably should not be factored into halt-polling as the
behavior of the VM at this point is not at all indicative of the behavior
of the VM once it is up and running, i.e. executing HLT in idle tasks.

Note, because this case is encountered only on the first run of an AP vCPU,
vcpu->halt_poll_ns is guaranteed to be '0', and so KVM will not attempt
halt-polling, i.e. this really only affects the post-block bookkeeping.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0d71c73a61bb..b444f9315766 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10127,7 +10127,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 			r = -EINTR;
 			goto out;
 		}
-		kvm_vcpu_halt(vcpu);
+		kvm_vcpu_block(vcpu);
 		if (kvm_apic_accept_events(vcpu) < 0) {
 			r = 0;
 			goto out;
-- 
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

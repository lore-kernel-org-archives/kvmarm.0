Return-Path: <SRS0=Rd7Q=OP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F07BC433F5
	for <kvmarm@archiver.kernel.org>; Sat, 25 Sep 2021 00:55:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 24FC461265
	for <kvmarm@archiver.kernel.org>; Sat, 25 Sep 2021 00:55:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 24FC461265
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C13A54B133;
	Fri, 24 Sep 2021 20:55:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wFZvsJlOYl6c; Fri, 24 Sep 2021 20:55:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6131B4B152;
	Fri, 24 Sep 2021 20:55:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 63B2B4B12C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 20:55:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id r18mIgBipmxt for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Sep 2021 20:55:46 -0400 (EDT)
Received: from mail-qk1-f202.google.com (mail-qk1-f202.google.com
 [209.85.222.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 600624B136
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 20:55:46 -0400 (EDT)
Received: by mail-qk1-f202.google.com with SMTP id
 s18-20020a05620a255200b00433885d4fa7so44984737qko.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 17:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=wCDTOmCATHVhirkJj1e9UGRNdETjcfm809lLJpA1KZ0=;
 b=NqlSHtDJsZY9ynz1iazGvEiDMeqk04glWuzCtUdaZ74/+oO9rjnWS76Uh5TCi8grB+
 KwboA6njeSjTV+7uoE02X2FwYEkNPrLAm4qkXIZRVzJuxFafx32Mk5Xow/7WaARh1YAZ
 aC51w8eW6QKpvfDfIdD1udB75TJ4xUgQM915d2jcceUTh/hDb7mbGAiLnwAyqt0Y+WNF
 QpBy7FR47VOdDUwc186Fr9j28eODhANC/CUAjZvNZrR7fGsZs3zQzKM9xL4iXSTKlTtT
 +D4Y310QHpvHJHW02qI33BojoXY3YB8cjH1EF1eQmiciixtCRe97iPAZe1mITqWJtBmk
 YH1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=wCDTOmCATHVhirkJj1e9UGRNdETjcfm809lLJpA1KZ0=;
 b=uT4ZvQEPSufgarZjD75WsRp2OuJh6i7rrgFyBZAiK1zIhHSVCnLN5c14tFpDFCY4WZ
 VRfY8uR8W9Kn2ZMfIxUidugpoOXHaorFultPHzvjNSyBeAldsjOPgMAiqjshFbDZwPKm
 ZTWousmeiskb7OkuTCgUeg0pQWxW1FL2jdnQLD9VswEi98wdLuizrJhETxhZ2WRFay89
 hDnq9XG/fn73DSWliEDcD4fTijydKt9iIuI4Zuq5V1cTmJDXJCL0YDWM1QKOP697D2GE
 LQVQtDK3hduGY77QuHP6hN/bQm8PVat24Fi5VZv1MMr/X5kuW4367jZDR2XqdJuVV3LW
 a+JQ==
X-Gm-Message-State: AOAM533zzHwbCJ72KQ32pZeLOPYiqO1szVkqoq9pDEdYJxgYbhsZ5lOI
 T4YV8sZbqxrGBnVDIPpbvgl4TVC6dyA=
X-Google-Smtp-Source: ABdhPJwAe8cto2GGuy35+RfGF59+NomWHsqVgBAWIRGsvWVII07cOgInTsUOlV2E2ha1qSQ9QAXX81/NXqE=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:4c72:89be:dba3:2bcb])
 (user=seanjc job=sendgmr) by 2002:a05:6214:1046:: with SMTP id
 l6mr4932886qvr.6.1632531346015; Fri, 24 Sep 2021 17:55:46 -0700 (PDT)
Date: Fri, 24 Sep 2021 17:55:21 -0700
In-Reply-To: <20210925005528.1145584-1-seanjc@google.com>
Message-Id: <20210925005528.1145584-8-seanjc@google.com>
Mime-Version: 1.0
References: <20210925005528.1145584-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH 07/14] KVM: Don't block+unblock when halt-polling is successful
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

Invoke the arch hooks for block+unblock if and only if KVM actually
attempts to block the vCPU.  The only non-nop implementation is on arm64,
and if halt-polling is successful, there is no need for arm64 to put/load
the vGIC as KVM hasn't relinquished control of the vCPU in any way.

The primary motivation is to allow future cleanup to split out "block"
from "halt", but this is also likely a small performance boost on arm64
when halt-polling is successful.

Adjust the post-block path to update "cur" after unblocking, i.e. include
vGIC load time in halt_wait_ns and halt_wait_hist, so that the behavior
is consistent.  Moving just the pre-block arch hook would result in only
the vGIC put latency being included in the halt_wait stats.  There is no
obvious evidence that one way or the other is correct, so just ensure KVM
is consistent.

Cc: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2015a1f532ce..f96cda8312f3 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3232,8 +3232,6 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	bool waited = false;
 	u64 block_ns;
 
-	kvm_arch_vcpu_blocking(vcpu);
-
 	start = cur = poll_end = ktime_get();
 	if (do_halt_poll) {
 		ktime_t stop = ktime_add_ns(ktime_get(), vcpu->halt_poll_ns);
@@ -3250,6 +3248,7 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 		} while (kvm_vcpu_can_poll(cur, stop));
 	}
 
+	kvm_arch_vcpu_blocking(vcpu);
 
 	prepare_to_rcuwait(&vcpu->wait);
 	for (;;) {
@@ -3262,6 +3261,9 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 		schedule();
 	}
 	finish_rcuwait(&vcpu->wait);
+
+	kvm_arch_vcpu_unblocking(vcpu);
+
 	cur = ktime_get();
 	if (waited) {
 		vcpu->stat.generic.halt_wait_ns +=
@@ -3269,8 +3271,8 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.generic.halt_wait_hist,
 				ktime_to_ns(cur) - ktime_to_ns(poll_end));
 	}
+
 out:
-	kvm_arch_vcpu_unblocking(vcpu);
 	block_ns = ktime_to_ns(cur) - ktime_to_ns(start);
 
 	/*
-- 
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

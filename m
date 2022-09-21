Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF40DC6FA8E
	for <kvmarm@archiver.kernel.org>; Wed, 21 Sep 2022 00:33:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F1B94B7F7;
	Tue, 20 Sep 2022 20:33:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Lvd8xcuoaLP2; Tue, 20 Sep 2022 20:33:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 820994B808;
	Tue, 20 Sep 2022 20:32:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 73EB94B782
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 20:32:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Q3stBQx6-8d3 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2022 20:32:57 -0400 (EDT)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E01D44B0AC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 20:32:56 -0400 (EDT)
Received: by mail-pg1-f201.google.com with SMTP id
 h19-20020a63e153000000b00434dfee8dbaso2516095pgk.18
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 17:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc:subject:date;
 bh=efA5iJVbRrRgyy7qejkmxwve22ULxnh+arH50++PU/o=;
 b=LKQ43lhsEV6qkmBZlofrSrdl8EJ6mizwyIEMQYN4yuGNXkQj4E20I0hn2n1os/W8rc
 FBABKu95Qjg91h2stXYOQw+qADMR7XZ6aWiaoE4AtE31UgVml4CNZ7U+iemEDcQM7Qu4
 t9Z+X0wLCYzA/PywBX4R2TbwY4IqErPsq7pWjccSbHgqlIcJodfmwDsORX1S0hnpHOqL
 beWZAka2S0YLzR5F93gSfrPtpqFy0vHNPuMIF2SvlDmkv6DmDFSXlrSQYeY1mlT0WWNb
 xuXG79A1mSLbxXjRXjfR/KkQ6hWyNCiYg0/oAhyTPT5fIKU53548mJXGWrhfghBolN1K
 JXJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
 bh=efA5iJVbRrRgyy7qejkmxwve22ULxnh+arH50++PU/o=;
 b=PwvWspvXsbruiPAPtSirvZettxGa41EA0wEr+Zm/4V+WxTta6ZLUnQFhcRbX/Glbcf
 avlKWcFglegAkZtuGpMJLdzpCnieuXZYyJ6PAlof/19fUI1c1QLtinsS3riOR+o1M/2Y
 oKzbM5bK2NqQVjBzSrW5ULJLKkzklKAz02gzsCYfgpePqsPENaiINR/h3e3ALK/1UIbw
 7CMaHMz57kLKdlG3xzs/gR6X6ABXsm3X4Arq/XRCn6VNTt7WkaLp/7e74uJE1Su3We/7
 GxwUk9ngzMzJoeowgyKZp56uiT9vkYz4nf6nN5lgciFJ7q7OAVuEUuCjYFyx6E8lfNS+
 eMew==
X-Gm-Message-State: ACrzQf1tixgLrLfUB52bpvVjUbQBPSoAQWp6M/bEg6qr6kqAV0pSDsru
 3IWTQ3Qg7/YkqmBkzNUnELGPJfVTixc=
X-Google-Smtp-Source: AMsMyM4y6HKockrgOW/pRtDhYoSBz/Hgk7Jbboq2yxWPlcCYVwqDxT8mse4oLg7p1D+UQZFuX9F/d/ndT2k=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:be03:b0:178:6f5d:e979 with SMTP id
 r3-20020a170902be0300b001786f5de979mr2126922pls.163.1663720376093; Tue, 20
 Sep 2022 17:32:56 -0700 (PDT)
Date: Wed, 21 Sep 2022 00:31:54 +0000
In-Reply-To: <20220921003201.1441511-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220921003201.1441511-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220921003201.1441511-6-seanjc@google.com>
Subject: [PATCH v4 05/12] KVM: x86: lapic does not have to process INIT if it
 is blocked
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
 Huacai Chen <chenhuacai@kernel.org>, 
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Anup Patel <anup@brainfault.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 linuxppc-dev@lists.ozlabs.org, linux-mips@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Atish Patra <atishp@atishpatra.org>, linux-riscv@lists.infradead.org,
 Maxim Levitsky <mlevitsk@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

From: Paolo Bonzini <pbonzini@redhat.com>

Do not return true from kvm_vcpu_has_events() if the vCPU isn' going to
immediately process a pending INIT/SIPI.  INIT/SIPI shouldn't be treated
as wake events if they are blocked.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[sean: rebase onto refactored INIT/SIPI helpers, massage changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 16a24dd28f26..dcc675d4e44b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12765,7 +12765,8 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
 	if (!list_empty_careful(&vcpu->async_pf.done))
 		return true;
 
-	if (kvm_apic_has_pending_init_or_sipi(vcpu))
+	if (kvm_apic_has_pending_init_or_sipi(vcpu) &&
+	    kvm_apic_init_sipi_allowed(vcpu))
 		return true;
 
 	if (vcpu->arch.pv.pv_unhalted)
-- 
2.37.3.968.ga6b4b080e4-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

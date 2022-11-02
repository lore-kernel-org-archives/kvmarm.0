Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7C06C433FE
	for <kvmarm@archiver.kernel.org>; Wed,  2 Nov 2022 23:19:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 789E54B7CE;
	Wed,  2 Nov 2022 19:19:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MI9qzMhk3tOF; Wed,  2 Nov 2022 19:19:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D8EA4B750;
	Wed,  2 Nov 2022 19:19:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 528224B7FA
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2022 19:19:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lcwRSoN4LmWE for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Nov 2022 19:19:28 -0400 (EDT)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 098BA4B7D2
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2022 19:19:27 -0400 (EDT)
Received: by mail-pl1-f201.google.com with SMTP id
 o2-20020a170903210200b001872421f5b9so225273ple.11
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Nov 2022 16:19:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
 bh=2jZZfFf52GmkjzF4UkJBFUQx8TRwCaNEoxRzKdccz/c=;
 b=eS+ADSAUDBr+3HDHnDb3Fr9sF+Jb8/UT2oH309j3Rm/86ObG6TRCn9IyhpjUkKBdpE
 kcCNHyv3vwGiHYQRvOqDpsz+Ka9M2XEJCdBD1BDMQE+yHelvK5eIZBtBOFMFVOay6VLL
 HRD1UaccDMN8QRmrJzaFGA2kakGK5P4xJGBM94BuLtDJAAqDK7hBLTZ7oOdfic4lXqK4
 Fr39ZfZInLrcHKiM8fxmsZrdE64FtenP1A0FKcDrTDJZkpQ1QUJo1/Y5EttLt8eZYz9U
 +9QTVq6+Q+Y4pZ8EkuhDPhDFtAlj3OJomhnuiK5WjSAlU9kpBh9BdzMjPScyheuXuiwK
 D0tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=2jZZfFf52GmkjzF4UkJBFUQx8TRwCaNEoxRzKdccz/c=;
 b=6t85eORERh4wYATU++JJJku7kjsPyGDqF+fjgAo6rX4q3fgpw22mvrQMpMG+poLHJL
 ZPlIqfFKMQrW8iJMhvoM3q5CrxeRnp0DOIltGnYHhrK0TN0bq70ztC3uMypHTOJIA+ga
 wueymQntq0HKXK8uFcPkD/SqGRxWjMKOFjXaDixNXiL4uR+GYRvx8s8RQ1izkmXpLBag
 yhcq9uK9LzAz3wKvF9ASkyj4ZjnLAJSWfIswRPGUxSCe31wxdSch+G0GW35mgJ0romFi
 LKQRJrQN0elr9zLZZLpIYYj4sE1iWpnyTgr9UBihNzt6tBTMQsEniwQhP+XrMgM+NfgN
 4IsQ==
X-Gm-Message-State: ACrzQf3kC6y02IcBZ6WMR5TgpwYlLSKxustKr7y+Fo1llMNq4xP3y1PD
 5vAN7+3fm3bl59yIpk5sVSPGpkcUFpI=
X-Google-Smtp-Source: AMsMyM6vYYJQBYlQiDcX1wj97hZ9g1pk+rDBzdLxVoyiEkvTNhgYg+UmvFixquw/EG51V/dsQ+i+Sr9IedQ=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:e7c5:b0:213:b7d8:1c4c with SMTP id
 kb5-20020a17090ae7c500b00213b7d81c4cmr25473196pjb.114.1667431166266; Wed, 02
 Nov 2022 16:19:26 -0700 (PDT)
Date: Wed,  2 Nov 2022 23:18:34 +0000
In-Reply-To: <20221102231911.3107438-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221102231911.3107438-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102231911.3107438-8-seanjc@google.com>
Subject: [PATCH 07/44] KVM: x86: Do timer initialization after XCR0
 configuration
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
 Matthew Rosato <mjrosato@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>, 
 Sean Christopherson <seanjc@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Atish Patra <atishp@atishpatra.org>, linux-kernel@vger.kernel.org,
 linux-riscv@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 linux-s390@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
 Chao Gao <chao.gao@intel.com>, Yuan Yao <yuan.yao@intel.com>,
 kvmarm@lists.linux.dev, Thomas Gleixner <tglx@linutronix.de>,
 linux-arm-kernel@lists.infradead.org,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 Fabiano Rosas <farosas@linux.ibm.com>, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linuxppc-dev@lists.ozlabs.org
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

Move kvm_arch_init()'s call to kvm_timer_init() down a few lines below
the XCR0 configuration code.  A future patch will move hardware setup
into kvm_arch_init() and slot in vendor hardware setup before the call
to kvm_timer_init() so that timer initialization (among other stuff)
doesn't need to be unwound if vendor setup fails.  XCR0 setup on the
other hand needs to happen before vendor hardware setup.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cd9eb13e2ed7..9a7702b1c563 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9320,13 +9320,13 @@ int kvm_arch_init(void *opaque)
 	if (r)
 		goto out_free_percpu;
 
-	kvm_timer_init();
-
 	if (boot_cpu_has(X86_FEATURE_XSAVE)) {
 		host_xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
 		kvm_caps.supported_xcr0 = host_xcr0 & KVM_SUPPORTED_XCR0;
 	}
 
+	kvm_timer_init();
+
 	if (pi_inject_timer == -1)
 		pi_inject_timer = housekeeping_enabled(HK_TYPE_TIMER);
 #ifdef CONFIG_X86_64
-- 
2.38.1.431.g37b22c650d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

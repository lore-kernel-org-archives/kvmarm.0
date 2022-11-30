Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB0C3C4321E
	for <kvmarm@archiver.kernel.org>; Wed, 30 Nov 2022 23:10:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FD0D4B256;
	Wed, 30 Nov 2022 18:10:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fMGvlZ3cHrnu; Wed, 30 Nov 2022 18:10:21 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 94EDD4B269;
	Wed, 30 Nov 2022 18:10:18 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DCA7A4B372
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 18:10:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0p2o5R1MMcWe for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Nov 2022 18:10:14 -0500 (EST)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 225A64B5F5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 18:10:11 -0500 (EST)
Received: by mail-pl1-f202.google.com with SMTP id
 u6-20020a170903124600b00188cd4769bcso18980697plh.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 15:10:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
 bh=3q8g1I3CG/zN/S6yfEuz3UEYEnVKGNtIkvlUCCz4wMk=;
 b=IzqZX1vpqBRD6eqp/m2lCIonVBr9d0e0dYh+rnORdsBouvRr/LJHoAVFCGYwduLpYW
 OTMMo4gprlzO/u6ojuhJyOc3wk8iW8vMqSUKMIfurZ/dESMUEks0XD0dELDo/XLaovGl
 EKo5NrbtnviyIeCdpV2+U1bLcQY9lYskXKPUNJWsxtd+ecYNZC7sEQkVg+anA/T0XgVe
 YvNoKh5i6BiC33HYuQOVTGAT9N1QTpRLVSSatOGlZCfv03s8ZzOwEte840f58eQcGUDe
 h1+xBUE24TMAZ61kNCycVQsK/JxxPJO1UMM34/IR0XeCfuqHb2uwlievzCRoo9MRdbjv
 0jwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=3q8g1I3CG/zN/S6yfEuz3UEYEnVKGNtIkvlUCCz4wMk=;
 b=2/jottLTHnhCNFqA2ofPR/rXvIOZdAK3wp1nShVsQSBdxwx+1B0QuLV2v4rG40Q6Y9
 uTyCAom+qgT/iSiuvg55OxWEhiux/SEdRgY+1zKY4CBRVcBG8CfjZUnPD/oDtcMo46A8
 FHHDkBk0sVABY6lrnykDlQ6TlIVXvjCU6tLI3TgPg4tt7xDYVOHpq/7HOSW7/lLE/xk5
 x6sE5/T0TFDt0YDiSbRDtIKQyUwZAzzjk/ZxR9PNg16woOvnkwvCv1YE36gvzqdmFdCy
 DS4J3b5aW9lS9mV3nDOwWKu2sX1wWTF62TzRMhZHgqwOWzd63JV9nC2P68JQ2RuQSpas
 d4Kg==
X-Gm-Message-State: ANoB5pnu3rX4u8kzD77ke60nW4tuhCob/z+3Sixl6YS02hVfdTINro2q
 NGO9ePy2YtApx/dYvQa9NlDQrvPJdr0=
X-Google-Smtp-Source: AA0mqf4/tiOg+xYgcsoY9u5fwhXNPg1RVdsGA6s6X0UqfvBtJFvF15IrbdNSIgjSxdrgTr0k96rlZxXDdGM=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:8bc1:0:b0:575:bfb9:b1fa with SMTP id
 s1-20020aa78bc1000000b00575bfb9b1famr7674415pfd.62.1669849810052; Wed, 30 Nov
 2022 15:10:10 -0800 (PST)
Date: Wed, 30 Nov 2022 23:09:03 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-20-seanjc@google.com>
Subject: [PATCH v2 19/50] KVM: arm64: Do arm/arch initialization without
 bouncing through kvm_init()
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
 Sean Christopherson <seanjc@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Cc: kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Atish Patra <atishp@atishpatra.org>, linux-kernel@vger.kernel.org,
 Kai Huang <kai.huang@intel.com>, linux-riscv@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, linux-s390@vger.kernel.org,
 Michael Ellerman <mpe@ellerman.id.au>, Chao Gao <chao.gao@intel.com>,
 Yuan Yao <yuan.yao@intel.com>, kvmarm@lists.linux.dev,
 Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Fabiano Rosas <farosas@linux.ibm.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org
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

Do arm/arch specific initialization directly in arm's module_init(), now
called kvm_arm_init(), instead of bouncing through kvm_init() to reach
kvm_arch_init().  Invoking kvm_arch_init() is the very first action
performed by kvm_init(), so from a initialization perspective this is a
glorified nop.

Avoiding kvm_arch_init() also fixes a mostly benign bug as kvm_arch_exit()
doesn't properly unwind if a later stage of kvm_init() fails.  While the
soon-to-be-deleted comment about compiling as a module being unsupported
is correct, kvm_arch_exit() can still be called by kvm_init() if any step
after the call to kvm_arch_init() succeeds.

Add a FIXME to call out that pKVM initialization isn't unwound if
kvm_init() fails, which is a pre-existing problem inherited from
kvm_arch_exit().

Making kvm_arch_init() a nop will also allow dropping kvm_arch_init() and
kvm_arch_exit() entirely once all other architectures follow suit.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/arm.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e6f6fcfe6bcc..d3a4db1abf32 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2195,7 +2195,7 @@ void kvm_arch_irq_bypass_start(struct irq_bypass_consumer *cons)
 /**
  * Initialize Hyp-mode and memory mappings on all CPUs.
  */
-int kvm_arch_init(void *opaque)
+int kvm_arm_init(void)
 {
 	int err;
 	bool in_hyp_mode;
@@ -2269,6 +2269,14 @@ int kvm_arch_init(void *opaque)
 		kvm_info("Hyp mode initialized successfully\n");
 	}
 
+	/*
+	 * FIXME: Do something reasonable if kvm_init() fails after pKVM
+	 * hypervisor protection is finalized.
+	 */
+	err = kvm_init(NULL, sizeof(struct kvm_vcpu), 0, THIS_MODULE);
+	if (err)
+		goto out_subs;
+
 	return 0;
 
 out_subs:
@@ -2281,10 +2289,15 @@ int kvm_arch_init(void *opaque)
 	return err;
 }
 
+int kvm_arch_init(void *opaque)
+{
+	return 0;
+}
+
 /* NOP: Compiling as a module not supported */
 void kvm_arch_exit(void)
 {
-	kvm_unregister_perf_callbacks();
+
 }
 
 static int __init early_kvm_mode_cfg(char *arg)
@@ -2325,10 +2338,4 @@ enum kvm_mode kvm_get_mode(void)
 	return kvm_mode;
 }
 
-static int arm_init(void)
-{
-	int rc = kvm_init(NULL, sizeof(struct kvm_vcpu), 0, THIS_MODULE);
-	return rc;
-}
-
-module_init(arm_init);
+module_init(kvm_arm_init);
-- 
2.38.1.584.g0f3c55d4c2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

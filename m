Return-Path: <SRS0=rfx0=HZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B05E8C433E0
	for <kvmarm@archiver.kernel.org>; Tue, 23 Feb 2021 15:58:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 24B8F64E20
	for <kvmarm@archiver.kernel.org>; Tue, 23 Feb 2021 15:58:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 24B8F64E20
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD0674B1E6;
	Tue, 23 Feb 2021 10:58:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nXHgzd1QRRIQ; Tue, 23 Feb 2021 10:58:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A2C044B1EF;
	Tue, 23 Feb 2021 10:58:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 54D964B1E7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Feb 2021 10:58:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uKsOjglVychr for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Feb 2021 10:58:10 -0500 (EST)
Received: from mail-qt1-f202.google.com (mail-qt1-f202.google.com
 [209.85.160.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5507D4B1C0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Feb 2021 10:58:10 -0500 (EST)
Received: by mail-qt1-f202.google.com with SMTP id z3so10315701qtv.20
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Feb 2021 07:58:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=Yq3UF/O6ghf1oapvxUJWBbk4uV2Kh5VLtR3aNkbqwLU=;
 b=gpmDUt1OHWLR5BJcB5vOUDieK/iuS3jdCYC/3Qqk1Uz7Vs2ER8YjQZNbRMmIKQo9+L
 clTMbUAasQIAG+/2wwlNsQFJ02PnBMqvIi6KHCGECAuGcjJ0oI2y9NG0+dkHVuJ5BKS4
 Kj6fuXxVv9YctZ65M/d5X7k/HrVi8qZpi5B8Rf2pmkWcerPU6Rxm8MqW+5dFXgoOk4gX
 XgdQ8ljGq5Ba9c/DWmc7qO/yMOLJieMU6kawxoFxG/XrxdhzMKdE8PZ/7YSiwNLSffpL
 MZx6qeh80KI6yVYxeCjr51Bucj3amveXOATtQzkmRDBdMrD4Gr8Opbew4gilcJJ3m9u1
 ei4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Yq3UF/O6ghf1oapvxUJWBbk4uV2Kh5VLtR3aNkbqwLU=;
 b=Fa7kQmawbqalqPE5gJv2J91HbQFDeOqfRZ/4VndVmsW511krlmkzqoy88cPB1cWzFu
 MiX/HD34/+xz57WX5g8Qe5C+JY/epHcKNCH+1B2ubdls6aOf3b3WxFJdn3xGE+VTeAxS
 qZiYdcGSWKim24pqx6fN7lnvegsnWg9EhP8zGIGOPeq/HmoIHjxGO8wcdGva1iMakTcq
 4m9MQBpg9GAeTWYb9xYuBfu6o4b8KCYKSlxIQRudENHDnw7rhJt+RjC25TQ9bgt8azCW
 zQ4iaOlS9PQpvVhlV1hM1Tnbdn3jcgJOwQqluLdZB8Yh0spozdrH9dltZUowItZ6ZZcW
 aLIw==
X-Gm-Message-State: AOAM531cwfI+UIW3Duib1d0/2s1tIPlXfrblrd5jP9Dee82agpBA5gN1
 hHu8BhgXxmkujTLh9SmozOPL3wihryIeOqrVIKse6O6wIpaEOX9odlLqUz4p7bu/IRipuW8MCkm
 3/edx93Z+KhuasbgOgIZt41mh/Cu2UW07ejPEpIu8OKI2pcdAFHNp5hptpiiPh1aed7D4pg==
X-Google-Smtp-Source: ABdhPJxaNChA01qsecoe418jaw7NU2vcfrgh9tBh+/Qt5CHyN7goXPTTmu8BVzVBgR13/Jvc45rDTHpubSw=
X-Received: from ascull.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1510])
 (user=ascull job=sendgmr) by 2002:ad4:48c3:: with SMTP id
 v3mr22683374qvx.51.1614095889872; 
 Tue, 23 Feb 2021 07:58:09 -0800 (PST)
Date: Tue, 23 Feb 2021 15:57:58 +0000
In-Reply-To: <20210223155759.3495252-1-ascull@google.com>
Message-Id: <20210223155759.3495252-4-ascull@google.com>
Mime-Version: 1.0
References: <20210223155759.3495252-1-ascull@google.com>
X-Mailer: git-send-email 2.30.0.617.g56c4b15f3c-goog
Subject: [PATCH v2 3/4] KVM: arm64: Use BUG and BUG_ON in nVHE hyp
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, maz@kernel.org, linux-kernel@vger.kernel.org,
 catalin.marinas@arm.com, will@kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
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

hyp_panic() reports the address of the panic by using ELR_EL2, but this
isn't a useful address when hyp_panic() is called directly. Replace such
direct calls with BUG() and BUG_ON() which use BRK to trigger and
exception that then goes to hyp_panic() with the correct address. Also
remove the hyp_panic() declaration from the header file to avoid
accidental misuse.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/include/asm/kvm_hyp.h   | 1 -
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-smp.c  | 6 ++----
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index fb8404fefd1f..746eb9a2891b 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -95,7 +95,6 @@ u64 __guest_enter(struct kvm_vcpu *vcpu);
 
 bool kvm_host_psci_handler(struct kvm_cpu_context *host_ctxt);
 
-void __noreturn hyp_panic(void);
 #ifdef __KVM_NVHE_HYPERVISOR__
 void __noreturn __hyp_do_panic(struct kvm_cpu_context *host_ctxt, u64 spsr,
 			       u64 elr, u64 par);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index a906f9e2ff34..9f37a4240562 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -181,6 +181,6 @@ void handle_trap(struct kvm_cpu_context *host_ctxt)
 		handle_host_smc(host_ctxt);
 		break;
 	default:
-		hyp_panic();
+		BUG();
 	}
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-smp.c b/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
index 2997aa156d8e..4495aed04240 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
@@ -18,8 +18,7 @@ u64 __ro_after_init hyp_cpu_logical_map[NR_CPUS] = { [0 ... NR_CPUS-1] = INVALID
 
 u64 cpu_logical_map(unsigned int cpu)
 {
-	if (cpu >= ARRAY_SIZE(hyp_cpu_logical_map))
-		hyp_panic();
+	BUG_ON(cpu >= ARRAY_SIZE(hyp_cpu_logical_map));
 
 	return hyp_cpu_logical_map[cpu];
 }
@@ -30,8 +29,7 @@ unsigned long __hyp_per_cpu_offset(unsigned int cpu)
 	unsigned long this_cpu_base;
 	unsigned long elf_base;
 
-	if (cpu >= ARRAY_SIZE(kvm_arm_hyp_percpu_base))
-		hyp_panic();
+	BUG_ON(cpu >= ARRAY_SIZE(kvm_arm_hyp_percpu_base));
 
 	cpu_base_array = (unsigned long *)hyp_symbol_addr(kvm_arm_hyp_percpu_base);
 	this_cpu_base = kern_hyp_va(cpu_base_array[cpu]);
-- 
2.30.0.617.g56c4b15f3c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

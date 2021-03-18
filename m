Return-Path: <SRS0=/u//=IQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C628C433DB
	for <kvmarm@archiver.kernel.org>; Thu, 18 Mar 2021 14:33:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F242D64F30
	for <kvmarm@archiver.kernel.org>; Thu, 18 Mar 2021 14:33:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F242D64F30
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A60F74B72A;
	Thu, 18 Mar 2021 10:33:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id do-bXRocXv7e; Thu, 18 Mar 2021 10:33:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 78FE24B759;
	Thu, 18 Mar 2021 10:33:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 831094B74F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Mar 2021 10:33:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uW7BvCvGelZi for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Mar 2021 10:33:24 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6B5214B759
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Mar 2021 10:33:24 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id 9so4633598wrb.16
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Mar 2021 07:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=l32SnQQP2LFUEI9G5lNC10EbyLkwFo/iwnd3a9OFpx4=;
 b=TBngADY0fST4UjBOe1/GZf6BUqJqhlWT90sKTviH528u+OVEvK58gM+kk2AxWWPkQj
 cUViKWFkVyU7Jj62d6nJyyYxngQ6JUzqM8Q+qSbmGptVLw5THOMX7D/xq57msHy0iCIU
 ybAcnFo2JW/OnUdHfrb3os6nqPVBmm4ZqnvuiEMXIh8kGHbqOJs1y/RrVuuxfkiVwU1e
 smFlx6KLb019kQnfkZo6XvvBAdVsxO3j4hSb6ZpqLqbvzi/xzRhfM5ixGiCXRbImqQIv
 RIJWIVigLqNR0JOZSjER4x6IY6U/Ir/RtJq6ssxLrKMqFYSsXhpGtf6kiupkVioIdJci
 aziw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=l32SnQQP2LFUEI9G5lNC10EbyLkwFo/iwnd3a9OFpx4=;
 b=dbZfJh78Kk+klVbfi5Ekgw0SUtBrzQ1IzZlxl6llnO9P6NPET9zI6H61uWiT6r2NQq
 9Ri87Xh6Pv+/t2JeOVomp/nLuhJVpMmzk7zn7E2iQi2IPtdJBKmAyP5edNU3YtSeB9te
 S8h0mdOMFaSnn4c61x15HpzSirTBOLEmhkjfhsgzkrjE9YT1hUyn3DLw/nC9+dGKtA8v
 ER2LOwmx8eJDhWwr/5pKBKqRcLLYP4hPta2arltLMk/Y8oQ9Im3oSMdOZq74FnV3jJUu
 c6KkGupFh0azLUhs0yggj4qvxeLYDhkqg3BA+9bCbGmyd+k+wot6TQguvNS/jlZZl20U
 +QpQ==
X-Gm-Message-State: AOAM533QK2rsCvIF8vuSMcIi/nIcZF4DA/t9gjDEYKsHV5bkrBMteSM9
 hYNLjLJS2XI7eMp/bw12qsfrMse0CV4uwiem+B26OIt0Ur1M/QiQbh4DPuP1jDxxCGV8XGiEQeT
 EqSeFIp+LbE+eKpMkQzf4v2gJ30YYLAHTvbKsavW25SbDWwYwjWirJ2ym9Nd/sQv7zdKZhw==
X-Google-Smtp-Source: ABdhPJzTkYsRRG5Hx2J+bhJwZVCO9DwF+yJwREcoMUZ2/RV4OcuQ+A0aO6RztHKzHOunfiTyjw4OVuB27B4=
X-Received: from ascull.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1510])
 (user=ascull job=sendgmr) by 2002:adf:f411:: with SMTP id
 g17mr9818163wro.22.1616078003567; 
 Thu, 18 Mar 2021 07:33:23 -0700 (PDT)
Date: Thu, 18 Mar 2021 14:33:10 +0000
In-Reply-To: <20210318143311.839894-1-ascull@google.com>
Message-Id: <20210318143311.839894-5-ascull@google.com>
Mime-Version: 1.0
References: <20210318143311.839894-1-ascull@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v3 4/5] KVM: arm64: Use BUG and BUG_ON in nVHE hyp
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, maz@kernel.org, catalin.marinas@arm.com,
 will@kernel.org
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
direct calls with BUG() and BUG_ON() which use BRK to trigger an
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
index 32ae676236b6..fe5fc814f228 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -100,7 +100,6 @@ u64 __guest_enter(struct kvm_vcpu *vcpu);
 
 bool kvm_host_psci_handler(struct kvm_cpu_context *host_ctxt);
 
-void __noreturn hyp_panic(void);
 #ifdef __KVM_NVHE_HYPERVISOR__
 void __noreturn __hyp_do_panic(struct kvm_cpu_context *host_ctxt, u64 spsr,
 			       u64 elr, u64 par);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 936328207bde..821a69601dd9 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -178,6 +178,6 @@ void handle_trap(struct kvm_cpu_context *host_ctxt)
 		handle_host_smc(host_ctxt);
 		break;
 	default:
-		hyp_panic();
+		BUG();
 	}
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-smp.c b/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
index 879559057dee..9f54833af400 100644
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
 
 	cpu_base_array = (unsigned long *)&kvm_arm_hyp_percpu_base;
 	this_cpu_base = kern_hyp_va(cpu_base_array[cpu]);
-- 
2.31.0.rc2.261.g7f71774620-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

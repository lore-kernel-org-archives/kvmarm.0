Return-Path: <SRS0=rfx0=HZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CF6DC433E0
	for <kvmarm@archiver.kernel.org>; Tue, 23 Feb 2021 09:49:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1EDCD64E60
	for <kvmarm@archiver.kernel.org>; Tue, 23 Feb 2021 09:49:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1EDCD64E60
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B2B244B1F1;
	Tue, 23 Feb 2021 04:49:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 97FDPy-WQD7i; Tue, 23 Feb 2021 04:49:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A4D014B1EC;
	Tue, 23 Feb 2021 04:49:39 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B9A04B1D5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Feb 2021 04:49:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4eCVkOwEfoqX for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Feb 2021 04:49:37 -0500 (EST)
Received: from mail-qt1-f201.google.com (mail-qt1-f201.google.com
 [209.85.160.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 500DB4B0D6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Feb 2021 04:49:37 -0500 (EST)
Received: by mail-qt1-f201.google.com with SMTP id t5so9624346qti.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Feb 2021 01:49:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=Yq3UF/O6ghf1oapvxUJWBbk4uV2Kh5VLtR3aNkbqwLU=;
 b=hD9Jlj9YF1o/WCGyN5vUtU9153ZnKrb5uyJTMxKBsfPOU1xLSLrjoxnN5JMm1+CpMv
 f4otmBn6wd+SaDuv+J7T1kAO5clCt/0sSiuSCYx7MZjedJi+Kt32G+btOWGmGeVYcXhI
 W4TenexOBXfSg9hcW7YvQlzjDmOjIduMWFBEZ4NcZax5Siyu4Lp95vBroj4oMdche885
 do4QL+I1rqOsXVDmCctYI7tL5scgFZV+a6pWBd1uFs0Kd184yn+eKiVU+p5Qk/A6Nvf1
 VB8UjeNE6AylFH5hYddGfqM6OpbuDVFSYok/9B400HDajcnup3+feDi9z0SmfbBk/rLe
 8owQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Yq3UF/O6ghf1oapvxUJWBbk4uV2Kh5VLtR3aNkbqwLU=;
 b=o5LCAAt1lSTdad46SizVhAflxTXDiPUxTDd4t25RQng96LaTcY5V2VJqqgZzW/DHMO
 PdW9kxvBwtokI5OSM97TqwBzKuhtKQ6MURrqin/GbDGKz2qK87HMxpyKwNqMtLw1He/C
 5N5B27A78oka0V6fMY/Bz2dUydidvNUeQgvsoCD8sP/TFKByVP9Vxo+BsJ+BKD2UVgeF
 9tgkgQAlGTRGMMkY9PO2dYjnwV/XJyJVXGgQiuLVugPuI5NZ0QBr7gh6NzXP9ofkqyvN
 Ck1sCt+s4fMwvgR+K1uD3D+SSiA6P/iiM7UBRRnAo12G45M08Br+vTyzBmIiE1hfCk4/
 2SQg==
X-Gm-Message-State: AOAM532FHLRq7uWcLJxlCx7OastOFYHa7t+wikKL8Hev9VAFntE/a88u
 KOXfTMsyf5e+wFckYMjv9AvXvY2CW2EBj8S6HqcQcbphBW7tqsEVCVqZwJgkFJH6cU9y0ImcIpZ
 9pfQ9mIEbeBvjR/1F6tXMLYHaic8O9lGuGGTQf2vmOT80e70GEQwwsrUBD68QP453R8HgKw==
X-Google-Smtp-Source: ABdhPJz38dBT7VX3FyWuDPXxw7meMSBJqJ/lccWrUHQ/7+O798GcGbiE1SovJz/Vpj+Lqa7gpuyUIHN+1GE=
X-Received: from ascull.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1510])
 (user=ascull job=sendgmr) by 2002:a0c:eb0f:: with SMTP id
 j15mr11595845qvp.58.1614073776698; 
 Tue, 23 Feb 2021 01:49:36 -0800 (PST)
Date: Tue, 23 Feb 2021 09:49:26 +0000
In-Reply-To: <20210223094927.766572-1-ascull@google.com>
Message-Id: <20210223094927.766572-2-ascull@google.com>
Mime-Version: 1.0
References: <20210223094927.766572-1-ascull@google.com>
X-Mailer: git-send-email 2.30.0.617.g56c4b15f3c-goog
Subject: [PATCH 1/2] KVM: arm64: Use BUG and BUG_ON in nVHE hyp
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

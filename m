Return-Path: <SRS0=ROvZ=CM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA0B9C433E9
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 13:53:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 95D90208CA
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 13:53:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="K9XziCEG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 95D90208CA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 449BF4B2DA;
	Thu,  3 Sep 2020 09:53:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id imIRkQc9PQAY; Thu,  3 Sep 2020 09:53:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 31D554B140;
	Thu,  3 Sep 2020 09:53:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E95E84B2A7
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 09:53:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KYcMylRPv1Ly for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Sep 2020 09:53:23 -0400 (EDT)
Received: from mail-qk1-f201.google.com (mail-qk1-f201.google.com
 [209.85.222.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EF5E34B2DE
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 09:53:22 -0400 (EDT)
Received: by mail-qk1-f201.google.com with SMTP id g6so1569672qko.21
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Sep 2020 06:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=AwtXwoM2K8tOnbwwUhIWJJkJf6xiR3Qg++wLNHJKzAw=;
 b=K9XziCEGbV7pUGY/HBFMcEewUYae1cZqrqx7z+71k9vDrAXE8z2V4VbpueUSf6lBYK
 Ao5SmLRXSopY81N3w4qHh7hMzgC/cLoA4BiAdMvVyzQ7w9mZ4ICCff8t6yhGIW2xp5tK
 dQvtreMwcf7bQLT1/rX7x3ttdeiVQaYHB3Aq/VBk5iATp9E8kpSTuIdtq2nlO2spr/lP
 DvrPbIxX820OcdXZW81K/b237s7hsFNP4fw6S+3/95bM06QwQQO3aozWO2qZHzuiFUai
 Za4xAx6UVVN3ib0A10IXFqpDzTu1nQrZz3ZJc0gJ1l3mCL8moDxXKE1isagHTIzCnLNV
 SOKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=AwtXwoM2K8tOnbwwUhIWJJkJf6xiR3Qg++wLNHJKzAw=;
 b=RxOus8ctjDLA0boypkNJn3tNaE4kEmVCEkGXGTDqdSVER9wYbO49LOILAxvcNVGGoa
 g4gExB7u9vhA4AFYbdd7qt4o433u537fxCo3Pvgkwu5z/DReJ/u93RezF4uqlt4lCFm/
 gjDFVrrnQCs00zE8ex9uOux2d0cj34TCtZS6dzBxKzkeuGwScPGbq0g62u3BqqUHjB6G
 lMcaXpDUMfQxHt1xYKJckRs/Vs7kVONTRLVILrvDQAHcm+3hSzHWVcF6DOjn+BYbq0n8
 7dXmH9SN4MsttR9XkK4RU5VvnGmYl6zbSjhB8BGVfYPn+NUIhkb8mzcJuUnIj83+8glN
 viMg==
X-Gm-Message-State: AOAM533AnpCRuC+fTemMiqurBwL2PLZGtbxedLPE70ToSsjYXNLxINA7
 bPZqgTEVI22TrW+a406QsOczAq1pUFGa0taHNLBYjDjoxsixCqQz3ct9RQWqdGg6g/Hrk4sXZBO
 XBMIv9pG4MkBEGTYVvWAxacPcANNC/rAlvOfCXYk1sExZMRO+8xMhyau6TG8a4/1yXJAvew==
X-Google-Smtp-Source: ABdhPJz5oGR6ixw8aIc+X0oj1sX69tKg2ggKVOyAhbPBb8ACL2USx9VWiURftSkpHoyl0zy3WQzoCtvG6Qs=
X-Received: from ascull.lon.corp.google.com
 ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 (user=ascull job=sendgmr) by 2002:a0c:ca87:: with SMTP id
 a7mr2972588qvk.17.1599141202305; 
 Thu, 03 Sep 2020 06:53:22 -0700 (PDT)
Date: Thu,  3 Sep 2020 14:52:54 +0100
In-Reply-To: <20200903135307.251331-1-ascull@google.com>
Message-Id: <20200903135307.251331-6-ascull@google.com>
Mime-Version: 1.0
References: <20200903135307.251331-1-ascull@google.com>
X-Mailer: git-send-email 2.28.0.402.g5ffc5be6b7-goog
Subject: [PATCH v3 05/18] KVM: arm64: Save chosen hyp vector to a percpu
 variable
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 maz@kernel.org, Sudeep Holla <sudeep.holla@arm.com>, catalin.marinas@arm.com,
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

Introduce a percpu variable to hold the address of the selected hyp
vector that will be used with guests. This avoids the selection process
each time a guest is being entered and can be used by nVHE when a
separate vector is introduced for the host.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/include/asm/kvm_hyp.h | 2 ++
 arch/arm64/kvm/arm.c             | 5 ++++-
 arch/arm64/kvm/hyp/vhe/switch.c  | 2 +-
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 3de99b323061..1e2491da324e 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -12,6 +12,8 @@
 #include <asm/alternative.h>
 #include <asm/sysreg.h>
 
+DECLARE_PER_CPU(unsigned long, kvm_hyp_vector);
+
 #define read_sysreg_elx(r,nvh,vh)					\
 	({								\
 		u64 reg;						\
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 1af4c77feda2..77fc856ea513 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -47,6 +47,7 @@ __asm__(".arch_extension	virt");
 #endif
 
 DEFINE_PER_CPU(struct kvm_host_data, kvm_host_data);
+DEFINE_PER_CPU(unsigned long, kvm_hyp_vector);
 static DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
 
 /* The VMID used in the VTTBR */
@@ -1276,7 +1277,7 @@ static void cpu_init_hyp_mode(void)
 
 	pgd_ptr = kvm_mmu_get_httbr();
 	hyp_stack_ptr = __this_cpu_read(kvm_arm_hyp_stack_page) + PAGE_SIZE;
-	vector_ptr = (unsigned long)kvm_get_hyp_vector();
+	vector_ptr = __this_cpu_read(kvm_hyp_vector);
 
 	/*
 	 * Call initialization code, and switch to the full blown HYP code.
@@ -1309,6 +1310,8 @@ static void cpu_hyp_reinit(void)
 
 	cpu_hyp_reset();
 
+	__this_cpu_write(kvm_hyp_vector, (unsigned long)kvm_get_hyp_vector());
+
 	if (is_kernel_in_hyp_mode())
 		kvm_timer_init_vhe();
 	else
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 835c2dfc7a9f..7e99a7183320 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -59,7 +59,7 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 
 	write_sysreg(val, cpacr_el1);
 
-	write_sysreg(kvm_get_hyp_vector(), vbar_el1);
+	write_sysreg(__this_cpu_read(kvm_hyp_vector), vbar_el1);
 }
 NOKPROBE_SYMBOL(__activate_traps);
 
-- 
2.28.0.402.g5ffc5be6b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

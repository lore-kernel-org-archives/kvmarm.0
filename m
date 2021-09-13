Return-Path: <SRS0=oqs1=OD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 345CFC433EF
	for <kvmarm@archiver.kernel.org>; Mon, 13 Sep 2021 23:10:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C5AB06112E
	for <kvmarm@archiver.kernel.org>; Mon, 13 Sep 2021 23:10:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C5AB06112E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 76CFB4B1BC;
	Mon, 13 Sep 2021 19:10:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0F63-ZD8cEkr; Mon, 13 Sep 2021 19:10:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5157D4B206;
	Mon, 13 Sep 2021 19:10:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 763F54B1F2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 19:10:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5hI4yZOt5tAi for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Sep 2021 19:10:16 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 886D64B1E7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 19:10:13 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 k15-20020a25240f000000b0059efafc5a58so14994724ybk.11
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 16:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=VREX88yx9xWzleHW1ZEh6k892sL/xPpdGpps/n5mOO0=;
 b=iK83yniVjgitiMsPKE4heQ6oT5rN4oNwgLzQoyg5AZbIqAYzYHhPvLBF3Z3crr9r15
 9U+ZxVXK13YUTjJZJ4Yz5pii/pFm/7uIvC8pAu63Tn+8Vu0GIJwOSYuDaEpBkNcskqWf
 fs9FJCplOKxOdfrEDqL2+nU1gOritaqPDtimBWNEaypbZDTErBxFjkHWtO1D2rylDVfo
 3TOQq1XxOgSnD5Q6IfRthoDnW4h1H4/ngV0eT6/oJdj1/g1nKuOocfqESB9G6HVtqQWS
 2Nd3LR006dsHJuBkVl7PKAQ1+7BFeF7935GxPhrgHW9uyt/R8Pqt+Svp/fX8KXAPFU65
 /oBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=VREX88yx9xWzleHW1ZEh6k892sL/xPpdGpps/n5mOO0=;
 b=fxqeP3DSGRMsNCtTL24Jtd7akhFIx5VRQGcEaqpG/XxdUa4dzuBg/MVfpPf3MGfM84
 S742z1NeCDqi5o96kmdxWxJvTJTx3rnkw1Hmh7mqqRTUkyvLChwgB9p9BK3e5nU/5inQ
 I5TCCTZ5JNACtH19hvC1PCLU2YdLkNywR0BpWknbSmrHjZoVmGt3qYaYaQ7zFqYxvxOj
 Uwa9yx6SP/kzlyzjE8r4oRbJCzf5MkySrX7QINkca7vHa4wV8eSK/+4in5BI1u+w9pWB
 8RYFIi+ZgZQiIlHk4AsxWGnwZXtWW+7r4xnu5VeclR6OwS0Fc61qwZNiY2cCqFqzCHg4
 sHMQ==
X-Gm-Message-State: AOAM530awOZ/VMj491l57tvddkdmwjP66jibeAKKTqtUBsMPp5HRk1DX
 Bf8VyV1cqZOh0Q7L9x6l5WokhAzIi4F/
X-Google-Smtp-Source: ABdhPJwOabcG17jAMTLXvpXjFejZRIOwG/0IcuiiiLvmT7OSJIRiMZN1Y4+nazea7PBvNbx2r7WJPaFvDsgB
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a25:44d:: with SMTP id
 74mr20148426ybe.54.1631574613117; 
 Mon, 13 Sep 2021 16:10:13 -0700 (PDT)
Date: Mon, 13 Sep 2021 23:09:46 +0000
In-Reply-To: <20210913230955.156323-1-rananta@google.com>
Message-Id: <20210913230955.156323-6-rananta@google.com>
Mime-Version: 1.0
References: <20210913230955.156323-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH v6 05/14] KVM: arm64: selftests: Add support for cpu_relax
From: Raghavendra Rao Ananta <rananta@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
 Andrew Jones <drjones@redhat.com>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Implement the guest helper routine, cpu_relax(), to yield
the processor to other tasks.

The function was derived from
arch/arm64/include/asm/vdso/processor.h.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/include/aarch64/processor.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index 93797783abad..265054c24481 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -122,6 +122,11 @@ void vm_install_exception_handler(struct kvm_vm *vm,
 void vm_install_sync_handler(struct kvm_vm *vm,
 		int vector, int ec, handler_fn handler);
 
+static inline void cpu_relax(void)
+{
+	asm volatile("yield" ::: "memory");
+}
+
 #define isb()		asm volatile("isb" : : : "memory")
 #define dsb(opt)	asm volatile("dsb " #opt : : : "memory")
 #define dmb(opt)	asm volatile("dmb " #opt : : : "memory")
-- 
2.33.0.309.g3052b89438-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

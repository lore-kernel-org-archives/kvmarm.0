Return-Path: <SRS0=9/XU=MV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EDF9C4320A
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 19:56:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 079C260F46
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 19:56:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 079C260F46
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FAAB4B0B2;
	Thu, 29 Jul 2021 15:56:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Qe8H6u5SBh1d; Thu, 29 Jul 2021 15:56:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8605E4B0CF;
	Thu, 29 Jul 2021 15:56:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E84C4B0BC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 15:56:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zAeQEJqPWw+t for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Jul 2021 15:56:44 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C3D774B0B2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 15:56:44 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 a188-20020a25cac50000b029055d47682463so7970644ybg.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 12:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=pgN08b/yk00GBllZokVtpDSIFyPI7a31tDiORmsCfCE=;
 b=YYy23uG1UwrvJN92781dawTqDn7rZMmOuoeD+4Fa5cMOURrHKF4+7b+PbMfknbbdxA
 gAO0wbzpUDvMB/7yIdtwvwc5NMSXTrutcgwm4KEhR8VtONe2DahfE+BQsbia6PESTKca
 0+xIPncJvhoGX1fBAjyBzaTX/3YpdeWuQTVe/qzrGc1zEJV/3vyTEgzpd5gTGq0vXQEm
 LeylFxvvkaMHXaRdAiuuEjB2TqJ5zZ2ew7iYg9KMiHHP25U1dRuUvOY07cskE37oe/XJ
 DRTHHBc88F/Vh8xcmrroJWrPOD9C13B3s6UPhD860jT69w1S70hx2aht/1RR8+d6xe5w
 Vv0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=pgN08b/yk00GBllZokVtpDSIFyPI7a31tDiORmsCfCE=;
 b=P/KyCYZvaF/K83QlOCyphBvXBaLNZd+1cbX8uk0sO2KGNtPZ4K4Mqcz0e9xxDHoYOI
 pQL+MJDlgYYRm/xYs0C1gfC1+Q4hD3ntDRui5rRIKT2rYSCg1KzlTcXQh5Hox/QHPxb+
 nFv2HySQmOSHSFgkNdXcpEr3adX/i4EE7yOAxg1zUlwLB7PGuh6+AnpHJz6M9hColETi
 TkKO+A7skZCsGr/9fB0VVqZfbw/5L5VZScd2/7gWj2UBNQoQJQRMioUdGYJS8lsYyr1y
 ZvEU8Ut/8Y4S/gtnttJCVvM1qRlRtz/r40HFqnird06+BKUjXQApoHj95FrPjSsG/qQB
 Yo5g==
X-Gm-Message-State: AOAM532MEMZRZBncFAR6neF9RuHlVGfMm86/97wq2hlxB+oBJA05e4du
 aZjpxl1ndNKHoi5A/OfIpIOB1IBuu+wviJPo4Ahlod3MI1bzQapPq8UEsZgHkYSDmG2qd/NTSYk
 h22qAlFJ5hYJsc4QcjsxK9eqGUq/zzIFOrhzlewdryHZf/ReZsETf5aGKgpjQEa1p9mw4yA==
X-Google-Smtp-Source: ABdhPJxv5Q9iSjza/dtoJWD8Ji6uBJa+KRn2GwxkRTQBooW5PwZGIYhH1qvOF/ZaptJAN9C14jeegk4SH7g=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:7a03:: with SMTP id
 v3mr9033669ybc.202.1627588604139; 
 Thu, 29 Jul 2021 12:56:44 -0700 (PDT)
Date: Thu, 29 Jul 2021 19:56:30 +0000
In-Reply-To: <20210729195632.489978-1-oupton@google.com>
Message-Id: <20210729195632.489978-2-oupton@google.com>
Mime-Version: 1.0
References: <20210729195632.489978-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH 1/3] KVM: arm64: Record number of signal exits as a vCPU stat
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: Shakeel Butt <shakeelb@google.com>, kvm@vger.kernel.org,
 Peter Zijlstra <peterz@infradead.org>, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Guangyu Shi <guangyus@google.com>, Will Deacon <will@kernel.org>,
 Andy Lutomirski <luto@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
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

Most other architectures that implement KVM record a statistic
indicating the number of times a vCPU has exited due to a pending
signal. Add support for that stat to arm64.

Cc: Jing Zhang <jingzhangos@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 1 +
 arch/arm64/kvm/arm.c              | 1 +
 arch/arm64/kvm/guest.c            | 3 ++-
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 41911585ae0c..70e129f2b574 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -576,6 +576,7 @@ struct kvm_vcpu_stat {
 	u64 wfi_exit_stat;
 	u64 mmio_exit_user;
 	u64 mmio_exit_kernel;
+	u64 signal_exits;
 	u64 exits;
 };
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e9a2b8f27792..60d0a546d7fd 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -783,6 +783,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		if (signal_pending(current)) {
 			ret = -EINTR;
 			run->exit_reason = KVM_EXIT_INTR;
+			++vcpu->stat.signal_exits;
 		}
 
 		/*
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 1dfb83578277..50fc16ad872f 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -50,7 +50,8 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	STATS_DESC_COUNTER(VCPU, wfi_exit_stat),
 	STATS_DESC_COUNTER(VCPU, mmio_exit_user),
 	STATS_DESC_COUNTER(VCPU, mmio_exit_kernel),
-	STATS_DESC_COUNTER(VCPU, exits)
+	STATS_DESC_COUNTER(VCPU, exits),
+	STATS_DESC_COUNTER(VCPU, signal_exits),
 };
 static_assert(ARRAY_SIZE(kvm_vcpu_stats_desc) ==
 		sizeof(struct kvm_vcpu_stat) / sizeof(u64));
-- 
2.32.0.554.ge1b32706d8-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

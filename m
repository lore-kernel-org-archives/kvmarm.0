Return-Path: <SRS0=9/XU=MV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 952D4C4320E
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 22:09:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 328B660F4B
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 22:09:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 328B660F4B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C62C14B0B9;
	Thu, 29 Jul 2021 18:09:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6fTDZfYc-TSv; Thu, 29 Jul 2021 18:09:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AEF454B0DA;
	Thu, 29 Jul 2021 18:09:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F7BD4B0D3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 18:09:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id S9my36gpvQZ6 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Jul 2021 18:09:27 -0400 (EDT)
Received: from mail-oi1-f201.google.com (mail-oi1-f201.google.com
 [209.85.167.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 30FCD4B0D2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 18:09:27 -0400 (EDT)
Received: by mail-oi1-f201.google.com with SMTP id
 m20-20020a0568080f14b029025a3cb2429bso3631653oiw.20
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 15:09:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=quVRBmXT16c8/+OvPaemt4sih+vYkJfmbVpHJfXSYSE=;
 b=ugW9I6GN7pWL34ADNzvmolXeBcl8BcWkp42bUMTI1HufksQY7hkq6QIre1ssegbcDK
 1HingL2dULatPpmnK4uTzlDTe5eHq4aIvslbmDd+0FZDk9o/YhXmqlRUHTKClJqtjIRx
 lO9lAb7lc0X/0//6WYsoJanHg5bq1N/NKju+D9SXdR0TnkG7bI2ZtwBRiaEWf6bOkRAb
 98/5vkebBq7V5Nz4THlbYao4dA+pzlZ/gHl/QwtbvjtosU+04rXIX/8S9Log9/7k7tkG
 h+Dzno/lXwqxLsTSydVwT48EpccvW4FnKhbvPPd1heziD9Z5v6dkZjVLzssvROFfgMNZ
 1Y1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=quVRBmXT16c8/+OvPaemt4sih+vYkJfmbVpHJfXSYSE=;
 b=JvW6kNOGDhUU7miWT2OYNHyAjutxlFffRZwaezBe9O5GuUFbhsnzL+H3BvZO9Tvl0A
 foG6RskuKGwZo7KR61HkcLlvBeTm5sIt6fglmwIjSSvzoWiuhcyxqE+BHEoRx/Sd+ohW
 WM8JIKoSm7p5ynAROaoZHzijdo0nXcx6Mg8WumW/zZEWIqO/kU4/6EFfgAQezcU/DlVy
 aN+htfDF4jUJNOyywaKroEfjmHe2VcoKQgLvlqMCuo20EZLsYF5zLIzNV+c6hz0D7gMm
 6FrQAwWHCpGrTgu8nr+PgimcAXmdNIHb7N39MVn9fpelOEj4AC4DKVXFHrET+3mrHncw
 MvLA==
X-Gm-Message-State: AOAM532AnR1OmqRcmy7xo/0HZ9/+Yr99wf7z7eJXvk8k19kHccF02+9k
 +jPnGwBV3rP2FtFjqLxa/iCSFa3iBLczMQ4sWB2hF1gbZ4454cxSY/u+7hkRF1AEzOoyEE54YyL
 m7f/ypE7pBCoaqPGZfR9nC50PgMfEkxhqt47oK6exbAe52dFoMNphco+8xXd2klM+Q96WWw==
X-Google-Smtp-Source: ABdhPJzcet3LHyvZdP4E+QC8YrDCMndlQCo3ftaMJDpvwe0sicb30CgU1kH3S2MUtZSb4XXEKENrpPs4SFs=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:aca:bf84:: with SMTP id
 p126mr4508603oif.154.1627596566328; 
 Thu, 29 Jul 2021 15:09:26 -0700 (PDT)
Date: Thu, 29 Jul 2021 22:09:14 +0000
In-Reply-To: <20210729220916.1672875-1-oupton@google.com>
Message-Id: <20210729220916.1672875-2-oupton@google.com>
Mime-Version: 1.0
References: <20210729220916.1672875-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH v2 1/3] KVM: arm64: Record number of signal exits as a vCPU
 stat
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

Reviewed-by: Jing Zhang <jingzhangos@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 1 +
 arch/arm64/kvm/arm.c              | 1 +
 arch/arm64/kvm/guest.c            | 1 +
 3 files changed, 3 insertions(+)

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
index 1dfb83578277..853d1e8d2e73 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -50,6 +50,7 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	STATS_DESC_COUNTER(VCPU, wfi_exit_stat),
 	STATS_DESC_COUNTER(VCPU, mmio_exit_user),
 	STATS_DESC_COUNTER(VCPU, mmio_exit_kernel),
+	STATS_DESC_COUNTER(VCPU, signal_exits),
 	STATS_DESC_COUNTER(VCPU, exits)
 };
 static_assert(ARRAY_SIZE(kvm_vcpu_stats_desc) ==
-- 
2.32.0.554.ge1b32706d8-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

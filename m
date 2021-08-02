Return-Path: <SRS0=xqRQ=MZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE1D9C43214
	for <kvmarm@archiver.kernel.org>; Mon,  2 Aug 2021 19:28:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5877761104
	for <kvmarm@archiver.kernel.org>; Mon,  2 Aug 2021 19:28:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5877761104
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EFA69407F1;
	Mon,  2 Aug 2021 15:28:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ONObLrTXtTd9; Mon,  2 Aug 2021 15:28:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C34A84A17F;
	Mon,  2 Aug 2021 15:28:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AC752407EF
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Aug 2021 15:28:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id W8aD+j4nwXZy for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Aug 2021 15:28:14 -0400 (EDT)
Received: from mail-qk1-f201.google.com (mail-qk1-f201.google.com
 [209.85.222.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D1BF349E8A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Aug 2021 15:28:14 -0400 (EDT)
Received: by mail-qk1-f201.google.com with SMTP id
 h186-20020a37b7c30000b02903b914d9e335so13776689qkf.17
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Aug 2021 12:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=quVRBmXT16c8/+OvPaemt4sih+vYkJfmbVpHJfXSYSE=;
 b=JIWAzTD8mW/5i0lrePS1nmrHncrYMDBLUNta3fNF8Ym8CYZT1LUk485ozHVMBMDP3O
 QZrHPlUeWTuJF0oW+YnAumjLhjKHbXgy+pcl7q8c6osX3dCzZTpAjWjFcoNK9LoWBW0d
 Kqj87dr4gptUzqRPoLcm/S498Tbiqy2yQxKq48t2nLaQ9K9XyaXz2y+iqZVv9QEm1jPD
 Y5hI3hGYVSBEJzDRk15+/YPLJc2vTS5ZmzyLkBmRWgaOpuT7eps9fvzT6BBQjtHwKYON
 qQubl5pEdkRCv4fdLNsa0o7a8cWRy7YPFuAsNgjwl8cHNB+VLhFnxcNyWeYt8hzkt+C1
 R/dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=quVRBmXT16c8/+OvPaemt4sih+vYkJfmbVpHJfXSYSE=;
 b=mKmrH7i/siuxP7gTDbJ0bAgKmV+B421e0wVx+XrIATTlmrv/Ztg360wtsA+S/zPnCo
 JNjNVDbLGsHJWhcQfSVRtqotQPdopDXlgvleQ+Zou2vc/aSnxuhsSog3JIVMhR5VOmgr
 VimNccXidN7NRmokfSEeZMl3mcMWZhj5UWuiFgIc6xI1hzLUUZ5Eev7K1MMCsEeo4RwP
 Q87JFhTXOOuae8tEZ5Tm2UXkGlHnforUWISuWo5Z4kGESV50Cyf8l2njmksv/7GnQIkV
 h/C5tnbBHLTtH8+Ok9t4F+potmTydEbZdsKvEUjfL9QOMlJwBBJQKVm2Qalx3Dfifrim
 uVSg==
X-Gm-Message-State: AOAM530thfXtZKYg945MjdFxmh6FQv0M2jwCZ7FAz32K4q8HXrXcetj4
 Uk3rIoczmDLfVvE9or1f7JvhbH4slc1NOeDZiRLnfT0QvdQSdhhMq9fdZGY0xjA6BtJlDy/M2m9
 r3A4Jgckf5fCJ+fbIk14/zScTXR4WnLCzeM+Vg3zMkkUF0D7SssV8BcTCGWOvdEfU13vwfQ==
X-Google-Smtp-Source: ABdhPJz1DQuSneO2f/+7Ncn9bFUKrFi6AUVYWFhFUwzGMFfXQ0w8T9ZZ7K0LwD0TDiocdSA4H4YvhPjht+k=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a0c:e508:: with SMTP id
 l8mr16364594qvm.41.1627932494378; 
 Mon, 02 Aug 2021 12:28:14 -0700 (PDT)
Date: Mon,  2 Aug 2021 19:28:07 +0000
In-Reply-To: <20210802192809.1851010-1-oupton@google.com>
Message-Id: <20210802192809.1851010-2-oupton@google.com>
Mime-Version: 1.0
References: <20210802192809.1851010-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH v3 1/3] KVM: arm64: Record number of signal exits as a vCPU
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

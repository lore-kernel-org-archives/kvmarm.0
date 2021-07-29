Return-Path: <SRS0=9/XU=MV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EED2EC4320A
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 22:09:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8695960EB5
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 22:09:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8695960EB5
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 253F94B0E2;
	Thu, 29 Jul 2021 18:09:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id e++MNUFC+n0P; Thu, 29 Jul 2021 18:09:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EF8EE4B0F7;
	Thu, 29 Jul 2021 18:09:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8480C4025B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 18:09:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IAjU6+N6JQ-4 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Jul 2021 18:09:29 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 159C04B0D2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 18:09:29 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 j9-20020a2581490000b02905897d81c63fso2617118ybm.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 15:09:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Ol+FzPmhNMEWcf/ywMIJRhViVzXRwXAQpsvgYkKHWL8=;
 b=rMkpaQypttkvOTlv0Yu0PJmHWsRFvCYfneyQu7XZAtrdjGpFfNfWqGn18dsvnXx69o
 PZKA+4rEXvIPkfayg+sTbiz/r2c2jFqjggsWxPnHu2UvNAE/TxUYORkliLZz8+Unip/t
 8u26bRuYDYcAGouDHhdj3sGiQeLcyUoht6c3vAIWVzH75s2ci3VOmqFxR/seNYXNYlu8
 /AUeM/FGUiGx2BfOL8T7HKYlAbBrzpWfI02ULYgSN6TnmoTbeZ41S7ebJMuFU2smbXuw
 xnez5Awds1TMNx/arUH4gXwb9PyM5txGUSIjEvN0bYU7LVM0JasjEqcZuf3NxC0uOWP+
 uZnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Ol+FzPmhNMEWcf/ywMIJRhViVzXRwXAQpsvgYkKHWL8=;
 b=Nb844j9c1Zhults21bkhSdvQYvi8J+TwY9Yrfh+Q61EZn0cprRyTLpEDIcvw+C90ra
 LZHNAbBH9FGRgYJjQW0uBAkBMvssJTJ3u+RF4MhrSCv3LqgvA4DtBuBc27qNdIhnWrST
 esqyCpXxCbiaHZ96T+c0ju3M53FR4j/376iYMEREaOvGdK83f5vDLjRaI9wWUad2y/S1
 SeH2LIvvXGeuB/eh4S7mpFuM8VF8usnq0cUF4kZRX/H3VDfvMTrWUC/4FyUV+CSm9Ib1
 w7by24fUwlsumE8SV+cPC9sv2cQY6FIDs8sijaNDDMJhNXQxensUW0vq6A07bKoXf5Nd
 Bbcw==
X-Gm-Message-State: AOAM532Tnhy7FBRIwylJXOtazv/3O3SMVMP+wN0MP1C6KZNHGbKl9xWJ
 Cb3d+fdUZHp9pHhxUbpvheX32e0r4BU+QRdnIhdQ3V7BvF7Pu4cBfvZEm3oIH1q/7rIny+s8/6S
 RJ9z0PDyxaU43ADGrT4vzj3dFq9e2R+5uZPUw00LMoZY7NwNFm/8bK0gCxhRjWHzSwUMobQ==
X-Google-Smtp-Source: ABdhPJzutKBCdlIcisOY4xmX+bS3I+7VYGny6icfY80fNWnWdBzJeRY3xCP1/YQ+2mjVREH1XV6dtDLEzkk=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:e64a:: with SMTP id
 d71mr9565726ybh.142.1627596568495; 
 Thu, 29 Jul 2021 15:09:28 -0700 (PDT)
Date: Thu, 29 Jul 2021 22:09:16 +0000
In-Reply-To: <20210729220916.1672875-1-oupton@google.com>
Message-Id: <20210729220916.1672875-4-oupton@google.com>
Mime-Version: 1.0
References: <20210729220916.1672875-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH v2 3/3] KVM: arm64: Use generic KVM xfer to guest work function
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

Clean up handling of checks for pending work by switching to the generic
infrastructure to do so.

We pick up handling for TIF_NOTIFY_RESUME from this switch, meaning that
task work will be correctly handled.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/Kconfig |  1 +
 arch/arm64/kvm/arm.c   | 27 ++++++++++++++-------------
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index a4eba0908bfa..8bc1fac5fa26 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -26,6 +26,7 @@ menuconfig KVM
 	select HAVE_KVM_ARCH_TLB_FLUSH_ALL
 	select KVM_MMIO
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
+	select KVM_XFER_TO_GUEST_WORK
 	select SRCU
 	select KVM_VFIO
 	select HAVE_KVM_EVENTFD
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 60d0a546d7fd..9762e2129813 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -6,6 +6,7 @@
 
 #include <linux/bug.h>
 #include <linux/cpu_pm.h>
+#include <linux/entry-kvm.h>
 #include <linux/errno.h>
 #include <linux/err.h>
 #include <linux/kvm_host.h>
@@ -714,6 +715,13 @@ static bool vcpu_mode_is_bad_32bit(struct kvm_vcpu *vcpu)
 		static_branch_unlikely(&arm64_mismatched_32bit_el0);
 }
 
+static bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu)
+{
+	return kvm_request_pending(vcpu) ||
+			need_new_vmid_gen(&vcpu->arch.hw_mmu->vmid) ||
+			xfer_to_guest_mode_work_pending();
+}
+
 /**
  * kvm_arch_vcpu_ioctl_run - the main VCPU run function to execute guest code
  * @vcpu:	The VCPU pointer
@@ -757,7 +765,11 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		/*
 		 * Check conditions before entering the guest
 		 */
-		cond_resched();
+		if (__xfer_to_guest_mode_work_pending()) {
+			ret = xfer_to_guest_mode_handle_work(vcpu);
+			if (!ret)
+				ret = 1;
+		}
 
 		update_vmid(&vcpu->arch.hw_mmu->vmid);
 
@@ -776,16 +788,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 		kvm_vgic_flush_hwstate(vcpu);
 
-		/*
-		 * Exit if we have a signal pending so that we can deliver the
-		 * signal to user space.
-		 */
-		if (signal_pending(current)) {
-			ret = -EINTR;
-			run->exit_reason = KVM_EXIT_INTR;
-			++vcpu->stat.signal_exits;
-		}
-
 		/*
 		 * If we're using a userspace irqchip, then check if we need
 		 * to tell a userspace irqchip about timer or PMU level
@@ -809,8 +811,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		 */
 		smp_store_mb(vcpu->mode, IN_GUEST_MODE);
 
-		if (ret <= 0 || need_new_vmid_gen(&vcpu->arch.hw_mmu->vmid) ||
-		    kvm_request_pending(vcpu)) {
+		if (ret <= 0 || kvm_vcpu_exit_request(vcpu)) {
 			vcpu->mode = OUTSIDE_GUEST_MODE;
 			isb(); /* Ensure work in x_flush_hwstate is committed */
 			kvm_pmu_sync_hwstate(vcpu);
-- 
2.32.0.554.ge1b32706d8-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

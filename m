Return-Path: <SRS0=9/XU=MV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A5D9C432BE
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 19:56:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2A02660F01
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 19:56:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2A02660F01
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D0BF840287;
	Thu, 29 Jul 2021 15:56:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OXbenWli8gTB; Thu, 29 Jul 2021 15:56:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C90984B0CD;
	Thu, 29 Jul 2021 15:56:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B268040287
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 15:56:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DIpdjqLPurrT for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Jul 2021 15:56:47 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0FC9B4B0BC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 15:56:47 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 e145-20020a2550970000b029056eb288352cso7856648ybb.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 12:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Ol+FzPmhNMEWcf/ywMIJRhViVzXRwXAQpsvgYkKHWL8=;
 b=tE4wkeBUmlcgG1Oi1kqljBqPAq2FxkSBuM/0hbXQQi2dyGcWco8yqSrmnVk4GUqTP8
 B1Y6AqoRFUHY5NfwvVT//R2KLyto5BFSK3FnmrUiG6B5QJbtotKTGiSx8TAiSpUfpBX1
 RwJL40P1LJTj868fIGa7CImo40MmyzVuR3Zk0Ww+Q4xy5JLKXjy5TOCJ2rrdPUPCMjd/
 OHn/OlsBf1bNoxUI7q/mKah8S8j9nBSApsYGYrHhrHMJ/VdT+Cta+PFakejb4YGHGoAm
 Oxs/mxKqPQNfzOPDkOQwWRLi/PtiOeoWmR50Im/H2TpkCT/1DhBwEO+x3+I1HMKL+x3B
 WsbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Ol+FzPmhNMEWcf/ywMIJRhViVzXRwXAQpsvgYkKHWL8=;
 b=liyZyQVLZch76c8EEcCOZpkQpoapfypEN0It/FB5NahoeegYkqKg57PPUC67W5VVQ4
 sgZsKxMMmEaL2x5qOOzcu4ViHW/ZYmN9MS2pa/xC5PEaKrKTFUlrCSD/GlRVidFruFhR
 AGQMjWNrIV9U0wd7JEmC446KyUhVAUSi9Fl7UvHUmW1pJnF/tNdZW4TnJP4fS+8fAAMP
 WpIzJvBUvfKUxoTrANGoTGDVWepw6ePVMVpv5uwQsxpoTubX1g4qykfk/c1RhBFlthI/
 ExhXqHa4ZDwS8Cz0C+qilk8+rr6BI68Mja/vdj3N87PqUk7FQS3JHV5OFAF9oqannCk9
 f50w==
X-Gm-Message-State: AOAM533FZ14BpZyF1q5X8yJGzBF3WSeG1ba4mmagR2XBRaA6LIFF59iQ
 bMCxr3r6uI0vlz4uCBIkHCDg7s9gQKo+UuhIrRq7AcwdIIGKZFLRQkd1LNm2C0vGYxn/bFb8kTe
 BVAGs2WgvDvUTSMwkoN2eYn8/0Ri3UYr+tNCQY/8X500AjEB7TXgThXKSgzvoi+ISqSJgag==
X-Google-Smtp-Source: ABdhPJzEqeKxfCGlgZpzy/oi0hUM353MPBMR8OsyLB/q3Rn+Ob7BztAXWntKOvKujoWtbqCxSrp7KEVTT8w=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:55c4:: with SMTP id
 j187mr9110009ybb.284.1627588606437; 
 Thu, 29 Jul 2021 12:56:46 -0700 (PDT)
Date: Thu, 29 Jul 2021 19:56:32 +0000
In-Reply-To: <20210729195632.489978-1-oupton@google.com>
Message-Id: <20210729195632.489978-4-oupton@google.com>
Mime-Version: 1.0
References: <20210729195632.489978-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH 3/3] KVM: arm64: Use generic KVM xfer to guest work function
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

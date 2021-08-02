Return-Path: <SRS0=xqRQ=MZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16C49C41537
	for <kvmarm@archiver.kernel.org>; Mon,  2 Aug 2021 19:28:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BE41E61050
	for <kvmarm@archiver.kernel.org>; Mon,  2 Aug 2021 19:28:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BE41E61050
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 681B24A198;
	Mon,  2 Aug 2021 15:28:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2eb6h8r3KYvl; Mon,  2 Aug 2021 15:28:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D4D649F82;
	Mon,  2 Aug 2021 15:28:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 36BB849F82
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Aug 2021 15:28:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sqNCPQ2ENjWa for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Aug 2021 15:28:17 -0400 (EDT)
Received: from mail-io1-f73.google.com (mail-io1-f73.google.com
 [209.85.166.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 303B749E50
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Aug 2021 15:28:17 -0400 (EDT)
Received: by mail-io1-f73.google.com with SMTP id
 q137-20020a6b8e8f0000b02904bd1794d00eso12401799iod.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Aug 2021 12:28:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=jx0kExs6wdQ4eyF+O8UZpjg55SHP0x/R47RYe4pO1Jg=;
 b=cnlnmm5jEcaX+8zW+WSejkVKj0nduwLltebT/qMtowaGCR+RHiHpBF/VdhhDT/Dtlq
 hdCvXd1HKtznA+2bWaWmZjX9fDY+VZnLTDnoWRpoJLt+CLD5HBQ1qeq9a24998lbwwGG
 XINPu6/m86yqEfenasB0uNWBtKwmdk1StlA8Kh6fvPSFY436m1Dx9ZvhB1cVoHPdY4QA
 J0BZyEP4DVP3GHIZK2GEyzOBo596dfU7U7PvH1hqzc9g+fyPi4oH9XJcWDNi7aKWtzpJ
 0fYZ1L5RsprfPc9XNpWjZC1cFy1+d01JC6jNyWRLyOLTJHhqX59EM1tKbveG66fhI5yY
 Bn4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=jx0kExs6wdQ4eyF+O8UZpjg55SHP0x/R47RYe4pO1Jg=;
 b=kHUhkL54wyS779d22e0e1ixEid4vaLrk3pMV6DBrnVrv1I0OnRMMvWBIiig6J0sXwK
 XNcHuRGwPd99DlQhUYf3U4kwenth15gx8K+D5pUU6AMyqHt+opNbho+hcQHNvByzB1yT
 /4b/AnWIj2dJ1ag3Bn7cfVlJAHm5AInKtY8UAsKEaTE1Q5aMx6S0qnYYBiaaFTWoV7rt
 jy4km4ehhmQff+bI8BUTGbdTpSBe8ffXSvsBcQWp/G7cmgeMr5vBA3pERh8K8gxkab+h
 xVMOmS0235c/ccshrKH/WDtKPhEo05LEE2AjFTjD1bKh4RtwBRowA/B3yDzOey4HDwSO
 k2IA==
X-Gm-Message-State: AOAM533AhTJzqEIk6HhKCHFXhbxYYpwqyfPDPdl7WphEsQ3CqrnHfBqH
 u7Pw2UyR6OCgD2Z4nBhcHXAzoGX3ee2r9YlJDMbGf8hxh7lfsMvnFu+5XZo/MEtkqJek2QoufuU
 zKc0x3pzwBGLKDcCreoTeCTfLBE0Ssxf7ukK30KXokcYMnUAMxBcA/TfT9Y32ef55eUc7Ug==
X-Google-Smtp-Source: ABdhPJzTnJVyWDVmpRbXbEdCYT1hqJ9Qs+9K/AwtglpDZFmw11pNZLaqhv7TtM62mzN8+d7RPIBMwsUg3V8=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a02:8206:: with SMTP id
 o6mr16038436jag.92.1627932496528; 
 Mon, 02 Aug 2021 12:28:16 -0700 (PDT)
Date: Mon,  2 Aug 2021 19:28:09 +0000
In-Reply-To: <20210802192809.1851010-1-oupton@google.com>
Message-Id: <20210802192809.1851010-4-oupton@google.com>
Mime-Version: 1.0
References: <20210802192809.1851010-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH v3 3/3] KVM: arm64: Use generic KVM xfer to guest work function
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
 arch/arm64/kvm/arm.c   | 72 ++++++++++++++++++++++++++----------------
 2 files changed, 45 insertions(+), 28 deletions(-)

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
index 60d0a546d7fd..8245efc6e88f 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -6,6 +6,7 @@
 
 #include <linux/bug.h>
 #include <linux/cpu_pm.h>
+#include <linux/entry-kvm.h>
 #include <linux/errno.h>
 #include <linux/err.h>
 #include <linux/kvm_host.h>
@@ -714,6 +715,45 @@ static bool vcpu_mode_is_bad_32bit(struct kvm_vcpu *vcpu)
 		static_branch_unlikely(&arm64_mismatched_32bit_el0);
 }
 
+/**
+ * kvm_vcpu_exit_request - returns true if the VCPU should *not* enter the guest
+ * @vcpu:	The VCPU pointer
+ * @ret:	Pointer to write optional return code
+ *
+ * Returns: true if the VCPU needs to return to a preemptible + interruptible
+ *	    and skip guest entry.
+ *
+ * This function disambiguates between two different types of exits: exits to a
+ * preemptible + interruptible kernel context and exits to userspace. For an
+ * exit to userspace, this function will write the return code to ret and return
+ * true. For an exit to preemptible + interruptible kernel context (i.e. check
+ * for pending work and re-enter), return true without writing to ret.
+ */
+static bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu, int *ret)
+{
+	struct kvm_run *run = vcpu->run;
+
+	/*
+	 * If we're using a userspace irqchip, then check if we need
+	 * to tell a userspace irqchip about timer or PMU level
+	 * changes and if so, exit to userspace (the actual level
+	 * state gets updated in kvm_timer_update_run and
+	 * kvm_pmu_update_run below).
+	 */
+	if (static_branch_unlikely(&userspace_irqchip_in_use)) {
+		if (kvm_timer_should_notify_user(vcpu) ||
+		    kvm_pmu_should_notify_user(vcpu)) {
+			*ret = -EINTR;
+			run->exit_reason = KVM_EXIT_INTR;
+			return true;
+		}
+	}
+
+	return kvm_request_pending(vcpu) ||
+			need_new_vmid_gen(&vcpu->arch.hw_mmu->vmid) ||
+			xfer_to_guest_mode_work_pending();
+}
+
 /**
  * kvm_arch_vcpu_ioctl_run - the main VCPU run function to execute guest code
  * @vcpu:	The VCPU pointer
@@ -757,7 +797,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		/*
 		 * Check conditions before entering the guest
 		 */
-		cond_resched();
+		ret = xfer_to_guest_mode_handle_work(vcpu);
+		if (!ret)
+			ret = 1;
 
 		update_vmid(&vcpu->arch.hw_mmu->vmid);
 
@@ -776,31 +818,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
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
-		/*
-		 * If we're using a userspace irqchip, then check if we need
-		 * to tell a userspace irqchip about timer or PMU level
-		 * changes and if so, exit to userspace (the actual level
-		 * state gets updated in kvm_timer_update_run and
-		 * kvm_pmu_update_run below).
-		 */
-		if (static_branch_unlikely(&userspace_irqchip_in_use)) {
-			if (kvm_timer_should_notify_user(vcpu) ||
-			    kvm_pmu_should_notify_user(vcpu)) {
-				ret = -EINTR;
-				run->exit_reason = KVM_EXIT_INTR;
-			}
-		}
-
 		/*
 		 * Ensure we set mode to IN_GUEST_MODE after we disable
 		 * interrupts and before the final VCPU requests check.
@@ -809,8 +826,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		 */
 		smp_store_mb(vcpu->mode, IN_GUEST_MODE);
 
-		if (ret <= 0 || need_new_vmid_gen(&vcpu->arch.hw_mmu->vmid) ||
-		    kvm_request_pending(vcpu)) {
+		if (ret <= 0 || kvm_vcpu_exit_request(vcpu, &ret)) {
 			vcpu->mode = OUTSIDE_GUEST_MODE;
 			isb(); /* Ensure work in x_flush_hwstate is committed */
 			kvm_pmu_sync_hwstate(vcpu);
-- 
2.32.0.554.ge1b32706d8-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

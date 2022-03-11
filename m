Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31BD1C433FE
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 17:41:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CFD4849EF2;
	Fri, 11 Mar 2022 12:41:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Q50KdAMbRgbP; Fri, 11 Mar 2022 12:41:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5AEB3410F7;
	Fri, 11 Mar 2022 12:41:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B081C40B91
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 12:41:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mmTM+IJuJBsE for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Mar 2022 12:41:09 -0500 (EST)
Received: from mail-io1-f73.google.com (mail-io1-f73.google.com
 [209.85.166.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BE18540C10
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 12:41:08 -0500 (EST)
Received: by mail-io1-f73.google.com with SMTP id
 k10-20020a5d91ca000000b006414a00b160so6719203ior.18
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 09:41:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=9XdJKUFytcHkfxO8A0zHHdaSq5C6RUOo0dHsNroWzi4=;
 b=iBYHZZIu4+glns+DBM+1sLjFX7LQFA3zP0tDyNnFwpnRI/lNEol8HGFtx6Y2+Mi7ZK
 bQtPSTWOAKYg0fLgu1VqZ6kbC9RU/AJW6FF/ihA6uwiYBOHi1mk8SMwigIy/2ixjySNR
 tPuIxyMPycs0AUgDQulOYiG6DlF4YTQTc3sq37NMQn+Ohtd7drMQyK77PNolcn2BeeOV
 qzyTOTnZmWjZ6VaMTWv36WU9dPNOA1B5S+XBQqnCsDEK/FRqSBALFbxs5m91dBcFGMae
 y4S1v/2F5Sil92fkkuNmvMeX1cSkC8BFJL67AirOBoNyu1OH5kEKaDoVbtFCenBSFAzW
 w4uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=9XdJKUFytcHkfxO8A0zHHdaSq5C6RUOo0dHsNroWzi4=;
 b=SPkPvLkpgZOvO6W67SKa+VuxJzA4JKWTkTHUsRU8KAlaNNOUQyyFX34+a5K1pvfGi/
 cweiG5ARitE/ExA45ZVmCZDPFc+yoneV+msbprQyxz2LPInA7hMX2MCXksw+fyTVbKqi
 DTsChV3WUB4tHEotl063q17+AmTt+vrW+SG7QWsYieArGrO/8UFMueDPa1NwHbwCIAFH
 3n077YR33JKoo+Yeql4TRQ2QfBscMs8dlYSFElu/9SoGy31O5OmYGEBfsLA86RnD1Mnf
 4EPm4lJi+8eCCE9lXUn8HjttoJ2LMlz7Uw6fuW1zTXQ89yGH/ljOQEX4aEIhK82qmWcX
 iL/w==
X-Gm-Message-State: AOAM5338mCi4siZaQEsSCZ2iPkuzC74tXxadNkvuNzPMKCA8V63l9IUS
 6TxDu3hCAX12Z/hRPkWnZsuRMG9cKb7EZF8Gp4GH32smTb4hPaBpS2koJRe5bXyfbnqLzBtX15k
 ry9gIG+2m/XCPQrDcjnjxK+bKBGkzY4Qwv8uJ60njTGG3FeQ59KcWzOPXgmX41nxRKIJf1w==
X-Google-Smtp-Source: ABdhPJy0gVFdG3BgjTaM6i8MVhqzhgFYYyl2pWvpkR0CNXcn7tlc65SXQKYNv9FC9ebaoIoCLgIk9P8Y8yM=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:1569:b0:2be:ffc9:8bb4
 with SMTP id
 k9-20020a056e02156900b002beffc98bb4mr9168928ilu.229.1647020468144; Fri, 11
 Mar 2022 09:41:08 -0800 (PST)
Date: Fri, 11 Mar 2022 17:39:53 +0000
In-Reply-To: <20220311174001.605719-1-oupton@google.com>
Message-Id: <20220311174001.605719-8-oupton@google.com>
Mime-Version: 1.0
References: <20220311174001.605719-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v4 07/15] KVM: Create helper for setting a system event exit
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, wanpengli@tencent.com, kvm@vger.kernel.org, joro@8bytes.org,
 pshier@google.com, kvm-riscv@lists.infradead.org, atishp@atishpatra.org,
 pbonzini@redhat.com, vkuznets@redhat.com, jmattson@google.com
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

Create a helper that appropriately configures kvm_run for a system event
exit.

No functional change intended.

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oupton@google.com>
Acked-by: Anup Patel <anup@brainfault.org>
---
 arch/arm64/kvm/psci.c         | 5 +----
 arch/riscv/kvm/vcpu_sbi_v01.c | 4 +---
 arch/x86/kvm/x86.c            | 6 ++----
 include/linux/kvm_host.h      | 2 ++
 virt/kvm/kvm_main.c           | 8 ++++++++
 5 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index efd4428fda1c..78266716165e 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -173,10 +173,7 @@ static void kvm_prepare_system_event(struct kvm_vcpu *vcpu, u32 type, u64 flags)
 		tmp->arch.mp_state.mp_state = KVM_MP_STATE_STOPPED;
 	kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
 
-	memset(&vcpu->run->system_event, 0, sizeof(vcpu->run->system_event));
-	vcpu->run->system_event.type = type;
-	vcpu->run->system_event.flags = flags;
-	vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
+	kvm_vcpu_set_system_event_exit(vcpu, type, flags);
 }
 
 static void kvm_psci_system_off(struct kvm_vcpu *vcpu)
diff --git a/arch/riscv/kvm/vcpu_sbi_v01.c b/arch/riscv/kvm/vcpu_sbi_v01.c
index 07e2de14433a..c5581008dd88 100644
--- a/arch/riscv/kvm/vcpu_sbi_v01.c
+++ b/arch/riscv/kvm/vcpu_sbi_v01.c
@@ -24,9 +24,7 @@ static void kvm_sbi_system_shutdown(struct kvm_vcpu *vcpu,
 		tmp->arch.power_off = true;
 	kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
 
-	memset(&run->system_event, 0, sizeof(run->system_event));
-	run->system_event.type = type;
-	run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
+	kvm_vcpu_set_system_event_exit(vcpu, type, 0);
 }
 
 static int kvm_sbi_ext_v01_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7131d735b1ef..b3b94408cc61 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9903,14 +9903,12 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		if (kvm_check_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu))
 			kvm_vcpu_reload_apic_access_page(vcpu);
 		if (kvm_check_request(KVM_REQ_HV_CRASH, vcpu)) {
-			vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
-			vcpu->run->system_event.type = KVM_SYSTEM_EVENT_CRASH;
+			kvm_vcpu_set_system_event_exit(vcpu, KVM_SYSTEM_EVENT_CRASH, 0);
 			r = 0;
 			goto out;
 		}
 		if (kvm_check_request(KVM_REQ_HV_RESET, vcpu)) {
-			vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
-			vcpu->run->system_event.type = KVM_SYSTEM_EVENT_RESET;
+			kvm_vcpu_set_system_event_exit(vcpu, KVM_SYSTEM_EVENT_RESET, 0);
 			r = 0;
 			goto out;
 		}
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f11039944c08..c2a4fd2382e2 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2202,6 +2202,8 @@ static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
 }
 #endif /* CONFIG_KVM_XFER_TO_GUEST_WORK */
 
+void kvm_vcpu_set_system_event_exit(struct kvm_vcpu *vcpu, u32 type, u64 flags);
+
 /*
  * This defines how many reserved entries we want to keep before we
  * kick the vcpu to the userspace to avoid dirty ring full.  This
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 58d31da8a2f7..197bae04ca34 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3194,6 +3194,14 @@ void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn)
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_mark_page_dirty);
 
+void kvm_vcpu_set_system_event_exit(struct kvm_vcpu *vcpu, u32 type, u64 flags)
+{
+	memset(&vcpu->run->system_event, 0, sizeof(vcpu->run->system_event));
+	vcpu->run->system_event.type = type;
+	vcpu->run->system_event.flags = flags;
+	vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
+}
+
 void kvm_sigset_activate(struct kvm_vcpu *vcpu)
 {
 	if (!vcpu->sigset_active)
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

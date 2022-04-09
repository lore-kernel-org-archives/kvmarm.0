Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AB19C433EF
	for <kvmarm@archiver.kernel.org>; Sat,  9 Apr 2022 18:46:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 081664B130;
	Sat,  9 Apr 2022 14:46:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YLZlCUU9u57G; Sat,  9 Apr 2022 14:46:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD2964B1F4;
	Sat,  9 Apr 2022 14:46:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DA7A4B0C5
 for <kvmarm@lists.cs.columbia.edu>; Sat,  9 Apr 2022 14:46:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id B6wlwNLzxRo7 for <kvmarm@lists.cs.columbia.edu>;
 Sat,  9 Apr 2022 14:46:05 -0400 (EDT)
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com
 [209.85.166.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1D14C4B0EF
 for <kvmarm@lists.cs.columbia.edu>; Sat,  9 Apr 2022 14:46:05 -0400 (EDT)
Received: by mail-il1-f201.google.com with SMTP id
 i14-20020a056e020ece00b002ca198245e6so7669943ilk.4
 for <kvmarm@lists.cs.columbia.edu>; Sat, 09 Apr 2022 11:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=M9iTvBPFeRX7TdT7v6GSKktRRdhWcQUUVDEXOSoZ0MA=;
 b=quNSu1Jjv/0hBISLTOx0rk6fLQBVctF6MgBIRDglBMuaKCYZiquDfV74DSpRqL1IEr
 I5Wxh3kLLdATTFVTSQD+dxB35NCAKxcSAWnlgLXx7bDbHncygYwMz1CR9pRMIpHuIFlX
 Rm1PVwNOyQ9khBnTRrpJo/bsBtstwvicvNoopc735/q/uMuMCwpOb5EvGik5t2nU3fFt
 Fhgr+9svCSuUO0wcNQemmQy2L1uZRTCXNIBz+DthvKtZzgDwQ1Mjz9OmDasimZ9tdJ1r
 rgJbF04fXvOVCzsA3PDZKm/Lul1vh/r2OQlUm9OTVBKbAAAq2eQuvesqZVjIfYhOnL7J
 wz/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=M9iTvBPFeRX7TdT7v6GSKktRRdhWcQUUVDEXOSoZ0MA=;
 b=3LB8tl6bE2FDkGCedY4ylpUle1JPUfKx4pM4Gp8ngPbUGk6fIYArH5k0Mo3TEwVRCi
 beYIfvh7u6ZSDbvcQgQ0HLcZbCQ4BBZtzyHZKb23ZGK5ec8XjJhcsosNpX4hPARFBsEZ
 lztO1FfLP4JaUxw5S3f3Jo4hXFrR934XCF//ihEsbiV/SeQo7eefyHbrhsVZq8ouUq3a
 1n2VKJxkfYST79D1EfOoPMHRrnz1uu6+VRGPZzaK2Qg6pi+uCaPd4entl8Ih7UdpLyLq
 bTNuBJMQzzokdkiW1pHytWcgIrFg3qEHnNzI27N4Fj0HTG3ORCx0dqE4pKSorGFVVfoS
 89Tg==
X-Gm-Message-State: AOAM530QoykcNuTgts00pXOlJcVDeVRLuJXr689Si2vzPdhbOEpJ0SWC
 3JXZ3Igqv2JInePT/SIuu53zM5BqVEvV5fdlizgJqtQZRpS1C47B/AtDrePtHEx8fDEXvdkw8w5
 vh5ldBwbo88ySrIGx3Nj2yFSaDiqcg5+vHI7MAIbGervs1SKJnEiJCmJ4hqwApzn6Z06/Aw==
X-Google-Smtp-Source: ABdhPJxRJ4iysZdXgAeJGHll8zt3PmDZcCVUpZgsAVAZxYWkmHxpJiqPHoxgBXWTE1J7+28LpoIw6iUFAhA=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a6b:7845:0:b0:64c:9acc:9f1a with
 SMTP id
 h5-20020a6b7845000000b0064c9acc9f1amr10560772iop.103.1649529964447; Sat, 09
 Apr 2022 11:46:04 -0700 (PDT)
Date: Sat,  9 Apr 2022 18:45:41 +0000
In-Reply-To: <20220409184549.1681189-1-oupton@google.com>
Message-Id: <20220409184549.1681189-6-oupton@google.com>
Mime-Version: 1.0
References: <20220409184549.1681189-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v5 05/13] KVM: Create helper for setting a system event exit
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
 arch/arm64/kvm/psci.c     | 5 +----
 arch/riscv/kvm/vcpu_sbi.c | 5 +----
 arch/x86/kvm/x86.c        | 6 ++----
 include/linux/kvm_host.h  | 2 ++
 virt/kvm/kvm_main.c       | 8 ++++++++
 5 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index f2f45a3cbe86..362d2a898b83 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -172,10 +172,7 @@ static void kvm_prepare_system_event(struct kvm_vcpu *vcpu, u32 type, u64 flags)
 		tmp->arch.mp_state.mp_state = KVM_MP_STATE_STOPPED;
 	kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
 
-	memset(&vcpu->run->system_event, 0, sizeof(vcpu->run->system_event));
-	vcpu->run->system_event.type = type;
-	vcpu->run->system_event.flags = flags;
-	vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
+	kvm_vcpu_set_system_event_exit(vcpu, type, flags);
 }
 
 static void kvm_psci_system_off(struct kvm_vcpu *vcpu)
diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
index a09ecb97b890..3be9730ae68b 100644
--- a/arch/riscv/kvm/vcpu_sbi.c
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -92,10 +92,7 @@ void kvm_riscv_vcpu_sbi_system_reset(struct kvm_vcpu *vcpu,
 		tmp->arch.power_off = true;
 	kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
 
-	memset(&run->system_event, 0, sizeof(run->system_event));
-	run->system_event.type = type;
-	run->system_event.flags = flags;
-	run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
+	kvm_vcpu_set_system_event_exit(vcpu, type, flags);
 }
 
 int kvm_riscv_vcpu_sbi_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0c0ca599a353..54efc1b4eb28 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10014,14 +10014,12 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
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
index 3f9b22c4983a..f2f66dc0fa6e 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2220,6 +2220,8 @@ static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
 }
 #endif /* CONFIG_KVM_XFER_TO_GUEST_WORK */
 
+void kvm_vcpu_set_system_event_exit(struct kvm_vcpu *vcpu, u32 type, u64 flags);
+
 /*
  * This defines how many reserved entries we want to keep before we
  * kick the vcpu to the userspace to avoid dirty ring full.  This
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e39a6f56fc47..b91f689dd091 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3208,6 +3208,14 @@ void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn)
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
2.35.1.1178.g4f1659d476-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

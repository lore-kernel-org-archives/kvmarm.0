Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FC7EC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 23 Feb 2022 04:19:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C0E44C3DD;
	Tue, 22 Feb 2022 23:19:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8QP2m8kP6ZLf; Tue, 22 Feb 2022 23:19:47 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A5B7A4C318;
	Tue, 22 Feb 2022 23:19:47 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B268D4C2FE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 23:19:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OH1O+pya77TR for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Feb 2022 23:19:45 -0500 (EST)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 70FBE4C2F8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 23:19:45 -0500 (EST)
Received: by mail-yb1-f202.google.com with SMTP id
 l3-20020a25ad43000000b0062462e2af34so11331467ybe.17
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 20:19:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=vrRSzBdHSi7V3M8LBPUg7eNn+Ad6KYDTR0tZbBhvhI4=;
 b=Ti4eLNaNKEsY1Hz/c9AUmIoM+rX+ixTL4QKGgiTqIavDBMEvWRJu3oFrmKpkHgah+N
 Dc3OTM20y9z610wWpUHbFkLRbAHcd64WTxC04T0a/K6CIcLejCkIpRV/T/AZaGrgeDIl
 pz8PiqwoWLCmLYhDtGXKRXFBuTqBC/WNfkHrSHHN3iaY8j2teOyQeEQgSpW8DhpdV8il
 MQTdRy13X8/wKbstARYfVkEkT28hp3i/7hUCRGksunJyBBmHHJQx2akXWel8xS1kF0wF
 b2xSWheIjAgx1inrpk86VBYB6eYbSmmyKiTXlvYdOkx1WhHUGEwD7Du+Cq651agYYLnp
 7XNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=vrRSzBdHSi7V3M8LBPUg7eNn+Ad6KYDTR0tZbBhvhI4=;
 b=J+q1kCm6EgR47LyfbgFtMkEEZ5GQOZ72wjqyfrsUg1bW5zghds4dJEZXcr0LVW6G4Y
 77dUa7boPmx2BlvKOVBM4KDg2vszYndlaIm8fr7OXYz6KpkkS1/7pyhMoaAp8tSJTvgM
 P1yVv1fGqGjhvH41GB+HXaXiKnQbw1iLz7ZQj47faEbr6IH1JgBO/sYUdBRP7YH9SBsb
 r+wLduq462kFomnxW1maUgYPCKC7vsS8A+/GnGDeRsgBsUHll7D7ESoPuS/fTYG+ZuR4
 t1DUA29cbneX8zs+Ywq7zvnvh2hzpTZxQOA5Xl5uu6t8/jBpfoVyPlHo4BPWOkM/CDXy
 LAaQ==
X-Gm-Message-State: AOAM530l0JdFTKtN8pun3BPDYR7H0d8f5VMum56l83aXYnVF/bboY7a0
 7aqwb2qJLRV7CI/zMBFhczLeUpkvQHcdugyi5ywcbJdEU9SGzTtFUpDn3euiGGFSl0vKYuRt05w
 MqMcDjpQQSkoXXqE/8b4F/ha18npSK6VfNNzj68SAIB3YFBBIbc0vR2n27VtzzbhgddB4+g==
X-Google-Smtp-Source: ABdhPJxhrRx+omhNxuOMMvfeMyQjA61TDvdES0DvMmkWkwMsnKt4lqbldcuhKCkGQ1LJ0jFbLaCjLP8bfEU=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a81:6603:0:b0:2d6:d166:8c31 with
 SMTP id
 a3-20020a816603000000b002d6d1668c31mr20735607ywc.351.1645589984900; Tue, 22
 Feb 2022 20:19:44 -0800 (PST)
Date: Wed, 23 Feb 2022 04:18:35 +0000
In-Reply-To: <20220223041844.3984439-1-oupton@google.com>
Message-Id: <20220223041844.3984439-11-oupton@google.com>
Mime-Version: 1.0
References: <20220223041844.3984439-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH v3 10/19] KVM: Create helper for setting a system event exit
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Joerg Roedel <joro@8bytes.org>, Atish Patra <atishp@atishpatra.org>,
 Peter Shier <pshier@google.com>, kvm-riscv@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Jim Mattson <jmattson@google.com>
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
---
 arch/arm64/kvm/psci.c         | 4 +---
 arch/riscv/kvm/vcpu_sbi_v01.c | 4 +---
 arch/x86/kvm/x86.c            | 6 ++----
 include/linux/kvm_host.h      | 7 +++++++
 4 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 41adaaf2234a..2bb8d047cde4 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -193,9 +193,7 @@ static void kvm_prepare_system_event(struct kvm_vcpu *vcpu, u32 type)
 		tmp->arch.mp_state = KVM_MP_STATE_STOPPED;
 	kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
 
-	memset(&vcpu->run->system_event, 0, sizeof(vcpu->run->system_event));
-	vcpu->run->system_event.type = type;
-	vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
+	kvm_vcpu_set_system_event_exit(vcpu, type);
 }
 
 static void kvm_psci_system_off(struct kvm_vcpu *vcpu)
diff --git a/arch/riscv/kvm/vcpu_sbi_v01.c b/arch/riscv/kvm/vcpu_sbi_v01.c
index 07e2de14433a..7a197d5658d7 100644
--- a/arch/riscv/kvm/vcpu_sbi_v01.c
+++ b/arch/riscv/kvm/vcpu_sbi_v01.c
@@ -24,9 +24,7 @@ static void kvm_sbi_system_shutdown(struct kvm_vcpu *vcpu,
 		tmp->arch.power_off = true;
 	kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
 
-	memset(&run->system_event, 0, sizeof(run->system_event));
-	run->system_event.type = type;
-	run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
+	kvm_vcpu_set_system_event_exit(vcpu, type);
 }
 
 static int kvm_sbi_ext_v01_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7131d735b1ef..109751f89ee3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9903,14 +9903,12 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		if (kvm_check_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu))
 			kvm_vcpu_reload_apic_access_page(vcpu);
 		if (kvm_check_request(KVM_REQ_HV_CRASH, vcpu)) {
-			vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
-			vcpu->run->system_event.type = KVM_SYSTEM_EVENT_CRASH;
+			kvm_vcpu_set_system_event_exit(vcpu, KVM_SYSTEM_EVENT_CRASH);
 			r = 0;
 			goto out;
 		}
 		if (kvm_check_request(KVM_REQ_HV_RESET, vcpu)) {
-			vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
-			vcpu->run->system_event.type = KVM_SYSTEM_EVENT_RESET;
+			kvm_vcpu_set_system_event_exit(vcpu, KVM_SYSTEM_EVENT_RESET);
 			r = 0;
 			goto out;
 		}
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f11039944c08..9085a1b1569a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2202,6 +2202,13 @@ static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
 }
 #endif /* CONFIG_KVM_XFER_TO_GUEST_WORK */
 
+static inline void kvm_vcpu_set_system_event_exit(struct kvm_vcpu *vcpu, u32 type)
+{
+	memset(&vcpu->run->system_event, 0, sizeof(vcpu->run->system_event));
+	vcpu->run->system_event.type = type;
+	vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
+}
+
 /*
  * This defines how many reserved entries we want to keep before we
  * kick the vcpu to the userspace to avoid dirty ring full.  This
-- 
2.35.1.473.g83b2b277ed-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

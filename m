Return-Path: <SRS0=ky3n=LC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C411EC47082
	for <kvmarm@archiver.kernel.org>; Tue,  8 Jun 2021 15:54:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5897A6135D
	for <kvmarm@archiver.kernel.org>; Tue,  8 Jun 2021 15:54:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5897A6135D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BE8440CF9;
	Tue,  8 Jun 2021 11:54:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HTtNXdlldPHk; Tue,  8 Jun 2021 11:54:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB6CC49E50;
	Tue,  8 Jun 2021 11:54:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 07CEB40569
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jun 2021 11:54:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 68K1AjSx-L5A for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Jun 2021 11:54:03 -0400 (EDT)
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com
 [209.85.221.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C0D7A4029F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jun 2021 11:54:03 -0400 (EDT)
Received: by mail-wr1-f53.google.com with SMTP id i94so17094570wri.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Jun 2021 08:54:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=luZ2XBy4kIjKsUNN5YLr1hr2hYOSweOt5shsxweZY5c=;
 b=sbCxjbeI/oicVowr1ScpDXLBsVThc8WALV+maymt0+dWYJi+SdK1EjS3CBamvobctn
 oVj9jPoiFl+XFyqVbz7oy3/wgxvfgv4TUhXNsZtIJYnlHpvoajG5yUBb4YDZeadnQyZ6
 FVMM9S8Byjv7mzoU+5SISyAl31bOpdFIzZ//vvWfgeVaD+uvShhJnQfPo+J+Wj1q9caq
 U3Hk1jw15VgUv/U1tleMfSt+xrJk0XKUTYZF7Qb+jytlId0YYKfFcJnS///J517/MU38
 hcdfZin3+XvAGgVk0iRCkX8FCL1xBqvocAV1qiayCXWYGUiFRbLXitgw6SGtGQZndgP9
 UYFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=luZ2XBy4kIjKsUNN5YLr1hr2hYOSweOt5shsxweZY5c=;
 b=iNPAe030mX/RhhfXjRzm9R/Sg1cSmrQJbH761eevPeD3PZBXxify+wb1UJtYlvE0yH
 1Up4wOpmW2eWzqrTVGqrTlrx5OR1m4zI4eVX37C1w+HwvQ9oO/yhbewX48Aha/G9QS0K
 LFReVPNFozQAy2tQIgu6gf/K30CtXCeAyvFe6lxm+dUQmz3hQ4unvvssywIPrV+YW1uK
 xS3GQQNN673U91L6Fm012ctdokCuCbaCBJ8wbKsmvll9jn9zJd/V3L/nWb9rPSJSg0/D
 wYqOUNyFhVvoTrAhhO4hggZ/so7EPuePEAgqkTsCTXRnOqvixQiGplV/NqHFuMGGl2ug
 KYWA==
X-Gm-Message-State: AOAM5308ZeGnYtMIsz/HWZbsu1cZDMeVqNZ9044YXeSfK3wPVaVKWWOl
 wfu91TKHeDwOJqtX4XhkoNH6xA==
X-Google-Smtp-Source: ABdhPJzkPP5/N5I0QEPYl+or03a+RJK+q3fbfrxy8aomfkBbcwKtQQDp8ZjdsnAAKwnqh5+OZC4YyA==
X-Received: by 2002:a5d:4a4b:: with SMTP id v11mr23583559wrs.246.1623167642648; 
 Tue, 08 Jun 2021 08:54:02 -0700 (PDT)
Received: from localhost.localdomain (adsl-84-226-111-173.adslplus.ch.
 [84.226.111.173])
 by smtp.gmail.com with ESMTPSA id l31sm3314180wms.16.2021.06.08.08.54.01
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 08 Jun 2021 08:54:02 -0700 (PDT)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: maz@kernel.org
Subject: [RFC PATCH 2/5] KVM: arm64: Move WFI execution to
 check_vcpu_requests()
Date: Tue,  8 Jun 2021 17:48:03 +0200
Message-Id: <20210608154805.216869-3-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210608154805.216869-1-jean-philippe@linaro.org>
References: <20210608154805.216869-1-jean-philippe@linaro.org>
MIME-Version: 1.0
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>, salil.mehta@huawei.com,
 lorenzo.pieralisi@arm.com, kvm@vger.kernel.org, corbet@lwn.net,
 catalin.marinas@arm.com, linux-kernel@vger.kernel.org, will@kernel.org,
 jonathan.cameron@huawei.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu,
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

Prepare for WFI requests from userspace, by adding a suspend request and
moving the WFI execution into check_vcpu_requests(), next to the
power-off logic.

vcpu->arch.mp_state, previously only RUNNABLE or STOPPED, supports an
additional state HALTED and two new state transitions:

  RUNNABLE -> HALTED	from WFI or PSCI CPU_SUSPEND (same vCPU)
  HALTED -> RUNNABLE	vGIC IRQ, pending timer, signal

There shouldn't be any functional change with this patch, even though
the KVM_GET_MP_STATE ioctl could now in theory return
KVM_MP_STATE_HALTED, which would break some users' mp_state support. In
practice it should not happen because we do not return to userspace with
HALTED state. Both WFI and PSCI CPU_SUSPEND stay in the vCPU run loop
until the suspend request is consumed. It does feel fragile though,
maybe we should explicitly return RUNNABLE in KVM_GET_MP_STATE in place
of HALTED, to prevent future breakage.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/kvm/arm.c              | 18 ++++++++++++++-
 arch/arm64/kvm/handle_exit.c      |  3 +--
 arch/arm64/kvm/psci.c             | 37 +++++++++++++------------------
 4 files changed, 35 insertions(+), 25 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 55a04f4d5919..3ca732feb9a5 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -46,6 +46,7 @@
 #define KVM_REQ_VCPU_RESET	KVM_ARCH_REQ(2)
 #define KVM_REQ_RECORD_STEAL	KVM_ARCH_REQ(3)
 #define KVM_REQ_RELOAD_GICv4	KVM_ARCH_REQ(4)
+#define KVM_REQ_SUSPEND		KVM_ARCH_REQ(5)
 
 #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
 				     KVM_DIRTY_LOG_INITIALLY_SET)
@@ -722,6 +723,7 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
 			       struct kvm_device_attr *attr);
 void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu);
 bool kvm_arm_vcpu_is_off(struct kvm_vcpu *vcpu);
+void kvm_arm_vcpu_suspend(struct kvm_vcpu *vcpu);
 
 /* Guest/host FPSIMD coordination helpers */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index bcc24adb9c0a..d8cbaa0373c7 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -447,6 +447,12 @@ bool kvm_arm_vcpu_is_off(struct kvm_vcpu *vcpu)
 	return vcpu->arch.mp_state == KVM_MP_STATE_STOPPED;
 }
 
+void kvm_arm_vcpu_suspend(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.mp_state = KVM_MP_STATE_HALTED;
+	kvm_make_request(KVM_REQ_SUSPEND, vcpu);
+}
+
 int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
 				    struct kvm_mp_state *mp_state)
 {
@@ -667,6 +673,8 @@ static int kvm_vcpu_initialized(struct kvm_vcpu *vcpu)
 
 static void check_vcpu_requests(struct kvm_vcpu *vcpu)
 {
+	bool irq_pending;
+
 	if (kvm_request_pending(vcpu)) {
 		if (kvm_check_request(KVM_REQ_SLEEP, vcpu))
 			vcpu_req_sleep(vcpu);
@@ -678,7 +686,7 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
 		 * Clear IRQ_PENDING requests that were made to guarantee
 		 * that a VCPU sees new virtual interrupts.
 		 */
-		kvm_check_request(KVM_REQ_IRQ_PENDING, vcpu);
+		irq_pending = kvm_check_request(KVM_REQ_IRQ_PENDING, vcpu);
 
 		if (kvm_check_request(KVM_REQ_RECORD_STEAL, vcpu))
 			kvm_update_stolen_time(vcpu);
@@ -690,6 +698,14 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
 			vgic_v4_load(vcpu);
 			preempt_enable();
 		}
+
+		if (kvm_check_request(KVM_REQ_SUSPEND, vcpu)) {
+			if (!irq_pending) {
+				kvm_vcpu_block(vcpu);
+				kvm_clear_request(KVM_REQ_UNHALT, vcpu);
+			}
+			vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
+		}
 	}
 }
 
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 6f48336b1d86..9717df3104cf 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -95,8 +95,7 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu)
 	} else {
 		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), false);
 		vcpu->stat.wfi_exit_stat++;
-		kvm_vcpu_block(vcpu);
-		kvm_clear_request(KVM_REQ_UNHALT, vcpu);
+		kvm_arm_vcpu_suspend(vcpu);
 	}
 
 	kvm_incr_pc(vcpu);
diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 24b4a2265dbd..42a307ceb95f 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -31,27 +31,6 @@ static unsigned long psci_affinity_mask(unsigned long affinity_level)
 	return 0;
 }
 
-static unsigned long kvm_psci_vcpu_suspend(struct kvm_vcpu *vcpu)
-{
-	/*
-	 * NOTE: For simplicity, we make VCPU suspend emulation to be
-	 * same-as WFI (Wait-for-interrupt) emulation.
-	 *
-	 * This means for KVM the wakeup events are interrupts and
-	 * this is consistent with intended use of StateID as described
-	 * in section 5.4.1 of PSCI v0.2 specification (ARM DEN 0022A).
-	 *
-	 * Further, we also treat power-down request to be same as
-	 * stand-by request as-per section 5.4.2 clause 3 of PSCI v0.2
-	 * specification (ARM DEN 0022A). This means all suspend states
-	 * for KVM will preserve the register state.
-	 */
-	kvm_vcpu_block(vcpu);
-	kvm_clear_request(KVM_REQ_UNHALT, vcpu);
-
-	return PSCI_RET_SUCCESS;
-}
-
 static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 {
 	struct vcpu_reset_state *reset_state;
@@ -227,7 +206,21 @@ static int kvm_psci_0_2_call(struct kvm_vcpu *vcpu)
 		break;
 	case PSCI_0_2_FN_CPU_SUSPEND:
 	case PSCI_0_2_FN64_CPU_SUSPEND:
-		val = kvm_psci_vcpu_suspend(vcpu);
+		/*
+		 * NOTE: For simplicity, we make VCPU suspend emulation to be
+		 * same-as WFI (Wait-for-interrupt) emulation.
+		 *
+		 * This means for KVM the wakeup events are interrupts and this
+		 * is consistent with intended use of StateID as described in
+		 * section 5.4.1 of PSCI v0.2 specification (ARM DEN 0022A).
+		 *
+		 * Further, we also treat power-down request to be same as
+		 * stand-by request as-per section 5.4.2 clause 3 of PSCI v0.2
+		 * specification (ARM DEN 0022A). This means all suspend states
+		 * for KVM will preserve the register state.
+		 */
+		kvm_arm_vcpu_suspend(vcpu);
+		val = PSCI_RET_SUCCESS;
 		break;
 	case PSCI_0_2_FN_CPU_OFF:
 		kvm_arm_vcpu_power_off(vcpu);
-- 
2.31.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

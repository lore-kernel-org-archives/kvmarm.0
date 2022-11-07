Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA03BC43217
	for <kvmarm@archiver.kernel.org>; Mon,  7 Nov 2022 08:55:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 85C284B8B9;
	Mon,  7 Nov 2022 03:55:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Q9HiMe7AAKhb; Mon,  7 Nov 2022 03:55:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BC4B4B8F7;
	Mon,  7 Nov 2022 03:55:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 41ADF4B8BC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 03:55:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6ND9bCArPzqt for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Nov 2022 03:55:00 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EB6C44B887
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 03:54:59 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 7969560F2E;
 Mon,  7 Nov 2022 08:54:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BAE9C43144;
 Mon,  7 Nov 2022 08:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1667811299;
 bh=+0uL2LsE517XXiRSnYb+8lBrywGyDTjttJ4tHMrTfgQ=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=bs/C9zjRSHX1vgSIXCSeXFqAHTrSqLYQe1tf62vZr2hwzMr+g8jlpXj2TyFIAi/Sm
 NwcKzkBoUvuWPCRtjMcDlGnCfTPwVeCTfkGwtbf0XtbqfA1taTI726uYLT//c3ItA8
 rMJpfYpWpH6Aqm1rQKfgchjGoEbpzOtTL/MuGhsdv5HPEQQfRc76I1zZkjwVPksuAL
 n44Pa8n4Qsc8Ez7DcSF3x3xislDf5VNzmJ1zvCa4u2ZJYKqB+DycW8F8M92BYFQyq4
 pIO75ZR+TEaBUL88Kut1VSm7rLT6FnZ2TG8QrqMQ8iLKld5ANVEn/6jgyUaiF/gk/7
 w9X1lL9LfFe/Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1orxuD-004KxX-H1;
 Mon, 07 Nov 2022 08:54:57 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, <kvmarm@lists.cs.columbia.edu>,
 <kvmarm@lists.linux.dev>, kvm@vger.kernel.org
Subject: [PATCH v3 09/14] KVM: arm64: PMU: Do not let AArch32 change the
 counters' top 32 bits
Date: Mon,  7 Nov 2022 08:54:30 +0000
Message-Id: <20221107085435.2581641-10-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221107085435.2581641-1-maz@kernel.org>
References: <20221107085435.2581641-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
 oliver.upton@linux.dev, ricarkol@google.com, reijiw@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
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

Even when using PMUv3p5 (which implies 64bit counters), there is
no way for AArch32 to write to the top 32 bits of the counters.
The only way to influence these bits (other than by counting
events) is by writing PMCR.P==1.

Make sure we obey the architecture and preserve the top 32 bits
on a counter update.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/pmu-emul.c | 35 +++++++++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 03b761a63f5f..87585c12ca41 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -119,13 +119,8 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
 	return counter;
 }
 
-/**
- * kvm_pmu_set_counter_value - set PMU counter value
- * @vcpu: The vcpu pointer
- * @select_idx: The counter index
- * @val: The counter value
- */
-void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
+static void kvm_pmu_set_counter(struct kvm_vcpu *vcpu, u64 select_idx, u64 val,
+				bool force)
 {
 	u64 reg;
 
@@ -135,12 +130,36 @@ void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
 	kvm_pmu_release_perf_event(&vcpu->arch.pmu.pmc[select_idx]);
 
 	reg = counter_index_to_reg(select_idx);
+
+	if (vcpu_mode_is_32bit(vcpu) && select_idx != ARMV8_PMU_CYCLE_IDX &&
+	    !force) {
+		/*
+		 * Even with PMUv3p5, AArch32 cannot write to the top
+		 * 32bit of the counters. The only possible course of
+		 * action is to use PMCR.P, which will reset them to
+		 * 0 (the only use of the 'force' parameter).
+		 */
+		val  = lower_32_bits(val);
+		val |= upper_32_bits(__vcpu_sys_reg(vcpu, reg));
+	}
+
 	__vcpu_sys_reg(vcpu, reg) = val;
 
 	/* Recreate the perf event to reflect the updated sample_period */
 	kvm_pmu_create_perf_event(vcpu, select_idx);
 }
 
+/**
+ * kvm_pmu_set_counter_value - set PMU counter value
+ * @vcpu: The vcpu pointer
+ * @select_idx: The counter index
+ * @val: The counter value
+ */
+void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
+{
+	kvm_pmu_set_counter(vcpu, select_idx, val, false);
+}
+
 /**
  * kvm_pmu_release_perf_event - remove the perf event
  * @pmc: The PMU counter pointer
@@ -535,7 +554,7 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 		unsigned long mask = kvm_pmu_valid_counter_mask(vcpu);
 		mask &= ~BIT(ARMV8_PMU_CYCLE_IDX);
 		for_each_set_bit(i, &mask, 32)
-			kvm_pmu_set_counter_value(vcpu, i, 0);
+			kvm_pmu_set_counter(vcpu, i, 0, true);
 	}
 }
 
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

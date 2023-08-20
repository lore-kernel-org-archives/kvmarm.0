Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A16310F1
	for <kvmarm@lists.linux.dev>; Sun, 20 Aug 2023 09:01:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96041C433C7;
	Sun, 20 Aug 2023 09:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1692522074;
	bh=sh2Jxhg7UZZpCM0KqBWmx0YnZ14DknUZGfxDz8jBCHw=;
	h=From:To:Cc:Subject:Date:From;
	b=d2+4vXdpveoMcqd/vSO+UpagDRuC2WKT5/JQ+aURaKB4o1sSZzRYFStnbxv8A3yRz
	 1L/qkN9N2aMpg98jUxiGnYF1lLLOmoZW5lbBFhA+PlsnNlz8B8DjAINYIbvy6F9X9z
	 oG2EMvuUcYUbaQNat4089lKvo88QjIORbDysh3u044eLVVJq0w+g6v7YK1GCuAmi9Y
	 klks+s8wIaRZjhoaCd5xCcjjDpOFdtnXTYLDbYB+w5ZQKxoViaka4OetRabfx5OTZX
	 vDgUPV3EZZaB6mpFS0StTvMGgbOHmRL7rAUMn2NDH1cNLPE6wQNw4YxjnEk0MWybmK
	 M0X9UZP27wRfQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=wait-a-minute.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1qXeJ6-006Oo3-18;
	Sun, 20 Aug 2023 10:01:12 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Huang Shijie <shijie@os.amperecomputing.com>,
	Leo Yan <leo.yan@linaro.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v2] KVM: arm64: pmu: Resync EL0 state on counter rotation
Date: Sun, 20 Aug 2023 10:01:08 +0100
Message-Id: <20230820090108.177817-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, shijie@os.amperecomputing.com, leo.yan@linaro.org, mark.rutland@arm.com, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Huang Shijie reports that, when profiling a guest from the host
with a number of events that exceeds the number of available
counters, the reported counts are wildly inaccurate. Without
the counter oversubscription, the reported counts are correct.

Their investigation indicates that upon counter rotation (which
takes place on the back of a timer interrupt), we fail to
re-apply the guest EL0 enabling, leading to the counting of host
events instead of guest events.

In order to solve this, add yet another hook between the host PMU
driver and KVM, re-applying the guest EL0 configuration if the
right conditions apply (the host is VHE, we are in interrupt
context, and we interrupted a running vcpu). This triggers a new
vcpu request which will apply the correct configuration on guest
reentry.

With this, we have the correct counts, even when the counters are
oversubscribed.

Reported-by: Huang Shijie <shijie@os.amperecomputing.com>
Suggested-by: Oliver Upton <oliver.upton@linux.dev>
Tested_by: Huang Shijie <shijie@os.amperecomputing.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20230809013953.7692-1-shijie@os.amperecomputing.com
---

Notes:
    V2: Fixed 32bit compilation

 arch/arm/include/asm/arm_pmuv3.h  |  2 ++
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/arm.c              |  3 +++
 arch/arm64/kvm/pmu.c              | 18 ++++++++++++++++++
 drivers/perf/arm_pmuv3.c          |  2 ++
 include/kvm/arm_pmu.h             |  2 ++
 6 files changed, 28 insertions(+)

diff --git a/arch/arm/include/asm/arm_pmuv3.h b/arch/arm/include/asm/arm_pmuv3.h
index f3cd04ff022d..72529f5e2bed 100644
--- a/arch/arm/include/asm/arm_pmuv3.h
+++ b/arch/arm/include/asm/arm_pmuv3.h
@@ -227,6 +227,8 @@ static inline bool kvm_set_pmuserenr(u64 val)
 	return false;
 }
 
+static inline void kvm_vcpu_pmu_resync_el0(void) {}
+
 /* PMU Version in DFR Register */
 #define ARMV8_PMU_DFR_VER_NI        0
 #define ARMV8_PMU_DFR_VER_V3P4      0x5
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index d3dd05bbfe23..553040e0e375 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -49,6 +49,7 @@
 #define KVM_REQ_RELOAD_GICv4	KVM_ARCH_REQ(4)
 #define KVM_REQ_RELOAD_PMU	KVM_ARCH_REQ(5)
 #define KVM_REQ_SUSPEND		KVM_ARCH_REQ(6)
+#define KVM_REQ_RESYNC_PMU_EL0	KVM_ARCH_REQ(7)
 
 #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
 				     KVM_DIRTY_LOG_INITIALLY_SET)
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 72dc53a75d1c..978b0411082f 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -803,6 +803,9 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
 			kvm_pmu_handle_pmcr(vcpu,
 					    __vcpu_sys_reg(vcpu, PMCR_EL0));
 
+		if (kvm_check_request(KVM_REQ_RESYNC_PMU_EL0, vcpu))
+			kvm_vcpu_pmu_restore_guest(vcpu);
+
 		if (kvm_check_request(KVM_REQ_SUSPEND, vcpu))
 			return kvm_vcpu_suspend(vcpu);
 
diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 121f1a14c829..0eea225fd09a 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -236,3 +236,21 @@ bool kvm_set_pmuserenr(u64 val)
 	ctxt_sys_reg(hctxt, PMUSERENR_EL0) = val;
 	return true;
 }
+
+/*
+ * If we interrupted the guest to update the host PMU context, make
+ * sure we re-apply the guest EL0 state.
+ */
+void kvm_vcpu_pmu_resync_el0(void)
+{
+	struct kvm_vcpu *vcpu;
+
+	if (!has_vhe() || !in_interrupt())
+		return;
+
+	vcpu = kvm_get_running_vcpu();
+	if (!vcpu)
+		return;
+
+	kvm_make_request(KVM_REQ_RESYNC_PMU_EL0, vcpu);
+}
diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
index 08b3a1bf0ef6..6a3d8176f54a 100644
--- a/drivers/perf/arm_pmuv3.c
+++ b/drivers/perf/arm_pmuv3.c
@@ -772,6 +772,8 @@ static void armv8pmu_start(struct arm_pmu *cpu_pmu)
 
 	/* Enable all counters */
 	armv8pmu_pmcr_write(armv8pmu_pmcr_read() | ARMV8_PMU_PMCR_E);
+
+	kvm_vcpu_pmu_resync_el0();
 }
 
 static void armv8pmu_stop(struct arm_pmu *cpu_pmu)
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 847da6fc2713..3a8a70a60794 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -74,6 +74,7 @@ int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu);
 struct kvm_pmu_events *kvm_get_pmu_events(void);
 void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu);
 void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
+void kvm_vcpu_pmu_resync_el0(void);
 
 #define kvm_vcpu_has_pmu(vcpu)					\
 	(test_bit(KVM_ARM_VCPU_PMU_V3, (vcpu)->arch.features))
@@ -171,6 +172,7 @@ static inline u8 kvm_arm_pmu_get_pmuver_limit(void)
 {
 	return 0;
 }
+static inline void kvm_vcpu_pmu_resync_el0(void) {}
 
 #endif
 
-- 
2.39.2


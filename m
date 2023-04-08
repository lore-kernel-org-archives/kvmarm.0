Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18ADC1841
	for <kvmarm@lists.linux.dev>; Sat,  8 Apr 2023 03:50:04 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id 184-20020a2515c1000000b009419f64f6afso629663ybv.2
        for <kvmarm@lists.linux.dev>; Fri, 07 Apr 2023 20:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680925803; x=1683517803;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DVyCnj9MsgT2gsR7e3u087HLDuT+lFbQ8wpGn1PCyY8=;
        b=bMzztl++BoxzD0jfOIJzKDjn9QXopp4FEjBZBoErtKInqA2ibekx4/1zj1l0CBGXmH
         N5YQX4LCLiwT1vid3je3dWedfXjTq8I4Bbhqnq3M0RDVclxySyIs0R4NlPYi+RMnMmwh
         XlDTggjdF5V7SThMmLtIB7Qfxi09ZWSlb3j6tAtiKIKPuicshrUbzHR/Xwr40rUq1ZEo
         4YcxfXewagN2HeAwOVEuvWDkKQvshKe9/YBgyZtlCX/mSqAafCQVgDgoopU9v15NPBza
         TiCQiruWJkYyQCmU5QmRKUjiyAe1/wIcUcVAQZXjBBTv/H0vCPjuPxIP7SsPDMiSvCfg
         mV3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680925803; x=1683517803;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DVyCnj9MsgT2gsR7e3u087HLDuT+lFbQ8wpGn1PCyY8=;
        b=6vIiAG+Fy+Lq4pc0l9PjKXx8hNc/oMQeWDEPVA5fHhz7gacxqST+Bwycnmqd6uXrXk
         t/jxwgwj6s/aUuc1h4hroVs6/vBKBLIMZ4Am9knG60Yoj2z9fAj1DH2DH3RT2DRm1vHO
         OBmrUSfZTs0ONJDQomDJMwJeMP6I/wUh4hIpD3BP/yuecUY3GwMJb4peWTjFyxRqI9KN
         DfTDebo8kYUIU7rs9Xs70Tga7u9j5jqtM5g2UV48PykV9m+h6ILojQnnyh9ynu2x5YsS
         UKYk8nL6V6exsoS9OuQZ3lkJi9vcJMI7NBAN1OU4E2fUe5t4mIr7DaL6C4GjhKZBh6kg
         enuA==
X-Gm-Message-State: AAQBX9ehpbHXNmkxMxPWfLerN7Yvdl2Q1bqnWSuEomHzslPKNQCefbMw
	al9v4jdf/P23LoAVTNglWLvbRYwARGk=
X-Google-Smtp-Source: AKy350Y+PbYF40vl+ixnb0m4xqErgoFnHFSj2RsUTGKQeqQhI/G2CUtp/kJ7sXp2+MA0ejuWfd9siouXqzg=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:740f:0:b0:b09:6f3d:ea1f with SMTP id
 p15-20020a25740f000000b00b096f3dea1fmr3081666ybc.4.1680925803168; Fri, 07 Apr
 2023 20:50:03 -0700 (PDT)
Date: Fri,  7 Apr 2023 20:47:59 -0700
In-Reply-To: <20230408034759.2369068-1-reijiw@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230408034759.2369068-1-reijiw@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230408034759.2369068-3-reijiw@google.com>
Subject: [PATCH v2 2/2] KVM: arm64: PMU: Don't overwrite PMUSERENR with vcpu loaded
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Jing Zhang <jingzhangos@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Rob Herring <robh@kernel.org>, 
	Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"

Currently, with VHE, KVM sets ER, CR, SW and EN bits of
PMUSERENR_EL0 to 1 on vcpu_load(), and saves and restores
the register value for the host on vcpu_load() and vcpu_put().
If the value of those bits are cleared on a pCPU with a vCPU
loaded (armv8pmu_start() would do that when PMU counters are
programmed for the guest), PMU access from the guest EL0 might
be trapped to the guest EL1 directly regardless of the current
PMUSERENR_EL0 value of the vCPU.

Fix this by not letting armv8pmu_start() overwrite PMUSERENR on
the pCPU on which a vCPU is loaded, and instead updating the
saved shadow register value for the host, so that the value can
be restored on vcpu_put() later.

Suggested-by: Mark Rutland <mark.rutland@arm.com>
Suggested-by: Marc Zyngier <maz@kernel.org>
Fixes: 83a7a4d643d3 ("arm64: perf: Enable PMU counter userspace access for perf event")
Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  5 +++++
 arch/arm64/kernel/perf_event.c    | 21 ++++++++++++++++++---
 arch/arm64/kvm/pmu.c              | 20 ++++++++++++++++++++
 3 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index bcd774d74f34..22db2f885c17 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1028,9 +1028,14 @@ void kvm_arch_vcpu_put_debug_state_flags(struct kvm_vcpu *vcpu);
 #ifdef CONFIG_KVM
 void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr);
 void kvm_clr_pmu_events(u32 clr);
+bool kvm_set_pmuserenr(u64 val);
 #else
 static inline void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr) {}
 static inline void kvm_clr_pmu_events(u32 clr) {}
+static inline bool kvm_set_pmuserenr(u64 val)
+{
+	return false;
+}
 #endif
 
 void kvm_vcpu_load_sysregs_vhe(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
index dde06c0f97f3..0fffe4c56c28 100644
--- a/arch/arm64/kernel/perf_event.c
+++ b/arch/arm64/kernel/perf_event.c
@@ -741,9 +741,25 @@ static inline u32 armv8pmu_getreset_flags(void)
 	return value;
 }
 
+static void update_pmuserenr(u64 val)
+{
+	lockdep_assert_irqs_disabled();
+
+	/*
+	 * The current pmuserenr value might be the value for the guest.
+	 * If that's the case, have KVM keep tracking of the register value
+	 * for the host EL0 so that KVM can restore it before returning to
+	 * the host EL0. Otherwise, update the register now.
+	 */
+	if (kvm_set_pmuserenr(val))
+		return;
+
+	write_sysreg(val, pmuserenr_el0);
+}
+
 static void armv8pmu_disable_user_access(void)
 {
-	write_sysreg(0, pmuserenr_el0);
+	update_pmuserenr(0);
 }
 
 static void armv8pmu_enable_user_access(struct arm_pmu *cpu_pmu)
@@ -759,8 +775,7 @@ static void armv8pmu_enable_user_access(struct arm_pmu *cpu_pmu)
 			armv8pmu_write_evcntr(i, 0);
 	}
 
-	write_sysreg(0, pmuserenr_el0);
-	write_sysreg(ARMV8_PMU_USERENR_ER | ARMV8_PMU_USERENR_CR, pmuserenr_el0);
+	update_pmuserenr(ARMV8_PMU_USERENR_ER | ARMV8_PMU_USERENR_CR);
 }
 
 static void armv8pmu_enable_event(struct perf_event *event)
diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 7887133d15f0..40bb2cb13317 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -209,3 +209,23 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu)
 	kvm_vcpu_pmu_enable_el0(events_host);
 	kvm_vcpu_pmu_disable_el0(events_guest);
 }
+
+/*
+ * With VHE, keep track of the PMUSERENR_EL0 value for the host EL0 on
+ * the pCPU where vCPU is loaded, since PMUSERENR_EL0 is switched to
+ * the value for the guest on vcpu_load().  The value for the host EL0
+ * will be restored on vcpu_put(), before returning to the EL0.
+ *
+ * Return true if KVM takes care of the register. Otherwise return false.
+ */
+bool kvm_set_pmuserenr(u64 val)
+{
+	struct kvm_cpu_context *hctxt;
+
+	if (!kvm_arm_support_pmu_v3() || !has_vhe() || !kvm_get_running_vcpu())
+		return false;
+
+	hctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
+	ctxt_sys_reg(hctxt, PMUSERENR_EL0) = val;
+	return true;
+}
-- 
2.40.0.577.gac1e443424-goog


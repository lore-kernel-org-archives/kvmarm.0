Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8845CA4E
	for <kvmarm@lists.linux.dev>; Tue, 26 Sep 2023 23:40:19 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-d81e9981ff4so14486923276.3
        for <kvmarm@lists.linux.dev>; Tue, 26 Sep 2023 16:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695771618; x=1696376418; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IlRDb3sPh92VS5kLeieLP8ax0GBGWHRDMXJHtV/6RiM=;
        b=QfmHT41ZhnNEJQteM8G/UjkysfxIe9CWN1qxaWBd5Z1nrgq9iI77PeYIYvjH6hHES0
         gMjMEeDk3EFhIhEyySj7xsS6Od6RMPLpCeE/VHPxtd/lrRaki6buL8+FxLm8ZqPm/Nr+
         wB95Xh0GI2D7BHw1X8jZo+d5miC0CeGRmD+5xMOQ+M437/lLcupeJHT5qGXLmB7fGmrW
         bTDNf46gWMHaO7K6FLM0gT3w9UzNRs3kXnWeXdSfjMgyWcA0bwSeBq74ZonZ/82rjHml
         HxtaQMq033v1fH8JPLJEqrwjRqVqilSLibLjFefphkfUc5xW5gomeIvUMSdjeFx40w6w
         mMNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695771618; x=1696376418;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IlRDb3sPh92VS5kLeieLP8ax0GBGWHRDMXJHtV/6RiM=;
        b=r4BWAP7mjkNL02cGmOqcxyMNvTs7K/gJZQ3LEdq+0f7I7QTIE8Kv11dbaHDsswTdl2
         RQ6Q1sRX2qPQpK62OSIAz24prTkjjQETaZBArOr2YwJhy0rAxNH1P6DWPtKPZsBwewZE
         9ocsFroXL325KD/7x9ATE7nZ/moKjQnmngcdFfQIYZ6gk5tUFWJwAnruXcV4XFNssAdA
         +GQ7u2+NQ5qKXLJiG/SJbkXcw6mG95h5bm0Q1cLg0FXeKohTWHz5wVwmsgzWLLFPTwQa
         jNKDjU5wmFfvB9eDk+JLVsoNVM8ayXkK5Y8Zo2mpalwyE+4Bj6cDZgU15lR2wMzuYMfN
         fiGg==
X-Gm-Message-State: AOJu0YxPN4JCgKcSYJlH6pdIgwnDstJGPH2Pv0joTfvVo+YBraQyfAKV
	4hMn2f8ftWWhmbYAC2xnPh/ljMPCj0Xi
X-Google-Smtp-Source: AGHT+IHnSaDa/G+O/EI/N5IPFgR3Fp6P/KgiOcPWpbujdZg0NMzaFMsN8C54q4E3eV9+BasQHInZLDyUjFVh
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:20a1])
 (user=rananta job=sendgmr) by 2002:a05:6902:1613:b0:d80:ff9:d19e with SMTP id
 bw19-20020a056902161300b00d800ff9d19emr4336ybb.9.1695771618758; Tue, 26 Sep
 2023 16:40:18 -0700 (PDT)
Date: Tue, 26 Sep 2023 23:40:04 +0000
In-Reply-To: <20230926234008.2348607-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230926234008.2348607-1-rananta@google.com>
X-Mailer: git-send-email 2.42.0.582.g8ccd20d70d-goog
Message-ID: <20230926234008.2348607-8-rananta@google.com>
Subject: [PATCH v6 07/11] KVM: arm64: PMU: Allow userspace to limit PMCR_EL0.N
 for the guest
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Colton Lewis <coltonlewis@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Reiji Watanabe <reijiw@google.com>

KVM does not yet support userspace modifying PMCR_EL0.N (With
the previous patch, KVM ignores what is written by userspace).
Add support userspace limiting PMCR_EL0.N.

Disallow userspace to set PMCR_EL0.N to a value that is greater
than the host value as KVM doesn't support more event counters
than what the host HW implements. Also, make this register
immutable after the VM has started running. To maintain the
existing expectations, instead of returning an error, KVM
returns a success for these two cases.

Finally, ignore writes to read-only bits that are cleared on
vCPU reset, and RES{0,1} bits (including writable bits that
KVM doesn't support yet), as those bits shouldn't be modified
(at least with the current KVM).

Signed-off-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/kvm/sys_regs.c | 58 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 56 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index d1db1f292645e..a0efc71dbee1e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -16,6 +16,7 @@
 #include <linux/mm.h>
 #include <linux/printk.h>
 #include <linux/uaccess.h>
+#include <linux/perf/arm_pmu.h>
 
 #include <asm/cacheflush.h>
 #include <asm/cputype.h>
@@ -1087,6 +1088,59 @@ static int get_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 	return 0;
 }
 
+static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
+		    u64 val)
+{
+	struct kvm *kvm = vcpu->kvm;
+	u64 new_n, mutable_mask;
+
+	mutex_lock(&kvm->arch.config_lock);
+
+	/*
+	 * Make PMCR immutable once the VM has started running, but do
+	 * not return an error (-EBUSY) to meet the existing expectations.
+	 */
+	if (kvm_vm_has_ran_once(vcpu->kvm)) {
+		mutex_unlock(&kvm->arch.config_lock);
+		return 0;
+	}
+
+	new_n = (val >> ARMV8_PMU_PMCR_N_SHIFT) & ARMV8_PMU_PMCR_N_MASK;
+	if (new_n != kvm->arch.pmcr_n) {
+		u8 pmcr_n_limit = kvm->arch.arm_pmu->num_events - 1;
+
+		/*
+		 * The vCPU can't have more counters than the PMU hardware
+		 * implements. Ignore this error to maintain compatibility
+		 * with the existing KVM behavior.
+		 */
+		if (new_n <= pmcr_n_limit)
+			kvm->arch.pmcr_n = new_n;
+	}
+	mutex_unlock(&kvm->arch.config_lock);
+
+	/*
+	 * Ignore writes to RES0 bits, read only bits that are cleared on
+	 * vCPU reset, and writable bits that KVM doesn't support yet.
+	 * (i.e. only PMCR.N and bits [7:0] are mutable from userspace)
+	 * The LP bit is RES0 when FEAT_PMUv3p5 is not supported on the vCPU.
+	 * But, we leave the bit as it is here, as the vCPU's PMUver might
+	 * be changed later (NOTE: the bit will be cleared on first vCPU run
+	 * if necessary).
+	 */
+	mutable_mask = (ARMV8_PMU_PMCR_MASK |
+			(ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT));
+	val &= mutable_mask;
+	val |= (__vcpu_sys_reg(vcpu, r->reg) & ~mutable_mask);
+
+	/* The LC bit is RES1 when AArch32 is not supported */
+	if (!kvm_supports_32bit_el0())
+		val |= ARMV8_PMU_PMCR_LC;
+
+	__vcpu_sys_reg(vcpu, r->reg) = val;
+	return 0;
+}
+
 /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
 #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
 	{ SYS_DESC(SYS_DBGBVRn_EL1(n)),					\
@@ -2150,8 +2204,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_CTR_EL0), access_ctr },
 	{ SYS_DESC(SYS_SVCR), undef_access },
 
-	{ PMU_SYS_REG(PMCR_EL0), .access = access_pmcr,
-	  .reset = reset_pmcr, .reg = PMCR_EL0, .get_user = get_pmcr },
+	{ PMU_SYS_REG(PMCR_EL0), .access = access_pmcr, .reset = reset_pmcr,
+	  .reg = PMCR_EL0, .get_user = get_pmcr, .set_user = set_pmcr },
 	{ PMU_SYS_REG(PMCNTENSET_EL0),
 	  .access = access_pmcnten, .reg = PMCNTENSET_EL0 },
 	{ PMU_SYS_REG(PMCNTENCLR_EL0),
-- 
2.42.0.582.g8ccd20d70d-goog


Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD5E450FA
	for <kvmarm@lists.linux.dev>; Mon,  9 Oct 2023 23:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xiGWcoeh"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-d815354ea7fso6635609276.1
        for <kvmarm@lists.linux.dev>; Mon, 09 Oct 2023 16:09:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696892945; x=1697497745; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=z/EXS3E0QingI/dhMmhRcelks2qlBAd4MtKbKAc3JtE=;
        b=xiGWcoehs85wWgFkALrw7wc9cLaR70Visz/8FH1cf+Ka7jhfOH7VQOO3P3nboAHjds
         2VcnM1bj1CGztu3+2A6jLuGfiQYR2Y78Dk5ya51kGVqCS3Wd8nbxeFOQftZ53aQg+c/T
         pTsYiyaWpcl4N8z3qP017dQJGo6Ft+dBe6c3AbCr+NY1MsWoDrC2oEBgSa97CTv2TqD2
         vAPH3vThSnJXoaaBA+lqfCMgYM55kiggicbhjeTq9ohhIr6bsrkIATa/EFGHcNj7lsSm
         Ah6XiSejGy/v03K9ihIruJbm6jd5BEkqp6mpplxaY/2dPjAzvdkACLGNOmvsDG5DOJB/
         it4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696892945; x=1697497745;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z/EXS3E0QingI/dhMmhRcelks2qlBAd4MtKbKAc3JtE=;
        b=Qz87c5RqBJ6T1fMR1sTKc3P/45TfjE+RRN83asEpg18n12sD8oBZIh4ouTO6bZfy/L
         zzlJrfjl1DUcThvzCfMvDaM7D0sOVAmeym8pVnF35QItUAuiX4/+T3GWGwcl8XBm65C/
         dF2IpT8xN7s6Si52kcXjHVdzSLwgcUh3pFSVGtPJ9JmJKo9joK25Q8BgibLuEkcR6F+U
         PTtqrXT0W3ULODdjZZeI0vY9AnXk8QxR0Mwk87tZoaEhkcJ3MLyCuk3OXVyW/6rCIbKs
         lrQgYPsAUdOLQ/XkmoBQpImh+fMuzuP8voju02O14NgHX9Im+G2jwSUKXAK+dzfKXoHl
         ZNeQ==
X-Gm-Message-State: AOJu0Yyuqq3hPmqY4C57t3wwK+rB1BJgUg05oV+uroD1hBYNHN039SGb
	SH4AG4DYDNf9JTNd+LDMQieVWOuQCJjt
X-Google-Smtp-Source: AGHT+IFKsr7JXVWu1qWTpXDJfo7L0hMPkdhBsdaOWv/PZufLpBw0bG7I4Sg+xG29iJZKC5s8M0y0vdlKLtJf
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:20a1])
 (user=rananta job=sendgmr) by 2002:a25:c583:0:b0:d86:56f4:e4a3 with SMTP id
 v125-20020a25c583000000b00d8656f4e4a3mr248890ybe.13.1696892945384; Mon, 09
 Oct 2023 16:09:05 -0700 (PDT)
Date: Mon,  9 Oct 2023 23:08:48 +0000
In-Reply-To: <20231009230858.3444834-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231009230858.3444834-1-rananta@google.com>
X-Mailer: git-send-email 2.42.0.609.gbb76f46606-goog
Message-ID: <20231009230858.3444834-3-rananta@google.com>
Subject: [PATCH v7 02/12] KVM: arm64: PMU: Set the default PMU for the guest
 before vCPU reset
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

The following patches will use the number of counters information
from the arm_pmu and use this to set the PMCR.N for the guest
during vCPU reset. However, since the guest is not associated
with any arm_pmu until userspace configures the vPMU device
attributes, and a reset can happen before this event, assign a
default PMU to the guest just before doing the reset.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/kvm/arm.c      | 20 ++++++++++++++++++++
 arch/arm64/kvm/pmu-emul.c | 12 ++----------
 include/kvm/arm_pmu.h     |  6 ++++++
 3 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 78b0970eb8e6..708a53b70a7b 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1313,6 +1313,23 @@ static bool kvm_vcpu_init_changed(struct kvm_vcpu *vcpu,
 			     KVM_VCPU_MAX_FEATURES);
 }
 
+static int kvm_vcpu_set_pmu(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+
+	if (!kvm_arm_support_pmu_v3())
+		return -EINVAL;
+
+	/*
+	 * When the vCPU has a PMU, but no PMU is set for the guest
+	 * yet, set the default one.
+	 */
+	if (unlikely(!kvm->arch.arm_pmu))
+		return kvm_arm_set_default_pmu(kvm);
+
+	return 0;
+}
+
 static int __kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
 				 const struct kvm_vcpu_init *init)
 {
@@ -1328,6 +1345,9 @@ static int __kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
 
 	bitmap_copy(kvm->arch.vcpu_features, &features, KVM_VCPU_MAX_FEATURES);
 
+	if (kvm_vcpu_has_pmu(vcpu) && kvm_vcpu_set_pmu(vcpu))
+		goto out_unlock;
+
 	/* Now we know what it is, we can reset it. */
 	kvm_reset_vcpu(vcpu);
 
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index eb5dcb12dafe..cc30c246c010 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -717,8 +717,7 @@ static struct arm_pmu *kvm_pmu_probe_armpmu(void)
 	 * It is still necessary to get a valid cpu, though, to probe for the
 	 * default PMU instance as userspace is not required to specify a PMU
 	 * type. In order to uphold the preexisting behavior KVM selects the
-	 * PMU instance for the core where the first call to the
-	 * KVM_ARM_VCPU_PMU_V3_CTRL attribute group occurs. A dependent use case
+	 * PMU instance for the core during the vcpu reset. A dependent use case
 	 * would be a user with disdain of all things big.LITTLE that affines
 	 * the VMM to a particular cluster of cores.
 	 *
@@ -893,7 +892,7 @@ static void kvm_arm_set_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
  * where vCPUs can be scheduled on any core but the guest
  * counters could stop working.
  */
-static int kvm_arm_set_default_pmu(struct kvm *kvm)
+int kvm_arm_set_default_pmu(struct kvm *kvm)
 {
 	struct arm_pmu *arm_pmu = kvm_pmu_probe_armpmu();
 
@@ -946,13 +945,6 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	if (vcpu->arch.pmu.created)
 		return -EBUSY;
 
-	if (!kvm->arch.arm_pmu) {
-		int ret = kvm_arm_set_default_pmu(kvm);
-
-		if (ret)
-			return ret;
-	}
-
 	switch (attr->attr) {
 	case KVM_ARM_VCPU_PMU_V3_IRQ: {
 		int __user *uaddr = (int __user *)(long)attr->addr;
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 3546ebc469ad..858ed9ce828a 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -101,6 +101,7 @@ void kvm_vcpu_pmu_resync_el0(void);
 })
 
 u8 kvm_arm_pmu_get_pmuver_limit(void);
+int kvm_arm_set_default_pmu(struct kvm *kvm);
 
 #else
 struct kvm_pmu {
@@ -174,6 +175,11 @@ static inline u8 kvm_arm_pmu_get_pmuver_limit(void)
 }
 static inline void kvm_vcpu_pmu_resync_el0(void) {}
 
+static inline int kvm_arm_set_default_pmu(struct kvm *kvm)
+{
+	return -ENODEV;
+}
+
 #endif
 
 #endif
-- 
2.42.0.609.gbb76f46606-goog


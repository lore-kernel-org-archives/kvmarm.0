Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96BA1641C
	for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 18:19:56 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-d052f49702dso2267282276.3
        for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 11:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690568395; x=1691173195;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aAekjaTFXjEweeDH/Mb/ZF43LZdu52WOafvdUDqv0bc=;
        b=x2Oe9AirNgS7MogCIu5oJEqq/52wGFhjSA2r8zXGXeSPnwQQ56qElMbIeSrctyuSqn
         VhgLSHooyJxBubxB/sekpoO36br0Rw+VItm+aildhM69+/WctF+kNs6r9HGT6OYO23Te
         Mlr0ZD5d538njjfjNMnVNE352zXLPAAv44OXzX8WamqjuGJWQMfwUU1qjYZB+l6gksTk
         4E/FO7lA60doM+lD8gYzmS+QNLXiHt69J6ffxgwXmnzn3M9sjEvlGbAlMlGLAKF0ki+O
         zw7xZ8/SQiHGQjZhP0EXB1qy6o25gtwhaZb/BL0DU46WRCDv1/ATWDApKWQAKxTYnXiB
         A54A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690568395; x=1691173195;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aAekjaTFXjEweeDH/Mb/ZF43LZdu52WOafvdUDqv0bc=;
        b=O4r2Q0Y2LvrJXSIUaCw81+XSsCtyfnB8TvoZ7KHpNVmD389BQv7mi8HPA9FqxqMAMb
         UG8kQTJqeK3yO1MRrdXnqeV8OzPmiSbp7a9o8GTY8qq7paxFCTlzuH9iHVbcY9Qvt6Ih
         PM+duOwPiGVbPk4OZaDbDCKADT5Jw1DfzIZcesH8CEMJmfunQV5WSFcFhYhDc4W8pM+8
         5uiogDlqHxcmeh2lGE5JHVSn2Z0c9WCryb7hzJ6Afj1i8w7wYaJ6DnAY0lyw9OpbVGlt
         qeZZrih0bp6rfsMJasQuhe5KcQPXtHPrbcLUQibVgG+uNjEf8EZnBNlfwRANzcIOYHMv
         Nm/A==
X-Gm-Message-State: ABy/qLZo6/sczpd2hu7xOyBlnn7aiXAEMPviPy1jlOubBjQO5kw2vrWz
	2EJMTT1rt0vogkRSQQj7dloSEBQRh8I=
X-Google-Smtp-Source: APBJJlEiuMt+iQwxWAR3z0dbeeYVal00IsgPQQYapNBLmQrDJITZt7qPg6Q37+JqAmmMLNr4R/yVTSp7USo=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:b28b:0:b0:d0c:e37:b749 with SMTP id
 k11-20020a25b28b000000b00d0c0e37b749mr13192ybj.10.1690568395653; Fri, 28 Jul
 2023 11:19:55 -0700 (PDT)
Date: Fri, 28 Jul 2023 11:19:05 -0700
In-Reply-To: <20230728181907.1759513-1-reijiw@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230728181907.1759513-1-reijiw@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230728181907.1759513-4-reijiw@google.com>
Subject: [PATCH v2 3/5] KVM: arm64: PMU: Avoid inappropriate use of host's PMUVer
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Jing Zhang <jingzhangos@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"

Avoid using the PMUVer of the host's PMU hardware to determine
the PMU event mask, except in one case, as the value of host's
PMUVer may differ from the value of ID_AA64DFR0_EL1.PMUVer for
the guest.

The exception case is when using the PMUVer to determine the
valid range of events for KVM_ARM_VCPU_PMU_V3_FILTER, as it has
been allowing userspace to specify events that are valid for
the PMU hardware, regardless of the value of the guest's
ID_AA64DFR0_EL1.PMUVer.  KVM will use a valid range of events
based on the value of the guest's ID_AA64DFR0_EL1.PMUVer,
in order to effectively filter events that the guest attempts
to program though.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/pmu-emul.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 6fb5c59948a8..f0cbc9024bb7 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -36,12 +36,8 @@ static struct kvm_pmc *kvm_vcpu_idx_to_pmc(struct kvm_vcpu *vcpu, int cnt_idx)
 	return &vcpu->arch.pmu.pmc[cnt_idx];
 }
 
-static u32 kvm_pmu_event_mask(struct kvm *kvm)
+static u32 __kvm_pmu_event_mask(unsigned int pmuver)
 {
-	unsigned int pmuver;
-
-	pmuver = kvm->arch.arm_pmu->pmuver;
-
 	switch (pmuver) {
 	case ID_AA64DFR0_EL1_PMUVer_IMP:
 		return GENMASK(9, 0);
@@ -56,6 +52,14 @@ static u32 kvm_pmu_event_mask(struct kvm *kvm)
 	}
 }
 
+static u32 kvm_pmu_event_mask(struct kvm *kvm)
+{
+	u64 dfr0 = IDREG(kvm, SYS_ID_AA64DFR0_EL1);
+	u8 pmuver = SYS_FIELD_GET(ID_AA64DFR0_EL1, PMUVer, dfr0);
+
+	return __kvm_pmu_event_mask(pmuver);
+}
+
 /**
  * kvm_pmc_is_64bit - determine if counter is 64bit
  * @pmc: counter context
@@ -947,11 +951,17 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 		return 0;
 	}
 	case KVM_ARM_VCPU_PMU_V3_FILTER: {
+		u8 pmuver = kvm_arm_pmu_get_pmuver_limit();
 		struct kvm_pmu_event_filter __user *uaddr;
 		struct kvm_pmu_event_filter filter;
 		int nr_events;
 
-		nr_events = kvm_pmu_event_mask(kvm) + 1;
+		/*
+		 * Allow userspace to specify an event filter for the entire
+		 * event range supported by PMUVer of the hardware, rather
+		 * than the guest's PMUVer for KVM backward compatibility.
+		 */
+		nr_events = __kvm_pmu_event_mask(pmuver) + 1;
 
 		uaddr = (struct kvm_pmu_event_filter __user *)(long)attr->addr;
 
-- 
2.41.0.585.gd2178a4bd4-goog


Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B018BEC2
	for <kvmarm@lists.linux.dev>; Sat, 19 Aug 2023 04:40:01 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-58fb8933e18so3953617b3.3
        for <kvmarm@lists.linux.dev>; Fri, 18 Aug 2023 21:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692420000; x=1693024800;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TAo6+1RgBMzjn0+tgeK+RdjREY7saD7U6oafRnw0fx8=;
        b=rKmZ11ymHgsb8A+ZhygucloIc+RS76L/+ICgvOdkG41GnCGHyv62mTLMaS9ChptEpP
         lvA1xiqLn4J6R1X02OildZNEMxMF9TecNNRaYeH6rjJWyLQkqoJeMsGfp5JonrhYLNRk
         mDdPcat/mu45vFl46D66+iAGMZYw9xaBWB/TB2XxUh5u/wVpgjpMpB2nBT50PserrpvH
         2EYr0YsubYR1ZjdOYElel/ObCyhTmWPldrY2I5/O26x1B45EYoCGCZ0I7tR4nieMf+HQ
         zW9aW/c2M1C+Apy+b8eb/JPXMOTaf9toLNiJNtU/pt/w1OhyIe4YTU8+J+GEdx6Sn4Mr
         UlDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692420000; x=1693024800;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TAo6+1RgBMzjn0+tgeK+RdjREY7saD7U6oafRnw0fx8=;
        b=l1zX4mBDHqVSOSC68XWu13QSe4yvLze1WnaA5Sr+foQr9uLvfLSFkfhk2XYAKcqWTo
         PtvsUgxW32gjsNj0wgSIv+Sgbpfvg4huFVXWaKaz2dlgoWdSkbDmPWLuWmkrBsLPCC9h
         z2SKX4LT1AXJuA9/y29LiG2auf5kGU+3FE956eMZI6XQ1vipVhN+9uJvO/q9aHL8gswC
         WDXvbZm+uHUNGEBpcqwVu7GcvWUf8XlCrwTZHsNRRcsn8+BZxEKPnHA9T65Ewq0EApx5
         yEOyxvGALWloQpcYa/AMaRca5x5XaN1QtpJMpNkradTbS0ESegSxH6aIm8yKogn7SkuT
         h2uQ==
X-Gm-Message-State: AOJu0Yw+MhENBffXqUorWIiRGR/k5BoYSv3gLe4XTqO/Q2db1KpSBeGP
	VwUvEIhaL5/UXp+KIhkBr97I6EK5MPM=
X-Google-Smtp-Source: AGHT+IHX3mSDq9FhzDQbdS+XlHKtXxqy2p8nQlFtuOxi5Mt0UrnWf4ZYN4S6hnPUBVVyAcYA9P5COQcbbG4=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:768f:0:b0:d3f:ccc:2053 with SMTP id
 r137-20020a25768f000000b00d3f0ccc2053mr9506ybc.7.1692420000623; Fri, 18 Aug
 2023 21:40:00 -0700 (PDT)
Date: Fri, 18 Aug 2023 21:39:45 -0700
In-Reply-To: <20230819043947.4100985-1-reijiw@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230819043947.4100985-1-reijiw@google.com>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <20230819043947.4100985-3-reijiw@google.com>
Subject: [PATCH v3 2/4] KVM: arm64: PMU: Avoid inappropriate use of host's PMUVer
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
index 689bbd88fd69..eaeb8fea7971 100644
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
@@ -954,11 +958,17 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
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
2.42.0.rc1.204.g551eb34607-goog


Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326C810E6
	for <kvmarm@lists.linux.dev>; Fri,  3 Feb 2023 04:23:23 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id k204-20020a256fd5000000b007b8b040bc50so3759569ybc.1
        for <kvmarm@lists.linux.dev>; Thu, 02 Feb 2023 20:23:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bsxNffR5T4+GCyVU1rQER4x81/cUB6ikFRzN3Ch65v8=;
        b=im+oblvNpOXv0tNoFXmcYty6GGMOtyQ16C4YJhhKMWKcpj4ix+8iIeWPIjk1y+P7TK
         TAme7nDlXvpnp7/PRBqUXsdjOZA3WnjKzaHxuwhdNmKSwHHk+ToMvvS5HS+7eiP7zduL
         kVaMmsc3UmkmkCqgDoZAs/ksnsY7kREkUCfzQFH3xkJ9P4NVjEFhs1kx9wx6RZp1bxO9
         lLncFtAdu9yOSttS6YvvkPSPpo8zevrYj3t8gbuDhwTlfzhJHXhx8fhdL7x1/033uaQj
         hYKNtWH2UjCjoWeQ4vBxBdUQMKLUQJGrszIgDTGrnK9E9o2Iee3nbcFmKoKmVsG3ZTqQ
         z6Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bsxNffR5T4+GCyVU1rQER4x81/cUB6ikFRzN3Ch65v8=;
        b=GjKTbEVgBJl2eqR/JoFMb6J6vK4ttxVjX5lvfZgC7LYIC8fZvuH9ml29zpnmRvnRD0
         a1V6gEuCGtupQHp28fUNgP+myQy3SHPco3wEGNlB5L1gpIvoyXSM6lFsoSawcMIRtoFV
         1wsceqYyfHCgFXkXsaruxNPuVRuX9QK2rzbOW8rtiW3o7+o9S1tT2qzhTzKYHKtxjMKl
         nGn5LayIdg19UCDj+4byHGV7GM9ha54/k+Y24OAe3BUNenE986m3SL8PzWuhuT6JIXyG
         W0kUClXdQaz5DD2wTkibmk7/JKlPssc/NQ33gKP3enfyN/90ecdiTYBDFm120PLuWTwk
         EaOg==
X-Gm-Message-State: AO0yUKWSB+asr2TSvWWyaLlq/Dom5tSZiliA3yuCTAmD18ZxWYMwLeMr
	zgzasszOJkFOIo0s86XG+HPWW4WXov8=
X-Google-Smtp-Source: AK7set/wpJYN/xrCwxDVv1wcqFOvXuH8Zi1m5CeU9pjOV2IyOIeXUl9PfgDkrAGzUL5m4JkVGoZ6jumXfPY=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a81:4b8c:0:b0:525:483e:5cb4 with SMTP id
 y134-20020a814b8c000000b00525483e5cb4mr0ywa.6.1675398201590; Thu, 02 Feb 2023
 20:23:21 -0800 (PST)
Date: Thu,  2 Feb 2023 20:20:46 -0800
In-Reply-To: <20230203042056.1794649-1-reijiw@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230203042056.1794649-1-reijiw@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230203042056.1794649-3-reijiw@google.com>
Subject: [PATCH v3 04/14] KVM: arm64: PMU: Don't use the PMUVer of the PMU set
 for the guest
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Jing Zhang <jingzhangos@google.com>, 
	Raghavendra Rao Anata <rananta@google.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"

KVM uses two potentially different PMUVer for a vCPU with PMU
configured (kvm->arch.dfr0_pmuver.imp and kvm->arch.arm_pmu->pmuver).
Stop using the host's PMUVer (arm_pmu->pmuver) in most cases,
as the PMUVer for the guest (kvm->arch.dfr0_pmuver.imp) could be
set by userspace (could be lower than the host's PMUVer).

The only exception to KVM using the host's PMUVer is to create an
event filter (KVM_ARM_VCPU_PMU_V3_FILTER).  For this, KVM uses
the value to determine the valid range of the event, and as the
size of the event filter bitmap.  Using the host's PMUVer here will
allow KVM to keep the compatibility with the current behavior of
the PMU_V3_FILTER.  Also, that will allow KVM to keep the entire
filter when PMUVer for the guest is changed, and KVM only need
to change the actual range of use.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/pmu-emul.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 49580787ee09..701728ad78d6 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -35,12 +35,8 @@ static struct kvm_pmc *kvm_vcpu_idx_to_pmc(struct kvm_vcpu *vcpu, int cnt_idx)
 	return &vcpu->arch.pmu.pmc[cnt_idx];
 }
 
-static u32 kvm_pmu_event_mask(struct kvm *kvm)
+static u32 __kvm_pmu_event_mask(u8 pmuver)
 {
-	unsigned int pmuver;
-
-	pmuver = kvm->arch.arm_pmu->pmuver;
-
 	switch (pmuver) {
 	case ID_AA64DFR0_EL1_PMUVer_IMP:
 		return GENMASK(9, 0);
@@ -55,6 +51,11 @@ static u32 kvm_pmu_event_mask(struct kvm *kvm)
 	}
 }
 
+static u32 kvm_pmu_event_mask(struct kvm *kvm)
+{
+	return __kvm_pmu_event_mask(kvm->arch.dfr0_pmuver.imp);
+}
+
 /**
  * kvm_pmc_is_64bit - determine if counter is 64bit
  * @pmc: counter context
@@ -755,7 +756,7 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 		 * Don't advertise STALL_SLOT, as PMMIR_EL0 is handled
 		 * as RAZ
 		 */
-		if (vcpu->kvm->arch.arm_pmu->pmuver >= ID_AA64DFR0_EL1_PMUVer_V3P4)
+		if (vcpu->kvm->arch.dfr0_pmuver.imp >= ID_AA64DFR0_EL1_PMUVer_V3P4)
 			val &= ~BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT - 32);
 		base = 32;
 	}
@@ -955,7 +956,12 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 		struct kvm_pmu_event_filter filter;
 		int nr_events;
 
-		nr_events = kvm_pmu_event_mask(kvm) + 1;
+		/*
+		 * Allocate an event filter for the entire range supported
+		 * by the PMU hardware so we can simply change the actual
+		 * range of use when the PMUVer for the guest is changed.
+		 */
+		nr_events = __kvm_pmu_event_mask(kvm->arch.dfr0_pmuver.imp_limit) + 1;
 
 		uaddr = (struct kvm_pmu_event_filter __user *)(long)attr->addr;
 
-- 
2.39.1.519.gcb327c4b5f-goog


Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929C4C8F6
	for <kvmarm@lists.linux.dev>; Sat, 10 Jun 2023 19:45:19 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-56536dd5f79so44458587b3.3
        for <kvmarm@lists.linux.dev>; Sat, 10 Jun 2023 12:45:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686426318; x=1689018318;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DhmS+5Rbxn1VEYNEf/6MMSLp+0EGyRm+QoblFWUsSik=;
        b=NQHfPTF48NEz0KFbVuwd78qv8DOKvNH5I7z8FB5J0eJFMNwbBhiyD2v1x+I81tmFFC
         n+XgMlCrEXyYSgoaVbBFMJlCxn2qAqWXWoEj+BJCOFROgxBhXwT/25s1+lfyyyM3WGhM
         khd6GuD+zGW2V3ZSbh/vyYdudIz8SyH3Ce0iuzawnyasvtv/Z2yE9EiKmo1gfTWBm5EZ
         msIBgSC+hG/mNTJe+0mP8P51MQNfjhIE24Nnj2K6rmUHOdYRFFA7/uCoOkBozsDfwm2U
         CvhXh3YUnHeWkJXJdZKflGBBMQ4JVzl30IGvurmsKmJAhVgCvkfZYj//lyo0Cu6D4KY+
         V+hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686426318; x=1689018318;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DhmS+5Rbxn1VEYNEf/6MMSLp+0EGyRm+QoblFWUsSik=;
        b=V1p60GOPgrfrsxazN1VDHRGp2eptVz2PXbiMuDh4j6tsgzpT1PVLkkIlDCi11lkfCz
         7NM6qFm4VLpCeDsxWLzgtuEQOGbovIA1fx8TB0dXdxjP9algPLXvi2JIgs5qFeEXWV11
         6ba5RZfilZCHVzVUznUUfyUDE25qie7BkNBaaYQndgpZpX8dgSXnEWOBhrYx/pSH6LJR
         azux0ZjIUZF0l5LPKSZltPvmsCfZESQtpaAjUB/mp+XqJvOpPnDgGjbtXqy87wrVTK/e
         UM0ZGfF+jjLuDq4gAaGfUSm0GfWKJnH96cydoqJ3miaZgsPQzn3K00S24bS//W4177AO
         7O8g==
X-Gm-Message-State: AC+VfDw3MkOpn0u8VNBq2kRg/T475y4Vq60qTfR/NK1trB2LC9mX0PnI
	vjPcceqyXLc0SaKh+FpiL66i8A9soWk=
X-Google-Smtp-Source: ACHHUZ6GNWiW+9MfWShyd11SyiEsw54ELBW+E0xkIuzWcSOJYkhY6fKB79FSpMLSbxUOjReFDpoKZ7i9IXo=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:bc2:0:b0:ba6:e7ee:bb99 with SMTP id
 185-20020a250bc2000000b00ba6e7eebb99mr2545129ybl.12.1686426318417; Sat, 10
 Jun 2023 12:45:18 -0700 (PDT)
Date: Sat, 10 Jun 2023 12:45:10 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230610194510.4146549-1-reijiw@google.com>
Subject: [PATCH 1/1] KVM: arm64: PMU: Avoid inappropriate use of host's PMUVer
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Jing Zhang <jingzhangos@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"

Avoid using the PMUVer of the host's PMU hardware (including
the sanitized value of the PMUVer) for vPMU control purposes,
except in a few cases, as the value of host's PMUVer may differ
from the value of ID_AA64DFR0_EL1.PMUVer for the guest.

The first case is when using the PMUVer as the limit value of
the ID_AA64DFR0_EL1.PMUVer for the guest. The second case is
when using the PMUVer to determine the valid range of events for
KVM_ARM_VCPU_PMU_V3_FILTER, as it has been allowing userspace to
specify events that are valid for the PMU hardware, regardless of
the value of the guest's ID_AA64DFR0_EL1.PMUVer. KVM will change
the valid range of the event that the guest can use based on the
value of the guest's ID_AA64DFR0_EL1.PMUVer though.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/pmu-emul.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 491ca7eb2a4c..2d52f44de4a1 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -35,12 +35,8 @@ static struct kvm_pmc *kvm_vcpu_idx_to_pmc(struct kvm_vcpu *vcpu, int cnt_idx)
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
@@ -735,7 +736,7 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 		 * Don't advertise STALL_SLOT, as PMMIR_EL0 is handled
 		 * as RAZ
 		 */
-		if (vcpu->kvm->arch.arm_pmu->pmuver >= ID_AA64DFR0_EL1_PMUVer_V3P4)
+		if (vcpu->kvm->arch.dfr0_pmuver.imp >= ID_AA64DFR0_EL1_PMUVer_V3P4)
 			val &= ~BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT - 32);
 		base = 32;
 	}
@@ -932,11 +933,17 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
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
2.41.0.162.gfafddb0af9-goog


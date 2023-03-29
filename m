Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA50EB8
	for <kvmarm@lists.linux.dev>; Wed, 29 Mar 2023 02:40:01 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3-20020a251103000000b00b732e362449so13922140ybr.0
        for <kvmarm@lists.linux.dev>; Tue, 28 Mar 2023 19:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680057600;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=g+L6ngmQzqeAkDT2zaXK2CAjwgR4YJ46Vd4xGrMqvOI=;
        b=I8QIadBdOlQ7lazV39hVWI0Kws6dkOboQeyNkOYTnlXnAnszJyff8w0ygPp8su/4Zu
         Nny1qhPbY5EOcYeQP1NkrwbXxY9MfZ9fB9M6RWdP3JzQNJkPujH5JbCWDapX+IxYy7+I
         qnJKGvD4Xsjb2nMJiMKeVTp/IrQWdvZoczS1B0WMdtjAJbNlLBD2BEy198yTua4eFZ7O
         Z+plU+9ITDrs63mqQpAEZZgu718LG4YwwwpdYMpJiczCIS0Hz/f5Pw4NCQFaRQhUGVQu
         f3c+eYfO/VIoCeOqsBFoU4wsPozrWQHpb/ikLkDBG2iATuNEw4LBou028tCKfEyUO5E0
         z9eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680057600;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g+L6ngmQzqeAkDT2zaXK2CAjwgR4YJ46Vd4xGrMqvOI=;
        b=uR6agsmMLIiV8C5AFjQML/WIi+HMwbeXO3pIEOMQtWpCU9bnXv+7Ok4ecDxhl4bjHd
         OAHGMKn30CEFZ8lJT6GSBtrkPloD7wganXYtFNZPZ5FveHX/x/MI5zqSBUxRyP+IWPSL
         xBYUe1Mq/g5007E4iddH7C5iha78m9Wse91QIHV2lA8yHFCW166zoT7CaevgAhbJo6OV
         1PLBsJPLk7nLnkOwhBPv8brq5F7wiiI793mKAspIvzXP4TwQ9U8Dfaqh4BWyi500nX3Q
         4VnuiaIKLrkuy80CfsqUDUu95heqYjQdWm8+7rwumW9G0s/YkM/OpRdGnpJFwd3c9WbQ
         lWug==
X-Gm-Message-State: AAQBX9fESgJ3hAZi9S6wgSLKyZtVtxachLdyOLZE6UMag6IpHNoClHxL
	Ot/i0GFgFy8TXRKVCypyCKcWsRtVasg=
X-Google-Smtp-Source: AKy350Z396WmO5htsaorEF4lDrOAYg2qSUXByMyFmFnN20rjqJnOIXx38KZo3aNWtmyFJDUISkk9iVSdNco=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a81:ad05:0:b0:545:fff5:b639 with SMTP id
 l5-20020a81ad05000000b00545fff5b639mr3570058ywh.1.1680057600649; Tue, 28 Mar
 2023 19:40:00 -0700 (PDT)
Date: Tue, 28 Mar 2023 19:39:44 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230329023944.2488484-1-reijiw@google.com>
Subject: [PATCH v2] KVM: arm64: PMU: Restore the guest's EL0 event counting
 after migration
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Jing Zhang <jingzhangos@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	Will Deacon <will@kernel.org>, Reiji Watanabe <reijiw@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Currently, with VHE, KVM enables the EL0 event counting for the
guest on vcpu_load() or KVM enables it as a part of the PMU
register emulation process, when needed.  However, in the migration
case (with VHE), the same handling is lacking, as vPMU register
values that were restored by userspace haven't been propagated yet
(the PMU events haven't been created) at the vcpu load-time on the
first KVM_RUN (kvm_vcpu_pmu_restore_guest() called from vcpu_load()
on the first KVM_RUN won't do anything as events_{guest,host} of
kvm_pmu_events are still zero).

So, with VHE, enable the guest's EL0 event counting on the first
KVM_RUN (after the migration) when needed.  More specifically,
have kvm_pmu_handle_pmcr() call kvm_vcpu_pmu_restore_guest()
so that kvm_pmu_handle_pmcr() on the first KVM_RUN can take
care of it.

Fixes: d0c94c49792c ("KVM: arm64: Restore PMU configuration on first run")
Cc: stable@vger.kernel.org
Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Reiji Watanabe <reijiw@google.com>

---
v2:
 - Added more explanation to the commit message [Marc]
 - Added Marc's r-b tag (Thank you!)

v1: https://lore.kernel.org/all/20230328034725.2051499-1-reijiw@google.com/
---
 arch/arm64/kvm/pmu-emul.c | 1 +
 arch/arm64/kvm/sys_regs.c | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 24908400e190..74e0d2b153b5 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -557,6 +557,7 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 		for_each_set_bit(i, &mask, 32)
 			kvm_pmu_set_pmc_value(kvm_vcpu_idx_to_pmc(vcpu, i), 0, true);
 	}
+	kvm_vcpu_pmu_restore_guest(vcpu);
 }
 
 static bool kvm_pmu_counter_is_enabled(struct kvm_pmc *pmc)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 53749d3a0996..425e1e9adae7 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -794,7 +794,6 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		if (!kvm_supports_32bit_el0())
 			val |= ARMV8_PMU_PMCR_LC;
 		kvm_pmu_handle_pmcr(vcpu, val);
-		kvm_vcpu_pmu_restore_guest(vcpu);
 	} else {
 		/* PMCR.P & PMCR.C are RAZ */
 		val = __vcpu_sys_reg(vcpu, PMCR_EL0)

base-commit: 197b6b60ae7bc51dd0814953c562833143b292aa
-- 
2.40.0.348.gf938b09366-goog


Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F938A3F
	for <kvmarm@lists.linux.dev>; Sat, 11 Feb 2023 03:16:47 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-52ec987d600so40503017b3.21
        for <kvmarm@lists.linux.dev>; Fri, 10 Feb 2023 19:16:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MCXnOb6jcGTB9kCRmfw+USzftBG5GbuvoabNuXgoEVU=;
        b=bcxD3LvkYnFpmSe0OOL5FnK+rcgRPLQvdZMgoUbwJlzTZUXvvFht0hWOAbfD7fwzMO
         PPIKczBG/uxBejjRAsvzVLhSrjdI/XfTYxwnP54eZLr49fS9EJoBG2Q0MH5dW24sYWqG
         5rNeWjkrE89NWC6RTldgbiiFH+NAgkp8riAo/SLTdV1FyPQVQLJCttGqfcgxpaqUrr3A
         zzSkEHZfzAhjy+YE86HtZC6EYQg14ZzQWfWsNvBgBFvWVMG6eabvewT9/VQlVz2wn8gw
         AOW9WnUeK+JJvztH/lgimLiRkf8TPFLh5nIwD42T3+mLmJ5BUTDG3Y2uZhctSzK+p8u7
         IR8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MCXnOb6jcGTB9kCRmfw+USzftBG5GbuvoabNuXgoEVU=;
        b=7uks7jAgsqnENbyqVYApS2fPdjF3dX+rohncxNN78pJW0Z77feyZDOgGtBja0rnEh1
         d3ry4hiJghMHPcElRQ3JiGRXSgSKbP11uTCe+d9KCt/Ad1l7QWBwgTdcT8GOVHLbw3vY
         GZTi998s2tn27AXBe4+UgVrDilFRgvuAb+li4+VNfUWltkXILcOIAlml7ymlh0mkmFfC
         eprs1WFC4epnse9XV6FpvAjB38aUCbz4xaA+rKzd4t9oZHiVIcPH4HceSYto9oZqHxQz
         EA+2TTTaca/VYZzWrRazkX4CxZaHZgNMqDhdOVUKa4wAwZMDG6OURbZV4fu0sXMRCbC3
         53Ng==
X-Gm-Message-State: AO0yUKVaThIAY5N9dlA8Zx3YlF2cJwFFcJ2/zOkdNvIGjwd78mswcWYO
	UVm8vL5+QHWBv5dJHZmY6ozEEQ7EK44=
X-Google-Smtp-Source: AK7set9ycbZcIhKY2lEr5PmnL1aLgmVOCXQ7NCzmiSMYPzzadl1xbEaheY9neKH5tD47DeO3FkS/ZiIqyJc=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:69c2:0:b0:8b4:7955:9223 with SMTP id
 e185-20020a2569c2000000b008b479559223mr8ybc.8.1676085405916; Fri, 10 Feb 2023
 19:16:45 -0800 (PST)
Date: Fri, 10 Feb 2023 19:14:59 -0800
In-Reply-To: <20230211031506.4159098-1-reijiw@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230211031506.4159098-1-reijiw@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230211031506.4159098-8-reijiw@google.com>
Subject: [PATCH v4 07/14] KVM: arm64: PMU: Simplify extracting PMCR_EL0.N
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Jing Zhang <jingzhangos@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"

Some code extracts PMCR_EL0.N using ARMV8_PMU_PMCR_N_SHIFT and
ARMV8_PMU_PMCR_N_MASK. Define ARMV8_PMU_PMCR_N (0x1f << 11),
and simplify those codes using FIELD_GET() and/or ARMV8_PMU_PMCR_N.
The following patches will also use these macros to extract PMCR_EL0.N.

No functional change intended.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/perf_event.h | 2 +-
 arch/arm64/kernel/perf_event.c      | 3 +--
 arch/arm64/kvm/pmu-emul.c           | 3 +--
 arch/arm64/kvm/sys_regs.c           | 7 +++----
 4 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/perf_event.h b/arch/arm64/include/asm/perf_event.h
index 3eaf462f5752..eeef8d56d9c8 100644
--- a/arch/arm64/include/asm/perf_event.h
+++ b/arch/arm64/include/asm/perf_event.h
@@ -219,7 +219,7 @@
 #define ARMV8_PMU_PMCR_LC	(1 << 6) /* Overflow on 64 bit cycle counter */
 #define ARMV8_PMU_PMCR_LP	(1 << 7) /* Long event counter enable */
 #define	ARMV8_PMU_PMCR_N_SHIFT	11	 /* Number of counters supported */
-#define	ARMV8_PMU_PMCR_N_MASK	0x1f
+#define	ARMV8_PMU_PMCR_N	(0x1f << ARMV8_PMU_PMCR_N_SHIFT)
 #define	ARMV8_PMU_PMCR_MASK	0xff	 /* Mask for writable bits */
 
 /*
diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
index a5193f2146a6..1775d89a9144 100644
--- a/arch/arm64/kernel/perf_event.c
+++ b/arch/arm64/kernel/perf_event.c
@@ -1158,8 +1158,7 @@ static void __armv8pmu_probe_pmu(void *info)
 	probe->present = true;
 
 	/* Read the nb of CNTx counters supported from PMNC */
-	cpu_pmu->num_events = (armv8pmu_pmcr_read() >> ARMV8_PMU_PMCR_N_SHIFT)
-		& ARMV8_PMU_PMCR_N_MASK;
+	cpu_pmu->num_events = FIELD_GET(ARMV8_PMU_PMCR_N, armv8pmu_pmcr_read());
 
 	/* Add the CPU cycles counter */
 	cpu_pmu->num_events += 1;
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 701728ad78d6..9dbf532e264e 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -246,9 +246,8 @@ void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu)
 
 u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
 {
-	u64 val = __vcpu_sys_reg(vcpu, PMCR_EL0) >> ARMV8_PMU_PMCR_N_SHIFT;
+	u64 val = FIELD_GET(ARMV8_PMU_PMCR_N, __vcpu_sys_reg(vcpu, PMCR_EL0));
 
-	val &= ARMV8_PMU_PMCR_N_MASK;
 	if (val == 0)
 		return BIT(ARMV8_PMU_CYCLE_IDX);
 	else
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 790f028a1686..9b410a2ea20c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -629,7 +629,7 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 		return;
 
 	/* Only preserve PMCR_EL0.N, and reset the rest to 0 */
-	pmcr = read_sysreg(pmcr_el0) & (ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT);
+	pmcr = read_sysreg(pmcr_el0) & ARMV8_PMU_PMCR_N;
 	if (!kvm_supports_32bit_el0())
 		pmcr |= ARMV8_PMU_PMCR_LC;
 
@@ -736,10 +736,9 @@ static bool access_pmceid(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 
 static bool pmu_counter_idx_valid(struct kvm_vcpu *vcpu, u64 idx)
 {
-	u64 pmcr, val;
+	u64 val;
 
-	pmcr = __vcpu_sys_reg(vcpu, PMCR_EL0);
-	val = (pmcr >> ARMV8_PMU_PMCR_N_SHIFT) & ARMV8_PMU_PMCR_N_MASK;
+	val = FIELD_GET(ARMV8_PMU_PMCR_N, __vcpu_sys_reg(vcpu, PMCR_EL0));
 	if (idx >= val && idx != ARMV8_PMU_CYCLE_IDX) {
 		kvm_inject_undefined(vcpu);
 		return false;
-- 
2.39.1.581.gbfd45094c4-goog


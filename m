Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1AD1D6188
	for <kvmarm@lists.linux.dev>; Sun,  2 Mar 2025 08:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740903186; cv=none; b=aAoUxYtojGOcoK8Pe7NQCVRaEYDfgf+mp9UdJxpKnAmaFMgNV+PSUR/J/PTapatR5F3B6kfz43MGuswESwEQuYz1iWEfut/LU4N0f+jlG5Rq3zIIfQYhMG4b101O4aoFt6TvA7s9nfUCyKrd0GcQgqwZPFym9CnZ5FVghr5+vAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740903186; c=relaxed/simple;
	bh=LOEpf77ZOX/xyJTR8gqTAqd2Ga8F+sIaYQCZIN7wxFw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=tRcxDIrySbWzN+HrXHWKf9vUSbJWf6w8oNLw3dqF4AYuua0BFDMxOXLqWMj1fL7oARvChT2GKfd/xLwb+ouNBxZUIpmvRbvphX9fgz1LZnJ07zADaDKD/3q/KcGv8uySjxhaE/81aYymqBHfe0twgvTeL8GMn83fzJfthjczUSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=qQazaCoa; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="qQazaCoa"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2feb9078888so4924754a91.3
        for <kvmarm@lists.linux.dev>; Sun, 02 Mar 2025 00:13:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1740903183; x=1741507983; darn=lists.linux.dev;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=84McYKpkJJYqDhwKGbOb4J/jLEFuGbb2JLYOWqIz1bA=;
        b=qQazaCoa5l4ng46DbILG6NpC8tFG7lPGAtPF3iXFWy2kDC8LPLUEV/vcgVfIPSNw5A
         BsHL7ziAbQ5la7Q2ylsRQ5xtT9tvuV6vowITtJs0EasMNLDh+vwwVzm50zWnaONOxnA6
         01lug2edR1EFYYnJly9miXOYLnomi2a+Kspfrph3UPBhlv5UFR5v0IZSaGLde5M2266S
         199gcYn7qj6D2CWTs/kql4h26wUK6m0yz9VrvAqwRfClE4KMG9aLdV+yuu3XlxhOUoN9
         ujyn3RUh2yHMsL7TimP9M8wz68TOLX/8/nEPJPZyacL7Y9fJoQGBbqEnUeKkUUDInDaE
         plaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740903183; x=1741507983;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=84McYKpkJJYqDhwKGbOb4J/jLEFuGbb2JLYOWqIz1bA=;
        b=ZSh2aX9+aNQNXGihE5lQxhDKNkLlLYOB+jm245LsH0garMeAbHXbkNcRZ3Xhs32Mw2
         QSXRFjA7ZYX38gbCe2zyFQ5l0NBj/pwNw2DGBCNcqcoq3KXWoQ2vG21BqACKqVssb6qH
         Jf6gMk3q80gAgzOTE5PSe5Edf9itg8nBUmMj7FGEn0oy2pXzUEwqnT1+jgG9hAJMuiIP
         vQPzHPxDEg3EVA1xnorptd3PSePizD6dg8s7oy2zgQ77jl7BeKYx4LsfP5zllvgLDCrY
         lYY3XqwySmyCMemsuknZheE97tTh2exQxeDta3R0cbRBFY4TVEsXxHrzDmOnGSfUcZsI
         vPhw==
X-Forwarded-Encrypted: i=1; AJvYcCXLOuDHzf5IuF2NNscHvXE6WACfxL0J1cPStUQFDAEgT8C01UOl+GFQqXSLY8irlknW3cycIDA=@lists.linux.dev
X-Gm-Message-State: AOJu0YxGkeH7iSZPaxV5UglEkK2dRWqylmAC6ou5EInBlN4qY+gAnUj1
	kVemjvw/k4FdTCGWS70zoeQZn6WOcqb3cNMumzCk4eL6e99wlFoDyxEHZ1C9fgw=
X-Gm-Gg: ASbGncszthhvE+QNcBL6O4SAmUJk8i3FxmbRYEGhXjJFcGYyyFlfvfoOWqxEk5SCfJu
	ML1kxHhwz/n5DvGuG2l9E0K6rQstzSXsV4Ji/75cFiJG+YTxsxp4Uvxm72PqXONlZwKOCtTMs9q
	wpr8R33GFsde4NXp+gv7hSUa99rUt5sfPBQXXAlj3Qd71TBY2nnp1SJE+9w0Vz2VS0BDZUWCDmV
	FWKWSSE+czTfrcRXiMKcqtdybfIcXuijg8Q7j+uptNdGLgMm7GJ+JpuMw+YKJ3ar81OfaSQ85E7
	1oYi+RDeSwuogWe45sdH/k/xN5yTPdal3CYgtbrdDy71v28v
X-Google-Smtp-Source: AGHT+IEm3T6IHk5ovRAm0FLQbBTvAowwUDJVCwuWzj30KVnm2jDxufS66tVGFXW4MWOrLXmcQD8Ulw==
X-Received: by 2002:a17:90b:3ec9:b0:2ee:9e06:7db0 with SMTP id 98e67ed59e1d1-2febab50f40mr14774270a91.11.1740903183521;
        Sun, 02 Mar 2025 00:13:03 -0800 (PST)
Received: from localhost ([157.82.207.107])
        by smtp.gmail.com with UTF8SMTPSA id 41be03b00d2f7-aee7dedf5a8sm6079482a12.70.2025.03.02.00.13.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Mar 2025 00:13:03 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Sun, 02 Mar 2025 17:12:54 +0900
Subject: [PATCH] KVM: arm64: PMU: Fix SET_ONE_REG for vPMC regs
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250302-pmc-v1-1-caff989093dc@daynix.com>
X-B4-Tracking: v=1; b=H4sIAAUTxGcC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDI1MDYwMj3YLcZN0kS4NEC7PENEsT02QloMqCotS0zAqwKdGxtbUAQ6KKqlU
 AAAA=
X-Change-ID: 20250302-pmc-b90a86af945c
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Andrew Jones <drjones@redhat.com>, Shannon Zhao <shannon.zhao@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, devel@daynix.com, 
 Akihiko Odaki <akihiko.odaki@daynix.com>
X-Mailer: b4 0.14.2

Reset the current perf event when setting the vPMU counter (vPMC)
registers (PMCCNTR_EL0 and PMEVCNTR<n>_EL0). This is a change
corresponding to commit 9228b26194d1 ("KVM: arm64: PMU: Fix GET_ONE_REG
for vPMC regs to return the current value") but for SET_ONE_REG.

Values of vPMC registers are saved in sysreg files on certain occasions.
These saved values don't represent the current values of the vPMC
registers if the perf events for the vPMCs count events after the save.
The current values of those registers are the sum of the sysreg file
value and the current perf event counter value.  But, when userspace
writes those registers (using KVM_SET_ONE_REG), KVM only updates the
sysreg file value and leaves the current perf event counter value as is.

Fix this by calling kvm_pmu_set_counter_value(), which resests the
current perf event as well.

Fixes: 051ff581ce70 ("arm64: KVM: Add access handler for event counter register")
Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 arch/arm64/kvm/sys_regs.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 42791971f75887796afab905cc12f49fead39e10..1de990edc6a3e9be2a05a711621bb1bcbeac236a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1035,6 +1035,22 @@ static int get_pmu_evcntr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 	return 0;
 }
 
+static int set_pmu_evcntr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
+			  u64 val)
+{
+	u64 idx;
+
+	if (r->CRn == 9 && r->CRm == 13 && r->Op2 == 0)
+		/* PMCCNTR_EL0 */
+		idx = ARMV8_PMU_CYCLE_IDX;
+	else
+		/* PMEVCNTRn_EL0 */
+		idx = ((r->CRm & 3) << 3) | (r->Op2 & 7);
+
+	kvm_pmu_set_counter_value(vcpu, idx, val);
+	return 0;
+}
+
 static bool access_pmu_evcntr(struct kvm_vcpu *vcpu,
 			      struct sys_reg_params *p,
 			      const struct sys_reg_desc *r)
@@ -1328,6 +1344,7 @@ static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 #define PMU_PMEVCNTR_EL0(n)						\
 	{ PMU_SYS_REG(PMEVCNTRn_EL0(n)),				\
 	  .reset = reset_pmevcntr, .get_user = get_pmu_evcntr,		\
+	  .set_user = set_pmu_evcntr,					\
 	  .access = access_pmu_evcntr, .reg = (PMEVCNTR0_EL0 + n), }
 
 /* Macro to expand the PMEVTYPERn_EL0 register */
@@ -2682,7 +2699,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  .access = access_pmceid, .reset = NULL },
 	{ PMU_SYS_REG(PMCCNTR_EL0),
 	  .access = access_pmu_evcntr, .reset = reset_unknown,
-	  .reg = PMCCNTR_EL0, .get_user = get_pmu_evcntr},
+	  .reg = PMCCNTR_EL0, .get_user = get_pmu_evcntr, .set_user = set_pmu_evcntr },
 	{ PMU_SYS_REG(PMXEVTYPER_EL0),
 	  .access = access_pmu_evtyper, .reset = NULL },
 	{ PMU_SYS_REG(PMXEVCNTR_EL0),

---
base-commit: 97eab90817fc214843ca8ccd4cdf68b8115ed424
change-id: 20250302-pmc-b90a86af945c

Best regards,
-- 
Akihiko Odaki <akihiko.odaki@daynix.com>


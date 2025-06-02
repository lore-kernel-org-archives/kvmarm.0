Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE972221FD0
	for <kvmarm@lists.linux.dev>; Mon,  2 Jun 2025 19:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748892552; cv=none; b=sMUWCv4u3OouZ6qAf9pZPvXfrVf+Be2g6t8gC0i0+JcCcVxRz1bL3bycFAmTku+tiRvd3l9NftPjU2VjKMITU/4zo7BhiKn5Bt28dJdk8X27pIOYwjFACa2A3MN7YtShY5pD0svEVAVgTVKBFM1FsPnOZuZKIMZLoLmBF4b8J04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748892552; c=relaxed/simple;
	bh=gJd6Sg7X96ujBJm4xpL0n0BwR1+EO0NbIRmkP5OmPT4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Bd7CEimTiyeEF13S3zFFMk25y2zwWFmmdegSTY0ZZ32iWIkbJQk7G/5PXHUjnmKZTAEX4wxV6sIgMulbRDLFcOFo9OSuJGQQCx5I2fJmM8WxxMrn33k7zar5whIiQQJWX4/RbYoN9QtabRBWpp1EJmEULulDKTUmI01kJO79AaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dHFEAHG8; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dHFEAHG8"
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-3ddb4dcebfaso9512975ab.1
        for <kvmarm@lists.linux.dev>; Mon, 02 Jun 2025 12:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748892547; x=1749497347; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0IRqT9xxCS8Kun6mHdSmbCCnl/MV3abA8LdyACjVeWc=;
        b=dHFEAHG8oAgrs5STOJ0xKTZedMyu83LACmOP4gRbt7dNKXNWqv7agZa0fJbKqZAbfl
         bv4+R5xK7IfoQO4e8s3zOhrJhXLap3pv289Wmt5K7RLrGo94ra/iQGq/fWUZ9gCXy2x0
         0pbAjL5V5AotoM7of7gnEqav3yl7qkaNnFphtPqOJwkv1J6l5J1PFyKsp7xl3tc41y5A
         gKuGjWuzk+1OdnWyM4W1uBSr4GQFgkC+MDXfXp1mjqjuQHBlnbXXuBZTcD+zJbH5PiK7
         JEPNeL5OeAyxfYvr19ElG2ttmiSoEyQFbHFGFCZ6zGoDkKzGGYS6wClfADdx9ldaLHxR
         62xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748892547; x=1749497347;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0IRqT9xxCS8Kun6mHdSmbCCnl/MV3abA8LdyACjVeWc=;
        b=FUi3mpgq6ZV8cuGKN7RGQs/ig/CxU0DDSrJjGnoTUqensm0+CM7wrO/2JgqyD9UUCM
         qGdTfpV/CEZ5fswUMAWJ5VD7wzNSpbV74wkDBlaOSzaM1ThIStmpdxW+CSC1/smpbjky
         FXjzmVyIoFq/9toDQroySsNby1kAwElS1rQaV49MvOfyNs3qpGDmhYxs9yh2gGJcTDKp
         Am1oOESNjnVE4SlyGUL0ofjwjZCSrCPo99setLJ2IWh6RpxPmbqEA+ppJKG/Q6zGL4hC
         XWZx9OqT6kWNLc6OHhW97opgqD4YAjJzzNkC9ZFuP1Ea89+ukgDFX9L54NHfiDKy/yk8
         kKKw==
X-Forwarded-Encrypted: i=1; AJvYcCUpXk6U8l6+UpZoMK7ccMknEM8kwMGFlCpPIrmrYUfg+CW2hbWu0POgaB0IRFuscZSN/K4PIF8=@lists.linux.dev
X-Gm-Message-State: AOJu0YwdvFAtZKA7WUGf+zU+P4/rkdhjbQy4EtlKCJb49jPR/KAPm/Rz
	NvmuBuZxN6OBQG3KaaiSAafW/vAYy1wXE0cdVCK1XNz0r5Pn9j0RgBxuE3zfuRqhUwT/vYFwKLV
	ZPDU/Zlw/TnGZDTt4OkJ0iYOfyQ==
X-Google-Smtp-Source: AGHT+IFMVeKyETkycXmBUpASHlOBIqAlJOgdAa/bpyVkcS9jV+S6qkzUphiHGfVK6q8KTzMSYrzDWRGuInC2fMT41A==
X-Received: from ilbbk6.prod.google.com ([2002:a05:6e02:3286:b0:3dd:b580:4100])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:4515:10b0:3dd:b5c6:421f with SMTP id e9e14a558f8ab-3ddb5c642c8mr13690965ab.6.1748892547783;
 Mon, 02 Jun 2025 12:29:07 -0700 (PDT)
Date: Mon,  2 Jun 2025 19:26:55 +0000
In-Reply-To: <20250602192702.2125115-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250602192702.2125115-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250602192702.2125115-11-coltonlewis@google.com>
Subject: [PATCH 10/17] KVM: arm64: Writethrough trapped PMEVTYPER register
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

With FGT in place, the remaining trapped registers need to be written
through to the underlying physical registers as well as the virtual
ones. Failing to do this means delaying when guest writes take effect.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/sys_regs.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index d368eeb4f88e..afd06400429a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -18,6 +18,7 @@
 #include <linux/printk.h>
 #include <linux/uaccess.h>
 #include <linux/irqchip/arm-gic-v3.h>
+#include <linux/perf/arm_pmu.h>
 #include <linux/perf/arm_pmuv3.h>
 
 #include <asm/arm_pmuv3.h>
@@ -942,7 +943,11 @@ static bool pmu_counter_idx_valid(struct kvm_vcpu *vcpu, u64 idx)
 {
 	u64 pmcr, val;
 
-	pmcr = kvm_vcpu_read_pmcr(vcpu);
+	if (kvm_vcpu_pmu_is_partitioned(vcpu))
+		pmcr = read_pmcr();
+	else
+		pmcr = kvm_vcpu_read_pmcr(vcpu);
+
 	val = FIELD_GET(ARMV8_PMU_PMCR_N, pmcr);
 	if (idx >= val && idx != ARMV8_PMU_CYCLE_IDX) {
 		kvm_inject_undefined(vcpu);
@@ -1037,6 +1042,22 @@ static bool access_pmu_evcntr(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static void writethrough_pmevtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+				   u64 reg, u64 idx)
+{
+	u64 evmask = kvm_pmu_evtyper_mask(vcpu->kvm);
+	u64 val = p->regval & evmask;
+
+	__vcpu_sys_reg(vcpu, reg) = val;
+
+	if (idx == ARMV8_PMU_CYCLE_IDX)
+		write_pmccfiltr(val);
+	else if (idx == ARMV8_PMU_INSTR_IDX)
+		write_pmicfiltr(val);
+	else
+		write_pmevtypern(idx, val);
+}
+
 static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			       const struct sys_reg_desc *r)
 {
@@ -1063,7 +1084,9 @@ static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	if (!pmu_counter_idx_valid(vcpu, idx))
 		return false;
 
-	if (p->is_write) {
+	if (kvm_vcpu_pmu_is_partitioned(vcpu) && p->is_write) {
+		writethrough_pmevtyper(vcpu, p, reg, idx);
+	} else if (p->is_write) {
 		kvm_pmu_set_counter_event_type(vcpu, p->regval, idx);
 		kvm_vcpu_pmu_restore_guest(vcpu);
 	} else {
-- 
2.49.0.1204.g71687c7c1d-goog


Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D0428A1F5
	for <kvmarm@lists.linux.dev>; Mon, 14 Jul 2025 22:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752533987; cv=none; b=CEfRod5jIluc53NrL9gOwWM639+VETgdf2o0btyizesxu5mfmfH0uC8zXyiaQSrdPXSx9F0ZXnlO2eFsU4BJAOrgnc+HrNpE0Y/qC5AtA3vL0EgyR8vznevhMA8nPFHG8umWu2PlYXjFlslnPToR8pIHmAlzdUCSM3SDGxvbe3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752533987; c=relaxed/simple;
	bh=/fFdI8wVfZFbSMTxD9yoD8XUlrA4EM1qvQESFfNH+cI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CJhx0qkoGfyuvjYQNIL13Tw72TesR5LdoHB4o/R7Ps2EvYdYMWUfc22n330sT7DRiUkwkVN1OBzmsylJoXPU/zQH2r3kWKD7vtOlFnOXjm3etCCZv8bTju2EKCAkWuXJHQfE4RwujO4GqwDnRsTJqoX3CpxlVMokdEIq0ViYKbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dvZnzsa0; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dvZnzsa0"
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-876afa8b530so534970939f.0
        for <kvmarm@lists.linux.dev>; Mon, 14 Jul 2025 15:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752533982; x=1753138782; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HKFKaT34CSY+XrjUi/PaqmOwj/haOI4Kmp3zrewTJxs=;
        b=dvZnzsa0YjjDCkdg9hfMBWjV4JjwFS2t9D1GklX98mRzxGPxhX4xRNye2UPYDM7+nl
         Ap4AIx2/6OEvIqyWStljfirup/nd/9m/tF/Y4S4trtnQhO2s7bHu9KtK3lhOtuFW8yeq
         /xVvHUta890f1ZLfb4ddIMJY2UstkQrGJJnaUMedx1ycrgwmPcgGgHiI65o1mfi9sJSA
         sCOo+o18JjHaG/W1Ll+qnvNiYG8ya87npN0HGHxu1+CaMT/AAiI2WQlucBt0FXLQaaUT
         77YR45Q3w8dWmdCS7yOVhiebrGqllGBdDjfNR8UU/kizsg1egBZRS2ADLafVm14LV0OR
         uxQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752533982; x=1753138782;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HKFKaT34CSY+XrjUi/PaqmOwj/haOI4Kmp3zrewTJxs=;
        b=peQT/y+4q9q6fPfoEFOseLKahZB2Y2FgYRLfZwNjrRZxUVHw3/6dILDiaRFTgW54+F
         fsDihl0Z7IhjRJdgMA28cH0u9+0N7ooYS6vMJ5jwcw0adh1U/aTacG5lgiae7PrAGJsk
         0l3LahrdrnlohvhHQ+cWe7lOMTkgEKCpm8d4DQg1ABGDHgpFt+f6G8yHBm+Ddq9v8r8b
         V7UwkTlGH+e69wUCaROT44xX3eMd1FU/cefxhubcytthcg/McdLpwtrdB/tce7yBHRz7
         6fK+Rbuu1/V4Nzb0Bl70IARyCOxRpNnXsHRZ5fBlbfPjJn66hYcH04RhFsKjohk/vEmK
         IWig==
X-Forwarded-Encrypted: i=1; AJvYcCXjB+Wr45XHvaR7bPN2O4KGriicodyiocrUNgedeYjgjgv4Cd8URouoZdPGHXwdzwBkqir3LIM=@lists.linux.dev
X-Gm-Message-State: AOJu0YzM6h+G2Vr03e9PyVaFNyiINubenTq9LkVnGKIY//BK8Gat+aNf
	f+Zxfv4kWXmp+yYoidzTZ5ho4R3RqQzEqfsxsWqnVXNKhBFjExmyGRbvFoG+XNkEp7+5PC2X43D
	TbDJ1VBqpeSoGkwWCONnKNV4Wnw==
X-Google-Smtp-Source: AGHT+IFHDkydm6wR47l1+EJ847BUB3r6NTWQGkm6LnVFFK97D4N3qaxOkSTSlfCSEPiOoL+l6dOgeUU/KUc+l3ngkQ==
X-Received: from ioy17.prod.google.com ([2002:a05:6602:a111:b0:876:c211:2aad])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6602:4019:b0:876:7876:a587 with SMTP id ca18e2360f4ac-87977e98946mr1665370139f.0.1752533982373;
 Mon, 14 Jul 2025 15:59:42 -0700 (PDT)
Date: Mon, 14 Jul 2025 22:59:06 +0000
In-Reply-To: <20250714225917.1396543-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250714225917.1396543-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250714225917.1396543-13-coltonlewis@google.com>
Subject: [PATCH v4 12/23] KVM: arm64: Writethrough trapped PMOVS register
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Mingwei Zhang <mizhang@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Mark Rutland <mark.rutland@arm.com>, Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

With FGT in place, the remaining trapped registers need to be written
through to the underlying physical registers as well as the virtual
ones. Failing to do this means delaying when guest writes take effect.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/include/asm/arm_pmuv3.h | 10 ++++++++++
 arch/arm64/kvm/sys_regs.c          | 17 ++++++++++++++++-
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/arm_pmuv3.h b/arch/arm64/include/asm/arm_pmuv3.h
index 60600f04b590..3e25c0313263 100644
--- a/arch/arm64/include/asm/arm_pmuv3.h
+++ b/arch/arm64/include/asm/arm_pmuv3.h
@@ -140,6 +140,16 @@ static inline u64 read_pmicfiltr(void)
 	return read_sysreg_s(SYS_PMICFILTR_EL0);
 }
 
+static inline void write_pmovsset(u64 val)
+{
+	write_sysreg(val, pmovsset_el0);
+}
+
+static inline u64 read_pmovsset(void)
+{
+	return read_sysreg(pmovsset_el0);
+}
+
 static inline void write_pmovsclr(u64 val)
 {
 	write_sysreg(val, pmovsclr_el0);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index e761538e1e17..68457655a10b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1171,6 +1171,19 @@ static bool access_pminten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	return true;
 }
 
+static void writethrough_pmovs(struct kvm_vcpu *vcpu, struct sys_reg_params *p, bool set)
+{
+	u64 mask = kvm_pmu_accessible_counter_mask(vcpu);
+
+	if (set) {
+		__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, |=, (p->regval & mask));
+		write_pmovsset(p->regval & mask);
+	} else {
+		__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, &=, ~(p->regval & mask));
+		write_pmovsclr(p->regval & mask);
+	}
+}
+
 static bool access_pmovs(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			 const struct sys_reg_desc *r)
 {
@@ -1179,7 +1192,9 @@ static bool access_pmovs(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	if (pmu_access_el0_disabled(vcpu))
 		return false;
 
-	if (p->is_write) {
+	if (kvm_vcpu_pmu_is_partitioned(vcpu) && p->is_write) {
+		writethrough_pmovs(vcpu, p, r->CRm & 0x2);
+	} else if (p->is_write) {
 		if (r->CRm & 0x2)
 			/* accessing PMOVSSET_EL0 */
 			__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, |=, (p->regval & mask));
-- 
2.50.0.727.gbf7dc18ff4-goog


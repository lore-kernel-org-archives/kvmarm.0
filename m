Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com [209.85.161.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E87D630B527
	for <kvmarm@lists.linux.dev>; Tue,  9 Dec 2025 20:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765313564; cv=none; b=MiqDZZhQSp/c0FLucWMTK2gE4VlwUEe8mxwwXFpnSqqF7F3jiTWNSFoIGMB/DHpSzjGX6AsOJRcaQKazN5bmNSa/zXXYjSiJNRi5SYzisgKKfc0Yt0A2KfKzV0L14saOaUCkkpMgyVkvyu5r14oSABnnV+GBvyWNG9U4fjzs1OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765313564; c=relaxed/simple;
	bh=aCNuh2V9q56mw6LZjRPGjWZ7ahwIMSj/x17VFTK+/00=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aXCgp1OCiltswNdjANGo7vpH5zR1hwYhjnL+smcC7aQ3wuYD6aU+TYRSHY2bIz0/6CCcjxHnSVGKZhyGGDue/GMcYqREk4b9uPIdG92dWhuPFqp+1XO/Azz/Hxdw/hfG5PdXzFbayzxzj2ePWglF82p4fZtsCzneAtjwpU+G3TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sitj1gYo; arc=none smtp.client-ip=209.85.161.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sitj1gYo"
Received: by mail-oo1-f74.google.com with SMTP id 006d021491bc7-657486eb435so7782190eaf.1
        for <kvmarm@lists.linux.dev>; Tue, 09 Dec 2025 12:52:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765313557; x=1765918357; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tlzYgLY8Hya1ebzZsNsRPfgfqZdf/pfSg0Aip8i1MzM=;
        b=sitj1gYoJnW39Jp5xovs/UbKRCz6/jpaNiWU0iYXhYU+oXlwwZsWQHhNU/LJDfxFBT
         VKNwoM3OfZVIRM2/pM/JcRD8HRBp3FFqTrYp++ICdlbvO+gvKr+AZJYiQd0upkqhoG8Q
         awlWrZKkFfB8PDCDpKNQJpGuNcpxf8OIhsF2GPCDefqSlNXy4notjXEA1Jb2z1ZGNErz
         cJ/jPYrvSkNxsdRls/Xbf8QfyJEnCekA8FK5TMOgrKNsYMuVBj09Hh3jb02a5m063zvk
         WbY3hpuD+73FovxMgofZt/NBhgvgIFaHPjeGHp89c9HJqan6Vt2xSO8MO8JqXCLmR2K3
         gsVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765313557; x=1765918357;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tlzYgLY8Hya1ebzZsNsRPfgfqZdf/pfSg0Aip8i1MzM=;
        b=t96XXu1766Avq0LNfUsezNinGfuHJro1z5Cr2ewDC5VsZX4v5kK8LCfhF3oEkfhi/D
         ZP5Dic3Irv1pbtlI0haHn1JKtVAU0jXLp9g3RMta2Z2xuWQUeIRNX+m0ueq+zJbkbkmr
         7PqhJ58IzrN6oRrBZOlST7xU92rv2fsiOPuk2vnj3mtcXNJctpJ8pFa7MZI9ls6zyoer
         +Qzt4KT6ZYwI0AlkvheRij4kc+IoydWdWgZsA8ppP44uj8CVXIIoAs3K4mXK6vAXMWSR
         barnY6QJiH8wjCMG5tqK2BR3OhFKV8Jg6X/Cc8ErsGljcLWgx1i4LMTF11JHdvEfgR2w
         tckQ==
X-Forwarded-Encrypted: i=1; AJvYcCVVZIOyek8gD9thbaf0Ug/mzT80Kb0sjfi2Gbs3nZyHiDLp8g7/L+aiZ62B80CDoERQz/XjQvw=@lists.linux.dev
X-Gm-Message-State: AOJu0YzxxTOaglc+aI/9C+q7S3IvibCssOJworA/D6E1VIE3ihOQg7FH
	dGBixbJB6/P8PyETxNDerm1dZnoJJaNZht5XVwY4sKZwMTqRN4LNebSDuULGeLl6NbSCYQsZH68
	hZX8D3Fri3lm7WQMdPUYMV9LoAg==
X-Google-Smtp-Source: AGHT+IFjXkWMzT4yuAEaLB+dJ2qXq9BXOkkzzf3nS3SdXsepbg3bqK/U0WpaHKFNBgIw1WNvMEX2vLOAaq9kL+8k3A==
X-Received: from jabhd27.prod.google.com ([2002:a05:6638:4e9b:b0:5b7:56fc:a47d])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:6acf:b0:659:9a49:8f3d with SMTP id 006d021491bc7-65b2ad9f5eamr96621eaf.78.1765313557028;
 Tue, 09 Dec 2025 12:52:37 -0800 (PST)
Date: Tue,  9 Dec 2025 20:51:08 +0000
In-Reply-To: <20251209205121.1871534-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251209205121.1871534-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251209205121.1871534-12-coltonlewis@google.com>
Subject: [PATCH v5 11/24] KVM: arm64: Writethrough trapped PMEVTYPER register
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Mingwei Zhang <mizhang@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Mark Rutland <mark.rutland@arm.com>, Shuah Khan <shuah@kernel.org>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

With FGT in place, the remaining trapped registers need to be written
through to the underlying physical registers as well as the virtual
ones. Failing to do this means guest writes will not take effect when
expected.

For the PMEVTYPER register, take care to enforce KVM's PMU event
filter. Do that by setting the bits to exclude EL1 and EL0 when an
event is not present in the filter and clearing the bit to include EL2
always.

Note the virtual register is always assigned the value specified by
the guest to hide the setting of those bits.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/sys_regs.c | 34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c636840b1f6f9..0c9596325519b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1166,6 +1166,36 @@ static bool access_pmu_evcntr(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static bool writethrough_pmevtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+				   u64 reg, u64 idx)
+{
+	u64 eventsel;
+	u64 val = p->regval;
+	u64 evtyper_set = ARMV8_PMU_EXCLUDE_EL0 |
+		ARMV8_PMU_EXCLUDE_EL1;
+	u64 evtyper_clr = ARMV8_PMU_INCLUDE_EL2;
+
+	__vcpu_assign_sys_reg(vcpu, reg, val);
+
+	if (idx == ARMV8_PMU_CYCLE_IDX)
+		eventsel = ARMV8_PMUV3_PERFCTR_CPU_CYCLES;
+	else
+		eventsel = val & kvm_pmu_event_mask(vcpu->kvm);
+
+	if (vcpu->kvm->arch.pmu_filter &&
+	    !test_bit(eventsel, vcpu->kvm->arch.pmu_filter))
+		val |= evtyper_set;
+
+	val &= ~evtyper_clr;
+
+	if (idx == ARMV8_PMU_CYCLE_IDX)
+		write_pmccfiltr(val);
+	else
+		write_pmevtypern(idx, val);
+
+	return true;
+}
+
 static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			       const struct sys_reg_desc *r)
 {
@@ -1192,7 +1222,9 @@ static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
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
2.52.0.239.gd5f0c6e74e-goog


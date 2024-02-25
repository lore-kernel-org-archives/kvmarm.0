Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C1CFBE5
	for <kvmarm@lists.linux.dev>; Sun, 25 Feb 2024 09:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708851790; cv=none; b=rA0iRna+ph2evAyuAuzOJDSlFdEPJXilzxHHilRwmOKrAkw6iQehwWsLTijpLNpb/fDVC9oOLBqfmv60IEqwN0vFUCrlq+tfw3/A/fpcrFxum+HwfBbVWnUXTvqfxaUOPNj6HxkHmpzMit9NYr9R5tua7FzpKiqDrSdE1MCCqqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708851790; c=relaxed/simple;
	bh=9X5ZFfGJrRx90tkCXWlVnyOyMYXcxK7DsLN1j0jJHgM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FAvVABeIsS6f54GS6e3V1RdH34l7wi3AqxTc+sG1bb/AXUNQYtbwHzHVePFfkYtQZwMMZ4Fjvd6frb92+Uc2gMVH+hSMCi8dbm7QT4Su5TYekPa2DogCWpHkyhiuGm1HnYPmxFftQ6cO2fx0nzUxmeHt/2Nh06dQVtyDXcB3Zt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw; spf=pass smtp.mailfrom=csie.ntu.edu.tw; dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b=GXxBVBaW; arc=none smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csie.ntu.edu.tw
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b="GXxBVBaW"
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-595aa5b1fe0so1440667eaf.2
        for <kvmarm@lists.linux.dev>; Sun, 25 Feb 2024 01:03:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=csie.ntu.edu.tw; s=google; t=1708851787; x=1709456587; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=woeQnoHGVB6Fu5J8kN+/MJeLw1fgBr2n72Y8FIG27b8=;
        b=GXxBVBaW3kaUyA5W+v3qA4K36yHGiyKmBf2k2aYo1wpUSjffpEwo0+m3hkDDchXzlN
         t8kLiGVkdiMX9OtbpHNksmFsATmuNAcoY8u6V9rAA81mfX9h4Jr44AWxn6ozbx5s5fm0
         O92anyG7wJfTjb+2vFgGTE3YLMxQaJ5BJUSKPpayT2qGzJH96kVce+9wkG3UZgOWr7d/
         ylWpIjfTdaaBednwvLSgn6Issjk9I5zVwMd8K58ZPqUFhZCu6e417hqzVWN0p8OOEX3Y
         enhqnGVQFTDHCjEt6ZaQjLR39jBq/Jgq2vJD86/LV/zjobFMplNeyI71JAPMAiyW2YV0
         LWSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708851787; x=1709456587;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=woeQnoHGVB6Fu5J8kN+/MJeLw1fgBr2n72Y8FIG27b8=;
        b=FPpnPWB0tbU9/bC5bwsFn3c0wPYnI/PwCPygK6BmiJZQNVhfNAqq7Dx3+0Wk57YFbL
         gPvNHbAJUmYNDD4sFxdDoSY4HKYRuzy0aRN9cwOTdLy/dTU3WHzWnkBvBLzRFikRVb4+
         eN3HSDHz9om2CCrwrc13wThW/SmNekJp9U6JoCUHfqM9dagY1MnCgo/l1oTcLp1yEAc0
         yU/cDuiNodiDNybFQo4Vzammozf0K1se6/MRF1+2MeljTHvqCiZIaa8tZhC9szG8cXs1
         z2u9WYQYfFhJLb9yVRKP8GQ28a/ZTz1DSc5HXU8UMtrf8vfx4rMENgWjogKEohoznSDg
         58hA==
X-Forwarded-Encrypted: i=1; AJvYcCUMziyN1i2Ac1Qvu+crcUrWksGNTHvVoJ5//s4g9RQe8cqyV32JMEFqOq79eh8X4gbeErcBn/NryoHLaWGOKuAuSSXaECoC
X-Gm-Message-State: AOJu0YyeqBoSTuOlPqH1LqXAyWy8FPPbjFu77h3fzAPFVJQSOFhZd4Zy
	tyA/MY+Qy82Jihs2W3sxHFbTA74xTOcJP8IpPeJKLqE4BR9fhdUGkkNOIhquw5InZPRTptX8rkX
	vA5/vD3bD3MYBMB9mu78NgjUDuK2oMdzFYn/+o0BIcns7FLM=
X-Google-Smtp-Source: AGHT+IH/ZpkU2dBCP/4LbQ1PSl/wE9pKB8nFZgcCothGRxMVlOLGI7UlddvXkqCDjoL7L74CwAcamg==
X-Received: by 2002:a05:6358:e491:b0:178:75b1:c403 with SMTP id by17-20020a056358e49100b0017875b1c403mr6750768rwb.9.1708851787099;
        Sun, 25 Feb 2024 01:03:07 -0800 (PST)
Received: from localhost.localdomain (2001-b011-3808-dc23-dcdd-edc7-9b03-9c72.dynamic-ip6.hinet.net. [2001:b011:3808:dc23:dcdd:edc7:9b03:9c72])
        by smtp.gmail.com with ESMTPSA id o18-20020a17090ac09200b0029a3da37123sm2298071pjs.23.2024.02.25.01.03.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Feb 2024 01:03:06 -0800 (PST)
From: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
To: maz@kernel.org,
	oliver.upton@linux.dev,
	james.morse@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	sauravsc@amazon.com,
	Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
Subject: [PATCH 1/1] KVM: arm64: Affinity level 3 support
Date: Sun, 25 Feb 2024 17:02:37 +0800
Message-Id: <20240225090237.775573-2-r09922117@csie.ntu.edu.tw>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240225090237.775573-1-r09922117@csie.ntu.edu.tw>
References: <20240225090237.775573-1-r09922117@csie.ntu.edu.tw>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Gm-Spam: 0
X-Gm-Phishy: 0

Currently, KVM ARM64 avoids using the Aff3 field for VCPUs, which saves
us from having to check for hardware support in ICH_VTR_EL2.A3V or the
guest's execution state. However a VCPU could still have its Aff3 bits
set to non-zero if the VMM directly changes the VCPU's MPIDR_EL1. This
causes a mismatch between MPIDR_EL1.Aff3 and GICR_TYPER[63:56] since 0s
are always returned for the latter, failing the GIC Redistributor
matching in the VM.

Let's fix this by only allowing userspace to write into the Aff3 field
of MPIDR_EL1 if Aff3 is valid. Additionally, extend reset_mpidr and
vgic_mmio_{read,write}_irouter to fully support Aff3. With theses
changes, GICR_TYPER can then safely return all four affinity levels.

Suggested-by: Saurav Sachidanand <sauravsc@amazon.com>
Signed-off-by: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
---
 arch/arm64/kvm/sys_regs.c          | 24 +++++++++++++++++++++---
 arch/arm64/kvm/vgic/vgic-debug.c   |  2 +-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 18 +++++++++++-------
 include/kvm/arm_vgic.h             |  7 ++++++-
 4 files changed, 39 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 30253bd199..6694ce851a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -239,6 +239,19 @@ static u8 get_min_cache_line_size(bool icache)
 	return field + 2;
 }
 
+static int set_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
+		   u64 val)
+{
+	bool aff3_valid = !vcpu_el1_is_32bit(vcpu) && kvm_vgic_has_a3v();
+
+	if (!aff3_valid)
+		val &= ~((u64)MPIDR_LEVEL_MASK << MPIDR_LEVEL_SHIFT(3));
+
+	__vcpu_sys_reg(vcpu, rd->reg) = val;
+
+	return 0;
+}
+
 /* Which cache CCSIDR represents depends on CSSELR value. */
 static u32 get_ccsidr(struct kvm_vcpu *vcpu, u32 csselr)
 {
@@ -817,10 +830,12 @@ static u64 reset_actlr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 static u64 reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	u64 mpidr;
+	bool aff3_valid = !vcpu_el1_is_32bit(vcpu) && kvm_vgic_has_a3v();
 
 	/*
-	 * Map the vcpu_id into the first three affinity level fields of
-	 * the MPIDR. We limit the number of VCPUs in level 0 due to a
+	 * Map the vcpu_id into the affinity level fields of the MPIDR. The
+	 * fourth level is mapped only if we are running a 64 bit guest and
+	 * A3V is supported. We limit the number of VCPUs in level 0 due to a
 	 * limitation to 16 CPUs in that level in the ICC_SGIxR registers
 	 * of the GICv3 to be able to address each CPU directly when
 	 * sending IPIs.
@@ -828,6 +843,8 @@ static u64 reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	mpidr = (vcpu->vcpu_id & 0x0f) << MPIDR_LEVEL_SHIFT(0);
 	mpidr |= ((vcpu->vcpu_id >> 4) & 0xff) << MPIDR_LEVEL_SHIFT(1);
 	mpidr |= ((vcpu->vcpu_id >> 12) & 0xff) << MPIDR_LEVEL_SHIFT(2);
+	if (aff3_valid)
+		mpidr |= (u64)((vcpu->vcpu_id >> 20) & 0xff) << MPIDR_LEVEL_SHIFT(3);
 	mpidr |= (1ULL << 31);
 	vcpu_write_sys_reg(vcpu, mpidr, MPIDR_EL1);
 
@@ -2232,7 +2249,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	{ SYS_DESC(SYS_DBGVCR32_EL2), trap_undef, reset_val, DBGVCR32_EL2, 0 },
 
-	{ SYS_DESC(SYS_MPIDR_EL1), NULL, reset_mpidr, MPIDR_EL1 },
+	{ SYS_DESC(SYS_MPIDR_EL1), NULL, reset_mpidr, MPIDR_EL1,
+	  .get_user = NULL, .set_user = set_mpidr },
 
 	/*
 	 * ID regs: all ID_SANITISED() entries here must have corresponding
diff --git a/arch/arm64/kvm/vgic/vgic-debug.c b/arch/arm64/kvm/vgic/vgic-debug.c
index 85606a531d..726cf1bd7b 100644
--- a/arch/arm64/kvm/vgic/vgic-debug.c
+++ b/arch/arm64/kvm/vgic/vgic-debug.c
@@ -206,7 +206,7 @@ static void print_irq_state(struct seq_file *s, struct vgic_irq *irq,
 		      "    %2d "
 		      "%d%d%d%d%d%d%d "
 		      "%8d "
-		      "%8x "
+		      "%8llx "
 		      " %2x "
 		      "%3d "
 		      "     %2d "
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index c15ee1df03..ea0d4ad85a 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -195,13 +195,13 @@ static unsigned long vgic_mmio_read_irouter(struct kvm_vcpu *vcpu,
 {
 	int intid = VGIC_ADDR_TO_INTID(addr, 64);
 	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, NULL, intid);
+	bool aff3_valid = !vcpu_el1_is_32bit(vcpu) && kvm_vgic_has_a3v();
 	unsigned long ret = 0;
 
 	if (!irq)
 		return 0;
 
-	/* The upper word is RAZ for us. */
-	if (!(addr & 4))
+	if (aff3_valid || !(addr & 4))
 		ret = extract_bytes(READ_ONCE(irq->mpidr), addr & 7, len);
 
 	vgic_put_irq(vcpu->kvm, irq);
@@ -213,11 +213,12 @@ static void vgic_mmio_write_irouter(struct kvm_vcpu *vcpu,
 				    unsigned long val)
 {
 	int intid = VGIC_ADDR_TO_INTID(addr, 64);
+	bool aff3_valid = !vcpu_el1_is_32bit(vcpu) && kvm_vgic_has_a3v();
 	struct vgic_irq *irq;
 	unsigned long flags;
 
-	/* The upper word is WI for us since we don't implement Aff3. */
-	if (addr & 4)
+	/* The upper word is WI if Aff3 is not valid. */
+	if (!aff3_valid && addr & 4)
 		return;
 
 	irq = vgic_get_irq(vcpu->kvm, NULL, intid);
@@ -227,8 +228,7 @@ static void vgic_mmio_write_irouter(struct kvm_vcpu *vcpu,
 
 	raw_spin_lock_irqsave(&irq->irq_lock, flags);
 
-	/* We only care about and preserve Aff0, Aff1 and Aff2. */
-	irq->mpidr = val & GENMASK(23, 0);
+	irq->mpidr = val & MPIDR_HWID_BITMASK;
 	irq->target_vcpu = kvm_mpidr_to_vcpu(vcpu->kvm, irq->mpidr);
 
 	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
@@ -323,7 +323,11 @@ static unsigned long vgic_mmio_read_v3r_typer(struct kvm_vcpu *vcpu,
 	int target_vcpu_id = vcpu->vcpu_id;
 	u64 value;
 
-	value = (u64)(mpidr & GENMASK(23, 0)) << 32;
+	value = MPIDR_AFFINITY_LEVEL(mpidr, 3) << 56 |
+		MPIDR_AFFINITY_LEVEL(mpidr, 2) << 48 |
+		MPIDR_AFFINITY_LEVEL(mpidr, 1) << 40 |
+		MPIDR_AFFINITY_LEVEL(mpidr, 0) << 32;
+
 	value |= ((target_vcpu_id & 0xffff) << 8);
 
 	if (vgic_has_its(vcpu->kvm))
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 8cc38e836f..b464ac1b79 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -143,7 +143,7 @@ struct vgic_irq {
 	unsigned int host_irq;		/* linux irq corresponding to hwintid */
 	union {
 		u8 targets;			/* GICv2 target VCPUs mask */
-		u32 mpidr;			/* GICv3 target VCPU */
+		u64 mpidr;			/* GICv3 target VCPU */
 	};
 	u8 source;			/* GICv2 SGIs only */
 	u8 active_source;		/* GICv2 SGIs only */
@@ -413,6 +413,11 @@ static inline int kvm_vgic_get_max_vcpus(void)
 	return kvm_vgic_global_state.max_gic_vcpus;
 }
 
+static inline bool kvm_vgic_has_a3v(void)
+{
+	return kvm_vgic_global_state.ich_vtr_el2 & ICH_VTR_A3V_MASK;
+}
+
 /**
  * kvm_vgic_setup_default_irq_routing:
  * Setup a default flat gsi routing table mapping all SPIs
-- 
2.34.1


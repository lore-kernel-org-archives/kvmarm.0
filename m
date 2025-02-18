Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF89F26E656
	for <kvmarm@lists.linux.dev>; Tue, 18 Feb 2025 16:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739896494; cv=none; b=NZcqmxOMJFA6pI290aZj3BNuh3WSl/2d8XygoqNEeuc2oEAXZXYRsUlMwRIyI/zYhCg+bqIZz8QXJGppVSVYdwVxGfVnCGg2d0k6fQyzNdOKIMkGhkts8K9EF9AgcW5Bg8UR54QJhRZEhnrIXWiEGE4eGpSWiptEhgfF6y426e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739896494; c=relaxed/simple;
	bh=ZVloPN1fD4UQcmC89bjs58//7KVKKTPl0NepyMe8SEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=uSeiq3zQg/mjbfEiCipo9U+oafr5gRXS5gOSu8vLdsJz9S01LRzpIqIIjLSqpSf6o8adxW5BpQJ/WeBRkXqc2iQ42iS8cMk2yRF3Fi+hQ5GCSmT/Ftc7RdITwI807/CxYt9vgt2H97wGt4fIxYk/8RyvGQuaV3m1MN9tU/4d3CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GjXGsKXi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GjXGsKXi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739896491;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h8+328qXkkbZhSNY9Ft7M6L1S6M16B35hy1ZghZxpZI=;
	b=GjXGsKXiRs0YiO7XA/lz+o40rT0sCs1K0Wk9RaJBb6ukeXBgBK+FQw+LsdxE07WBqqyGh2
	m4zHpUsWXab8WjPQXOO4Rp6/vWZvlb5/Bcr0hc+JjQUZ9crE1L0zBCVJRMwfaQ9rLksKSv
	LVr42JajPt1SAwh1Ug1IXQ3N1iA4Lkk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-412-dsQp0vRnPyuRqqfZ-2wDFw-1; Tue, 18 Feb 2025 11:34:50 -0500
X-MC-Unique: dsQp0vRnPyuRqqfZ-2wDFw-1
X-Mimecast-MFC-AGG-ID: dsQp0vRnPyuRqqfZ-2wDFw_1739896489
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43935bcec79so33966855e9.3
        for <kvmarm@lists.linux.dev>; Tue, 18 Feb 2025 08:34:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739896489; x=1740501289;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h8+328qXkkbZhSNY9Ft7M6L1S6M16B35hy1ZghZxpZI=;
        b=l2gex400D4sSd7DnS88gAI1HX0UNWPT+5HZPLOdsYIQ56gVzGTe/uohssMznx+kwZ5
         XHe4fMicXttwyj/NorvBCXxj4gIzChpDu0FVPJGAv/+nyuHNUo/zfySztWtkJC+c3tHo
         W9RPc/DdhosHByj1WHDv1cTvkiLbp0+yfzU2a/RysHykD6jvTRY7ECSznl1F58rM1gvp
         3NXdgrOZ0YolP3TcobPZwiKNzL0fhtqCnjs8fxu0JGNj3popgCvxAPKuJft87u1bPRqZ
         SLs2I8tKLa83sTJmuqNTTOv0ccwwf7rLTJP54arzbh5o4J8wFl6zyaHPomxX16ayb8Uv
         tDzg==
X-Forwarded-Encrypted: i=1; AJvYcCWQdsW93veoqUjIT1n9ZurVWoUIgjosPjAJyLwZRasLJC2O2At3CME/4K5YvpgwwHfDoB65eRA=@lists.linux.dev
X-Gm-Message-State: AOJu0YxbTQkbUbxprWPUKYJnpi//hgad8K3dQ8riqnxb6vIKjHzrhQ9D
	qmpYrYSLRmiTq/5VC4MJ1Svz/TTNRB477wixMT9KvJmidBs6A2YMnYxdzxWa7QPwKPr+sqqOWQy
	KU9FFDGUc4oUjyQ0yn/ek6VzWEGrnO42j3e7y01OKDOfPhDz4yfIg/g==
X-Gm-Gg: ASbGncuP3viWPNgoe1pOM01LGuw62dcU0XRnDjVC9ZJEj7HzWeEw/ync05A4hLpXIaW
	TY0HNPgBubVwcTqHX5+SEAH6cnN6wNIB/FSmWAitFtCFzVuo+pMZjA3WSraKE3MnAA4Fhkz+iIn
	a9/x1q+KJ4OulqaIJ7N3430YuMadAXENGSQmyYAgGmnjua/pMpA9cB5yCd5h/KUo8eb6Wi/P7gu
	bnMpqMyRFfU4FH83D19Nui6wWg2xGvcnZuVdpSaXKkt/mPIqwQI0mpxJVq+W6clC7bzQ9/6k9Nn
	lQN6VkTP698PyYMrgK6dORay4DSZVYpjN91x6tgDFX9ioEqyGilnqG29+xujNPMlMau/
X-Received: by 2002:a05:600c:4f0b:b0:439:8e3e:b0d6 with SMTP id 5b1f17b1804b1-4398e3eb2efmr50743835e9.13.1739896489426;
        Tue, 18 Feb 2025 08:34:49 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFoGgK4BaVZXPPpQ7eoOxfRAzJ7ZHbx/iMmEzLD1TPtPXGjU41tvzcRbGV+tANko10ThiC7sg==
X-Received: by 2002:a05:600c:4f0b:b0:439:8e3e:b0d6 with SMTP id 5b1f17b1804b1-4398e3eb2efmr50743515e9.13.1739896488934;
        Tue, 18 Feb 2025 08:34:48 -0800 (PST)
Received: from rh.redhat.com (p200300f6af0e4d00dda53016e366575f.dip0.t-ipconnect.de. [2003:f6:af0e:4d00:dda5:3016:e366:575f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4396b5267eesm85091845e9.0.2025.02.18.08.34.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2025 08:34:48 -0800 (PST)
From: Sebastian Ott <sebott@redhat.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc: Cornelia Huck <cohuck@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/4] KVM: arm64: Allow userspace to change AIDR_EL1
Date: Tue, 18 Feb 2025 17:34:42 +0100
Message-ID: <20250218163443.32836-4-sebott@redhat.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250218163443.32836-1-sebott@redhat.com>
References: <20250218163443.32836-1-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: aoMVCw0-mRnX23eM0QYOnlNKfICeHadyqkl015p7X6E_1739896489
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Enable VMMs to write AIDR_EL1 by treating it as a VM ID register.
Trap guest access of AIDR_EL1 when the VMs value differs from hardware.

Since this was the last invariant register remove all the stuff
that was needed to handle these.

Signed-off-by: Sebastian Ott <sebott@redhat.com>
---
 arch/arm64/include/asm/kvm_host.h |  3 ++
 arch/arm64/kvm/sys_regs.c         | 90 +++----------------------------
 2 files changed, 10 insertions(+), 83 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index c8fba4111b77..de735e2ad9ce 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -375,6 +375,7 @@ struct kvm_arch {
 
 	u64 midr_el1;
 	u64 revidr_el1;
+	u64 aidr_el1;
 	u64 ctr_el0;
 
 	/* Masks for VNCR-backed and general EL2 sysregs */
@@ -1475,6 +1476,8 @@ static inline u64 *__vm_id_reg(struct kvm_arch *ka, u32 reg)
 		return &ka->midr_el1;
 	case SYS_REVIDR_EL1:
 		return &ka->revidr_el1;
+	case SYS_AIDR_EL1:
+		return &ka->aidr_el1;
 	case SYS_CTR_EL0:
 		return &ka->ctr_el0;
 	default:
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c12fd91574ab..a1a683ba6bb9 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1667,7 +1667,7 @@ static bool is_feature_id_reg(u32 encoding)
 static inline bool is_vm_ftr_id_reg(u32 id)
 {
 	if (id == SYS_CTR_EL0 || id == SYS_MIDR_EL1 ||
-	    id == SYS_REVIDR_EL1)
+	    id == SYS_REVIDR_EL1 || id == SYS_AIDR_EL1)
 		return true;
 
 	return (sys_reg_Op0(id) == 3 && sys_reg_Op1(id) == 0 &&
@@ -2530,6 +2530,7 @@ static bool access_mdcr(struct kvm_vcpu *vcpu,
 
 FUNCTION_RESET(midr_el1)
 FUNCTION_RESET(revidr_el1)
+FUNCTION_RESET(aidr_el1)
 
 
 /*
@@ -2856,6 +2857,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  .set_user = set_clidr, .val = ~CLIDR_EL1_RES0 },
 	{ SYS_DESC(SYS_CCSIDR2_EL1), undef_access },
 	{ SYS_DESC(SYS_SMIDR_EL1), undef_access },
+	{ ID_DESC(AIDR_EL1), .set_user = set_id_reg_non_ftr, .visibility = id_visibility,
+	  .reset = reset_aidr_el1, .val = -1ULL },
 	{ SYS_DESC(SYS_CSSELR_EL1), access_csselr, reset_unknown, CSSELR_EL1 },
 	ID_FILTERED(CTR_EL0, ctr_el0,
 		    CTR_EL0_DIC_MASK |
@@ -4620,61 +4623,6 @@ id_to_sys_reg_desc(struct kvm_vcpu *vcpu, u64 id,
 	return r;
 }
 
-/*
- * These are the invariant sys_reg registers: we let the guest see the
- * host versions of these, so they're part of the guest state.
- *
- * A future CPU may provide a mechanism to present different values to
- * the guest, or a future kvm may trap them.
- */
-
-#define FUNCTION_INVARIANT(reg)						\
-	static u64 reset_##reg(struct kvm_vcpu *v,			\
-			       const struct sys_reg_desc *r)		\
-	{								\
-		((struct sys_reg_desc *)r)->val = read_sysreg(reg);	\
-		return ((struct sys_reg_desc *)r)->val;			\
-	}
-
-FUNCTION_INVARIANT(aidr_el1)
-
-/* ->val is filled in by kvm_sys_reg_table_init() */
-static struct sys_reg_desc invariant_sys_regs[] __ro_after_init = {
-	{ SYS_DESC(SYS_AIDR_EL1), NULL, reset_aidr_el1 },
-};
-
-static int get_invariant_sys_reg(u64 id, u64 __user *uaddr)
-{
-	const struct sys_reg_desc *r;
-
-	r = get_reg_by_id(id, invariant_sys_regs,
-			  ARRAY_SIZE(invariant_sys_regs));
-	if (!r)
-		return -ENOENT;
-
-	return put_user(r->val, uaddr);
-}
-
-static int set_invariant_sys_reg(u64 id, u64 __user *uaddr)
-{
-	const struct sys_reg_desc *r;
-	u64 val;
-
-	r = get_reg_by_id(id, invariant_sys_regs,
-			  ARRAY_SIZE(invariant_sys_regs));
-	if (!r)
-		return -ENOENT;
-
-	if (get_user(val, uaddr))
-		return -EFAULT;
-
-	/* This is what we mean by invariant: you can't change it. */
-	if (r->val != val)
-		return -EINVAL;
-
-	return 0;
-}
-
 static int demux_c15_get(struct kvm_vcpu *vcpu, u64 id, void __user *uaddr)
 {
 	u32 val;
@@ -4756,15 +4704,10 @@ int kvm_sys_reg_get_user(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg,
 int kvm_arm_sys_reg_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
 	void __user *uaddr = (void __user *)(unsigned long)reg->addr;
-	int err;
 
 	if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_DEMUX)
 		return demux_c15_get(vcpu, reg->id, uaddr);
 
-	err = get_invariant_sys_reg(reg->id, uaddr);
-	if (err != -ENOENT)
-		return err;
-
 	return kvm_sys_reg_get_user(vcpu, reg,
 				    sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
 }
@@ -4800,15 +4743,10 @@ int kvm_sys_reg_set_user(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg,
 int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
 	void __user *uaddr = (void __user *)(unsigned long)reg->addr;
-	int err;
 
 	if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_DEMUX)
 		return demux_c15_set(vcpu, reg->id, uaddr);
 
-	err = set_invariant_sys_reg(reg->id, uaddr);
-	if (err != -ENOENT)
-		return err;
-
 	return kvm_sys_reg_set_user(vcpu, reg,
 				    sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
 }
@@ -4897,23 +4835,13 @@ static int walk_sys_regs(struct kvm_vcpu *vcpu, u64 __user *uind)
 
 unsigned long kvm_arm_num_sys_reg_descs(struct kvm_vcpu *vcpu)
 {
-	return ARRAY_SIZE(invariant_sys_regs)
-		+ num_demux_regs()
-		+ walk_sys_regs(vcpu, (u64 __user *)NULL);
+	return num_demux_regs()	+ walk_sys_regs(vcpu, (u64 __user *)NULL);
 }
 
 int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 {
-	unsigned int i;
 	int err;
 
-	/* Then give them all the invariant registers' indices. */
-	for (i = 0; i < ARRAY_SIZE(invariant_sys_regs); i++) {
-		if (put_user(sys_reg_to_index(&invariant_sys_regs[i]), uindices))
-			return -EFAULT;
-		uindices++;
-	}
-
 	err = walk_sys_regs(vcpu, uindices);
 	if (err < 0)
 		return err;
@@ -4987,7 +4915,8 @@ static void vcpu_set_hcr(struct kvm_vcpu *vcpu)
 	else
 		vcpu->arch.hcr_el2 |= HCR_TID2;
 
-	if (kvm_read_vm_id_reg(kvm, SYS_REVIDR_EL1) != read_sysreg(REVIDR_EL1))
+	if ((kvm_read_vm_id_reg(kvm, SYS_REVIDR_EL1) != read_sysreg(REVIDR_EL1)) ||
+	    (kvm_read_vm_id_reg(kvm, SYS_AIDR_EL1) != read_sysreg(AIDR_EL1)))
 		vcpu->arch.hcr_el2 |= HCR_TID1;
 
 	if (vcpu_el1_is_32bit(vcpu))
@@ -5142,16 +5071,11 @@ int __init kvm_sys_reg_table_init(void)
 	valid &= check_sysreg_table(cp14_64_regs, ARRAY_SIZE(cp14_64_regs), true);
 	valid &= check_sysreg_table(cp15_regs, ARRAY_SIZE(cp15_regs), true);
 	valid &= check_sysreg_table(cp15_64_regs, ARRAY_SIZE(cp15_64_regs), true);
-	valid &= check_sysreg_table(invariant_sys_regs, ARRAY_SIZE(invariant_sys_regs), false);
 	valid &= check_sysreg_table(sys_insn_descs, ARRAY_SIZE(sys_insn_descs), false);
 
 	if (!valid)
 		return -EINVAL;
 
-	/* We abuse the reset function to overwrite the table itself. */
-	for (i = 0; i < ARRAY_SIZE(invariant_sys_regs); i++)
-		invariant_sys_regs[i].reset(NULL, &invariant_sys_regs[i]);
-
 	ret = populate_nv_trap_config();
 
 	for (i = 0; !ret && i < ARRAY_SIZE(sys_reg_descs); i++)
-- 
2.42.0


Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96993250BF3
	for <kvmarm@lists.linux.dev>; Tue, 11 Feb 2025 14:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739284762; cv=none; b=R+HI85qGaI8Wt5dCIsSdOJ33kO3qMl7KIUcfKMsmq+E1z0h3+jq4k0SZ2anLT59q3lvL5Qq1yaAp6m59Vm0OPB4wR3cc5q3ljJS4id+jCeTN7XD3uzQlKjXF70lXddnlpTW9s3WWjlxDxB4sabOAPt53Q/sjeiJzq+UXYnUYmzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739284762; c=relaxed/simple;
	bh=Xh97xB0t4V0m4yRQ6og3fwpvTr3Hlw3peV8Pp9xA1Vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=dJdRC6sMVi2cDYYb9CyR+/EeyIpIcQVDDQ8R10ROX1sGlSBMOkX6WjE+9xfpy4CnhgbXEcC9Ypk/Tr5RcQq4ftEd+G3QU9kVnJKXg5RRN0gDigMwW520CBZ5P8CZFqjPbV1usfvFXF6aAh5f/26AFE7tFmbzu+a3osJekDxaKhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QMf85Rff; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QMf85Rff"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739284759;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wSVu+15UXFfSOFL1ip9ZLwAcn38zQdv9iDAl5Qkapx0=;
	b=QMf85RffKE+IHWUA/luVWT5OOYZG6ZD3Vi+zNqIo8xvs34qVy+fYykbdZze/7X7jHN3ttw
	/WRi08yn4+LR8Uo9ezEVZrQ3R3w+s6rl7aNvVj8gfN0OB0drvBN/XrUO1YCd7QLnAzXpf1
	H2/TCVn1DUZQk6yl4EQOr2CEYR9+LnE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-312-JP3XwsX_O6GHzOEzUsxK2Q-1; Tue, 11 Feb 2025 09:39:16 -0500
X-MC-Unique: JP3XwsX_O6GHzOEzUsxK2Q-1
X-Mimecast-MFC-AGG-ID: JP3XwsX_O6GHzOEzUsxK2Q
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-38dca55788eso2450491f8f.1
        for <kvmarm@lists.linux.dev>; Tue, 11 Feb 2025 06:39:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739284755; x=1739889555;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wSVu+15UXFfSOFL1ip9ZLwAcn38zQdv9iDAl5Qkapx0=;
        b=jTiFwrAU3pr2mVwanr4aUMOAlK23nQ9uCWVJWsr4G3H5FajskUxI6Kc518+vD86t4K
         Gaq+2kahMGuD2rH9lJmrzJLMrI6yMWWW3zORdwrChtXIIkQW4if6Ljz/8faJBruk2xor
         nHhqfSaXPdpkhIEG79tvWz98tHyH3MGPsg/KAe4BmoJXamy91DSt6Q9/GElr/pDixfVp
         AsnNLlOdrv4hqTQm+fwpGLluQv9bl+VkR4fmiQFP5ZOh8Lxof6XAZvCQUxaC7IOo54cf
         1XJUvIegdeggCzYXJMdy4Guo/n6/y+VpOzQToWSLNCpPFzf6xcsO5uETkDAj6f6LufXA
         HLWA==
X-Forwarded-Encrypted: i=1; AJvYcCVcd8NZ/XLopqjk7I7/QDqcDi2WuvaqUALE/kEa3XR8Pb9bVUT8T6pXmf/mx09K3mtUHcJhZ7Y=@lists.linux.dev
X-Gm-Message-State: AOJu0YyZExCAJo8TEbUHlhD/3hNrrUCxP52eDXLOeJZFRHpzBqUSaRfv
	uqpM45F/HR1QXk8Oe8EHohDiVWSKpjmx/PnN1bBBK6FhZbL1MUMcn+DCPphSxK3dmgqO0VQ0KDK
	PWZvsR85P5+QGrb2yYWfiUECxPh4F6LAgYb1LOebQtVADrR53SP35HQ==
X-Gm-Gg: ASbGncs8x9t3pxJhpe34oqAVBRAJ2/L/w20ac1MSDRtNxOucFSaoaLPYs4tzjWoMzXb
	x4VlKheXETjCHZcvKguqaHFLgHBxqyiNv5x7GVvRCK5wXU57pwCeHlvsN8xDhQd+3CTJqNrSi9C
	tLjAQT79IfdJ2lc1xlNKicyNQu0OpBVW6x9XcAyTEsS0VSCqRNA/oVhNT0lWda9Ld5O69JX7FOO
	VzMAAZLi9tYuIlQfInlhnQNFVQFRC072e2y234qzwcNRyWAs5/0lPccHQnN0QYNyYwF4Aj5/9CT
	g21haku+8zG0MWYR6FSUg+obYOQ7+E0o9vLfwfFZTkkw7Aq2mvAOeftJsRGktnZUC2g=
X-Received: by 2002:adf:ef4c:0:b0:38d:bec9:c8d with SMTP id ffacd0b85a97d-38dc936545bmr10411282f8f.53.1739284754973;
        Tue, 11 Feb 2025 06:39:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGVlLeeltNgiMbHSqxLznPIfhFN4eDHUttCSHrTtTV0bsdUK3PjmcFdHZ6fTWELMuF2PXz6rg==
X-Received: by 2002:adf:ef4c:0:b0:38d:bec9:c8d with SMTP id ffacd0b85a97d-38dc936545bmr10411256f8f.53.1739284754577;
        Tue, 11 Feb 2025 06:39:14 -0800 (PST)
Received: from rh.fritz.box (p200300f6af0e4d00dda53016e366575f.dip0.t-ipconnect.de. [2003:f6:af0e:4d00:dda5:3016:e366:575f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38dcc9bd251sm11745833f8f.9.2025.02.11.06.39.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2025 06:39:13 -0800 (PST)
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
Subject: [PATCH v2 2/4] KVM: arm64: Allow userspace to change REVIDR_EL1
Date: Tue, 11 Feb 2025 15:39:08 +0100
Message-ID: <20250211143910.16775-3-sebott@redhat.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250211143910.16775-1-sebott@redhat.com>
References: <20250211143910.16775-1-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: RxeYoWH0xkLA45EbmneoR7CjcHZ8IunIHEdhhivWuRM_1739284755
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Enable VMMs to write REVIDR_EL1 by treating it as a VM ID register.
Trap guest access of REVIDR_EL1 when the VMs value differs from hardware.

Signed-off-by: Sebastian Ott <sebott@redhat.com>
---
 arch/arm64/include/asm/kvm_host.h |  3 +++
 arch/arm64/kvm/sys_regs.c         | 11 ++++++++---
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 3db8c773339e..c8fba4111b77 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -374,6 +374,7 @@ struct kvm_arch {
 	u64 id_regs[KVM_ARM_ID_REG_NUM];
 
 	u64 midr_el1;
+	u64 revidr_el1;
 	u64 ctr_el0;
 
 	/* Masks for VNCR-backed and general EL2 sysregs */
@@ -1472,6 +1473,8 @@ static inline u64 *__vm_id_reg(struct kvm_arch *ka, u32 reg)
 		return &ka->id_regs[IDREG_IDX(reg)];
 	case SYS_MIDR_EL1:
 		return &ka->midr_el1;
+	case SYS_REVIDR_EL1:
+		return &ka->revidr_el1;
 	case SYS_CTR_EL0:
 		return &ka->ctr_el0;
 	default:
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 7e1c9884f62a..646c0a04e58a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1666,7 +1666,8 @@ static bool is_feature_id_reg(u32 encoding)
  */
 static inline bool is_vm_ftr_id_reg(u32 id)
 {
-	if (id == SYS_CTR_EL0 || id == SYS_MIDR_EL1)
+	if (id == SYS_CTR_EL0 || id == SYS_MIDR_EL1 ||
+	    id == SYS_REVIDR_EL1)
 		return true;
 
 	return (sys_reg_Op0(id) == 3 && sys_reg_Op1(id) == 0 &&
@@ -2542,6 +2543,7 @@ static bool access_mdcr(struct kvm_vcpu *vcpu,
 	}
 
 FUNCTION_RESET(midr_el1)
+FUNCTION_RESET(revidr_el1)
 
 
 /*
@@ -2595,6 +2597,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ ID_DESC(MIDR_EL1), .set_user = set_id_reg_non_ftr, .visibility = id_visibility,
 	  .reset = reset_midr_el1, .val = GENMASK_ULL(31, 0) },
 	{ SYS_DESC(SYS_MPIDR_EL1), NULL, reset_mpidr, MPIDR_EL1 },
+	{ ID_DESC(REVIDR_EL1), .set_user = set_id_reg_non_ftr, .visibility = id_visibility,
+	  .reset = reset_revidr_el1, .val = -1ULL },
 
 	/*
 	 * ID regs: all ID_SANITISED() entries here must have corresponding
@@ -4646,12 +4650,10 @@ id_to_sys_reg_desc(struct kvm_vcpu *vcpu, u64 id,
 		return ((struct sys_reg_desc *)r)->val;			\
 	}
 
-FUNCTION_INVARIANT(revidr_el1)
 FUNCTION_INVARIANT(aidr_el1)
 
 /* ->val is filled in by kvm_sys_reg_table_init() */
 static struct sys_reg_desc invariant_sys_regs[] __ro_after_init = {
-	{ SYS_DESC(SYS_REVIDR_EL1), NULL, reset_revidr_el1 },
 	{ SYS_DESC(SYS_AIDR_EL1), NULL, reset_aidr_el1 },
 };
 
@@ -4999,6 +5001,9 @@ static void vcpu_set_hcr(struct kvm_vcpu *vcpu)
 	else
 		vcpu->arch.hcr_el2 |= HCR_TID2;
 
+	if (kvm_read_vm_id_reg(kvm, SYS_REVIDR_EL1) != read_sysreg(REVIDR_EL1))
+		vcpu->arch.hcr_el2 |= HCR_TID1;
+
 	if (vcpu_el1_is_32bit(vcpu))
 		vcpu->arch.hcr_el2 &= ~HCR_RW;
 
-- 
2.42.0


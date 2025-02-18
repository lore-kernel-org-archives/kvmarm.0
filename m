Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB36A26D5CA
	for <kvmarm@lists.linux.dev>; Tue, 18 Feb 2025 16:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739896493; cv=none; b=XlOhEu4VPU7KZwbr/hGPpaGvPuQ6rSQXLXbBh8dD9MfRu74F6hsyULTLUPU0yJUFQj8WzgjD226whIvwaQprCcGhhcwJ6VLGy0r2y8INCIY1C79XO2i24gZRpfIgW0jubbC8KppCtuEXUtzB6r/GasDDBO9F0j2jWh/SZUioios=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739896493; c=relaxed/simple;
	bh=kI8f+ZCKDCxxkN6vwc72VPsmzF9WcnNXHOsT35Jb1nw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=RQ6BCZVrSC4KdwIa3r48rMwmnTpEBhl+46Vtp6HCJIbg4KKqnbxHsCBClVec+XaUcnmErMT5sysOjWuP42po2OgJe/rL4MA/1oPLLjyPQnLeRBEFzoe4kP4AoNnJZbSP4C64CKH70AsBEZGcwhWrs09iTotcc8klf/RwFufF4Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EB5AY1Ol; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EB5AY1Ol"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739896491;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NeQXcS3pEHXKPjpS1aBvSo5HEPQatvaCcC9yZ+tXu5k=;
	b=EB5AY1OlGGXUjRN54smarfmdWmFM5mi139/Gmy30QyK8VzHIIexxJqkCNDhzviuQ9P2RWV
	1dHqQng/syHPSwcUq6IvpiADNHD76zZ76pDpRZ6OyPGssfcq+OHtlQ9chl1iIMFDSqSPto
	JEgPPdhHYfe8XFH1xwnvxanY67S9ux0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-54-k_UkmxJrNFmWiSxN2AIojA-1; Tue, 18 Feb 2025 11:34:49 -0500
X-MC-Unique: k_UkmxJrNFmWiSxN2AIojA-1
X-Mimecast-MFC-AGG-ID: k_UkmxJrNFmWiSxN2AIojA_1739896488
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4393e89e910so30365305e9.0
        for <kvmarm@lists.linux.dev>; Tue, 18 Feb 2025 08:34:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739896488; x=1740501288;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NeQXcS3pEHXKPjpS1aBvSo5HEPQatvaCcC9yZ+tXu5k=;
        b=GwDizndm+OgK5vqRnzG/3ZGQjGlZye6vHNc8+KlFiPTY/GWk0Xfde2IToliuRXNpZi
         Vh3X1XH6DQGf3QNEHdCTMS+yrWmU8XtWAAmSVo+6x2up07qE/7ND+T08IE+Ol1Cocgjx
         s0pp2d5B2QE7g0inI55S5X2JzNJKrA2RL/3HgAKllDudFcGtsvUCNBCxcj4HWSFzl6j3
         gdsI6boeye9u6sNYu+gCLfzraEg8rUOF2kZ8rc1rYTpmR+W1ODwnEyidBElNCFax94tx
         22Q6fvcF6L/zGAU9dkRyUwvJTJ661qA6mnqd9OPW/rOXAHZRa/WtTvdv6KqRYWOVlgwn
         j9Ew==
X-Forwarded-Encrypted: i=1; AJvYcCUYqUbNYyqpLFfPahCVRJITztGUJ/2oo9JBq9Zs5amCnlAJ7hkHGHK6jRGa2D6M9UrSJpqMxX0=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywzg0a5oi7zsF9gAtmlcnQXpH0o29P+64pxiqg0Var7e2K55GeM
	kMLavCCZLKUMd8ArDhL5FyJ6JuAKVeMSpxH6f0AXQHnlSWID3bV2N7R0iEfCM0/7yCJjf0Q2S9y
	7U1n5IN7MvNazLUJLHxF8WSPTvcYOd9jbzAdSXzhoYzACGPAcOPhRGQ==
X-Gm-Gg: ASbGncu2k4fK5LappJqKEhLApG74EjPwrbCxYwFqdSFVvibUcIUmInnFI2XvkHWb7Wp
	gKO7rUvVPY8f+Ii2lX5X/PU81eDLavUT1nlSwLDp1FnGg1QU6kk7ou1OZVwbZquOLtAcXrqbTL0
	+X1H5rx6r/Fa26h/KjXv61TYCc4QgrXUH0uXF6WVepxWUDD36EHQgmEZJX5nHu5rBIxUyEkhqvp
	BADQ4iIIfAE4nhlMWCmyx6nl03WMIqeMKl6q6x3Dxdkt1A/hD9yEiNdj06p2uKwNHeYk5U80tf3
	TUST1zYI5rMpwVSkQRkjFNAem2z4KKNmEAlStGamPneqPZc+FBypCwVz0Smq+p5tTBxs
X-Received: by 2002:a05:600c:1c86:b0:439:9863:e876 with SMTP id 5b1f17b1804b1-4399863e985mr12624685e9.24.1739896488298;
        Tue, 18 Feb 2025 08:34:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGhjzSey7Os9gD/9cBHHf8QXaWprjYC5klxAlQo6nfv7hgprgS0BPQtKhe2iSIdbXKsawM7OA==
X-Received: by 2002:a05:600c:1c86:b0:439:9863:e876 with SMTP id 5b1f17b1804b1-4399863e985mr12624455e9.24.1739896487978;
        Tue, 18 Feb 2025 08:34:47 -0800 (PST)
Received: from rh.redhat.com (p200300f6af0e4d00dda53016e366575f.dip0.t-ipconnect.de. [2003:f6:af0e:4d00:dda5:3016:e366:575f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4396b5267eesm85091845e9.0.2025.02.18.08.34.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2025 08:34:46 -0800 (PST)
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
Subject: [PATCH v3 2/4] KVM: arm64: Allow userspace to change REVIDR_EL1
Date: Tue, 18 Feb 2025 17:34:41 +0100
Message-ID: <20250218163443.32836-3-sebott@redhat.com>
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
X-Mimecast-MFC-PROC-ID: U9XzIpQKhz6sdEA_W2OQ4Owbauuh3Qsu5uwWr5o0PKA_1739896488
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
index 3cd4dfdd287a..c12fd91574ab 100644
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
@@ -2528,6 +2529,7 @@ static bool access_mdcr(struct kvm_vcpu *vcpu,
 	}
 
 FUNCTION_RESET(midr_el1)
+FUNCTION_RESET(revidr_el1)
 
 
 /*
@@ -2581,6 +2583,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ ID_DESC(MIDR_EL1), .set_user = set_id_reg_non_ftr, .visibility = id_visibility,
 	  .reset = reset_midr_el1, .val = GENMASK_ULL(31, 0) },
 	{ SYS_DESC(SYS_MPIDR_EL1), NULL, reset_mpidr, MPIDR_EL1 },
+	{ ID_DESC(REVIDR_EL1), .set_user = set_id_reg_non_ftr, .visibility = id_visibility,
+	  .reset = reset_revidr_el1, .val = -1ULL },
 
 	/*
 	 * ID regs: all ID_SANITISED() entries here must have corresponding
@@ -4632,12 +4636,10 @@ id_to_sys_reg_desc(struct kvm_vcpu *vcpu, u64 id,
 		return ((struct sys_reg_desc *)r)->val;			\
 	}
 
-FUNCTION_INVARIANT(revidr_el1)
 FUNCTION_INVARIANT(aidr_el1)
 
 /* ->val is filled in by kvm_sys_reg_table_init() */
 static struct sys_reg_desc invariant_sys_regs[] __ro_after_init = {
-	{ SYS_DESC(SYS_REVIDR_EL1), NULL, reset_revidr_el1 },
 	{ SYS_DESC(SYS_AIDR_EL1), NULL, reset_aidr_el1 },
 };
 
@@ -4985,6 +4987,9 @@ static void vcpu_set_hcr(struct kvm_vcpu *vcpu)
 	else
 		vcpu->arch.hcr_el2 |= HCR_TID2;
 
+	if (kvm_read_vm_id_reg(kvm, SYS_REVIDR_EL1) != read_sysreg(REVIDR_EL1))
+		vcpu->arch.hcr_el2 |= HCR_TID1;
+
 	if (vcpu_el1_is_32bit(vcpu))
 		vcpu->arch.hcr_el2 &= ~HCR_RW;
 
-- 
2.42.0


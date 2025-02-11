Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3614A2505C8
	for <kvmarm@lists.linux.dev>; Tue, 11 Feb 2025 14:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739284758; cv=none; b=FDTpDjyX907qQpY+wLav3v26T8f8Sod9MeIahFvkfpVPvWPpSC4gabg58QCDWlcjCSAVRijY4VRAj+xvIZ+NHMK9Cmuzt2Mj2/xI5xMlVKT8D+Uwl+QNuhFknfP4WXA0v34D/xVoNmbNEvYC1D6sXlfIqrDyPWaVc1NgiJcvAxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739284758; c=relaxed/simple;
	bh=7JHbJ2DuZCv74J5NSz9ZAXfYRHZMl6ToNndRqFA4VjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=XXAzum6bRDU1Tlj5DPoLWCmpuP81dW7ZLitVFN6kq0571nrtGcyjr2AP8BFQfgB4s3H3kq1bY6hMb2KJKyeKHWJ/TkheQbDEy4U+njN/nMlSNao0mI86qaG/I/ic4hR2XbonHsQ0LhwPtG+ctsUgN9Eyi2OTMU3NNVkxb9m/Un0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Lzk5C4B9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Lzk5C4B9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739284756;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dxQC5OSA8UNrYi2FsJ8qImpmh+po7bw6P6uEsaW3lFQ=;
	b=Lzk5C4B9GjZ2an/tNM3/oWFxQtpWdXnojQAyeoFjcE2poWgAEJId1Yze17GFXw3s1X7UOw
	b0x8DViAC00aQdC8BfXCYCN+Z7yr+4k8rgfl7X6Qa+hh8WEmlrY1dqo199DnYEfPVzu7qN
	g54emXkCP3/1bz0ypc9X60ABlilI8qc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-166-HEvbZ6F4POekRB3DcGL15A-1; Tue, 11 Feb 2025 09:39:15 -0500
X-MC-Unique: HEvbZ6F4POekRB3DcGL15A-1
X-Mimecast-MFC-AGG-ID: HEvbZ6F4POekRB3DcGL15A
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4394c489babso7448555e9.1
        for <kvmarm@lists.linux.dev>; Tue, 11 Feb 2025 06:39:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739284754; x=1739889554;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dxQC5OSA8UNrYi2FsJ8qImpmh+po7bw6P6uEsaW3lFQ=;
        b=Sakh5d5Jzg9cs0h4aMV1KVDZlZWB9vTMaoqloRvJbSF6veFcjZp2u9tstxyHk0kPqd
         4JeFoNNJUhS5+4O0HCOOaj/ihVyeSid1C2//NMechM5GsYefqCOgAXyFaVKi6hhQ0DjX
         ay1+wBw8V61XcBf7eD/8K5lhMiX2Xq5QhaG4mwhGvOasEPIe2pQsj06ZwlkBBxxt+OWp
         t4C24kHSzMrZTJYlwcKuE84WSMHXDutibWqXp0p14e/NtFSxbF2lOCo+nDQtEdaVC3xP
         kazrRxs4w759EfRwX0sbN6BUUjBQr10UXCwcR9kHh4If11Yb8ITO+d37u2Vx5XnJwVvZ
         bHMw==
X-Forwarded-Encrypted: i=1; AJvYcCVXp0NhpW1gyZ+fp9PwhtC/A1iyidKeC5CI3pBIoxltoncP4hbMkgdj10FQViGHjCu5utiuzd0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzzPKof3w6PHZKaRNiox6UBcpWoepQn7X4ayVq0XpTVKA00LVND
	eB1tFOaKQw/yX5IJksi9agPhbmdhvgOg4B10Yyao1cOLCpXHZwkJsOgZL7OdzlTt3IwQYcUiTSD
	PehHeyWHZnPOiykFe6yvwjbM3Aq9F4K5UQ64rrnzqjJ7ZXXOAkX0+Ow==
X-Gm-Gg: ASbGnctI3m2in0RmSGoBxL27vNRBJYO1ScF2DG51qE6wdhwAcht3UhqbqbQqAbMjzfJ
	+RFWF/wLTmCyTTX5e3mu6UnHdtO/dNUJXwJMMuhRmOn4gnK9L6rzu4QDvQDA/uHhBgj9CocHlMh
	mFCu2UPkJ9wrtkn1i5pQnjH8BZJqwH4ZIcPldRn3kXjU9Y9x4zmDvyTSEADf7Al40KqhbVgN6Ty
	yJ7bTYvFzzJ8z46kI4ESOVuHhO5037Qft6mR7ccO1sC1RtubAS/TjAkdOiw6oEFfyDrpcE6dP5U
	hws/O9CyRY3zfxHg7nBOqCKvazENWP3p520c3OokGj2rxjUWv4bYjL6sgqfT4s3HSZU=
X-Received: by 2002:a05:600c:190c:b0:439:42c6:f11f with SMTP id 5b1f17b1804b1-43942c6f5eemr83107045e9.4.1739284753679;
        Tue, 11 Feb 2025 06:39:13 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFDvsaYgzTa5RWn9BkqT6d0zbIYe+dTe5ziVPY8IeCNWz/AYeRHaPoW5P6jv6YFeryIf9I1Lg==
X-Received: by 2002:a05:600c:190c:b0:439:42c6:f11f with SMTP id 5b1f17b1804b1-43942c6f5eemr83106725e9.4.1739284753304;
        Tue, 11 Feb 2025 06:39:13 -0800 (PST)
Received: from rh.fritz.box (p200300f6af0e4d00dda53016e366575f.dip0.t-ipconnect.de. [2003:f6:af0e:4d00:dda5:3016:e366:575f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38dcc9bd251sm11745833f8f.9.2025.02.11.06.39.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2025 06:39:12 -0800 (PST)
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
Subject: [PATCH v2 1/4] KVM: arm64: Allow userspace to change MIDR_EL1
Date: Tue, 11 Feb 2025 15:39:07 +0100
Message-ID: <20250211143910.16775-2-sebott@redhat.com>
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
X-Mimecast-MFC-PROC-ID: w9cW0XYwVSuavI2d0bDjixTgAE_eDHk472-lrEiYntE_1739284754
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Enable VMMs to write MIDR_EL1 by treating it as a VM ID register.
Since MIDR_EL1 is not handled as a proper arm64_ftr_reg apply only
a sanity check against the writable mask to ensure the reserved
bits are 0.

Set up VPIDR_EL2 to hold the MIDR_EL1 value for the guest.

Signed-off-by: Sebastian Ott <sebott@redhat.com>
---
 arch/arm64/include/asm/kvm_host.h |  3 ++
 arch/arm64/kvm/sys_regs.c         | 56 +++++++++++++++++++++++++++++--
 2 files changed, 56 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7cfa024de4e3..3db8c773339e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -373,6 +373,7 @@ struct kvm_arch {
 #define KVM_ARM_ID_REG_NUM	(IDREG_IDX(sys_reg(3, 0, 0, 7, 7)) + 1)
 	u64 id_regs[KVM_ARM_ID_REG_NUM];
 
+	u64 midr_el1;
 	u64 ctr_el0;
 
 	/* Masks for VNCR-backed and general EL2 sysregs */
@@ -1469,6 +1470,8 @@ static inline u64 *__vm_id_reg(struct kvm_arch *ka, u32 reg)
 	switch (reg) {
 	case sys_reg(3, 0, 0, 1, 0) ... sys_reg(3, 0, 0, 7, 7):
 		return &ka->id_regs[IDREG_IDX(reg)];
+	case SYS_MIDR_EL1:
+		return &ka->midr_el1;
 	case SYS_CTR_EL0:
 		return &ka->ctr_el0;
 	default:
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 82430c1e1dd0..7e1c9884f62a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1666,7 +1666,7 @@ static bool is_feature_id_reg(u32 encoding)
  */
 static inline bool is_vm_ftr_id_reg(u32 id)
 {
-	if (id == SYS_CTR_EL0)
+	if (id == SYS_CTR_EL0 || id == SYS_MIDR_EL1)
 		return true;
 
 	return (sys_reg_Op0(id) == 3 && sys_reg_Op1(id) == 0 &&
@@ -1999,6 +1999,47 @@ static int get_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	return 0;
 }
 
+static int set_id_reg_non_ftr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
+			      u64 val)
+{
+	u32 id = reg_to_encoding(rd);
+	int ret;
+
+	mutex_lock(&vcpu->kvm->arch.config_lock);
+	/*
+	 * Once the VM has started the ID registers are immutable. Reject any
+	 * write that does not match the final register value.
+	 */
+	if (kvm_vm_has_ran_once(vcpu->kvm)) {
+		if (val != read_id_reg(vcpu, rd))
+			ret = -EBUSY;
+		else
+			ret = 0;
+
+		mutex_unlock(&vcpu->kvm->arch.config_lock);
+		return ret;
+	}
+
+	/*
+	 * For non ftr regs do a limited test against the writable mask only.
+	 */
+	if ((rd->val & val) != val) {
+		mutex_unlock(&vcpu->kvm->arch.config_lock);
+		return -EINVAL;
+	}
+
+	kvm_set_vm_id_reg(vcpu->kvm, id, val);
+	/*
+	 * Since guest access to MIDR_EL1 is not trapped
+	 * set up VPIDR_EL2 to hold the MIDR_EL1 value.
+	 */
+	if (id == SYS_MIDR_EL1)
+		write_sysreg(val, vpidr_el2);
+
+	mutex_unlock(&vcpu->kvm->arch.config_lock);
+	return 0;
+}
+
 static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		      u64 val)
 {
@@ -2493,6 +2534,15 @@ static bool access_mdcr(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+#define FUNCTION_RESET(reg)						\
+	static u64 reset_##reg(struct kvm_vcpu *v,			\
+			       const struct sys_reg_desc *r)		\
+	{								\
+		return read_sysreg(reg);				\
+	}
+
+FUNCTION_RESET(midr_el1)
+
 
 /*
  * Architected system registers.
@@ -2542,6 +2592,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	{ SYS_DESC(SYS_DBGVCR32_EL2), undef_access, reset_val, DBGVCR32_EL2, 0 },
 
+	{ ID_DESC(MIDR_EL1), .set_user = set_id_reg_non_ftr, .visibility = id_visibility,
+	  .reset = reset_midr_el1, .val = GENMASK_ULL(31, 0) },
 	{ SYS_DESC(SYS_MPIDR_EL1), NULL, reset_mpidr, MPIDR_EL1 },
 
 	/*
@@ -4594,13 +4646,11 @@ id_to_sys_reg_desc(struct kvm_vcpu *vcpu, u64 id,
 		return ((struct sys_reg_desc *)r)->val;			\
 	}
 
-FUNCTION_INVARIANT(midr_el1)
 FUNCTION_INVARIANT(revidr_el1)
 FUNCTION_INVARIANT(aidr_el1)
 
 /* ->val is filled in by kvm_sys_reg_table_init() */
 static struct sys_reg_desc invariant_sys_regs[] __ro_after_init = {
-	{ SYS_DESC(SYS_MIDR_EL1), NULL, reset_midr_el1 },
 	{ SYS_DESC(SYS_REVIDR_EL1), NULL, reset_revidr_el1 },
 	{ SYS_DESC(SYS_AIDR_EL1), NULL, reset_aidr_el1 },
 };
-- 
2.42.0


Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5260A26B966
	for <kvmarm@lists.linux.dev>; Thu,  6 Mar 2025 18:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741286421; cv=none; b=R3nY6HonUTySrvmL7lei0Eq1UQWkjgEZsfSHEMePofBmA6HQDb6TtuygAyfiNJHV8LvJp4iGAqrhQTytrNt4i8/reSzBPmmriHPojjl99oGlCOfYX23YjoWGENpSfvDLXHnBLo6JWPeqbfWuyBqIz76mNyVihJ9qMOz1BtEmM88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741286421; c=relaxed/simple;
	bh=LkKR288RE+h611Y9F4OQZCS2oNAv31ZfvfnKlmFsXKM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=jqSHqpFx1c4TF6FqYpHbVNT6D8PD4Istmwv2v+y+oxUhnq37xejrFm+SEmrmS6K9vpUPJ+FrCzEeD9vE8ledxCySowg6I5ejbRzvVS06V0sHnP15kkYwHM7uhoBwikv33Xr66Kz4wbMhr1/RgTL5H1ulMXVZdKH+zLUfAWRBrfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UVFBFxO9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UVFBFxO9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741286417;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=9Lmst4VUAQQ3LJJdXWEWRCBJzpFOzVT70uwpvEP3i+I=;
	b=UVFBFxO9xTJDT13it9EXLNgb3Vi9xPXnlrE0DOgAqQqY2/hnjOZ6DIz4l34FKlD+wJ4EIj
	4E5rlTNLcFr1dQRcZdKKq5+zdJmmWyOg/mFV15R8QRb3kNSkPFrGOPpFhBwFYh5jGsoI0U
	IF2ujfJ/Q3gXvfCnAcPuFyMkHioZHtM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-370-JNpwo9LNMOmbopNBEVFOJw-1; Thu, 06 Mar 2025 13:40:16 -0500
X-MC-Unique: JNpwo9LNMOmbopNBEVFOJw-1
X-Mimecast-MFC-AGG-ID: JNpwo9LNMOmbopNBEVFOJw_1741286415
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3912e4e2033so485256f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 06 Mar 2025 10:40:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741286415; x=1741891215;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9Lmst4VUAQQ3LJJdXWEWRCBJzpFOzVT70uwpvEP3i+I=;
        b=jdi/49S6CnY/GDSEuBSH4Q7BpkxS8WAePLvg9khJEz8ixshGbe6QcSqDeCM4AKwSjP
         KXkdXPwcztZV3k89y75tsJEX/OZGFh6mIVwvfSNNgAWzhAdQPMRFd4ERVPNpVeFNbkwj
         wehapUMly5t+RlzeP9oWO/He8jvAM+zx9V5FxIDfeNKfoXGR9KqrR4qfH4fF3Iu3r0F/
         JQcttW6OrroXdt4VGHJ4splEJ7Gd3OrDVWXMv111uBBWtdQcj5BavjDqLnJzM5rDep5t
         +5O5gPVsAm26h6cyg/ZXZITSqXg/bjg8MHOQ5FFrIDXkzh5Xg+PSzH8OtDwxtBoLwZYQ
         Wq6w==
X-Forwarded-Encrypted: i=1; AJvYcCUFMJIZgKjhaJDsGT0zmr123+6tieBeennW3+Fuo5Zd7mU+4HNtvPjpXAeLlblKiLVP5jSUR+k=@lists.linux.dev
X-Gm-Message-State: AOJu0YygXLeIGL/aT4JrsVwNNMC4DCn2eirjRd16VSaeNgGEKoZ+Efbm
	a16p0odmkV7N4Dw1nsGQJEKuVWL+4tEPsRCkxPqO7VCIvVw9iHt6gTcfmcMkGMq6/fIAVvctthe
	Z0enHYizvVAuE89l8zvTdRo/gwzrNBZMxFup5VPEtuo8D0atwvLQ+eg==
X-Gm-Gg: ASbGncsYBC7osj4kIs7w9XVCpEU2dCrDpEZ2q+jwfOH8KX0zTCj0T7dKpv5Ghzdv1E1
	kSBfk0/8Ib5oNKl0nkE9FSakR+0zY1LyODvJ5MEWwQFl0uE4xrSQqHj0M057GlhenbZPa30/f5S
	Fw84vg0q7k6jCgEF4+QkS9GDK70ok6lh7S9AglG4ePBHcxxkRTwSd8WZP3Hp+OGb4JUGu7l5Rww
	Mr0QgCbtuM7k7DC78adJL2NOW8OoDC2hpHatU0WxwGf5reaNWqh2u/SW1410cV6ix5MyJPS2ZH7
	zO61XU7BTv9dP0Hdgv53LWpgkqnuCCQ/ZLvKgeiQ/bGo3cx0PYjFE3AOlIkmkk970bj5cSxAaGA
	X8A==
X-Received: by 2002:a5d:47a2:0:b0:391:3150:96fb with SMTP id ffacd0b85a97d-39132d6325bmr200930f8f.23.1741286415178;
        Thu, 06 Mar 2025 10:40:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG+PIlhHHUzNDRAUatrj6r8bLMc9x2BjUmkvzjVG8Z/wDAKyIEVDRSOx3ZM1Q7ROAl8MR6S/Q==
X-Received: by 2002:a5d:47a2:0:b0:391:3150:96fb with SMTP id ffacd0b85a97d-39132d6325bmr200910f8f.23.1741286414795;
        Thu, 06 Mar 2025 10:40:14 -0800 (PST)
Received: from rh.fritz.box (p200300f6af284000f9ca1328aeaacdd4.dip0.t-ipconnect.de. [2003:f6:af28:4000:f9ca:1328:aeaa:cdd4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912bfdfcdasm2767640f8f.23.2025.03.06.10.40.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Mar 2025 10:40:14 -0800 (PST)
From: Sebastian Ott <sebott@redhat.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: arm64: Writable TGRAN*_2
Date: Thu,  6 Mar 2025 19:40:13 +0100
Message-ID: <20250306184013.30008-1-sebott@redhat.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: VDtwo1H1fKu5H4Wx0K5nDcTXAHE6gk3CfZhKT6yToO0_1741286415
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Allow userspace to write the safe (NI) value for ID_AA64MMFR0_EL1.TGRAN*_2.
Disallow to change these fields for NV since kvm provides a sanitized view
for them based on the PAGE_SIZE.
Also add these bits to the set_id_regs selftest.

Signed-off-by: Sebastian Ott <sebott@redhat.com>
---
 arch/arm64/kvm/sys_regs.c                     | 21 +++++++++++++++----
 .../testing/selftests/kvm/arm64/set_id_regs.c |  3 +++
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 14faf213d483..0730ed8314d0 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1948,6 +1948,21 @@ static int set_id_aa64pfr1_el1(struct kvm_vcpu *vcpu,
 	return set_id_reg(vcpu, rd, user_val);
 }
 
+static int set_id_aa64mmfr0_el1(struct kvm_vcpu *vcpu,
+				const struct sys_reg_desc *rd, u64 user_val)
+{
+	u64 sanitized_val = kvm_read_sanitised_id_reg(vcpu, rd);
+	u64 tgran2_mask = ID_AA64MMFR0_EL1_TGRAN4_2_MASK |
+			  ID_AA64MMFR0_EL1_TGRAN16_2_MASK |
+			  ID_AA64MMFR0_EL1_TGRAN64_2_MASK;
+
+	if (vcpu_has_nv(vcpu) &&
+	    ((sanitized_val & tgran2_mask) != (user_val & tgran2_mask)))
+		return -EINVAL;
+
+	return set_id_reg(vcpu, rd, user_val);
+}
+
 static int set_id_aa64mmfr2_el1(struct kvm_vcpu *vcpu,
 				const struct sys_reg_desc *rd, u64 user_val)
 {
@@ -2787,10 +2802,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	ID_UNALLOCATED(6,7),
 
 	/* CRm=7 */
-	ID_WRITABLE(ID_AA64MMFR0_EL1, ~(ID_AA64MMFR0_EL1_RES0 |
-					ID_AA64MMFR0_EL1_TGRAN4_2 |
-					ID_AA64MMFR0_EL1_TGRAN64_2 |
-					ID_AA64MMFR0_EL1_TGRAN16_2 |
+	ID_FILTERED(ID_AA64MMFR0_EL1, id_aa64mmfr0_el1,
+				      ~(ID_AA64MMFR0_EL1_RES0 |
 					ID_AA64MMFR0_EL1_ASIDBITS)),
 	ID_WRITABLE(ID_AA64MMFR1_EL1, ~(ID_AA64MMFR1_EL1_RES0 |
 					ID_AA64MMFR1_EL1_HCX |
diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
index 1d65f4a09e6f..322b9d3b0125 100644
--- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
@@ -146,6 +146,9 @@ static const struct reg_ftr_bits ftr_id_aa64pfr1_el1[] = {
 static const struct reg_ftr_bits ftr_id_aa64mmfr0_el1[] = {
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64MMFR0_EL1, ECV, 0),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64MMFR0_EL1, EXS, 0),
+	REG_FTR_BITS(FTR_EXACT, ID_AA64MMFR0_EL1, TGRAN4_2, 1),
+	REG_FTR_BITS(FTR_EXACT, ID_AA64MMFR0_EL1, TGRAN64_2, 1),
+	REG_FTR_BITS(FTR_EXACT, ID_AA64MMFR0_EL1, TGRAN16_2, 1),
 	S_REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64MMFR0_EL1, TGRAN4, 0),
 	S_REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64MMFR0_EL1, TGRAN64, 0),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64MMFR0_EL1, TGRAN16, 0),
-- 
2.42.0


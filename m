Received: from mail-oo1-f73.google.com (mail-oo1-f73.google.com [209.85.161.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D416830BB80
	for <kvmarm@lists.linux.dev>; Tue,  9 Dec 2025 20:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765313569; cv=none; b=WQH41ffUSGQBiIKi9Ekp8R1DfwqVu4SsiuL3peNbEzVqLiYoVgoIs4cESYiMbEHeXO3rloyQW3o8Q+ULCKa8BQ+T+V8tFzGkA1Pk4IVwPm7ev/ES1hfkZYbChpMT22YAkclcD495xkfrn3ZjLXlyE1xV9F4MYvszKjOIg8hGOpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765313569; c=relaxed/simple;
	bh=gK8PYV0Ut8umvNmJJee7/9an5YvBL6+gILLBE0W0pjA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fyufg81M+hgeeKHB+/+LodscySM1BXvRD3HPl/tvkRSxRIdju617vbczvC28ZvO/3qCbBla68Z1Qjv7syWlIoLkPGMUd8UjDVBbxE4j1hIpg31582mUuujhgNa3eh9FhralmBwkhZLwIIsZVTeYprrHLFwcPcvEiC4oScQhsdQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DxmBNjpo; arc=none smtp.client-ip=209.85.161.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DxmBNjpo"
Received: by mail-oo1-f73.google.com with SMTP id 006d021491bc7-65979a343e5so7666997eaf.1
        for <kvmarm@lists.linux.dev>; Tue, 09 Dec 2025 12:52:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765313558; x=1765918358; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eILdFka/rsHJNMit/75Sq+eu11TjmQop/YtCpvpq3fA=;
        b=DxmBNjpoKAcIt3w0jmOMmWeD4iAT2lptGx6EYbpfNm/crqwqi9NXSkMONgCw+DhG12
         mPbxKXmJCuGshMpfbNSesUD/EKmTNnHBkakUwUfxTo4MDyb8i6epsbkCcHipreqgBoo7
         D5SRNPBABE/pQHGfagA6uaFVQzM9uYaQCRFMHqIVXq59sIfgm4cBKzBnT8YCUmpbYos3
         lWvPm6NhcTGknFSIVrfM4cXOs0aiqS3q0OA1gy/RQuxWt2LW66oUXthFtBubqTsQEEOq
         sOc++Ajkcn+2nXPSr9siuyd/6dd4Mxfn5kUkzop8RRjoyyxHVnNoQzSawpvBcDkbawqC
         qrZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765313558; x=1765918358;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eILdFka/rsHJNMit/75Sq+eu11TjmQop/YtCpvpq3fA=;
        b=cBGUG5IHArbnEf9xPbfc2ze+DQsJ97liz/yPIB1LUT9DwQSbHUvcrAot4LCYmBeJjm
         ylORMEzDzgKPgNvT4nk0mg8tFLz+yc+yer9S8PE1WOJNTV61K6WigzbrCmQJLohDKSkW
         tr1NN/nWOipoKf3mxsPfBxDpcSryKcvgQVmx6iRMIr4Rul8w7yG3+Cqe0c/Jvx5Yt9Yg
         aNVkjc808P3nndqZIoKBq7ojEKAHBo28+KXSaUSvD9pBkdAzqxWOa5xFXPN6K+ySrprG
         mrwFw2EN4kHlhXFMjg6ODrMv2CUdMepIdMzFFI2jT1E+FTZhtFU/xl8dt4VNVZvK9U39
         2MAA==
X-Forwarded-Encrypted: i=1; AJvYcCWvt8723JFECc2Uo7kFM09kjzPeva8h/eoX8FMkmo8755/lKG9N0jDeRJWe/X/Mfr5Z2Q9PX+Y=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywewynsst/Ax+Dv78+ZhNaKpUuzxUQrJS8IHefp2/SQLIEjTJUq
	ka5qf7C6mysym9OqZnHH5/VO0bD3qcpglF7imRT0Ihwf1rMNHRV3NCxaRAfKYRmsftODsb6MZQg
	vnN/6GvTLIWhtA7HGLrXzSDghEg==
X-Google-Smtp-Source: AGHT+IGFO7LxHdl3SUALrs39mwNrx9NW2pYEpCVi8R5YZ4pkCq168hpaasS4MHYzaxE05YVUGX0GL3A0G5bIBNL23w==
X-Received: from ilbcp5.prod.google.com ([2002:a05:6e02:3985:b0:433:e44:c729])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:4d08:b0:659:9a49:8f57 with SMTP id 006d021491bc7-65b2abec3e1mr136653eaf.28.1765313558233;
 Tue, 09 Dec 2025 12:52:38 -0800 (PST)
Date: Tue,  9 Dec 2025 20:51:09 +0000
In-Reply-To: <20251209205121.1871534-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251209205121.1871534-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251209205121.1871534-13-coltonlewis@google.com>
Subject: [PATCH v5 12/24] KVM: arm64: Use physical PMSELR for PMXEVTYPER if partitioned
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

Because PMXEVTYPER is trapped and PMSELR is not, it is not appropriate
to use the virtual PMSELR register when it could be outdated and lead
to an invalid write. Use the physical register when partitioned.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/include/asm/arm_pmuv3.h | 7 ++++++-
 arch/arm64/kvm/sys_regs.c          | 9 +++++++--
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/arm_pmuv3.h b/arch/arm64/include/asm/arm_pmuv3.h
index 27c4d6d47da31..60600f04b5902 100644
--- a/arch/arm64/include/asm/arm_pmuv3.h
+++ b/arch/arm64/include/asm/arm_pmuv3.h
@@ -70,11 +70,16 @@ static inline u64 read_pmcr(void)
 	return read_sysreg(pmcr_el0);
 }
 
-static inline void write_pmselr(u32 val)
+static inline void write_pmselr(u64 val)
 {
 	write_sysreg(val, pmselr_el0);
 }
 
+static inline u64 read_pmselr(void)
+{
+	return read_sysreg(pmselr_el0);
+}
+
 static inline void write_pmccntr(u64 val)
 {
 	write_sysreg(val, pmccntr_el0);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 0c9596325519b..2e6d907fa8af2 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1199,14 +1199,19 @@ static bool writethrough_pmevtyper(struct kvm_vcpu *vcpu, struct sys_reg_params
 static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			       const struct sys_reg_desc *r)
 {
-	u64 idx, reg;
+	u64 idx, reg, pmselr;
 
 	if (pmu_access_el0_disabled(vcpu))
 		return false;
 
 	if (r->CRn == 9 && r->CRm == 13 && r->Op2 == 1) {
 		/* PMXEVTYPER_EL0 */
-		idx = SYS_FIELD_GET(PMSELR_EL0, SEL, __vcpu_sys_reg(vcpu, PMSELR_EL0));
+		if (kvm_vcpu_pmu_is_partitioned(vcpu))
+			pmselr = read_pmselr();
+		else
+			pmselr = __vcpu_sys_reg(vcpu, PMSELR_EL0);
+
+		idx = SYS_FIELD_GET(PMSELR_EL0, SEL, pmselr);
 		reg = PMEVTYPER0_EL0 + idx;
 	} else if (r->CRn == 14 && (r->CRm & 12) == 12) {
 		idx = ((r->CRm & 3) << 3) | (r->Op2 & 7);
-- 
2.52.0.239.gd5f0c6e74e-goog


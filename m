Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1839A3BBE5
	for <kvmarm@lists.linux.dev>; Tue, 21 Jan 2025 04:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737434425; cv=none; b=Q58e8goxryGHgIYQpkcgvTtjTgil9SdjXmy+svGf2XX5Ij4FXmNLBLcpq3560Lpi+kobmY3/KCJQ3acdZ7ic8UzlRJMzyfle+0JBVlsri54xZTe2hJNZfb/+N5njwbcDDSW5PXzlXn+alG/obhQFZucdmT+e7yL++BrIMnn28Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737434425; c=relaxed/simple;
	bh=duHDPIpK5kU4H7/Yoa4QyItBCX1GS/+WUeuKKzr8CYc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=cYpcE3YI/FepbF/lxVyByo+sccZGow1vk6PQRfYQxyQCCZNJZLAzgsqzM0aKrZbSu+xGLcBuChPmEwFGueYL7Kuac/Gdd93Vkg3Ay9fs9HTFVgz5tpOSP00N+I14AqfY6kCXpBuv/Fq2hBQjV+UlRdjA/bccP1Ol/3K1OJAVkDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--lokeshvutla.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=01cbxQx6; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--lokeshvutla.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="01cbxQx6"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef35de8901so9585323a91.3
        for <kvmarm@lists.linux.dev>; Mon, 20 Jan 2025 20:40:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737434423; x=1738039223; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=W6HslTJVcoTc76NPV/AhEAAiVSfWCRn3Y3i6yxgDWLg=;
        b=01cbxQx6VJiZboT1fJgJOpfLo5+pGDUwY7wnlIPdKc14AC0MA57ni2s0xQrN4d7eOq
         czObrd8+DPH3q4Ai2zuCqeBFxItSEssOuPMXKZ6fAuRD0/tRR+JRzQjnIH6K/mh/sxkp
         0UHN7jaGeY0f5gdHxktBiZapkCUG8YORiXtc3zpGsiRBlOHTrAKxnj6u53bFIjK0J6mF
         Jvb+Or+k4Kqrc+7I1ktyIGM6Qnf8Pix5ZFVx2JI1opSlraML25Rp8SrArKKeIHgzwsFY
         BZgShi49sxrg0LHK/3qG9BZaYFBbjfMAV8GzP8Q2f4FVKP2xy1lNCMtaP/8gT+QuOKgT
         8HFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737434423; x=1738039223;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=W6HslTJVcoTc76NPV/AhEAAiVSfWCRn3Y3i6yxgDWLg=;
        b=Oirv0x9Y02PNOrfgi4m61PE0jaKcB8UtA/OetcZl+CIc8xl9XHYoUL8jaI9X/pKJsL
         LPBOgP8DfLOS6VQJbnN07NYWvnQdqeao9n0k+EePfxEXGuo7qqSjwIpeslauKluAFMee
         f7fu1klpGNY3JEMaPvqpUHdPwMv9STOMKFpm373kINwPBm16LFqkr49tN9CEYwDOj9L+
         OkKiUhEuKp6Asw+gQzLFo+2EyoBm3WdTdi6s5T+ffNT7Us2gyKrazCAKkdRtsymHxEof
         nNPcLA/1eLSURuo5PhIL/epiqmmuCzIIY5NMGILpSDR+zFC1mKqJSdLg/0rgEiMnkzmw
         Mv3w==
X-Forwarded-Encrypted: i=1; AJvYcCXyfwXtJafzgnQLPTraTXYXGH7pt/SutHqIp0jwJDRzEEu+x82mJlZrraJBN2D4rhq2AiRfBNA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxpapgbi+pIBMhSWk5x0uN6jTiWGqb0XGKQEJgjT/OX7pimst/s
	mat8OYI5iOhHzWekvuspqaOuN7xg8iLOSSWv3olHItFW/QvduKPOfFFeVAksBU4VsxuHO6xgfQH
	Bn2JbmaQzIuyC2Sdl+/Ws9g==
X-Google-Smtp-Source: AGHT+IF4p997QdwvM0SsDbErEoy+U/aICq4fFswhgZuSPgNMtUKRK4y7HpGvS1wx8IpyVVRWtWkg/psQwIA3R5wW3Q==
X-Received: from pjoz4.prod.google.com ([2002:a17:90a:9804:b0:2ea:3a1b:f493])
 (user=lokeshvutla job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2e06:b0:2ee:d824:b594 with SMTP id 98e67ed59e1d1-2f782d8ccdemr21933409a91.31.1737434423306;
 Mon, 20 Jan 2025 20:40:23 -0800 (PST)
Date: Tue, 21 Jan 2025 04:40:16 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.0.rc2.279.g1de40edade-goog
Message-ID: <20250121044016.2219256-1-lokeshvutla@google.com>
Subject: [PATCH v2] KVM: arm64: Flush hyp bss section after initialization of
 variables in bss
From: Lokesh Vutla <lokeshvutla@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	lokeshvutla@google.com, sachinparekh@google.com
Content-Type: text/plain; charset="UTF-8"

To determine CPU features during initialization, the nVHE hypervisor
utilizes sanitized values of the host's CPU features registers. These
values, stored in u64 idaa64*_el1_sys_val variables are updated by the
kvm_hyp_init_symbols() function at EL1. To ensure EL2 visibility with
the MMU off, the data cache needs to be flushed after these updates.
However, individually flushing each variable using
kvm_flush_dcache_to_poc() is inefficient.

These cpu feature variables would be part of the bss section of
the hypervisor. Hence, flush the entire bss section of hypervisor
once the initialization is complete.

Fixes: 6c30bfb18d0b ("KVM: arm64: Add handlers for protected VM System Registers")
Suggested-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Lokesh Vutla <lokeshvutla@google.com>
---
v1: https://lore.kernel.org/kvmarm/20250120151514.1769597-1-lokeshvutla@google.com/
- Applies on top of Linux 6.13 tag.
Changes since v1:
* Updated Commit message based on review
* Updated kvm_flush_dcache_to_poc() to call from kvm_hyp_init_symbols()

 arch/arm64/kvm/arm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a102c3aebdbc..caacb2da8e09 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2410,6 +2410,13 @@ static void kvm_hyp_init_symbols(void)
 	kvm_nvhe_sym(id_aa64smfr0_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64SMFR0_EL1);
 	kvm_nvhe_sym(__icache_flags) = __icache_flags;
 	kvm_nvhe_sym(kvm_arm_vmid_bits) = kvm_arm_vmid_bits;
+
+	/*
+	 * Flush entire BSS since part of its data containing init symbols is read
+	 * while the MMU is off.
+	 */
+	kvm_flush_dcache_to_poc(kvm_ksym_ref(__hyp_bss_start),
+				kvm_ksym_ref(__hyp_bss_end) - kvm_ksym_ref(__hyp_bss_start));
 }
 
 static int __init kvm_hyp_init_protection(u32 hyp_va_bits)
-- 
2.48.0.rc2.279.g1de40edade-goog


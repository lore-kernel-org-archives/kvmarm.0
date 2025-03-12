Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A6F241678
	for <kvmarm@lists.linux.dev>; Wed, 12 Mar 2025 11:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741780590; cv=none; b=fGiHbEiV5pwIeGL8X/dpkUOdcG1U9UeXFqGj5GK3zpxuR8RwnSjc2rrwm2Qpe+YVVlKWD/gLddnm8TseUF17ExKhHEZA8BGfUwXvV8Xc4wnCiWZPGt/jPrjvfnJJCOMHgSvdjAKdwmoMBKEFaEb1JghuOho6AmC9xjlVUJEjBjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741780590; c=relaxed/simple;
	bh=4v1s/durCkfELOZpL2W2ey0P23M5dti6CGsoLaBi280=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=hqQlwJSjQ3ipCU66Ijk4B/4WCAycX3+a80pPQXP+qZUJjIB/k1M24/bFX6oy525My557+qIrAqEbho1GxcJOE+cl2YaCig7tKoUZGjLPEvU1y4jNbeNXQKOOSUzHKpIbog7RDKwGPn5GwjIbciXUagG4AjVh/fpywVEYFW974Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=mnRgkktz; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="mnRgkktz"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-223a7065ff8so33838555ad.0
        for <kvmarm@lists.linux.dev>; Wed, 12 Mar 2025 04:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1741780588; x=1742385388; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=batJW7N99udsH5or2fGgRKZ12NqGfXHTrvw8DYDS8OY=;
        b=mnRgkktzWgLvgVddBJhWNVOlngRQ3a9bPsvgWD5J2NTQ7Q/56j1UdGbBzYpBCP95ry
         JLwAWD8ns97DlHBGgcUP2rF9mXf9Bciydp/HE3zmqJ0gO70hZh0lf7bncVrGcFXmjq81
         HPp5EkXGtN2ABIp+hlOZfFresV/u1G5Xzsl/zcDjb+tfkZvP2urlrBfvqsj002IbiiC1
         KH2EOT420nv/4ni26jU33bzT6PDj4ht+sPE0h82A8c0ibO6HQthD+wte93D+gVgVlee1
         ozf0wMacjZS/66v7hBmdFZ8nnP3pfrAf4s0S/vgq6HbSIsRO4pKEto/Lw6s09da1RTex
         7Xmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741780588; x=1742385388;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=batJW7N99udsH5or2fGgRKZ12NqGfXHTrvw8DYDS8OY=;
        b=HZ/SOSMIOzL/MySSFb5s6673xzjkxMIDTGDaVtwayQcjWA3zcI4V558qRDezUC34X+
         Uii/I3CvTuos/XV6yRvQJz/VV2bWB6Z/eENeBNKvNuuo/Cwgis9isBxMlsKrw4MEacIy
         JaaFDT93NhVgtgAnwGzyCIk26aUlw8faReS5QsGk7qomGgMyEPR8OGHVRou+tDkR+Ubg
         GfLKdZ7gewk23O53sB2cFj3VbWoACiV8Sl7ayEK4HdHSx6jXYX2Wvbc8EGefWsGvAVn4
         NDOvMMGDXWh8B7VF/akNaKBSyDLuIr4zHdcs9O6U1I3xCrXhqC2YsGjofZJzmZVI0zoO
         w1qQ==
X-Forwarded-Encrypted: i=1; AJvYcCV6L/aON80RVV8N/QQYIUkQ/xzk+vo2Fp+cM1FYpg+HIiKmlUsF+jhMb6F20Lx/ySu+eIKmMDk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw6y/f3AUnDEckljhtRvlzqh2Ng//+1qPbLlIXnph+x9QQiDidq
	BiPUgebXjVhf4toTC2ZflsHPHf0CdPPJC2MESOGvq9g0faG/wIq1LiSmmU6GRIc=
X-Gm-Gg: ASbGncvuKQxyCsnvyVzu3Kld1FjFb4hnMBZ+Q71Fj8fcT0F9/v7zf4IyLAE5PFiy3Ei
	eyENT0ANiGeR9mEq/FfshOOq3q7TxNOnpeX4QvubEvUpEqMFJVJZQLr4VSnD5MlTkPH+qwdZ11U
	ulpJgqJKndPstvRyuYGwfAxqPZRO+F3P+cM1mQBJCt1c4ou4u/UgMAxPWRkz+phBAeQCQGHuvXh
	2FB7AeJ/KE2xonUtlEYyN2cPD7XCTtA6cePXPwE9EFLOoOEGG7cC40Qd+YrICL8y+7XVPBOsChG
	I/DhIjf3DoVz910e6ikWby5l8Q8zJsWdz8LskjRPFyP1jFf/
X-Google-Smtp-Source: AGHT+IFrXL/c2aUmiggWa0jbXOlzV9E33S5G3t7pznZh6+1oFT+Cw3t/yJk10DJ41f3H26UTFexAtg==
X-Received: by 2002:a17:903:40cb:b0:21f:85ee:f2df with SMTP id d9443c01a7336-2242888adfemr319563085ad.15.1741780588669;
        Wed, 12 Mar 2025 04:56:28 -0700 (PDT)
Received: from localhost ([157.82.205.237])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-22410aa457csm114113705ad.212.2025.03.12.04.56.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Mar 2025 04:56:28 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Wed, 12 Mar 2025 20:55:58 +0900
Subject: [PATCH v3 4/6] KVM: arm64: PMU: Reload when user modifies
 registers
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250312-pmc-v3-4-0411cab5dc3d@daynix.com>
References: <20250312-pmc-v3-0-0411cab5dc3d@daynix.com>
In-Reply-To: <20250312-pmc-v3-0-0411cab5dc3d@daynix.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Andrew Jones <drjones@redhat.com>, Shannon Zhao <shannon.zhao@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, devel@daynix.com, 
 Akihiko Odaki <akihiko.odaki@daynix.com>
X-Mailer: b4 0.15-dev-edae6

Commit d0c94c49792c ("KVM: arm64: Restore PMU configuration on first
run") added the code to reload the PMU configuration on first run.

It is also important to keep the correct state even if system registers
are modified after first run, specifically when debugging Windows on
QEMU with GDB; QEMU tries to write back all visible registers when
resuming the VM execution with GDB, corrupting the PMU state. Windows
always uses the PMU so this can cause adverse effects on that particular
OS.

The usual register writes are already handled independently, but
register writes from userspace and ones for reset are not covered.
Trigger the code to reload the PMU configuration in these code paths
instead so that PMU configuration changes made by users will be applied
also after the first run.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 arch/arm64/kvm/pmu-emul.c | 3 ---
 arch/arm64/kvm/sys_regs.c | 6 ++++++
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 1cfe53b6353e..78cfa8b0964d 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -862,9 +862,6 @@ int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu)
 		   return -EINVAL;
 	}
 
-	/* One-off reload of the PMU on first run */
-	kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
-
 	return 0;
 }
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 26182cae4ac7..307ce37d0434 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1143,6 +1143,7 @@ static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 static int set_pmreg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r, u64 val)
 {
 	__vcpu_sys_reg(vcpu, r->reg) = val & kvm_pmu_valid_counter_mask(vcpu);
+	kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
 	return 0;
 }
 
@@ -1303,6 +1304,8 @@ static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 		val |= ARMV8_PMU_PMCR_LC;
 
 	__vcpu_sys_reg(vcpu, r->reg) = val;
+	kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
+
 	return 0;
 }
 
@@ -4259,6 +4262,9 @@ void kvm_reset_sys_regs(struct kvm_vcpu *vcpu)
 	}
 
 	set_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &kvm->arch.flags);
+
+	if (kvm_vcpu_has_pmu(vcpu))
+		kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
 }
 
 /**

-- 
2.48.1


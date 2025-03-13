Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244621FC7C6
	for <kvmarm@lists.linux.dev>; Thu, 13 Mar 2025 06:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741849096; cv=none; b=QF7C1BB4sNgQP0Ua6oiFDZQduK6IiGHOkEhpp6ZRYI5+q/odKZksYV+kPmYqGHzFXOP8AtobMJGNZ/OVDxtByG1zg0QtJWNqCMJrFWfkT3peLG9xKFK9KZaCM1qcz0Qtm9JK1bHZbBJI8Fm1qD3QTe/OylKXt698/PXQrIQRJVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741849096; c=relaxed/simple;
	bh=F3X6D6K8/IleFxaVTYcfc5YrfdKG3utxmjKEiJ5rrmY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=VqsPjEeKv/yux71O0v28FD0qR2I32GEEEVk9vXVnJBtV1CS/WDfdAz+MAUQ3BPrVd9OYJwbZsm8RXLiD9ISKPXt0Ml9pl2TmQruCGtV+m0/xafxSQcoEUur7NfRcKeJWPyjsvWJgfnsBM7Pn7I3SWsE4wm4L4gvtkYN+2ImHUyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=3KtJv9K6; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="3KtJv9K6"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-223a7065ff8so16536085ad.0
        for <kvmarm@lists.linux.dev>; Wed, 12 Mar 2025 23:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1741849094; x=1742453894; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ov1QC08xmBeOUCrm+sZTVT7zWaIK1Z9CIL8k0jXnjDA=;
        b=3KtJv9K6PGVYtoqoOauWcT2/GOiLuse8yWIqIxypOKDNYoAx7s1RmhnBO7ECGiPI88
         piZ4ui44jFWkXWBFPJKBQx8UcBsJrLbZnzvPlmO2fjnOn0PNeJX0fxgi/K68XnnFI7IZ
         PkBweRXYaldwdLIarQ6nRbIPXRdIbIYHepSRGBM9aQ/bBTDJTUbDxGE+3VzWPdpgFzow
         1972+3yE/VVwF7q+3oCeDPNAnp1LtRJ/n+ihJUdHQ0mh1pinaLdBZ9o2i+BbCLdxyAZJ
         l43Cw5sUMF57GZgD5rVgchRjxH5Gi20W3CKoFJcUC1WRiISEC1PijhshE4xyYsocJVHc
         S77w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741849094; x=1742453894;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ov1QC08xmBeOUCrm+sZTVT7zWaIK1Z9CIL8k0jXnjDA=;
        b=GE7CSv2TztUByNXCRBAh0ioPVAeihS9mGnZcuAObV+7yItPcL2Y7EOidT+TzSbeOhB
         jEatzKYnEfWA0R4SEXc8mTNmrS329ThqXF92jyaZZHYX9qeKWcasf/tcSUEnaMQLV/I3
         ltwu+EDRJTqjs3288qndcDZ1EdBEEN2+SU3ZJLwV1FAccaOFOqgn9nrHDXln+n5ApxRY
         N4HqgqYXZuaGsO7fmiXVmjWE0+dOIUDHBvPKBk0N3JZk5//ScVQAU3feoX8yEc4ctl0A
         qThNPR53ZqBTlL7RLAlzqg3X6pwlnDuytJVsiu2deeJdYQ1YEDiiWPCuRcLOsoj5w+m+
         qc0A==
X-Forwarded-Encrypted: i=1; AJvYcCWJGnvpMhcY6rxN1Dr1yJpu4I+dN2oH+wMta1Xvt+IJOLD35BafwhtqEb5IlR+K2cz3vC6IYEg=@lists.linux.dev
X-Gm-Message-State: AOJu0YyD1QgnYsF9vQkUWpVCK8hhNM6n6jb8HthcqFQk/nXlHCa9uqV3
	Rx9lMWhbjusPZiCqWyJkkQXLlZ98n5me9gXSpSRqTqRF1r8fdLEWpuowZgEjnSA=
X-Gm-Gg: ASbGncuJoD6pNQIk1Mq9oILEpClLwIuq8MxbBqd1b48OaneCrg/JXROzp/2nLcAIalX
	5OswdLPDMx596bdoCZ0H2nkt09rBNNBvkmuIUc1u676cAGDvaDAAeZ22PbvbHOiyOEYMnqOPl09
	twXHxxqPeVop3hWG7A8lOuHrDg3sLvPnQO2ZV4wODS44/6H4HNsh0jxaEAUi7vziFvBVOAnt0ui
	A3SUa0O68GpByNKaYvAHqq9lZvNTnhbMXy0fOwpb2A0TgWeZFif+oW6nsO+lPO5b7cbd7fcUdha
	ffJdc7uyY9x0vAT09FQeBlF6HBzqXJUn/1rr9LDzUaiWCpbM
X-Google-Smtp-Source: AGHT+IFPWy7B2BUY2WAUGm0CDCmAcyU/PA9aOMoalJWaDBeBLNlBGUj9py5eigGDQ0JyyV1QjpJmAw==
X-Received: by 2002:aa7:88c6:0:b0:736:34a2:8a18 with SMTP id d2e1a72fcca58-736aaadf9c1mr39387147b3a.24.1741849094416;
        Wed, 12 Mar 2025 23:58:14 -0700 (PDT)
Received: from localhost ([157.82.205.237])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-7371167df97sm627290b3a.114.2025.03.12.23.58.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Mar 2025 23:58:14 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Thu, 13 Mar 2025 15:57:45 +0900
Subject: [PATCH v4 4/7] KVM: arm64: PMU: Reload when user modifies
 registers
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250313-pmc-v4-4-2c976827118c@daynix.com>
References: <20250313-pmc-v4-0-2c976827118c@daynix.com>
In-Reply-To: <20250313-pmc-v4-0-2c976827118c@daynix.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Andrew Jones <andrew.jones@linux.dev>
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

The usual register writes and reset are already handled independently,
but register writes from userspace are not covered.
Trigger the code to reload the PMU configuration for them instead so
that PMU configuration changes made by users will be applied also after
the first run.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 arch/arm64/kvm/pmu-emul.c | 3 ---
 arch/arm64/kvm/sys_regs.c | 3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 1b91e5188d52..3ed8b74d9925 100644
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
index 26182cae4ac7..11718c635e2f 100644
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
 

-- 
2.48.1


Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0952B1F76B5
	for <kvmarm@lists.linux.dev>; Sat, 15 Mar 2025 09:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742029982; cv=none; b=erMMgQqc1w0xQY62S7lb/ZjhdWVVQRrVhGX8HbJ+qN5NJ2tA+mAjpSY3PCQSwSsKuZLvW29dhDVa7ZCEOhTllrG7P2i/5AAzs/sMYFxIluyWqdhoLecPJxQPyBOiXsEyl2Ehj55vLY811uXuuAVrjq93pPQAiLlSIw2dHC4qQlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742029982; c=relaxed/simple;
	bh=UIs9U4gwmL5870YLJcYNAyG53WiYxibycuWPw35RO2U=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=j/QfOMxqHnor6xyE6MiWnEMCuk2H5CLfztbqbF19oS6Nqjie1K9C10N14GHVvEtGKrkau6oZZlZCMxXdBUtWQtNm/ZchMVG9KUWrSYAASTmYtz2C9qi3vZdOCtbYNIS9QsSlNWYq+DV7r3HLOwqgLAs10zNIpzIWifJ/S030h5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=B//K5tWn; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="B//K5tWn"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-301493f45aeso829628a91.1
        for <kvmarm@lists.linux.dev>; Sat, 15 Mar 2025 02:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1742029980; x=1742634780; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/FbB5lDaUNvpC7XuDXTEGvGqSXp+ZEz8J1AwcsET8uY=;
        b=B//K5tWnu9j/sV5T2q5nm0UwR2qz+TyyqVru2Ww5Ai/i0CjVsS0qg72Iusy47tUHCV
         TC1gcoQG2fgK9AS9hNRyf16zBuijkyGxDBA5UUVj1vjgRrfYyS0Ji9w1pHXMj4YM5Hjc
         y1k5zmezpgk/liOgtg0fwksgFCMUGYKmFVp/KcxN/WAKZ1c/0RR2TvczvNgl7xgaktbC
         YlwY2PBSfThtnZKkngxhf/yVACEH8fQqr7lhl99H9NRqkJWIwLtbqlJoZJ5nUsc2BTdi
         sl4pUi35Un3Eq+8aB4CVBAcSIbQdW7g1iqJJVc+Y1Zd7eVPZelIpu1qwBqDAHuGfISNF
         vHRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742029980; x=1742634780;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/FbB5lDaUNvpC7XuDXTEGvGqSXp+ZEz8J1AwcsET8uY=;
        b=QwwFZQeyK5fiwocPmvHRFXGi6WvdMsl+5ywh2XOemUOFlICB7J453Z3ssgvyFw4aoe
         /43447D7+CiqRfV3Et0ld5N+BKP/undDql7FMS6zcUMrDGWVCErKtY6NqPDh3+A4iAXL
         APnDfE1P9oHJ/nEi7wxduAS941HePDoJ2N9ymbkaiwEAxtocEFZLfRE1JSpXqzaRWWA2
         RIf96YJsr3RAzqRuiXGNyocldwWalmHgOSKMPWg8DjQblcjJoFxARm+BCLlSwEyB3yic
         lImcjkFsk2YM1qydRQN/NnS1NV5pBmB0IOsylL3b+Zle5Lz2gCESaD3/RF0WUkNMNjUb
         aFZA==
X-Forwarded-Encrypted: i=1; AJvYcCUa8uLe112U/88+m5F2zsIAkYdq89MZrnPaZTbBVBVCEdMlV1/i0WV3Ti9yogAZ8RJwkgRrfD0=@lists.linux.dev
X-Gm-Message-State: AOJu0YwfoDBpcv4mx5UH+27vNcLCa8Pi5swSV+OnClowIQJjDbue6o5B
	1Me3TO++hel9AdxZxDfc2dFWSlFYkx6sxfZJfoNnH63FEPZ3Ztrdktd8+LzipbE=
X-Gm-Gg: ASbGncvCkRVpwAWTYQOyTuHtEtBbPTCJsXH9IRArD2Sudkace7tLeZoRJsZoVhg7soE
	Ar4P/SDL1prA5BlmkPrdV4eNCOiR1N0YkMqmiCwX5NmJoffZ97ZMqdFhW9cIQ+adk+7AvhTEfzH
	jSQqwOXF/uxMo34Dkfk/fknzKlLKObfgtGgB0oxQphpYKf+K4u5rRcOT+TY/DyK4tnmviHuqVGp
	2L5oUL/haIMXmOU5difnjhpJG9s6o04rRCwIlQ/OJ3M/Qb0V19NvgkY3o/ZMmXkLCFSmbddvi5T
	aPhScfXn9Wiz78zm3s1mGosbopBkcEYtkMEgAe5D5lSgYHo1eT3UhEN2Z5c=
X-Google-Smtp-Source: AGHT+IHaYE3C8lcppzvNgVq++/gQW7jqz6vA6hT6Z68AyNtCpi+E5uRU4W2Fjw9r55KOhScD/9aGrg==
X-Received: by 2002:a17:90b:4b83:b0:2ff:6f88:b04a with SMTP id 98e67ed59e1d1-30151ca6de6mr7547868a91.15.1742029980303;
        Sat, 15 Mar 2025 02:13:00 -0700 (PDT)
Received: from localhost ([157.82.205.237])
        by smtp.gmail.com with UTF8SMTPSA id 98e67ed59e1d1-3015364ec2bsm2630846a91.46.2025.03.15.02.12.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Mar 2025 02:12:59 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Sat, 15 Mar 2025 18:12:13 +0900
Subject: [PATCH v5 4/5] KVM: arm64: PMU: Reload when user modifies
 registers
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250315-pmc-v5-4-ecee87dab216@daynix.com>
References: <20250315-pmc-v5-0-ecee87dab216@daynix.com>
In-Reply-To: <20250315-pmc-v5-0-ecee87dab216@daynix.com>
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
 arch/arm64/kvm/sys_regs.c | 4 ++++
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 593216bc14f0..8e10124a7420 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -917,9 +917,6 @@ int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu)
 		   return -EINVAL;
 	}
 
-	/* One-off reload of the PMU on first run */
-	kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
-
 	return 0;
 }
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 4d1ef47d0049..727579acc7f6 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1070,6 +1070,8 @@ static int set_pmreg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r, u64 va
 	u64 mask = kvm_pmu_accessible_counter_mask(vcpu);
 
 	__vcpu_sys_reg(vcpu, r->reg) = val & mask;
+	kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
+
 	return 0;
 }
 
@@ -1228,6 +1230,8 @@ static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 		val |= ARMV8_PMU_PMCR_LC;
 
 	__vcpu_sys_reg(vcpu, r->reg) = val;
+	kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
+
 	return 0;
 }
 

-- 
2.48.1


Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC292AD22
	for <kvmarm@lists.linux.dev>; Thu, 13 Mar 2025 06:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741849079; cv=none; b=nTeFNuxZuRhWIeDuS5odIp+s5iMnq2OGmA1tUNHTTkx9FAJ3iypnnGtpPqfTsqOnwU0FlfaQIxKTIAazCv6ljB4QFBoId5JWcV2nOiLGmoSoY+0MxdbePV0hzAoqF6pr/2ebo2KHmobHOKdNSy9ZR7ZW+PKbOrjZWpZx6eOxEBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741849079; c=relaxed/simple;
	bh=i+aS6230F9Pf7oru2l/exa62ii5VwUSG1UgYivlTBkM=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=dIjsoVSnDZHzMGoAIyxEkVNpsTKSotA6yoGbiKq/1MW52Je9QevftJVE25xiiJxQqO3TW9VwHz2iyP1ra0IVVXNGBtZ8F2NwTVsd6vImdYTPRBLIp8OM9p0wbLA7NIPB5uM20ngUTkQvnY5sYxnf/08uyeZDBeY4Ems6ynSORCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=aoc/0t56; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="aoc/0t56"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-223594b3c6dso10848445ad.2
        for <kvmarm@lists.linux.dev>; Wed, 12 Mar 2025 23:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1741849077; x=1742453877; darn=lists.linux.dev;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DzZ/OwKmmQbXUKB6Ig9nkspgT/x2zvQUcWtNQDAlXJ8=;
        b=aoc/0t56jHU9qx0zPqrPjDCCpYAI8eXK5hhqqYgibosAhRbsBLMAS6s+I0ElCeb4VW
         62lRUzFYj/LIzQ9l1wFxNUt9e903qpkBM+MxFdbEYeosdKTsKk9+VlyAFr7wzL5Z8hXx
         y1z5IkcmIIX8mw2csoT4l3faKtB/LVd5grer8dmHx7/lxE08cPb9LrLq3xkVcDUD4fX0
         FSJSOjFPer/Zxf/Y8rpXZ4nNn22QTPx+EaonYFOerzn19SQjvRf4iAt+vfp9/dFZnMvy
         d8LnLrn+Tbc0ReMcZQFX0WKEgCv1UghHdbKYmRZoLrW0gfPh1O1IdRTSdlAhYWywJUFY
         koAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741849077; x=1742453877;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DzZ/OwKmmQbXUKB6Ig9nkspgT/x2zvQUcWtNQDAlXJ8=;
        b=jMVlmJEphMvzyNSQgWuiGVEM8BxmtBkr8IE7KKz1HNC2EUu1eRx6rQSdhk7yJqBB5/
         22I8zl9/JI0pHjBc9wuoDIBgQAVSG6Cae0QfPSyh/HdvobtV6C54KI48feQptBsuJhe1
         HOlk4/RLAG6HcABTl6GdHz3GKVthuQcKa3nqma1+hD1vqD2tY27k5RC+BETCDzxxaB5a
         c3MrUViOmGp1avw24WZF8f4G8QltJFvFh1bSSIeV2kRvjFCdIhSywuC0PK5AGQLzMnI9
         pwbWpgFl59lZpcL3IrD+uMC3K/nXNZZhabUOtnnHTfZ1QASPPbU1j6sKDFablBv4CG5j
         SCjw==
X-Forwarded-Encrypted: i=1; AJvYcCVkj7tjl9SseI6vnWKKhSIUtjHOsLfnfZEF4NnKfMW7MdvUapAqnQOhJK6Emabr11oXXZkXXtM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzndl+ZNCm8QJoUBlcqYB8QZBmQSyW6o+IB8NG6xeFvj+wYz/5d
	6IXZg+EiQ6VXf6rtWD/0agOx9wPBC762K4JIs4Gf+vWCkmTDQYvy+B0T7463Dd8=
X-Gm-Gg: ASbGncurNP3gDEKGEkOaOupoSt70JEyvN9d7VECRBRbG9ucnqf0rWOCAa119/lPL1zn
	hf+5KndxPXqha79aNZdAswSuuKmflm/BotXvIF0fthi3ExZAUU9TZCoaIvnY+XVpnJHmIBF3i+8
	FPmHh8igg3oAUMGFvqdqxe+ocxa4bywX2anzFBSwNa2iiw+bwiCo0EkgnuKdYMx/JSk/PBv8y3c
	9My2oD8I2BoEdyzgGFdRSd7CDGir9Vk/eHUF7M3bvyRxoDqEghOd5zK7Jl7ZX8+lt/FKiQLfTTi
	enwtUTh1DbcvPGa0A+FPLyuTEBuysnopEac96Clmxy7+8W/2
X-Google-Smtp-Source: AGHT+IFJys5eR6oUmPsgD0nQ7bgGFWSfRnMTkiQzEi9pZgL77FdSzGwIkj2Od2Zq73fxdD3yVQX53g==
X-Received: by 2002:a05:6a00:c95:b0:725:96f2:9e63 with SMTP id d2e1a72fcca58-736aab16545mr42898380b3a.24.1741849076765;
        Wed, 12 Mar 2025 23:57:56 -0700 (PDT)
Received: from localhost ([157.82.205.237])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-73711694b2csm624169b3a.129.2025.03.12.23.57.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Mar 2025 23:57:56 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: [PATCH v4 0/7] KVM: arm64: PMU: Fix SET_ONE_REG for vPMC regs
Date: Thu, 13 Mar 2025 15:57:41 +0900
Message-Id: <20250313-pmc-v4-0-2c976827118c@daynix.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAOWB0mcC/2XNyw6DIBAF0F8xrEvDU6Wr/kfTBQ5QWfgINERj/
 Pei7ULT5b2Zc2dB0QZvI7oVCwo2+eiHPgdxKRC0un9Z7E3OiBEmCScMjx3gRhFdl9opIQHlyzF
 Y56d95fHMufXxPYR5H010a88+UUwxaOdUrYjiBu5Gz72frjB0aBtI7IiqL2KY4BI4r6SWjlrxh
 /gB0d8nnhERlIJupAFuTmhd1w9opBY6AQEAAA==
X-Change-ID: 20250302-pmc-b90a86af945c
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Andrew Jones <andrew.jones@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, devel@daynix.com, 
 Akihiko Odaki <akihiko.odaki@daynix.com>, stable@vger.kernel.org
X-Mailer: b4 0.15-dev-edae6

Prepare vPMC registers for user-initiated changes after first run. This
is important specifically for debugging Windows on QEMU with GDB; QEMU
tries to write back all visible registers when resuming the VM execution
with GDB, corrupting the PMU state. Windows always uses the PMU so this
can cause adverse effects on that particular OS.

This series also contains patch "KVM: arm64: PMU: Set raw values from
user to PM{C,I}NTEN{SET,CLR}, PMOVS{SET,CLR}", which reverts semantic
changes made for the mentioned registers in the past. It is necessary
to migrate the PMU state properly on Firecracker, QEMU, and crosvm.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
Changes in v4:
- Reverted changes for functions implementing ioctls in patch
  "KVM: arm64: PMU: Assume PMU presence in pmu-emul.c".
- Removed kvm_pmu_vcpu_reset().
- Reordered function calls in kvm_vcpu_reload_pmu() for better style.
- Link to v3: https://lore.kernel.org/r/20250312-pmc-v3-0-0411cab5dc3d@daynix.com

Changes in v3:
- Added patch "KVM: arm64: PMU: Assume PMU presence in pmu-emul.c".
- Added an explanation of this path series' motivation to each patch.
- Explained why userspace register writes and register reset should be
  covered in patch "KVM: arm64: PMU: Reload when user modifies
  registers".
- Marked patch "KVM: arm64: PMU: Set raw values from user to
  PM{C,I}NTEN{SET,CLR}, PMOVS{SET,CLR}" for stable.
- Reoreded so that patch "KVM: arm64: PMU: Set raw values from user to
  PM{C,I}NTEN{SET,CLR}, PMOVS{SET,CLR}" would come first.
- Added patch "KVM: arm64: PMU: Call kvm_pmu_handle_pmcr() after masking
  PMCNTENSET_EL0".
- Added patch "KVM: arm64: Reload PMCNTENSET_EL0".
- Link to v2: https://lore.kernel.org/r/20250307-pmc-v2-0-6c3375a5f1e4@daynix.com

Changes in v2:
- Changed to utilize KVM_REQ_RELOAD_PMU as suggested by Oliver Upton.
- Added patch "KVM: arm64: PMU: Reload when user modifies registers"
  to cover more registers.
- Added patch "KVM: arm64: PMU: Set raw values from user to
  PM{C,I}NTEN{SET,CLR}, PMOVS{SET,CLR}".
- Link to v1: https://lore.kernel.org/r/20250302-pmc-v1-1-caff989093dc@daynix.com

---
Akihiko Odaki (7):
      KVM: arm64: PMU: Set raw values from user to PM{C,I}NTEN{SET,CLR}, PMOVS{SET,CLR}
      KVM: arm64: PMU: Assume PMU presence in pmu-emul.c
      KVM: arm64: PMU: Fix SET_ONE_REG for vPMC regs
      KVM: arm64: PMU: Reload when user modifies registers
      KVM: arm64: PMU: Call kvm_pmu_handle_pmcr() after masking PMCNTENSET_EL0
      KVM: arm64: PMU: Reload PMCNTENSET_EL0
      KVM: arm64: PMU: Reload when resetting

 arch/arm64/kvm/arm.c      |  8 ++++---
 arch/arm64/kvm/pmu-emul.c | 60 ++++++++++++++---------------------------------
 arch/arm64/kvm/reset.c    |  3 ---
 arch/arm64/kvm/sys_regs.c | 53 +++++++++++++++++++++++------------------
 include/kvm/arm_pmu.h     |  3 +--
 5 files changed, 53 insertions(+), 74 deletions(-)
---
base-commit: da2f480cb24d39d480b1e235eda0dd2d01f8765b
change-id: 20250302-pmc-b90a86af945c

Best regards,
-- 
Akihiko Odaki <akihiko.odaki@daynix.com>


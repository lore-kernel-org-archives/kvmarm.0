Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 597A923F390
	for <kvmarm@lists.linux.dev>; Wed, 12 Mar 2025 11:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741780572; cv=none; b=nZdnm66O38M4WCHDG2Xd4kpo6/ordhMY9zIYqZFssXqVH/TTU8wdiG+qd/UBpbuMCArslgNWiWXu1LDHf+zsggoOOy8Y/apx40nocouossHiu2SOvmXJFSC5V7A00UUvH4vYrOcHb59Kpb3COcEhUxBt0hKI4ra+g7rrbTeW1Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741780572; c=relaxed/simple;
	bh=cmBlq/kzr7m17+5OwAx9iOS7U0NNp08z+8zJN/RNvc0=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=ryPmRei/RzbiJLmkf9+ogMNcaS7LsK6mGoIwREcg+soGEyMa7Qu14vuJbMmnp0/+I4UAHEH8rkLXskK/J2RQJkCPHWYBSn3GR8GWeX/EdnGT+eLTaTudjwJ/ak63SXpt9ZKc4Aapq6C+7ljm8qaSLls9sBzk+ZV/M1TBHf1OFJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=Mad5nsOO; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="Mad5nsOO"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-223a7065ff8so33832355ad.0
        for <kvmarm@lists.linux.dev>; Wed, 12 Mar 2025 04:56:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1741780569; x=1742385369; darn=lists.linux.dev;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=R9IlyLC7A5fKrEe72gCHfs3e2o6+wpvRXjQlPG7kMic=;
        b=Mad5nsOOjkCVbtPkMe2Vh8ZftlmjjRpxciyR1dc5IT6Y4ba9UYKZGqV+rvA17M44+z
         zrvGy16yMAnT8rfe7HUv8dPbT8UDv24vxfThEE/LqnIfRon+wJFp/JamO2RDTPrpJytj
         KAM+g4f3K9klaDrXquTOclDUzEvmVXbtTr0vOdeiibwnxW40QwB0xdlmg4CGnjKu55yI
         s0dc18KIB5E57V4lB5XES3Hy8wvXnkSSQHMR7SDWaFjXprCzOXQIAB7yHKv+3PB7RE0R
         4yRV1nD+CsQ6j945YlG7YZTUjlUAtcm4lyISDE2/tddmjIASw9WMY8lih90/pJdUYUHc
         GrcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741780569; x=1742385369;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R9IlyLC7A5fKrEe72gCHfs3e2o6+wpvRXjQlPG7kMic=;
        b=PULDUvpkP62DIR5RdELjSqF2haL2Djd0fMF4muMSa7Op0FJTFNSpzB/MpHypLN1T45
         LG97ccxnOo9WOo5jaw3ETEUkqpsHIFtwAr0r4tj1x18GmloLHgnlOx4ZrnBiwVqJwLtz
         f++XGo5oCmwrXZDfuEJk32qIPoGxd2h45uXvUPgF1Y68yKSC85jbov2mLrwveaUFVjpd
         42nPMm7XFeR26hu20M967ueB+YOioknwpL3laT9PhyclJO50vvX2QtAPGdPCaSq/2nEb
         2NezfL+HPVq72GFBWawbY1nA6SVdP8PeyaInWEOZIAXvdorfVOl8xuSN7vJ5EUJGVdwA
         HZYw==
X-Forwarded-Encrypted: i=1; AJvYcCWwgnX2PH4ICtwqkeo8PmQ3O/hh6/+NpU3CrI9ffZXehtG4ZV+a06MtQAeS2mI1b5UKwy9aA7A=@lists.linux.dev
X-Gm-Message-State: AOJu0YxolDKb12hkvIO2t0Pf9Wmm8b69u/RvoS4SIpvQhyQtSjdxbc2U
	C1aCskpzCk7y9KltQv7JUvnKcf8ij47DrrpKij7Mu7TnzUs8/f7eqTGNv3qQJHg=
X-Gm-Gg: ASbGncu25T3HeWeEjv+Hr89HgYcFbqOUdUQJMAT45P3e5ULlcubYoNeh/FQRiZEdzAm
	DtOq19GXj3iq1q+ytJOybxBm0YVewnvDMjMFlrmAtUhy4YdOIRjAVnG4U/Myzf4S4QvQfXtOe6j
	taaINmdUyyThP6MWZTmyi2afvSKvuSZHEr/7Y6y99xmtbdv7j5AN47HEsXR+iumfBA+DusqIaHl
	5B50TVX6+mwc6JhhXqEcHBBquUEttqfgzQ3GDS+RbJ3Fbe7qSkjmyTUq90ovyFZlB7c8RCMi37L
	HMWPUt3Hm98rBu6brlC+kcOudae3yf1hPuRFp2YXD0LuGOWn
X-Google-Smtp-Source: AGHT+IEZMl7qgOp/elCr4VXp7AlgwKiCuKen+kfThanblODxDmQAYt3d4nqftKdNx7NyuuUlrtd5xg==
X-Received: by 2002:a17:902:c94d:b0:223:5c33:56a8 with SMTP id d9443c01a7336-22428ab89ccmr358251575ad.35.1741780569502;
        Wed, 12 Mar 2025 04:56:09 -0700 (PDT)
Received: from localhost ([157.82.205.237])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-736a1f813d1sm11378575b3a.129.2025.03.12.04.56.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Mar 2025 04:56:09 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: [PATCH v3 0/6] KVM: arm64: PMU: Fix SET_ONE_REG for vPMC regs
Date: Wed, 12 Mar 2025 20:55:54 +0900
Message-Id: <20250312-pmc-v3-0-0411cab5dc3d@daynix.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAEp20WcC/1WMOw6DMBAFr4JcZyN/MOBUuUeUwlnssAUf2ZEFQ
 tw9hjShnKc3s7LoArnIbsXKgksUaRwyqEvBsLPD2wG1mZnkUnPFJUw9wstw21TWm1Ijy88pOE/
 zUXk8M3cUP2NYjmgS+3r2kwABaL03jeFGtXhv7TLQfMWxZ3sgyX+p/kkSOFSoVK2t9sKVJ2nbt
 i+40r9pzAAAAA==
X-Change-ID: 20250302-pmc-b90a86af945c
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Andrew Jones <drjones@redhat.com>, Shannon Zhao <shannon.zhao@linaro.org>
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
Akihiko Odaki (6):
      KVM: arm64: PMU: Set raw values from user to PM{C,I}NTEN{SET,CLR}, PMOVS{SET,CLR}
      KVM: arm64: PMU: Assume PMU presence in pmu-emul.c
      KVM: arm64: PMU: Fix SET_ONE_REG for vPMC regs
      KVM: arm64: PMU: Reload when user modifies registers
      KVM: arm64: PMU: Call kvm_pmu_handle_pmcr() after masking PMCNTENSET_EL0
      KVM: arm64: Reload PMCNTENSET_EL0

 arch/arm64/kvm/arm.c      |  8 ++++---
 arch/arm64/kvm/guest.c    | 12 +++++++++++
 arch/arm64/kvm/pmu-emul.c | 54 ++++++++++++++++-------------------------------
 arch/arm64/kvm/sys_regs.c | 53 ++++++++++++++++++++++++++--------------------
 include/kvm/arm_pmu.h     |  1 +
 5 files changed, 66 insertions(+), 62 deletions(-)
---
base-commit: da2f480cb24d39d480b1e235eda0dd2d01f8765b
change-id: 20250302-pmc-b90a86af945c

Best regards,
-- 
Akihiko Odaki <akihiko.odaki@daynix.com>


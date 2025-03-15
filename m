Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55244D531
	for <kvmarm@lists.linux.dev>; Sat, 15 Mar 2025 09:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742029963; cv=none; b=dMelgZYV7SCkWJmYFOi3IgR1GD7AhP/4Z1WG+EaAg32aopzcK+PW8b+zK0C23MyiHuSym1Alj077QveWvwHwLyO3FWe/zVMGP+MrnWlM1dNJRQiZAGQwlCwgTr1Dd3H+6kPVWzXdwvA1PuhgTsLA601uVP/F19slT1dZQWv8tP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742029963; c=relaxed/simple;
	bh=HLSOm3R6nr19ptigB7cJt4Vl8chHdPlqn/pPY/+ONhk=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=tCB3gJgQXAlbsFXmGhzhxwRmJNtLtuxN0hSw5y68lwL91iOGDH6Q6LrJFtgZGpVS74oo50sk1ujH/jsdn+gVuFYBg+os9cSjct64PU65hom4E+mHioqNulaQXjFPYFy+YDWinQEUFWnUrUqZJRyzDAa8JRHLQnYknG1o0YV4Kr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=hhRTbsDg; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="hhRTbsDg"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2235189adaeso49878535ad.0
        for <kvmarm@lists.linux.dev>; Sat, 15 Mar 2025 02:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1742029961; x=1742634761; darn=lists.linux.dev;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KLwVXPbbRkF8uCWikKGIA8xgMN+KuKWxo6BOl1fHSvk=;
        b=hhRTbsDg49FQieTQ/ant8hn2bPuS1gfWB8JajBqDTEurLEj1wkGj2pZNVKQEIhGkrw
         lro4WeXhoZSQHDkKUWnxYs+3LE+v0ecY3ssRtWUur64Sdk8LzCKmKiqfv3VwqaP6tBdC
         bZfeBrt9Y9zcDgPIaAdZsd7pUTg82ZYcdEdkg6oYO1QVmCNKFBvp5QXrNEr5Xg50M/Is
         tL2u8wb/+JPViVFcUhTI8QONXpugg3+lCMBJVfbszePbPAyuiy9ijWgj/XN5EBpB4hOt
         cfbs9yg+ZRp0BCGpl1NwPQjH5Xo2IXjFdcjd1lIwh1qRfx3YNMJDW2fyDkNZuuLYXzck
         gtEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742029961; x=1742634761;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KLwVXPbbRkF8uCWikKGIA8xgMN+KuKWxo6BOl1fHSvk=;
        b=VBimLv/RFLEGrqJLNRH/XzaQkPGVkTKVo2AYpL/PXKye0tQSsvAUv+VPmE77ad8fQB
         nkcNLijNAh0aHkqZR0D/TnLUaKeQIybjf3mcVYXl72rqjopX/jWiTztBnpKfUz8/qIsv
         jh/P7P/v68G4d6oW+nHyxNLql0CpDeHdQKuIFV0M3uBH1357dYFPvQrSPpc/izP/H0b7
         fxH9tpQu6uBXuzEkL/97xLTry68DuTQAMiIvMEu8EQlYdrhpaKI/CapY4LDK1ssyb90s
         xI89syYGyM833i5b1GUw199OvGTJgZhByks1PyO7oLfSpdaeTOCtFTmqzuQczhxqKhGN
         tsFQ==
X-Forwarded-Encrypted: i=1; AJvYcCUghui74dfWKL42azSNgclvNVJJids9UFBkDNbUUk6g/c63LEp1QbbmEGXREXVFSG7nZ9hlto4=@lists.linux.dev
X-Gm-Message-State: AOJu0YzrebIyW2jbABd0UaUTM2SWyWhsYFcu/hYbj6+XIsp6oZCvve/J
	2wVbKMZAeT3meS6yYybsku+KwjSsL6wcuGVMhSzuOIDZxB964ITG0LHHfU1gLcE=
X-Gm-Gg: ASbGnctDYxs3t+UOyuK3SmYdlZv2MM8vrL5PWaTtDEktIH465cMdbbJg01MBmkEyvIm
	nbXMrJp9gwNPiyAqiEJMGq5Na6piP4h+xgoIIdFVude/bpqgcHlLmlxcAl6+iad2DqZY2k8YJrH
	Zk04S3s6EVTSPTwMhSXrddakx6xI1HQk75pemOQM2dvlDaqtZiNy4kPqSJkJxCiCgW3y0R+og4l
	lcuoKkMUI0CY2U2cRPX6nz5tidSfsNzXjK3cF6nhRMUyVR9i8ctHNqWthRd5kVi5/0LeYAEIzzG
	hqKT2NGKeQK5cPGgLi6aYLnB9VkAHdTBSLiMJm+8VYXKQRp1
X-Google-Smtp-Source: AGHT+IFQlkAYLQJz9OZLtD7VhX6ghBBoAGJzqQtpfj3z/JvhpgmI8tBgESFhabIFaTXRXazJxYdPNQ==
X-Received: by 2002:a17:903:3c64:b0:215:ba2b:cd55 with SMTP id d9443c01a7336-225e1681376mr66493455ad.2.1742029961548;
        Sat, 15 Mar 2025 02:12:41 -0700 (PDT)
Received: from localhost ([157.82.205.237])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-225c6ba7255sm40793705ad.126.2025.03.15.02.12.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Mar 2025 02:12:41 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: [PATCH v5 0/5] KVM: arm64: PMU: Fix SET_ONE_REG for vPMC regs
Date: Sat, 15 Mar 2025 18:12:09 +0900
Message-Id: <20250315-pmc-v5-0-ecee87dab216@daynix.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAGlE1WcC/2XQQW7DIBAF0KtYrEvFMGAgq96j6gKGccPCdmq7V
 qIody+Ju3CU5Qfeh+EqZp4Kz+LQXMXEa5nLONRg3xpBxzh8syy5ZqGVtgqVlqeeZAoq+jZ2wVg
 S9eRp4q6cHy2fXzUfy7yM0+VRusJ99dmvIEFS7LrggwqY6SPHy1DO7zT24l6w6j1yG9JSyZYQn
 Y22AzYvCHcI/m/CipQBoJhsJswvyOwRbshUpCm41msH4J+fd9sGnvjnt/7Wsk0tUpxZ1v2+LIf
 GK7aGvQkAMWgko7JLzIgRDUEyicH47GItu/0Bqtb5MIIBAAA=
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
Changes in v5:
- Rebased.
- Link to v4: https://lore.kernel.org/r/20250313-pmc-v4-0-2c976827118c@daynix.com

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
Akihiko Odaki (5):
      KVM: arm64: PMU: Set raw values from user to PM{C,I}NTEN{SET,CLR}, PMOVS{SET,CLR}
      KVM: arm64: PMU: Assume PMU presence in pmu-emul.c
      KVM: arm64: PMU: Fix SET_ONE_REG for vPMC regs
      KVM: arm64: PMU: Reload when user modifies registers
      KVM: arm64: PMU: Reload when resetting

 arch/arm64/kvm/arm.c            | 17 ++++++++-----
 arch/arm64/kvm/emulate-nested.c |  6 +++--
 arch/arm64/kvm/pmu-emul.c       | 56 +++++++++++------------------------------
 arch/arm64/kvm/reset.c          |  3 ---
 arch/arm64/kvm/sys_regs.c       | 52 ++++++++++++++++++++++----------------
 include/kvm/arm_pmu.h           |  4 +--
 6 files changed, 62 insertions(+), 76 deletions(-)
---
base-commit: 80e54e84911a923c40d7bee33a34c1b4be148d7a
change-id: 20250302-pmc-b90a86af945c

Best regards,
-- 
Akihiko Odaki <akihiko.odaki@daynix.com>


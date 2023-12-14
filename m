Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94FB2E64B
	for <kvmarm@lists.linux.dev>; Thu, 14 Dec 2023 10:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DhsBca11"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5e27479b6e2so25149147b3.0
        for <kvmarm@lists.linux.dev>; Thu, 14 Dec 2023 02:02:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702548120; x=1703152920; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jcmoOfTfuAZe0H48BAZSQKy3c0OXKN12bT3q7fYzvao=;
        b=DhsBca110gSM009jzFNAsjdghty3Ipdr/HIPLdvCbTw7RFtCbhy9VI1dbPi0sVPV5k
         5XsfgvZ8MLmiOm8peePlrfl1SpGHFLmk18GILaV6CXJAy6P2rN7gGruXPwE5d7La0XGA
         g5VcJ7PHVHWnAdu6KSGSge5DLto7KV0HAkvCBP6fPE7V/IVg8eTP6SdNmh1z04fZ8bu/
         YsapDdUgK2ZfI4RnfID8QQO5EeujlqIQO+sok7PbsQ7TWyc4t2vE/WgiHtYHGP+zuffK
         qfXnuujAXtYHT0xxr5hfBdJN+VGKCAQzo+A/A9KhaSQeUnO4g2hDioDxMJPRoqaMm9AV
         2d2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702548120; x=1703152920;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jcmoOfTfuAZe0H48BAZSQKy3c0OXKN12bT3q7fYzvao=;
        b=F+hGapqXhsZaaON0fRJaIn3Lfszo9V8oXF/8jgnMabnNvEHl7dex/+/X770sq+RvcB
         z7FxbYukQY1XKiMKaad4VA+e6ku2Y02beV03fAuD3CmRFOow4YWNq5Aenf1ZvAO50Rm6
         S6iSoaMPyLVbhkoaundiAA/wsVMtTbLai6MSSTEZP90mS3gcXfJOCBP1HS9AeQS7kIOI
         267RmUr/vRda1MgfQUW9pW8SlxTAn+l/t1sF7e5aZckXaeczSI936frs24/z0lSrBtqe
         OXsNWZJ2IVYvz4EtuYH7wgGgg7xPS4TuUYeLAAKVODaxBR/5M305nbkWbz+lXjN9/+W1
         JjvQ==
X-Gm-Message-State: AOJu0YxL/6yepCaIDWYSCImEBH+uXBZ/T9N2ES9ifprEUGU17JTfVAVx
	ZxmNxEPjEtBQmVsTiet4kQtFM9aADMR629XkOHtUtvqBrzHoDYWXEwK1l36hsEOS8vyI6MgZIMj
	YcP/2FTuaeWeWYgmi07BomTEKHtu78VZCRbXkRgqCK/2lv3FtR8wGIP4BhNk=
X-Google-Smtp-Source: AGHT+IHa7ZGIfNRAiqR5mQm9iMrynhdS+L689UnGmzl+oKTX6+S84bpG0jYLqqqsBtLwgJhUvmIEHp0/bQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:534:b0:db5:41e9:aa1c with SMTP id
 y20-20020a056902053400b00db541e9aa1cmr74689ybs.11.1702548120127; Thu, 14 Dec
 2023 02:02:00 -0800 (PST)
Date: Thu, 14 Dec 2023 10:01:40 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231214100158.2305400-1-tabba@google.com>
Subject: [PATCH v3 00/17] KVM: arm64: Fixes to fine grain traps and pKVM traps
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, broonie@kernel.org, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, eric.auger@redhat.com, 
	jingzhangos@google.com, joey.gouly@arm.com, tabba@google.com, 
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

Changes from v2:
- Rebased on arm64/for-next/sysregs, which includes new system
  register definitions (Mark, Joey)
- Explicitly trap unsupported HFGxTR_EL2 features rather than
  relying on its nMASK (Joey)
- Add new system registers to the auto-generated sysreg rather
  than hardcoding them (Mark)
- Drop patch that was meant as RFC
- Added missing system registers, fields, and  system
  instructions
- Split patches that make system register changes
- Fixes to patches defining allowed features for protected VMs
- Other minor fixes and tidying up

Changes from v1:
- Handle HAFGRTR_EL2 in nested virt
- Update the nested virt FGT tables with the added trap bits (Marc)
- Use the generated value for RES0 (Marc)
- Calculate the value of NMASK based on RES0 and MASK

This patch series has fixes, updates, and code for validating
fine grain trap register masks, as well as some fixes to feature
trapping in pKVM.

New fine grain trap (FGT) bits have been defined in the latest
Arm Architecture System Registers xml specification (DDI0601 and
DDI0602 2023-09) [1], so the code is updated to reflect them.
Moreover, some of the already-defined masks overlap with RES0,
which this series fixes.

It also adds FGT register masks that weren't defined earlier,
handling of HAFGRTR_EL2 in nested virt, as well as build time
validation that the bits of the various masks are all accounted
for and without overlap.

Based on arm64/for-next/sysregs (e94e06d8a796), which is composed
of system register updates [2] and is based on Linux 6.7-rc3.

Cheers,
/fuad

[1] https://developer.arm.com/downloads/-/exploration-tools
[2] https://lore.kernel.org/all/20231209-b4-arm64-sysreg-additions-v1-0-45284e538474@kernel.org/

Fuad Tabba (17):
  arm64/sysreg: Add missing Pauth_LR field definitions to
    ID_AA64ISAR1_EL1
  arm64/sysreg: Add missing ExtTrcBuff field definition to
    ID_AA64DFR0_EL1
  arm64/sysreg: Add missing system register definitions for FGT
  arm64/sysreg: Add missing system instruction definitions for FGT
  KVM: arm64: Explicitly trap unsupported HFGxTR_EL2 features
  KVM: arm64: Add missing HFGxTR_EL2 FGT entries to nested virt
  KVM: arm64: Add missing HFGITR_EL2 FGT entries to nested virt
  KVM: arm64: Add bit masks for HAFGRTR_EL2
  KVM: arm64: Handle HAFGRTR_EL2 trapping in nested virt
  KVM: arm64: Update and fix FGT register masks
  KVM: arm64: Add build validation for FGT trap mask values
  KVM: arm64: Use generated FGT RES0 bits instead of specifying them
  KVM: arm64: Define FGT nMASK bits relative to other fields
  KVM: arm64: Macros for setting/clearing FGT bits
  KVM: arm64: Fix which features are marked as allowed for protected VMs
  KVM: arm64: Mark PAuth as a restricted feature for protected VMs
  KVM: arm64: Trap external trace for protected VMs

 arch/arm64/include/asm/kvm_arm.h              | 61 +++++++++------
 arch/arm64/include/asm/kvm_host.h             |  1 +
 arch/arm64/include/asm/sysreg.h               |  7 ++
 arch/arm64/kvm/emulate-nested.c               | 63 +++++++++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h       | 77 +++++++++++--------
 .../arm64/kvm/hyp/include/nvhe/fixed_config.h | 22 +++++-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                |  4 +
 arch/arm64/kvm/sys_regs.c                     |  1 +
 arch/arm64/tools/sysreg                       | 50 +++++++++++-
 9 files changed, 225 insertions(+), 61 deletions(-)


base-commit: e94e06d8a7960fd840ea92021ca1bf1362ea67f8
-- 
2.43.0.472.g3155946c3a-goog


Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3D615AC1
	for <kvmarm@lists.linux.dev>; Wed,  6 Dec 2023 10:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XlCwRun5"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5d340a9cf07so101772957b3.3
        for <kvmarm@lists.linux.dev>; Wed, 06 Dec 2023 02:05:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701857105; x=1702461905; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hKt4wnxhbWMieJh8Fo1EeTPFkyfgQ6Kk+mcH0bY82so=;
        b=XlCwRun5/jC/T544F+a4EjEyNxHBLa6m6XaDrY5jVnJRNrNcWTMuNDmbIl4MgmIYrj
         +0aaWiPGenpWp41QuHXku1Y89261jbmWdZE14A2rv5+IkMChmwjnFW//2VWttb+cdxgZ
         1AqHFDudeas236GWVauypyLV0RI7y3pWpfR2qlmUfAQ7xaOLEwkmLiXDJy25bNPCl+LH
         EF9WUvCBGpPaUKEU836dU4QG5S/ZybqwlL/ogI4Tuzzl27KfbN1LietB6JCuuFuFaw9L
         PFigZj7YSd4M+y6QIcov2lvIkjnDOxcPNXJ5WsDlU5p2F4ayV5eewiv7J2B8MErSpQNT
         4ggQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701857105; x=1702461905;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hKt4wnxhbWMieJh8Fo1EeTPFkyfgQ6Kk+mcH0bY82so=;
        b=axcUP/93L1qQPtDfZ1o4z0SeKwkXhyO3uCR4IizLQhicucqH8CvaA5YQU29LscD2CU
         ExEA0vPH0HovlVMYVBTB6sabdeP+fJuVDKTHBLQcCgUIwuqrAGxDHGtAI9UMrLSsdlWm
         RBR6fGYjMHxFunmdEsmYmrd8oH8ibtrUeQbRPLwe09ZlZHEq68hPPbd+4BBvSHujF650
         +deosJf7bH4heSZnmMF7V20X6L3m1n0PhZU4ZGLvfny4bhoFy/MEtEKybBYikc/slg9Q
         ckn6fXQgiFrmznXwxZN/rnYIfdzOAvx8x/8p9Eq0wLfttCwHMxH8Vvr8WG7tVXvxnnkd
         szGg==
X-Gm-Message-State: AOJu0YyxCb+MK1273hWeDar1AemU/xOENPT6EjE/pqqefidYI/14Bd3b
	6ER3KVLcwrXdfbS30LgyZJ9lyNkOhRoL1YIBJw6/PgjpF8kqBIlHt8wbQPKbP3DIk9yFdCSG7Gk
	qvS2oBVGec1k2q3wlGmH5gaGPlX4TbRh8qjkvGhLy2n4hIv/7ss3TWUqWFrw=
X-Google-Smtp-Source: AGHT+IE0PJsBsYo7iM8Ik4Zx22L0blbH5vZfupSNvop9lHF+Jf6kBA570/+wuauYae2DfKLmqYI0SGe29w==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a81:99d0:0:b0:5d4:3013:25d4 with SMTP id
 q199-20020a8199d0000000b005d4301325d4mr6275ywg.5.1701857105270; Wed, 06 Dec
 2023 02:05:05 -0800 (PST)
Date: Wed,  6 Dec 2023 10:04:50 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Message-ID: <20231206100503.564090-1-tabba@google.com>
Subject: [PATCH v2 00/12] KVM: arm64: Fixes to fine grain traps and pKVM traps
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, eric.auger@redhat.com, jingzhangos@google.com, 
	joey.gouly@arm.com, tabba@google.com, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

Changes from v1:
- Handle HAFGRTR_EL2 in nested virt
- Update the nested virt FGT tables with the added trap bits (Marc)
- Use the generated value for RES0 (Marc)
- Calculate the value of NMASK based on RES0 and MASK

This patch series has fixes, updates, and code for validating
fine grain trap register masks, as well as some fixes to feature
trapping in pKVM.

New fine grain trap (FGT) bits have been defined in the latest
Arm Architecture System Registers xml specification (2023-09)
[*], so the code is updated to reflect them. Moreover, some of
the already-defined masks overlap with RES0, which this series
fixes.

It also adds FGT register masks that weren't defined earlier,
handling of HAFGRTR_EL2 in nested virt, as well as build time
validation that the bits of the various masks are all accounted
for and without overlap.

Based on 6.7-rc4.

Cheers,
/fuad

[*] https://developer.arm.com/downloads/-/exploration-tools

Fuad Tabba (12):
  KVM: Add missing HCRX_EL2 field definitions
  KVM: arm64: Add latest HFGxTR_EL2 FGT entries to nested virt
  KVM: arm64: Add latest HFGITR_EL2 FGT entries to nested virt
  KVM: arm64: Add bit masks for HAFGRTR_EL2
  KVM: arm64: Handle HAFGRTR_EL2 trapping in nested virt
  KVM: arm64: Update and fix FGT register masks
  KVM: arm64: Add build validation for FGT trap mask values
  KVM: arm64: Use generated FGT RES0 bits instead of specifying them
  KVM: arm64: Generate the HFGWTR-only RES0 bits
  KVM: arm64: Define FGT NMASK bits relative to other fields
  KVM: arm64: Trap external trace for protected VMs
  KVM: arm64: Mark CMOW as allowed for protected VMs

 arch/arm64/include/asm/kvm_arm.h              | 58 +++++++------
 arch/arm64/include/asm/kvm_host.h             |  1 +
 arch/arm64/include/asm/sysreg.h               | 20 +++++
 arch/arm64/kvm/emulate-nested.c               | 63 ++++++++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h       | 29 +++++++
 .../arm64/kvm/hyp/include/nvhe/fixed_config.h |  4 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                |  4 +
 arch/arm64/kvm/sys_regs.c                     |  1 +
 arch/arm64/tools/sysreg                       | 82 ++++++++++++++++++-
 9 files changed, 231 insertions(+), 31 deletions(-)


base-commit: 33cc938e65a98f1d29d0a18403dbbee050dcad9a
-- 
2.43.0.rc2.451.g8631bc7472-goog


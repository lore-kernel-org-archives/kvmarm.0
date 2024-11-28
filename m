Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA3A195385
	for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 12:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732797320; cv=none; b=iuX8bXP5WEr7lxsnhSBt0cGz/s4McZHeJQeMKTfYhmXX2uyTh/H1rhvQISK1DSceq+JDlS2WuJnfHPNE/LA6lXMgDgj+aBY4KatPaA2H+Tz+4S7cvXhk5FrKw3DhSN32bOcQuKqhRxoTEtaYfiMyvhwDFD/seViE4fhFQIBqGrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732797320; c=relaxed/simple;
	bh=PJ2R48m1QOHmMSNOB88d8Ni5c8G59raWD8VX7yGv8zU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=i1WVtFsTKDqLbhJgIrRhL4rjA+XJoAaTJCex7BLFE/p2NTaYVOyXkJSVN2YdnP99lS8Xf1EPvjq7fPqMG744TCx5ZSfgG7qkNbqx+umHqzF6eS3INDDNFbvhQ6CF2xlL1Saukq2ZRBQG7itRTVYCAmlGESIjm9zlXaWnAZKbbb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hY9fhe73; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hY9fhe73"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4349cbf726cso6116655e9.3
        for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 04:35:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732797317; x=1733402117; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1TtG2bGm1kTJQrBMkxcresYx07XYbMxLIekhY/ZS7PQ=;
        b=hY9fhe73AuY1WXkGJsF+RVJ4QFYT74F2dKxpFaW4V+QdakKsOJN3EL4JZRgCiGrBPK
         ZT1yKXhAvEnGICFsIPuvAtU4wnU2VBL+GDoXb8ENYLjdTs/eHHZY4/FvQwFldjqmYm3n
         3LzEPTIPGmLmyyNg3m4HUeRev3h0jqG8MlhU91/UcNNuTCA+nzzHgLlixPDr6vKdFRJm
         aAF7MJPUPZFzaEQEGq0nV9Kp5uWewtNgeLH3g3QJnfqicLmqLz951WY0z9Qnuz4JnRKU
         VCq/y6IT36yoVk2KPxbwnx+HX1se53GYLATkK7WpeyjLW8DhyxJbvIW7FTCa/XOZLZV/
         h00Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732797317; x=1733402117;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1TtG2bGm1kTJQrBMkxcresYx07XYbMxLIekhY/ZS7PQ=;
        b=hLrtjBJFD7lf7YaUgOgJqLn8G32uxr2ZEQMxgk7dJRjYScJeHstDXWSbJGXpSkEvtl
         2mOBx4IeG3tkiGJfRe+T9NZXs8hiF5GAEvdgqcgLHoR1K/lLQm01HQ/nlHUJsc6id684
         iLv5ekM8RoQv5hPrpgFETsTrQPNxZJAkAgrIl5pi9yokOisdCi0s4Vnr1xIIGJREHuFP
         FxIUWoDTji0/Wr/C+btCikJ3/k04PgTbSD+YcdO26VBSktgw4KTMkQTmou4dWCiF+7SN
         wagIS7OWKw9J841f6RH6l1O8unXIGMw5VaD4cChCXT3O5r+3GgPwfkVTE/zvt90nF7RO
         uVWw==
X-Gm-Message-State: AOJu0Yyo9aopqViUdRYMVn/X3u8OzHYk+VqvEi9YtNV/FFuaHNTa3mYY
	1AcGvbMF+KIlBgp553pS6GyhkfBid4rz+yh/LBqVTaammvmdnsWTz34Hmj+/hxq8WpvfweyUqme
	pbthhY/r7ixozlfqljbsPbETXpwfv4WXZfOpQ3fnLo1CWrbP4GJUpuczqg8asjUnA39hbWHNKC8
	oq6r8q4hYP6Uk3y17bXuaoB9YkzaU=
X-Google-Smtp-Source: AGHT+IH2IM4W6WAIgVMbLGWBStWlI0DvrysFqeCP5tUZqsjNCDTaw1hNxBdBrk8TZXf/mO/x+4ENDxn6Eg==
X-Received: from wmgg28.prod.google.com ([2002:a05:600d:1c:b0:431:5888:7a68])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:474f:b0:431:54d9:da57
 with SMTP id 5b1f17b1804b1-434a9dfbc15mr70053905e9.30.1732797317110; Thu, 28
 Nov 2024 04:35:17 -0800 (PST)
Date: Thu, 28 Nov 2024 12:35:00 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128123515.1709777-1-tabba@google.com>
Subject: [PATCH v3 00/15] KVM: arm64: Rework guest VM fixed feature handling
 and trapping in pKVM
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	qperret@google.com, kristina.martsenko@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Changes from v2 (Marc):
- Added three patches that remove the per-vcpu flags of PtrAuth
and SVE being enabled for guests, in favor of them being per VM
- Tidying up

This patch series redoes how fixed features for protected guests
are specified in pKVM, as well as how trapping is handled based
on the features available for the VM. It also fixes a couple of
existing bugs in the process.

For protected VMs, some features should be trapped if the guest
tries to use them because they are not supported (e.g., SME), or
if they are not enabled for the particular VM (e.g., SVE).

Initially, pKVM took the approach of specifying these features
using macros and grouping their handling by feature id register.
This proved to be difficult to maintain and bug prone. Moreover,
since the nested virt work there is a framework in KVM for
storing feature id register values per vm, as well as how to
handle traps based on these values.

This patch series uses the vm's feature id registers to track the
supported features, a framework similar to nested virt to set the
trap values, and removes the need to store cptr_el2 per vcpu in
favor of setting its value when traps are activated, as VHE mode
does.

The changes should not affect the behavior of non-protected VMs
nor the behavior of VMs outside of protected mode in general.

This series is based on kvmarm/next (60ad25e14ab5), since it
requires the patches from the series that fixes initialization of
trap register values in pKVM [2].

Cheers,
/fuad

[1] https://lore.kernel.org/all/20241122110622.3010118-1-tabba@google.com/
[2] https://lore.kernel.org/all/20241018074833.2563674-1-tabba@google.com/

Fuad Tabba (15):
  KVM: arm64: Consolidate allowed and restricted VM feature checks
  KVM: arm64: Group setting traps for protected VMs by control register
  KVM: arm64: Move checking protected vcpu features to a separate
    function
  KVM: arm64: Use KVM extension checks for allowed protected VM
    capabilities
  KVM: arm64: Initialize feature id registers for protected VMs
  KVM: arm64: Set protected VM traps based on its view of feature
    registers
  KVM: arm64: Rework specifying restricted features for protected VMs
  KVM: arm64: Remove fixed_config.h header
  KVM: arm64: Remove redundant setting of HCR_EL2 trap bit
  KVM: arm64: Calculate cptr_el2 traps on activating traps
  KVM: arm64: Refactor kvm_reset_cptr_el2()
  KVM: arm64: Fix the value of the CPTR_EL2 RES1 bitmask for nVHE
  KVM: arm64: Remove PtrAuth guest vcpu flag
  KVM: arm64: Convert the SVE guest vcpu flag to a vm flag
  KVM: arm64: Renumber remaining vcpu guest configuration flags

 arch/arm64/include/asm/kvm_arm.h              |   2 +-
 arch/arm64/include/asm/kvm_emulate.h          |  23 +-
 arch/arm64/include/asm/kvm_host.h             |  21 +-
 arch/arm64/include/asm/kvm_pkvm.h             |  25 ++
 arch/arm64/kvm/arm.c                          |  30 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h       |   2 +-
 .../arm64/kvm/hyp/include/nvhe/fixed_config.h | 223 ----------
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |   5 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |   2 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                | 335 +++++----------
 arch/arm64/kvm/hyp/nvhe/setup.c               |   1 -
 arch/arm64/kvm/hyp/nvhe/switch.c              |  56 ++-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c            | 402 ++++++++++--------
 arch/arm64/kvm/hyp/vhe/switch.c               |   2 +-
 arch/arm64/kvm/reset.c                        |   6 +-
 15 files changed, 430 insertions(+), 705 deletions(-)
 delete mode 100644 arch/arm64/kvm/hyp/include/nvhe/fixed_config.h


base-commit: 60ad25e14ab5a4e56c8bf7f7d6846eacb9cd53df
-- 
2.47.0.338.g60cca15819-goog


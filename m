Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E763ECBD8
	for <kvmarm@lists.linux.dev>; Thu, 22 Jan 2026 11:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769080942; cv=none; b=pMtWoJEfnJCb+UNeovrQzv/Xz8jTuMUWp5W775wSxh/S3LNXiR0W14+PhxsUBq2YOGgp4pBDH9x7W3/V882Suddaw1FgT4Pd6BME2fRWiyiz42aQeLsjwNvnydOCHSeeuNBnoerATxvgSTqV7SPoXLhmws+lELVCrXiVaxb27/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769080942; c=relaxed/simple;
	bh=FM31oenZVkSZOBfJ19MuaLaeMNDtKRKSlu5W3b5D4EI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=j0We2/TYVoR14FFkUip7EHdS932pNXMfqoYJ8LAq31EH6nBp+Qacs1DvvcwKXvho273DF8AWm82F6vivxZe1YtkgYMOZygNqqx+T09nsBBx8GCW8AMcxapLLda6ODgW29xThIKc/cyEFcnmK7SSxoPhgCQApMYzDgt8AkYzvYUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YyrXxlGd; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YyrXxlGd"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-47fff4fd76dso6654635e9.3
        for <kvmarm@lists.linux.dev>; Thu, 22 Jan 2026 03:22:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769080939; x=1769685739; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QGIMyup1UugtxhG5c48JAapo6xJWqwlZ2t4XWmKNlso=;
        b=YyrXxlGdySrnvXO1TzOb/81CAa/upwoJEE2B0XpAjXs17Q+QJyXKqfpx0yMudyX49n
         APpTcn5k6Y75pmJysBYebjJPDJ7wl2QlI4isbyNruRzQ/fe5dsPwf5URUuhP+O/eTVVp
         GJ1WH42WXSqrOSNra28FQlMH6lk5D7hvukSbZLvX1PUzo2yUjsDVJXUb17h8Uyvhf2fI
         Enz/wtFJ8eWvIMW2kZ/wtvAB1seTMTo59pAlZwjp3ETUgxPA2fmQI7NFu/HOa9mPG7XI
         63HHsYZx5BqN+mkYyj+46/w0UZ9aKtdSzkM8tGKi3E4g2jt0NXHXD7p3K8MfXilCXx4C
         yWww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769080939; x=1769685739;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QGIMyup1UugtxhG5c48JAapo6xJWqwlZ2t4XWmKNlso=;
        b=iu950sE7p7y9EfnwfWjJ7PkJW/aVqyC6jH0xT0Ypi4Dzr0Nej7W9J/Qd7IbP+5OQ02
         LT5cDpn46Sdu2NYVe1zZKFY2Crzxnj9ZUFPef6SQ5j8D3HxH5R6Odpd4prI/T5zvzSva
         3x9QdXF0kMiw9lP95005WLjF3ptjBuIK//q/2xR+FMVtVVw2WHM+j2jqnNwJb4RXjyEU
         4nfd+JtaAeZpqOS14QEiThkrcUfttCY9VCCxa2O1WEW7VOOvb/8E6cB5MHWZzNWiKU2Z
         NnTFw55ASDMuQ/2DaihGvTUBJsFVCfWaxRutru8lSGDQaXWOrggL0P2XJSXjJVs1pwzL
         CfYg==
X-Gm-Message-State: AOJu0Yw1GnP0Ov88FB2G9dwFx6BHbj7XHqYipF7Oo839yZy2A/SiyW1B
	NF3IDZlZ8VGseUC7hpZIRshWzH1Zx3b9pxHpcmEwAiE3ki9tJKXn9/BU0x7q1ufGO3cfroeRduD
	d+9BU0w3eojQ9Af83yPeGtnvZrF0yE5NB77d8xlFJlZ70ae69/ZzNKhRSYc07oKGyrQ5iz2X+BP
	EOQf2NVfdplDkrsjVxkATDS+FohDriAmQ=
X-Received: from wmbka17.prod.google.com ([2002:a05:600c:5851:b0:477:9945:466d])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4e93:b0:477:7f4a:44b4
 with SMTP id 5b1f17b1804b1-4801e30a606mr299888715e9.1.1769080938838; Thu, 22
 Jan 2026 03:22:18 -0800 (PST)
Date: Thu, 22 Jan 2026 11:22:14 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260122112218.531948-1-tabba@google.com>
Subject: [PATCH v3 0/4] KVM: arm64: Enforce MTE disablement at EL2
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Changes since v2 [1]:
- Trap accesses to GMID_EL1 by setting `HCR_EL2.TID5` when MTE is
  disabled (Marc)
- Dropped patch refactoring `enter_exception64()` in favor of open-coded
  logic in `inject_undef64()` in patch 3/4 (Marc)
- Based on Linux 6.19-rc6

pKVM never exposes MTE to protected guests (pVM), but we must also
ensure that a malicious host cannot use MTE to attack the hypervisor or
a protected VM.

If MTE is supported by the hardware (and is enabled at EL3), it remains
available to lower exception levels by default. Disabling it in the host
kernel (e.g., via 'arm64.nomte') only stops the kernel from advertising
the feature; it does not physically disable MTE in the hardware.

The ability to disable MTE in the host kernel is used by some systems,
such as Android, so that the physical memory otherwise used as tag
storage can be used for other things (i.e. treated just like the rest of
memory). In this scenario, a malicious host could still access tags in
pages donated to a guest using MTE instructions (e.g., STG and LDG),
bypassing the kernel's configuration.

To prevent this, explicitly disable MTE at EL2 (by clearing
`HCR_EL2.ATA` and setting `HCR_EL2.TID5`) when the host has MTE
disabled. This causes MTE instructions to trap to the hypervisor.

Cheers,
/fuad

[1] https://lore.kernel.org/all/20251211113828.370370-1-tabba@google.com/

Fuad Tabba (4):
  KVM: arm64: Remove dead code resetting HCR_EL2 for pKVM
  KVM: arm64: Trap MTE access and discovery when MTE is disabled
  KVM: arm64: Inject UNDEF when accessing MTE sysregs with MTE disabled
  KVM: arm64: Use kvm_has_mte() in pKVM trap initialization

 arch/arm64/include/asm/kvm_arm.h   |  2 +-
 arch/arm64/kernel/head.S           |  2 +-
 arch/arm64/kvm/arm.c               |  6 +++
 arch/arm64/kvm/hyp/nvhe/hyp-init.S |  5 ---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 67 ++++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/pkvm.c     |  2 +-
 6 files changed, 76 insertions(+), 8 deletions(-)


base-commit: 24d479d26b25bce5faea3ddd9fa8f3a6c3129ea7
-- 
2.52.0.457.g6b5491de43-goog


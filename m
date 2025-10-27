Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6162FB98B
	for <kvmarm@lists.linux.dev>; Mon, 27 Oct 2025 11:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761565188; cv=none; b=i3RWkPVbUyeRGoL+L5HOM/NEEp/V9NbkBs0/WNCyhYyrZLZlU7hSfPxEcNY6A38DaoweIop1PzDDr3Q7yp24KC2KoqfC1gg35SQzB/bqnwj0QxKqBeH4BrrOdVy3ylhJ9Kiq6vRS0nTYFie+thNc65XhcLuXijQ6gfFELiscbwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761565188; c=relaxed/simple;
	bh=uyG88eoeNDcrOWdUXNcbGFhXSLdBDCgZmTPebSjOGmA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=AEYH+8tzEjkJmofYKheUCWIiBdnC8P40XASffYEZWXuAAJVJWjAta2sRM4PHljBVV81SKgM5kdssqpXNHW7aaUhoEIfHVOG2PxkGFtbbX6RCQPOrFcQbs8g7i7QCJQM6hmHcHdGwicfThep5z2dTJYabg7bSOVsME4Wt4bIufhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oYc4hX+m; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oYc4hX+m"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-477113a50fcso10351865e9.1
        for <kvmarm@lists.linux.dev>; Mon, 27 Oct 2025 04:39:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761565185; x=1762169985; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=W3zZy85oW98LmzlLLVlNLP/kxDk+jUE3Sk+1kWzQBq8=;
        b=oYc4hX+mGPhrxJdkBxiryBbGz/SJ4LIVWfpz1tXgzGkZiV9oWRyIoQ+92RXw9N0uQz
         46qJKTSQ6CNzLCwuhSO6kKgePiv8ugpTwaaDwfuo1LST0CjqGaURNyGVZjO3r/dpTViG
         GA23ofiUWUgHSCF1bo3OBS7dICA5YcsMcvwjB+eKX5wvoBU+Q3ZyLmdwesyeShmp0Fia
         ymc0w9SGGlUA/+eEhEAOINirUL6lOqooIXs3W2835mdzVQ7tFxKpYi4Gij3ZcOUy8Kqc
         0bnN/bcC6SNObckin+reGboLcb40FKGMm8jy9DitdTB8nCO9GHJWWVvVJ6qFADha2cs/
         4UYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761565185; x=1762169985;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=W3zZy85oW98LmzlLLVlNLP/kxDk+jUE3Sk+1kWzQBq8=;
        b=kg43qo/vx5tg/n1yLim3GHHcsV93hf4Uc/ZrJqDh1TAlmH1KH8kH7TZRgpZ6ri4aub
         RmEswo9u6Dz1eldeHS65P82Rp5nh5zyWJ+j5RdXQMwFnda7Qk9PcHci3vAhyz06pdbOY
         2jxONnAgTSMD29v/STNlbLbvupnwJwruAmbCWYaV31uEj+3JDhkhh8XhxDM6u7XtTl+1
         srx9Ik95nP2DZKbP5ezwoyLd/bNYEVeofajHV472r3kc2pG2gxtV+qv/44l3E+rZHkSK
         0R54Fa6rLppwOYWYuCRuiCFC0pxID7zwiEOkCBcaVJZJTWettz3uvwF2/K78QgmEMAEu
         Dkig==
X-Gm-Message-State: AOJu0YwPbce2GkPjJfdTOV+EtC0NB2jA2MxJ97ZBBiiN95ebbjCrbGKz
	Q25B0kygZQA+jGEPNJt0Iz58LNK399NX2b0zYqnV3SSIRSFqC4vqeA9SdFCdvQwZtc+32gCQVVu
	eummjZMgUEufr9qvgh5LjYqvxEX22YrxddOLx3xJeGQwWou+tYoBzbaDC1H4K/YOYGRTpUjXWcd
	JLAyPj7sZOOQDhT+BjCoxl42pP9Qq3sAM=
X-Google-Smtp-Source: AGHT+IGfIk/DDRBImLoLQrIA8NfRPRuJ6G5SFEtQg8ZEUOxNLLwzjWpF+jFxftbCRBMSKvrx+1GVUBgyOw==
X-Received: from wmwo28.prod.google.com ([2002:a05:600d:439c:b0:471:6089:1622])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3e07:b0:46e:450d:e037
 with SMTP id 5b1f17b1804b1-4711786c560mr290520485e9.5.1761565184474; Mon, 27
 Oct 2025 04:39:44 -0700 (PDT)
Date: Mon, 27 Oct 2025 11:39:39 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.1.838.g19442a804e-goog
Message-ID: <20251027113943.1282568-1-tabba@google.com>
Subject: [PATCH v1 0/4] KVM: arm64: Prevent sysreg helper parameter transposition
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Some of the KVM/arm64 sysreg helper functions and macros, such as
vcpu_write_sys_reg() and __vcpu_assign_sys_reg(), are prone to parameter
transposition bugs. The 'reg'/'r' (enum vcpu_sysreg) and 'val'/'v' (u64)
can be easily swapped, as the types are not distinct enough to be caught
by the compiler.

There are a few functions and macros that have similar parameters and
behavior, e.g., vcpu_write_sys_reg(), __vcpu_assign_sys_reg(), and
__vcpu_rmw_sys_reg(). However, the ordering of the reg and value
parameters is not consitent across them [*].

Moreover, there is neither a compile time nor a runtime check that
catches these errors. This has caused at least one bug that made it
upsteam: commit 798eb5978700 ("KVM: arm64: Sync protected guest VBAR_EL1
on injecting an undef exception"), and other kernel developers have also
run into similar issues from speaking to them.

This series addresses this in two ways:

* The parameter order of vcpu_write_sys_reg() is changed from (vcpu,
  val, reg) to (vcpu, reg, val), making it consistent with similar
  functions and macros.
* Compile-time checks are added to prevent the 'reg' parameter from
  having a 'u64' type, which directly catches the transposition bug.

No functional change is intended in this series.

Based on Linux 6.18-rc3.

Cheers,
/fuad

[*] Just take look at __vcpu_write_sys_reg() in
  arch/arm64/kvm/hyp/exception.c for example:

static inline void __vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
{
	if (has_vhe())
		vcpu_write_sys_reg(vcpu, val, reg);
	else
		__vcpu_assign_sys_reg(vcpu, reg, val);
}

Fuad Tabba (4):
  KVM: arm64: Switch reg and val parameter ordering in
    vcpu_write_sys_reg()
  KVM: arm64: Add compile-time type check for register in
    __vcpu_assign_sys_reg()
  KVM: arm64: Add compile-time type check to vcpu_write_sys_reg()
  KVM: arm64: Add compile-time type check for register in
    __vcpu_rmw_sys_reg()

 arch/arm64/include/asm/kvm_emulate.h |  2 +-
 arch/arm64/include/asm/kvm_host.h    | 44 ++++++++++++++++------------
 arch/arm64/kvm/at.c                  |  6 ++--
 arch/arm64/kvm/emulate-nested.c      |  4 +--
 arch/arm64/kvm/hyp/exception.c       | 14 ++++-----
 arch/arm64/kvm/hyp/vhe/switch.c      |  2 +-
 arch/arm64/kvm/inject_fault.c        | 16 +++++-----
 arch/arm64/kvm/nested.c              |  4 +--
 arch/arm64/kvm/pmu-emul.c            |  7 +++--
 arch/arm64/kvm/sys_regs.c            | 16 +++++-----
 arch/arm64/kvm/sys_regs.h            |  2 +-
 11 files changed, 63 insertions(+), 54 deletions(-)


base-commit: dcb6fa37fd7bc9c3d2b066329b0d27dedf8becaa
-- 
2.51.1.838.g19442a804e-goog


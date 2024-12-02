Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1122134AC
	for <kvmarm@lists.linux.dev>; Mon,  2 Dec 2024 15:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733154467; cv=none; b=HQ05JjqmJ3SVBVVpyajx69jGI/EjE2rpOJRUc4x5o6gZPpUUgfvWGBmZ04nNJs/6LkHgB+nHMMvk4WHu7oHi+OuISoIwzqFTRGYJQsvhx7fSfABAgYQ+L8FjqRY3wmMqSMjPTr8a40w/COTO4oE+ECl4iywFsB+BIfZfS266hTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733154467; c=relaxed/simple;
	bh=ME7mrRvr6orJUc+w62J6Go41NvcoUA6lQPRGR+WPF2o=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=nZx5DSiy0Ond83xx4F4NA7IeS7IXVaRi34TyZ3oRPxWv/GiLqWH7iLRmG7RBrSwOLR66yUIDmJecqI8umNwLJGUOQmznC5IPVm0zEI7SBh0R6LfSVDgeRjL6KVFfDNdAuyO9qWAa307aXf3jElxqrhaHH+G+yQ4w9NlT0Xa4Eiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nis2abE/; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nis2abE/"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-434a4ad78a1so36889125e9.0
        for <kvmarm@lists.linux.dev>; Mon, 02 Dec 2024 07:47:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733154464; x=1733759264; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bjiTluSApE4QpRIWQxXVru819UqevJvurrDBEPvS6Xg=;
        b=nis2abE/7TtwTCJDiyQrJp7pDGrpTWWJot6BLClzxMmJF4gwoe+a0vyzion5Ucrpjj
         vOtSIa+U/xN9P88uGBSxln9aTAu/fu2yraGwcPgP02gAM97xO5PeRzRDh7nRDPQ4u4mA
         aP4jl0oB0Uia/uZBKFzts78IHLZBqNK22FOa4mqgFJA16qPmypsYdEeKCIY++EA56NAw
         neXy6DaIWrSM3jkQVsw1+XQCuXnMWm3x/Wy7M/zDZtSLETjWXjj44yQuPXs2We0MHzzj
         S042jkqoIoLpaYnT/pE1ye3G9+3MEWvRzmnbKLUs7B7onfNHfg/Ps67BoCegeO5iFeWr
         ff5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733154464; x=1733759264;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bjiTluSApE4QpRIWQxXVru819UqevJvurrDBEPvS6Xg=;
        b=OnlCSkb+PmbKbrff1LLdwe5rWNn3gikphkOtJBc5HrmTMTrBvABZ5JPJ8DW7yH5Up0
         J3m8W9oQb0KlgKVT7/PFS2dbIFrsKwZxpFO5eige00VjuQmZdeGj8viQbkgMJjR9iQyQ
         eAGpqkj6Dwn0bySma5GXCyHac28gUIhDzABC04F02F77fdPADSFwwfKiPbRUoLBSNGRJ
         otKG+7pew1XSV6fJoY+x9vpQ5qVuo89WBTHnmbMPsqw1mWeg2z4DEfPxPKGfg0EEnmlY
         3J3scoJMaX3VpuuoZ6nCXyOolEEYI4tyna4cm1becXF/CKyta9LIEaVjzdYwRzZT+yF8
         l5Dg==
X-Gm-Message-State: AOJu0Yxw3FsE08FkjflzGQVW4Jwp9W9z6hYG6k0ojKsIOQvPWN7W63/3
	GxcpUPRHObKj5jkJsfoLyQgaHN7HWpo1GSn46MMJvT3MbtSNqNRRDnGoXbKGjDtNpbcCJg8G9jd
	ZpDdDzUe7XeU08Br47A9g+oWdhMsPDJBSbeSQdcvo1/Yb5WS7N3tmYKrwtGpbqQgAHv9JmbI9le
	keCqCrba3M7dd3JlsL9S6yG1QaqCk=
X-Google-Smtp-Source: AGHT+IEehAlIwkgDnoP+30Lh36a78sD7bkaGZ0SiWd8FUwJmEufpy7JTsAy5OUDRqnNYsOnPWSsAGjex6g==
X-Received: from wmbf1.prod.google.com ([2002:a05:600c:5941:b0:434:a5c2:2758])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4fc9:b0:434:a6af:79f6
 with SMTP id 5b1f17b1804b1-434a9dc7074mr226167815e9.15.1733154464069; Mon, 02
 Dec 2024 07:47:44 -0800 (PST)
Date: Mon,  2 Dec 2024 15:47:27 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241202154742.3611749-1-tabba@google.com>
Subject: [PATCH v4 00/14] KVM: arm64: Rework guest VM fixed feature handling
 and trapping in pKVM
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	qperret@google.com, kristina.martsenko@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Changes from v3 (Marc):
- Reduce churn from patch reworking SVE checks
- Fold in vcpu config flag renumbering patch

This patch series redoes how fixed features for protected guests
are specified in pKVM, as well as how trapping is handled based
on the features available for the VM. It also fixes a couple of
existing bugs in the process.

For protected VMs, some features should be trapped if the guest
tries to use them because they are not supported (e.g., SME), or
if they are not enabled for the particular VM (e.g., SVE).

Initially, pKVM took the approach of specifying these features
using macros and grouping their handling by feature id register.
This proved to be difficult to maintainbug prone. Moreover, since
the nested virt work there is a framework in KVM for storing
feature id register values per vm, as well as how to handle traps
based on these values.

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

[1] https://lore.kernel.org/all/20241128123515.1709777-1-tabba@google.com/
[2] https://lore.kernel.org/all/20241018074833.2563674-1-tabba@google.com/

Fuad Tabba (14):
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

 arch/arm64/include/asm/kvm_arm.h              |   2 +-
 arch/arm64/include/asm/kvm_emulate.h          |  29 +-
 arch/arm64/include/asm/kvm_host.h             |  25 +-
 arch/arm64/include/asm/kvm_pkvm.h             |  25 ++
 arch/arm64/kvm/arm.c                          |  30 +-
 .../arm64/kvm/hyp/include/nvhe/fixed_config.h | 223 ----------
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |   5 +
 arch/arm64/kvm/hyp/nvhe/pkvm.c                | 335 +++++----------
 arch/arm64/kvm/hyp/nvhe/setup.c               |   1 -
 arch/arm64/kvm/hyp/nvhe/switch.c              |  52 ++-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c            | 402 ++++++++++--------
 arch/arm64/kvm/reset.c                        |   6 +-
 12 files changed, 435 insertions(+), 700 deletions(-)
 delete mode 100644 arch/arm64/kvm/hyp/include/nvhe/fixed_config.h


base-commit: 60ad25e14ab5a4e56c8bf7f7d6846eacb9cd53df
-- 
2.47.0.338.g60cca15819-goog


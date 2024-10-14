Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA698156676
	for <kvmarm@lists.linux.dev>; Mon, 14 Oct 2024 10:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728901459; cv=none; b=gOFyA6XcNl/OOUs7znepR5fLfK/63gnqieb72AaS9C7oEBvLfejwPLOEl5Zar90jKrEr2nW633nndmP3FRig1NoFhBKbZVzc8siiV0h4uBGaq4R5wQ+wxjAe9OoOE40HAL9l8bGhVncobwXB48zMdDlzz9GKYta6y75dyMuvJpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728901459; c=relaxed/simple;
	bh=k+cIoTw4AjYMBRQI25BH32jgec6i4oQllPHohlP2IVI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=rppHpO5DlXlfSxuyfBWrdAoQmxdOOumxCRbaylhPOQpK2dn/OxaoIT9z+5n4jLR2K8IuVwJuS7TQpS4DkanvGWZDK9cIjy9HWYYNOMbMkDrt+hffWwB0FSYUxA6izIGIO825jDs3l7gwSLsa2ajZgZ8AlPYwkrY0FeDeK6jVbs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=baXYboYQ; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="baXYboYQ"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e2946a143efso1315342276.1
        for <kvmarm@lists.linux.dev>; Mon, 14 Oct 2024 03:24:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728901456; x=1729506256; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8k2idgPYUza+mPX/Cnkz7zCa4DRegqLGNpcbrNa5L1s=;
        b=baXYboYQFigk8uFIeP1p+/2f2oXsn7jPrNTpDCNC0dE/ytcmRrzylZ82S/yKAN4SWU
         WSxYYb8HTnV0bypjKhjXUkXynF4izNa9TxCf+mrpdwG2q/EE3zx63nLFix0M4xWXhEVm
         qJc0G6Dbd5pA2fW1YLtOsvyLGDH/UOJYQH06qFX4xuPhP9s4WnE/VpmJRFYTmdcy5mMH
         QnIy+fRxaVbhpmD99HmdSqu2UuUrgrTHBqpvA+LIGrpJhCQpPu3SBJ1xW7nD35efp9+k
         Kv9zKFFHIZCyNk3HZbJ9RYAVeemd386+GOWx9V3h6YDScDZ15xJGQXvZxI6CTtYr9XSB
         aKVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728901456; x=1729506256;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8k2idgPYUza+mPX/Cnkz7zCa4DRegqLGNpcbrNa5L1s=;
        b=r42zXGe+lvaNKFVUL6iwRKmcpig+t61pDPWHANwdSHIekLJJqhsf0SJZXTeH7sTWhx
         hsnxY7Hn9BiN5bv6YIHzKJ1/f8CrQ4ZxLeD4oONlOZpNHWZR93YmxVQBGVXf5x75dJh4
         iX7laTy8Acd7GCM6pZfrTPX7mHIv0V59xFuWzT/ELmI8GF3Q6kChMbKnj2ZxLWy1K5VN
         tS+89KyOGlOawLYNqfuv1yduciAz6Jzbmpa/KzITrjqiNj6V0Lmj4F2TqqMhkdTtQEoi
         9AvAy8XF72nlD2qmfMNWu6S6WvVntvK+qrRwd2DGnbTHZv/UliOjy+RCZhQpdpLPdMU/
         ZswQ==
X-Gm-Message-State: AOJu0YxaE8vsb7mQj0Zdor57YOX5lLxfnYccyIdVcGMIADS6TN4JSZCs
	mLNIaPW5hIre+PUvJ60/o4p3gpRUT/RutukBQfFVzn++6p4RcDfvcy+oYEMQ8BfSkDVdry97s54
	myJE0kaoNShIzK5G/zqMAxPLCFqdlwGPnWmHBGBR34JwKLgiTqNKEjU363QxlwhFcTs4Tk7GGFk
	psnEa1iX0/7B1WZePcf2AWvYdX4jk=
X-Google-Smtp-Source: AGHT+IEYMMe5UqXSHlbyzhtM6fqu85YUpP5e468FK0ht0vpvc8Zo0di7afXpMFSYc9NPvsIRkHsL5u6CeA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a25:dd06:0:b0:e28:fdd7:bb27 with SMTP id
 3f1490d57ef6-e290b89e3e2mr145012276.3.1728901454943; Mon, 14 Oct 2024
 03:24:14 -0700 (PDT)
Date: Mon, 14 Oct 2024 11:24:08 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241014102413.4092725-1-tabba@google.com>
Subject: [PATCH v1 0/4] KVM: arm64: Fix initialization of trap register values
 in pKVM
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, catalin.marinas@arm.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	will@kernel.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The patch that dropped PAuth instruction/key traps [1] did not
apply to non-protected VMs in protected mode, since as noted [2],
the hypervisor is supposed to handle trap register values in
pKVM. However, in pKVM upstream code the hypervisor does not set
all necessary trap register values in protected mode, and running
non-protected VMs with PAuth enabled in pKVM has been broken
since then [1].

This patch series lets the hypervisor initialize the values of
trap registers for both non-protected and protected VMs,
including setting PAuth traps depending on whether PAuth is
available in the system and configured for the target VCPU.

Based on Linux 6.12-rc3 (8e929cb546ee).

Cheers,
/fuad

[1] Commit 814ad8f96e92 ("KVM: arm64: Drop trapping of PAuth instructions/keys")
[2] Commit 7e814a20f6da ("KVM: arm64: Tidying up PAuth code in KVM")

Fuad Tabba (4):
  KVM: arm64: Move pkvm_vcpu_init_traps() to init_pkvm_hyp_vcpu()
  KVM: arm64: Refactor kvm_vcpu_enable_ptrauth() for hyp use
  KVM: arm64: Initialize the hypervisor's VM state at EL2
  KVM: arm64: Initialize trap register values in hyp in pKVM

 arch/arm64/include/asm/kvm_asm.h              |   1 -
 arch/arm64/include/asm/kvm_emulate.h          |   4 +
 arch/arm64/kvm/arm.c                          |   8 --
 .../arm64/kvm/hyp/include/nvhe/trap_handler.h |   2 -
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  12 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                | 116 +++++++++++++++++-
 arch/arm64/kvm/reset.c                        |   5 -
 7 files changed, 122 insertions(+), 26 deletions(-)


base-commit: 8e929cb546ee42c9a61d24fae60605e9e3192354
-- 
2.47.0.rc1.288.g06298d1525-goog


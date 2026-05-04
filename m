Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A64384253
	for <kvmarm@lists.linux.dev>; Mon,  4 May 2026 22:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777934551; cv=none; b=mVCBkwc0SmapEoctb92f1Y6yrDVTXU34yYUsUWi2DY4HZCXh3LwZBmH5jF76Pzy5clefu8TrS9K6hQzRfYHRSOpRhVRxGUVCIUA/R8GZboa8Y8OGvfPnOcU7B9flnbE9FYBs+2vIwZ9ClsNBejFHKknf/XIpV4e41kbfBW7VMfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777934551; c=relaxed/simple;
	bh=a6LAKe8ovUnasAZFDeUefPCWvqT60LXkBEdqdXAd5Mc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=mkg+XGhMtCL8Ga5dqr+X5y0hSk72xm94ord0QYwTXukf66gTwD9gJpvxpH6haDuzZGo5tBCrkyqSUeswiOrgZTRT9vxhJTBGiaj7+o29SMOJpPMPT3y3H0JRM/lkgjVhHBUG31F6vExTfs7xmM1hqbfko9hxAWKv93/7txTPbG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ksdeilwo; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ksdeilwo"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-835417ba8c8so810589b3a.0
        for <kvmarm@lists.linux.dev>; Mon, 04 May 2026 15:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777934549; x=1778539349; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=GreUyu/PwGDkwAAEFHxYx5rSO95cp1lrcmL4UWkbrcg=;
        b=Ksdeilwo7cv78EhIaBwBWS8c8eNJ/Jf6+621JiOxZVPZT3i4yoE+zw37UqCtwgChyi
         breODgqsmDdVM9wm7lkGkG5OQGM6h0pCBTl231ogKF166cZdkyRLAV4c+q4AG9YLvooQ
         XDCGD+N0hMSkiQ/SCaV9/icjonMw64Xa9jpQqHq8M4Fe1K940a0GBNmhCF+V3Dq0aV9v
         eogo5UpZ5oDiI1IF5l/QHMCUHmZx+jCguPz3hHyV4mmhGOpLS/X364sXDgcBmwEoJzJd
         aN+X1yALR7wYmg6qqBmXqDeRUwqxvwdUqUuDgy4H/3HGT2S9PG2i0nSI+qlE0nlrTSpg
         IIRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777934549; x=1778539349;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GreUyu/PwGDkwAAEFHxYx5rSO95cp1lrcmL4UWkbrcg=;
        b=rOzVnYG08nqtZvZuWIVituJ9gJYjI/ReJr4WhtlKXCtLgKsJg6BBC9WF1Qa7qVbK10
         xDYW9EHn1ygWETJooi2QEQh3v5XGm07fvo5i3wFNHB+NnF7Ns05Eom8o9niYzawAOHVa
         CwDtUVwfSaZWZ0aYjWU+gklwbnUpYMkmvmXEeIN0jaA5s7gD2a0M2IGCOWgp0XsihlA2
         UszlzP9EwvgVnu5APXX/dV2e1YzDheKdqBacAsPDfP5+2hSvUaaDv/K/JH3SIPPMGgnN
         L137Iq+oQTkGuu5/xxLpPbrKDeHN7HEgl+65mye1HHpQuLd7qAsBvhY981gdyenFrAhG
         eVmw==
X-Forwarded-Encrypted: i=1; AFNElJ/mdemsfCHMGWWqhH98PMYAkT4pTvmvUVrba1P+gC+1dBSa58Y8kNRs3N6XJRGb8A0pHEyfog8=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywx926QaNTHbj2XkLj12ji6BYi2vWNnuxNcEBiLi0lmj9EucNBw
	ieVEADUARFCSLhyde0dch4nSMG6PfW/pEla4b2U9yAKo2JxZ5O1/AimVpBFSi/FE6MUVDi+f8Y7
	HD3qeUjCsXDI8yTVEJpv0Rw==
X-Received: from pfbhm13.prod.google.com ([2002:a05:6a00:670d:b0:82f:7bc:70a9])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:4c96:b0:82c:ded1:261f with SMTP id d2e1a72fcca58-8352d22c289mr10958941b3a.27.1777934549232;
 Mon, 04 May 2026 15:42:29 -0700 (PDT)
Date: Mon,  4 May 2026 22:42:07 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260504224213.1049426-1-jthoughton@google.com>
Subject: [PATCH 0/5] KVM: Fix race conditions in kvm_arch_flush_shadow_all()
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Sean Christopherson <seanjc@google.com>, Gavin Shan <gshan@redhat.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, James Hogan <jhogan@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi Paolo,

syzbot running on Google production kernels ran into a double-free on
KVM/arm64 in kvm_mmu_free_memory_cache(). It turns out that loongarch
and mips also have a similar problem.

kvm_arch_flush_shadow_all() can be called on the same memslot
concurrently, leading to double-freeing in arm64 and mips. loongarch
is also affected: it can at least underflow some counters; I'm not sure
what else can break.

To get into this scenario, we need to have a process (P1) share an open
VM with another process (P2). If P1 closes its VM to leave P2 holding
the last reference, then there is a race between P1 exiting (exit_mm)
and P2 dropping its last reference to the VM.

exit_mm() and kvm_vm_release() both call kvm_mmu_notifier_release() on
the same KVM, and the only locks held are the KVM srcu lock and the MMU
notifier srcu lock.

Please see the arm64 patch for another description of the same race with
more context on the ensuing double-free in KVM/arm64.

The first three patches fix each broken architecture; each of those
patches have stable CCed with what I think are the appropriate Fixes.

After patching the locking for the broken architectures, it seems better
simply to have KVM take the MMU lock exclusively before calling
kvm_arch_flush_shadow_all() so that architectures don't need to worry
about it. Feel free to drop that patch, the fourth one, if you disagree
with it.

The fifth patch provides a repro (with a crude kernel patch to reliably
demonstrate the double-free). Please do not merge this.

The arm64 patch has been tested with the repro. The loongarch and mips
patches have been compile-tested only.

kvm_arch_guest_memory_reclaimed() is only implemented by one
architecture: x86. Its implementation does not need the KVM MMU lock to
be held.

This series is based on 7.1-rc2.

James Houghton (5):
  KVM: arm64: Grab KVM MMU write lock in kvm_arch_flush_shadow_all()
  KVM: loongarch: Grab MMU lock in kvm_arch_flush_shadow_all()
  KVM: mips: Grab MMU lock in kvm_arch_flush_shadow_all()
  KVM: Hold MMU lock exclusively when calling
    kvm_arch_flush_shadow_all()
  DO NOT MERGE: KVM: selftests: Reproducer for arm64 double-free

 arch/arm64/include/asm/kvm_host.h             |   1 +
 arch/arm64/include/asm/kvm_mmu.h              |   1 +
 arch/arm64/kvm/mmu.c                          |  39 +++++-
 arch/arm64/kvm/nested.c                       |   4 +-
 arch/loongarch/kvm/mmu.c                      |   2 +
 arch/mips/kvm/mips.c                          |   2 +
 arch/mips/kvm/mmu.c                           |   2 +
 arch/riscv/kvm/mmu.c                          |   4 +-
 arch/riscv/kvm/vm.c                           |   2 +
 arch/x86/kvm/mmu/mmu.c                        |   4 +-
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../testing/selftests/kvm/transfer_fd_test.c  | 129 ++++++++++++++++++
 virt/kvm/kvm_main.c                           |   3 +
 13 files changed, 184 insertions(+), 10 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/transfer_fd_test.c

base-commit: 6d35786de28116ecf78797a62b84e6bf3c45aa5a
-- 
2.54.0.545.g6539524ca2-goog


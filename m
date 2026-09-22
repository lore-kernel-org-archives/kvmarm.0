Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7AF9545D9A
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 13:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790082509; cv=none; b=S8GLmW3++s5phmH7d9xnhG+VcsEEKZhui4oLLCKJAiI7cE0egEu02U4FaNdvA3FpWFY6PHPJTUV3vV+l8Evc/HcN47WWwGdcVfbRMV0+Tu2VAQRDBghkRgfbGUqSwuDDlaeQZNmNWFS31rB7RwSRL3H7Oag583DZB4Y3Sl59Nx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790082509; c=relaxed/simple;
	bh=DJGEjAkbqRq6VN709DgCul86Vg0kk1bVBI8TH3PU9yw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=NqKfGLXTiiORnCuitVm22dTQ5i17IH8hkzfi6WEGNuZjA/51q/pg/hI98k/ptShX8fZxy3L2nfgkkKzbph3aV4VMUITERFAIb3gAfK6xXaBAbDgQomHXX3Rp5BkxXfkdyMdjeKugDnNSOauZxWRghbtUf1W5v2ARDrOrAY23OyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c2R+f9HH; arc=none smtp.client-ip=209.85.221.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c2R+f9HH"
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-4870af30a85so640300f8f.1
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 06:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790082506; x=1790687306; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ilx8e+rSH9u6ZnDUv38L7O/GoBWQdLqlZUaHwlvmxkY=;
        b=c2R+f9HHz41c3w/FK8AIB70eK/tebueqjy463B9Bo18NYp2lyoqUYwJmTXuATuNRbK
         S1Lx4LxS9D7hwyZLRsfnTFUaKztBr3pLSi3OjfsSuB+lXRZX/PNN+ITrD/cfV0wur1E+
         4781IBHu0+lNbskEBTPc5Lvg0frC+Iu9v/Av1tdyLF7xhwvPwo0/58qU+cnX4QfWtrAa
         Nw84p2yamKn18gAXh1UDGYzDFwU8T3pn4C9SaSEG4IbCxE/I4okGXXpu6R+iVzTfl+jF
         5RPMr9AQf438ugHfrixefEJCbDr/vzR4sk4wlHCNLtKKSR1pUD1qWcf4nTgNA5MeE8Eb
         VBWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790082506; x=1790687306;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ilx8e+rSH9u6ZnDUv38L7O/GoBWQdLqlZUaHwlvmxkY=;
        b=aNo4scMwk6aci1HcWzq4qfefcNl3o7o1bIFSX65xTlLGrMt73nyxCZ/1GJ3W4qY+wC
         VzCgXLnF6Mq4YX6qr7nVOYqxBPcO5KNw2S0nEGTMczveSn6orCAxT1UetMHJlKPvijv2
         gVhTE+tXXn817pugfx87tpzPSvw+rate9jcfjdn94Q4cmJSm6f4QWCDpKxg/Vm9m0PQ/
         2FIRgdUPIIAPUushvcZ18KDkQYJumSBap2sku5n0oo8/KQAXl/T6UvihuA0xzc/kGX6y
         X+3JlqYr9LyXUzQRd1wxoS4TTwJgwGK/v5enYfRTiTo8rSp9p94PCvte/9Z/lWl7sOgt
         4XGw==
X-Forwarded-Encrypted: i=1; AKwUvBxqyoknYXaXjju+hDu3TLR4Y46PN0nFj2ga5Q36LL1EorZYC/5wE0cI4Haczlh5YqRVYAcNx8M=@lists.linux.dev
X-Gm-Message-State: AFuF++nMZKOV4yuangxXQ1X36ZHirTJBQHgZiPfWg5/nS4iuwBs4J6XI
	+YrvlU2DA8dJKmPSOa60h/tUSOf3WI4EZgkyYie7GGJ9UadLJvtDTxeB4GgA9uGwG8aZ44R36HO
	5FadHtj4VC+qXJTu4405hEw==
X-Received: from wrwu1.prod.google.com ([2002:a5d:6ac1:0:b0:488:3cea:199f])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:420d:b0:484:361a:1c7b with SMTP id ffacd0b85a97d-48860f8a582mr4928028f8f.7.1790082505714;
 Tue, 22 Sep 2026 06:08:25 -0700 (PDT)
Date: Tue, 22 Sep 2026 14:08:15 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260922130821.1666713-1-vdonnefort@google.com>
Subject: [PATCH v1 0/6] Fix guest_memfd and protected VMs on systems with
 pages larger than 4K
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

This series allows booting protected VMs and guest_memfd-back VMs on
systems with a page size larger than 4K.

Currently, the fault handling assumes 4K alignment, as HPFAR_EL2
provides the IPA minus the bottom 12 bits regardless of the system page
size. This leads to mapping failures on 16K and 64K systems.

This series addresses the alignment mismatch by relying on struct
kvm_s2_fault_vma_info in both gmem_abort() and pkvm_mem_abort() to
retrieve correctly page-aligned addresses.

This series bundles the following previously discussed fixes:

 1. https://lore.kernel.org/all/20260915091606.2111217-1-vdonnefort@google.com
 2. https://lore.kernel.org/all/20260915084438.2076072-1-vdonnefort@google.com

Fuad Tabba (2):
  KVM: arm64: Move gmem_abort()
  KVM: arm64: Use kvm_s2_fault_vma_info in gmem_abort()

Vincent Donnefort (4):
  KVM: arm64: Fix MMFR0 TGRAN advertisement for pVMs
  KVM: arm64: Pass kvm_s2_fault_desc to
    fault_supports_stage2_huge_mapping()
  KVM: arm64: Move pkvm_mem_abort()
  KVM: arm64: Use kvm_s2_fault_vma_info in pkvm_mem_abort()

 arch/arm64/kvm/hyp/nvhe/sys_regs.c |   3 +
 arch/arm64/kvm/mmu.c               | 357 +++++++++++++++--------------
 arch/arm64/kvm/pkvm.c              |   3 +
 3 files changed, 186 insertions(+), 177 deletions(-)


base-commit: 93f51579e7df248780214094418f205253383cc5
-- 
2.55.0.1082.g2b9226bbc0-goog


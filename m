Received: from mail-ot1-f73.google.com (mail-ot1-f73.google.com [209.85.210.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0437D384258
	for <kvmarm@lists.linux.dev>; Wed,  8 Jul 2026 22:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783551131; cv=none; b=Qbpn+wjZA5hiimj1fcbdHJvSi8gsFsnnjcliiOfEFGZm20NVd3WRjXb91OBUcjSe8jdn6jPMwI1Su3YU7t6E2KV1nruYnaseq7lLuVWZ7IeuW9Yfr5bE/ZF/w92/0vc5La4pkmkghLfwlXIlZF73RiA3UNZ/mQvTogLa+KbxD/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783551131; c=relaxed/simple;
	bh=W9eRCyxeQaxWVre9xRAxVREG5IbAzd3SpzWk9523/DY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=tMHgeLtY0f3OS/geoTXThxT4+69DEQ2VL8k7/xdggxaahuVByNipnFWFo5fJ3hBqbws3jX1srI2OX58IgbX40Klg45Pld0tp8QTQKr7gDkxf4DRz/D0tBSvBlzegRJlFgQDmnfEcTQ/uEhK8DWWBo6k9Q98u5AKRqYi/20Havks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Oyt5CJ8l; arc=none smtp.client-ip=209.85.210.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Oyt5CJ8l"
Received: by mail-ot1-f73.google.com with SMTP id 46e09a7af769-7e9e2db9914so392525a34.1
        for <kvmarm@lists.linux.dev>; Wed, 08 Jul 2026 15:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783551128; x=1784155928; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VXjaTRbhjgdEqS1UyFYRJTvGMmWZaq4i6pqgK3sf76s=;
        b=Oyt5CJ8lGoO1AXqQCYz4+uIaL9t276MW0pL/063LRHsnAh6RnIKfgLj+X2241rYCPl
         ppfv4iQZZbjZRcmKIrk7yL2gvz9awgR2FnAGt7t8eKSSbN1+wjFd7fothvOV3EgmN/vn
         NxOyCC5tfxiSoHZbw+zIm/XtYQIKnRXSurXmo/JR4FgnF26fxHP8F7sgse7fcIM2vkO3
         PnlzVpY74SZwveZ3j5VuW8gJe3XIEL495iLodKKoAJ8njuJLKx86Z1z+OiyuzW/bYfYo
         FkKKa1KYrEHNxQGE+DLAdP+jcctLqYcT8qxz+eWOixLi+iMLyxDwo2s26xsXNdVGG6MM
         xJuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783551128; x=1784155928;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VXjaTRbhjgdEqS1UyFYRJTvGMmWZaq4i6pqgK3sf76s=;
        b=NlPfiOwatHCwEExzRss7nCWbEaRyDZr1R1YxXvkv63N7i1GkSZlkRDXHp7rJlAzb4h
         8alK1LaxuxrDf1GR6MM+pHKjNnG2gMaTybCrONP0tWVG1ebc8cNkSp8A35hkeL+H3VE9
         S7fuqlbDFmuvHSVpYfBTR0NrwITM61Qh5AEL2iodkzOXUI65TQ84iqtsCk8v0ZF7uv4j
         u8m7PhpNOcFDaYBos3/NDnGQv+xKCxrNs9JVGbiTqUDk4iqAiZwL/dhBAWkja9a+lKUZ
         u2L+biyCwinHNd76TCXZRx6IN2BVWKeD82TlzUYNcKchzMa8cb90TCI5yF6tDtyQadFp
         wBNw==
X-Forwarded-Encrypted: i=1; AFNElJ+6OPNDJWtaNquHdYakxLofkXIxHlHJbZ+SC8eCqAxo7ljm0ABwZV2lNyrifCY77fU6jVJiLjg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw8uavhSa6gQUewbY3My5ULgpOKFVanfNP2vWwOvdTasWviRZo2
	unymibRnQ8dd6K/mrNdGvAk4NZWhYhHBkqhi6ORqqAjgAZapu2KEznEyPfaEPBbR0vk69VMZuuZ
	URElweFNVcNDju9sU9OcfEWkMJg==
X-Received: from ilsl6.prod.google.com ([2002:a05:6e02:5c6:b0:502:20e8:e7ce])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:2209:b0:6a3:7d5a:1ae0 with SMTP id 006d021491bc7-6a37d9d6e0amr220936eaf.29.1783551127438;
 Wed, 08 Jul 2026 15:52:07 -0700 (PDT)
Date: Wed,  8 Jul 2026 22:51:18 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260708225124.4130846-1-coltonlewis@google.com>
Subject: [PATCH 6.6 v2 0/6] arm64: KVM: Backport VHE-only boot fixes
From: Colton Lewis <coltonlewis@google.com>
To: stable@vger.kernel.org
Cc: oliver.upton@linux.dev, sashal@kernel.org, gregkh@linuxfoundation.org, 
	mizhang@google.com, catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	mark.rutland@arm.com, ahmed.genidi@arm.com, leo.yan@arm.com, 
	miguel.luis@oracle.com, dbrazdil@google.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Architectural updates retroactively made FEAT_E2H0 optional, meaning
hardware can implement FEAT_VHE without FEAT_E2H0. On such CPUs,
HCR_EL2.E2H can reset to an unknown state and must be initialized early
so later code can reliably detect whether E2H mode is active.

Without these fixes, booting 6.6.y as a guest under KVM nested
virtualization will hang at boot.

This series targets 6.6.y specifically because these patches are all
present in 6.12.y and applying these patches to 6.1.y and presumably
older kernels has more conflicts and results in other issues booting
as a guest under nested virtualization. More work is needed to enable
that.

Changes in v2:
- Updated commit messages to reference correct upstream SHA1s.
- Preserved inline EL2 state initialization in Patch 4 to avoid
  unrelated code churn.
- Added upstream commit 3855a7b91d42 ("KVM: arm64: Initialize SCTLR_EL1 in
  __kvm_hyp_init_cpu()") as Patch 5.
- Verified boot and KVM initialization across all KVM execution modes
  (nVHE, hVHE/nested, VHE, and protected).

v1:
https://lore.kernel.org/kvmarm/20260701204342.2654385-1-coltonlewis@google.com/

Ahmed Genidi (1):
  KVM: arm64: Initialize SCTLR_EL1 in __kvm_hyp_init_cpu()

Marc Zyngier (4):
  arm64: sysreg: Add layout for ID_AA64MMFR4_EL1
  arm64: Treat HCR_EL2.E2H as RES1 when ID_AA64MMFR4_EL1.E2H0 is
    negative
  arm64: Fix early handling of FEAT_E2H0 not being implemented
  arm64: Revamp HCR_EL2.E2H RES1 detection

Mark Rutland (1):
  KVM: arm64: Initialize HCR_EL2.E2H early

 arch/arm64/include/asm/el2_setup.h   | 56 ++++++++++++++++++++++++++--
 arch/arm64/kernel/head.S             | 20 ++++------
 arch/arm64/kvm/hyp/nvhe/hyp-init.S   |  3 +-
 arch/arm64/kvm/hyp/nvhe/psci-relay.c |  3 ++
 arch/arm64/tools/sysreg              | 37 ++++++++++++++++++
 5 files changed, 101 insertions(+), 18 deletions(-)


base-commit: da47cbc254661aa66d61ef061485a7080305c4be
--
2.55.0.795.g602f6c329a-goog

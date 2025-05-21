Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81218265614
	for <kvmarm@lists.linux.dev>; Wed, 21 May 2025 12:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747831866; cv=none; b=qyNaWG72gKKSm3ADQ/0u/7w93j7yZ3jeYFh9aij3yFz/uyRlmJaZfflEpsBz3Wm1/lnh9ixifEFpRurXnF0QYoVDcMTP4VoG5mOl//bxO0C95L7Cfn4wxMOVixad+luRQJqSxlV+oaam/RnjCVHTuhEV85aBOlWN7tFf3+T3Eqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747831866; c=relaxed/simple;
	bh=dZS75bhksG3hhRNNHThAj2ycKgyCKwT1pEGoFt5HQH8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=XbL8lDNnScGyqLi2w0oQk6cWz8vLqKTz4Y5SUw+2iUXkMWtUiI96svCq57jmDuQAQnI0XCAMFtB9vIIlTq3fP60VqPCH5Y3/Hlc+O/LMwXfdNU8/+KardHPA0Ml/gZsdr4PdRqZEWEpXUIJLLRZQCi1g6N4K12Gt/VMAcjBtip8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mgnpKFwz; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mgnpKFwz"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43cf446681cso41451155e9.1
        for <kvmarm@lists.linux.dev>; Wed, 21 May 2025 05:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747831863; x=1748436663; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5uHy+p8xiNatJ/qO1mRfpamxzCqJKlhzt7Hc5Lu76pY=;
        b=mgnpKFwzfXUemLL9MIZyfEpkFjgMIC7LiPrh91GnAuED4O03jtblsDLdOTe4Q6Q5Lc
         PSDWeD0hytmGmJDbDmatE5RiJOpntQCEB+PXSinhXOm0PRU+4WBuPy53wk5Mdlkc61yr
         y00DXCJHjEAO8MKWSXnoKYbdnkK0pSSS3vwvFbjuvK7ntIxKOiln7+N9P+Bqg4UZMBLF
         RM1d70WhCKRfi9TTyDG94GetVSDmv0vgtxpBbv89Oi0OMVfkBIFvtMuCOVlgehLIsOMS
         HFEvFoDpNg1WkWZKbcKjXDiaRpDOebX457xHajO7DE9Z5K+8XofsUm1q5uMi2Rk/WbgF
         2F4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747831863; x=1748436663;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5uHy+p8xiNatJ/qO1mRfpamxzCqJKlhzt7Hc5Lu76pY=;
        b=QQiE2cF0o7yPUCDVWcjfDq27F4nRFtMj1nXd7KqKfhWBmmSXLVUpBu7dD/LyzNiwxC
         0Xtct+HA50EH6rQWEGKV3awGd2tKFOmAugvFwvrB8jAlDw/gVbM1XazO4AaW/SNumO+Z
         t5uDMyqcLDFr9tnOx+5j66Ug2QF64Xx2NHBURM5vVGaejuIav8x4eg+9RwmKze0TmCpw
         Hctk/hYpRUCvKaTrctrfqdUQ/qPAfFmebqSeKO5bTD8Ilwqjg/gh6rzIflxETpSpfgk8
         bTddv7Y5G43qEOfx6gWZaxVHs3mKzO7e/OPCKWOk9z53Ki4LHUFmMcnGCKs6t8VYs9VI
         F+Ow==
X-Forwarded-Encrypted: i=1; AJvYcCVaJTPLPYEou+7yPEgh8KIuxWn4XwYzMJcVU5tcsj3YoQk5kQcuSMP/8Pfx7IZFGFrr5G/zOfU=@lists.linux.dev
X-Gm-Message-State: AOJu0YxvimIbXCSlNzERV8rPg0+gTUWY9HjkhfRIja/vxHnSFF+TMeXy
	MfoyXV3CPnrq9IvzubkOyjgalUycrYWA2jcAIFOShG/iuRzwTWDaDsiRaFO+O7t1uMj8k/3JgG0
	ldzVrLjcikMmeOjargpy2SA==
X-Google-Smtp-Source: AGHT+IHRjNo/bemvwuTLbGZUJ+I0Cd/WKzDQzqP3NrChiAI6QmaNpGURgsbvUPlh98wyTVdHdymBU2R9bWaHgD8h
X-Received: from wmbay39.prod.google.com ([2002:a05:600c:1e27:b0:43d:1ef1:b314])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a418:b0:445:1984:247d with SMTP id 5b1f17b1804b1-445198427a1mr118512565e9.7.1747831862985;
 Wed, 21 May 2025 05:51:02 -0700 (PDT)
Date: Wed, 21 May 2025 13:48:24 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.1112.g889b7c5bd8-goog
Message-ID: <20250521124834.1070650-1-vdonnefort@google.com>
Subject: [PATCH v6 00/10] Stage-2 huge mappings for pKVM np-guests
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: qperret@google.com, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kernel-team@android.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi all,

This series adds support for stage-2 huge mappings (PMD_SIZE) to pKVM
np-guests, that is installing PMD-level mappings in the stage-2,
whenever the stage-1 is backed by either Hugetlbfs or THPs.

The last patch of that series is an optimization for CMOs using a shared
PMD_SIZE fixmap.

Changes since v5 (https://lore.kernel.org/all/20250520085201.3059786-1-vdonnefort@google.com/)

  - Fix fixblock_map usage. It should only be used on PMD_SIZE aligned addresses. (Marc)

Changes since v4 (https://lore.kernel.org/all/20250509131706.2336138-1-vdonnefort@google.com/)

  - Make guest CMO functions working with any input (Marc)
  - Improve for_each_hyp_page() and fold struct hyp_page declaration
    (Marc)
  - in mem_protect.c "PMD_SIZE" replaced with kvm_granule_size(KVM_PGTABLE_LAST_LEVEL - 1)
    (Marc)
  - Remove useless guest pgtable callback force_pte (Marc)
  - Fixblock functions fallsback on fixmap on 64KiB pages systems.
    (Marc)

Changes since v3 (https://lore.kernel.org/all/20250407082706.1239603-1-vdonnefort@google.com/)

  - Rebase on kvmarm/next

Changes since v2 (https://lore.kernel.org/all/20250306110038.3733649-1-vdonnefort@google.com/)

  - Fix PUD_SIZE -> PMD_SIZE enforcement (Quentin)
  - Rework pkvm_host_share_guest() to remove one hyp_page walk (Quentin)
  - Remove one pgtable walk into __check_host_shared_guest() (Quentin)
  - Return EBUSY on host_share_guest_count overflow

Changes since v1 (https://lore.kernel.org/all/20250228102530.1229089-1-vdonnefort@google.com/)

  - WARN_ON() on !PAGE_ALIGNED size for guest CMOs (Quentin)
  - check_range_allowed_memory() before accessing the Vmemmap (Quentin)

Quentin Perret (2):
  KVM: arm64: Convert pkvm_mappings to interval tree
  KVM: arm64: Add a range to pkvm_mappings

Vincent Donnefort (8):
  KVM: arm64: Handle huge mappings for np-guest CMOs
  KVM: arm64: Introduce for_each_hyp_page
  KVM: arm64: Add a range to __pkvm_host_share_guest()
  KVM: arm64: Add a range to __pkvm_host_unshare_guest()
  KVM: arm64: Add a range to __pkvm_host_wrprotect_guest()
  KVM: arm64: Add a range to __pkvm_host_test_clear_young_guest()
  KVM: arm64: Stage-2 huge mappings for np-guests
  KVM: arm64: np-guest CMOs with PMD_SIZE fixmap

 arch/arm64/include/asm/kvm_pgtable.h          |   7 +-
 arch/arm64/include/asm/kvm_pkvm.h             |   2 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   8 +-
 arch/arm64/kvm/hyp/include/nvhe/memory.h      |  16 +-
 arch/arm64/kvm/hyp/include/nvhe/mm.h          |   4 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  16 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 264 +++++++++++-------
 arch/arm64/kvm/hyp/nvhe/mm.c                  |  97 ++++++-
 arch/arm64/kvm/hyp/nvhe/setup.c               |  15 +-
 arch/arm64/kvm/hyp/pgtable.c                  |   6 -
 arch/arm64/kvm/mmu.c                          |   6 +-
 arch/arm64/kvm/pkvm.c                         | 129 ++++-----
 12 files changed, 365 insertions(+), 205 deletions(-)


base-commit: 52a62c117afb9ec3484a4d2fd6d0c4caff754c5b
-- 
2.49.0.1112.g889b7c5bd8-goog


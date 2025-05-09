Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC81290BBE
	for <kvmarm@lists.linux.dev>; Fri,  9 May 2025 13:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746796634; cv=none; b=eVMpLOzbpo0wuBdUeji0zv5GeXd6snraSXTLXpblZqI5+zyiV3PEgWP2k6ByReN+Kf98fmn4txm7u8vIkYA0XW+6RakZIS2yjL9MSQkPs/sTfNdCqKiAHRRzFT/uE3/h5yofhn7YWxPlMl9gLg0oIcmK9bYRn07un3o8QwaX4WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746796634; c=relaxed/simple;
	bh=B0zHJx0l5Xb8WBxT0akPWMO2vZgmXim5DcgNC6Ar/5A=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=YXcMJuRycU4mpokBiwVq29KQZsoWVDO243+5yrrB4yddjjZXo96E0VOB2j6v9ncVHxClHwlIvO0VMqevspZ8OlY8y73OSk4gLS3LmUPzC2MoVx1D29zlVn7nFg/dEwJYkTgLbwEfioAWmvo16lWVNe6awt9kfnyekwti4I3gzSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bpgnSoAM; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bpgnSoAM"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3a0b7124b5fso1354012f8f.2
        for <kvmarm@lists.linux.dev>; Fri, 09 May 2025 06:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746796631; x=1747401431; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=a7gSbBmwEbrzvNYYQSCJBfxoOPDdFppaV9wKD8t7PFc=;
        b=bpgnSoAMbT0UpMfriJ6K8/TMQR2KKRucg16qLsdhmLGftsJ8k6WAlh/hOVFEAK46yU
         bcLEihDcslDV4pLb346ihBuo9W6V7G2NFxNLenTy/vYpyT8OirjWNNkIXMqenPZiZYEk
         CFM3St/Yw67rW7fFIWOMgf9BRDFoH44NTRrE1Gf9gCrzycUJacjL43KLGnZbc9b6ZSb3
         Uzj6YoKiroXNM3LuDDyFUSkcCHmhLhlEaBLRHNlAfhhA8ylCFzZRp5b6Ej3uiln5xdR6
         JQ1sznkSKAJwx9km9bjKiRSddlBCQz3j1esX4i6zY5/rlgsA+p6sewvDd9jH8QN9AEYu
         rqxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746796631; x=1747401431;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=a7gSbBmwEbrzvNYYQSCJBfxoOPDdFppaV9wKD8t7PFc=;
        b=sp4RmGoWnK4eEuZhrY2REKtzbMAoO6pmaB/MA05mgutInbWZ5yPukfvUB+PVt7FYqY
         r+v2BD0jWm2ykKP19cK1Apzk4NxU9VxBRpP4fhHqiykiV6BFQVmvujlWQATz1u79wqvX
         EDV6iXVLtOpgqaRQmOsxFqiSKjhZ0rziPj8gCOYaUVSUjlbabuImBnpj/F04NTR7zyqs
         XWiTv+0Z1Y0znbaS9/KQtXkb8wnaWSCizhUnuyu3yyns9dy5fmNwOQ91P/O+dHvDmRV1
         2HHN4uqwbcpVkpWn4vgV1w00CP7UTjR1sFrosxtn6f6vBfkO6xCDc2LaScjC8/U4pJt2
         /9wQ==
X-Forwarded-Encrypted: i=1; AJvYcCXqEFb2rRP1DR09I1n0x5Zq6cuFKQLgxstxsC3cGWVjavF/wXg3YCDhj7i+Ta23wxLI5VS4Z5Y=@lists.linux.dev
X-Gm-Message-State: AOJu0YyoiVSEds4egJxMz6dVY8RMe3GNvxdjh5x3pmC0rL65y0lf/EvP
	zzwZCJREDCsNnAwliRfTmtISiBMEBdP/ozA791YkjlacJYKj7SeC/1YkOUm7Sb7+MUQGEveXBFW
	GNR2xWRXJ4IiDbIzpEw==
X-Google-Smtp-Source: AGHT+IFi6w9266SPSYPxeLRdeQM8z/1XJhDeBgZ2t8xI6U1+Kw8j1L1qN5yPWtzyq3Jue0kea8Vb5SL0z32sr5OS
X-Received: from wmbfm20.prod.google.com ([2002:a05:600c:c14:b0:43d:8f:dd29])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:adf:e3c1:0:b0:3a1:f654:ebec with SMTP id ffacd0b85a97d-3a1f654ec75mr2409729f8f.38.1746796630943;
 Fri, 09 May 2025 06:17:10 -0700 (PDT)
Date: Fri,  9 May 2025 14:16:56 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.1015.ga840276032-goog
Message-ID: <20250509131706.2336138-1-vdonnefort@google.com>
Subject: [PATCH v4 00/10] Stage-2 huge mappings for pKVM np-guests
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
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 276 ++++++++++++------
 arch/arm64/kvm/hyp/nvhe/mm.c                  |  86 +++++-
 arch/arm64/kvm/hyp/nvhe/setup.c               |  15 +-
 arch/arm64/kvm/hyp/pgtable.c                  |   6 -
 arch/arm64/kvm/mmu.c                          |   5 +-
 arch/arm64/kvm/pkvm.c                         | 129 ++++----
 12 files changed, 375 insertions(+), 195 deletions(-)


base-commit: c4e91ea0cc7e6345a4f7b8167e838d728ca86c30
-- 
2.49.0.1015.ga840276032-goog


Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 978F81DA61B
	for <kvmarm@lists.linux.dev>; Tue, 20 May 2025 08:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747731183; cv=none; b=GgtiZ+Z9t9LXmQhMKkeRk3C6cCFwV989v6UoKPbgNn6SxpJR62lIL6k6SvabzLi1bgp4cvJWDV0ncGNSv2KwPMX1qC6hHMXanIK/jwVeW62LZialafujPn6YpCFvAUyidXSuG2CUTHMhwCELQJqQ4kXvwgJLg5xSAFvkhVj20kA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747731183; c=relaxed/simple;
	bh=uw13QPggAl+A94pkIcH2RFvi8JKQ4cNypwyB4yn48+4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=FCtUWqSg4l4Si2pW8skxCR/eRGIkDf5CHuL7CxlLyJhKcQq4DHm1XZfMcV3WG5opcAzE6yZnnB/sUKqFbqKGGfs23fxVxLIBKuNS/PGYYJbd3ifIBX1KKGwnxMk44vaKWxmHIunuSoFPFg4zgOvlREy1GIonfZPo7d1TUh02i/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UALBlDEy; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UALBlDEy"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3a370309e5cso1313611f8f.3
        for <kvmarm@lists.linux.dev>; Tue, 20 May 2025 01:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747731180; x=1748335980; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1R+g8p9p/0+qgGtEWSsfrtXcyJzKxwZsoiTTrliTdnI=;
        b=UALBlDEyeqPiNvKXKxbVtzml7svwTuMjbIQDTmCg4JePzfIVphEQV/M/8Tq+Vjnzar
         PfFYz1xdo1buoHyYTpFIxH/ZJozIRQBB/6IOxP/2TjtMpa9I+yqaZfeYVGK1WjL9b9/q
         hVXA/c148ZMCfu7HSw5BU/N5OjxP0w643Vv0Oeg8lT3LCTsA6TbAP6nx9w90j4Ft7xgD
         pZYL+fOT3A3M+iL83lORsU+XzJykGPMHh9b85zw/opI+gq795T7IfkBIPBkTZ7NQ4aTd
         xOx7En4ET9JRUtBexVNdoNKGecqD4T37WEa1tR1jm3OhWEVwDu9qnDuiWx+IEOOHhRfB
         oCew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747731180; x=1748335980;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1R+g8p9p/0+qgGtEWSsfrtXcyJzKxwZsoiTTrliTdnI=;
        b=sBqEd3DtRApU8m3jqOQUby5lXr7r8pYAlQ/zS7HCf1tLxln3tpmCohs3vXKi5KZVBZ
         GHgH5TMX4c5pMCcdvOC2RyVIbiz3elMlFaPSwdp+UWrC0z45/QCKvWMaMAgzF29UUmq5
         kq0egXU4/mBnAiEHAmcyKrDFzIhxsAOY9AMVRXjN1q3/NI9bOUZ2Gs2fbt53dcNkWABt
         hUJ+TjOZfClGdDPhkEWyvFJarkolxQDsY9zz6xkt1lCce5lQoi2CuBRE7f0X0MIB7xdf
         DpDnykiSfgKWDVjJeI1Gjyf2fwsxcjYunLhRgmJpWfOfgq78vsZ3dhWTAdRWHeHK0Vzv
         +A8Q==
X-Forwarded-Encrypted: i=1; AJvYcCV+gORmEoHMD4zAcbNOmVOBDkZbPP5C4esIh0QOnZ/eD1x2jTLjZ0Fu698dZMcZlKJ1/QIekzw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxc1/ybt6rHEqyp5VAd2qWgsyC+luFOFJct2sHo5rVOqgffVK3l
	yPgn927ML8QRa3UAs4qbghb0Ei6Aqctxw9I82vKw7dojmjatSJm+nqWZRZNAAEQ80RoEGcc6njC
	YlnwJ61UAMZtddjuzqBosXA==
X-Google-Smtp-Source: AGHT+IFvnJ0x096AewJLW91FfyVpd0hjBTiaPSvB/MeNfz/Q4KVLUUxYR8v5yoCX37oRP3aJR89EPXhq3td9C3jQ
X-Received: from wrbee4.prod.google.com ([2002:a05:6000:2104:b0:3a0:b3cf:8dee])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:5986:0:b0:3a3:76da:32b3 with SMTP id ffacd0b85a97d-3a376da331fmr3865387f8f.18.1747731180063;
 Tue, 20 May 2025 01:53:00 -0700 (PDT)
Date: Tue, 20 May 2025 09:51:51 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.1143.g0be31eac6b-goog
Message-ID: <20250520085201.3059786-1-vdonnefort@google.com>
Subject: [PATCH v5 00/10] Stage-2 huge mappings for pKVM np-guests
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


base-commit: c4e91ea0cc7e6345a4f7b8167e838d728ca86c30
-- 
2.49.0.1143.g0be31eac6b-goog


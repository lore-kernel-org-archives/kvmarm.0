Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9420520F087
	for <kvmarm@lists.linux.dev>; Mon,  7 Apr 2025 08:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744014454; cv=none; b=F5/CNswTyJCqdeEmErDv4uCbeIW6N7irKbrBpm4Ht9VRmP54JD701WWmIKDdprud4f7TLE/vLkAMuQdNnVjglGUSmFB+owG9HFlfrLXY03m7vJVd5QUqc6kAhbZUVtLNINt1xoAoUqAWRePCh+TLLTM3dz7j6FdSpqpLha4w3Es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744014454; c=relaxed/simple;
	bh=ZiNq+60xXrp7X+NoT2r6vcJeIPt+ez0IAmeaMobsOWk=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=uV14iOaw+J9Mr2h7vAyYoaQhgjrj/o+M9mcWgTz3vOSQ900RJtFtFm1r5OnPCxmOIwzMEJGT3V5VOFAAJ1xTAPX1L7Jp/eC2y2FRJw/hnuJgyhxNhuUlHS+Qrp0ehYgJmyZstDUDlwfk7uCjGp+fdztRIiOrue4H+kNn2kycwMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ENRVLOvg; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ENRVLOvg"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43d08915f61so22354895e9.2
        for <kvmarm@lists.linux.dev>; Mon, 07 Apr 2025 01:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744014451; x=1744619251; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fD9COX0Pw17byuPpjCb5FZ4ylgjxa+BidJzcsVb88Zc=;
        b=ENRVLOvgHnin0VLTIo//Qg0yFKcKfadwlCv2K0DbgqASi9/MdLIY85N/QjrNKJXhij
         b/5rmtKUhWVEsPR2424Mh0pog1TvvMOlFjvHm7iCaf0jPdA5kWhTsiWJdrp/sV1vA3MS
         mvjWhnZWL74Q+AQw1SXu0iV3a9qurae+KyXmNJwjOQAn7cuauFfzejBh29BRMsGUfDdA
         GBiZvPUoYhmNhNtlVhRWiCLSXIrWdW1eKeNDsrtw8bkhweZrQtFYclGwODKt67vaoSkO
         36/Qyq3148Ygpj0biarx0JVNNrJgpKFvAoPQQedmGiCbly41nZH6qP7soVMLbmC2/ipl
         gHYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744014451; x=1744619251;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fD9COX0Pw17byuPpjCb5FZ4ylgjxa+BidJzcsVb88Zc=;
        b=NkjPMOIsWDyKNR4rXUEGQiSiN1sdTR5n48jnYYArolDhPK1y7FCNClZxyZs6zNCHWc
         Zr7kK0rwK8PXEo5Xd3uuC5IG04kDbDoLuKoXaa6vcMpGBsggqtvYeKjEZUnbZiBwpb3D
         y+PZR9JXinh9FLiEiFPVDdJJxrkaLgVlI4ZVOQls/KDdh5KEWiRGPWJCHhQwG8/E59SH
         0Fo8dRzQ3/Qtktvisgxs9vUNRgpmocObr94MzCwF0JRR2tqw7XIxgtZ/pJBpKESyOiF0
         xqExpBx5FLFiDZ5chOlm9lEpVOmc/vFLCgosQlSBOHfXNrzF2KVrJszYUp0U/QqJAdRV
         2RnA==
X-Forwarded-Encrypted: i=1; AJvYcCWUyDlxSjpeeBi4vpWRXrw4XlA1xgy9+ZTpLUyxMIXRGmy23h9tNQjAqbiIOWp09/gDIcA54fs=@lists.linux.dev
X-Gm-Message-State: AOJu0YyciDln3cJiLIiMCDb7zWsuaF5+qCO9Nozhd+hJkcMAwe3xqKmg
	IKNMD1a5PbWHGI86jOYgFcTl7Kh8f+lEGZY807CccTUJBwQZN7KfoU9V78nP5JuMZK5fR1HzrIy
	2yNpVR+mAcnNT/cxYKg==
X-Google-Smtp-Source: AGHT+IGUzsg+5YsqZ1PEyJ2fXUi6r6QPStOWt82YjAv0VQSmQXRC8ZoIubECZXRmtlKWgqNSo2X0aPxjJEzjFARt
X-Received: from wmcn5.prod.google.com ([2002:a05:600c:c0c5:b0:43c:ec4d:6037])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:46cb:b0:434:fa55:eb56 with SMTP id 5b1f17b1804b1-43ed0b5e180mr92911905e9.7.1744014451027;
 Mon, 07 Apr 2025 01:27:31 -0700 (PDT)
Date: Mon,  7 Apr 2025 09:26:57 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250407082706.1239603-1-vdonnefort@google.com>
Subject: [PATCH v3 0/9] Stage-2 huge mappings for pKVM np-guests
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

Changes since v2 https://lore.kernel.org/all/20250306110038.3733649-1-vdonnefort@google.com/

  - Fix PUD_SIZE -> PMD_SIZE enforcement (Quentin)
  - Rework pkvm_host_share_guest() to remove one hyp_page walk (Quentin)
  - Remove one pgtable walk into __check_host_shared_guest() (Quentin)
  - Return EBUSY on host_share_guest_count overflow

Changes since v1 https://lore.kernel.org/all/20250228102530.1229089-1-vdonnefort@google.com/

  - WARN_ON() on !PAGE_ALIGNED size for guest CMOs (Quentin)
  - check_range_allowed_memory() before accessing the Vmemmap (Quentin)

Quentin Perret (2):
  KVM: arm64: Convert pkvm_mappings to interval tree
  KVM: arm64: Add a range to pkvm_mappings

Vincent Donnefort (7):
  KVM: arm64: Handle huge mappings for np-guest CMOs
  KVM: arm64: Add a range to __pkvm_host_share_guest()
  KVM: arm64: Add a range to __pkvm_host_unshare_guest()
  KVM: arm64: Add a range to __pkvm_host_wrprotect_guest()
  KVM: arm64: Add a range to __pkvm_host_test_clear_young_guest()
  KVM: arm64: Stage-2 huge mappings for np-guests
  KVM: arm64: np-guest CMOs with PMD_SIZE fixmap

 arch/arm64/include/asm/kvm_pgtable.h          |   7 +-
 arch/arm64/include/asm/kvm_pkvm.h             |   2 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   8 +-
 arch/arm64/kvm/hyp/include/nvhe/mm.h          |   4 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  16 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 224 +++++++++++++-----
 arch/arm64/kvm/hyp/nvhe/mm.c                  |  86 ++++++-
 arch/arm64/kvm/hyp/nvhe/setup.c               |   2 +-
 arch/arm64/kvm/hyp/pgtable.c                  |   6 -
 arch/arm64/kvm/mmu.c                          |   5 +-
 arch/arm64/kvm/pkvm.c                         | 129 +++++-----
 11 files changed, 330 insertions(+), 159 deletions(-)


base-commit: e48e99b6edf41c69c5528aa7ffb2daf3c59ee105
-- 
2.49.0.504.g3bcea36a83-goog


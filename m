Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB85149C50
	for <kvmarm@lists.linux.dev>; Fri,  7 Mar 2025 11:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741347261; cv=none; b=mLEwkX1PPWg3nUJoJvOo2lFoPR5oJ6Hds11VXWuFhSh29LSEp/ZHY4/JcWMMrvznuyoRwsFgjeYupkFcuL5AeYSI8SbRgo7NPHbjJmYkiVNQLuXeN9OnFsEPVf2LFPUUF0quxSSObSWgbuozmpiVjuNO8Ta9iuSusOoEcn5HgXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741347261; c=relaxed/simple;
	bh=mc8GdzR9S6fQkS0ghgXW9r2iwc49GNMDkYndkVxx+To=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=HUjR2G8maA4K0VCYvd3xTNjXVLTZx3GemAoFR6lQSH3sUk5JaMbOaWR/4UUxW3IFh8Bd/oW87xKMCE1dDm0ko4cw2cJ/iGGEnikHqqDIZP+7EoX6dqP9XCj00qxp1JurouA1TGathpqI9oj7v5Wyw/e4YIffu7S7JeKVS9GX3hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rXj4ihgi; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rXj4ihgi"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43bcde3f887so11875765e9.2
        for <kvmarm@lists.linux.dev>; Fri, 07 Mar 2025 03:34:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741347257; x=1741952057; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gWRrS3x4cauUfBmtdb7CWhXFgQlJhhYmJ5IHCDodbtg=;
        b=rXj4ihgi7URoDQCafT6++u+M0A2PhGCfd3qBfc10YoiK4UtCZkDxdTO2Jj8b8b2EcU
         /5ZtzsyTZas1U6fDjHLgTuTWpMyGCRmDHXLBGsYw3694zXdgiZ2SZHuCW+A/U9jYBmOQ
         o585fQx1sJFJQtdPnYWRfb1gvgJYZ55cfHsR+qgD27PpSJ2Klb8KuOPJWFS6164frSQI
         KDDKs8g+U1sod9Ol4YlpL9OBE5Hnf2YQyA8F0aYnkSwsP8SMGqMoHmQ2HbVA5Y2w/Lly
         AkjbUZzzqRsfCLVW812cXbmCS8znbxH8fEjxwbovp1QXE1Ay3ztX+xSXZUIbLcZnvqsR
         HUiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741347257; x=1741952057;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gWRrS3x4cauUfBmtdb7CWhXFgQlJhhYmJ5IHCDodbtg=;
        b=dkH3P7rwbDg9LCqxjcuLHSL9CXglVwZaigLggnYA/14HH/93uhi9/yDWARwK61yChh
         qd9mjLvk41BEUnl4tMZ2bHnc1ToUHVxQgFtjXW+mlBdlrEzzjHw+0N7omrvS8qPZiweo
         zqqoE0Y7Wj3zfERaxdmIv11sZJA2QULH3kMhQKHIAHgDOU1q5z88UCzzVLaFI+JYhrXr
         8Rpf2wzt0e8S+8XUlIPV/8ILfGM9CkpXFvUElXpToGLdZJ7YGPQpjUiF2mHH3vayMKZ+
         iuzLj9lKEBLScmyE1ho75kkuN11pj/6JjSjxDfyPUolpWuMc3d4a7lV0zHyCdrG72Y5x
         ZGLg==
X-Forwarded-Encrypted: i=1; AJvYcCVffW8NVl8YxwlqazvcG1pQIYLZKEAh20bDBGWqOQN7F6Njrb1YRQSL56iymkvDnD1yBw4VCGw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxz48cR+5dMtK3lIUIzTonrSyh3Wq7tG4XJr3AU38c9B9oLYSjo
	7OAmZuQ4s4A+cWS/rNtmJUsfjGtknq4wbkmN1YyOwGlKUtAlit9evSIpTFiQRU7uRBz71ueKLd3
	nTdvBROowJX9R2G5NdQ==
X-Google-Smtp-Source: AGHT+IHPB/BavFeiIuU4jP5ze2ourrXrXM89F+RxMJStp6R8CgJywz72d2FJ/8Pyx4rbvot/9rkDeqVmllP9YyEi
X-Received: from wmbhc25.prod.google.com ([2002:a05:600c:8719:b0:43b:d212:f974])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:198f:b0:439:6101:5440 with SMTP id 5b1f17b1804b1-43c5a5f7050mr20681135e9.8.1741347257113;
 Fri, 07 Mar 2025 03:34:17 -0800 (PST)
Date: Fri,  7 Mar 2025 11:34:08 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.rc0.332.g42c0ae87b1-goog
Message-ID: <20250307113411.469018-1-vdonnefort@google.com>
Subject: [PATCH v3 0/3] Count pKVM stage-2 usage in secondary pagetable stat
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: qperret@google.com, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kernel-team@android.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

This series allows to count stage-2 related memory when using pKVM. The
value can be found in the /proc/meminfo field SecPageTables.

Changes since v2: https://lore.kernel.org/all/20250304134347.369854-1-vdonnefort@google.com/
  - Pass a pointer to kvm_hyp_memcache instead of just the flags
    (Oliver)

Changes since v1: https://lore.kernel.org/all/20250228121355.1377891-1-vdonnefort@google.com/
  - Flags to kvm_hyp_memcache
  - Separate stage-2 memcache
  - Account for PGD

Vincent Donnefort (3):
  KVM: arm64: Add flags to kvm_hyp_memcache
  KVM: arm64: Distinct pKVM teardown memcache for stage-2
  KVM: arm64: Count pKVM stage-2 usage in secondary pagetable stats

 arch/arm64/include/asm/kvm_host.h |  4 ++++
 arch/arm64/kvm/hyp/nvhe/pkvm.c    |  7 ++++---
 arch/arm64/kvm/mmu.c              | 22 +++++++++++++++++-----
 arch/arm64/kvm/pkvm.c             |  5 +++++
 4 files changed, 30 insertions(+), 8 deletions(-)


base-commit: d082ecbc71e9e0bf49883ee4afd435a77a5101b6
-- 
2.49.0.rc0.332.g42c0ae87b1-goog


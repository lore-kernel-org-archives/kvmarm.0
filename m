Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4823F266B4B
	for <kvmarm@lists.linux.dev>; Thu, 13 Mar 2025 11:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741866051; cv=none; b=pqha/+kfYhDazZQczh0v34ikRnT5M2pQn7PSAqCT3p6R5Gv4H1aYHMMnTMJYp6OGcWUXRpAxAXoywe11TnFdbOQ7wkiEpZ7tP8hZ7frQooqgTiYfOs+C9kvILU30NLfPHScTqhGBuXhLeBGa1VbVdg2VsEpYRfmwyct0A9StOYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741866051; c=relaxed/simple;
	bh=Eh3Y5LXG17wzb3mkSprvbBwR21QXQxiAZRBUjytc0qM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=ELL9rCNx3Jh4N+DNAauyDc8ND0qIvoPmCOOWtceyTuyvY5M+wwS1Sgq364sD0IkRkC52ioM7FW0ZswHhkprsuBSkdQ/CHHBPJn0/kV9PS0Me7VkDKvqV5r4sMPRd3wtgzh++miBGhnrI+7R8dSgfFyxG+bOKeVO78OH0VtGMSsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mQ4eic2r; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mQ4eic2r"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43bd0586b86so6128745e9.3
        for <kvmarm@lists.linux.dev>; Thu, 13 Mar 2025 04:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741866047; x=1742470847; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/j+Oz7cHBDK6gF/9kTqWJDu+O9+gPpwr8SGXRwE61TQ=;
        b=mQ4eic2rbX8h+T3gtrkp2DrbO3yU5RUdVr9BQYZuRDIWjucF8b6fhmIGOnQZIJPW2z
         NfZWzSB7eGcvpG8U1U8VAXHE0PTsneqHAWM+mnnezs4Ed/q64yzX9jhp1GBhB78WPbva
         n20fZ6QKvw2C0tW8dcYmB4xI/hWwoZuFdZH743KNYQm6O9JsxMpgGwfubOSIc1MRq41L
         jPHOiERlJWVnqJou/A9M8AfomE0CQC60gHd++2zgRK/ebE4hX+qSMShkyxEkICNb+vu8
         Dv1itIRsoDCcec2yA4BRtPvBZ7WtTpkncFqXmdEy6uW2/m5K5BGVNhCnUqxoGZFvmA5z
         HRvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741866047; x=1742470847;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/j+Oz7cHBDK6gF/9kTqWJDu+O9+gPpwr8SGXRwE61TQ=;
        b=k1rkX4HGeGodcDq67AMx4CNN53SlGTg9YjiMsNuFtPJ4R97r2Q4h4A+gU2aPIh9zXj
         4AW4Ph9SAZaTVwINrY72WiPyM03RfIEoaXqlHvyMNxPfaPbP+ZlPPalFLtcWpCvgw2X9
         2xPOUBFAzKr0jpu1t7L9z5tIkGKxKiLRUU+N7bwETZU33PaeileuNptlIw7axALIWldR
         OodvB6B8aRuN+HnUGjUzWCgm0HLQUnPa1WVMSoCpr5ZuCuVaKnYpZ7Lbdeb0ry5/MAaX
         VwxJySHvximKuPkHdd0o4Tt/gty/b4FZVNEWmI9rROUVM1FYh4cVqhFjXYuyLbfhI8k9
         S05A==
X-Forwarded-Encrypted: i=1; AJvYcCUHmw3+HkVFUJsnC8mgwao9l0D570i1/kqs2VWh/ziL8HGXTDUU2dW78rxdMh3IswL24k+9rOU=@lists.linux.dev
X-Gm-Message-State: AOJu0YxCw1U54/QMO5Bz6PD3khw44BBLv4uAxJhXUSrSuzDLIG3JNiDQ
	rIWehLXdqEHt3WprrQLBEXzUPVeCDDacN9uDIdowxKfZq/QVm3g0JlUXAZ67BTyBgoxQUqXKRn0
	k/r+G7NnHsUF1KGCV6w==
X-Google-Smtp-Source: AGHT+IHT/XL50MODZw7JAAt6rGzgQd+Y4OENiN5kXRm9oqFCYFwRAIdO78t5s5DxhHV14BZpOtcnvF2TqxK+OAfE
X-Received: from wmbbi10.prod.google.com ([2002:a05:600c:3d8a:b0:43d:abd:278f])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:5618:b0:43b:ce3c:19d0 with SMTP id 5b1f17b1804b1-43cdfb7db88mr180301615e9.29.1741866047681;
 Thu, 13 Mar 2025 04:40:47 -0700 (PDT)
Date: Thu, 13 Mar 2025 11:40:35 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.rc0.332.g42c0ae87b1-goog
Message-ID: <20250313114038.1502357-1-vdonnefort@google.com>
Subject: [PATCH v4 0/3] Count pKVM stage-2 usage in secondary pagetable stat
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

Changes since v3: https://lore.kernel.org/all/20250307113411.469018-1-vdonnefort@google.com/
  - Remove unnecessary void * cast (Marc)
  - Rename reclaim_guest_pages() -> reclaim_pgtable_pages() (Marc)
  - Remove unnecessary PAGE_ALIGN(pgd_sz)

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

 arch/arm64/include/asm/kvm_host.h             |  4 ++++
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  2 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         |  2 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                |  8 +++----
 arch/arm64/kvm/mmu.c                          | 22 ++++++++++++++-----
 arch/arm64/kvm/pkvm.c                         |  5 +++++
 6 files changed, 32 insertions(+), 11 deletions(-)


base-commit: d082ecbc71e9e0bf49883ee4afd435a77a5101b6
-- 
2.49.0.rc0.332.g42c0ae87b1-goog


Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89FCC3161BB
	for <kvmarm@lists.linux.dev>; Fri,  9 Jan 2026 08:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767946959; cv=none; b=mVyPWoGLqpxrXEL/dHtixSZVOExitNsH+BoYZW6BIdbJ65Lq5Hl+GudDeYyKWnFB62lj1k0+2d+WTupisbxoMzAFmYnUk8YSG4HV/iatbGnYukLhx3vRTk+Lilfy07KGwN04MD7Kusj0HgFla4R8GlXRVXfboyBkxbuVWoaGqHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767946959; c=relaxed/simple;
	bh=7+hBAtEjizRvOWyCo7oHDoORCJhFCsVGIJjJxvMGurc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=YaoQFRaD+yHsGpYGxrrTn3r3+WY02Hjm8eUofrfA8CjhgjfxdgUj4MIznAj/1OeSTCwJV8GsfjhJ7pNXJzvD61p1t1WUy2JPc1Otk58Jwuf2MB7IsO0xI5dTqLJK1sHQltAewmfGpQWTkAFfkzlQCEIvJjKI02Q8kYCaV1wxCJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YVq7j7uu; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YVq7j7uu"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4775e00b16fso27183405e9.2
        for <kvmarm@lists.linux.dev>; Fri, 09 Jan 2026 00:22:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767946939; x=1768551739; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BMgUtghnuAy1sqqzoIvEfRuLHghrW+zp1tKrLf8u880=;
        b=YVq7j7uuQUar19gXNFAf3uNKKN68RMh/YJnSTeuMsLVp0ohFu5YyK2UN4Mz+4nx/zX
         vsZ7X6XRJZfRwKFPHBAxejxd9wrzdQdiwXefETNS7EoMacuYhB7nK8/xWpt0kstQIb8p
         inUFZByq5GG9P7Z39n+KQKZoL+NLBRYqj+DKyMSJaHNz+qr4vTnhBuPulZLKd7vDzNzp
         He1o1WIofW0YbjYMMF5Ps/FiQPHm8dQ2drcbsEgEf3b0KL3rLTdrwDNpLVQaLXvfjmys
         8O184MseRsZQGKt52/aRE6VMKFEB7Poq3RxCgRRE3ZkFg7z+C0d3YnYMO3lJRclnlTha
         uwUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767946939; x=1768551739;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BMgUtghnuAy1sqqzoIvEfRuLHghrW+zp1tKrLf8u880=;
        b=InJEteGlS88nytsL17DBUHY6g3HFUwiXzepXxKjFgyo0pVejurnyWzh1Vjg0TRB97E
         nsjxU7r2cPzaxftXqdBSO/vMe0M7eAE/7tGxZcukX6OSyRpgHKQpw9zy2y0dR7PuBWes
         MllTM+A4QMgkoRfR6PwH8nhBxxAQgpcOmxYhBRHMdgvxbZ1W4iBooJimEZeHobQ2qjey
         JgiiSHGH4GI9i+IbRXEVJWPGi2Koj28HjDvs8Xchu3S3e0jX/AUV5YaQoWlEZ4Q6hoye
         UbRSglilMgih738AmINcJn+dguzEP/wQD8VC/c6w3coexQlc/JB8TbzckMKncGHZVvjX
         9Oxg==
X-Forwarded-Encrypted: i=1; AJvYcCUK7zglSKvZfqI8RhwXJGOo5u/w1Vi8eTKsaTsDt+SIfjTSaT8vEr0DJFEwDrMd384bi3koYLg=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywt0PE79f77mEnecMarZggGaYTtoKeHcxKzfaRZJdFSnwO3QDc6
	4cMbfyKepxMDd5QujSCjiTWtiqzkoZKxBOc0wcOX6VTOAmFRB0hRgfzBgXYbFbxfgoUMQpiK+cu
	ymA==
X-Google-Smtp-Source: AGHT+IEEqNYMoHeY+3DwmkTCwwRtWsTJKfrOQfXfQ55U2Jju+BCRFWy02s7qCZ5He0miV9LurIPAHvpnNA==
X-Received: from wrbgz29.prod.google.com ([2002:a05:6000:481d:b0:431:1c7:f966])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4fd2:b0:47b:deb9:f8a
 with SMTP id 5b1f17b1804b1-47d84b40a99mr108297505e9.30.1767946939194; Fri, 09
 Jan 2026 00:22:19 -0800 (PST)
Date: Fri,  9 Jan 2026 08:22:13 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260109082218.3236580-1-tabba@google.com>
Subject: [PATCH v4 0/5] KVM: selftests: Alignment fixes and arm64 MMU cleanup
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org, 
	pbonzini@redhat.com, shuah@kernel.org, anup@brainfault.org, 
	atish.patra@linux.dev, itaru.kitayama@fujitsu.com, andrew.jones@linux.dev, 
	seanjc@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Changes from v3 [1]:
- Renamed page_align() to vm_page_align() (Sean)

This series tidies up a few things in the KVM selftests. It addresses an
error in memory alignment, hardens the arm64 MMU configuration for
selftests, and fixes minor documentation issues.

First, for arm64, the series explicitly disables translation table walks
for the unused upper virtual address range (TTBR1). Since selftests run
entirely in the lower range (TTBR0), leaving TTBR1 uninitialized but
active could lead to unpredictable behavior if guest code accesses high
addresses. We set EPD1 and TBI1 to ensure such accesses
deterministically generate translation faults.

Second, the series fixes the `page_align()` implementation in both arm64
and riscv. The previous version incorrectly rounded up already-aligned
addresses to the *next* page, potentially wasting memory or causing
unexpected gaps. After fixing the logic in the arch-specific files, the
function is moved to the common `kvm_util.h` header to eliminate code
duplication, and renamed to vm_page_align() to make it clear that the
alignment is done with respect to the guest's base page size.

Finally, a few comments and argument descriptions in `kvm_util` are
updated to match the actual code implementation.

Based on Linux 6.19-rc4.

Cheers,
/fuad

[1] https://lore.kernel.org/all/20260106092425.1529428-1-tabba@google.com/

Fuad Tabba (5):
  KVM: arm64: selftests: Disable unused TTBR1_EL1 translations
  KVM: arm64: selftests: Fix incorrect rounding in page_align()
  KVM: riscv: selftests: Fix incorrect rounding in page_align()
  KVM: selftests: Move page_align() to shared header
  KVM: selftests: Fix typos and stale comments in kvm_util

 tools/testing/selftests/kvm/include/arm64/processor.h | 4 ++++
 tools/testing/selftests/kvm/include/kvm_util.h        | 9 +++++++--
 tools/testing/selftests/kvm/lib/arm64/processor.c     | 9 +++------
 tools/testing/selftests/kvm/lib/kvm_util.c            | 2 +-
 tools/testing/selftests/kvm/lib/riscv/processor.c     | 7 +------
 5 files changed, 16 insertions(+), 15 deletions(-)


base-commit: 9ace4753a5202b02191d54e9fdf7f9e3d02b85eb
-- 
2.52.0.457.g6b5491de43-goog


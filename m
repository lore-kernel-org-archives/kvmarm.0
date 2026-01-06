Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5324F3161B1
	for <kvmarm@lists.linux.dev>; Tue,  6 Jan 2026 09:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767691470; cv=none; b=o8J2PFN6uYP8jPdt1xretXY7Ut+79L4arKL4kza0H4voTAR8pJxKDVzM3yi+xd8GHrGQuP4syT1BIuO0Hif9XV8Gkz2qTubzSr1m3xVsYGmc28UJiqAK+eOeuqQhPVfYABtPVuVldRLjPvcq2FIueN/SSNr82dijxtGmGNki8TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767691470; c=relaxed/simple;
	bh=hMrKzPKwz67JgoKxLU1YaBlRJJnDreZeCQvtwVIB3NA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=X+b5GljDzIDa/QC4YloGfgQVPZFtNUERuqk61St+SdH5alJVHgwkv2avdzNgV/0tYUlHc4aAu+gM3CyEIM0EdKLYfm/bpzDSZsS8eLiP830qFAr8TVqOgh3wOMyE98K/T1DBpW9vdNY6EOacTk+QYxT5p1E8SRIRhQKGgEpuSPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=h7yXnKTS; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h7yXnKTS"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4775e00b16fso4713955e9.2
        for <kvmarm@lists.linux.dev>; Tue, 06 Jan 2026 01:24:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767691466; x=1768296266; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+LqF8/lht1o9n/0GpUByxOJv4W80ArGZN3sXAN7aJgw=;
        b=h7yXnKTSSl7nhzswRApRS0CPsxfXcj9HsmSsLO2BgRlvb8Cd2UpeJPn1EjAzDKiv1U
         nohr1M/lwcrDQE4okw4TLg6o/oeeicBlJK535l4Ylkbge/IaxXZfLeStu1jV84QpEPMr
         QGkVd/5KfydmSf8nAf6xIZBMg1yCbfnZVqGhQQ2MwZuPz1wv2VpgLzQsBHLXdjSlZDYo
         jJh0UOnOQDrhvG2ijYTUuBIuKSeUa2FH+JhAurmoNo+LnTdL64XmRm3eY0sloXwwgcKv
         CsSO996QXx/Go8eE043ArUe1xyCXq/n89crSvmJGlT9yJ4lLK+KTQTMl0X4mB8dJBTUg
         Y2vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767691466; x=1768296266;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+LqF8/lht1o9n/0GpUByxOJv4W80ArGZN3sXAN7aJgw=;
        b=i93zW0kGmLpTcnrNNPZBDW5bTY1Cre+izv1nUaJJjNhPmOWVvKwV6exqixe+QZ/RNS
         zgaSw3cnAu8MKKcwaxJ29mlZN31T2WATOoaOEfKhFTrSF5WxGqOg1QZWnxnHvaOlh1yU
         EPXZHbDWrGaT86pzUznmEs7Fax5ZP0rPY9f1WsM2V7Lgi6O8OxDbFyUI+9LtimPRhboH
         Ec2J5e+qykdDfDqJ9/+YkYtRsgUXQhtgvyJmtvGsRJFsu76/zqY/1VE5d34Xf2AYSY08
         1Gy0zOTzbvvLOue/FBrxYWf7MtAwJcaJ/RU4fYYJULbyy3ntbVz692sylOY4AvsAqN/v
         5TwQ==
X-Forwarded-Encrypted: i=1; AJvYcCWnUZHF5c5Wp1iH9iFB3LfCR9r0GUW0eJ1/K7s38utj+Z8OAgJGnfyuA8iY4BR4UZrppazjOtE=@lists.linux.dev
X-Gm-Message-State: AOJu0YxEeFMbslDogEkMQXxyOLf4PF4tONcqfZzuw+uRNablN1ey7oQq
	DLxR/WbqCpR5zU0krio14EUdL+FDWx0fF5nZJHqtNiO8t6RYD5QIGH7YnNBMREBt1MLmdQT09Lj
	QJg==
X-Google-Smtp-Source: AGHT+IGJDvWpfC1ugVJSYdWQcUeMnYmXOhwJri2fdiSaOwSbZ5cVH4Myj4tyQgT04GoXs3XHWR0vuJXjyQ==
X-Received: from wmbdu14.prod.google.com ([2002:a05:600c:634e:b0:477:9b3e:67e3])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3555:b0:479:33be:b23e
 with SMTP id 5b1f17b1804b1-47d7f090045mr30939095e9.17.1767691466044; Tue, 06
 Jan 2026 01:24:26 -0800 (PST)
Date: Tue,  6 Jan 2026 09:24:20 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20260106092425.1529428-1-tabba@google.com>
Subject: [PATCH v3 0/5] KVM: selftests: Alignment fixes and arm64 MMU cleanup
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org, 
	pbonzini@redhat.com, shuah@kernel.org, anup@brainfault.org, 
	itaru.kitayama@fujitsu.com, andrew.jones@linux.dev, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Changes from v2 [1]:
- Collected Reviewed-by tags from the previous version (thanks!)
- Rebased on 6.19-rc4
- No code changes

This series tidies up a few things in the KVM selftests. It addresses an
error in memory alignment, hardens the arm64 MMU configuration for
selftests, and fixes minor documentation issues.

First, for arm64, the series explicitly disables translation table walks
for the unused upper virtual address range (TTBR1). Since selftests run
entirely in the lower range (TTBR0), leaving TTBR1 uninitialized but
active could lead to unpredictable behavior if guest code accesses high
addresses. We set EPD1 (and TBI1) to ensure such accesses
deterministically generate translation faults.

Second, the series fixes the `page_align()` implementation in both arm64
and riscv. The previous version incorrectly rounded up already-aligned
addresses to the *next* page, potentially wasting memory or causing
unexpected gaps. After fixing the logic in the arch-specific files, the
function is moved to the common `kvm_util.h` header to eliminate code
duplication.

Finally, a few comments and argument descriptions in `kvm_util` are
updated to match the actual code implementation.

Based on Linux 6.19-rc4.

Cheers,
/fuad

[1] https://lore.kernel.org/all/20251215165155.3451819-1-tabba@google.com/

Fuad Tabba (5):
  KVM: arm64: selftests: Disable unused TTBR1_EL1 translations
  KVM: arm64: selftests: Fix incorrect rounding in page_align()
  KVM: riscv: selftests: Fix incorrect rounding in page_align()
  KVM: selftests: Move page_align() to shared header
  KVM: selftests: Fix typos and stale comments in kvm_util

 tools/testing/selftests/kvm/include/arm64/processor.h | 4 ++++
 tools/testing/selftests/kvm/include/kvm_util.h        | 9 +++++++--
 tools/testing/selftests/kvm/lib/arm64/processor.c     | 7 ++-----
 tools/testing/selftests/kvm/lib/kvm_util.c            | 2 +-
 tools/testing/selftests/kvm/lib/riscv/processor.c     | 5 -----
 5 files changed, 14 insertions(+), 13 deletions(-)


base-commit: 9ace4753a5202b02191d54e9fdf7f9e3d02b85eb
-- 
2.52.0.351.gbe84eed79e-goog


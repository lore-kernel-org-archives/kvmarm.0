Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79BD341065
	for <kvmarm@lists.linux.dev>; Mon, 15 Dec 2025 16:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765817519; cv=none; b=tTLieAsVKwcWxFBe900FSGRSXhlL133ZVeEUfJL9dZsljgq9E5mEowIVD7AiW6z+UdnKmzWdUAxpfP7xuuOpxaQVHbrOqTGdqmn8rMJCPwoPgiraDi47+3XvmHLOfrSyyedKwgXeptSc2m7PwYciPYosqANYOg4XZTOKJUmeXlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765817519; c=relaxed/simple;
	bh=kU9NExtTi+tE1/KxnF4R8dBMbcDHnu2R/mzeJ9uVPQs=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=sdDtrKDHZnj2qbN3GuC0Lg18SViAFdwZWcYbfyLfp/v7WjgkjNvJu4L+kR05LXZ6B8gMj2PUNLDsxABr5727XHa9u/Cdh0IzJM81r5aIMm66Bo9Oee8gWY5SR5cj4xsdnfBF0Dri+J23LtGoTaZQYnx1lvtxBtJM0ijzPusHvvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=v66sDfm6; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="v66sDfm6"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4792bd2c290so42476915e9.1
        for <kvmarm@lists.linux.dev>; Mon, 15 Dec 2025 08:51:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765817516; x=1766422316; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=k4K0A7tw0piWVnb/7q48qsAOBuaPwaaJnbI388C3EIk=;
        b=v66sDfm6AWlP8boEbDCRAgU8l/bVZYjE68GwKNDl/YSM8GaWrio2+A8QdPhbJADZUG
         pHPNbdT29P/hoj8bO4szMV8ZQ9QoMSi6SgvVJ8KfUyCVZ9gFtUsCfCw79IS6DFXl188C
         QfjtexLHh/TvZhuCMA33IUsfdXy0dP6GBScVorthFwNb9lCCcPYv9HNvSU4Hi4Cm8boa
         zn93N1Y7QxB++YGBAjls90opHmLODIQchuZ1CFjPUkrEGyLVMyMynBlSSPTuKWxUkdxp
         yNynUkl8HNDykRfblTbC6QGVx8DSp9f6UhAUaGEVJPRkZLBlSsBJrpvxKrenRlX3+1ve
         Ygvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765817516; x=1766422316;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=k4K0A7tw0piWVnb/7q48qsAOBuaPwaaJnbI388C3EIk=;
        b=bw4uumyehlnxAA1r8Lq26F7QdcSUUkmceKkdov+xIh4ZYX1RGwYwchvwy5ZWDbhNn+
         XoR/4mWvH1SeX8DP4WNWH61oh0QwJHu+3j+zrx/hrOa9BidjS2mPFw8cf3vMf9Q+EgEU
         tyqqbAXz7hhGE1q7Wn/lUrGMu74zUJ3hP9pt5JJ1W65XrA4qs2EjVFjVwhWAN+nAJy40
         RGXJvwOnJicZFlpvLo4J0hIg11K2iZo1nH3SDjqKVFrS59iyRrjY2GO7q5gy6K7QyCgt
         rs97Z28RRxtWJGCVlIRh50FCRtEAyxCrOLvocK4aoVFPpKt9bXtcplbtfwx5WaPgVmlS
         Gylg==
X-Forwarded-Encrypted: i=1; AJvYcCVjWzc30Vl8YoIi4jeo9nWBcuylcEDi96tyowSiNHlAE2/eyJBxLNjIE7akU9C5nULz6Mt4gsE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyvyna9J0DfTZMXN4lO9rX4WbzPk5V96jKtDdsYDA0eL5kSHxKC
	RAQnxNtsBgAGMKzR4OqfZgJN/5QhwyoUDcvjS6+R2CYGA53Gh6XdoVUaZxf69kY4moNioLDvUsD
	lSg==
X-Google-Smtp-Source: AGHT+IGNq+OOelN0gNt5/INxptKwNuOhXBeg9PpZV5h/y2ooLGgWvT+8nQuHYF+Ar/8EPep76SDOriq1fw==
X-Received: from wmpo6.prod.google.com ([2002:a05:600c:3386:b0:475:d804:bfd2])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:840f:b0:479:1a09:1c4a
 with SMTP id 5b1f17b1804b1-47a96378c50mr93572455e9.31.1765817516238; Mon, 15
 Dec 2025 08:51:56 -0800 (PST)
Date: Mon, 15 Dec 2025 16:51:50 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251215165155.3451819-1-tabba@google.com>
Subject: [PATCH v2 0/5] KVM: selftests: Alignment fixes and arm64 MMU cleanup
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org, 
	pbonzini@redhat.com, shuah@kernel.org, anup@brainfault.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

v2:
- Resend to correct partial To/Cc lists. The previous versions were
  inadvertently sent to disjoint subsets of the maintainers and lists
  (kvmarm vs kvm-riscv). Apologies for the noise and the duplicate
  threads.
- No code changes.

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

Based on Linux 6.19-rc1.

Cheers,
/fuad

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


base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8
-- 
2.52.0.239.gd5f0c6e74e-goog


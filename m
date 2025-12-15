Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09D8338916
	for <kvmarm@lists.linux.dev>; Mon, 15 Dec 2025 15:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765813537; cv=none; b=ita3Fj0hGN6bb2mBaHaHLlINH9Qf3UrzyDQ1zw2jO/ni4AsPW8OiqXj8iGmLhwHUgOpAxTKM5g9Pb51YBzfn0vHo9uIzWEAQJnhqaSVFAjTZmjsxIQontxcnM2RBN86S6gRSiF7AENYbTzaG1VUoZSgKuZFRlCUIkpq0R/kkdWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765813537; c=relaxed/simple;
	bh=QLYTCjX2EZ84iw7nVlOSDJ86AmUekPGCFfsO1BJfBhI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=nhabp8FS/la9FhLt1iRATY5pFPloxC+AidvUs/TQvZuLqhP3+kznJwhfGMMBWyiXFxdRJ58Swz4qHf1i1Oc5/p0ZsfXz9TMBO4yC5hmHRu4oE/b3hdnbJh1qVMioGLopLWEusmFU23JDPxU85eJN7krjTBbi0pNq8p+BSYcoAhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2MhykaDv; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2MhykaDv"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-47775585257so26065615e9.1
        for <kvmarm@lists.linux.dev>; Mon, 15 Dec 2025 07:45:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765813534; x=1766418334; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bw36UYHiJwTnMGEVt20djLkGP5pKUV/ucx4MipOtVRg=;
        b=2MhykaDvvU1P0JmpvA6BbS4y1GFn75U06J3cQpgJ1cBU34NPiqQNJIz+gAT1QBcn2U
         IXgV3BecM+W7EfbjTK/SCGd65KOgrrYZZ6LFMh6ITLOm5wXsasQccudSTQ6QkXHh4E63
         Q6qPpUZtzhh5s2e8axbx2FAdayuTBVEuAwETXz39EsSF6TgzLH6/hK4D/JYexiGleAMk
         /elYHFZtkGoKT6yO+xyCy+KMPbzsk05T9PpCcdv4oUNzZHRqZE3rMNPoL+tKk57bdzGN
         d2lbUcdN+yXWpoIbnC2Y2EmdiehFZ43IEFuxDgMFqqfCHTnAgWrW3KWJtwDxsQtarpeZ
         y+5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765813534; x=1766418334;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bw36UYHiJwTnMGEVt20djLkGP5pKUV/ucx4MipOtVRg=;
        b=jyHxdzL4R7bfHxexYPDOkfNAIdyP0CZ+1Yp0vNSllVcSw1UhkXtIK913P+NiMbjkZQ
         yO1oboVD9h5UiFWF4Jp3wDzYUW0skPHyr+Yi3kb9I1+fhvWXz/3d33jvJIjBLqwtRTe/
         aQ/aT+34Wl5VBTSAUNJ4u5UOMrSRH85t54Zp7EI1T8GAoWXom8gA60ToRdSBmU3yG/wJ
         Ogyi2Rwi5t22xSaF8wpgMOr5qjjfJLpZo8MnyK/CORvsS4KE8xlx1auvRIrXonqtYYFu
         4fBdYmiCsijFUnzbO4gJ4nRCsLV7HFw9VnUKXAUPR1JIn3ktheTQSCpJt2Cd1zPZgZs0
         68Ng==
X-Gm-Message-State: AOJu0YyxijmJ0u30gNextLaPKMy/ZFAc/mKky0TL/dyMRrQZYnJuGXOI
	VWN/mIWGuLEiCTgQmDZHUZMOwgS4CFnaG7yPeyig/nNNTl0lXxVrADV5jamBAy4LGAQrmSK+2RU
	EsaFgISB4SNBm3n6tGhalvCy99c4Fs7urSkvLbB/UYOgIzjHy3syLMLcOrCC3SALTCbfAukVur9
	E4sBaN4LXrVm44oWXRRebTzxKMXbBVn0w=
X-Google-Smtp-Source: AGHT+IFvCN7OJ47OliZuHF+F6SZwHJvJOtHHqhXWSZq7DLxhATMKUb5NKWIlhsqiu0gI3E0gMagNgYMmzg==
X-Received: from wmrc6.prod.google.com ([2002:a05:600c:ac6:b0:46e:1f26:9212])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3b07:b0:477:8a2a:123e
 with SMTP id 5b1f17b1804b1-47a8f916502mr130881835e9.33.1765813533898; Mon, 15
 Dec 2025 07:45:33 -0800 (PST)
Date: Mon, 15 Dec 2025 15:45:28 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251215154533.3154405-1-tabba@google.com>
Subject: [PATCH v1 0/5] KVM: selftests: Alignment fixes and arm64 MMU cleanup
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org, 
	pbonzini@redhat.com, shuah@kernel.org, anup@brainfault.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

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


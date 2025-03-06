Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D1C2E339F
	for <kvmarm@lists.linux.dev>; Thu,  6 Mar 2025 11:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741258848; cv=none; b=u8KHDw0eCjRnuFvqUd7qpTP8Zx1nOmgUnH3a4v32vrkcjSZ8LoEYupcDU4+DUeci67H71c57Fs/LG+VqogU7JkVZM8WKzRVvWPbK9uGm4Yqk83WzylKTfm8QwTToqDXTru05cO3L9ZpbPj3I5Jbxvv3jqtOyEaOxI0wJE8kSBHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741258848; c=relaxed/simple;
	bh=cXOUGzXJisDnk0/ye+2VvQdHhCVvaIPyZYsa3alQEpw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=GWnfjgd/qemGA0z2BVnqC6mgajq9oJeEdp+wp1Dmo3GxrKTEE4QDG6+wgL42wWtG1QGJVvEwnfCVD7+rm1CfYBS/ol9uqJ4llCXqWgswIheiIJbF80fAlJ+xhBzBUyFJlXkFAMeW7S0m8tnTo0Bvq9PgE/PjlFINUdb8Vvfqjdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uPczNifK; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uPczNifK"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4394c747c72so1942245e9.1
        for <kvmarm@lists.linux.dev>; Thu, 06 Mar 2025 03:00:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741258845; x=1741863645; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PvJOjZ7gASzBfvYGoJZPS5obCWwIrSTS1iwOGHLb12c=;
        b=uPczNifK2QqU3qhDZ8hfLwokQ4GKJgIf++3uxaj4uhBVXhjtu+SnWPs3NtiShmlkJ0
         tbawPvDggEmc5+IJAtm+N1fuxQSgPnZqaRV9+Wb2aSePNWfS8pOJyhcCc4b4S/o+8F9V
         asU10doMMzLgXYthfUcNABAGyp6/Ge5JlQCBEOoA6Ef09rbcLMtTkkKtQTSZdWezWw1+
         HE0Gr1yvbQ6oBTte/jFdn08HkTzfnmXrBAYr8wr3OS3IgyTSLNHyWuJAYyK4uucRyRwh
         NTIdb/3uEWu3T/ZXKhuuz/SB5IJfFQTNRuYDFdqSX0EGExbJ4txCCPxw+RhXDQBfyPnA
         GyjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741258845; x=1741863645;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PvJOjZ7gASzBfvYGoJZPS5obCWwIrSTS1iwOGHLb12c=;
        b=AY2AqxSZNueul/me4zihrtt8pMSsiyYrvevf6QHPZ8r8X0rMkvyYWNe2vmOhF37sF1
         UH9NfXyS5UWo5qtH/f3cvijO3lRJIBgHMghCDzTbSezkSsIG0Onbxc90PadEbHD2NaOp
         NMNWm4pIOCnXjbWaiCN0YYhxUTLdJp7LHz51m8Wm086c+Inc8t+zw7IqtjyP+yD0mJPh
         3+RKrwnTC+pXIizmqBdq4OHfaGDB0Laj1Z4XiTi5rvp+vyqVnVGEHriFUWQYo8D2h5N2
         vrBZuNqix8NhcS5Nx0w0QEJA7N/0tzb2PmHHb9QzMFkJTzMpvEhQScZgAWx8cVCTcVFx
         mC/A==
X-Forwarded-Encrypted: i=1; AJvYcCXYTFVzvBhpPrkQnz6PKIoonGRM71LbbDjyRiaoPzrUS21QxCYXy+DMTpS60dLWlYIJ81MJTyg=@lists.linux.dev
X-Gm-Message-State: AOJu0YzzjjQEQVfDXDT7K095SQ49KXWbEsG4+yUUSC0zMYoC/Yefnfwn
	NxTvT9JtFVc2DSKkzCFLlRAvCktP8k7tPGahE+0DcyAlMSksbFXYBgS91dLKgttQhJ+eEHQ6w2N
	VUUsxiRfRb3GMG7SP5A==
X-Google-Smtp-Source: AGHT+IEGIm+qxrHFi7YMwd4v2mWCai/lo65N8Xe9xbdmYtOuCPL/1azW8IfDSK4oVWN0pRfPGkpSLhGS4zv1Dg9I
X-Received: from wmbet7.prod.google.com ([2002:a05:600c:8187:b0:43b:c6a4:89a0])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:190f:b0:43b:b756:f0a9 with SMTP id 5b1f17b1804b1-43bd295286dmr61943825e9.11.1741258845390;
 Thu, 06 Mar 2025 03:00:45 -0800 (PST)
Date: Thu,  6 Mar 2025 11:00:29 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250306110038.3733649-1-vdonnefort@google.com>
Subject: [PATCH v2 0/9] Stage-2 huge mappings for pKVM np-guests
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

Changes since v1: https://lore.kernel.org/all/20250228102530.1229089-1-vdonnefort@google.com/

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
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 236 +++++++++++++-----
 arch/arm64/kvm/hyp/nvhe/mm.c                  |  86 ++++++-
 arch/arm64/kvm/hyp/nvhe/setup.c               |   2 +-
 arch/arm64/kvm/hyp/pgtable.c                  |   6 -
 arch/arm64/kvm/mmu.c                          |   5 +-
 arch/arm64/kvm/pkvm.c                         | 129 +++++-----
 11 files changed, 342 insertions(+), 159 deletions(-)


base-commit: d082ecbc71e9e0bf49883ee4afd435a77a5101b6
-- 
2.48.1.711.g2feabab25a-goog


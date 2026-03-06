Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6AAF3ACA42
	for <kvmarm@lists.linux.dev>; Fri,  6 Mar 2026 14:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772805759; cv=none; b=X0Eh+nGtl8YDgHVMdN3nsh4pKdQ7OjyaJVy5MvqCgB6NP2Sw8VfCZ5MkhPF/Kh09kspknHAS1TSDFezGeg7rzmbGvEJr3CjUhthl5PEXLI4xD4jjHxncsOwhITaEO5GTxoy6892zc6/cqWi4tbyUjlCrPJXNGimhpWGCEoxEFuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772805759; c=relaxed/simple;
	bh=qk5cae16ltKMUDI2zPQaSJkz6t/UCHYIXsZ20NA/4lQ=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=MgStrAxqiySFJeoXAb1G8iaDWJw85qlBpye1dDhdvw5X6JTwMM/RT8NXIakD3W35BNjXYPeZwkaV1fsOWsbnf1Bl2ViDxGszOImtFRIVgLzQY1g0A63kcUfK/4qVwbXV14nF1jznO1Q3La5eB1Dw2hJ1Tq0TVjEFiT+EgxtmpGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KwwXUzJY; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KwwXUzJY"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-661ad73d41eso1232250a12.0
        for <kvmarm@lists.linux.dev>; Fri, 06 Mar 2026 06:02:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772805754; x=1773410554; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BwOlgh6ZUE7+ip/EGV9A/3opBVCZWrRyXJLI+YqAKL0=;
        b=KwwXUzJYrD3kmWIor8tTafkF9De2RUqnvh6zv6GmUH/X/fcoMmCLLfMDAmxBvrMajF
         nKri4x0JWDK9w49vFZMIMUzq+kZWhSyEWKjy2Z2kEd36U9PCU8SoXv+XQGtMokMFAnuc
         e+Ua5LjJqxo+sye8gcCBIpRyyfeBE5RXE+agE0TNFPEo3hlemddczX8W2eyep+OCAmKP
         e7fgzy2R6CAf2t0digixKmM2lFIlwYOYCHHKK/K3ClqxNWoyUPMhzUMj+vmdMFnVq/57
         ri6ixKqaI6ozDUyocLff512YEcGhpMmQC9d6lmw5lqXBYNCAi55fceAceqrAF3a8XT/G
         76zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772805754; x=1773410554;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BwOlgh6ZUE7+ip/EGV9A/3opBVCZWrRyXJLI+YqAKL0=;
        b=bwnrFKDv9uQzGjPeK6jq9u68rZXorKhjDzeI9Q4ApAMBSXiSjZpZII1PCxdfJtB202
         MTl06T9JJQzhv7IjnS5sGYizskDvjIp5raTg9ljeWTNw8AnPigYs7dtpsnBgFe5ce1Sy
         XpanzEzNceGDWdIAOZagqynEHEYMvcFV+XiLK3h+X6mBMZllARF2zhrO/f6YwQDiACMg
         Sw10ujK+Yf6lRDvEV/L3Yeo2byr6aobd50hYI59lRypWFjORf3bPfzyuKJZVFg6m5Qzm
         ZcHJDnvP+rjoNdHMqzSRC/UzW2Nli7GZGo7DYwQbclh4US4cBm2R6MXxZKCDnTEg+w6o
         J23Q==
X-Forwarded-Encrypted: i=1; AJvYcCWFMR0/oTYMzOSnc3+xojJP60RlLZMss63cg0EJ/uKIyIFABxJigpvwGWJeBAJM9bebpJ/S6Cc=@lists.linux.dev
X-Gm-Message-State: AOJu0YweN4ny8YOHbMsj4hvrNWPqsDZy4fBIMDI6c0tDtM0yhI7eK4Or
	fyFkXLcchDQAvlhyTBN0lhwZjwO5vYNGGAMcaKo6H5KdBKzbXKbdzcs5i9czi34GNCFYmaUyGCr
	p5A==
X-Received: from edb22.prod.google.com ([2002:a05:6402:2396:b0:661:257c:8537])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:354a:b0:65b:f3d5:ae79
 with SMTP id 4fb4d7f45d1cf-6619d4650damr1116541a12.10.1772805753773; Fri, 06
 Mar 2026 06:02:33 -0800 (PST)
Date: Fri,  6 Mar 2026 14:02:19 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260306140232.2193802-1-tabba@google.com>
Subject: [PATCH v1 00/13] KVM: arm64: Refactor user_mem_abort() into a
 state-object model
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, qperret@google.com, vdonnefort@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

As promised in my recent patch series fixing a couple of urgent bugs in
user_mem_abort() [1], here is the actual refactoring to finally clean up this
monolith.

If you look through the Fixes: history of user_mem_abort(), you will start to
see a very clear pattern of whack-a-mole caused by the sheer size and
complexity of the function. For example:
- We keep leaking struct page references on early error returns because the
  cleanup logic is hard to track (e.g., 5f9466b50c1b and the atomic fault leak
  I just fixed in the previous series).
- We have had uninitialized memcache pointers (157dbc4a321f) because the
  initialization flow jumps around unpredictably.
- We have had subtle TOCTOU and locking boundary bugs (like 13ec9308a857 and
  f587661f21eb) because we drop the mmap_read_lock midway through the function
  but leave the vma pointer and mmu_seq floating around in the same lexical
  scope, tempting people to use them.

The bulk of the work is in the first 6 patches, which perform a strict,
no-logic-change structural refactoring of user_mem_abort() into a clean,
sequential dispatcher.

We introduce a state object, struct kvm_s2_fault, which encapsulates
both the input parameters and the intermediate state. Then,
user_mem_abort() is broken down into focused, standalone helpers:
- kvm_s2_resolve_vma_size(): Determines the VMA shift and page size.
- kvm_s2_fault_pin_pfn(): Handles faulting in the physical page.
  - kvm_s2_fault_get_vma_info(): A tightly-scoped sub-helper that isolates the
    mmap_read_lock, VMA lookup, and metadata snapshotting.
- kvm_s2_fault_compute_prot(): Computes stage-2 protections and evaluates
  permission/execution constraints.
- kvm_s2_fault_map(): Manages the KVM MMU lock, mmu_seq retry loops, MTE, and
  the final stage-2 mapping.

This structural change makes the "danger zone" foolproof. By isolating
the mmap_read_lock region inside a tightly-scoped sub-helper
(kvm_s2_fault_get_vma_info), the vma pointer is confined. It snapshots
the required metadata into the kvm_s2_fault structure before dropping
the lock. Because the pointers scope ends when the sub-helper returns,
accessing a stale VMA in the mapping phase is not possible by design.

The remaining patches in are localized cleanup patches. With the logic
finally extracted into digestible helpers, these patches take the
opportunity to streamline struct initialization, drop redundant struct
variables, simplify nested math, and hoist validation checks (like MTE)
out of the lock-heavy mapping phase.

I think that there are still more opportunities to tidy things up some
more, but I'll stop here to see what you think.

Based on Linux 7.0-rc2 and my previous fixes series [1].

[1] https://lore.kernel.org/all/20260304162222.836152-1-tabba@google.com/

Cheers,
/fuad

Fuad Tabba (13):
  KVM: arm64: Extract VMA size resolution in user_mem_abort()
  KVM: arm64: Introduce struct kvm_s2_fault to user_mem_abort()
  KVM: arm64: Extract PFN resolution in user_mem_abort()
  KVM: arm64: Isolate mmap_read_lock inside new
    kvm_s2_fault_get_vma_info() helper
  KVM: arm64: Extract stage-2 permission logic in user_mem_abort()
  KVM: arm64: Extract page table mapping in user_mem_abort()
  KVM: arm64: Simplify nested VMA shift calculation
  KVM: arm64: Remove redundant state variables from struct kvm_s2_fault
  KVM: arm64: Simplify return logic in user_mem_abort()
  KVM: arm64: Initialize struct kvm_s2_fault completely at declaration
  KVM: arm64: Optimize early exit checks in kvm_s2_fault_pin_pfn()
  KVM: arm64: Hoist MTE validation check out of MMU lock path
  KVM: arm64: Clean up control flow in kvm_s2_fault_map()

 arch/arm64/kvm/mmu.c | 379 +++++++++++++++++++++++++------------------
 1 file changed, 224 insertions(+), 155 deletions(-)


base-commit: f9985be5e1985930c2d2cf2752e36bb145b3ff7c
-- 
2.53.0.473.g4a7958ca14-goog


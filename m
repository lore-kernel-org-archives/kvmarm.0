Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8FDB3749F4
	for <kvmarm@lists.linux.dev>; Mon,  3 Aug 2026 10:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785751855; cv=none; b=YqznVzYrurjlTyJp2W6o7BfrzACdiUbdaeTd2GODYmn47LmgXkVuMQzMqgMPPL/8otnKhklBY68Si+gSZI9L8+PBBklbhSVMEutsgh3eU7omg5cGUODCogFLT0bF/6UEuSGnfx61y6VJ4p8frOuuNl90uCMfhHCyZxTOlSZ6OnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785751855; c=relaxed/simple;
	bh=0eWejNOlF67/67v6jq5w8EToETFQ+7hdv+rkAknNl0w=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=RWoAuLmk7oQWfeKYqm3jSf0twr4u6SoKkwoiLOYmPaUL0NLqFTun8X31lXrPj0E0EpJZ/KnsoWILDByXlQ5iXRXMvZ7HGUaaQ8GsVRPEkmYU4KXVe64EHBEWoMC6ZaRIErJ6wJkS/3e+kf7ufj3Ia5TxLPEHOxu51BBNmtJRPDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nQ5dkn/c; arc=none smtp.client-ip=209.85.128.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nQ5dkn/c"
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4955fd77c18so11872145e9.2
        for <kvmarm@lists.linux.dev>; Mon, 03 Aug 2026 03:10:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785751851; x=1786356651; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=//RZJaGyoeI1RxifgtDLFRHQpm92KEJu8DMKbfF6oOo=;
        b=nQ5dkn/clr4OR62SpzHPDo6UkwOSPHHjLcbqp1BYcL4ufokGHt3P1f6Ad5FG7yoiUG
         NLCPP9pHGBF0wsarVG3RLrbVdmofKBoW7cF0wRKlq7TdjQ4jevSL7uhY200fjL2OPSmV
         jucggnk6qWmXgtMm5LSi5TDIPEUWWKs3KQJISsWcFIPFSAjNAvVU3qnPZd1InrkMcjqF
         ofZ/cWYp0h4dEM1OrgsUHjOw2uKmf1dHZrIIhqgKilUWOtsee9amgsjFmxMe5FF5Umli
         T+/+mbkcpai5gYSVXYlYc5aeb8zIkOSjk1PTNBLGfL5GaRmsYNlzU24BMUbOlF2VvGfu
         d7Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785751851; x=1786356651;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=//RZJaGyoeI1RxifgtDLFRHQpm92KEJu8DMKbfF6oOo=;
        b=msmRF9Bq1gIha+u+IImYoiM5I91XW+tUDOgU1lDi6qlHIw3nD4ptYLvy0SqfbYF0rv
         xX504fGt4dJoEqRaIudCCcalXimVeGgftPkwYNZZI6F4L48twoUEO24oPw051kLrq2OU
         sFf7ssnDK6vbWmsiwAyiFPYpYYrtEW5kd9ccfvIxmywwK1I6hM62wUdsIiSNxsTlu+Ot
         HqHnGpZBGBYnpfhWNf7LgWXuNBnT7id3fa2DG5Ut/ysO3bbu9vxG6fIm0PJiis6n2DS5
         nwsM9xSmKalu59tl8pkeBEGzY57LOqCx42PlxtYSjgqxBaekSfMfTWr8WQnS+1Qe9cjt
         uI/w==
X-Forwarded-Encrypted: i=1; AHgh+Rp6qobttipHwBi7vgo0apOvJJ7pGDJAqwyInGcIpncw9pEHYoBRSGygW+cPcTzDYuFXQBM/39Q=@lists.linux.dev
X-Gm-Message-State: AOJu0YytNK+AQ808BecHg7HchglMn8K8CgU19ou3JkX8NGhlk4BP0zds
	fNg8H6Xwnp+P5Rfo2P1p1FLzwP9HWVHE2XsoA+MwDFCq0byv6WlgKlPdkfCQvu/AEUPiQl/iSjq
	OsHf4TqTvVvQc6nB7Z5CRkw==
X-Received: from wmrk14.prod.google.com ([2002:a05:600c:b4e:b0:493:b4d4:96bf])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8b54:b0:495:4859:8f9b with SMTP id 5b1f17b1804b1-4980c674f25mr238962235e9.9.1785751851273;
 Mon, 03 Aug 2026 03:10:51 -0700 (PDT)
Date: Mon,  3 Aug 2026 11:08:44 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260803100904.3563942-1-vdonnefort@google.com>
Subject: [PATCH 00/20] Huge mapping support for protected VMs
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	keirf@google.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Currently, pKVM handles stage-2 mappings and ownership tracking strictly
at the PAGE_SIZE level. This series extends pKVM to support PMD_SIZE
block mappings, thereby enabling Transparent Huge Pages (THP) for
protected guests. hugetlbfs is currently unsupported as it does not
appear as swapbacked.

Summary of changes:

1. Enable host stage-2 block-level annotations:

The host stage-2 being annotated with the GFN of the guest on the
host->guest donation transitions, we allow block-level annotations to
ensure the host stage-2 mapping size matches the guest stage-2.

2. Expand ownership transition HVCs:

Enable the ownership test to work with PMD_SIZE so we can test
transitions supporting more than PAGE_SIZE.

3. Implements the `PKVM_HYP_REQ_SPLIT` hypervisor request:

Allows the hypervisor to ask the host to split a mapping. This ensures
the guest s2, pkvm_mapping tree and host s2 are always using the same
mapping size.

4. Wires up THP support for pKVM guests.

Keir Fraser (1):
  KVM: arm64: Prefault host stage-2 entries on block split

Vincent Donnefort (19):
  KVM: arm64: Propagate host stage-2 annotated entries on block split
  KVM: arm64: Allow block-level stage-2 annotation
  KVM: arm64: Use block-level annotations when setting up the host
    stage-2
  KVM: arm64: Make pKVM ownership selftest an HVC
  KVM: arm64: Add a range to __pkvm_host_share/unshare_hyp()
  KVM: arm64: Add a range to __pkvm_host_donate_guest()
  KVM: arm64: Add a range to __pkvm_host_reclaim_page_guest()
  KVM: arm64: Add a range to __pkvm_guest_share_host()
  KVM: arm64: Add a range to __pkvm_guest_unshare_host()
  KVM: arm64: Add a range to pKVM ownership selftest
  KVM: arm64: Handle huge mappings in
    __pkvm_host_force_reclaim_page_guest()
  KVM: arm64: Handle huge mappings in __pkvm_vcpu_in_poison_fault()
  KVM: arm64: pkvm: Warn on guest stage-2 block collapse
  KVM: arm64: Add pkvm_hyp_req infrastructure
  KVM: arm64: Add __pkvm_host_split_guest HVC
  KVM: arm64: Extend pKVM page ownership selftests to cover guest block
    split
  KVM: arm64: Add PKVM_HYP_REQ_SPLIT
  KVM: arm64: Raise PKVM_HYP_REQ_SPLIT on guest to host sharing
  KVM: arm64: Stage-2 huge mappings for protected VMs

 arch/arm64/include/asm/kvm_asm.h              |  12 +-
 arch/arm64/include/asm/kvm_host.h             |  19 +
 arch/arm64/include/asm/kvm_pgtable.h          |   3 +-
 arch/arm64/include/asm/kvm_pkvm.h             |  21 +-
 arch/arm64/kvm/arm.c                          |   2 +
 arch/arm64/kvm/handle_exit.c                  |   3 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  25 +-
 arch/arm64/kvm/hyp/include/nvhe/memory.h      |   5 +
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |   6 +-
 arch/arm64/kvm/hyp/nvhe/ffa.c                 |  12 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  47 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 545 ++++++++++++------
 arch/arm64/kvm/hyp/nvhe/pkvm.c                |  59 +-
 arch/arm64/kvm/hyp/nvhe/setup.c               | 152 +++--
 arch/arm64/kvm/hyp/pgtable.c                  | 113 +++-
 arch/arm64/kvm/mmu.c                          |  72 ++-
 arch/arm64/kvm/pkvm.c                         | 247 +++++++-
 arch/arm64/kvm/trace_pkvm.h                   |  44 ++
 18 files changed, 1036 insertions(+), 351 deletions(-)
 create mode 100644 arch/arm64/kvm/trace_pkvm.h


base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
-- 
2.55.0.508.g3f0d502094-goog


Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5236E39EF17
	for <kvmarm@lists.linux.dev>; Fri,  1 May 2026 11:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777634514; cv=none; b=oM/U3VAcvl5QW7BI9lLyHv63zjwlNk5uE8VRVkF5H/o0Ky3na4jMcflAOwUnhCCHn1s3AAkBzcMyLZN0Axhk9RCpJdi5yO26Qsz5kEQQoAq77AOHUM7xXpSMQ6yuRovVn9J2p/qBmRz13LVV2+ytADXv0PUbgGIlDfHPsqFfnQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777634514; c=relaxed/simple;
	bh=qUux5fWnaB7vwSuaIK7yJ/xoTOk1kHLhaO5Fj32opLY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=T1/S8YWRlHPF5MSierIWSH1xZPfh45DNnF0ntDWkgwWAtCe8ATfwt106pst/Pdro0JkiXS0c8ql/vkoRWHq9LScTcx//tZX10qKCSHm+JQhlHaHdg3m9Kr4HFN1qVl5KjFIi74et9r/9RGf6jfVnMYVmHEBxX8T2x/TwWlBdrI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c9PCeKOV; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c9PCeKOV"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-44a3aee3813so429404f8f.3
        for <kvmarm@lists.linux.dev>; Fri, 01 May 2026 04:21:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777634511; x=1778239311; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OsvmNiIFOjSLSp4rcDSw+qNHN7ZNglz3VqzWWNlV7vU=;
        b=c9PCeKOVkhJ59VNxGgrcnuPSEnxxsSpVY74K0JXp2VJfdcd+7s4IK7Nvbeh1j/o/Ur
         wY/8Go7uitKY1dmrupWH0UUfBOuTxslSwzjKsvqZ/AzZSHw4u6zmyplmc1kRx2aXp3i8
         vfwNm4annUfVOAkxQ5RMIBllWe+yw4/40GW6UFIgU7Pu3q/FQmNmWWNxhWEel4KrIydR
         PsxdmW99QhfEdDq99n1XcSNZu5xO0LpXEvzB9WDbEDFy1QL07a7dk+tv3/XWt3HvWMT4
         Xpgm/HXTLolBRA5jT+Pg3LEslmWbyN86zk38soprlwBgooOW+rgWy0pOVdBdmxvGEeIe
         T0ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777634511; x=1778239311;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OsvmNiIFOjSLSp4rcDSw+qNHN7ZNglz3VqzWWNlV7vU=;
        b=kHTk7FZiEnXFRPffpK3lD+svWH4+JcbnThsPjlUqTVvsovJSGhU9n5/S3T7wenbX5f
         wzkbVwmDjvauR8Zc2p1W+7WQz5lWrtheYP/GsPBS64K0nS0MJPVPTyv4ATuJY3CUOc92
         MYiQVS5d36MAs/uHNMNGj+SDBCBNGvm6EO1pJJcyzM5u+J8A6c7b7up+QQbuyGqHPCPV
         YbFu1J3Qh/lfUmtJTpTlnvEf/1/TvGaU1CXTD9oJxQmv8y0hmxeFY8rMEs2h/8QY79Dy
         I1L2FDaURAjfQd4HUyOYZWZV6bPHygWkKhWqtE+4L9fuJoWGp57Q7XRce10J6qPSvxYX
         /HlQ==
X-Forwarded-Encrypted: i=1; AFNElJ9u4YbWQlmiNlzFkI1llqbLHM8S6j0I1IXeO7hq5qOzi6KireGkIEeMpkZbmH7KmNrb92Uqsc8=@lists.linux.dev
X-Gm-Message-State: AOJu0YwMU6B2O5TGZph4YtE96jfKC31UUy8HOjZpJMSRL1gWMBPJupTY
	X8znP/F1aM9FNmUjy8q0ITqpQz9ABmH9Y6Mu3MFqJPlQNwyaAeEugj8ep8me3Nzcunuid4UIRiQ
	xUA==
X-Received: from wrbgg9.prod.google.com ([2002:a05:6000:2f89:b0:449:ba46:e362])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2f8a:b0:441:1cf9:4f06
 with SMTP id ffacd0b85a97d-4493fed64c0mr11269061f8f.31.1777634510466; Fri, 01
 May 2026 04:21:50 -0700 (PDT)
Date: Fri,  1 May 2026 12:21:43 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260501112149.2824881-1-tabba@google.com>
Subject: [PATCH v2 0/6] KVM: arm64: EL2 synchronisation and pKVM stage-2 error
 propagation fixes
From: Fuad Tabba <tabba@google.com>
To: maz@kernel.org, oliver.upton@linux.dev
Cc: james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	qperret@google.com, vdonnefort@google.com, tabba@google.com, 
	catalin.marinas@arm.com, will@kernel.org, yaoyuan@linux.alibaba.com, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi folks,

V2 of the kvm/arm64 audit fixes [1].

Changes since v1:

    Patch 1 (SCTLR_EL2.EIS|EOS): Fixes: tag corrected to 0a35bd285f43
    ("arm64: Convert SCTLR_EL2 to sysreg infrastructure"); the commit
    message now explains that the conversion auto-generated
    SCTLR_EL2_RES1 to UL(0).  Code unchanged.

    Patches 2-3 (NULL vcpu guard, __deactivate_fgt typo): unchanged.

    Patch 4 (new): Seed selftest_vcpu's memcache to mirror
    hyp-main.c's pkvm_refill_memcache() flow; required by the
    pre-check in patches 5-6.

    Patches 5-6 (host->guest share/donate, formerly v1 patches 5-6):
    reworked to pre-check the vcpu memcache against
    kvm_mmu_cache_min_pages() during the existing pre-check pass,
    before any state mutation.  The WARN_ON() around
    kvm_pgtable_stage2_map() then asserts an invariant the pre-check
    pass establishes, rather than swallowing a reachable -ENOMEM.

Dropped since v1:

    - Patch 2 (HCR_EL2 sync): failure path not reachable.
    - Patches 7-8 (guest->host share/unshare): the stage-2 map cannot
      fail at those call sites (the leaf already exists).

Carried `Reviewed-by` tag (thanks!) and added `Assisted-by:` tags.

Note that with `review-prompts` in the `Assisted-by:` tags, I am
referring to subsystem guides that I added to the base prompts [2],
which I plan submit for upstreaming.

Cheers,
/fuad

[1] https://lore.kernel.org/all/20260428103008.696141-1-tabba@google.com/
[2] https://github.com/masoncl/review-prompts

Fuad Tabba (6):
  KVM: arm64: Make EL2 exception entry and exit context-synchronization
    events
  KVM: arm64: Guard against NULL vcpu on VHE hyp panic path
  KVM: arm64: Fix __deactivate_fgt macro parameter typo
  KVM: arm64: Seed pkvm_ownership_selftest vcpu memcache
  KVM: arm64: Pre-check vcpu memcache for host->guest share
  KVM: arm64: Pre-check vcpu memcache for host->guest donate

 arch/arm64/include/asm/sysreg.h         |  2 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h |  2 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c   | 24 ++++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/pkvm.c          | 16 +++++++++++++++-
 arch/arm64/kvm/hyp/vhe/switch.c         |  3 ++-
 5 files changed, 43 insertions(+), 4 deletions(-)

-- 
2.54.0.545.g6539524ca2-goog


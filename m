Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D2F2D4B66
	for <kvmarm@lists.linux.dev>; Tue, 18 Nov 2025 10:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763462291; cv=none; b=mugccQ7LdoVtSNCAbac6DJTwSe4OzqV7fapBipmDpHrXmlE9iO1PvMD4v5Ylp4NWYAXwt9vKW27dt+5IUbL9urbEcxgD/R6UGoUqU8RtVUqLAzGC9Wb+Y87z+FOIQYHClIzwLHa93e/QB/x55mKDQLK+113XpVvr8/0Mhm/mEFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763462291; c=relaxed/simple;
	bh=pE3jJd7UHpJXmJt/9kmFtYwEQTumWVI/eaeO0kVtYgk=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=kfkrxNcaNS+8Qi4KsAhe8WlqjuOP7xSK1lNuanGFMkeoUsVo4atGNdPEgP+oraC2NHkPI0wZvXvCAVM9lWTRpRXZf7MR0W7zmoh13Hf2Ot7sdHLkLMhWUWGcvRFUK5Rwv0CEIRvBvubN64JjHHmc8IKBUDrzm9BBrD3VOAuaDm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1wOztKvL; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1wOztKvL"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b7270cab7eeso464924666b.1
        for <kvmarm@lists.linux.dev>; Tue, 18 Nov 2025 02:38:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763462288; x=1764067088; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=opTLkJ9rWZdOh6NllMm8SZ1k9obnWdX+EkDUkDwUBBE=;
        b=1wOztKvLbgbPRThvRTyL6ggH/6JF5XjhFspniyR/PyZ1VPvyRiutezgV9O+1mBM7B1
         C9wVDgE/ZRcsYb8+ba/5GDNNZyLeFJZ0KLBzKVFk38M2BygqC1PrCsjwQcJHh9pa9AI8
         tPtDzgZYEawaq+oT4shAWcBFAoCS5Mnwk66UthL3zHtE6ZrEibw0o3GAxRiGMRAxF39d
         Fot7gffow/J9y432kSRfOb4iKOFzR+dvDFgr8BCnxKiKprb3MDDFVKrKoG1XyHugtJFA
         eBBcPaVM2QGQ3PkFXEon8lOXjRQVcU/uG37lXeFQZ5OUVgLgeXcXaC81Cn3ANuf446We
         Kf6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763462288; x=1764067088;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=opTLkJ9rWZdOh6NllMm8SZ1k9obnWdX+EkDUkDwUBBE=;
        b=DC1Lk2CuyIWUEynjcvnq9Sct5Ajywr+vP0XhT8zAQh1l0GxdNALbfjPLX2Jglu4jaW
         yfO40Z3gOmhab++fiiBaHW9CWNkHDB+C7r0G/idE/3o5iROQSDOzf4B6qMT16fPmlcFg
         v3Snps0eKjvYqWu44K3lF0ljPn4LUeaVtqEq6DFweQpRpmvfZmz+mM1lfCC0tpc/79UC
         oGJLg6IQJcX1I5l9oaH7MMGIXNtj7ZwNnrKK6RDaUPtskzyYsAeC2NIoqha1DRmMG7te
         eRNFni/Ts4rCWBNGsLeckpEzvH/Tt9dhC6LSp3wEjrTh3KGFN9rUtVGdvbdwUokwPvVl
         6+Fw==
X-Gm-Message-State: AOJu0YxYNQErtI82ODzhn2DCbO6lOlM+RomPw2me4X1FMg9ND0t6Q8Aw
	bNnEIlD2wAqRajRUR+RiXmy1mopJAGZh+vuM3CAYLOh9yohWraaerOyeRdwaCZCmm1YsnQpoZa4
	SfFWYNoaWgc4aXUe6xjTd6kfZIvAmaYzYRVnX1j20qdLrimiWb+P8UNarwNdUaXSVs8YJE1ZqOv
	G9b0kpcgcFny5eR85Wyc5YhIeHLkABTco=
X-Google-Smtp-Source: AGHT+IHa7FWLOGKg8Thm7QDDUPlVzXaAEWqWomimgzOkWsb0FL5ju0E2rB0g4YLHEY/ASv5Z648Auwd6KA==
X-Received: from ejchw14.prod.google.com ([2002:a17:907:a0ce:b0:b72:41e4:751c])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:1c9c:b0:b6d:7b77:ff33
 with SMTP id a640c23a62f3a-b736782c351mr1442681866b.19.1763462287893; Tue, 18
 Nov 2025 02:38:07 -0800 (PST)
Date: Tue, 18 Nov 2025 10:37:57 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251118103807.707500-1-tabba@google.com>
Subject: [PATCH v5 0/9] KVM: arm64: Fixes for guest CPU feature trapping and enabling
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, vladimir.murzin@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Hi,

This series contains several fixes for guest feature trapping and
enabling, as well as a bit of tidying up.

Changes from v3 [1]:
- Add a map of KVM capabilities to IOCTLs (Oliver)
- Based on Linux 6.18-rc6

Cheers,
/fuad

[1] https://lore.kernel.org/all/20251110134525.3768197-1-tabba@google.com/

Fuad Tabba (9):
  KVM: arm64: Fix Trace Buffer trapping for protected VMs
  KVM: arm64: Fix Trace Buffer trap polarity for protected VMs
  KVM: arm64: Fix MTE flag initialization for protected VMs
  KVM: arm64: Introduce helper to calculate fault IPA offset
  KVM: arm64: Include VM type when checking VM capabilities in pKVM
  KVM: arm64: Do not allow KVM_CAP_ARM_MTE for any guest in pKVM
  KVM: arm64: Track KVM IOCTLs and their associated KVM caps
  KVM: arm64: Check whether a VM IOCTL is allowed in pKVM
  KVM: arm64: Prevent host from managing timer offsets for protected VMs

 arch/arm64/include/asm/kvm_arm.h         |  2 ++
 arch/arm64/include/asm/kvm_host.h        | 42 ++++++++++++++++++++++++
 arch/arm64/include/asm/kvm_pkvm.h        | 33 ++++++++++++++++---
 arch/arm64/kvm/arch_timer.c              | 18 +++++++---
 arch/arm64/kvm/arm.c                     |  7 ++--
 arch/arm64/kvm/hyp/nvhe/pkvm.c           | 18 +++++-----
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c |  2 +-
 arch/arm64/kvm/inject_fault.c            |  2 +-
 arch/arm64/kvm/mmu.c                     |  4 +--
 include/uapi/linux/kvm.h                 |  1 +
 10 files changed, 105 insertions(+), 24 deletions(-)


base-commit: 6a23ae0a96a600d1d12557add110e0bb6e32730c
-- 
2.52.0.rc1.455.g30608eb744-goog


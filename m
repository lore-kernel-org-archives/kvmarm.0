Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B925221577
	for <kvmarm@lists.linux.dev>; Thu, 12 Feb 2026 09:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770886977; cv=none; b=NphH2fg86/KRFbj28fauBY4lAzR6Yl6WlrTdnz5FSSViLBwKDPTtp41bBof3KZ2DtA8yP1KUmgJQrHNxnFrUmQ1Y/pF7FKAT8ChrKeA6nJBOchr3vLqZ5ExOtMbz+ZdoKuNpMu+kjS+PgUcMddZqybIJeoKnUL7L4Qig81xUUkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770886977; c=relaxed/simple;
	bh=yiRsdt570K13+Sp7adOYctz55UhJ5uxrG+YyJGo4m4M=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=dJE229ibYY0GBxD1TtlfankJ/yIa7knM+v+dLXe2G+S4/wcymqLQv4Ztwa946COW+GVLplVJJ1UB+7mSZ20okKvYD5dEt/KQcTyXnycECLQtAj1TcciPwuFuWRAqlWo3jXxwz9ezepIQWPNrli5QFEVrXwcFFDFEVZ0aI21aejA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4e3IGwvm; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4e3IGwvm"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b7fe37056e1so290000566b.2
        for <kvmarm@lists.linux.dev>; Thu, 12 Feb 2026 01:02:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770886973; x=1771491773; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3lZ/FXSzIrKV2ZCN0nh7sjPuVDRySXe1YLtlGIVn0Sc=;
        b=4e3IGwvmUmvlkBoRUcr35R5K6GYJJ4UsXj/KdNVxANWN8MdCeI/IWohBl7/i8FnDO6
         SouhFYRZHji9iPkkJ5VMiG+x/wTrSzsq7y1Yj5XdmmbzD9Cl8OWzStbN+EYtVX/TOESm
         sl7lYLRDpGdOWZYHWX7bOsKw9N13nrDWoqP/EtlvMGOJL0T4vqm5Z5l3ok4NjBsXmnaY
         OaC/onJ6PnlIXs4V0mWeK3ux8WisC5Rgx/ugiGQFUgH8POhZgaqEmMdDV87Nlkrl3lQT
         pa5t3gFHp5MCxOPaVHVrC959Ss9DDsV3NiqA0zwnmkJsFjAJxnPhUbWTS3HGTT2T/k3c
         iXkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770886973; x=1771491773;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3lZ/FXSzIrKV2ZCN0nh7sjPuVDRySXe1YLtlGIVn0Sc=;
        b=rCNbkDtuS8ULXcN8nlPgIrXyi6K9Q+J3S18g+cB82nvoSD6HMgh20shrj2tGbukvEq
         TUW6YShfBgykwbZ2iHtYLSdfuwYNLjItkyfvIHwkr9m797Cp3Rm0MGMrICc4IhUCbgQ8
         XcCoOtKEFye6ll/nv8x0zP+t2DC98FFtm+qbXP8U1CJt7gjou+NYXCHy3FHrt9xGT9gT
         K3ju33z2laFgR1oqDp8OTvdzNdS6rJcqgIV3QDl0e9Aod9HQu4FIiECdnxC43Dt50zmD
         S7/JmbcIVf75b7WFJggtqyLC1sWnRr8TIqA5g9qX0VpePVmU5Le/xO/aP2NApjrFFOKt
         hDXg==
X-Forwarded-Encrypted: i=1; AJvYcCXOQnLZkgGvmFY474EbfChjDHLE5s4w/4iXpXIk08Z/BNYgFD96LZ/jU3/HxwccEpgoKaeUD7I=@lists.linux.dev
X-Gm-Message-State: AOJu0YxzhgTTuq/s93AJ11cdNUsz9d0cM2YjMGzxZbkM7fFLAQvpLstc
	yE/mT2KUtgEqa6ahYFZ4NBCzLuxD9bAzUNAIa6zOg3Br9QA/OZAYg4I+m8xE8iRWn5Szexkym3z
	G1A==
X-Received: from ejdr2.prod.google.com ([2002:a17:906:38c2:b0:b8f:9c02:805c])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:fe44:b0:b87:322d:a8bc
 with SMTP id a640c23a62f3a-b8f92be341cmr98528366b.31.1770886973514; Thu, 12
 Feb 2026 01:02:53 -0800 (PST)
Date: Thu, 12 Feb 2026 09:02:49 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.239.g8d8fc8a987-goog
Message-ID: <20260212090252.158689-1-tabba@google.com>
Subject: [PATCH v1 0/3] KVM: arm64: Fix guest feature sanitization and pKVM
 state synchronization
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, tabba@google.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

This series addresses state management and feature synchronization
vulnerabilities in both standard KVM and pKVM implementations on arm64.
The primary focus is ensuring that the hypervisor correctly handles
architectural extensions during context switches to prevent state
corruption.

The series is structured as follows:

* Patch 1: Addresses an issue in KVM/arm64 in general where FEAT_S1POE
  is exposed to guests based solely on hardware capability. If the host
  kernel is built without CONFIG_ARM64_POE, it will not context-switch
  POR_EL1. Masking the S1POE bit in ID_AA64MMFR3_EL1 when
  system_supports_poe() is false prevents state corruption.

* Patch 2: Fixes a bug in pKVM non-protected guest initialization.
  Previously, pkvm_init_features_from_host() copied the initialized flag
  without copying the actual id_regs array. This caused EL2 feature
  checks (such as ctxt_has_tcrx()) to silently fail, breaking the
  save/restore logic for system registers like TCR2_EL1, PIR_EL1, and
  POR_EL1 during world switches. The fix initializes the ID registers.

* Patch 3: Removes a redundant kern_hyp_va() macro invocation in
  unpin_host_sve_state(). The sve_state pointer is already initialized
  as a hypervisor virtual address. While idempotent, the macro is
  unnecessary here.

Based on Linux 6.19.

Cheers,
/fuad

Cc: stable@vger.kernel.org

Fuad Tabba (3):
  KVM: arm64: Hide S1POE from guests when not supported by the host
  KVM: arm64: Fix ID register initialization for non-protected pKVM
    guests
  KVM: arm64: Remove redundant kern_hyp_va() in unpin_host_sve_state()

 arch/arm64/include/asm/kvm_host.h |  3 ++-
 arch/arm64/kvm/hyp/nvhe/pkvm.c    | 39 ++++++++++++++++++++++++++++---
 arch/arm64/kvm/sys_regs.c         |  3 +++
 3 files changed, 41 insertions(+), 4 deletions(-)


base-commit: 05f7e89ab9731565d8a62e3b5d1ec206485eeb0b
-- 
2.53.0.239.g8d8fc8a987-goog


Received: from mail-oi1-f201.google.com (mail-oi1-f201.google.com [209.85.167.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36FCC4499A4
	for <kvmarm@lists.linux.dev>; Thu,  9 Jul 2026 22:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783636636; cv=none; b=VHH3P7EJCZ1ix0r7N57fj0qR34aZsLVBLbbdIfGdIv+rBPu/df1J1xFeGcOXubawZXNukGcG9bgMaEoCPpz96cmpAFZaxvPCDfISkL6oc7LgulW5Z0PScxNu2JoiXAMEvAFM4vFusHVOhwqzySdR6AQW8o170HGEoR4JyT9sAVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783636636; c=relaxed/simple;
	bh=EaexnPqrmtpzjh8qzHPIamRGJjDLlHmrtHt32D9rGTQ=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=hW4ULk+O25NGrp+mOY3z4j18cAuB8bp/X3/tyMLJawwYP+611J4xBq+1VOJzaIt5Vi6zQxUTap3qRWNcqHlShomur8SAAO90uagDeLK8eFBptKqk0WN9xnyEtZcIVP1wc9+7nQbkTZCNPBAvR6tJVDCQcp1BWM7QfpsIYRY0zgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Rj9VSL7s; arc=none smtp.client-ip=209.85.167.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Rj9VSL7s"
Received: by mail-oi1-f201.google.com with SMTP id 5614622812f47-485fdae1db3so293070b6e.1
        for <kvmarm@lists.linux.dev>; Thu, 09 Jul 2026 15:37:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783636634; x=1784241434; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7wbRxqeXe6OhAyO1MWhkHUo2TrAk/KOd+lAMmZEbmWc=;
        b=Rj9VSL7sz5+8oDflfvWVNVPBpdC3CHmGtkai8neW8aUiRBgGOZbgJUap33vnNMRYRa
         Bu12I4CTMQRs8+pGXFSHsS3zhavOAV0dWPy3PLRvlXHyRaDkpJqKdz4y4Qtv1SYebkAG
         0TIooBl7FGS8YN3XPD6rKV7nMVhrzBIp82xKKqb8Xv2oPEk2OL137UWArvvnScWmzyfw
         BwtfX6G2l1caDJXaW9q/rpQvmBLUNQw6gjJCKCF7OwPdlr7mStx0nF0SVagP+HYpqpn0
         84KdMn43lLdUaaZwHhNFIvmavnNZusbt9AbmwzvXaU6UMMu71sSK4fJ5oVMSBe2kN0jy
         wIeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783636634; x=1784241434;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7wbRxqeXe6OhAyO1MWhkHUo2TrAk/KOd+lAMmZEbmWc=;
        b=iywjrdGQyX6aB/8ks9MFJYgexu4Md6Cvl0Z4IKprW9dcvKFBZsxkQeRNSnnjgkOCdG
         h3a1exR5cGznXM3HFGI5QvSoEJCt69mF0HsKYKHoZKdhCAFyUJQxybyd+smSCsKAXLja
         NBiGw/uxAR96eDAsa4huQBZE/PJ3nFBo/x7NQJvpKgCx5nIc9Zn3v7QqcnzLKEpnc6Oq
         GLqbij9szZO3a8TFRV9r9c5ICTWdpuFwFPXm+7ZubmrfREjDLmyjIjztEk+RVBfl4HqO
         pQLO+hPmKYr0NVdCJAgUPgkkO8gzdMmJBGG1bxDbrngaJ0VCpbBE9ZM8Uf6whHaGYM3M
         WAoA==
X-Forwarded-Encrypted: i=1; AFNElJ/ExnhPqnecqs4RR8lVj2hSPNZ8MKYg7eKQZonZpWx6xxSQe/I+ttTeoFzmC+rhGqPe5koi2II=@lists.linux.dev
X-Gm-Message-State: AOJu0YwLeQS6fThXqmmnwEapIZ8j7GTGThnlbX2T2OPOWVIfpnqWhF6Z
	/EhK42B51LCyVr8tvXn9R6dq4IxhibbodkUafDCDmC5TfQGlyR7qCzl3s2FntWbwy2MwvTcBKOO
	nv530TvZE+njm7iWGkO7+RX1Wjw==
X-Received: from ilax6.prod.google.com ([2002:a92:d306:0:b0:503:4f93:1524])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:c410:b0:48c:3b4:2b95 with SMTP id 5614622812f47-4a2042c6d24mr8647572b6e.29.1783636633855;
 Thu, 09 Jul 2026 15:37:13 -0700 (PDT)
Date: Thu,  9 Jul 2026 22:35:57 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260709223604.12934-1-coltonlewis@google.com>
Subject: [PATCH 6.6 v3 0/6] arm64: KVM: Backport VHE-only boot fixes
From: Colton Lewis <coltonlewis@google.com>
To: stable@vger.kernel.org
Cc: oliver.upton@linux.dev, sashal@kernel.org, gregkh@linuxfoundation.org, 
	mizhang@google.com, catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	mark.rutland@arm.com, ahmed.genidi@arm.com, leo.yan@arm.com, 
	miguel.luis@oracle.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Architectural updates retroactively made FEAT_E2H0 optional, meaning
hardware can implement FEAT_VHE without FEAT_E2H0. On such CPUs,
HCR_EL2.E2H can reset to an unknown state and must be initialized early
so later code can reliably detect whether E2H mode is active.

Without these fixes, booting 6.6.y as a guest under KVM nested
virtualization will hang at boot.

This series targets 6.6.y specifically because these patches are all
present in 6.12.y and applying these patches to 6.1.y and presumably
older kernels has more conflicts and results in other issues booting
as a guest under nested virtualization. More work is needed to enable
that.

Changes in v3:
- Added Signed-off-by: Colton Lewis <coltonlewis@google.com> to all commits.
- Added explicit '[ Backport: ... ]' conflict resolution notes indicating why
  conflicts occurred and how they were resolved (Patches 4, 5, and 6,
  including Patch 4 where the conflict was trivial).

v2:
https://lore.kernel.org/kvmarm/20260708225124.4130846-1-coltonlewis@google.com/

v1:
https://lore.kernel.org/kvmarm/20260701204342.2654385-1-coltonlewis@google.com/

Ahmed Genidi (1):
  KVM: arm64: Initialize SCTLR_EL1 in __kvm_hyp_init_cpu()

Marc Zyngier (4):
  arm64: sysreg: Add layout for ID_AA64MMFR4_EL1
  arm64: Treat HCR_EL2.E2H as RES1 when ID_AA64MMFR4_EL1.E2H0 is
    negative
  arm64: Fix early handling of FEAT_E2H0 not being implemented
  arm64: Revamp HCR_EL2.E2H RES1 detection

Mark Rutland (1):
  KVM: arm64: Initialize HCR_EL2.E2H early

 arch/arm64/include/asm/el2_setup.h   | 56 ++++++++++++++++++++++++++--
 arch/arm64/kernel/head.S             | 20 ++++------
 arch/arm64/kvm/hyp/nvhe/hyp-init.S   |  3 +-
 arch/arm64/kvm/hyp/nvhe/psci-relay.c |  3 ++
 arch/arm64/tools/sysreg              | 37 ++++++++++++++++++
 5 files changed, 101 insertions(+), 18 deletions(-)


base-commit: da47cbc254661aa66d61ef061485a7080305c4be
-- 
2.55.0.795.g602f6c329a-goog

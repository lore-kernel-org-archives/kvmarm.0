Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D12751DDFB
	for <kvmarm@lists.linux.dev>; Wed, 30 Sep 2026 21:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790803117; cv=none; b=KieD2YNxRDdq3kR22yrb45vIN/CYcmqeJrfjMvkRkn8xn/+yWCkAoR3C/6KOsCKYYbABKwrpp6aPpR5zqtHsQNElo9YLQ08rKdJYa4vgNfmfx4om+zHawGf9vxH/6tLx0nJ4RWvGjZ7IEJmFxL2HY4sqNMdIeUxIlcFDrjsKNBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790803117; c=relaxed/simple;
	bh=bBIz71XabS8gsl10MkZY2WdwbNn2woPnnwp8G7PdlC4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=G8SQk/DeqvpS/FrElwhHd9SwkIO87EeM1fFgH+6XVlCtQFCHkRwZ+TdutEHoGPxsoJVyVw4grCtDtZ6gDAbtdbyLPd0x/e3iupRYz9Z45dN6quwAwzsOfVeoSvGcJoqClPBTqDP3rrwSAD+4fOotGIe6O6/8Px/M2CsNvzCedcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CTzXCYlh; arc=none smtp.client-ip=209.85.167.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CTzXCYlh"
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4b28dafb8e1so9949858b6e.2
        for <kvmarm@lists.linux.dev>; Wed, 30 Sep 2026 14:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790803115; x=1791407915; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=631pnrFuqDRXd3BfizV2s6nQYFa+PIycK6cr0Zp6o9g=;
        b=CTzXCYlhH58t0zDZdx6gDq3QKKzMSVmixqIrtGXYtUJV325QZh9EYxjXG0X4UyWBT/
         4IJ8MCkwZRvFgz6+6L1nYXa7Py0Q/BO0BmUwiVi1kqg7RcLlMwxULyw0k9mPv8TTJVna
         pN7NPgdf+NL/bd2smNPT2OZO8xg5kREdiKpUcSfgKQpemZ20S1tm5pMrP1LPH5C3U6ta
         ZKrf3wBekBh53EDqLqTlQAW5bm/5h9nvyglrQ15iio1AESAKp6p8vjBbdaBJ2capzmxc
         ug55WdXQ6YZhLK09+k3NZaHciPywa+h4SVe4tlF7TKRt5JMOw0446Va1TId1bmRjgUxq
         a9/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790803115; x=1791407915;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=631pnrFuqDRXd3BfizV2s6nQYFa+PIycK6cr0Zp6o9g=;
        b=vRwONMGFNEdYder85S/8RnxfO7r4+MKY5jLj+D59bspXAugOQ4aZ37ddrw0s/QCJGV
         MIHPTPcypWMIPlnCzC/OlF4zfgwRmLtT/STvijwN1DhnKyCBYXhPBoen9/W9kns2Fbvq
         iVJcrQgYLr4znlafCbJn8uVdP5okmjoE9+s85BeQ8GN/RadiXfurUENxDkK/j4ItpedE
         BT5cUTKAoOD1pnSmqLa1FCeMp3Z2t946n6eKBNh8hhifu7nLKGxxPclBmntXKquFTKvF
         SqvDCo0u4p/KaTxBm4qpg1tdfLMclAA0yCBV4LE7h9irCfxLcWuf2HDN/qfADKbJXIRX
         /rcw==
X-Gm-Message-State: AFuF++kIxZ7HZSX3ZhMsTRXVye68CMaOozxlqIbvEabkBSojYYDImwIE
	YRZmQ0j1koUKmo4ckr8Y28JC2bzY+zTjmmnE6/96q+ZUPdI6QI0S5bDQD1SXrAE1zX3Tf8UsEHa
	Hfm76zaJE0olW0MNNjrfAAwAGNsns1Gv4J+ce7dTlLz5DFlv1HvtkgHkqwfWaEG0p/zWlizF+uM
	FX5XoPmd/29tnQZVNVSqr+bQ+oIhKJHuMiFFA5RMpNkBDmHpKGg4A9TVfs8QpvEjw=
X-Received: from iocrj27.prod.google.com ([2002:a05:6602:a71b:b0:9c7:5b85:f7d6])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:14ca:b0:4d6:92b3:5c8d with SMTP id 5614622812f47-4f1bafb3d3bmr3357156b6e.67.1790803114797;
 Wed, 30 Sep 2026 14:18:34 -0700 (PDT)
Date: Wed, 30 Sep 2026 21:18:32 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260930211834.2773546-1-coltonlewis@google.com>
Subject: [PATCH v2 0/2] KVM: arm64: Handle hidden FEAT_PMUv3 in ID_AA64DFR0_EL1
From: Colton Lewis <coltonlewis@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, pbonzini@redhat.com, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

When userspace initializes a vCPU with KVM_ARM_VCPU_PMU_V3 and hides
FEAT_PMUv3 via ID_AA64DFR0_EL1.PMUVer, KVM hits a WARN_ONCE("Unknown PMU
version 0") during reset_pmevtyper() and continues to expose PMU system
registers instead of emulating guest accesses as UNDEF.

Patch 1 handles ID_AA64DFR0_EL1_PMUVer_NI in __kvm_pmu_event_mask() and
removes the redundant kvm_vcpu_has_pmu() check in reset_pmevtyper().
Patch 2 updates pmu_visibility() to check ID_AA64DFR0_EL1.PMUVer via
kvm_has_feat() so PMU registers are marked REG_HIDDEN when FEAT_PMUv3 is
not advertised.

Changes in v2:
- Handle ID_AA64DFR0_EL1_PMUVer_NI in __kvm_pmu_event_mask() and drop
  the kvm_vcpu_has_pmu() check in reset_pmevtyper() (Oliver)
- Drop Cc: stable@vger.kernel.org (Oliver)
- Add patch 2 to check ID_AA64DFR0_EL1.PMUVer in pmu_visibility()
  (Oliver)
- Link to v1: https://lore.kernel.org/r/20260929220411.3756519-1-coltonlewis@google.com

Colton Lewis (2):
  KVM: arm64: Handle ID_AA64DFR0_EL1.PMUVer == NI in
    __kvm_pmu_event_mask()
  KVM: arm64: Check ID_AA64DFR0_EL1.PMUVer in pmu_visibility()

 arch/arm64/kvm/pmu-emul.c | 5 ++++-
 arch/arm64/kvm/sys_regs.c | 6 +-----
 2 files changed, 5 insertions(+), 6 deletions(-)

-- 
2.56.0.rc1.315.gc6ed9934b7-goog


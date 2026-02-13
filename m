Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 071423612EC
	for <kvmarm@lists.linux.dev>; Fri, 13 Feb 2026 14:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770993499; cv=none; b=I39eUWkfILmxXTnTRcypAU/OReiQ0U2d+demeoL+q+mkBwRSh0o3G6gqustET9XlbUCG3vXf+ekGSI7U54hwC/Pz5Ks8LXXTE9FyiGbdBjKOHBJzqjqEZlYXYj3Pfv/vQ7lJT6EfcAgQo8Y85tNxtxn6F3aSHhooK8ttU4/6Hz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770993499; c=relaxed/simple;
	bh=tgCJ0yXfYRIrO5tRfb5O7+h3Cr2Uakv1/lFQiNz9wC0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=SOOSQwZl+yZ3vEtlYvLfork7tvYBv8hwKwqpQ8iQJtR1OimQicIEWVacR33yKYmvm/AXdkMtrVxhYQDuk1gyzO4U1t5D2dZ2lQ1nLKY1l4yvYAa5FrUNun2BpLK6i5MqoEN0MW5kLP2HQvgbczG8VVQ2RQQdwOhiSkVsKS9V0l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NTerOXBo; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NTerOXBo"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b8faf5f2b38so94087366b.1
        for <kvmarm@lists.linux.dev>; Fri, 13 Feb 2026 06:38:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770993496; x=1771598296; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UUp+ZPHGqL5Ruf8kk7PuU1fhAJIx8L0ts8JU7bSIkH8=;
        b=NTerOXBotg9sZfPLbISjba52NMXRlyOSwCV3ILnp6+MuHeyED24dEv+bUJy5JWQPWG
         PH6fNMvCwSXyOCXtPLC94NZIo7HyZpLig8ePcYCHm3yfm9hd6pig6w1icpiBB8w5ilvl
         9mtxTFuK2CgOfQxezPZFH7is0HOHWiuD3JiisqsWlj+aODB1OYD84kmH8P9f2JnyXFqk
         17GMVfspN8u0ZtgRxXsDZICxi+he8NVKeyFYWbg9jTQXMiV5/mv9YLyw5wacwpZcK2NO
         M8cGGrjvu+BCE14Od/k9YIk1MW2EoVWSDd59e+ISzWS4F5IxE8uIzyXN7FOVWpeaI/lF
         Vm6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770993496; x=1771598296;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UUp+ZPHGqL5Ruf8kk7PuU1fhAJIx8L0ts8JU7bSIkH8=;
        b=a+VuTQCfgQfmEWfx3aldugXYKxTdMIydrl1HK6oipjOMOTqnrwaB70F5r1DW2ficGs
         QRa8HEUDwADw8Z3Hnzi5JZkF/ZnbihhlxjGyAp4VfknIxTzh3tv5F5L9+6FZpqJ2yrqL
         eisfg7XqCZxO9Cp5MCbV7opXzYYrHMv9l67V70sfT3my0euFMi+UtNHHjsOt4VkG6qlE
         GH1wepZMCd6RlZLI4TxFJohXKzdbKfoapE9nsEpbODlbIkL48gM3bz0V6Zg/oDlpn/Uu
         cY58mbfsEwbhmU3cSXu1krc+cYpyf3WFzy2DjQ2NmNs1DGBK1hWCPPcijdFZPm1Ljf7v
         2svw==
X-Forwarded-Encrypted: i=1; AJvYcCUFmR+hQ/vS9+4iAoi5wPd9hN+6NurdwhsdedeMaGNxi4CNSmz7kJAd8WnmcJWWW6Q3mUnWBEQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzj6sdGFkoC3O4UOyWlw5KgFFTVvxqg6R/nTd8HCoAyeHhomKZz
	nXxmAOXB/pkNpOCdd0mOTj4wIpt2EutvKapsqDu0UFdCzJ9tdl3jqLG058XLGZtdtowtAfO1tBv
	ZrA==
X-Received: from ejbme9.prod.google.com ([2002:a17:906:aec9:b0:b87:1864:34ed])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:728c:b0:b8f:848b:4456
 with SMTP id a640c23a62f3a-b8fb41937f6mr98615266b.13.1770993496347; Fri, 13
 Feb 2026 06:38:16 -0800 (PST)
Date: Fri, 13 Feb 2026 14:38:11 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.273.g2a3d683680-goog
Message-ID: <20260213143815.1732675-1-tabba@google.com>
Subject: [PATCH v2 0/4] KVM: arm64: Fix guest feature sanitization and pKVM
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

Changes since v1 [1]:
- Moved optimising away S1POE handling when not supported by host to a
  separate patch.
- Fixed clearing, checking and setting KVM_ARCH_FLAG_ID_REGS_INITIALIZED

[1] https://lore.kernel.org/all/20260212090252.158689-1-tabba@google.com/

Based on Linux 6.19.

Cheers,
/fuad

Cc: stable@vger.kernel.org

Fuad Tabba (4):
  KVM: arm64: Hide S1POE from guests when not supported by the host
  KVM: arm64: Optimise away S1POE handling when not supported by host
  KVM: arm64: Fix ID register initialization for non-protected pKVM
    guests
  KVM: arm64: Remove redundant kern_hyp_va() in unpin_host_sve_state()

 arch/arm64/include/asm/kvm_host.h |  3 ++-
 arch/arm64/kvm/hyp/nvhe/pkvm.c    | 37 ++++++++++++++++++++++++++++---
 arch/arm64/kvm/sys_regs.c         |  3 +++
 3 files changed, 39 insertions(+), 4 deletions(-)


base-commit: 05f7e89ab9731565d8a62e3b5d1ec206485eeb0b
-- 
2.53.0.273.g2a3d683680-goog


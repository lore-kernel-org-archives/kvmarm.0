Received: from mail-oa1-f73.google.com (mail-oa1-f73.google.com [209.85.160.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA5131946C3
	for <kvmarm@lists.linux.dev>; Mon, 27 Jan 2025 22:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738016454; cv=none; b=WhI+LM4taJ4hedv0rWf/pkHyE7WGOmTFzV/AbupR9VoaI1c6vm90/vQWzd0BgftGgoIlGAk1X62PlLuI0/Eu2dV6qhKosXbnLqjVVJXYiI32QA3UOap7VVnilBU6zFtWVi3RP8gDcTXkKAN3wznYdMIIr+2MRcK3lCS9LTYnjY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738016454; c=relaxed/simple;
	bh=YR+PMK0VyLwKWhT0xbtwEKZ7//CuT8dMl7x5cZfrnYo=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=XgP0l83XkMiakhxDVTC8lujvVf8BnoqQxZ1k5AReh8w3iC3eFy9YNpJOyiWxyu/APHFqP8sFKXg3805Nqunuk3I+MHcUtMdxM+8SihEr2HVz4ooWNlXrRDOVGlRF1Wg4Nj0pDS6VCnPDCLBVcNQz4k+Hfprv6NPGNn1s0NRwI8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xduxv3A1; arc=none smtp.client-ip=209.85.160.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xduxv3A1"
Received: by mail-oa1-f73.google.com with SMTP id 586e51a60fabf-2a8e3905c56so1580635fac.2
        for <kvmarm@lists.linux.dev>; Mon, 27 Jan 2025 14:20:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738016451; x=1738621251; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VGVx2inDcPb4kyuc5g9Cp41GlSlePFgSKTBuQPtRjD4=;
        b=xduxv3A1Gpln0NHADUvUWBoFal2GQ7ONgsHTl6g/+gHtBuJyv3x9ECkW7O4zYtdxuc
         y4OSxlA35NyNkw1sSoRuO+GqhfBpeljHGQMKD+eDVdB4MGZBEqc/jIrZf6DbDouw1ieO
         /UYPNgdl1MTjVicDoFkq5+OKMBrwKTiiWwtUrxRVAN+aZNS1FdLHZ5a4QEjm9X+q+iiZ
         eCAvoil/ylcr+A4pRtb/DwTk96VbNKez2EqQtSwYG4Aa6nfVu+J8kw1WFWvSSgX5/ReD
         opuMv6wCXBhuQyDlAo7azbhAWwEQpdObWqAbUIT6Vq4IA738OoVeBZyXoGcYRf4Z248Y
         f6dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738016451; x=1738621251;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VGVx2inDcPb4kyuc5g9Cp41GlSlePFgSKTBuQPtRjD4=;
        b=ZQxMcLOfa2Y1x0tLISbaG1jM5bCCPAOE3Vd7cVJ50XF1LyGxQ3in3BNGPC0S+8nBV+
         aWBTk438qXfegJHSdU6gnD80JPUUnfd8xwxXGlAyo5e4l0b3zCq2lUb7LcUW0ZKsRMRX
         bi9U54Xobld9Q/3HeWL2LQiVeYXa28TceSd+aHggzzrrcz40v6p4wzbS0reQ8qu8+Mlb
         NJEjMA0Ckfq+4bjJruLYYwgyZhlh7SPoSgHXH7LBT70kO205kjdY+mSdLHb+uTNZvkqG
         /CmE6XTcfKVx3u+R9OiOQ/mbjVR7x3bX/v8/K+U76oJ5HDWO6NMTAAGBpNvsG8M1yd4m
         Gr6A==
X-Forwarded-Encrypted: i=1; AJvYcCU5SD3gNQJ81j8o9RIrpX7GszNl6nf74hM8lRUFb11i7e7Mi4bIaXcPjSaTdEu7RCG0Ih2EO5o=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx+deaIVFwtfH6krB5KEkd2i3LxB73pp7W+9lNXKfOPVnbd9a45
	E3PagsuE+CFUtw9An76aegSuq9HcYLe8SG3jU1C8nvF3IJLK3D1G99D/yM4sFKA6a4nbsbUWOOa
	QYAmBJm7jWEhj71B30nsMrA==
X-Google-Smtp-Source: AGHT+IEyp+zn4K8xvMBme9w+olqOdC2WoYBUbvWUqnKRlZMr1gAx+eFOYXOnePYqDL8MpO28ip3SYaynWBZeMCj6Qg==
X-Received: from oabnw13.prod.google.com ([2002:a05:6870:bb0d:b0:2b2:2b44:5abb])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6871:3a88:b0:29e:2422:49f9 with SMTP id 586e51a60fabf-2b1c0aee5efmr22900341fac.25.1738016450898;
 Mon, 27 Jan 2025 14:20:50 -0800 (PST)
Date: Mon, 27 Jan 2025 22:20:26 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.262.g85cc9f2d1e-goog
Message-ID: <20250127222031.3078945-1-coltonlewis@google.com>
Subject: [RFC PATCH 0/4] PMU partitioning driver support
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

This series introduces support in the ARM PMUv3 driver for
partitioning PMU counters into two separate ranges by taking advantage
of the MDCR_EL2.HPMN register field.

The advantage of a partitioned PMU would be to allow KVM guests direct
access to a subset of PMU functionality, greatly reducing the overhead
of performance monitoring in guests.

While this series could be accepted on its own merits, practically
there is a lot more to be done before it will be fully useful, so I'm
sending as an RFC for now.

This patch is based on v6.13-rc7. It needs a small additional change
after Oliver's Debug cleanups series going into 6.14, specifically
this patch [1], because it changes kvm_arm_setup_mdcr_el2() to
initialize HPMN from a cached value read early in the boot process
instead of reading from the register. The only sensible way I can see
to deal with this is returning to reading the register.

[1] https://lore.kernel.org/kvmarm/20241219224116.3941496-3-oliver.upton@linux.dev/

Colton Lewis (4):
  perf: arm_pmuv3: Introduce module param to partition the PMU
  KVM: arm64: Make guests see only counters they can access
  perf: arm_pmuv3: Generalize counter bitmasks
  perf: arm_pmuv3: Keep out of guest counter partition

 arch/arm/include/asm/arm_pmuv3.h              |  10 ++
 arch/arm64/include/asm/arm_pmuv3.h            |  10 ++
 arch/arm64/kvm/pmu-emul.c                     |   8 +-
 drivers/perf/arm_pmuv3.c                      | 113 ++++++++++++++++--
 include/linux/perf/arm_pmu.h                  |   2 +
 include/linux/perf/arm_pmuv3.h                |  34 +++++-
 .../kvm/aarch64/vpmu_counter_access.c         |   2 +-
 7 files changed, 160 insertions(+), 19 deletions(-)


base-commit: 5bc55a333a2f7316b58edc7573e8e893f7acb532
--
2.48.1.262.g85cc9f2d1e-goog

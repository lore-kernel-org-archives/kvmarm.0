Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132A222F09
	for <kvmarm@lists.linux.dev>; Fri,  3 Nov 2023 19:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="r9Y/BSvC"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-da04fb79246so2804396276.2
        for <kvmarm@lists.linux.dev>; Fri, 03 Nov 2023 12:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699039767; x=1699644567; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bEAfZyWhlsWU6we+1WUOdwYhBvWIiGNcSe/GN4oT0oY=;
        b=r9Y/BSvC6NcQn+VW/TA+VESWYaNEbbE4oZLcgdcvi+cyUhhsWxv1Ore1AmWCylAsNT
         rY83sXQYQCXVMqZEEO1veWUUc+6/BzFfC7Kr3kGejLVnk45L1hxeKGG0P5GepFW/HEyo
         YKFqfPseKvvMoS8ceqkAGAvSjW8Dnp+mhu6t+/zwX6mVM8WzYz7BRLgZ9OOiWw9/+XSB
         E9Vk3eRHMDrqHGPCVRQOg/Aw/d5/lpbgnOeG2ekKvKArWZmrDzzHd7iATyFL9gRCQBZ8
         fjgb4YHH40f//6h8/927LSEWpGqR9VeWV/7YkB6yrLOijwSfEI30UeCI7UPckwuIfC7e
         zPzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699039767; x=1699644567;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bEAfZyWhlsWU6we+1WUOdwYhBvWIiGNcSe/GN4oT0oY=;
        b=MEmhhi3johpqnyKmZGVjWdNTc12pZTiZ1MZcREUPW8FT5MOZ6RYESHN1HtSVBM1Xu8
         BB71eZf9Iq75EvGj4kdgCkCzxxZduuE0OPazqXeTqD6L1hbSCoCccF9TPxHx4HoAkrsJ
         F+43GOKeghgdHzw0KCxh6YkOrFRW6l477K1ZkFqqkkTuCp7v4oNwQ6//G7q0u3o35N1Z
         u+bYdn7NODXpjNl1Bak3LW1+BeRty9Gq8AdXEcQ6CTcoMjqEekeU0sY1bPPSJUlo3VCu
         xkZcrs9wqXH5Fp4fDKQQFlITqNdBQ05gyD5Dwx0235wj7KB61o2Oj6PEMUfsp6iFGJ5n
         IT7A==
X-Gm-Message-State: AOJu0YzxR+X0PnWiUMGqP7ZdBKimy3JJvvtugSRi+ZbvlvQSK4U+i7D/
	5VlrmJWT/MmW+GxVSExDaVIP+uwkv2M7eHnbMQ==
X-Google-Smtp-Source: AGHT+IHKhte6SyveleGfndRKN5qF5FiLzkyOQTSM6UmB/7Ca1BYcGNMFHiQ2xWtcgmwtm27r2JFQyaL2fqKGSpkBeA==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a25:2688:0:b0:da0:29ba:668c with SMTP
 id m130-20020a252688000000b00da029ba668cmr412348ybm.10.1699039766978; Fri, 03
 Nov 2023 12:29:26 -0700 (PDT)
Date: Fri,  3 Nov 2023 19:29:12 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231103192915.2209393-1-coltonlewis@google.com>
Subject: [PATCH v3 0/3] Add arch_timer_edge_cases selftest
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Ricardo Koller <ricarkol@google.com>, kvmarm@lists.linux.dev, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Add arch_timer_edge_cases selftest to test various corner cases of the
ARM timers such as:

* timers above the max TVAL value
* timers in the past
* moving counters ahead and behind pending timers
* reprograming timers
* timers fired multiple times
* masking/unmasking using the timer control mask

These are intentionally unusual scenarios to stress compliance with
the arm architecture.

v3:
* Rebase to v6.6
* Patch to standardize GIC base addresses across tests
* Patch to guarantee interrupt handling in vgic_irq with context sync,
  fixing an error there that was caught here
* Expand sync_cmd enum for more logical arguments to waiting functions

v2:
https://lore.kernel.org/kvmarm/20230928210201.1310536-1-coltonlewis@google.com/

v1:
https://lore.kernel.org/kvm/20230516213731.387132-1-coltonlewis@google.com/

Colton Lewis (3):
  KVM: arm64: selftests: Standardize GIC base addresses
  KVM: arm64: selftests: Guarantee interrupts are handled
  KVM: arm64: selftests: Add arch_timer_edge_cases selftest

 tools/testing/selftests/kvm/Makefile          |    1 +
 .../selftests/kvm/aarch64/arch_timer.c        |    8 +-
 .../kvm/aarch64/arch_timer_edge_cases.c       | 1104 +++++++++++++++++
 .../testing/selftests/kvm/aarch64/vgic_irq.c  |   23 +-
 .../selftests/kvm/dirty_log_perf_test.c       |    5 +-
 .../kvm/include/aarch64/arch_timer.h          |   18 +-
 .../selftests/kvm/include/aarch64/gic.h       |    8 +-
 .../selftests/kvm/include/aarch64/vgic.h      |    3 +-
 tools/testing/selftests/kvm/lib/aarch64/gic.c |   12 +-
 .../testing/selftests/kvm/lib/aarch64/vgic.c  |    7 +-
 10 files changed, 1159 insertions(+), 30 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/arch_timer_edge_cases.c

--
2.42.0.869.gea05f2083d-goog

Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E184E12B176
	for <kvmarm@lists.linux.dev>; Fri,  9 Aug 2024 18:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723228698; cv=none; b=aHHzks66cVJMYqdEp7O2JTD5qSiBzmVAmCDunXRsv8vLpBGZkRrp2mOGt550dsrVesM+CjfGEmyK4JbcEYNfwxkLiLLEfVMhSSuPkX8vV5m7Kf2s4bkNqPkg/ztV/IZFofh8G4DLZThxTaSI04sVZNX8QzRHsyrvcWZNXIefYOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723228698; c=relaxed/simple;
	bh=WgFcAp2Lf8zyPmmusFZaXFyM7LQjQCGcA8kgp6zTh1w=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=hLz9dezzPxOly2u1WBxzdzUS7/AbmfPKngZWor+uni7SlXOiz1vfhVB8blT0J4XqWkRo7cEtzonAOTDFIoFGnpqhC6b79Im4BhHcxElDSZQf4zRcAoqV8Nde12HTvFdFo2GueA3c7gceFY215JPEOeFOryR82TOadSpZLQx2CRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IyOTi83P; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IyOTi83P"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e05e9e4dfbeso4243616276.1
        for <kvmarm@lists.linux.dev>; Fri, 09 Aug 2024 11:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723228696; x=1723833496; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9QpRWP4XLNMJiIvVol8OxLNovEZIjUaHM/c1cDtRmx0=;
        b=IyOTi83PqrsX33MC75+SZts/gGL6s5QTfKk510RG7GcdRLTIC1g0YIHZhi2xpeZ0RA
         b+HUJJkBkLotYI0fLDf9mtx7VXuah1/oTlMSc1eP5oAdQJUp1sfSROzX9A5+K30SXTIM
         QZfYr2sRbO8SnV7J62DY9woogwp9sQld1kakRgK4t84Fg5O3lsgHTa1+SJWWGKqPGZYJ
         UfmZa/RHlyDEq5UNbgMgMdJB946lnoJGaHmTiXQDDbjYQYKxniLA/ozoLXJf3EJUwW4K
         dsFTO5B08neoXAL91y4AN5Z4HWMJZ/xVaUEAl7LQZwRSpZqs+nWFb78grLZ7nwa/J2/h
         cWxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723228696; x=1723833496;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9QpRWP4XLNMJiIvVol8OxLNovEZIjUaHM/c1cDtRmx0=;
        b=Hjc4XH597zwDVq9AfYUW7AKJXzzZlO9nOoJmRmZ3CJR18wWxWx0Vi5WPca9eDrTT7K
         ulFd6BadSkF91jJp/SSk2ewo3tUtpSDVcKNyJhhgPYX4JzCjZws6Cdjh34yzcip6jEDt
         u6u7Ywlx/1jk9SML+8Xe7pxGrEKZp3WwTd8j+OIuyw+MlMuyNUW/kj/lklLtU0ZNlEmm
         8FX+2wV0JNDKeTLdP1hOQIDCwGxxNLCHv1yr/dULkcZP8sQf9XKOsdxfxQenhieFpQKg
         vNOejDiHhk12bF84rWoTJjf4uKnikgMDdTi1ZUUKuMGjqz8DBR8/9Vxe+WsrS6VO81C1
         Zm9w==
X-Forwarded-Encrypted: i=1; AJvYcCUXa3eCkdgUQmuyWlGGazso/ccx5f37NXfxdYSAiQsfq029dg3azE7VJUmln8VR/revkGTTg+CDqaPDJCyvO3XwutkcpTwr
X-Gm-Message-State: AOJu0Yxo5SO3xtrJwBp/hegHGisGgPim/n4PccAEN05/Z9Yzv6Y6jwQ+
	edgiCcnC/7uY1EJTh1woHil9cPu4TSOlBAkZ80mrpM22Nv7QH2gSwvOJsKL/vOOV9KcWGrV3rTL
	l6Ux8+vfHMzqhxvU5P6EQLw==
X-Google-Smtp-Source: AGHT+IEQzaYfkd9MJCLSU0EZ0iwERGwinl3PjreNXMmt5xE9iCRLweaZNLIudRz1qRDKokEE+0gqU4sbJ8n0hwOLfQ==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a25:ab93:0:b0:e03:b0b4:9456 with SMTP
 id 3f1490d57ef6-e0eb9a107c8mr23264276.7.1723228695743; Fri, 09 Aug 2024
 11:38:15 -0700 (PDT)
Date: Fri,  9 Aug 2024 18:38:00 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Message-ID: <20240809183802.3572177-1-coltonlewis@google.com>
Subject: [PATCH v5 0/2] Add arch_timer_edge_cases selftest
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Ricardo Koller <ricarkol@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, kvmarm@lists.linux.dev, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Add arch_timer_edge_cases selftest to test various corner cases of the
ARM timers such as:

* timers above the max TVAL value
* timers in the past
* moving counters ahead and behind pending timers
* reprogramming timers
* timers fired multiple times
* masking/unmasking using the timer control mask

These are intentionally unusual scenarios to stress compliance with
the arm architecture.

v5:
* Drop previous patch 1 standardizing GIC addresses as this has now been
  done by another series
* Fix shortlog message for patch on arch_timer test
* Comment ISB use appropriately
* Rename gic_wfi() helper to wfi() as WFI instructions don't imply a GIC

v4:
https://lore.kernel.org/kvmarm/20240307183907.1184775-1-coltonlewis@google.com/

v3:
https://lore.kernel.org/kvmarm/20231103192915.2209393-1-coltonlewis@google.com/

v2:
https://lore.kernel.org/kvmarm/20230928210201.1310536-1-coltonlewis@google.com/

v1:
https://lore.kernel.org/kvm/20230516213731.387132-1-coltonlewis@google.com/

Colton Lewis (2):
  KVM: selftests: Ensure pending interrupts are handled in arch_timer
    test
  KVM: arm64: selftests: Add arch_timer_edge_cases selftest

 tools/testing/selftests/kvm/Makefile          |    1 +
 .../kvm/aarch64/arch_timer_edge_cases.c       | 1099 +++++++++++++++++
 .../testing/selftests/kvm/aarch64/vgic_irq.c  |   11 +-
 .../kvm/include/aarch64/arch_timer.h          |   18 +-
 .../selftests/kvm/include/aarch64/processor.h |    3 +
 .../selftests/kvm/lib/aarch64/processor.c     |    6 +
 6 files changed, 1131 insertions(+), 7 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/arch_timer_edge_cases.c

--
2.46.0.76.ge559c4bf1a-goog

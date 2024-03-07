Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69988131E3C
	for <kvmarm@lists.linux.dev>; Thu,  7 Mar 2024 18:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709836796; cv=none; b=m4ztjnmOYaAOhxPLpr3OPi9W7agbKgSagZh6Y+lv+bY1O7MjEAVuq91WePjx0lWdfm+aEOJoduqfdL+PG0USSWONjdTGoMDNSfs+vBC2qDEWmEA9PicYcnb5iGxvUcHCb2F0QENn8EgamQ8tyyNqS5KP5vrKUsn2zZMgKmLh9Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709836796; c=relaxed/simple;
	bh=akk9bHSXL2p2/76CztMO7vrfVTA+C6sHDz1aSSJxcrI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=pV5Bq8F29ctAn7sk7B/XTSpwGQelTpiQgj7JQ4ch8c8P3fkSfFolQT+OiiAkkDF8Aft/8mHb5imfiZlCDl3E1wwel5RY3jsbLngCu+CXPugfP4JRGhfRxqo37qHDYwkQZGcEJdEu0WxNiNaXdC3snC9giDneNYl0Lzt8BSmkiho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Wun+UNTc; arc=none smtp.client-ip=209.85.166.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Wun+UNTc"
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-7c495649efdso143380639f.2
        for <kvmarm@lists.linux.dev>; Thu, 07 Mar 2024 10:39:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709836794; x=1710441594; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vNMOfHTWILvXvO6xXs7ecY4oaxm2hms9W+5pBi1MYDs=;
        b=Wun+UNTcoxyV75SQ0Ps5UlMgfC1JFlLDRrRPsIyVs/jyggAY7d85dnmUzehth0G3Tp
         sEdkiWtLkM8yjk7XpnDw1z2//Deam/5WgUsJdMq8uiW+UqCrGeoVefAjkUNkqeICanfP
         pUSuqLvV3bFZ4kOKmTCJ3IHZfLRfZOsZL4KkEKf+h11JommNzjfCuZgNx//R9mP5wZWl
         G0AANkq7e3q9XNmLZqk977rXHruFys7BOpmiLFBCs5QXHJBNn1ftbVOKKNW33uMCNrjg
         ZaXpOQj5X/fOUKOof90/6IIkaZyrH24H7uBhGaVUsqpSodY09xoz1Ma5cIkc6Wz2f2n9
         WUAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709836794; x=1710441594;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vNMOfHTWILvXvO6xXs7ecY4oaxm2hms9W+5pBi1MYDs=;
        b=BpLepHbybatqkDdmyLP0+gPS+Rwt5N1WDMWLTe0C2/GR+LZr+YdYAQBu53uwm0Zp3L
         QDffD4l2qNZquaVJkcWx2dH89/gF8gSR8MmLLwRlTnJloX9eJaxFwsCa5uOGPH5Je90a
         cEi5T05pTw6D4w1nFQd90zg9pGRXXhgTsw48f4ZptSnSxH/kVa90fHpm0jFPmtGVDzHb
         yYgSDR3o45r5OOKvBrvF6Rwx8n0d+AaFuBQ0GxRj8P3IqUbEeAP5IchymwTHvmoAU7mp
         4HJcjXWpg8nn1wgUR9Mrz0SEFpr005sWAc0vbcE426hZ5Zvi3ijmK/t600AHQJA8/QlX
         ChSA==
X-Forwarded-Encrypted: i=1; AJvYcCXOSUrk0aFQuUWszwsAniQ7ROoTd2ZvbeIrPaxr6KUks0gQ8GadmGy/4yViYbKp90JCFk0zTMHU2SejuEaEg7u/UQlVnU45
X-Gm-Message-State: AOJu0YxaH5JSh1nWc+7gvSR+GaYb3L+2s6UIbHL3tp8RXuaWCJ1uUp2T
	t7j6I/HayF/Ain8CzKeUbOdD20uwGHXWqkW6AklsZ+Pjq4dMCu6GdL4ee36CdrBk25zGt9hmDkv
	kBgJl6MFj0A/Rcbs4XStkFg==
X-Google-Smtp-Source: AGHT+IHn+sE1Yd5hWukLNm6By8efRqP8K6LAQ3UzMWo/06dXPuuyn1o2cC1Gk4A10pen0rB7atZJaPWELfUv2bnXlg==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6638:16ca:b0:474:b9df:7315 with
 SMTP id g10-20020a05663816ca00b00474b9df7315mr1010188jat.2.1709836794515;
 Thu, 07 Mar 2024 10:39:54 -0800 (PST)
Date: Thu,  7 Mar 2024 18:39:04 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240307183907.1184775-1-coltonlewis@google.com>
Subject: [PATCH v4 0/3] Add arch_timer_edge_cases selftest
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

v4:
* Convert macros to functions where possible
* Remove magic numbers
* Improve naming of variables and types

v3:
https://lore.kernel.org/kvmarm/20231103192915.2209393-1-coltonlewis@google.com/

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
 .../kvm/aarch64/arch_timer_edge_cases.c       | 1102 +++++++++++++++++
 .../testing/selftests/kvm/aarch64/vgic_irq.c  |   23 +-
 .../kvm/aarch64/vpmu_counter_access.c         |    3 +-
 .../selftests/kvm/dirty_log_perf_test.c       |    5 +-
 .../kvm/include/aarch64/arch_timer.h          |   18 +-
 .../selftests/kvm/include/aarch64/gic.h       |    8 +-
 .../selftests/kvm/include/aarch64/vgic.h      |    3 +-
 tools/testing/selftests/kvm/lib/aarch64/gic.c |   12 +-
 .../testing/selftests/kvm/lib/aarch64/vgic.c  |    7 +-
 11 files changed, 1158 insertions(+), 32 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/arch_timer_edge_cases.c

--
2.44.0.278.ge034bb2e1d-goog

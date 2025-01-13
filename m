Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA1F1C1F09
	for <kvmarm@lists.linux.dev>; Mon, 13 Jan 2025 19:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736796694; cv=none; b=OLVN1anOm5nJ7LUpeRrENK3/CYcmSIvyak95SaPC79bBUCudXak0tyVlS0Rzit+44W/r3EFm5S6P38O9+GlUOUMk7ls3OQn8Q2Kcwc7OaxoXzwW19wEtZU7RrlWhHodFW5RF7vwVC3g4g//JHkWbrZ8Ijf38iwDKnDhx5AQ5+5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736796694; c=relaxed/simple;
	bh=PRBMDwCzGMm8L3nHQz/Y5ZCs//c8r+CGj3lxJjZURcg=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=PgNdWLJJal0PNnkt9SLCWKNnsWneqnoSbLVJcRD0CYIzntWXnAa5TLpdVOSFc43Ws97Ii/uO3Brluc10uTtnCUKewVLBablS5b1eArqKnUz4wLUdEFpS6+eiHO8OsU3bxc3OQBySD9k6rKxPWET7eg+hdHadyxfnAtaBt9scq4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NDEyOifi; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NDEyOifi"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2163dc0f689so119572655ad.1
        for <kvmarm@lists.linux.dev>; Mon, 13 Jan 2025 11:31:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736796692; x=1737401492; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zQuLNus1VAxZrNBZ43k6Ya2LjBOws5SGp9azJjVVqPM=;
        b=NDEyOifiKhJVrKNOjEbrs4Dr+WXXoea2bKJN6K9dhFYKM4/Tpe8LuErlI6aj/Rs1gY
         o5erntqkZN08MXLmpASM7T+Um9PYYxNnIZVbZHdoBW0gEdjvP7Op1kDJKgEfqNnzmyJm
         7nXCXnfafGmLux6Lgj0pABLwjHBs0b20Op0iL5IEulTkEq/YPTtCkCokxTJEUUY+TZp9
         zcB2Bkem0AR7dXYvGcPx8Bh/YJXBnZn8oXJAyL0aejcVvMqIZGstNbnhy/anh1Da3guD
         WFj3FGnGNr/FlYtduzIEUnNKhiAVLTpOj+AYIAy0cdYhE3ZDPLxBfMOWUhzwrFmQf3ql
         gw4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736796692; x=1737401492;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zQuLNus1VAxZrNBZ43k6Ya2LjBOws5SGp9azJjVVqPM=;
        b=CmE9EigPIXp10MpBZtV+9bXzy4DjDvNVK/bgpXnJUcdPlTlQreH6tP+fJSDW8PsF1c
         pvv3XEa8d8aHdA5IKtcOMSwsEm0Vo9WL66lPFY43O2F2mbu0U10Yq/yRFk14nWv/1Gon
         Xu1rL7hvzaTCfeP9TaTKkPbA/6WgMv7m7odZgXjwrVZIMveZrf2dBWnq5PLduxci8iLK
         3/YCUnvjAVq50S9IvLqKXOxzXIVGIXj8ItXZff2IORw82DhB/F01S8ylwlRRg2kHEs7F
         H5Oq6t5lmiXZY+rcippAXz6E/BWumtSqW/HTGYheAgMOw/6gg5b+jdg4LGlRvraS0LKr
         wUFA==
X-Gm-Message-State: AOJu0YwSD24SB8IxDp8gC9Zc0ov8hP8ZviMMtkcq4HpMNyrJLxEi66ON
	JJdcPb3WRRMglwsEgDi+t8g/qlTXq7MEyWziNYzIA13OetbBrudwqOdNmbt+Tek7mfkPa3BzV0p
	RWnNRWKk1HlTvUsZPPFUZC/r0bDsDaqbJsVW33ou2uERLE1G5Z7UdgGiXnATRor7jRrfawOu4aE
	+2qZDm00gzymuo7tKbl4RBmwRYDoKkV+y/MfIWB05nWnbZqZpVwmmGMbnuEuQ=
X-Google-Smtp-Source: AGHT+IFTTR9jWVG4vVEvgyv+yC8hp1O0OmOvPiyAoIVKcAx8u7/sqAUQ1P0efNDOYAB1okcT0cVybvPbu9xCmAhOiA==
X-Received: from plkl13.prod.google.com ([2002:a17:902:d34d:b0:212:10e4:fc1a])
 (user=jingzhangos job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:cccb:b0:216:4d1f:5c83 with SMTP id d9443c01a7336-21a84010cb0mr327348885ad.47.1736796692096;
 Mon, 13 Jan 2025 11:31:32 -0800 (PST)
Date: Mon, 13 Jan 2025 11:31:26 -0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.1.688.g23fc6f90ad-goog
Message-ID: <20250113193128.1533449-1-jingzhangos@google.com>
Subject: [RFC PATCH 0/2] KVM: arm64: vgic-its: Enhance debugging with debugfs
 and tracepoints
From: Jing Zhang <jingzhangos@google.com>
To: KVMARM <kvmarm@lists.linux.dev>, ARMLinux <linux-arm-kernel@lists.infradead.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

This patch introduces two significant enhancements to the debugging
capabilities of the KVM VGIC ITS for ARM64 systems:

* Debugfs Interface for ITS Tables:
  A new debugfs interface is added, accessible at
  /sys/kernel/debug/kvm/<vm_name>/vgic-its-state@<its_base_address>.
  This interface exposes the internal ITS tables, allowing developers
  to inspect the mappings between Event IDs, Interrupt IDs, and their
  associated target processors. The information is presented in a clear,
  tabular format, making it easy to understand the current state of the
  ITS configuration.
* Tracepoints for ITS Commands:
  Tracepoints have been added to cover all major ITS commands. These
  tracepoints provide detailed information about each command execution,
  including device IDs, event IDs, collection IDs, and other relevant
  parameters. This allows for fine-grained monitoring of ITS activity
  and facilitates debugging of complex interrupt routing scenarios.

Motivation:

The ITS is a critical component for interrupt routing in virtualized
environments, but its complexity can make it difficult to debug and
optimize. The current lack of visibility into its internal state hinders
the ability to diagnose issues related to interrupt delivery, performance
bottlenecks, and configuration errors.

This patch addresses these challenges by providing tools to:

* Inspect ITS Table Mappings:
  The debugfs interface allows developers to directly examine the ITS
  tables, verify the correctness of mappings, and identify potential
  misconfigurations.
* Monitor ITS Command Execution:
  The tracepoints provide a detailed log of ITS command activity, making
  it easier to understand the flow of interrupt routing and pinpoint the
  root cause of issues.
* Improve Debuggability:
  By combining the static view of the ITS tables with the dynamic
  information from tracepoints, developers gain a comprehensive
  understanding of the ITS's behavior.

Implementation Details:

The debugfs interface is implemented using the seq_file interface to
present the ITS table data in a user-friendly format.
Tracepoints are defined using TRACE_EVENT and DECLARE_EVENT_CLASS macros
for efficient tracing. Tracepoints are strategically placed within each
ITS command handler function to capture relevant information.
The patch includes necessary modifications to the KVM Makefile and VGIC
header files to incorporate the new functionality.

---

Jing Zhang (2):
  KVM: arm64: vgic-its: Add debugfs interface to expose ITS tables
  KVM: arm64: vgic-its: Add tracepoints for VGIC ITS commands

 arch/arm64/kvm/Makefile              |   2 +-
 arch/arm64/kvm/vgic/trace.h          | 135 ++++++++++++++++
 arch/arm64/kvm/vgic/vgic-its-debug.c | 234 +++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-its.c       |  58 ++++---
 arch/arm64/kvm/vgic/vgic.h           |  33 ++++
 5 files changed, 430 insertions(+), 32 deletions(-)
 create mode 100644 arch/arm64/kvm/vgic/vgic-its-debug.c


base-commit: 9d89551994a430b50c4fffcb1e617a057fa76e20
-- 
2.47.1.613.gc27f4b7a9f-goog


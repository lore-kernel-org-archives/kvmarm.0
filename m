Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327FA10F2
	for <kvmarm@lists.linux.dev>; Wed,  6 Nov 2024 08:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730881842; cv=none; b=BqpnUEGMiCCRisypToJFKNRDq7jRoOisOSIxEdP88133LkNyWJ9Vl/fCmObk5DMgO8P09pxbAUxxLvm8HFJL2dBUlxzNmBvZci37TLkcm30XlJT9Y2cSp71+Y2oMHzJvgmf5uzjA4oQgA7K3fyJRk1KIu9JzbAFibQiKl/CC24Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730881842; c=relaxed/simple;
	bh=uie5EwUupmfki0rGnZG5vo18XEMnIAkAeh6ikomY32c=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=WdcxI4P3AJ1WZixj87rMaEHK+c1nSbBckB/obRX8g/P4oPn4cgQfECQLcOf+Ao3Q3OLfDyoLYd4Ens6RHCz6v11zJoeUv0TONtlIBM1e+5DvG1RLuPTFA6B3SpHcXoWcmilCpx8m9CZZJvjxHBb7mXflNq4COhCleg+yqFAEzZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=b98Q5a+1; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="b98Q5a+1"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6ea33140094so121787407b3.1
        for <kvmarm@lists.linux.dev>; Wed, 06 Nov 2024 00:30:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730881840; x=1731486640; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=AsoJeQT7lIbORupJmPx8o8UcNDx1QgoC4+ZDQJoGnSc=;
        b=b98Q5a+15NeZLYZ653cOsNBWG4nlXjgNcg36jF7HdM4WjoXpbV2p9JpwFyma8gZWfa
         emq6pQFlcIUnJBsZ+kODnoGT+yKaFffDdyfOWG5vMpPJYG3gRN/z7oPVwq3HRyOk/TY1
         I6xsxf9ELtKcsCtAPdPA4GjfWrfTqPo2KCJfJZ/9979SzZp18di2Jtxz3tv9BmmZjf2D
         7f4lrRYPErSHty8T0im5YCLxzhrJTEcmRJP3PntvhNXCxuq/QoWg/yMrfpKyQ7i+YFxQ
         8tlHv2X7q4cZj5fyzKRh4X2wE88PWBhqfu4/X7/TzMsuVjfIxQBbya+hvm/jwxb+su7o
         gMYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730881840; x=1731486640;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AsoJeQT7lIbORupJmPx8o8UcNDx1QgoC4+ZDQJoGnSc=;
        b=Be//StODl32PYEmkboyfbXYVLC4ZhxBq7PZGvmvX6t/hhsrFf00uYAuE0MFVQ24RFY
         wtMQy5qj7EAOKSRnmboq0r8O6lKvdltsqMmtZwAO9Ti80vnJ+Afa1LVPKzSMJBX5iwJH
         yiKD5EV5VAlytHxSsdD6XmIz1E/HlZ++yCtncNL2dLZR/zAW0UJV83du6ldDApkIaJYx
         1qlM36npdYl4oidxhU+xVsjWggFvn1LVtWMxoIsqxRJbv/dmLFIXjWVopkGFhBoodUAG
         a6E87b/aR9U+EIiTPrR2jgZxxT+WBagMtfeocP2I9jH/Er5nuk9dPZvClDWOO7yAKq8m
         lzvQ==
X-Forwarded-Encrypted: i=1; AJvYcCUEdyBZsLxf/x7c8Fk5+rW3DPE+WLpNiB4XYA6qtndiZnLlpJ0X7YoMK0VuuMFBaXwrNaZF9Zk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxf1HROKxNSK+y7veTHHlAFUCj/5qV33Ll3dem0Ot5vsha894b7
	Y9EDUy7m+1b1odHK7uyGt75NSQVYRW58ip9lkOXO4dFIz4pQa6pd9wcV+b/el5jrvohj9UtjLfl
	s+lzm8BPztIAvXP0+cemRsw==
X-Google-Smtp-Source: AGHT+IFnO97LH4M7nakwImn7GhWO3dwEBs9GkzFartsysl46F+6jkXxf6aVj3MHFmDdtMe6k2kDQQQH6u4FDvb/Y/Q==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:36:e7b8:ac13:c96f])
 (user=jingzhangos job=sendgmr) by 2002:a81:c745:0:b0:6e3:f32:5fc8 with SMTP
 id 00721157ae682-6ea52319152mr944207b3.1.1730881839861; Wed, 06 Nov 2024
 00:30:39 -0800 (PST)
Date: Wed,  6 Nov 2024 00:30:31 -0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.277.g8800431eea-goog
Message-ID: <20241106083035.2813799-1-jingzhangos@google.com>
Subject: [PATCH v3 0/4] Some fixes about vgic-its
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Kunkun Jiang <jiangkunkun@huawei.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Andre Przywara <andre.przywara@arm.com>, 
	Colton Lewis <coltonlewis@google.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Shusen Li <lishusen2@huawei.com>, Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

This patch series addresses a critical issue in the VGIC ITS tables'
save/restore mechanism, accompanied by a comprehensive selftest for bug
reproduction and verification.

The fix is from Kunkun Jiang at [1]. Only a few typos are addressed.

The identified bug manifests as a failure in VM suspend/resume operations.
The root cause lies in the repeated suspend attempts often required for
successful VM suspension, coupled with concurrent device interrupt registration
and freeing. This concurrency leads to inconsistencies in ITS mappings before
the save operation, potentially leaving orphaned Device Translation Entries
(DTEs) and Interrupt Translation Entries (ITEs) in the respective tables.

During the subsequent restore operation, encountering these orphaned entries
can result in two error scenarios:
* EINVAL Error: If an orphaned entry lacks a corresponding collection ID, the
  restore operation fails with an EINVAL error.
* Mapping Corruption: If an orphaned entry possesses a valid collection ID, the
  restore operation may succeed but with incorrect or lost mappings,
  compromising system integrity.

The provided selftest facilitates the reproduction of both error scenarios:
* EINVAL Reproduction: Execute ./vgic_its_tables without any options.
* Mapping Corruption Reproduction: Execute ./vgic_its_tables -s
  The -s option enforces identical collection IDs for all mappings.
* A workaround within the selftest involves clearing the tables before the save
  operation using the command ./vgic_its_tables -c. With this, we can run the
  the selftest successfully on host w/o the fix.

---

* v2 -> v3:
  - Rebased to v6.12-rc6
  - Fixed some typos
  - Added a selftest for bug reproduction and verification

* v1 -> v2:
  - Replaced BUG_ON() with KVM_BUG_ON()

[1] https://lore.kernel.org/linux-arm-kernel/20240704142319.728-1-jiangkunkun@huawei.com

---

Jing Zhang (1):
  KVM: selftests: aarch64: Test VGIC ITS tables save/restore

Kunkun Jiang (3):
  KVM: arm64: vgic-its: Add a data length check in vgic_its_save_*
  KVM: arm64: vgic-its: Clear DTE when MAPD unmaps a device
  KVM: arm64: vgic-its: Clear ITE when DISCARD frees an ITE

 arch/arm64/kvm/vgic/vgic-its.c                |  44 +-
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/vgic_its_tables.c   | 566 ++++++++++++++++++
 .../kvm/include/aarch64/gic_v3_its.h          |   3 +-
 .../testing/selftests/kvm/include/kvm_util.h  |   4 +-
 .../selftests/kvm/lib/aarch64/gic_v3_its.c    |  24 +-
 6 files changed, 632 insertions(+), 10 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/vgic_its_tables.c


base-commit: 59b723cd2adbac2a34fc8e12c74ae26ae45bf230
-- 
2.47.0.277.g8800431eea-goog


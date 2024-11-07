Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2335D218958
	for <kvmarm@lists.linux.dev>; Thu,  7 Nov 2024 21:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731015702; cv=none; b=Ai+KqBgvfGQRSKl0ur7b1ucVcPLfVGmh5dfPJzdq6baO4F2dNT3S33p3H0FR+qMoGzZkNzimv9jeGeNhGHi3TzhpW3uZuViTUkouqzPuOOPPq69JSyDP4H71o2J3gH5sH9B41aIJjBgHLwHX5pKAT2gGTBFcnKzguASFyhzDJyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731015702; c=relaxed/simple;
	bh=q4ZHQxgTV8bsJCCWyN3hyqsECD5J82qaLuxwVTYXRD0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=SPx9rODfGiaC8ghAy4N6NySV3AH5K2to2D52w23nM4/rrCld8cKPtGVcAQQYHVrnBVQ5XalTyOTk2J3qHy41W7NjN4jYpfdEMC1shCMYP7EQ1HfoC0H3Y6qEjfIYbIoVY/vzxklSq8Bx2i7vGRGEI71NA5pMPTvMM1486gpW5iA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=r8J1pGll; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="r8J1pGll"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e29205f6063so2438480276.1
        for <kvmarm@lists.linux.dev>; Thu, 07 Nov 2024 13:41:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731015700; x=1731620500; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=U/2V0k0nsK2UijeufbuSOipQUsU110T9hQl5WTfC5qM=;
        b=r8J1pGllHlP20ttzZtWZdZGdSjN4yau6Zl4EWd1k22cHDaKnjrHQRFDrYAdn8rpteu
         yAFtQus8mdAsqT5ds4PFApl/rGvgAKNYgIaRaIikKIN42qxyoGd8TuQDlmevOHIn+WMX
         vnJFz/7GbhWPcxAHouZ146zWLxbh+VttDsks4LQLr3Rbq6uVRXRQlAW6o/NCjoV35YvB
         wmbMUIH95ekKETPnScb/utBYUtRfhBvRhA/IuO/REU2hf5RIS7fQ5UzK6Uu1ormR/niZ
         Y6SdeC8INWo+zhSMNQzFa69KmbmgHcSRIGYAtGb7pj6QxnyeejGgcgl53DM4E9nMEN5d
         /oPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731015700; x=1731620500;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=U/2V0k0nsK2UijeufbuSOipQUsU110T9hQl5WTfC5qM=;
        b=U80UrlsjCSF0fs5xKjV8SobxgpZMHGLd8o93L9Bqm1GKxoRsT68Y+km1GwGPE1imdA
         09f9nV09yQ9qKh0WmXZ3pCs6Isnd0jdDerXYqamOnPG8p6TorWQzrOXjNg/IXWzRHMSM
         4FHTqP5AMd6wOTXQF8Wvbl53mPmBwxxCRF7Hqp26VoTqCNZHaPvKAbZeQJN8eclJ9NyB
         x7ME48DG9GvEoBBKqE9I+KOxDrJ8T1MwwYy5cuUunx0Cw3/pXxVN4Lw0Vs6+eBXA6zVK
         6BJcF9A/pFnahdyf2UKYjW4hzALRqt4ZtQYJeyQd0E4FXFanxtjv31wbaZsG7Xu2pATA
         NMpQ==
X-Forwarded-Encrypted: i=1; AJvYcCW0ZLaCajcG/04DCrHh86mz9gIvwjthMC/MxqKJ+wuoOk6ADvVOnxqw+Ox91hFmjSVESMzWqMU=@lists.linux.dev
X-Gm-Message-State: AOJu0YymzoEFW/vWNOQRHQb6YkdKtssnx1A5ilZ3FLSXT0926ElNIeKI
	bT4euxYwGjKz1+xqcMLzivKdmw/6gRA7UI2WTR7LKADQD+vuOtt1Cl5kmC40v5OqSRr89oxQYAx
	ZJd4ijAQ25/tCl0ZoNZHICQ==
X-Google-Smtp-Source: AGHT+IHQa4/WDLxhwkTlxQKoJnSpSbWPLr4U+354oC+COKsIp0AWg/aYpXuPUvHJ5Ube9TvWVckE07rwKroGFx7ioQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:36:e7b8:ac13:c96f])
 (user=jingzhangos job=sendgmr) by 2002:a25:aaea:0:b0:e2b:d28f:bf28 with SMTP
 id 3f1490d57ef6-e337f844036mr1537276.2.1731015699859; Thu, 07 Nov 2024
 13:41:39 -0800 (PST)
Date: Thu,  7 Nov 2024 13:41:32 -0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.277.g8800431eea-goog
Message-ID: <20241107214137.428439-1-jingzhangos@google.com>
Subject: [PATCH v4 0/5] Some fixes about vgic-its
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Kunkun Jiang <jiangkunkun@huawei.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Andre Przywara <andre.przywara@arm.com>, 
	Colton Lewis <coltonlewis@google.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Shusen Li <lishusen2@huawei.com>, Eric Auger <eauger@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

This patch series addresses a critical issue in the VGIC ITS tables'
save/restore mechanism, accompanied by a comprehensive selftest for bug
reproduction and verification.

The fix is originally from Kunkun Jiang at [1]. 

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

* v3 -> v4:
  - Added two helper functions for table entry read/write in guest memory.
  - Move selftest as the first patch to easily run on a host without the fix.

* v2 -> v3:
  - Rebased to v6.12-rc6
  - Fixed some typos
  - Added a selftest for bug reproduction and verification

* v1 -> v2:
  - Replaced BUG_ON() with KVM_BUG_ON()

[1] https://lore.kernel.org/linux-arm-kernel/20240704142319.728-1-jiangkunkun@huawei.com

---

Jing Zhang (2):
  KVM: selftests: aarch64: Add VGIC selftest for save/restore ITS table
    mappings
  KVM: arm64: vgic-its: Add read/write helpers on ITS table entries.

Kunkun Jiang (3):
  KVM: arm64: vgic-its: Add a data length check in vgic_its_save_*
  KVM: arm64: vgic-its: Clear DTE when MAPD unmaps a device
  KVM: arm64: vgic-its: Clear ITE when DISCARD frees an ITE

 arch/arm64/kvm/vgic/vgic-its.c                |  31 +-
 arch/arm64/kvm/vgic/vgic.h                    |  23 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/vgic_its_tables.c   | 565 ++++++++++++++++++
 .../kvm/include/aarch64/gic_v3_its.h          |   3 +-
 .../testing/selftests/kvm/include/kvm_util.h  |   4 +-
 .../selftests/kvm/lib/aarch64/gic_v3_its.c    |  24 +-
 7 files changed, 631 insertions(+), 20 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/vgic_its_tables.c


base-commit: 59b723cd2adbac2a34fc8e12c74ae26ae45bf230
-- 
2.47.0.277.g8800431eea-goog


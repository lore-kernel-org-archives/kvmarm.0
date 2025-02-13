Received: from mail-ot1-f73.google.com (mail-ot1-f73.google.com [209.85.210.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE0F190468
	for <kvmarm@lists.linux.dev>; Thu, 13 Feb 2025 18:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739469917; cv=none; b=XcdRy/7cvWsTVrgn6J1puhTtcYXskguE2lx9m+qR+7dh2cniCi/grrwOfaphgdMfBxzpIpTYSo+jXEIv5caztYj5VbhwCRPKVDYCuoq+7MWioIl2N2rc4R6MweNin3xqIumHYsezHsOqaHSnMVTDXUfK2v625c1q1Sa8NoFY8Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739469917; c=relaxed/simple;
	bh=XXMTdbhQZ5qRWr2cYeBk2dfkftdsQbT7KMI+qPc6Who=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=QOX+5jN1uKuYlvWcYGNsBFLyEKeLXFRdQYXVdd/Q4SuSlLpdGgDm8QDIW4IuLJ5gycJSybgl6mGOv3TlUc6fTisdr58fRt3b0ZJv7xTDMWCn2CRZLj1WC6McFctmyh40cU/sDZRoWF0gR5d0W4GUL2EBKir0av71NsR+RUd/wPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1X7ttoEq; arc=none smtp.client-ip=209.85.210.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1X7ttoEq"
Received: by mail-ot1-f73.google.com with SMTP id 46e09a7af769-726e6412e1fso998043a34.1
        for <kvmarm@lists.linux.dev>; Thu, 13 Feb 2025 10:05:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739469915; x=1740074715; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wTjCHNALhtJm9kkINHAhPaKfRIpf+UugZZ6g0+G4iFA=;
        b=1X7ttoEqwS9FULmg5NDAgvSSVx/ah+Oh2o60cOUmCNKGFf9R1yqc3DBnh/y1pAksFE
         kR/QiIrElpDAfqzbnKKzSx01KXWSQuNbM6rvmbvC+EUrzdUhLpDOuILtzNcxQxKT1JzE
         klQnwr/DYdJXPonRCdtrfrVmltVwqphx6KPmEEy2iKO0zl815toB/THLIyzgs3tWQkTv
         7rZFtE0H2rypBoSZpB8L6sRARkzIiecglP+xzDs0ORAhNme1wuE8NTs5hYjcQso6d2/M
         o1pCTV3lsM9eeuvjPSxDUihUaJD5vAr8cVFmmbJUeZ5dypd633yM3mVfTn4UoaidYBbf
         XIDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739469915; x=1740074715;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wTjCHNALhtJm9kkINHAhPaKfRIpf+UugZZ6g0+G4iFA=;
        b=c1Uo4IseOjdu+WeRWXjFd1nsimQkTfD+95/WjWXnC51oQenseMTM+UClK2p/Uae2on
         vrnsXj+wFR3RTdGkE2ax4+0mPnpDRKSvpvOR1OygnJFo7899wGAzOM11W0R+DUkWtO1J
         FJX6wJ8rkBS7cdjffS6hdECPNHIbbMot7K1hCINdCdY42Zl/FMdwBDr+yFjFTMPpp5t3
         AMF9+/UU6K32XAo2bjpy3kOf0ABYMw6IGjb/3ou/OyEnlt9NzsjM/ALtk4Nlpzig5dyj
         Z6rmr1KNktjOgZsaPMuzZ2oZ/8Wu4YfO4YqWixKpr2EVy5PfiAtzkBTEGA79+4jJr1FY
         Fj1w==
X-Forwarded-Encrypted: i=1; AJvYcCU1DT75n8PSL1HP2s5hj+IQRyxV/irZ1gVkIiq2jcEmMgkLZJDAZthOH0hBO/U+ftAcqedCFSU=@lists.linux.dev
X-Gm-Message-State: AOJu0YwY+wStAtq9wye3b0LGSYNu8+UciCYIjA9Lmc90cTA9q/Rw789A
	UHrdW8RrDWas16P60jWUipo225lrwEEGUOJatqCuAX9BASr7RZO10lupFclBGvltxC9ZqGGfjCe
	4iuXmZlnVo8fWdyqjJd1u6g==
X-Google-Smtp-Source: AGHT+IGskVqY6i9bRXfX/e76DJqFlexfmJ+792ViVNAj9Su+9gvc9IWKEbkYdQXuRHWIlqliVBeP0nYN3f0kCSEvKQ==
X-Received: from otbcv2.prod.google.com ([2002:a05:6830:6882:b0:71d:f81f:c595])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6830:410a:b0:71d:415a:5d18 with SMTP id 46e09a7af769-726f302e609mr5209306a34.3.1739469914886;
 Thu, 13 Feb 2025 10:05:14 -0800 (PST)
Date: Thu, 13 Feb 2025 18:03:09 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250213180317.3205285-1-coltonlewis@google.com>
Subject: [RFC PATCH v3 0/8] PMU partitioning driver support
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

This series introduces support in the KVM and ARM PMUv3 driver for
partitioning PMU counters into two separate ranges by taking advantage
of the MDCR_EL2.HPMN register field.

The advantage of a partitioned PMU would be to allow KVM guests direct
access to a subset of PMU functionality, greatly reducing the overhead
of performance monitoring in guests.

While this feature could be accepted on its own merits, practically
there is a lot more to be done before it will be fully useful, so I'm
sending as an RFC for now.

v3:
* Include cpucap definition for FEAT_HPMN0 to allow for setting HPMN
  to 0

* Include PMU header cleanup provided by Marc [1] with some minor
  changes so compilation works

* Pull functions out of pmu-emul.c that aren't specific to the
  emulated PMU. This and the previous item aren't strictly
  needed but they provide a nicer starting point.

* As suggested by Oliver, start a file for partitioned PMU functions
  and move the reserved_host_counters parameter and MDCR handling into
  KVM so the driver does not have to know about it and we need fewer
  hacks to keep the driver working on 32-bit ARM. This was not a
  complete separation because the driver still needs to start and stop
  the host counters all at once and needs to toggle MDCR_EL2.HPME to
  do that. Introduce kvm_pmu_host_counters_{enable,disable}()
  functions to handle this and define them as no ops on 32-bit ARM.

* As suggested by Oliver, don't limit PMCR.N on emulated PMU. This
  value will be read correctly when the right traps are disabled to
  use the partitioned PMU

v2:
https://lore.kernel.org/kvm/20250208020111.2068239-1-coltonlewis@google.com/

v1:
https://lore.kernel.org/kvm/20250127222031.3078945-1-coltonlewis@google.com/

[1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/pmu-includes

Colton Lewis (7):
  arm64: cpufeature: Add cap for HPMN0
  arm64: Generate sign macro for sysreg Enums
  KVM: arm64: Reorganize PMU functions
  KVM: arm64: Introduce module param to partition the PMU
  perf: arm_pmuv3: Generalize counter bitmasks
  perf: arm_pmuv3: Keep out of guest counter partition
  KVM: arm64: selftests: Reword selftests error

Marc Zyngier (1):
  KVM: arm64: Cleanup PMU includes

 arch/arm/include/asm/arm_pmuv3.h              |   2 +
 arch/arm64/include/asm/arm_pmuv3.h            |   2 +-
 arch/arm64/include/asm/kvm_host.h             | 199 +++++++-
 arch/arm64/include/asm/kvm_pmu.h              |  47 ++
 arch/arm64/kernel/cpufeature.c                |   8 +
 arch/arm64/kvm/Makefile                       |   2 +-
 arch/arm64/kvm/arm.c                          |   1 -
 arch/arm64/kvm/debug.c                        |  10 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h       |   1 +
 arch/arm64/kvm/pmu-emul.c                     | 464 +-----------------
 arch/arm64/kvm/pmu-part.c                     |  63 +++
 arch/arm64/kvm/pmu.c                          | 454 +++++++++++++++++
 arch/arm64/kvm/sys_regs.c                     |   2 +
 arch/arm64/tools/cpucaps                      |   1 +
 arch/arm64/tools/gen-sysreg.awk               |   1 +
 arch/arm64/tools/sysreg                       |   6 +-
 drivers/perf/arm_pmuv3.c                      |  73 ++-
 include/kvm/arm_pmu.h                         | 204 --------
 include/linux/perf/arm_pmu.h                  |  16 +-
 include/linux/perf/arm_pmuv3.h                |  27 +-
 .../selftests/kvm/arm64/vpmu_counter_access.c |   2 +-
 virt/kvm/kvm_main.c                           |   1 +
 22 files changed, 882 insertions(+), 704 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_pmu.h
 create mode 100644 arch/arm64/kvm/pmu-part.c
 delete mode 100644 include/kvm/arm_pmu.h


base-commit: 2014c95afecee3e76ca4a56956a936e23283f05b
--
2.48.1.601.g30ceb7b040-goog

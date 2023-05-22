Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03C11642B
	for <kvmarm@lists.linux.dev>; Mon, 22 May 2023 22:18:38 +0000 (UTC)
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-64d11e07868so3091769b3a.3
        for <kvmarm@lists.linux.dev>; Mon, 22 May 2023 15:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684793918; x=1687385918;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dc4gy2OJK1GSTndBVdU+FFnqd/hG/qmsMHmmQ43RlTM=;
        b=AFHEVsY780/IwFzkk7gl9k4v8g6D9HZiZaUXfNElQY6niQTrix3aP1UzgnFTGQLVQv
         d9o7n9Ax6Vq+22Jz+ERm4gSA+r1RZx9E2UPvEoO8KtSzYXGXEQrkzPV7c8AeciYX/ARf
         oT60n0NsIPYyTtHZkhP3KTuecCnSkZE8uIlAsUhPZHGEBF5vKpODV/XuuC+iswFocfz2
         9PFpz1m4/in5yb6JmR7WSCdByCXyLXA+qN4c9IHKSWXZhkbGFGYc/MdcU8NYOZ8aA6uI
         Fzc+X5DPXUlecoWJUGLOD1QwCiIoF+ArbPEnKRshX1/bC2xW2ebcCHAiKvT1UE9YWZhX
         4lkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684793918; x=1687385918;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dc4gy2OJK1GSTndBVdU+FFnqd/hG/qmsMHmmQ43RlTM=;
        b=AMO3W17p7BhPCOmkOw3MA/PZivQf9ykkXF0ViePFJnwytkGNDsGtFzeaBDiXuge0Bw
         xcpE0fRBc5VYhftsysy1QaR1LdPeIfI+429jEPQGYnMdM3vVY3ovvMhCgQa0uFsjjWzv
         CV/oCy8/YZKs4Lphr93A35R4Yc+Vs6GWzfEmv+0MVoG14ajyo1v2WOLv6KzDeyYCJRxd
         SBLRKh4S7g3uxxo8HzWRseMuwR2wGBNGCggCWlXmPgrryuFAehq4nARzSUWhQR/gEkXg
         4oXJJB6m6b3+2tjUzgpUpqdK4SGauWCaH8qwVX6feBxOJfB7NLEp98JqK2JVf4El0b7k
         jU8w==
X-Gm-Message-State: AC+VfDwEwn8BbtXH/W97AMdnwYNLcf7wOb4KcEKj55o2vx6JmIgJ6hEC
	YAd9VYohr29UfEav/FbmGtZzxxzhFNHVGkJBiw==
X-Google-Smtp-Source: ACHHUZ6H5hIJqaC36GavRELQjAZAMqYhtwqAgC0dtBDJCIhgGHV1be0gt84M9UzPvMWCYsJMLWWczAhZCIVn8PqDrQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6a00:15c7:b0:641:31b1:e787 with
 SMTP id o7-20020a056a0015c700b0064131b1e787mr5038528pfu.5.1684793918271; Mon,
 22 May 2023 15:18:38 -0700 (PDT)
Date: Mon, 22 May 2023 22:18:30 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
Message-ID: <20230522221835.957419-1-jingzhangos@google.com>
Subject: [PATCH v10 0/5] Support writable CPU ID registers from userspace
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@google.com>
Cc: Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

This patchset refactors/adds code to support writable per guest CPU ID feature
registers. Part of the code/ideas are from
https://lore.kernel.org/all/20220419065544.3616948-1-reijiw@google.com .
No functional change is intended in this patchset. With the new CPU ID feature
registers infrastructure, only writtings of ID_AA64PFR0_EL1.[CSV2|CSV3],
ID_AA64DFR0_EL1.PMUVer and ID_DFR0_ELF.PerfMon are allowed as KVM does before.

Writable (Configurable) per guest CPU ID feature registers are useful for
creating/migrating guest on ARM CPUs with different kinds of features.

This patchset uses kvm->arch.config_lock from Oliver's lock inversion fixes at
https://lore.kernel.org/linux-arm-kernel/20230327164747.2466958-1-oliver.upton@linux.dev/

---

* v9 - v10
  - Rebased to v6.4-rc3
  - Addressed some review comments from v8/v9.

* v8 -> v9
  - Rebased to v6.4-rc2.
  - Don't create new file id_regs.c and don't move out id regs from
    sys_reg_descs array to reduce the changes.

* v7 -> v8
  - Move idregs table sanity check to kvm_sys_reg_table_init.
  - Only allow userspace writing before VM running.
  - No lock is hold for guest access to idregs.
  - Addressed some other comments from Reiji and Oliver.

* v6 -> v7
  - Rebased to v6.3-rc7.
  - Add helpers for idregs read/write.
  - Guard all idregs reads/writes.
  - Add code to fix features' safe value type which is different for KVM than
    for the host.

* v5 -> v6
  - Rebased to v6.3-rc5.
  - Reuse struct sys_reg_desc's reset() callback and field val for KVM.
    sanitisation function and writable mask instead of creating a new data
    structure for idregs.
  - Use get_arm64_ftr_reg() instead of exposing idregs ftr_bits array.

* v4 -> v5
  - Rebased to 2fad20ae05cb (kvmarm/next)
    Merge branch kvm-arm64/selftest/misc-6,4 into kvmarm-master/next
  - Use kvm->arch.config_lock to guard update to multiple VM scope idregs
    to avoid lock inversion
  - Add back IDREG() macro for idregs access
  - Refactor struct id_reg_desc by using existing infrastructure.
  - Addressed many other comments from Marc.

* v3 -> v4
  - Remove IDREG() macro for ID reg access, use simple array access instead
  - Rename kvm_arm_read_id_reg_with_encoding() to kvm_arm_read_id_reg()
  - Save perfmon value in ID_DFR0_EL1 instead of pmuver
  - Update perfmon in ID_DFR0_EL1 and pmuver in ID_AA64DFR0_EL1 atomically
  - Remove kvm_vcpu_has_pmu() in macro kvm_pmu_is_3p5()
  - Improve ID register sanity checking in kvm_arm_check_idreg_table()

* v2 -> v3
  - Rebased to 96a4627dbbd4 (kvmarm/next)
    Merge tag ' https://github.com/oupton/linux tags/kvmarm-6.3' from into kvmarm-master/next
  - Add id registere emulation entry point function emulate_id_reg
  - Fix consistency for ID_AA64DFR0_EL1.PMUVer and ID_DFR0_EL1.PerfMon
  - Improve the checking for id register table by ensuring that every entry has
    the correct id register encoding.
  - Addressed other comments from Reiji and Marc.

* v1 -> v2
  - Rebase to 7121a2e1d107 (kvmarm/next) Merge branch kvm-arm64/nv-prefix into kvmarm/next
  - Address writing issue for PMUVer

[1] https://lore.kernel.org/all/20230201025048.205820-1-jingzhangos@google.com
[2] https://lore.kernel.org/all/20230212215830.2975485-1-jingzhangos@google.com
[3] https://lore.kernel.org/all/20230228062246.1222387-1-jingzhangos@google.com
[4] https://lore.kernel.org/all/20230317050637.766317-1-jingzhangos@google.com
[5] https://lore.kernel.org/all/20230402183735.3011540-1-jingzhangos@google.com
[6] https://lore.kernel.org/all/20230404035344.4043856-1-jingzhangos@google.com
[7] https://lore.kernel.org/all/20230424234704.2571444-1-jingzhangos@google.com
[8] https://lore.kernel.org/all/20230503171618.2020461-1-jingzhangos@google.com
[9] https://lore.kernel.org/all/20230517061015.1915934-1-jingzhangos@google.com

---

Jing Zhang (5):
  KVM: arm64: Save ID registers' sanitized value per guest
  KVM: arm64: Use per guest ID register for ID_AA64PFR0_EL1.[CSV2|CSV3]
  KVM: arm64: Use per guest ID register for ID_AA64DFR0_EL1.PMUVer
  KVM: arm64: Reuse fields of sys_reg_desc for idreg
  KVM: arm64: Refactor writings for PMUVer/CSV2/CSV3

 arch/arm64/include/asm/cpufeature.h |   1 +
 arch/arm64/include/asm/kvm_host.h   |  34 +-
 arch/arm64/kernel/cpufeature.c      |   2 +-
 arch/arm64/kvm/arm.c                |  24 +-
 arch/arm64/kvm/sys_regs.c           | 469 +++++++++++++++++++++++-----
 arch/arm64/kvm/sys_regs.h           |  22 +-
 include/kvm/arm_pmu.h               |   5 +-
 7 files changed, 437 insertions(+), 120 deletions(-)


base-commit: 44c026a73be8038f03dbdeef028b642880cf1511
-- 
2.40.1.698.g37aff9b760-goog


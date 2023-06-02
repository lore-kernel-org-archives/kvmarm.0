Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD1210E3
	for <kvmarm@lists.linux.dev>; Fri,  2 Jun 2023 00:51:21 +0000 (UTC)
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-53feeb13906so1388657a12.1
        for <kvmarm@lists.linux.dev>; Thu, 01 Jun 2023 17:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685667081; x=1688259081;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=IxvLemz2dwjbVsZeFniwB3W6eHn7soIs0M/JRgk9xg4=;
        b=GEjj1FOZ5jb9LNTGCbLI3ZIgUSFvnTRkljNl5ECcGpFRtDDQgryCpCGvxiwydXIqFq
         Fj/TG9oZUDLKnp5ZOkvVcZDo3kThphVkWx2nD8FxNv03IgiVXHIq8YJsAyQOPk6dGrWw
         ZPE8+6pE6S+xpg1xUYIIy6d4K/zsWOvy9vYk+XnknfzN5LM8QNeJygV7gkeAyB/gZ2VA
         MBIcIwAqaw7pAErk1qR2rG9mko25OTwyQCMv7UsspIzTyA4tYZ8cp1VEfvZW0JbM9k5v
         cc6knnDPjomMQbHYNTnQ/Ztv6XKHUTLWLjxqeJnCwuddupqscSQEpC65B/8TIjiAsQN1
         C5MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685667081; x=1688259081;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IxvLemz2dwjbVsZeFniwB3W6eHn7soIs0M/JRgk9xg4=;
        b=G0gzYprh4q7BJd6+oqC9XGuUsTOcPiW3eGxhW8P0SvFFI1pLdZgEaRY3PW2mPN8kN7
         9oP/kZRuDMx+AnkeFy0J2g1FZePz2Qs/GnNZ1ERSU/zYJc4RxP12ISpdy7MWA3bBTKYp
         e9om0M7oHFxly02Lb/S/38NfLAnxArxtchdncwNWbqrEPHoLaDjWTzwRZLQo/nOxi6J8
         Pf9TLhvSDlQN97vb6cmoEC/gg6PVyQV+vE1YwLmn0gfZt3z9sMl78H4ZDRz6eY5Tjmy8
         9aFHIdWmzR7DPt/KmzVRvOAYfJNIdJvnmBSOW5rmuEeKQHDAXw0BJw8N46MzpxMBm/49
         +RYg==
X-Gm-Message-State: AC+VfDy9pYyzvdBjK+AZJDHOYouwLHa2w/LdCgv71XGB2JH0JPYZWymO
	Vv7VlewESv3oa2R0EwsawdOf8ENriD8Aa6SFrg==
X-Google-Smtp-Source: ACHHUZ7h7YTHXBw/obvVBcvxv3KNZsDAptNpRkqVyS5QFQESZR2NZXottv72XrrrTgZs50trWDYerzHFJ9Pm0tKJHg==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:90b:e84:b0:256:6214:4834 with SMTP
 id fv4-20020a17090b0e8400b0025662144834mr203358pjb.4.1685667081410; Thu, 01
 Jun 2023 17:51:21 -0700 (PDT)
Date: Fri,  2 Jun 2023 00:51:12 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230602005118.2899664-1-jingzhangos@google.com>
Subject: [PATCH v11 0/5] Support writable CPU ID registers from userspace
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

* v10 - v11
  - Rebased to v6.4-rc4.
  - Move one time searching of first ID reg from kvm_arm_init_id_regs() to
    kvm_sys_reg_table_init().
  - Move the lock/unlock of arch.config_lock and whether vm has ran to
    kvm_sys_reg_get_user()/kvm_sys_reg_set_user().
  - Addressed some other review comments from Marc and Oliver.

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
[10] https://lore.kernel.org/all/20230522221835.957419-1-jingzhangos@google.com

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
 arch/arm64/kvm/sys_regs.c           | 467 ++++++++++++++++++++++------
 arch/arm64/kvm/sys_regs.h           |  22 +-
 include/kvm/arm_pmu.h               |   9 +-
 7 files changed, 419 insertions(+), 140 deletions(-)


base-commit: 7877cb91f1081754a1487c144d85dc0d2e2e7fc4
-- 
2.41.0.rc0.172.g3f132b7071-goog


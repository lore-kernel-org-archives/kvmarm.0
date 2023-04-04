Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 753EC7C
	for <kvmarm@lists.linux.dev>; Tue,  4 Apr 2023 03:53:47 +0000 (UTC)
Received: by mail-pl1-f201.google.com with SMTP id n13-20020a170902d2cd00b001a22d27406bso16936315plc.13
        for <kvmarm@lists.linux.dev>; Mon, 03 Apr 2023 20:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680580427;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Kl6XH7tsAvbCeHiUIQpcSJ8z/9T0GbF7s7ZTe/CJjI8=;
        b=ZJtZ3QkBwaqzM6X3963/YPwxJHfGZQbe02Ext9gV1LQX8kN7cpb3f3zrXaSw/nGdRO
         0FJIiFqqCOrwxsteNiUfP2UBtaawRHVyUh/muSx7MapgJdDDsMkqhNpYUPL3UJzanT3s
         UHZizYqmgw4v4g3XZkYxpXsvPLmUcsf9U7r36RkYAimpCB0RuYvI3hNnkhLn+N9ZSIct
         fTj297YMQMlT/49BSdPQ+ozIrdV+hTobtvsKnHQPOZprhaE16mfVyRYksW6s2GIQe6l6
         dnuOJbTfDOLfEBcFvn2Q7amY9LvCnPiLb23yWj3oDJxgB+o+B6W1U/r3iEBkxEkwzWtN
         nJuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680580427;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Kl6XH7tsAvbCeHiUIQpcSJ8z/9T0GbF7s7ZTe/CJjI8=;
        b=CLAtMdbD3utCujJJkotHh4JO/MbCS7g4s4mlj4OxtmxJIrMEAEraIhym3fLWiIh74z
         kEq+r1zmhyQkmrqXEVNQklYeLBnhiH5qyCxcwRLxbpCCHWUBzVNhclK9qHHWTKhp9BPZ
         OZoS92IilzSMYiyxjCGBbWGoFiLUbrspjXLLx+nOkkLmzJSLaQRuXv0nNIxZP/cTPT8g
         G1bFBNUHjs6BkIKpNEMeBGEOCksJL5uCt/Mgi8v/m8/UxYMeRhZKB1OV3njIYqfZpFJ7
         KB+N1ko+NPof/2DFhR3Ww2avZsZc+Yey37qFNs1ICDkEgwKZ2iQMQVxFfBT1GRisxydQ
         wIog==
X-Gm-Message-State: AAQBX9f0LWKXSCr2Cuo4pghS/5QpNMd0mOeH6Oqx6/4x6c8m8zhEIG2P
	nidK0dyLTwPcomFU8V5SRIOrcBUBMLfZag/6CA==
X-Google-Smtp-Source: AKy350ZJfffhvWGlxC1EcPyUK94RX+9STEn5IxpVxmbl99uTVRhb6XFmqy/CVVWHJ1om8sN4O/I1Mmxxdu4SRKLB1g==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:903:494:b0:19a:e3d4:216e with SMTP
 id jj20-20020a170903049400b0019ae3d4216emr481174plb.7.1680580426875; Mon, 03
 Apr 2023 20:53:46 -0700 (PDT)
Date: Tue,  4 Apr 2023 03:53:38 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230404035344.4043856-1-jingzhangos@google.com>
Subject: [PATCH v6 0/6] Support writable CPU ID registers from userspace
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

---

Jing Zhang (6):
  KVM: arm64: Move CPU ID feature registers emulation into a separate
    file
  KVM: arm64: Save ID registers' sanitized value per guest
  KVM: arm64: Use per guest ID register for ID_AA64PFR0_EL1.[CSV2|CSV3]
  KVM: arm64: Use per guest ID register for ID_AA64DFR0_EL1.PMUVer
  KVM: arm64: Reuse fields of sys_reg_desc for idreg
  KVM: arm64: Refactor writings for PMUVer/CSV2/CSV3

 arch/arm64/include/asm/cpufeature.h |   1 +
 arch/arm64/include/asm/kvm_host.h   |  34 +-
 arch/arm64/kernel/cpufeature.c      |   2 +-
 arch/arm64/kvm/Makefile             |   2 +-
 arch/arm64/kvm/arm.c                |  24 +-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c  |   7 -
 arch/arm64/kvm/id_regs.c            | 670 ++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c           | 525 ++++------------------
 arch/arm64/kvm/sys_regs.h           |  28 +-
 include/kvm/arm_pmu.h               |   5 +-
 10 files changed, 809 insertions(+), 489 deletions(-)
 create mode 100644 arch/arm64/kvm/id_regs.c


base-commit: 7e364e56293bb98cae1b55fd835f5991c4e96e7d
-- 
2.40.0.348.gf938b09366-goog


Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A422B7470
	for <kvmarm@lists.linux.dev>; Mon, 24 Apr 2023 23:47:08 +0000 (UTC)
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-63b79d8043eso26480678b3a.0
        for <kvmarm@lists.linux.dev>; Mon, 24 Apr 2023 16:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682380028; x=1684972028;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6Ot+Rlnm7hn0ij7rFbhHCvuqwiEfbByzG62dXdUvoFM=;
        b=C7G+CTI+zTaYdXEebMpoh3NA7eElM3eZcBitcG3FWy623s36A3AFCzEkoqO+5X70zG
         Hn4qOxvU+H8ktV/dvTpDC8F8e4kCT/kkmmvjUFwN43rBcc29BjM3raapLyCM+c47OcQZ
         ZKxas7fxqwOTLFnkvlKa1SBh2gqw9e4KWfQA9xRq56L8tvTXPELZOdaF/BzpbizVNSwW
         CiLoltdtJWNpdyrFK3XLwwAZA2hk4q3LFtd8/wrndrSyx9RwcHvmE25PlBCSCQS4Tjlz
         TRTA2nvnLqel0piqWvuxKJpkrXPz3JtdQegjNrmCuK08YwnFUP96Bv/HlJIr9767SsL9
         uETw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682380028; x=1684972028;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6Ot+Rlnm7hn0ij7rFbhHCvuqwiEfbByzG62dXdUvoFM=;
        b=kZ173zRnU2VWucYRd10zwELsxHD6Y0nXIXlLSN5PT0L9K21UjaGwgxwLYHRQYa63ju
         6Gyh1CIE8oDdRw3tdt5tq660r+SaPobNrNOPLRbdPzfqnFW1k4xMpRHKLuBswIklao6p
         /7LhY81txiVpnCpA5jyb0J39kJelLfxmebsTliBkzPo2V4cKkRCoaFesihdTHy7ooMdz
         HPEW/HNirWkhWV/mr5+u4PHmwOijEff40ngaatgDrZA0HQZedoN1jW1c0SvbBi6ZCnvr
         ZF6rxjuHaWFOncyx7zWoJmhd4HYRjW7YKgGj8cV86QEudNXy9jdQ6qhkPQVlv2xxWXjY
         bGHA==
X-Gm-Message-State: AAQBX9fgfu6trbbqvbVDf2UpNZ1XnJKA9pkzkn+fW9S4r0kaAEJWPWKG
	1VyY3Sc3kMovF8WizS2aPO1SHb82YRUYxUZ+KA==
X-Google-Smtp-Source: AKy350YA2bOuxPuU0rjoWOaZFXNoIaerjZaOX9j0+SAeMzgaYiYyYu3xvNxbQC5ZlX/uH0ik+Rf1lqGSKK19ZJ/R6g==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:90a:3481:b0:246:ac5c:ba3f with
 SMTP id p1-20020a17090a348100b00246ac5cba3fmr3352874pjb.0.1682380028103; Mon,
 24 Apr 2023 16:47:08 -0700 (PDT)
Date: Mon, 24 Apr 2023 23:46:58 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230424234704.2571444-1-jingzhangos@google.com>
Subject: [PATCH v7 0/6] Support writable CPU ID registers from userspace
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
 arch/arm64/include/asm/kvm_host.h   |  60 ++-
 arch/arm64/kernel/cpufeature.c      |   2 +-
 arch/arm64/kvm/Makefile             |   2 +-
 arch/arm64/kvm/arm.c                |  24 +-
 arch/arm64/kvm/id_regs.c            | 692 ++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c           | 525 ++++-----------------
 arch/arm64/kvm/sys_regs.h           |  28 +-
 include/kvm/arm_pmu.h               |   5 +-
 9 files changed, 857 insertions(+), 482 deletions(-)
 create mode 100644 arch/arm64/kvm/id_regs.c


base-commit: 6a8f57ae2eb07ab39a6f0ccad60c760743051026
-- 
2.40.0.634.g4ca3ef3211-goog


Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E055255
	for <kvmarm@lists.linux.dev>; Wed, 17 May 2023 06:10:19 +0000 (UTC)
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-520f3f18991so223370a12.3
        for <kvmarm@lists.linux.dev>; Tue, 16 May 2023 23:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684303819; x=1686895819;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5vgkms3bE9opKTZQvJe26hV6yisTQL3/1UTH/Z61J20=;
        b=GQyGweibZozfSF/kXgltqpOdvljhbFcW8O0ZC4Ljh/l8Em0ttNGMtQ5bDpibEDRKGx
         62CDqgrtH1BAMWmE2bhr2ryagFS51LN4tovGR7TymDHPjX/0LT5Cva8Rgc8aMJd81Ym4
         bcoKSEVAzUJJWVRkCKs4Re7sEEO586CTxwB2OkW3/jFSzcoN0lH+DTB8r19TQnwMhLbJ
         cZoLBe4MWpat44SMdCH42dgvHV03bzAuar8NW1keoiG699NdTCTd7ZrT1jS+c0X1Bme+
         OTY5aCoE6yU7xlkljY1mBglRPsln31mcfWxOVsTlO2q2vD6GyVa7jQj5ffQXnpz1Iojp
         wbvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684303819; x=1686895819;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5vgkms3bE9opKTZQvJe26hV6yisTQL3/1UTH/Z61J20=;
        b=QKMuolTd2aM/omHLC1aTba/0cOCnuGiC2Vmg9igP0c0Egexu++R5gM2NEgL1/DdKDG
         DlPy6PUEtoRdYLL0oFNBIL36cxIsJBCCV3XLbEHwWCOmH2oEE/Ubopc5lYqCTXYKpH1f
         oEhmrmS+HAf5Uqbut894+zgwFxicHPCKxcu+pUv/SeVI6WiONfmcV1CmupI2newr5ZJD
         AM0FpUdc8nMN2JBR6eH0l41Muv9dZoWPeAxvr85EAoLLZnAzAMNQmbbMBqzy8yrEUf22
         WOgi3GqBBKNGl9CkM3YU9csNaq4PRZYXCYvY5JybKXNKp2qCDQg1v0FhekpI9dlbVy48
         XG9w==
X-Gm-Message-State: AC+VfDy0RkgsuCakMGjginC5/QvysuxJzZn9xP8g2v5Wk/saRtEygZF8
	dAZF1+0+8opSx46hEQKzbdaIVdpM5H57nIEmFA==
X-Google-Smtp-Source: ACHHUZ4f3shn/9mstHq7qrXdWYkBsYliV5r0AqLzDASIeXL0z32Qlo6BIxCZTd3/6/FM8FirMMG/4Lenw8afKU/SSQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a63:8b49:0:b0:530:dc2:78bc with SMTP
 id j70-20020a638b49000000b005300dc278bcmr9241400pge.12.1684303819108; Tue, 16
 May 2023 23:10:19 -0700 (PDT)
Date: Wed, 17 May 2023 06:10:09 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230517061015.1915934-1-jingzhangos@google.com>
Subject: [PATCH v9 0/5] Support writable CPU ID registers from userspace
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


base-commit: f1fcbaa18b28dec10281551dfe6ed3a3ed80e3d6
-- 
2.40.1.606.ga4b1b128d6-goog


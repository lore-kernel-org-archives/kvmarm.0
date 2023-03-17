Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD69641
	for <kvmarm@lists.linux.dev>; Fri, 17 Mar 2023 05:06:44 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id ch1-20020a0569020b0100b00b3cc5b4fa9dso4128838ybb.12
        for <kvmarm@lists.linux.dev>; Thu, 16 Mar 2023 22:06:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679029604;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=w+vwBZQ4cXLwZeDSUo6XQ4+Y+78q4qqtLXFPZEGCVUQ=;
        b=KbuTLGnltMuNZQ5sMF45pEMsyEzUo78gxBk3ywtddoj6JDGRKbN1BY4bYc/L3f6mop
         GhyXRFH8odKpFZUt4QSzS9Pvi3qdxPrJGzRNSxd6oU/8xS/l8M1nLMIQ+H8aQ93IDbwP
         6sDbk1IcwCF7YjzggNHpWhWx2oz4BqgKs0Lj+HuDpPXp/SZIXM56ZC5333kqgqkeV5xO
         ao/XPo4yUMYUIYz4yduWqAovQliIyw9uEmSxTxyYwGW3dz7ec5rcqXzQ2YUTBCJmx8Bw
         6qXKSICttfV2sihfU452YpIGJBwVO3uRGB76oGi1cwP/XgrRvBQ23zIRQOdYIUfT1Z9p
         EEXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679029604;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=w+vwBZQ4cXLwZeDSUo6XQ4+Y+78q4qqtLXFPZEGCVUQ=;
        b=1mUi+i+D9GpKQSp5is5ee+QARnnutoObuJSfY6d2GJ8XNfh7SmKLxgHA3X+lJZBlNW
         8NABPidA9dbXC51gvGqz+u3I2bwY/omPFPemhm1+NEJ3g2RXuqOsTadOOody8o2dTiH+
         igJv7rYngyH9ErSgoavn92CtXPG+tLCi3Cm0KwZorwtPIh9vlCnraPfV1O0O1EqLqSms
         /UZF+p8+EsVDGO71dycFCnGkxsiMOz3rOY0PYX7D5tuuqL1j65u8lt/GKEOkR9yt/fUO
         NOLJa86VkAt8TMH3OxhjyYGku8pwqxMgEbynY2zEo27aPUY30Tz5lcs8pTe1hDycHqIW
         MkWw==
X-Gm-Message-State: AO0yUKV1pmZqzVv3TlIfyPaz7ArcExT/EJAcpuMeXB1iOtYrZ83p5Dbr
	rVOZcsZJM91U8wQhfgdFKfhpMst/cTKZF8lnVw==
X-Google-Smtp-Source: AK7set/YoPAtT2ABNeHbY3weqdIX4biMtQPIuYq5sSnuILz3MjucdJN9sjsx84/fFa7D7o3kyaa2v5Fh19Y8IAjS4Q==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a25:aca8:0:b0:b26:884:c35e with SMTP
 id x40-20020a25aca8000000b00b260884c35emr1204754ybi.4.1679029603938; Thu, 16
 Mar 2023 22:06:43 -0700 (PDT)
Date: Fri, 17 Mar 2023 05:06:31 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230317050637.766317-1-jingzhangos@google.com>
Subject: [PATCH v4 0/6] Support writable CPU ID registers from userspace
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@google.com>
Cc: Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Ricardo Koller <ricarkol@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

This patchset refactors/adds code to support writable per guest CPU ID feature
registers. Part of the code/ideas are from
https://lore.kernel.org/all/20220419065544.3616948-1-reijiw@google.com .
No functional change is intended in this patchset. With the new CPU ID feature
registers infrastructure, only writtings of ID_AA64PFR0_EL1.[CSV2|CSV3],
ID_AA64DFR0_EL1.PMUVer and ID_DFR0_ELF.PerfMon are allowed as KVM does before.

Writable (Configurable) per guest CPU ID feature registers are useful for
creating/migrating guest on ARM CPUs with different kinds of features.

---

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

---

Jing Zhang (5):
  KVM: arm64: Move CPU ID feature registers emulation into a separate
    file
  KVM: arm64: Use per guest ID register for ID_AA64PFR0_EL1.[CSV2|CSV3]
  KVM: arm64: Use per guest ID register for ID_AA64DFR0_EL1.PMUVer
  KVM: arm64: Introduce ID register specific descriptor
  KVM: arm64: Refactor writings for PMUVer/CSV2/CSV3

Reiji Watanabe (1):
  KVM: arm64: Save ID registers' sanitized value per guest

 arch/arm64/include/asm/cpufeature.h |  25 +
 arch/arm64/include/asm/kvm_host.h   |  24 +-
 arch/arm64/kernel/cpufeature.c      |  26 +-
 arch/arm64/kvm/Makefile             |   2 +-
 arch/arm64/kvm/arm.c                |  24 +-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c  |   7 +-
 arch/arm64/kvm/id_regs.c            | 807 ++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c           | 469 +---------------
 arch/arm64/kvm/sys_regs.h           |  43 ++
 include/kvm/arm_pmu.h               |   5 +-
 10 files changed, 930 insertions(+), 502 deletions(-)
 create mode 100644 arch/arm64/kvm/id_regs.c


base-commit: 96a4627dbbd48144a65af936b321701c70876026
-- 
2.40.0.rc1.284.g88254d51c5-goog


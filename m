Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97DF7EF
	for <kvmarm@lists.linux.dev>; Tue, 28 Feb 2023 06:23:10 +0000 (UTC)
Received: by mail-pl1-f201.google.com with SMTP id k17-20020a170902d59100b0019abcf45d75so4738143plh.8
        for <kvmarm@lists.linux.dev>; Mon, 27 Feb 2023 22:23:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Z1r0WYjM0/VuU6mjjmazkwKNGOGVwqzV6mT22M8W4HM=;
        b=ZFNOO/o/ltYsu0BFmlqYaS8vPvFTGoTzsGcyXISkHPwECMTSRPdw4vUf8ovrkojsT/
         1k/Qjevt63qym/E8HT4vbrSCwnlY8O+vAfWuFeAYgzRjnRU9IhzniSfc5PtL3bRdnUB0
         QBU6bB0XXeM0x0bBPO7R6uZHOuiIzvUyTn3ty2BliT8MkTRhxkCXht63vLmk4FK+L7SX
         Gxu2ggr4pjuNw36sK22qjz45RJrlradUaXbtrxovt4ii0qcHwOV4bpErk9ERA6ItS/aZ
         UIf6PsxS4DlHWUZFjmw7t1zB9qFVOr4D6L2i4H2jWS5io/I1CE+Q/GXtKHcfBYbcnw/7
         /3fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Z1r0WYjM0/VuU6mjjmazkwKNGOGVwqzV6mT22M8W4HM=;
        b=srvS44z97qyXQjPGxIGkMipgS0V2obN67SHqouQrvuh6jTZUtKDZc6SHdvp0hBz+y+
         JT/0IRsyDRvNILS3l9cmNEmpPHJM2sOExSfjodDLkso95cI+7cE0Ew0wgbcTJW273D9f
         3oDKG4P2Ate6jKwkA8o583W9otHLypV4a7jjcrwtEQV0r+aWGpMepYOXJEHrp/HLIB1p
         sELQDlF/BOH3+VBhvCm9q/PUwIAuN6O0JKb/AeHVCaD0PElfHju04G7x3e9FSBIqPRKh
         kbcPx8J6n3bb3+pWiN1DrHuAerwLwP7W7WRMyM2P0LwFrJGBFnxIK01kRn2heFbzn7T2
         HMZg==
X-Gm-Message-State: AO0yUKUtCstWPImnOl3OQPFe5kYcCrKqVI0u5KxdwNG3hpc9cfBey0Zq
	UEnMySe9FGKqTgX8LuZBqPPyYipGD4IYUEw0zg==
X-Google-Smtp-Source: AK7set/Y8JQI650TtbbpqiexJqxUzV9QvzDrDlEdyJoNTnpnPtmzuwiT6BP+OQD0RdOWSAnNFehFE11GjFdSTnqsuQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:902:e8d0:b0:19b:da7:d8cb with SMTP
 id v16-20020a170902e8d000b0019b0da7d8cbmr537061plg.8.1677565389938; Mon, 27
 Feb 2023 22:23:09 -0800 (PST)
Date: Tue, 28 Feb 2023 06:22:40 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.2.722.g9855ee24e9-goog
Message-ID: <20230228062246.1222387-1-jingzhangos@google.com>
Subject: [PATCH v3 0/6] Support writable CPU ID registers from userspace
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
 arch/arm64/include/asm/kvm_host.h   |  26 +-
 arch/arm64/kernel/cpufeature.c      |  26 +-
 arch/arm64/kvm/Makefile             |   2 +-
 arch/arm64/kvm/arm.c                |  24 +-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c  |   7 +-
 arch/arm64/kvm/id_regs.c            | 801 ++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c           | 469 +---------------
 arch/arm64/kvm/sys_regs.h           |  43 ++
 include/kvm/arm_pmu.h               |   6 +-
 10 files changed, 927 insertions(+), 502 deletions(-)
 create mode 100644 arch/arm64/kvm/id_regs.c


base-commit: 96a4627dbbd48144a65af936b321701c70876026
-- 
2.39.2.722.g9855ee24e9-goog

